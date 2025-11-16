// lib/utils/sync_config.dart
import 'package:flutter/foundation.dart';

/// Configuration centralisée pour la synchronisation (STEP 4)
///
/// Cette classe centralise tous les paramètres de configuration pour la sync:
/// - Flags dev/test/production
/// - Politique de retry
/// - Politique de cleanup
/// - Validation officialID
///
/// IMPORTANT:
/// - En production: blockSyncIfNoOfficialId = TRUE (obligatoire pour conformité)
/// - En dev: autoriser sync sans officialID pour tests
class SyncConfig {
  // ==================== MODE EXECUTION ====================

  /// Mode développement = debug + test features enabled
  /// Utilise kDebugMode de Flutter (true en debug, false en release)
  static const bool isDevelopmentMode = kDebugMode;

  // ==================== FLAGS SYNC ====================

  /// 🔴 CRITIQUE: Bloquer sync si officialNumber vide
  ///
  /// Production: TRUE (OBLIGATOIRE pour conformité réglementaire UE)
  /// - Animal sans officialNumber = ERREUR de sync
  /// - User doit saisir officialNumber avant sync
  ///
  /// Dev: FALSE (permet test sans officialID réel)
  /// - Création animal sans officialNumber autorisée
  /// - Utile pour tests et développement
  static bool blockSyncIfNoOfficialId = !isDevelopmentMode;

  /// Activer/désactiver la sync globalement
  /// Peut être modifié dynamiquement via UI Settings
  static bool syncEnabled = true;

  /// 🤖 Mode mock serveur: simule sync sans appel réseau
  ///
  /// TRUE: Utilise MockSyncService (pas d'appel HTTP)
  /// FALSE: Utilise RealSyncService (appel HTTP au serveur)
  ///
  /// Dev: TRUE par défaut (tester sans serveur)
  /// Production: FALSE (sync réelle avec API)
  static bool mockServerMode = isDevelopmentMode;

  /// 🧪 Mode test: enregistre data mais ne sync pas réellement
  ///
  /// TRUE: Items ajoutés à queue mais jamais synchronisés
  /// FALSE: Items synchronisés normalement
  ///
  /// Utile pour tester la logique de queue sans sync réelle
  static bool testMode = false;

  // ==================== RETRY POLICY ====================

  /// Nombre maximum de tentatives avant échec définitif
  /// Après 3 échecs, l'item est marqué "stalled" (nécessite intervention)
  static const int maxRetries = 3;

  /// Délai initial entre tentatives (ms)
  /// Premier retry: 5 secondes
  static const int retryDelayMs = 5000;

  /// Multiplicateur pour backoff exponentiel
  /// Retry 1: 5s, Retry 2: 10s, Retry 3: 20s
  static const int retryBackoffMultiplier = 2;

  /// Délai maximum entre retries (ms)
  /// Plafond à 60 secondes même si backoff dépasse
  static const int maxRetryDelayMs = 60000;

  // ==================== CLEANUP POLICY ====================

  /// Nombre de jours avant cleanup des items synchronisés
  /// Items synced + > 30 jours = supprimés automatiquement
  static const int cleanupDaysOld = 30;

  /// Nettoyer automatiquement au démarrage de l'app
  /// TRUE: Cleanup à chaque ouverture de l'app
  /// FALSE: Cleanup manuel seulement (via Settings)
  static bool autoCleanup = true;

  /// Taille maximale de la queue (alerte si dépassé)
  /// Si queue > 5000 items = problème potentiel
  static const int maxQueueSize = 5000;

  // ==================== BATCH SYNC ====================

  /// Nombre maximum d'items à synchroniser par batch
  /// Évite de surcharger le serveur avec trop de requêtes simultanées
  static const int batchSize = 100;

  /// Délai entre deux batchs (ms)
  /// Après sync d'un batch, attendre 2 secondes avant le suivant
  static const int batchDelayMs = 2000;

  // ==================== DEBUG ====================

  /// Logs de debug activés
  /// TRUE: Affiche logs dans console
  /// FALSE: Pas de logs (production)
  static bool debugLogging = isDevelopmentMode;

  /// Afficher DebugSyncScreen en UI
  /// TRUE: FAB rouge visible pour accès rapide
  /// FALSE: DebugSyncScreen caché
  static bool debugShowSyncQueue = isDevelopmentMode;

  // ==================== HELPERS ====================

  /// Peut-on syncer sans officialID?
  ///
  /// TRUE si:
  /// - Mode développement ET
  /// - blockSyncIfNoOfficialId = FALSE
  ///
  /// Utilisé pour bypass validation en dev seulement
  static bool canSyncWithoutOfficialId() {
    return isDevelopmentMode && !blockSyncIfNoOfficialId;
  }

  /// Utiliser mock serveur?
  ///
  /// TRUE si:
  /// - Mode développement ET
  /// - mockServerMode = TRUE
  ///
  /// Permet tester sans serveur HTTP
  static bool shouldUseMockServer() {
    return isDevelopmentMode && mockServerMode;
  }

  /// Mode test actif?
  ///
  /// TRUE si testMode = TRUE
  /// Items en queue mais pas vrais synced
  static bool isTestMode() {
    return testMode;
  }

  /// Calculer le délai de retry selon le nombre de tentatives
  ///
  /// Backoff exponentiel:
  /// - Tentative 1: 5s (retryDelayMs)
  /// - Tentative 2: 10s (5 * 2)
  /// - Tentative 3: 20s (10 * 2)
  /// - Plafond: maxRetryDelayMs (60s)
  static int getRetryDelay(int retryCount) {
    if (retryCount <= 0) return retryDelayMs;

    int delay = retryDelayMs;
    for (int i = 0; i < retryCount; i++) {
      delay *= retryBackoffMultiplier;
    }

    // Appliquer plafond
    return delay > maxRetryDelayMs ? maxRetryDelayMs : delay;
  }

  /// Afficher configuration actuelle (debug)
  static void printConfig() {
    if (!debugLogging) return;

    print('════════════════════════════════════════');
    print('🔧 SYNC CONFIGURATION');
    print('════════════════════════════════════════');
    print('Mode: ${isDevelopmentMode ? "DEV" : "PRODUCTION"}');
    print('blockSyncIfNoOfficialId: $blockSyncIfNoOfficialId');
    print('syncEnabled: $syncEnabled');
    print('mockServerMode: $mockServerMode');
    print('testMode: $testMode');
    print('────────────────────────────────────────');
    print('Retry Policy:');
    print('  maxRetries: $maxRetries');
    print('  retryDelayMs: $retryDelayMs');
    print('  backoffMultiplier: $retryBackoffMultiplier');
    print('────────────────────────────────────────');
    print('Cleanup Policy:');
    print('  cleanupDaysOld: $cleanupDaysOld');
    print('  autoCleanup: $autoCleanup');
    print('  maxQueueSize: $maxQueueSize');
    print('════════════════════════════════════════');
  }
}
