// lib/repositories/species_repository.dart
import '../drift/database.dart';
import '../models/animal_species.dart';
import 'package:drift/drift.dart' as drift;

class SpeciesRepository {
  final AppDatabase _db;

  SpeciesRepository(this._db);

  // 1. Get all species (ordered by displayOrder)
  Future<List<AnimalSpecies>> getAll() async {
    final data = await _db.speciesDao.findAll();
    return data.map((d) => _mapToModel(d)).toList();
  }

  // 2. Get species by ID
  Future<AnimalSpecies?> getById(String id) async {
    final data = await _db.speciesDao.findById(id);
    return data != null ? _mapToModel(data) : null;
  }

  // 3. Search species by name
  Future<List<AnimalSpecies>> search(String query) async {
    final data = await _db.speciesDao.searchByName(query);
    return data.map((d) => _mapToModel(d)).toList();
  }

  // 4. Create species
  Future<void> create(AnimalSpecies species) async {
    final companion = _mapToCompanion(species);
    await _db.speciesDao.insertSpecies(companion);
  }

  // 5. Update species
  Future<void> update(AnimalSpecies species) async {
    final companion = _mapToCompanion(species);
    await _db.speciesDao.updateSpecies(companion);
  }

  // 6. Delete species
  Future<void> delete(String id) async {
    await _db.speciesDao.deleteSpecies(id);
  }

  // 7. Count species
  Future<int> count() async {
    return await _db.speciesDao.countSpecies();
  }

  // 8. Check if species exists
  Future<bool> exists(String id) async {
    return await _db.speciesDao.exists(id);
  }

  // === MAPPERS ===

  AnimalSpecies _mapToModel(SpeciesTableData data) {
    return AnimalSpecies(
      id: data.id,
      nameFr: data.nameFr,
      nameEn: data.nameEn,
      nameAr: data.nameAr,
      icon: data.icon,
      displayOrder: data.displayOrder,
    );
  }

  SpeciesTableCompanion _mapToCompanion(AnimalSpecies species) {
    return SpeciesTableCompanion(
      id: drift.Value(species.id),
      nameFr: drift.Value(species.nameFr),
      nameEn: drift.Value(species.nameEn),
      nameAr: drift.Value(species.nameAr),
      icon: drift.Value(species.icon),
      displayOrder: drift.Value(species.displayOrder),
    );
  }
}
