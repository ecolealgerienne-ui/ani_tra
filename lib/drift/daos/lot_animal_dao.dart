// lib/drift/daos/lot_animal_dao.dart
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/lot_animals_table.dart';

part 'lot_animal_dao.g.dart';

@DriftAccessor(tables: [LotAnimalsTable])
class LotAnimalDao extends DatabaseAccessor<AppDatabase>
    with _$LotAnimalDaoMixin {
  LotAnimalDao(super.db);

  // ==================== CREATE ====================

  /// Add an animal to a lot
  Future<void> addAnimalToLot(String lotId, String animalId) async {
    await into(lotAnimalsTable).insert(
      LotAnimalsTableCompanion.insert(
        lotId: lotId,
        animalId: animalId,
        addedAt: DateTime.now(),
      ),
      mode: InsertMode.insertOrIgnore, // Ignore if already exists
    );
  }

  /// Add multiple animals to a lot
  Future<void> addAnimalsToLot(String lotId, List<String> animalIds) async {
    final now = DateTime.now();
    await batch((batch) {
      batch.insertAll(
        lotAnimalsTable,
        animalIds.map((animalId) => LotAnimalsTableCompanion.insert(
              lotId: lotId,
              animalId: animalId,
              addedAt: now,
            )),
        mode: InsertMode.insertOrIgnore,
      );
    });
  }

  // ==================== READ ====================

  /// Get all animal IDs for a lot
  Future<List<String>> getAnimalIdsForLot(String lotId) async {
    final results = await (select(lotAnimalsTable)
          ..where((t) => t.lotId.equals(lotId))
          ..orderBy([(t) => OrderingTerm.asc(t.addedAt)]))
        .get();

    return results.map((row) => row.animalId).toList();
  }

  /// Get all lot IDs for an animal
  Future<List<String>> getLotIdsForAnimal(String animalId) async {
    final results = await (select(lotAnimalsTable)
          ..where((t) => t.animalId.equals(animalId))
          ..orderBy([(t) => OrderingTerm.desc(t.addedAt)]))
        .get();

    return results.map((row) => row.lotId).toList();
  }

  /// Count animals in a lot
  Future<int> countAnimalsInLot(String lotId) async {
    final query = selectOnly(lotAnimalsTable)
      ..addColumns([lotAnimalsTable.animalId.count()])
      ..where(lotAnimalsTable.lotId.equals(lotId));

    final result = await query.getSingleOrNull();
    return result?.read(lotAnimalsTable.animalId.count()) ?? 0;
  }

  /// Check if an animal is in a lot
  Future<bool> isAnimalInLot(String lotId, String animalId) async {
    final result = await (select(lotAnimalsTable)
          ..where((t) => t.lotId.equals(lotId) & t.animalId.equals(animalId)))
        .getSingleOrNull();

    return result != null;
  }

  // ==================== DELETE ====================

  /// Remove an animal from a lot
  Future<int> removeAnimalFromLot(String lotId, String animalId) {
    return (delete(lotAnimalsTable)
          ..where((t) => t.lotId.equals(lotId) & t.animalId.equals(animalId)))
        .go();
  }

  /// Remove multiple animals from a lot
  Future<int> removeAnimalsFromLot(String lotId, List<String> animalIds) {
    return (delete(lotAnimalsTable)
          ..where(
              (t) => t.lotId.equals(lotId) & t.animalId.isIn(animalIds)))
        .go();
  }

  /// Remove all animals from a lot
  Future<int> clearLot(String lotId) {
    return (delete(lotAnimalsTable)..where((t) => t.lotId.equals(lotId))).go();
  }

  /// Remove an animal from all lots
  Future<int> removeAnimalFromAllLots(String animalId) {
    return (delete(lotAnimalsTable)
          ..where((t) => t.animalId.equals(animalId)))
        .go();
  }

  // ==================== BATCH OPERATIONS ====================

  /// Replace all animals in a lot (atomic operation)
  Future<void> replaceAnimalsInLot(
      String lotId, List<String> animalIds) async {
    await transaction(() async {
      // Clear existing animals
      await clearLot(lotId);
      // Add new animals
      await addAnimalsToLot(lotId, animalIds);
    });
  }
}
