// lib/services/mock_sync_service.dart
import '../drift/database.dart';
import '../repositories/sync_queue_repository.dart';
import '../utils/sync_config.dart';

/// Service pour simuler le serveur en mode dev/test (STEP 4)
///
/// Ce service permet de tester toute la logique de synchronisation
/// SANS avoir besoin d'un serveur HTTP réel:
/// - Simuler sync réussie (marquer items comme synced)
/// - Simuler sync échouée (incrémenter retries)
/// - Inspecter la queue
/// - Tester la logique de retry et cleanup
///
/// IMPORTANT:
/// - Seulement utilisable si SyncConfig.mockServerMode = true
/// - Ne fait aucun appel HTTP
/// - Utile pour développement et tests
class MockSyncService {
  final AppDatabase _db;
  late final SyncQueueRepository _syncQueueRepo;

  MockSyncService(this._db) {
    _syncQueueRepo = SyncQueueRepository(_db);
  }

  // ==================== SIMULATION SYNC ====================

  /// Simuler une synchronisation réussie
  ///
  /// Parcourt tous les items pending et les marque comme synced.
  /// Simule un délai réseau pour chaque item (100ms).
  ///
  /// Workflow:
  /// 1. Récupérer items pending
  /// 2. Pour chaque item:
  ///    - Attendre 100ms (simuler réseau)
  ///    - Marquer comme synced
  /// 3. Retourner nombre d'items synchronisés
  ///
  /// Retourne: nombre d'items synchronisés
  Future<int> simulateSuccessfulSync(String farmId) async {
    if (!SyncConfig.mockServerMode) {
      throw Exception('❌ Mock server mode not enabled! '
          'Set SyncConfig.mockServerMode = true');
    }

    print('🤖 [MOCK] Starting successful sync simulation...');

    final pending = await _syncQueueRepo.getPendingForSync(farmId);

    if (pending.isEmpty) {
      print('🤖 [MOCK] Aucun item à synchroniser');
      return 0;
    }

    int syncedCount = 0;

    // Simuler sync pour chaque item
    for (int i = 0; i < pending.length; i++) {
      final item = pending[i];

      // Simuler délai réseau (100ms)
      await Future.delayed(const Duration(milliseconds: 100));

      // Marquer comme synchronisé
      await _syncQueueRepo.markSynced(item.id, farmId);
      syncedCount++;

      if (SyncConfig.debugLogging) {
        print('  ✅ [$i/${pending.length}] Synced: '
            '${item.entityType}:${item.entityId}');
      }
    }

    print('🤖 [MOCK] Sync completed! $syncedCount items synchronisés');

    return syncedCount;
  }

  /// Simuler une synchronisation échouée
  ///
  /// Parcourt tous les items pending et incrémente leur retry count.
  /// Utile pour tester la logique de retry et les items "stalled".
  ///
  /// Paramètres:
  /// - farmId: ID de la ferme
  /// - errorMessage: Message d'erreur à stocker
  ///
  /// Retourne: nombre d'items pour lesquels retry a été incrémenté
  Future<int> simulateFailedSync(
    String farmId,
    String errorMessage,
  ) async {
    if (!SyncConfig.mockServerMode) {
      throw Exception('❌ Mock server mode not enabled!');
    }

    print('🤖 [MOCK] Starting FAILED sync simulation: $errorMessage');

    final pending = await _syncQueueRepo.getPendingForSync(farmId);

    if (pending.isEmpty) {
      print('🤖 [MOCK] Aucun item à échouer');
      return 0;
    }

    int failedCount = 0;

    // Simuler échec pour chaque item
    for (int i = 0; i < pending.length; i++) {
      final item = pending[i];

      // Simuler délai réseau plus court (50ms)
      await Future.delayed(const Duration(milliseconds: 50));

      // Incrémenter retry
      await _syncQueueRepo.recordRetry(item.id, farmId, errorMessage);
      failedCount++;

      if (SyncConfig.debugLogging) {
        print('  ⚠️  [$i/${pending.length}] Retry ${item.retryCount + 1}: '
            '${item.entityType}:${item.entityId}');
      }
    }

    print('🤖 [MOCK] Failed sync completed! $failedCount retries incrémentés');

    return failedCount;
  }

  /// Simuler sync partielle (certains réussis, certains échoués)
  ///
  /// Permet de tester un scenario réaliste où certains items
  /// se synchronisent correctement et d'autres échouent.
  ///
  /// Paramètres:
  /// - farmId: ID de la ferme
  /// - successRate: Taux de réussite (0.0 à 1.0)
  ///   Exemple: 0.7 = 70% de réussite, 30% d'échec
  /// - errorMessage: Message d'erreur pour les échecs
  ///
  /// Retourne: Map avec 'success' et 'failed' counts
  Future<Map<String, int>> simulatePartialSync(
    String farmId, {
    double successRate = 0.7,
    String errorMessage = 'Erreur partielle de simulation',
  }) async {
    if (!SyncConfig.mockServerMode) {
      throw Exception('❌ Mock server mode not enabled!');
    }

    if (successRate < 0.0 || successRate > 1.0) {
      throw ArgumentError('successRate doit être entre 0.0 et 1.0');
    }

    print('🤖 [MOCK] Starting partial sync (${(successRate * 100).toInt()}% success)...');

    final pending = await _syncQueueRepo.getPendingForSync(farmId);

    if (pending.isEmpty) {
      print('🤖 [MOCK] Aucun item à synchroniser');
      return {'success': 0, 'failed': 0};
    }

    int successCount = 0;
    int failedCount = 0;

    for (int i = 0; i < pending.length; i++) {
      final item = pending[i];

      // Simuler délai réseau
      await Future.delayed(const Duration(milliseconds: 100));

      // Décider succès ou échec selon le taux
      final shouldSucceed = (i / pending.length) < successRate;

      if (shouldSucceed) {
        await _syncQueueRepo.markSynced(item.id, farmId);
        successCount++;
        if (SyncConfig.debugLogging) {
          print('  ✅ [$i/${pending.length}] Synced: ${item.entityType}:${item.entityId}');
        }
      } else {
        await _syncQueueRepo.recordRetry(item.id, farmId, errorMessage);
        failedCount++;
        if (SyncConfig.debugLogging) {
          print('  ⚠️  [$i/${pending.length}] Failed: ${item.entityType}:${item.entityId}');
        }
      }
    }

    print('🤖 [MOCK] Partial sync completed! '
        'Success: $successCount, Failed: $failedCount');

    return {
      'success': successCount,
      'failed': failedCount,
    };
  }

