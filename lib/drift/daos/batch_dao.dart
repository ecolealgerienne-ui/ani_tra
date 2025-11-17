// lib/drift/daos/batch_dao.dart
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/batches_table.dart';

part 'batch_dao.g.dart';

@DriftAccessor(tables: [BatchesTable])
class BatchDao extends DatabaseAccessor<AppDatabase> with _$BatchDaoMixin {
  BatchDao(super.db);

  // 1. Get all batches for a farm
  Future<List<BatchesTableData>> findAllByFarm(String farmId) {
    return (select(batchesTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  // 2. Get batch by ID WITH farmId validation
  Future<BatchesTableData?> findById(String id, String farmId) {
    return (select(batchesTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  // 3. Get active batches (not completed) for a farm
  Future<List<BatchesTableData>> findActiveByFarm(String farmId) {
    return (select(batchesTable)
          ..where((t) => t.farmId.equals(farmId) & t.completed.equals(false))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  // 4. Get completed batches for a farm
  Future<List<BatchesTableData>> findCompletedByFarm(String farmId) {
    return (select(batchesTable)
          ..where((t) => t.farmId.equals(farmId) & t.completed.equals(true))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.usedAt)]))
        .get();
  }

  // 5. Get batches by purpose for a farm
  Future<List<BatchesTableData>> findByPurposeAndFarm(
      String purpose, String farmId) {
    return (select(batchesTable)
          ..where((t) => t.farmId.equals(farmId) & t.purpose.equals(purpose))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  // 6. [REMOVED] Get batches containing a specific animal - Use BatchAnimalDao instead

  // 7. Insert batch
  Future<int> insertBatch(BatchesTableCompanion batch) {
    return into(batchesTable).insert(batch);
  }

  // 8. Update batch WITH farmId validation - returns Future<int>
  Future<int> updateBatch(BatchesTableCompanion batch, String farmId) {
    return (update(batchesTable)
          ..where((t) => t.id.equals(batch.id.value))
          ..where((t) => t.farmId.equals(farmId)))
        .write(batch);
  }

  // 9. Soft-delete batch (audit trail)
  Future<int> softDelete(String id, String farmId) {
    return (update(batchesTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(BatchesTableCompanion(
      deletedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // 10. Mark batch as completed
  Future<int> markAsCompleted(String id, String farmId) {
    return (update(batchesTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(
      BatchesTableCompanion(
        completed: const Value(true),
        usedAt: Value(DateTime.now()),
        synced: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // 11. [REMOVED] Add animal to batch - Use BatchAnimalDao.addAnimalToBatch() instead

  // 12. [REMOVED] Remove animal from batch - Use BatchAnimalDao.removeAnimalFromBatch() instead

  // 13. Count batches by farm
  Future<int> countByFarm(String farmId) async {
    final query = selectOnly(batchesTable)
      ..addColumns([batchesTable.id.count()])
      ..where(batchesTable.farmId.equals(farmId))
      ..where(batchesTable.deletedAt.isNull());

    final result = await query.getSingleOrNull();
    return result?.read(batchesTable.id.count()) ?? 0;
  }

  // 14. Count active batches by farm
  Future<int> countActiveByFarm(String farmId) async {
    final query = selectOnly(batchesTable)
      ..addColumns([batchesTable.id.count()])
      ..where(batchesTable.farmId.equals(farmId) &
          batchesTable.completed.equals(false))
      ..where(batchesTable.deletedAt.isNull());

    final result = await query.getSingleOrNull();
    return result?.read(batchesTable.id.count()) ?? 0;
  }

  // 15. Get unsynced batches for a farm
  Future<List<BatchesTableData>> findUnsyncedByFarm(String farmId) {
    return (select(batchesTable)
          ..where((t) => t.farmId.equals(farmId) & t.synced.equals(false))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.updatedAt)]))
        .get();
  }

  // ==================== Helper Methods ====================
  // [REMOVED] _encodeAnimalIds and _decodeAnimalIds
  // Use BatchAnimalDao for managing animals in batches
}
