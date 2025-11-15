// lib/drift/daos/farm_dao.dart
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/farms_table.dart';

part 'farm_dao.g.dart';

@DriftAccessor(tables: [FarmsTable])
class FarmDao extends DatabaseAccessor<AppDatabase> with _$FarmDaoMixin {
  FarmDao(super.db);

  // 1. Get all farms
  Future<List<FarmsTableData>> findAll() {
    return select(farmsTable).get();
  }

  // 2. Get farm by ID
  Future<FarmsTableData?> findById(String id) {
    return (select(farmsTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // 3. Get farm by cheptel number
  Future<FarmsTableData?> findByCheptelNumber(String cheptelNumber) {
    return (select(farmsTable)
          ..where((t) => t.cheptelNumber.equals(cheptelNumber)))
        .getSingleOrNull();
  }

  // 4. Insert farm
  Future<int> insertFarm(FarmsTableCompanion farm) {
    return into(farmsTable).insert(farm);
  }

  // 5. Update farm
  Future<bool> updateFarm(FarmsTableCompanion farm) {
    return update(farmsTable).replace(farm);
  }

  // 6. Delete farm (hard delete - used rarely, only for admin)
  Future<int> deleteFarm(String id) {
    return (delete(farmsTable)..where((t) => t.id.equals(id))).go();
  }

  // 7. Count farms
  Future<int> countFarms() {
    final query = selectOnly(farmsTable)..addColumns([farmsTable.id.count()]);

    return query.map((row) => row.read(farmsTable.id.count())!).getSingle();
  }

  // 8. Search farms by name
  Future<List<FarmsTableData>> searchByName(String query) {
    return (select(farmsTable)..where((t) => t.name.like('%$query%'))).get();
  }

  // 9. Get farms by owner
  Future<List<FarmsTableData>> findByOwnerId(String ownerId) {
    return (select(farmsTable)..where((t) => t.ownerId.equals(ownerId))).get();
  }

  // 10. Get farms by group
  Future<List<FarmsTableData>> findByGroupId(String groupId) {
    return (select(farmsTable)..where((t) => t.groupId.equals(groupId))).get();
  }
}
