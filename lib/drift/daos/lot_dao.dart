// lib/drift/daos/lot_dao.dart
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

  // 2. Get lot by ID WITH farmId validation
  Future<LotsTableData?> findById(String id, String farmId) {
    return (select(lotsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .getSingleOrNull();
  }

  // 3. Get open lots (not completed) for a farm
  // PHASE 1: Add fallback logic for backward-compat
  Future<List<LotsTableData>> findOpenByFarm(String farmId) {
    return (select(lotsTable)
          ..where((t) =>
              t.farmId.equals(farmId) &
              (t.status.equals('open') |
                  (t.status.isNull() & t.completed.equals(false))))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  // 4. Get completed lots for a farm (PHASE 1: includes archived)
  Future<List<LotsTableData>> findCompletedByFarm(String farmId) {
    return (select(lotsTable)
          ..where((t) =>
              t.farmId.equals(farmId) &
              (t.status.isIn(['closed', 'archived']) |
                  (t.status.isNull() & t.completed.equals(true))))
          ..orderBy([(t) => OrderingTerm.desc(t.completedAt)]))
        .get();
  }

  // PHASE 1: ADD - Get closed lots only (excluding archived)
  Future<List<LotsTableData>> findClosedByFarm(String farmId) {
    return (select(lotsTable)
          ..where((t) =>
              t.farmId.equals(farmId) &
              (t.status.equals('closed') |
                  (t.status.isNull() & t.completed.equals(true))))
          ..orderBy([(t) => OrderingTerm.desc(t.completedAt)]))
        .get();
  }

  // PHASE 1: ADD - Get archived lots for a farm
  Future<List<LotsTableData>> findArchivedByFarm(String farmId) {
    return (select(lotsTable)
          ..where((t) => t.farmId.equals(farmId) & t.status.equals('archived'))
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

  // 7. [REMOVED] Get lots containing a specific animal - Use LotAnimalDao instead

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

  // 11. Update lot WITH farmId validation - returns Future<int>
  Future<int> updateLot(LotsTableCompanion lot, String farmId) {
    return (update(lotsTable)
          ..where((t) => t.id.equals(lot.id.value))
          ..where((t) => t.farmId.equals(farmId)))
        .write(lot);
  }

  // 12. Delete lot
  Future<int> deleteLot(String id) {
    return (delete(lotsTable)..where((t) => t.id.equals(id))).go();
  }

  // 13. Mark lot as completed (PHASE 1: KEEP for backward-compat, renamed to markAsClosed)
  Future<int> markAsCompleted(String id, String farmId) {
    return (update(lotsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(
      LotsTableCompanion(
        status: const Value('closed'),
        completed: const Value(true),
        completedAt: Value(DateTime.now()),
        synced: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // PHASE 1: ADD - Mark lot as closed with status
  Future<int> markAsClosed(String id, String farmId) {
    return (update(lotsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(
      LotsTableCompanion(
        status: const Value('closed'),
        completed: const Value(true),
        completedAt: Value(DateTime.now()),
        synced: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // PHASE 1: ADD - Mark lot as archived
  Future<int> markAsArchived(String id, String farmId) {
    return (update(lotsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(
      LotsTableCompanion(
        status: const Value('archived'),
        synced: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // 14. [REMOVED] Add animal to lot - Use LotAnimalDao.addAnimalToLot() instead

  // 15. [REMOVED] Remove animal from lot - Use LotAnimalDao.removeAnimalFromLot() instead

  // 16. Set lot type
  Future<int> setLotType(String id, String type, String farmId) {
    return (update(lotsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(
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

  // 18. Count open lots by farm (PHASE 1: add fallback)
  Future<int> countOpenByFarm(String farmId) async {
    final query = selectOnly(lotsTable)
      ..addColumns([lotsTable.id.count()])
      ..where(lotsTable.farmId.equals(farmId) &
          (lotsTable.status.equals('open') |
              (lotsTable.status.isNull() & lotsTable.completed.equals(false))));

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
  // PHASE 1: Only get OPEN treatment lots (not closed/archived)
  Future<List<LotsTableData>> findWithUpcomingWithdrawal(
      String farmId, DateTime beforeDate) {
    return (select(lotsTable)
          ..where((t) =>
              t.farmId.equals(farmId) &
              t.type.equals('treatment') &
              t.withdrawalEndDate.isSmallerOrEqualValue(beforeDate) &
              (t.status.equals('open') |
                  (t.status.isNull() & t.completed.equals(false))))
          ..orderBy([(t) => OrderingTerm.asc(t.withdrawalEndDate)]))
        .get();
  }

  // PHASE 2: ADD - Migration helper
  // Populate status column from completed boolean (run once in Phase 2)
  Future<int> migrateStatusFromCompleted() {
    return db.customUpdate('''
      UPDATE lots 
      SET status = CASE 
        WHEN completed = 1 THEN 'closed'
        ELSE 'open'
      END
      WHERE status IS NULL
    ''');
  }

  // ==================== Helper Methods ====================
  // [REMOVED] _encodeAnimalIds and _decodeAnimalIds
  // Use LotAnimalDao for managing animals in lots
}
