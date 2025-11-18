// lib/repositories/sync_queue_repository.dart

import 'dart:convert';
import 'dart:typed_data';
import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';

import '../drift/database.dart';
import '../models/animal.dart';
import '../models/treatment.dart';
import '../models/vaccination.dart';
import '../models/movement.dart';
import '../models/lot.dart';
import '../models/weight_record.dart';
import '../models/breeding.dart';
import '../models/document.dart';
import '../utils/constants.dart';
import '../utils/sync_config.dart';
import '../utils/sync_validator.dart';

/// Repository pour gérer la queue de synchronisation (STEP 4)
///
/// Architecture HYBRIDE:
/// - Méthode privée _enqueue() générique avec check syncEnabled
/// - Méthodes publiques typées pour chaque entité
class SyncQueueRepository {
  final AppDatabase _db;
  final _uuid = const Uuid();

  SyncQueueRepository(this._db);

  // ═══════════════════════════════════════════════════════════
  // MÉTHODE CORE PRIVÉE (générique)
  // ═══════════════════════════════════════════════════════════

  /// Ajouter un item à la queue (générique)
  ///
  /// Check syncEnabled avant d'enqueue.
  /// Si syncEnabled = false, ne fait rien (return immédiatement)
  Future<void> _enqueue({
    required String farmId,
    required String entityType,
    required String entityId,
    required String action,
    required Map<String, dynamic> payload,
  }) async {
    // Check si sync activée
    if (!SyncConfig.isSyncEnabled()) {
      SyncConfig.log('Sync disabled - skipping enqueue for $entityType:$entityId');
      return;
    }

    final id = _uuid.v4();
    final now = DateTime.now();
    final payloadBytes = Uint8List.fromList(utf8.encode(jsonEncode(payload)));

    final item = SyncQueueTableCompanion(
      id: drift.Value(id),
      farmId: drift.Value(farmId),
      entityType: drift.Value(entityType),
      entityId: drift.Value(entityId),
      action: drift.Value(action),
      payload: drift.Value(payloadBytes),
      retryCount: const drift.Value(0),
      createdAt: drift.Value(now),
      updatedAt: drift.Value(now),
    );

    await _db.syncQueueDao.upsertItem(item);
    SyncConfig.log('Enqueued: $entityType:$entityId ($action)');
  }

  // ═══════════════════════════════════════════════════════════
  // MÉTHODES PUBLIQUES TYPÉES
  // ═══════════════════════════════════════════════════════════

  /// Ajouter un animal à la queue
  Future<void> enqueueAnimal(
    String farmId,
    Animal animal,
    String action,
  ) async {
    // Validation spécifique Animal (sauf delete)
    if (action != SyncAction.delete) {
      final validation = SyncValidator.validateAnimal(animal);
      if (!validation.isValid) {
        throw SyncBlockedException(
          'Animal validation failed: ${validation.errorMessage}',
          errorCodes: validation.errors,
        );
      }
    }

    await _enqueue(
      farmId: farmId,
      entityType: SyncEntityType.animal,
      entityId: animal.id,
      action: action,
      payload: animal.toJson(),
    );
  }

  /// Ajouter un traitement à la queue
  Future<void> enqueueTreatment(
    String farmId,
    Treatment treatment,
    String action,
  ) async {
    await _enqueue(
      farmId: farmId,
      entityType: SyncEntityType.treatment,
      entityId: treatment.id,
      action: action,
      payload: treatment.toJson(),
    );
  }

  /// Ajouter une vaccination à la queue
  Future<void> enqueueVaccination(
    String farmId,
    Vaccination vaccination,
    String action,
  ) async {
    await _enqueue(
      farmId: farmId,
      entityType: SyncEntityType.vaccination,
      entityId: vaccination.id,
      action: action,
      payload: vaccination.toJson(),
    );
  }

  /// Ajouter un mouvement à la queue
  Future<void> enqueueMovement(
    String farmId,
    Movement movement,
    String action,
  ) async {
    await _enqueue(
      farmId: farmId,
      entityType: SyncEntityType.movement,
      entityId: movement.id,
      action: action,
      payload: movement.toJson(),
    );
  }

  /// Ajouter un lot à la queue
  Future<void> enqueueLot(
    String farmId,
    Lot lot,
    String action,
  ) async {
    await _enqueue(
      farmId: farmId,
      entityType: SyncEntityType.lot,
      entityId: lot.id,
      action: action,
      payload: lot.toJson(),
    );
  }

