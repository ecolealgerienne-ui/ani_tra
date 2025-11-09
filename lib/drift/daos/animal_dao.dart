// lib/drift/daos/animal_dao.dart
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/animals_table.dart';

part 'animal_dao.g.dart';

@DriftAccessor(tables: [AnimalsTable])
class AnimalDao extends DatabaseAccessor<AppDatabase> with _$AnimalDaoMixin {
  AnimalDao(super.db);

  // ==================== MÉTHODES OBLIGATOIRES ====================

  /// 1. findByFarmId - TOUJOURS filtrer par farmId
  Future<List<AnimalsTableData>> findByFarmId(String farmId) {
    return (select(animalsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// 2. findById - Sécurité farmId
  Future<AnimalsTableData?> findById(String id, String farmId) {
    return (select(animalsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// 3. insert - Créer avec farmId
  Future<int> insertItem(AnimalsTableCompanion animal) {
    return into(animalsTable).insert(animal);
  }

  /// 4. update - Vérifier farmId
  Future<bool> updateItem(AnimalsTableCompanion animal) {
    return update(animalsTable).replace(animal);
  }

  /// 5. softDelete - Soft-delete (pas hard delete)
  Future<int> softDelete(String id, String farmId) {
    return (update(animalsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(AnimalsTableCompanion(
      deletedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// 6. getUnsynced - Phase 2 ready
  Future<List<AnimalsTableData>> getUnsynced(String farmId) {
    return (select(animalsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.synced.equals(false))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// 7. markSynced - Phase 2 ready
  Future<int> markSynced(String id, String farmId) {
    return (update(animalsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(AnimalsTableCompanion(
      synced: const Value(true),
      lastSyncedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // ==================== MÉTHODES MÉTIER SUPPLÉMENTAIRES ====================

  /// Rechercher par EID
  Future<AnimalsTableData?> findByEid(String eid, String farmId) {
    return (select(animalsTable)
          ..where((t) => t.currentEid.equals(eid))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Rechercher par numéro officiel
  Future<AnimalsTableData?> findByOfficialNumber(
      String officialNumber, String farmId) {
    return (select(animalsTable)
          ..where((t) => t.officialNumber.equals(officialNumber))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Filtrer par espèce
  Future<List<AnimalsTableData>> findBySpecies(
      String speciesId, String farmId) {
    return (select(animalsTable)
          ..where((t) => t.speciesId.equals(speciesId))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Filtrer par statut
  Future<List<AnimalsTableData>> findByStatus(String status, String farmId) {
    return (select(animalsTable)
          ..where((t) => t.status.equals(status))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Filtrer par sexe
  Future<List<AnimalsTableData>> findBySex(String sex, String farmId) {
    return (select(animalsTable)
          ..where((t) => t.sex.equals(sex))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Compter animaux par farmId
  Future<int> countByFarmId(String farmId) async {
    final count = countAll();
    final query = selectOnly(animalsTable)
      ..addColumns([count])
      ..where(animalsTable.farmId.equals(farmId))
      ..where(animalsTable.deletedAt.isNull());

    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Obtenir les mères potentielles (femelles vivantes)
  Future<List<AnimalsTableData>> getPotentialMothers(String farmId) {
    return (select(animalsTable)
          ..where((t) => t.sex.equals('female'))
          ..where((t) => t.status.equals('alive'))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }
}
