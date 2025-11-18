// lib/services/sync/sync_auth_service.dart

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../utils/sync_config.dart';

/// Service d'authentification Keycloak pour la synchronisation (STEP 5)
///
/// Gère :
/// - Authentification via Keycloak (OAuth2 Password Grant)
/// - Stockage sécurisé des tokens
/// - Refresh automatique des tokens expirés
/// - Logout et nettoyage
class SyncAuthService {
  final FlutterSecureStorage _secureStorage;
  final http.Client _httpClient;

  // Clés de stockage
  static const String _accessTokenKey = 'sync_access_token';
  static const String _refreshTokenKey = 'sync_refresh_token';
  static const String _tokenExpiryKey = 'sync_token_expiry';

  // Cache en mémoire
  String? _accessToken;
  String? _refreshToken;
  DateTime? _tokenExpiry;

  SyncAuthService({
    FlutterSecureStorage? secureStorage,
    http.Client? httpClient,
  })  : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        _httpClient = httpClient ?? http.Client();

  // ==================== AUTHENTIFICATION ====================

  /// Authentifier l'utilisateur via Keycloak
  ///
  /// Utilise OAuth2 Resource Owner Password Credentials Grant.
  /// Stocke les tokens de manière sécurisée.
  Future<AuthResult> authenticate({
    required String username,
    required String password,
  }) async {
    try {
      SyncConfig.log('Authenticating user: $username');

      final response = await _httpClient.post(
        Uri.parse(SyncConfig.keycloakTokenEndpoint),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'password',
          'client_id': SyncConfig.keycloakClientId,
          if (SyncConfig.keycloakClientSecret != null)
            'client_secret': SyncConfig.keycloakClientSecret!,
          'username': username,
          'password': password,
        },
      ).timeout(
        Duration(seconds: SyncConfig.httpTimeoutSeconds),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        await _storeTokens(data);
        SyncConfig.log('Authentication successful');
        return AuthResult.success();
      } else {
        final error = _parseError(response);
        SyncConfig.log('Authentication failed: $error');
        return AuthResult.failure(error);
      }
    } catch (e) {
      SyncConfig.log('Authentication error: $e');
      return AuthResult.failure('Connection error: $e');
    }
  }

  /// Obtenir un token valide (refresh automatique si nécessaire)
  ///
  /// Retourne null si non authentifié ou refresh échoué.
  Future<String?> getValidToken() async {
    // Charger depuis le stockage si pas en cache
    if (_accessToken == null) {
      await _loadTokens();
    }

    // Pas de token
    if (_accessToken == null) {
      return null;
    }

    // Token valide
    if (_tokenExpiry != null && _tokenExpiry!.isAfter(DateTime.now())) {
      return _accessToken;
    }

    // Token expiré - tenter refresh
    SyncConfig.log('Token expired, attempting refresh');
    final refreshed = await _refreshAccessToken();
    return refreshed ? _accessToken : null;
  }

  /// Vérifier si l'utilisateur est authentifié
  Future<bool> isAuthenticated() async {
    final token = await getValidToken();
    return token != null;
  }

  /// Déconnecter l'utilisateur
  Future<void> logout() async {
    try {
      // Notifier Keycloak (optionnel)
      if (_refreshToken != null) {
        await _httpClient.post(
          Uri.parse(SyncConfig.keycloakLogoutEndpoint),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {
            'client_id': SyncConfig.keycloakClientId,
            if (SyncConfig.keycloakClientSecret != null)
              'client_secret': SyncConfig.keycloakClientSecret!,
            'refresh_token': _refreshToken!,
          },
        ).timeout(
          Duration(seconds: SyncConfig.httpTimeoutSeconds),
        );
      }
    } catch (e) {
      SyncConfig.log('Logout notification failed: $e');
    }

    // Nettoyer tokens locaux
    await clearTokens();
    SyncConfig.log('Logout completed');
  }

  /// Effacer tous les tokens stockés
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    _tokenExpiry = null;

    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _secureStorage.delete(key: _tokenExpiryKey);
  }

  // ==================== TOKEN MANAGEMENT ====================

  /// Stocker les tokens depuis la réponse Keycloak
  Future<void> _storeTokens(Map<String, dynamic> data) async {
    _accessToken = data['access_token'] as String;
    _refreshToken = data['refresh_token'] as String?;

    // Calculer l'expiration (avec marge de 60 secondes)
    final expiresIn = data['expires_in'] as int? ?? 300;
    _tokenExpiry = DateTime.now().add(
      Duration(seconds: expiresIn - 60),
    );

    // Stocker de manière sécurisée
    await _secureStorage.write(key: _accessTokenKey, value: _accessToken);
    if (_refreshToken != null) {
      await _secureStorage.write(key: _refreshTokenKey, value: _refreshToken);
    }
    await _secureStorage.write(
      key: _tokenExpiryKey,
      value: _tokenExpiry!.toIso8601String(),
    );
  }

  /// Charger les tokens depuis le stockage sécurisé
  Future<void> _loadTokens() async {
    _accessToken = await _secureStorage.read(key: _accessTokenKey);
    _refreshToken = await _secureStorage.read(key: _refreshTokenKey);

    final expiryStr = await _secureStorage.read(key: _tokenExpiryKey);
    if (expiryStr != null) {
      _tokenExpiry = DateTime.tryParse(expiryStr);
    }
  }

  /// Rafraîchir le token d'accès
  Future<bool> _refreshAccessToken() async {
    if (_refreshToken == null) {
      SyncConfig.log('No refresh token available');
      return false;
    }

    try {
      final response = await _httpClient.post(
        Uri.parse(SyncConfig.keycloakTokenEndpoint),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'refresh_token',
          'client_id': SyncConfig.keycloakClientId,
          if (SyncConfig.keycloakClientSecret != null)
            'client_secret': SyncConfig.keycloakClientSecret!,
          'refresh_token': _refreshToken!,
        },
      ).timeout(
        Duration(seconds: SyncConfig.httpTimeoutSeconds),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        await _storeTokens(data);
        SyncConfig.log('Token refresh successful');
        return true;
      } else {
        SyncConfig.log('Token refresh failed: ${response.statusCode}');
        await clearTokens();
        return false;
      }
    } catch (e) {
      SyncConfig.log('Token refresh error: $e');
      return false;
    }
  }

  /// Parser l'erreur de la réponse Keycloak
  String _parseError(http.Response response) {
    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['error_description'] as String? ??
          data['error'] as String? ??
          'Unknown error';
    } catch (_) {
      return 'HTTP ${response.statusCode}';
    }
  }

  // ==================== TOKEN INFO ====================

  /// Obtenir les informations du token (décodage JWT)
  Map<String, dynamic>? getTokenInfo() {
    if (_accessToken == null) return null;

    try {
      // Décoder le payload JWT (partie 2)
      final parts = _accessToken!.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      // Ajouter padding si nécessaire
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (e) {
      SyncConfig.log('Error decoding JWT: $e');
      return null;
    }
  }

  /// Obtenir l'ID de l'utilisateur depuis le token
  String? getUserId() {
    final info = getTokenInfo();
    return info?['sub'] as String?;
  }

  /// Obtenir l'email de l'utilisateur depuis le token
  String? getUserEmail() {
    final info = getTokenInfo();
    return info?['email'] as String?;
  }

  /// Obtenir les rôles de l'utilisateur depuis le token
  List<String> getUserRoles() {
    final info = getTokenInfo();
    if (info == null) return [];

    // Keycloak stocke les rôles dans realm_access.roles
    final realmAccess = info['realm_access'] as Map<String, dynamic>?;
    if (realmAccess == null) return [];

    final roles = realmAccess['roles'] as List<dynamic>?;
    return roles?.cast<String>() ?? [];
  }
}

/// Résultat d'une tentative d'authentification
class AuthResult {
  final bool isSuccess;
  final String? errorMessage;

  AuthResult._({
    required this.isSuccess,
    this.errorMessage,
  });

  factory AuthResult.success() {
    return AuthResult._(isSuccess: true);
  }

  factory AuthResult.failure(String message) {
    return AuthResult._(isSuccess: false, errorMessage: message);
  }
}