  // ==================== INSPECTION & DEBUG ====================

  /// Inspecter la queue (afficher dans console)
  ///
  /// Délègue à SyncQueueRepository.inspectQueue()
  Future<void> inspectQueue(String farmId) async {
    await _syncQueueRepo.inspectQueue(farmId);
  }

  /// Obtenir statistiques de la queue
  ///
  /// Retourne Map avec:
  /// - pending: nombre d'items en attente
  /// - synced: nombre d'items synchronisés
  /// - stalled: nombre d'items bloqués (max retries atteint)
  Future<Map<String, int>> getQueueStats(String farmId) async {
    final pending = await _syncQueueRepo.countPending(farmId);
    final synced = await _syncQueueRepo.countSynced(farmId);
    final stalled = await _syncQueueRepo.getStalledItems(farmId);

    return {
      'pending': pending,
      'synced': synced,
      'stalled': stalled.length,
    };
  }

  // ==================== SCENARIOS DE TEST ====================

  /// Simuler comportement serveur personnalisé
  ///
  /// Permet de tester des scénarios spécifiques avec contrôle fin:
  /// - Délai réseau variable
  /// - Taux de succès
  /// - Messages d'erreur custom
  ///
  /// Paramètres:
  /// - farmId: ID de la ferme
  /// - shouldSucceed: Si true, sync réussie; si false, sync échouée
  /// - delayMs: Délai de simulation en millisecondes
  /// - errorMessage: Message d'erreur si échec (optionnel)
  ///
  /// Retourne: nombre d'items traités
  Future<int> simulateCustomBehavior({
    required String farmId,
    required bool shouldSucceed,
    required int delayMs,
    String? errorMessage,
  }) async {
    if (!SyncConfig.mockServerMode) {
      throw Exception('❌ Mock server mode not enabled!');
    }

    print('🤖 [MOCK] Custom behavior:');
    print('  Should succeed: $shouldSucceed');
    print('  Delay: ${delayMs}ms');

    await Future.delayed(Duration(milliseconds: delayMs));

    if (shouldSucceed) {
      return await simulateSuccessfulSync(farmId);
    } else {
      return await simulateFailedSync(
        farmId,
        errorMessage ?? 'Custom error',
      );
    }
  }

  /// Tester le workflow complet de retry
  ///
  /// Simule plusieurs tentatives échouées suivies d'une réussite:
  /// 1. Échouer N fois (incrémenter retries)
  /// 2. Réussir la dernière fois (marquer synced)
  ///
  /// Paramètres:
  /// - farmId: ID de la ferme
  /// - failureCount: Nombre d'échecs avant réussite
  ///
  /// Retourne: nombre d'items synchronisés finalement
  Future<int> simulateRetryWorkflow(
    String farmId, {
    int failureCount = 2,
  }) async {
    print('🤖 [MOCK] Testing retry workflow ($failureCount failures)...');

    // Échouer N fois
    for (int i = 0; i < failureCount; i++) {
      print('  Attempt ${i + 1}: Simulating failure...');
      await simulateFailedSync(farmId, 'Retry test #${i + 1}');

      // Délai entre retries
      await Future.delayed(const Duration(milliseconds: 500));
    }

    // Réussir la dernière fois
    print('  Final attempt: Simulating success...');
    final synced = await simulateSuccessfulSync(farmId);

    print('🤖 [MOCK] Retry workflow completed! $synced items synced après $failureCount échecs');

    return synced;
  }

  /// Simuler timeout réseau
  ///
  /// Simule un timeout en attendant longtemps puis échouant
  Future<int> simulateTimeout(
    String farmId, {
    int timeoutMs = 5000,
  }) async {
    print('🤖 [MOCK] Simulating network timeout ($timeoutMs ms)...');

    await Future.delayed(Duration(milliseconds: timeoutMs));

    return await simulateFailedSync(farmId, 'Network timeout');
  }

  /// Simuler problème serveur intermittent
  ///
  /// Alterne entre succès et échec pour chaque item
  Future<Map<String, int>> simulateIntermittentIssue(String farmId) async {
    print('🤖 [MOCK] Simulating intermittent server issues...');

    final pending = await _syncQueueRepo.getPendingForSync(farmId);
    int successCount = 0;
    int failedCount = 0;

    for (int i = 0; i < pending.length; i++) {
      final item = pending[i];
      final shouldSucceed = i % 2 == 0; // Alterner

      await Future.delayed(const Duration(milliseconds: 100));

      if (shouldSucceed) {
        await _syncQueueRepo.markSynced(item.id, farmId);
        successCount++;
      } else {
        await _syncQueueRepo.recordRetry(item.id, farmId, 'Intermittent error');
        failedCount++;
      }
    }

    print('🤖 [MOCK] Intermittent sync completed! '
        'Success: $successCount, Failed: $failedCount');

    return {
      'success': successCount,
      'failed': failedCount,
    };
  }
}
