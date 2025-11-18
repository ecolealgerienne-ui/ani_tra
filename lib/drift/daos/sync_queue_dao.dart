// lib/drift/daos/sync_queue_dao.dart

import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/sync_queue_table.dart';

part 'sync_queue_dao.g.dart';

/// DAO pour la gestion de la queue de synchronisation (STEP 4)
@DriftAccessor(tables: [SyncQueueTable])
class SyncQueueDao extends DatabaseAccessor<AppDatabase>
    with _$SyncQueueDaoMixin {
  SyncQueueDao(super.db);

  // ==================== LECTURE ====================

  /// Récupérer tous les items pending (non synchronisés) pour une ferme
  Future<List<SyncQueueTableData>> getPending(String farmId) {
    return (select(syncQueueTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.syncedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  /// Récupérer tous les items (pending + synced) pour une ferme
  Future<List<SyncQueueTableData>> getAll(String farmId) {
    return (select(syncQueueTable)
          ..where((t) => t.farmId.equals(farmId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Récupérer un item par ID
  Future<SyncQueueTableData?> getById(String id, String farmId) {
    return (select(syncQueueTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .getSingleOrNull();
  }

  /// Récupérer items par type d'entité
  Future<List<SyncQueueTableData>> getByEntityType(
      String farmId, String entityType) {
    return (select(syncQueueTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.entityType.equals(entityType))
          ..where((t) => t.syncedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  /// Récupérer items en échec (retry >= max)
  Future<List<SyncQueueTableData>> getStalled(String farmId, int maxRetries) {
    return (select(syncQueueTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.syncedAt.isNull())
          ..where((t) => t.retryCount.isBiggerOrEqualValue(maxRetries)))
        .get();
  }

  // ==================== ÉCRITURE ====================

  /// Insérer un nouvel item dans la queue
  Future<int> insertItem(SyncQueueTableCompanion item) {
    return into(syncQueueTable).insert(item);
  }

  /// Mettre à jour un item existant (upsert)
  Future<int> upsertItem(SyncQueueTableCompanion item) {
    return into(syncQueueTable).insertOnConflictUpdate(item);
  }

  /// Marquer un item comme synchronisé
  Future<int> markSynced(String id, String farmId) {
    return (update(syncQueueTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(SyncQueueTableCompanion(
          syncedAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ));
  }

  /// Incrémenter le compteur de retry et enregistrer l'erreur
  Future<int> incrementRetry(String id, String farmId, String errorMsg) {
    return customStatement(
      'UPDATE sync_queue SET '
      'retry_count = retry_count + 1, '
      'error_message = ?, '
      'last_retry_at = ?, '
      'updated_at = ? '
      'WHERE id = ? AND farm_id = ?',
      [
        errorMsg,
        DateTime.now().toIso8601String(),
        DateTime.now().toIso8601String(),
        id,
        farmId,
      ],
    );
  }

  /// Réinitialiser le compteur de retry
  Future<int> resetRetry(String id, String farmId) {
    return (update(syncQueueTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(const SyncQueueTableCompanion(
          retryCount: Value(0),
          errorMessage: Value(null),
          lastRetryAt: Value(null),
        ));
  }

  // ==================== SUPPRESSION ====================

  /// Supprimer un item spécifique
  Future<int> deleteItem(String id, String farmId) {
    return (delete(syncQueueTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .go();
  }

  /// Supprimer tous les items synchronisés plus anciens que la date donnée
  Future<int> deleteSyncedOlderThan(String farmId, DateTime cutoff) {
    return (delete(syncQueueTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.syncedAt.isNotNull())
          ..where((t) => t.syncedAt.isSmallerThanValue(cutoff)))
        .go();
  }

  /// Supprimer tous les items d'une ferme (DANGER - dev only)
  Future<int> deleteAll(String farmId) {
    return (delete(syncQueueTable)
          ..where((t) => t.farmId.equals(farmId)))
        .go();
  }

  /// Supprimer items par entité (quand entité supprimée)
  Future<int> deleteByEntity(String farmId, String entityId) {
    return (delete(syncQueueTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.entityId.equals(entityId)))
        .go();
  }

  // ==================== STATISTIQUES ====================

  /// Compter les items pending
  Future<int> countPending(String farmId) async {
    final query = selectOnly(syncQueueTable)
      ..addColumns([syncQueueTable.id.count()])
      ..where(syncQueueTable.farmId.equals(farmId))
      ..where(syncQueueTable.syncedAt.isNull());

    final result = await query.getSingle();
    return result.read(syncQueueTable.id.count()) ?? 0;
  }

  /// Compter les items par type d'entité
  Future<Map<String, int>> countByEntityType(String farmId) async {
    final results = await (select(syncQueueTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.syncedAt.isNull()))
        .get();

    final counts = <String, int>{};
    for (final item in results) {
      counts[item.entityType] = (counts[item.entityType] ?? 0) + 1;
    }
    return counts;
  }

  /// Compter les items en erreur (stalled)
  Future<int> countStalled(String farmId, int maxRetries) async {
    final query = selectOnly(syncQueueTable)
      ..addColumns([syncQueueTable.id.count()])
      ..where(syncQueueTable.farmId.equals(farmId))
      ..where(syncQueueTable.syncedAt.isNull())
      ..where(syncQueueTable.retryCount.isBiggerOrEqualValue(maxRetries));

    final result = await query.getSingle();
    return result.read(syncQueueTable.id.count()) ?? 0;
  }
}
