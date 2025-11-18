// lib/utils/sync_config.dart

import 'package:flutter/foundation.dart';
import 'constants.dart';

/// Configuration centralisée pour la synchronisation (STEP 4 & 5)
///
/// Centralise tous les paramètres de configuration pour la sync:
/// - Flags activation/désactivation
/// - Configuration API backend
/// - Configuration Keycloak (authentification)
/// - Validation officialID
/// - Politique de retry
/// - Politique de cleanup
class SyncConfig {
  // ==================== MODE EXECUTION ====================

  /// Mode développement (kDebugMode de Flutter)
  static const bool isDevelopmentMode = kDebugMode;

  // ==================== FLAGS SYNC ====================

  /// Activer/désactiver la synchronisation globalement
  /// Par défaut: DÉSACTIVÉ (false)
  /// Pour activer: changer à true
  static bool syncEnabled = false;

  /// Activer/désactiver le service de synchronisation (STEP 5)
  /// Quand false, les items sont enqueued mais pas envoyés au serveur
  static bool syncServiceEnabled = false;

  /// Bloquer sync si officialNumber vide
  /// Production: true (obligatoire conformité UE)
  /// Développement: false (permet tests)
  static bool blockSyncIfNoOfficialId = !isDevelopmentMode;

  // ==================== API BACKEND ====================

  /// URL de base de l'API backend
  /// Exemple: 'https://api.animal-trace.com'
  static String apiBaseUrl = 'https://api.example.com';

  /// Version de l'API
  static String apiVersion = SyncApiConstants.defaultApiVersion;

  /// Timeout des requêtes HTTP (secondes)
  static int httpTimeoutSeconds = SyncApiConstants.httpTimeoutSeconds;

  /// Activer le certificate pinning (recommandé en production)
  static bool enableCertificatePinning = !isDevelopmentMode;

  /// Endpoint de synchronisation
  static String get syncEndpoint => '$apiBaseUrl/api/$apiVersion/sync';

  // ==================== KEYCLOAK AUTH ====================

  /// URL du serveur Keycloak
  /// Exemple: 'https://auth.animal-trace.com'
  static String keycloakUrl = 'https://auth.example.com';

  /// Nom du realm Keycloak
  static String keycloakRealm = 'animal-trace';

  /// Client ID de l'application mobile
  static String keycloakClientId = 'mobile-app';

  /// Client secret (optionnel, selon config Keycloak)
  static String? keycloakClientSecret;

  /// URL complète du token endpoint
  static String get keycloakTokenEndpoint =>
      '$keycloakUrl/realms/$keycloakRealm/protocol/openid-connect/token';

  /// URL complète du logout endpoint
  static String get keycloakLogoutEndpoint =>
      '$keycloakUrl/realms/$keycloakRealm/protocol/openid-connect/logout';

  // ==================== RETRY POLICY ====================

  /// Nombre max de tentatives avant échec
  static int get maxRetries => SyncRetryPolicy.maxRetries;

  /// Délai initial entre tentatives (ms)
  static int get retryDelayMs => SyncRetryPolicy.initialDelayMs;

  /// Multiplicateur backoff exponentiel
  static int get retryBackoffMultiplier => SyncRetryPolicy.backoffMultiplier;

  /// Délai max entre tentatives (ms)
  static int get maxDelayMs => SyncRetryPolicy.maxDelayMs;

  // ==================== CLEANUP POLICY ====================

  /// Supprimer items synchronisés après N jours
  static int get cleanupDaysOld => SyncConstants.cleanupDaysOld;

  /// Nettoyer automatiquement au démarrage
  static bool autoCleanup = false;

  // ==================== BATCH SYNC ====================

  /// Nombre max d'items par batch
  static int batchSize = SyncApiConstants.batchSize;

  /// Sync automatique au démarrage de l'app
  static bool autoSyncOnStartup = false;

  /// Intervalle de sync automatique (minutes, 0 = désactivé)
  static int autoSyncIntervalMinutes = 0;

  // ==================== DEBUG ====================

  /// Logs de debug activés
  static bool debugLogging = isDevelopmentMode;

  // ==================== HELPERS ====================

  /// Vérifier si sync est activée
  static bool isSyncEnabled() {
    return syncEnabled;
  }

  /// Vérifier si le service sync est activé
  static bool isSyncServiceEnabled() {
    return syncServiceEnabled && syncEnabled;
  }

  /// Activer ou désactiver la synchronisation
  static void setSyncEnabled(bool value) {
    syncEnabled = value;
    if (debugLogging) {
      debugPrint('[SYNC] Sync ${value ? 'enabled' : 'disabled'}');
    }
  }

  /// Activer ou désactiver le service de synchronisation
  static void setSyncServiceEnabled(bool value) {
    syncServiceEnabled = value;
    if (debugLogging) {
      debugPrint('[SYNC] Sync service ${value ? 'enabled' : 'disabled'}');
    }
  }

  /// Configurer l'API backend
  static void configureApi({
    required String baseUrl,
    String version = 'v1',
    int timeoutSeconds = 30,
  }) {
    apiBaseUrl = baseUrl;
    apiVersion = version;
    httpTimeoutSeconds = timeoutSeconds;
    log('API configured: $syncEndpoint');
  }

  /// Configurer Keycloak
  static void configureKeycloak({
    required String url,
    required String realm,
    required String clientId,
    String? clientSecret,
  }) {
    keycloakUrl = url;
    keycloakRealm = realm;
    keycloakClientId = clientId;
    keycloakClientSecret = clientSecret;
    log('Keycloak configured: $keycloakTokenEndpoint');
  }

  /// Peut-on syncer sans officialID?
  static bool canSyncWithoutOfficialId() {
    return isDevelopmentMode && !blockSyncIfNoOfficialId;
  }

  /// Calculer le délai pour une tentative donnée (backoff exponentiel)
  static int getRetryDelay(int attemptNumber) {
    if (attemptNumber <= 0) return retryDelayMs;

    int delay = retryDelayMs;
    for (int i = 0; i < attemptNumber; i++) {
      delay *= retryBackoffMultiplier;
      if (delay > maxDelayMs) {
        delay = maxDelayMs;
        break;
      }
    }
    return delay;
  }

  /// Log de debug si activé
  static void log(String message) {
    if (debugLogging) {
      debugPrint('[SYNC] $message');
    }
  }
}
