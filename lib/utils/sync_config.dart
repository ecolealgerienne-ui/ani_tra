// lib/utils/sync_config.dart

import 'package:flutter/foundation.dart';
import 'constants.dart';

/// Configuration centralisée pour la synchronisation (STEP 4)
///
/// Centralise tous les paramètres de configuration pour la sync:
/// - Flags activation/désactivation
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

  /// Bloquer sync si officialNumber vide
  /// Production: true (obligatoire conformité UE)
  /// Développement: false (permet tests)
  static bool blockSyncIfNoOfficialId = !isDevelopmentMode;

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

  // ==================== DEBUG ====================

  /// Logs de debug activés
  static bool debugLogging = isDevelopmentMode;

  // ==================== HELPERS ====================

  /// Vérifier si sync est activée
  static bool isSyncEnabled() {
    return syncEnabled;
  }

  /// Activer ou désactiver la synchronisation
  static void setSyncEnabled(bool value) {
    syncEnabled = value;
    if (debugLogging) {
      debugPrint('[SYNC] Sync ${value ? 'enabled' : 'disabled'}');
    }
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
