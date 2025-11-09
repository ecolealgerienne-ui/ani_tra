// lib/repositories/breed_repository.dart
import '../drift/database.dart';
import '../models/breed.dart';
import 'package:drift/drift.dart' as drift;

class BreedRepository {
  final AppDatabase _db;

  BreedRepository(this._db);

  // 1. Get all breeds (ordered by displayOrder)
  Future<List<Breed>> getAll() async {
    final data = await _db.breedDao.findAll();
    return data.map((d) => _mapToModel(d)).toList();
  }

  // 2. Get all active breeds
  Future<List<Breed>> getAllActive() async {
    final data = await _db.breedDao.findAllActive();
    return data.map((d) => _mapToModel(d)).toList();
  }

  // 3. Get breed by ID
  Future<Breed?> getById(String id) async {
    final data = await _db.breedDao.findById(id);
    return data != null ? _mapToModel(data) : null;
  }

  // 4. Get breeds by species ID
  Future<List<Breed>> getBySpeciesId(String speciesId) async {
    final data = await _db.breedDao.findBySpeciesId(speciesId);
    return data.map((d) => _mapToModel(d)).toList();
  }

  // 5. Get active breeds by species ID
  Future<List<Breed>> getActiveBySpeciesId(String speciesId) async {
    final data = await _db.breedDao.findActiveBySpeciesId(speciesId);
    return data.map((d) => _mapToModel(d)).toList();
  }

  // 6. Search breeds by name
  Future<List<Breed>> search(String query) async {
    final data = await _db.breedDao.searchByName(query);
    return data.map((d) => _mapToModel(d)).toList();
  }

  // 7. Create breed
  Future<void> create(Breed breed) async {
    final companion = _mapToCompanion(breed);
    await _db.breedDao.insertBreed(companion);
  }

  // 8. Update breed
  Future<void> update(Breed breed) async {
    final companion = _mapToCompanion(breed);
    await _db.breedDao.updateBreed(companion);
  }

  // 9. Delete breed
  Future<void> delete(String id) async {
    await _db.breedDao.deleteBreed(id);
  }

  // 10. Count breeds
  Future<int> count() async {
    return await _db.breedDao.countBreeds();
  }

  // 11. Count breeds by species
  Future<int> countBySpeciesId(String speciesId) async {
    return await _db.breedDao.countBySpeciesId(speciesId);
  }

  // 12. Check if breed exists
  Future<bool> exists(String id) async {
    return await _db.breedDao.exists(id);
  }

  // 13. Toggle active status
  Future<void> toggleActive(String id) async {
    await _db.breedDao.toggleActive(id);
  }

  // === MAPPERS ===

  Breed _mapToModel(BreedsTableData data) {
    return Breed(
      id: data.id,
      speciesId: data.speciesId,
      nameFr: data.nameFr,
      nameEn: data.nameEn,
      nameAr: data.nameAr,
      description: data.description,
      displayOrder: data.displayOrder,
      isActive: data.isActive,
    );
  }

  BreedsTableCompanion _mapToCompanion(Breed breed) {
    return BreedsTableCompanion(
      id: drift.Value(breed.id),
      speciesId: drift.Value(breed.speciesId),
      nameFr: drift.Value(breed.nameFr),
      nameEn: drift.Value(breed.nameEn),
      nameAr: drift.Value(breed.nameAr),
      description: breed.description != null 
        ? drift.Value(breed.description!) 
        : const drift.Value.absent(),
      displayOrder: drift.Value(breed.displayOrder),
      isActive: drift.Value(breed.isActive),
    );
  }
}
