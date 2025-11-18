// lib/services/sync/sync_api_client.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/sync_config.dart';
import 'sync_auth_service.dart';

/// Client API pour la synchronisation (STEP 5)
///
/// Gère les appels HTTP vers le backend avec :
/// - Authentification JWT automatique
/// - Gestion des erreurs
/// - Timeout configurable
/// - Support batch sync
class SyncApiClient {
  final SyncAuthService _authService;
  final http.Client _httpClient;

  SyncApiClient({
    required SyncAuthService authService,
    http.Client? httpClient,
  })  : _authService = authService,
        _httpClient = httpClient ?? http.Client();

  // ==================== SYNC OPERATIONS ====================

  /// Envoyer un batch d'items à synchroniser
  ///
  /// Retourne le résultat de la sync pour chaque item.
  Future<SyncBatchResponse> syncBatch(List<SyncBatchItem> items) async {
    final token = await _authService.getValidToken();
    if (token == null) {
      return SyncBatchResponse.authError('Not authenticated');
    }

    try {
      final response = await _httpClient.post(
        Uri.parse(SyncConfig.syncEndpoint),
        headers: _buildHeaders(token),
        body: jsonEncode({
          'items': items.map((i) => i.toJson()).toList(),
        }),
      ).timeout(
        Duration(seconds: SyncConfig.httpTimeoutSeconds),
      );

      return _handleBatchResponse(response);
    } catch (e) {
      SyncConfig.log('Sync batch error: $e');
      return SyncBatchResponse.networkError('Connection error: $e');
    }
  }

  /// Envoyer un item unique à synchroniser
  Future<SyncItemResponse> syncItem(SyncBatchItem item) async {
    final token = await _authService.getValidToken();
    if (token == null) {
      return SyncItemResponse.authError(item.entityId, 'Not authenticated');
    }

    try {
      final response = await _httpClient.post(
        Uri.parse(SyncConfig.syncEndpoint),
        headers: _buildHeaders(token),
        body: jsonEncode(item.toJson()),
      ).timeout(
        Duration(seconds: SyncConfig.httpTimeoutSeconds),
      );

      return _handleItemResponse(response, item.entityId);
    } catch (e) {
      SyncConfig.log('Sync item error: $e');
      return SyncItemResponse.networkError(item.entityId, 'Connection error: $e');
    }
  }

  // ==================== HELPERS ====================