  /// Ajouter un poids à la queue
  Future<void> enqueueWeight(
    String farmId,
    WeightRecord weight,
    String action,
  ) async {
    await _enqueue(
      farmId: farmId,
      entityType: SyncEntityType.weight,
      entityId: weight.id,
      action: action,
      payload: weight.toJson(),
    );
  }

  /// Ajouter une reproduction à la queue
  Future<void> enqueueBreeding(
    String farmId,
    Breeding breeding,
    String action,
  ) async {
    await _enqueue(
      farmId: farmId,
      entityType: SyncEntityType.breeding,
      entityId: breeding.id,
      action: action,
      payload: breeding.toJson(),
    );
  }

  /// Ajouter un document à la queue
  Future<void> enqueueDocument(
    String farmId,
    Document document,
    String action,
  ) async {
    await _enqueue(
      farmId: farmId,
      entityType: SyncEntityType.document,
      entityId: document.id,
      action: action,
      payload: document.toJson(),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // CONSULTATION
  // ═══════════════════════════════════════════════════════════

  /// Récupérer tous les items pending pour une ferme
  Future<List<SyncQueueTableData>> getPending(String farmId) {
    return _db.syncQueueDao.getPending(farmId);
  }

  /// Récupérer tous les items (pending + synced) pour une ferme
  Future<List<SyncQueueTableData>> getAll(String farmId) {
    return _db.syncQueueDao.getAll(farmId);
  }

  /// Compter les items pending
  Future<int> countPending(String farmId) {
    return _db.syncQueueDao.countPending(farmId);
  }

  /// Compter par type d'entité
  Future<Map<String, int>> countByEntityType(String farmId) {
    return _db.syncQueueDao.countByEntityType(farmId);
  }

  /// Récupérer les items en échec (stalled)
  Future<List<SyncQueueTableData>> getStalled(String farmId) {
    return _db.syncQueueDao.getStalled(farmId, SyncConfig.maxRetries);
  }

  /// Compter les items en échec
  Future<int> countStalled(String farmId) {
    return _db.syncQueueDao.countStalled(farmId, SyncConfig.maxRetries);
  }

  // ═══════════════════════════════════════════════════════════
  // NETTOYAGE
  // ═══════════════════════════════════════════════════════════

  /// Supprimer tous les items d'une ferme
  Future<int> deleteAll(String farmId) {
    SyncConfig.log('Deleting all queue items for farm: $farmId');
    return _db.syncQueueDao.deleteAll(farmId);
  }

  /// Supprimer les items synchronisés plus anciens que N jours
  Future<int> cleanupOldSynced(String farmId) {
    final cutoff = DateTime.now().subtract(
      Duration(days: SyncConfig.cleanupDaysOld),
    );
    SyncConfig.log('Cleanup: removing items synced before $cutoff');
    return _db.syncQueueDao.deleteSyncedOlderThan(farmId, cutoff);
  }

  /// Marquer un item comme synchronisé
  Future<void> markSynced(String id, String farmId) {
    return _db.syncQueueDao.markSynced(id, farmId).then((_) {
      SyncConfig.log('Marked synced: $id');
    });
  }

  /// Incrémenter le retry d'un item
  Future<void> incrementRetry(String id, String farmId, String error) {
    return _db.syncQueueDao.incrementRetry(id, farmId, error).then((_) {
      SyncConfig.log('Retry incremented: $id (error: $error)');
    });
  }

  /// Réinitialiser le retry d'un item
  Future<void> resetRetry(String id, String farmId) {
    return _db.syncQueueDao.resetRetry(id, farmId).then((_) {
      SyncConfig.log('Retry reset: $id');
    });
  }

  // ═══════════════════════════════════════════════════════════
  // STATISTIQUES
  // ═══════════════════════════════════════════════════════════

  /// Obtenir les statistiques complètes de la queue
  Future<SyncQueueStats> getStats(String farmId) async {
    final pending = await countPending(farmId);
    final stalled = await countStalled(farmId);
    final byType = await countByEntityType(farmId);

    return SyncQueueStats(
      pendingCount: pending,
      stalledCount: stalled,
      byEntityType: byType,
    );
  }
}

/// Statistiques de la queue de sync
class SyncQueueStats {
  final int pendingCount;
  final int stalledCount;
  final Map<String, int> byEntityType;

  SyncQueueStats({
    required this.pendingCount,
    required this.stalledCount,
    required this.byEntityType,
  });

  /// Total des items
  int get totalCount => pendingCount + stalledCount;

  /// A des items en attente?
  bool get hasPending => pendingCount > 0;

  /// A des items en échec?
  bool get hasStalled => stalledCount > 0;
}
