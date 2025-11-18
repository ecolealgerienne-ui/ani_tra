// lib/services/sync/sync_service.dart

import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import '../../drift/database.dart';
import '../../repositories/sync_queue_repository.dart';
import '../../utils/sync_config.dart';
import 'sync_api_client.dart';
import 'sync_auth_service.dart';

/// Service principal de synchronisation (STEP 5)
///
/// Orchestre la synchronisation des données entre l'app et le backend :
/// - Traitement de la queue de sync
/// - Gestion des retries avec backoff exponentiel
/// - Support batch et item par item
/// - Statistiques et monitoring
class SyncService {
  final AppDatabase _db;
  final SyncQueueRepository _syncQueueRepo;
  final SyncAuthService _authService;
  final SyncApiClient _apiClient;
  final Connectivity _connectivity;

  // État
  bool _isSyncing = false;
  SyncStatus _lastStatus = SyncStatus.idle;

  SyncService({
    required AppDatabase database,
    SyncAuthService? authService,
    SyncApiClient? apiClient,
    Connectivity? connectivity,
  })  : _db = database,
        _syncQueueRepo = SyncQueueRepository(database),
        _authService = authService ?? SyncAuthService(),
        _apiClient = apiClient ?? SyncApiClient(authService: authService ?? SyncAuthService()),
        _connectivity = connectivity ?? Connectivity();

  // ==================== GETTERS ====================

  /// Est-ce que la sync est en cours ?
  bool get isSyncing => _isSyncing;

  /// Dernier statut de sync
  SyncStatus get lastStatus => _lastStatus;

  /// Service d'authentification
  SyncAuthService get authService => _authService;

  // ==================== SYNC OPERATIONS ====================

  /// Traiter la queue de synchronisation pour une ferme
  ///
  /// Retourne le résultat de la synchronisation.
  Future<SyncResult> processQueue(String farmId) async {
    // Vérifier si le service est activé
    if (!SyncConfig.isSyncServiceEnabled()) {
      SyncConfig.log('Sync service disabled - skipping');
      return SyncResult.disabled();
    }

    // Éviter les syncs simultanées
    if (_isSyncing) {
      SyncConfig.log('Sync already in progress - skipping');
      return SyncResult.alreadyRunning();
    }

    _isSyncing = true;
    _lastStatus = SyncStatus.syncing;

    try {
      // Vérifier la connectivité
      final connectivityResults = await _connectivity.checkConnectivity();
      if (connectivityResults.contains(ConnectivityResult.none) ||
          connectivityResults.isEmpty) {
        SyncConfig.log('No network connectivity');
        _lastStatus = SyncStatus.noNetwork;
        return SyncResult.noNetwork();
      }

      // Vérifier l'authentification
      final isAuthenticated = await _authService.isAuthenticated();
      if (!isAuthenticated) {
        SyncConfig.log('Not authenticated');
        _lastStatus = SyncStatus.authRequired;
        return SyncResult.authRequired();
      }

      // Récupérer les items pending
      final pendingItems = await _syncQueueRepo.getPending(farmId);
      if (pendingItems.isEmpty) {
        SyncConfig.log('No pending items to sync');
        _lastStatus = SyncStatus.idle;
        return SyncResult.nothingToSync();
      }

      SyncConfig.log('Processing ${pendingItems.length} pending items');

      // Traiter en batch ou item par item selon la config
      final result = SyncConfig.batchSize > 1
          ? await _processBatch(farmId, pendingItems)
          : await _processOneByOne(farmId, pendingItems);

      _lastStatus = result.hasErrors ? SyncStatus.partialSuccess : SyncStatus.success;
      return result;

    } catch (e, stackTrace) {
      SyncConfig.log('Error processing queue: $e');
      if (SyncConfig.debugLogging) {
        debugPrint('❌ [SYNC] StackTrace: $stackTrace');
      }
      _lastStatus = SyncStatus.error;
      return SyncResult.error('Sync error: $e');
    } finally {
      _isSyncing = false;
    }
  }

  /// Traiter les items en batch
  Future<SyncResult> _processBatch(
    String farmId,
    List<SyncQueueTableData> items,
  ) async {
    int synced = 0;
    int failed = 0;
    final errors = <String>[];

    // Diviser en batches
    for (var i = 0; i < items.length; i += SyncConfig.batchSize) {
      final batchEnd = (i + SyncConfig.batchSize < items.length)
          ? i + SyncConfig.batchSize
          : items.length;
      final batch = items.sublist(i, batchEnd);

      // Convertir en SyncBatchItem
      final batchItems = batch.map((item) => _toBatchItem(item)).toList();

      // Envoyer le batch
      final response = await _apiClient.syncBatch(batchItems);

      if (response.isSuccess) {
        // Traiter les résultats individuels
        for (final result in response.results) {
          if (result.isSuccess) {
            await _syncQueueRepo.markSynced(result.entityId, farmId);
            synced++;
          } else {
            await _handleItemError(
              result.entityId,
              farmId,
              result.errorMessage ?? 'Unknown error',
            );
            failed++;
            errors.add('${result.entityId}: ${result.errorMessage}');
          }
        }
      } else {
        // Erreur sur tout le batch
        if (response.errorType == SyncErrorType.auth) {
          return SyncResult.authRequired();
        }

        // Marquer tous les items comme échoués
        for (final item in batch) {
          await _handleItemError(
            item.entityId,
            farmId,
            response.errorMessage ?? 'Batch error',
          );
          failed++;
        }
        errors.add('Batch error: ${response.errorMessage}');
      }
    }

    SyncConfig.log('Batch sync completed: $synced synced, $failed failed');
    return SyncResult(
      syncedCount: synced,
      failedCount: failed,
      errors: errors,
    );
  }

