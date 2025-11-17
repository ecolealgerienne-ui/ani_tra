// lib/drift/daos/batch_animal_dao.dart
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/batch_animals_table.dart';

part 'batch_animal_dao.g.dart';

@DriftAccessor(tables: [BatchAnimalsTable])
class BatchAnimalDao extends DatabaseAccessor<AppDatabase>
    with _$BatchAnimalDaoMixin {
  BatchAnimalDao(super.db);

  // ==================== CREATE ====================

  /// Add an animal to a batch
  Future<void> addAnimalToBatch(String batchId, String animalId) async {
    await into(batchAnimalsTable).insert(
      BatchAnimalsTableCompanion.insert(
        batchId: batchId,
        animalId: animalId,
        addedAt: DateTime.now(),
      ),
      mode: InsertMode.insertOrIgnore, // Ignore if already exists
    );
  }

  /// Add multiple animals to a batch
  Future<void> addAnimalsToBatch(String batchId, List<String> animalIds) async {
    final now = DateTime.now();
    await batch((batch) {
      batch.insertAll(
        batchAnimalsTable,
        animalIds.map((animalId) => BatchAnimalsTableCompanion.insert(
              batchId: batchId,
              animalId: animalId,
              addedAt: now,
            )),
        mode: InsertMode.insertOrIgnore,
      );
    });
  }

  // ==================== READ ====================

  /// Get all animal IDs for a batch
  Future<List<String>> getAnimalIdsForBatch(String batchId) async {
    final results = await (select(batchAnimalsTable)
          ..where((t) => t.batchId.equals(batchId))
          ..orderBy([(t) => OrderingTerm.asc(t.addedAt)]))
        .get();

    return results.map((row) => row.animalId).toList();
  }

  /// Get all batch IDs for an animal
  Future<List<String>> getBatchIdsForAnimal(String animalId) async {
    final results = await (select(batchAnimalsTable)
          ..where((t) => t.animalId.equals(animalId))
          ..orderBy([(t) => OrderingTerm.desc(t.addedAt)]))
        .get();

    return results.map((row) => row.batchId).toList();
  }

  /// Count animals in a batch
  Future<int> countAnimalsInBatch(String batchId) async {
    final query = selectOnly(batchAnimalsTable)
      ..addColumns([batchAnimalsTable.animalId.count()])
      ..where(batchAnimalsTable.batchId.equals(batchId));

    final result = await query.getSingleOrNull();
    return result?.read(batchAnimalsTable.animalId.count()) ?? 0;
  }

  /// Check if an animal is in a batch
  Future<bool> isAnimalInBatch(String batchId, String animalId) async {
    final result = await (select(batchAnimalsTable)
          ..where((t) => t.batchId.equals(batchId) & t.animalId.equals(animalId)))
        .getSingleOrNull();

    return result != null;
  }

  // ==================== DELETE ====================

  /// Remove an animal from a batch
  Future<int> removeAnimalFromBatch(String batchId, String animalId) {
    return (delete(batchAnimalsTable)
          ..where((t) => t.batchId.equals(batchId) & t.animalId.equals(animalId)))
        .go();
  }

  /// Remove multiple animals from a batch
  Future<int> removeAnimalsFromBatch(String batchId, List<String> animalIds) {
    return (delete(batchAnimalsTable)
          ..where(
              (t) => t.batchId.equals(batchId) & t.animalId.isIn(animalIds)))
        .go();
  }

  /// Remove all animals from a batch
  Future<int> clearBatch(String batchId) {
    return (delete(batchAnimalsTable)..where((t) => t.batchId.equals(batchId))).go();
  }

  /// Remove an animal from all batches
  Future<int> removeAnimalFromAllBatches(String animalId) {
    return (delete(batchAnimalsTable)
          ..where((t) => t.animalId.equals(animalId)))
        .go();
  }

  // ==================== BATCH OPERATIONS ====================

  /// Replace all animals in a batch (atomic operation)
  Future<void> replaceAnimalsInBatch(
      String batchId, List<String> animalIds) async {
    await transaction(() async {
      // Clear existing animals
      await clearBatch(batchId);
      // Add new animals
      await addAnimalsToBatch(batchId, animalIds);
    });
  }
}
