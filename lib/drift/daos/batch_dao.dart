// lib/drift/daos/batch_dao.dart
import 'dart:convert';
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
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  // 2. Get batch by ID
  Future<BatchesTableData?> findById(String id) {
    return (select(batchesTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // 3. Get active batches (not completed) for a farm
  Future<List<BatchesTableData>> findActiveByFarm(String farmId) {
    return (select(batchesTable)
          ..where((t) => t.farmId.equals(farmId) & t.completed.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  // 4. Get completed batches for a farm
  Future<List<BatchesTableData>> findCompletedByFarm(String farmId) {
    return (select(batchesTable)
          ..where((t) => t.farmId.equals(farmId) & t.completed.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.usedAt)]))
        .get();
  }

  // 5. Get batches by purpose for a farm
  Future<List<BatchesTableData>> findByPurposeAndFarm(
      String purpose, String farmId) {
    return (select(batchesTable)
          ..where((t) => t.farmId.equals(farmId) & t.purpose.equals(purpose))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  // 6. Get batches containing a specific animal
  Future<List<BatchesTableData>> findByAnimalId(
      String animalId, String farmId) async {
    final allBatches = await findAllByFarm(farmId);

    return allBatches.where((batch) {
      final animalIds = _decodeAnimalIds(batch.animalIdsJson);
      return animalIds.contains(animalId);
    }).toList();
  }

  // 7. Insert batch
  Future<int> insertBatch(BatchesTableCompanion batch) {
    return into(batchesTable).insert(batch);
  }

  // 8. Update batch
  Future<bool> updateBatch(BatchesTableCompanion batch) {
    return update(batchesTable).replace(batch);
  }

  // 9. Delete batch
  Future<int> deleteBatch(String id) {
    return (delete(batchesTable)..where((t) => t.id.equals(id))).go();
  }

  // 10. Mark batch as completed
  Future<int> markAsCompleted(String id) {
    return (update(batchesTable)..where((t) => t.id.equals(id))).write(
      BatchesTableCompanion(
        completed: const Value(true),
        usedAt: Value(DateTime.now()),
        synced: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // 11. Add animal to batch
  Future<void> addAnimalToBatch(String batchId, String animalId) async {
    final batch = await findById(batchId);
    if (batch == null) return;

    final animalIds = _decodeAnimalIds(batch.animalIdsJson);
    if (!animalIds.contains(animalId)) {
      animalIds.add(animalId);

      await (update(batchesTable)..where((t) => t.id.equals(batchId))).write(
        BatchesTableCompanion(
          animalIdsJson: Value(_encodeAnimalIds(animalIds)),
          synced: const Value(false),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  // 12. Remove animal from batch
  Future<void> removeAnimalFromBatch(String batchId, String animalId) async {
    final batch = await findById(batchId);
    if (batch == null) return;

    final animalIds = _decodeAnimalIds(batch.animalIdsJson);
    if (animalIds.contains(animalId)) {
      animalIds.remove(animalId);

      await (update(batchesTable)..where((t) => t.id.equals(batchId))).write(
        BatchesTableCompanion(
          animalIdsJson: Value(_encodeAnimalIds(animalIds)),
          synced: const Value(false),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  // 13. Count batches by farm
  Future<int> countByFarm(String farmId) async {
    final query = selectOnly(batchesTable)
      ..addColumns([batchesTable.id.count()])
      ..where(batchesTable.farmId.equals(farmId));

    final result = await query.getSingleOrNull();
    return result?.read(batchesTable.id.count()) ?? 0;
  }

  // 14. Count active batches by farm
  Future<int> countActiveByFarm(String farmId) async {
    final query = selectOnly(batchesTable)
      ..addColumns([batchesTable.id.count()])
      ..where(batchesTable.farmId.equals(farmId) &
          batchesTable.completed.equals(false));

    final result = await query.getSingleOrNull();
    return result?.read(batchesTable.id.count()) ?? 0;
  }

  // 15. Get unsynced batches for a farm
  Future<List<BatchesTableData>> findUnsyncedByFarm(String farmId) {
    return (select(batchesTable)
          ..where((t) => t.farmId.equals(farmId) & t.synced.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.updatedAt)]))
        .get();
  }

  // ==================== Helper Methods ====================

  /// Encode List String to JSON string
  String _encodeAnimalIds(List<String> animalIds) {
    return jsonEncode(animalIds);
  }

  /// Decode JSON string to List String
  List<String> _decodeAnimalIds(String jsonString) {
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is List) {
        return decoded.cast<String>();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
