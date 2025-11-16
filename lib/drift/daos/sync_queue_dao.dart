// lib/drift/daos/sync_queue_dao.dart
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/sync_queue_table.dart';

part 'sync_queue_dao.g.dart';

/// DAO pour la gestion de la queue de synchronisation (STEP 4)
///
/// Cette classe gère toutes les opérations sur la table sync_queue:
/// - Récupération des items en attente de sync
/// - Marquage des items synchronisés
/// - Gestion des retries en cas d'échec
/// - Cleanup des items anciens
@DriftAccessor(tables: [SyncQueueTable])
class SyncQueueDao extends DatabaseAccessor<AppDatabase>
    with _$SyncQueueDaoMixin {
  SyncQueueDao(super.db);

  // ==================== MÉTHODES SYNC QUEUE ====================

  /// 1. getPending - Récupère tous les items en attente de synchronisation
  ///
  /// Filtre:
  /// - farmId = farm spécifié (multi-tenancy)
  /// - syncedAt IS NULL (pas encore synchronisé)
  /// - Ordre: createdAt ASC (FIFO)
  Future<List<SyncQueueTableData>> getPending(String farmId) {
    return (select(syncQueueTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.syncedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  /// 2. insertItem - Ajoute un item à la queue
  ///
  /// Note: La contrainte UNIQUE(farmId, entityId, action) empêche les duplicatas.
  /// Si l'item existe déjà, une exception sera levée.
  /// Le repository doit gérer l'upsert (update si existe).
  Future<int> insertItem(SyncQueueTableCompanion item) {
    return into(syncQueueTable).insert(item);
  }

  /// 3. markSynced - Marque un item comme synchronisé
  ///
  /// Met à jour:
  /// - syncedAt = NOW()
  /// - updatedAt = NOW()
  ///
  /// Retourne le nombre de lignes affectées (doit être 1)
  Future<int> markSynced(String id, String farmId) {
    return (update(syncQueueTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(SyncQueueTableCompanion(
      syncedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// 4. incrementRetry - Incrémente le compteur de retry
  ///
  /// Utilisé en cas d'échec de synchronisation.
  /// Met à jour:
  /// - retryCount += 1
  /// - lastRetryAt = NOW()
  /// - errorMessage = message d'erreur
  /// - updatedAt = NOW()
  ///
  /// Après 3 retries (MAX_RETRIES), l'item est considéré comme "stalled"
  Future<int> incrementRetry(
    String id,
    String farmId,
    String errorMessage,
  ) async {
    // Récupérer l'item actuel pour obtenir retryCount
    final item = await (select(syncQueueTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .getSingleOrNull();

    if (item == null) {
      return 0; // Item not found
    }

    return (update(syncQueueTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(SyncQueueTableCompanion(
      retryCount: Value(item.retryCount + 1),
      lastRetryAt: Value(DateTime.now()),
      errorMessage: Value(errorMessage),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// 5. deleteSynced - Supprime les items synchronisés anciens (cleanup)
  ///
  /// Supprime les items:
  /// - farmId = farm spécifié
  /// - syncedAt IS NOT NULL (déjà synchronisé)
  /// - syncedAt < cutoffDate (plus ancien que la date limite)
  ///
  /// Typiquement appelé avec cutoffDate = NOW() - 30 jours
  ///
  /// Retourne le nombre d'items supprimés
  Future<int> deleteSynced(String farmId, DateTime cutoffDate) {
    return (delete(syncQueueTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.syncedAt.isNotNull())
          ..where((t) => t.syncedAt.isSmallerThanValue(cutoffDate)))
        .go();
  }

  /// 6. countPending - Compte le nombre d'items en attente
  ///
  /// Utile pour affichage UI et monitoring
  Future<int> countPending(String farmId) async {
    final count = syncQueueTable.id.count();
    final query = selectOnly(syncQueueTable)
      ..addColumns([count])
      ..where(syncQueueTable.farmId.equals(farmId))
      ..where(syncQueueTable.syncedAt.isNull());

    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  // ==================== MÉTHODES SUPPLÉMENTAIRES (DEBUG/MONITORING) ====================

  /// findById - Récupère un item spécifique par ID
  Future<SyncQueueTableData?> findById(String id, String farmId) {
    return (select(syncQueueTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .getSingleOrNull();
  }

  /// findStalled - Récupère les items en échec après max retries
  ///
  /// Items avec retryCount >= 3 (constant MAX_RETRIES)
  /// Ces items nécessitent intervention manuelle ou reset
  Future<List<SyncQueueTableData>> findStalled(String farmId,
      {int maxRetries = 3}) {
    return (select(syncQueueTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.syncedAt.isNull())
          ..where((t) => t.retryCount.isBiggerOrEqualValue(maxRetries)))
        .get();
  }

  /// resetRetryCount - Reset le compteur de retry à 0
  ///
  /// Utilisé pour re-tenter un item "stalled"
  Future<int> resetRetryCount(String id, String farmId) {
    return (update(syncQueueTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(const SyncQueueTableCompanion(
      retryCount: Value(0),
      lastRetryAt: Value(null),
      errorMessage: Value(null),
    ));
  }

  /// countSynced - Compte le nombre d'items déjà synchronisés
  Future<int> countSynced(String farmId) async {
    final count = syncQueueTable.id.count();
    final query = selectOnly(syncQueueTable)
      ..addColumns([count])
      ..where(syncQueueTable.farmId.equals(farmId))
      ..where(syncQueueTable.syncedAt.isNotNull());

    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// getAll - Récupère tous les items (pending + synced) pour debug
  ///
  /// ⚠️ À utiliser avec précaution (peut retourner beaucoup de données)
  Future<List<SyncQueueTableData>> getAll(String farmId) {
    return (select(syncQueueTable)
          ..where((t) => t.farmId.equals(farmId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// deleteAll - Supprime TOUS les items (dev/test only!)
  ///
  /// ⚠️ DANGER: À utiliser UNIQUEMENT en développement
  Future<int> deleteAll(String farmId) {
    return (delete(syncQueueTable)..where((t) => t.farmId.equals(farmId)))
        .go();
  }
}
