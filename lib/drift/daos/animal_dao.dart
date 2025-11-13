// lib/drift/daos/animal_dao.dart
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/animals_table.dart';

part 'animal_dao.g.dart';

@DriftAccessor(tables: [AnimalsTable])
class AnimalDao extends DatabaseAccessor<AppDatabase> with _$AnimalDaoMixin {
  AnimalDao(super.db);

  // ==================== MÃ‰THODES OBLIGATOIRES ====================

  /// 1. findByFarmId - TOUJOURS filtrer par farmId
  Future<List<AnimalsTableData>> findByFarmId(String farmId) {
    return (select(animalsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// 2. findById - SÃ©curitÃ© farmId
  Future<AnimalsTableData?> findById(String id, String farmId) {
    return (select(animalsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// 3. insert - CrÃ©er avec farmId
  Future<int> insertItem(AnimalsTableCompanion animal) {
    return into(animalsTable).insert(animal);
  }

  /// 4. update - VÃ©rifier farmId (B1 FIX: farmId parameter mandatory)
  /// âš ï¸ IMPORTANT: farmId est OBLIGATOIRE pour Ã©viter les violations de multi-tenancy
  /// 4. update - VÃ©rifier farmId (B1 FIX: farmId parameter mandatory)
  /// âš ï¸ IMPORTANT: farmId est OBLIGATOIRE pour Ã©viter les violations de multi-tenancy
  /// Retourne le nombre de lignes affectÃ©es (doit Ãªtre > 0)
  Future<int> updateItem(AnimalsTableCompanion animal, String farmId) {
    return (update(animalsTable)
          ..where((t) => t.id.equals(animal.id.value))
          ..where((t) => t.farmId.equals(farmId)))
        .write(animal);
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

  // ==================== MÃ‰THODES MÃ‰TIER SUPPLÃ‰MENTAIRES ====================

  /// Rechercher par EID
  Future<AnimalsTableData?> findByEid(String eid, String farmId) {
    return (select(animalsTable)
          ..where((t) => t.currentEid.equals(eid))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Rechercher par numÃ©ro officiel
  Future<AnimalsTableData?> findByOfficialNumber(
      String officialNumber, String farmId) {
    return (select(animalsTable)
          ..where((t) => t.officialNumber.equals(officialNumber))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Filtrer par espÃ¨ce
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

  /// B3 FIX: Compter animaux par farmId (optimisÃ©)
  Future<int> countByFarmId(String farmId) async {
    final count = countAll();
    final query = selectOnly(animalsTable)
      ..addColumns([count])
      ..where(animalsTable.farmId.equals(farmId))
      ..where(animalsTable.deletedAt.isNull());

    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Obtenir les mÃ¨res potentielles (femelles vivantes)
  Future<List<AnimalsTableData>> getPotentialMothers(String farmId) {
    return (select(animalsTable)
          ..where((t) => t.sex.equals('female'))
          ..where((t) => t.status.equals('alive'))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  // ==================== PRIORITY 3: AMÃ‰LIORATIONS ====================

  /// A1: Rechercher par plage de date de naissance
  Future<List<AnimalsTableData>> findByBirthDateRange(
    String farmId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return (select(animalsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.birthDate.isBetweenValues(startDate, endDate))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// A1: Rechercher par plage d'Ã¢ge en jours
  Future<List<AnimalsTableData>> findByAgeRangeInDays(
    String farmId,
    int minDays,
    int maxDays,
  ) {
    final now = DateTime.now();
    final maxBirthDate = now.subtract(Duration(days: minDays));
    final minBirthDate = now.subtract(Duration(days: maxDays));

    return (select(animalsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where(
              (t) => t.birthDate.isBetweenValues(minBirthDate, maxBirthDate))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// A2: Recherche composÃ©e: espÃ¨ce + statut
  Future<List<AnimalsTableData>> findBySpeciesAndStatus(
    String farmId,
    String speciesId,
    String status,
  ) {
    return (select(animalsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.speciesId.equals(speciesId))
          ..where((t) => t.status.equals(status))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// A2: Recherche composÃ©e: statut + sexe
  Future<List<AnimalsTableData>> findByStatusAndSex(
    String farmId,
    String status,
    String sex,
  ) {
    return (select(animalsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.status.equals(status))
          ..where((t) => t.sex.equals(sex))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// A3: Obtenir femelles en Ã¢ge de reproduction (logique avancÃ©e)
  /// Utilise l'index idx_animals_farm_status pour perf
  Future<List<AnimalsTableData>> getFemalesOfReproductiveAge(String farmId) {
    return (select(animalsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.sex.equals('female'))
          ..where((t) => t.status.equals('alive'))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// A4: Pagination: obtenir animaux avec limite et offset
  Future<List<AnimalsTableData>> findByFarmIdPaginated(
    String farmId, {
    required int limit,
    required int offset,
  }) {
    return (select(animalsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
          ])
          ..limit(limit, offset: offset))
        .get();
  }

  /// Compter total animaux par ferme (pour pagination)
  Future<int> countByFarmIdForPagination(String farmId) {
    return countByFarmId(farmId);
  }

  // ==================== DRAFT SYSTEM QUERIES ====================

  /// Obtenir tous les animaux DRAFT (non validés) d'une ferme
  Future<List<AnimalsTableData>> findDraftAnimals(String farmId) {
    return (select(animalsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.status.equals('draft'))
          ..where((t) => t.validatedAt.isNull())
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Obtenir les DRAFT créés avant une date donnée (pour alertes)
  Future<List<AnimalsTableData>> findDraftOlderThan(
    String farmId,
    DateTime beforeDate,
  ) {
    return (select(animalsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.status.equals('draft'))
          ..where((t) => t.validatedAt.isNull())
          ..where((t) => t.createdAt.isSmallerThanValue(beforeDate))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Valider un animal (mettre à jour status + validatedAt)
  Future<int> validateAnimal(String id, String farmId) {
    return (update(animalsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(AnimalsTableCompanion(
      status: const Value('alive'),
      validatedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }
}
