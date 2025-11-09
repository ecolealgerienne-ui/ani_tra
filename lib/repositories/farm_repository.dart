// lib/repositories/farm_repository.dart
import '../drift/database.dart';
import '../models/farm.dart';
import 'package:drift/drift.dart' as drift;

class FarmRepository {
  final AppDatabase _db;

  FarmRepository(this._db);

  // 1. Get all farms
  Future<List<Farm>> getAll() async {
    final data = await _db.farmDao.findAll();
    return data.map((d) => _mapToModel(d)).toList();
  }

  // 2. Get farm by ID
  Future<Farm?> getById(String id) async {
    final data = await _db.farmDao.findById(id);
    return data != null ? _mapToModel(data) : null;
  }

  // 3. Get farm by cheptel number
  Future<Farm?> getByCheptelNumber(String cheptelNumber) async {
    final data = await _db.farmDao.findByCheptelNumber(cheptelNumber);
    return data != null ? _mapToModel(data) : null;
  }

  // 4. Search farms by name
  Future<List<Farm>> search(String query) async {
    final data = await _db.farmDao.searchByName(query);
    return data.map((d) => _mapToModel(d)).toList();
  }

  // 5. Get farms by owner
  Future<List<Farm>> getByOwnerId(String ownerId) async {
    final data = await _db.farmDao.findByOwnerId(ownerId);
    return data.map((d) => _mapToModel(d)).toList();
  }

  // 6. Get farms by group
  Future<List<Farm>> getByGroupId(String groupId) async {
    final data = await _db.farmDao.findByGroupId(groupId);
    return data.map((d) => _mapToModel(d)).toList();
  }

  // 7. Create farm
  Future<void> create(Farm farm) async {
    final companion = _mapToCompanion(farm);
    await _db.farmDao.insertFarm(companion);
  }

  // 8. Update farm
  Future<void> update(Farm farm) async {
    final companion = _mapToCompanion(farm);
    await _db.farmDao.updateFarm(companion);
  }

  // 9. Delete farm
  Future<void> delete(String id) async {
    await _db.farmDao.deleteFarm(id);
  }

  // 10. Count farms
  Future<int> count() async {
    return await _db.farmDao.countFarms();
  }

  // === MAPPERS ===

  Farm _mapToModel(FarmsTableData data) {
    return Farm(
      id: data.id,
      name: data.name,
      location: data.location,
      ownerId: data.ownerId,
      cheptelNumber: data.cheptelNumber,
      groupId: data.groupId,
      groupName: data.groupName,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  FarmsTableCompanion _mapToCompanion(Farm farm) {
    return FarmsTableCompanion(
      id: drift.Value(farm.id),
      name: drift.Value(farm.name),
      location: drift.Value(farm.location),
      ownerId: drift.Value(farm.ownerId),
      cheptelNumber: farm.cheptelNumber != null
          ? drift.Value(farm.cheptelNumber!)
          : const drift.Value.absent(),
      groupId: farm.groupId != null
          ? drift.Value(farm.groupId!)
          : const drift.Value.absent(),
      groupName: farm.groupName != null
          ? drift.Value(farm.groupName!)
          : const drift.Value.absent(),
      createdAt: drift.Value(farm.createdAt),
      updatedAt: drift.Value(farm.updatedAt),
    );
  }
}