  /// Traiter les items un par un
  Future<SyncResult> _processOneByOne(
    String farmId,
    List<SyncQueueTableData> items,
  ) async {
    int synced = 0;
    int failed = 0;
    final errors = <String>[];

    for (final item in items) {
      // Vérifier si l'item n'est pas en stalled
      if (item.retryCount >= SyncConfig.maxRetries) {
        SyncConfig.log('Skipping stalled item: ${item.entityId}');
        continue;
      }

      final batchItem = _toBatchItem(item);
      final response = await _apiClient.syncItem(batchItem);

      if (response.isSuccess) {
        await _syncQueueRepo.markSynced(item.id, farmId);
        synced++;
        SyncConfig.log('Synced: ${item.entityType}:${item.entityId}');
      } else {
        await _handleItemError(
          item.id,
          farmId,
          response.errorMessage ?? 'Unknown error',
        );
        failed++;
        errors.add('${item.entityId}: ${response.errorMessage}');
        SyncConfig.log('Failed: ${item.entityType}:${item.entityId} - ${response.errorMessage}');

        // Si erreur d'auth, arrêter la sync
        if (response.errorType == SyncErrorType.auth) {
          return SyncResult.authRequired();
        }
      }
    }

    SyncConfig.log('Sync completed: $synced synced, $failed failed');
    return SyncResult(
      syncedCount: synced,
      failedCount: failed,
      errors: errors,
    );
  }

  /// Convertir un item de la queue en SyncBatchItem
  SyncBatchItem _toBatchItem(SyncQueueTableData item) {
    final payloadStr = utf8.decode(item.payload);
    final payload = jsonDecode(payloadStr) as Map<String, dynamic>;

    return SyncBatchItem(
      farmId: item.farmId,
      entityType: item.entityType,
      entityId: item.entityId,
      action: item.action,
      payload: payload,
      clientTimestamp: item.createdAt,
    );
  }

  /// Gérer une erreur sur un item
  Future<void> _handleItemError(
    String itemId,
    String farmId,
    String error,
  ) async {
    await _syncQueueRepo.incrementRetry(itemId, farmId, error);
  }

  // ==================== RETRY OPERATIONS ====================

  /// Retenter les items en échec (stalled)
  Future<int> retryStalled(String farmId) async {
    final stalledItems = await _syncQueueRepo.getStalled(farmId);
    if (stalledItems.isEmpty) return 0;

    int reset = 0;
    for (final item in stalledItems) {
      await _syncQueueRepo.resetRetry(item.id, farmId);
      reset++;
    }

    SyncConfig.log('Reset $reset stalled items for retry');
    return reset;
  }

  // ==================== STATISTICS ====================

  /// Obtenir les statistiques de la queue
  Future<SyncQueueStats> getStats(String farmId) {
    return _syncQueueRepo.getStats(farmId);
  }

  /// Obtenir le nombre d'items pending
  Future<int> getPendingCount(String farmId) {
    return _syncQueueRepo.countPending(farmId);
  }

  // ==================== CLEANUP ====================

  /// Nettoyer les anciens items synchronisés
  Future<int> cleanup(String farmId) {
    return _syncQueueRepo.cleanupOldSynced(farmId);
  }

  /// Vider toute la queue (dev only)
  Future<int> clearQueue(String farmId) {
    return _syncQueueRepo.deleteAll(farmId);
  }
}

// ==================== DATA CLASSES ====================

/// Résultat d'une synchronisation
class SyncResult {
  final int syncedCount;
  final int failedCount;
  final List<String> errors;
  final SyncResultType type;

  SyncResult({
    this.syncedCount = 0,
    this.failedCount = 0,
    this.errors = const [],
    this.type = SyncResultType.completed,
  });

  factory SyncResult.disabled() {
    return SyncResult(type: SyncResultType.disabled);
  }

  factory SyncResult.alreadyRunning() {
    return SyncResult(type: SyncResultType.alreadyRunning);
  }

  factory SyncResult.noNetwork() {
    return SyncResult(type: SyncResultType.noNetwork);
  }

  factory SyncResult.authRequired() {
    return SyncResult(type: SyncResultType.authRequired);
  }

  factory SyncResult.nothingToSync() {
    return SyncResult(type: SyncResultType.nothingToSync);
  }

  factory SyncResult.error(String message) {
    return SyncResult(
      type: SyncResultType.error,
      errors: [message],
    );
  }

  /// A des erreurs ?
  bool get hasErrors => failedCount > 0 || errors.isNotEmpty;

  /// Total d'items traités
  int get totalProcessed => syncedCount + failedCount;

  /// Taux de succès
  double get successRate =>
      totalProcessed > 0 ? syncedCount / totalProcessed : 1.0;
}

/// Type de résultat de sync
enum SyncResultType {
  completed,      // Sync terminée (avec ou sans erreurs)
  disabled,       // Service désactivé
  alreadyRunning, // Sync déjà en cours
  noNetwork,      // Pas de connectivité
  authRequired,   // Authentification requise
  nothingToSync,  // Rien à synchroniser
  error,          // Erreur générale
}

/// Statut de la sync
enum SyncStatus {
  idle,           // En attente
  syncing,        // Sync en cours
  success,        // Dernière sync réussie
  partialSuccess, // Dernière sync avec erreurs
  error,          // Dernière sync échouée
  noNetwork,      // Pas de réseau
  authRequired,   // Auth requise
}
