// lib/drift/daos/lot_dao.dart
import 'dart:convert';
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/lots_table.dart';

part 'lot_dao.g.dart';

@DriftAccessor(tables: [LotsTable])
class LotDao extends DatabaseAccessor<AppDatabase> with _$LotDaoMixin {
  LotDao(super.db);

  // 1. Get all lots for a farm
  Future<List<LotsTableData>> findAllByFarm(String farmId) {
    return (select(lotsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  // 2. Get lot by ID
  Future<LotsTableData?> findById(String id) {
    return (select(lotsTable)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // 3. Get open lots (not completed) for a farm
  Future<List<LotsTableData>> findOpenByFarm(String farmId) {
    return (select(lotsTable)
          ..where((t) => t.farmId.equals(farmId) & t.completed.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  // 4. Get completed lots for a farm
  Future<List<LotsTableData>> findCompletedByFarm(String farmId) {
    return (select(lotsTable)
          ..where((t) => t.farmId.equals(farmId) & t.completed.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.completedAt)]))
        .get();
  }

  // 5. Get lots by type for a farm
  Future<List<LotsTableData>> findByTypeAndFarm(String type, String farmId) {
    return (select(lotsTable)
          ..where((t) => t.farmId.equals(farmId) & t.type.equals(type))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  // 6. Get lots without type (type = null) for a farm
  Future<List<LotsTableData>> findWithoutTypeByFarm(String farmId) {
    return (select(lotsTable)
          ..where((t) => t.farmId.equals(farmId) & t.type.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  // 7. Get lots containing a specific animal
  Future<List<LotsTableData>> findByAnimalId(
      String animalId, String farmId) async {
    final allLots = await findAllByFarm(farmId);

    return allLots.where((lot) {
      final animalIds = _decodeAnimalIds(lot.animalIdsJson);
      return animalIds.contains(animalId);
    }).toList();
  }

  // 8. Get treatment lots by product for a farm
  Future<List<LotsTableData>> findByProductId(String productId, String farmId) {
    return (select(lotsTable)
          ..where(
              (t) => t.farmId.equals(farmId) & t.productId.equals(productId))
          ..orderBy([(t) => OrderingTerm.desc(t.treatmentDate)]))
        .get();
  }

  // 9. Get treatment lots by veterinarian for a farm
  Future<List<LotsTableData>> findByVeterinarianId(
      String veterinarianId, String farmId) {
    return (select(lotsTable)
          ..where((t) =>
              t.farmId.equals(farmId) & t.veterinarianId.equals(veterinarianId))
          ..orderBy([(t) => OrderingTerm.desc(t.treatmentDate)]))
        .get();
  }

  // 10. Insert lot
  Future<int> insertLot(LotsTableCompanion lot) {
    return into(lotsTable).insert(lot);
  }

  // 11. Update lot
  Future<bool> updateLot(LotsTableCompanion lot) {
    return update(lotsTable).replace(lot);
  }

  // 12. Delete lot
  Future<int> deleteLot(String id) {
    return (delete(lotsTable)..where((t) => t.id.equals(id))).go();
  }

  // 13. Mark lot as completed
  Future<int> markAsCompleted(String id) {
    return (update(lotsTable)..where((t) => t.id.equals(id))).write(
      LotsTableCompanion(
        completed: const Value(true),
        completedAt: Value(DateTime.now()),
        synced: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // 14. Add animal to lot
  Future<void> addAnimalToLot(String lotId, String animalId) async {
    final lot = await findById(lotId);
    if (lot == null) return;

    final animalIds = _decodeAnimalIds(lot.animalIdsJson);
    if (!animalIds.contains(animalId)) {
      animalIds.add(animalId);

      await (update(lotsTable)..where((t) => t.id.equals(lotId))).write(
        LotsTableCompanion(
          animalIdsJson: Value(_encodeAnimalIds(animalIds)),
          synced: const Value(false),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  // 15. Remove animal from lot
  Future<void> removeAnimalFromLot(String lotId, String animalId) async {
    final lot = await findById(lotId);
    if (lot == null) return;

    final animalIds = _decodeAnimalIds(lot.animalIdsJson);
    if (animalIds.contains(animalId)) {
      animalIds.remove(animalId);

      await (update(lotsTable)..where((t) => t.id.equals(lotId))).write(
        LotsTableCompanion(
          animalIdsJson: Value(_encodeAnimalIds(animalIds)),
          synced: const Value(false),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  // 16. Set lot type
  Future<int> setLotType(String id, String type) {
    return (update(lotsTable)..where((t) => t.id.equals(id))).write(
      LotsTableCompanion(
        type: Value(type),
        synced: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // 17. Count lots by farm
  Future<int> countByFarm(String farmId) async {
    final query = selectOnly(lotsTable)
      ..addColumns([lotsTable.id.count()])
      ..where(lotsTable.farmId.equals(farmId));

    final result = await query.getSingleOrNull();
    return result?.read(lotsTable.id.count()) ?? 0;
  }

  // 18. Count open lots by farm
  Future<int> countOpenByFarm(String farmId) async {
    final query = selectOnly(lotsTable)
      ..addColumns([lotsTable.id.count()])
      ..where(
          lotsTable.farmId.equals(farmId) & lotsTable.completed.equals(false));

    final result = await query.getSingleOrNull();
    return result?.read(lotsTable.id.count()) ?? 0;
  }

  // 19. Count lots by type for a farm
  Future<int> countByTypeAndFarm(String type, String farmId) async {
    final query = selectOnly(lotsTable)
      ..addColumns([lotsTable.id.count()])
      ..where(lotsTable.farmId.equals(farmId) & lotsTable.type.equals(type));

    final result = await query.getSingleOrNull();
    return result?.read(lotsTable.id.count()) ?? 0;
  }

  // 20. Get unsynced lots for a farm
  Future<List<LotsTableData>> findUnsyncedByFarm(String farmId) {
    return (select(lotsTable)
          ..where((t) => t.farmId.equals(farmId) & t.synced.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.updatedAt)]))
        .get();
  }

  // 21. Get lots with upcoming withdrawal dates (treatment)
  Future<List<LotsTableData>> findWithUpcomingWithdrawal(
      String farmId, DateTime beforeDate) {
    return (select(lotsTable)
          ..where((t) =>
              t.farmId.equals(farmId) &
              t.type.equals('treatment') &
              t.withdrawalEndDate.isSmallerOrEqualValue(beforeDate) &
              t.completed.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.withdrawalEndDate)]))
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