  /// Construire les headers HTTP
  Map<String, String> _buildHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }

  /// Gérer la réponse d'un batch sync
  SyncBatchResponse _handleBatchResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        try {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          return SyncBatchResponse.fromJson(data);
        } catch (e) {
          return SyncBatchResponse.parseError('Invalid response format');
        }

      case 401:
        return SyncBatchResponse.authError('Authentication expired');

      case 403:
        return SyncBatchResponse.authError('Access denied');

      case 400:
        final error = _parseErrorMessage(response);
        return SyncBatchResponse.validationError(error);

      case 409:
        // Conflict - traité par le backend
        try {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          return SyncBatchResponse.fromJson(data);
        } catch (e) {
          return SyncBatchResponse.conflictError('Conflict detected');
        }

      case 500:
      case 502:
      case 503:
        return SyncBatchResponse.serverError('Server error: ${response.statusCode}');

      default:
        return SyncBatchResponse.serverError('HTTP ${response.statusCode}');
    }
  }

  /// Gérer la réponse d'un item sync
  SyncItemResponse _handleItemResponse(http.Response response, String entityId) {
    switch (response.statusCode) {
      case 200:
      case 201:
        try {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          return SyncItemResponse.success(
            entityId: entityId,
            serverVersion: data['serverVersion'] as int?,
            serverTimestamp: data['serverTimestamp'] != null
                ? DateTime.parse(data['serverTimestamp'] as String)
                : null,
          );
        } catch (e) {
          return SyncItemResponse.success(entityId: entityId);
        }

      case 401:
        return SyncItemResponse.authError(entityId, 'Authentication expired');

      case 403:
        return SyncItemResponse.authError(entityId, 'Access denied');

      case 400:
        final error = _parseErrorMessage(response);
        return SyncItemResponse.validationError(entityId, error);

      case 409:
        return SyncItemResponse.conflictError(entityId, 'Conflict detected');

      case 500:
      case 502:
      case 503:
        return SyncItemResponse.serverError(entityId, 'Server error: ${response.statusCode}');

      default:
        return SyncItemResponse.serverError(entityId, 'HTTP ${response.statusCode}');
    }
  }

  /// Parser le message d'erreur de la réponse
  String _parseErrorMessage(http.Response response) {
    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['message'] as String? ??
          data['error'] as String? ??
          'Unknown error';
    } catch (_) {
      return 'HTTP ${response.statusCode}';
    }
  }

  // ==================== CONNECTIVITY ====================

  /// Vérifier la connectivité avec le serveur
  Future<bool> checkConnectivity() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('${SyncConfig.apiBaseUrl}/health'),
      ).timeout(
        const Duration(seconds: 5),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

// ==================== DATA CLASSES ====================

/// Item à synchroniser dans un batch
class SyncBatchItem {
  final String farmId;
  final String entityType;
  final String entityId;
  final String action;
  final Map<String, dynamic> payload;
  final DateTime clientTimestamp;

  SyncBatchItem({
    required this.farmId,
    required this.entityType,
    required this.entityId,
    required this.action,
    required this.payload,
    required this.clientTimestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'farmId': farmId,
      'entityType': entityType,
      'entityId': entityId,
      'action': action,
      'payload': payload,
      'clientTimestamp': clientTimestamp.toIso8601String(),
    };
  }
}

/// Réponse d'un batch sync
class SyncBatchResponse {
  final bool isSuccess;
  final SyncErrorType? errorType;
  final String? errorMessage;
  final List<SyncItemResult> results;

  SyncBatchResponse._({
    required this.isSuccess,
    this.errorType,
    this.errorMessage,
    this.results = const [],
  });

  factory SyncBatchResponse.fromJson(Map<String, dynamic> json) {
    final results = (json['results'] as List<dynamic>?)
            ?.map((r) => SyncItemResult.fromJson(r as Map<String, dynamic>))
            .toList() ??
        [];

    return SyncBatchResponse._(
      isSuccess: json['success'] as bool? ?? true,
      results: results,
    );
  }

  factory SyncBatchResponse.authError(String message) {
    return SyncBatchResponse._(
      isSuccess: false,
      errorType: SyncErrorType.auth,
      errorMessage: message,
    );
  }

  factory SyncBatchResponse.networkError(String message) {
    return SyncBatchResponse._(
      isSuccess: false,
      errorType: SyncErrorType.network,
      errorMessage: message,
    );
  }

  factory SyncBatchResponse.serverError(String message) {
    return SyncBatchResponse._(
      isSuccess: false,
      errorType: SyncErrorType.server,
      errorMessage: message,
    );
  }

  factory SyncBatchResponse.validationError(String message) {
    return SyncBatchResponse._(
      isSuccess: false,
      errorType: SyncErrorType.validation,
      errorMessage: message,
    );
  }

  factory SyncBatchResponse.conflictError(String message) {
    return SyncBatchResponse._(
      isSuccess: false,
      errorType: SyncErrorType.conflict,
      errorMessage: message,
    );
  }

  factory SyncBatchResponse.parseError(String message) {
    return SyncBatchResponse._(
      isSuccess: false,
      errorType: SyncErrorType.parse,
      errorMessage: message,
    );
  }
}

/// Réponse d'un item sync individuel
class SyncItemResponse {
  final String entityId;
  final bool isSuccess;
  final SyncErrorType? errorType;
  final String? errorMessage;
  final int? serverVersion;
  final DateTime? serverTimestamp;

  SyncItemResponse._({
    required this.entityId,
    required this.isSuccess,
    this.errorType,
    this.errorMessage,
    this.serverVersion,
    this.serverTimestamp,
  });

  factory SyncItemResponse.success({
    required String entityId,
    int? serverVersion,
    DateTime? serverTimestamp,
  }) {
    return SyncItemResponse._(
      entityId: entityId,
      isSuccess: true,
      serverVersion: serverVersion,
      serverTimestamp: serverTimestamp,
    );
  }

  factory SyncItemResponse.authError(String entityId, String message) {
    return SyncItemResponse._(
      entityId: entityId,
      isSuccess: false,
      errorType: SyncErrorType.auth,
      errorMessage: message,
    );
  }

  factory SyncItemResponse.networkError(String entityId, String message) {
    return SyncItemResponse._(
      entityId: entityId,
      isSuccess: false,
      errorType: SyncErrorType.network,
      errorMessage: message,
    );
  }

  factory SyncItemResponse.serverError(String entityId, String message) {
    return SyncItemResponse._(
      entityId: entityId,
      isSuccess: false,
      errorType: SyncErrorType.server,
      errorMessage: message,
    );
  }

  factory SyncItemResponse.validationError(String entityId, String message) {
    return SyncItemResponse._(
      entityId: entityId,
      isSuccess: false,
      errorType: SyncErrorType.validation,
      errorMessage: message,
    );
  }

  factory SyncItemResponse.conflictError(String entityId, String message) {
    return SyncItemResponse._(
      entityId: entityId,
      isSuccess: false,
      errorType: SyncErrorType.conflict,
      errorMessage: message,
    );
  }
}

/// Résultat d'un item dans un batch
class SyncItemResult {
  final String entityId;
  final bool isSuccess;
  final String? errorMessage;
  final int? serverVersion;

  SyncItemResult({
    required this.entityId,
    required this.isSuccess,
    this.errorMessage,
    this.serverVersion,
  });

  factory SyncItemResult.fromJson(Map<String, dynamic> json) {
    return SyncItemResult(
      entityId: json['entityId'] as String,
      isSuccess: json['success'] as bool? ?? true,
      errorMessage: json['error'] as String?,
      serverVersion: json['serverVersion'] as int?,
    );
  }
}

/// Types d'erreurs de synchronisation
enum SyncErrorType {
  auth,       // Erreur d'authentification (401, 403)
  network,    // Erreur réseau (timeout, connexion)
  server,     // Erreur serveur (5xx)
  validation, // Erreur de validation (400)
  conflict,   // Conflit de version (409)
  parse,      // Erreur de parsing de la réponse
}
