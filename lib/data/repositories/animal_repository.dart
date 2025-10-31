// lib/data/repositories/animal_repository.dart
import '../mappers/animal_mapper.dart' as mapper;
import '../local/daos/animal_dao.dart';
import '../../models/animal.dart' as model;

class AnimalRepository {
  final AnimalDao _dao;
  AnimalRepository({required AnimalDao dao}) : _dao = dao;

  /// Liste des animaux (non supprimés)
  Future<List<model.Animal>> list() async {
    final rows = await _dao.getAll(); // types générés par Drift
    return rows.map(mapper.fromDb).toList();
  }

  /// Récupère un animal par id
  Future<model.Animal?> get(String id) async {
    final row = await _dao.getById(id);
    return row != null ? mapper.fromDb(row) : null;
  }

  /// Crée ou met à jour un animal
  Future<void> upsert(model.Animal animal) async {
    final companion = mapper.toCompanion(animal);
    await _dao.upsert(companion);
  }

  /// Upsert en batch
  Future<void> upsertMany(List<model.Animal> animals) async {
    if (animals.isEmpty) return;
    final companions = animals.map(mapper.toCompanion).toList();
    await _dao.upsertMany(companions);
  }

  /// Soft-delete
  Future<void> softDelete(String id) => _dao.softDelete(id);

  /// Pour diagnostics/tests
  Future<int> countActive() => _dao.countActive();
}
