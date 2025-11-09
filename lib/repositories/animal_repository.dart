// lib/repositories/animal_repository.dart
import 'dart:convert';
import 'package:drift/drift.dart';
import '../drift/database.dart';
import '../models/animal.dart';
import '../models/eid_change.dart';

class AnimalRepository {
  final AppDatabase _db;

  AnimalRepository(this._db);

  // ==================== MÉTHODES OBLIGATOIRES ====================

  /// 1. getAll - Liste par farmId
  Future<List<Animal>> getAll(String farmId) async {
    final items = await _db.animalDao.findByFarmId(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// 2. getById - Sécurité farmId
  Future<Animal?> getById(String id, String farmId) async {
    final item = await _db.animalDao.findById(id, farmId);
    if (item == null) return null;

    // Security check
    if (item.farmId != farmId) {
      throw Exception('Farm ID mismatch - Security violation');
    }

    return _mapToModel(item);
  }

  /// 3. create - Créer avec farmId
  Future<void> create(Animal animal, String farmId) async {
    final companion = _mapToCompanion(animal, farmId);
    await _db.animalDao.insertItem(companion);
  }

  /// 4. update - Vérifier farmId
  Future<void> update(Animal animal, String farmId) async {
    // Security check
    final existing = await _db.animalDao.findById(animal.id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Animal not found or farm mismatch');
    }

    final companion = _mapToCompanion(animal, farmId);
    await _db.animalDao.updateItem(companion);
  }

  /// 5. delete - Soft-delete
  Future<void> delete(String id, String farmId) async {
    await _db.animalDao.softDelete(id, farmId);
  }

  /// 6. getUnsynced - Phase 2 ready
  Future<List<Animal>> getUnsynced(String farmId) async {
    final items = await _db.animalDao.getUnsynced(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  // ==================== MÉTHODES MÉTIER SUPPLÉMENTAIRES ====================

  /// Rechercher par EID
  Future<Animal?> findByEid(String eid, String farmId) async {
    final item = await _db.animalDao.findByEid(eid, farmId);
    if (item == null) return null;
    return _mapToModel(item);
  }

  /// Rechercher par numéro officiel
  Future<Animal?> findByOfficialNumber(
      String officialNumber, String farmId) async {
    final item =
        await _db.animalDao.findByOfficialNumber(officialNumber, farmId);
    if (item == null) return null;
    return _mapToModel(item);
  }

  /// Filtrer par espèce
  Future<List<Animal>> findBySpecies(String speciesId, String farmId) async {
    final items = await _db.animalDao.findBySpecies(speciesId, farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Filtrer par statut
  Future<List<Animal>> findByStatus(String status, String farmId) async {
    final items = await _db.animalDao.findByStatus(status, farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Filtrer par sexe
  Future<List<Animal>> findBySex(String sex, String farmId) async {
    final items = await _db.animalDao.findBySex(sex, farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Compter animaux
  Future<int> count(String farmId) async {
    return await _db.animalDao.countByFarmId(farmId);
  }

  /// Obtenir les mères potentielles
  Future<List<Animal>> getPotentialMothers(String farmId) async {
    final items = await _db.animalDao.getPotentialMothers(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  // ==================== MAPPERS ====================

  /// Mapper AnimalsTableData vers Animal (model)
  Animal _mapToModel(AnimalsTableData data) {
    // Decode eidHistory from JSON
    List<EidChange>? eidHistory;
    if (data.eidHistory != null) {
      try {
        final jsonList = jsonDecode(data.eidHistory!) as List;
        eidHistory = jsonList
            .map((e) => EidChange.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        // Si erreur parsing, laisser null
        eidHistory = null;
      }
    }

    return Animal(
      id: data.id,
      farmId: data.farmId,
      currentEid: data.currentEid,
      eidHistory: eidHistory,
      officialNumber: data.officialNumber,
      birthDate: data.birthDate,
      sex: AnimalSex.values.firstWhere((e) => e.name == data.sex),
      motherId: data.motherId,
      status: AnimalStatus.values.firstWhere((e) => e.name == data.status),
      speciesId: data.speciesId,
      breedId: data.breedId,
      visualId: data.visualId,
      photoUrl: data.photoUrl,
      days: data.days,
      synced: data.synced,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      lastSyncedAt: data.lastSyncedAt,
      serverVersion: data.serverVersion,
    );
  }

  /// Mapper Animal (model) vers AnimalsTableCompanion
  AnimalsTableCompanion _mapToCompanion(Animal animal, String farmId) {
    // Encode eidHistory to JSON
    String? eidHistoryJson;
    if (animal.eidHistory != null && animal.eidHistory!.isNotEmpty) {
      eidHistoryJson =
          jsonEncode(animal.eidHistory!.map((e) => e.toJson()).toList());
    }

    return AnimalsTableCompanion(
      id: Value(animal.id),
      farmId: Value(farmId),
      currentEid: Value(animal.currentEid),
      eidHistory: Value(eidHistoryJson),
      officialNumber: Value(animal.officialNumber),
      birthDate: Value(animal.birthDate),
      sex: Value(animal.sex.name),
      motherId: Value(animal.motherId),
      status: Value(animal.status.name),
      speciesId: Value(animal.speciesId),
      breedId: Value(animal.breedId),
      visualId: Value(animal.visualId),
      photoUrl: Value(animal.photoUrl),
      days: Value(animal.days),
      synced: Value(animal.synced),
      createdAt: Value(animal.createdAt),
      updatedAt: Value(animal.updatedAt),
      lastSyncedAt: Value(animal.lastSyncedAt),
      serverVersion: Value(animal.serverVersion),
      deletedAt: const Value.absent(), // Pas de soft-delete à la création
    );
  }
}
