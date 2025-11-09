// lib/drift/daos/breeding_dao.dart
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/breedings_table.dart';

part 'breeding_dao.g.dart';

@DriftAccessor(tables: [BreedingsTable])
class BreedingDao extends DatabaseAccessor<AppDatabase>
    with _$BreedingDaoMixin {
  BreedingDao(super.db);

  // ==================== MÉTHODES OBLIGATOIRES ====================

  /// 1. findByFarmId - TOUJOURS filtrer par farmId
  Future<List<BreedingsTableData>> findByFarmId(String farmId) {
    return (select(breedingsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// 2. findById - Sécurité farmId
  Future<BreedingsTableData?> findById(String id, String farmId) {
    return (select(breedingsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// 3. insert - Créer avec farmId
  Future<int> insertItem(BreedingsTableCompanion breeding) {
    return into(breedingsTable).insert(breeding);
  }

  /// 4. update - Vérifier farmId
  Future<bool> updateItem(BreedingsTableCompanion breeding) {
    return update(breedingsTable).replace(breeding);
  }

  /// 5. softDelete - Soft-delete (pas hard delete)
  Future<int> softDelete(String id, String farmId) {
    return (update(breedingsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(BreedingsTableCompanion(
      deletedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// 6. getUnsynced - Phase 2 ready
  Future<List<BreedingsTableData>> getUnsynced(String farmId) {
    return (select(breedingsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.synced.equals(false))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// 7. markSynced - Phase 2 ready
  Future<int> markSynced(String id, String farmId, String serverVersion) {
    return (update(breedingsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(BreedingsTableCompanion(
      synced: const Value(true),
      lastSyncedAt: Value(DateTime.now()),
      serverVersion: Value(serverVersion),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // ==================== MÉTHODES MÉTIER SUPPLÉMENTAIRES ====================

  /// Filtrer par mère
  Future<List<BreedingsTableData>> findByMother(
      String motherId, String farmId) {
    return (select(breedingsTable)
          ..where((t) => t.motherId.equals(motherId))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Filtrer par père
  Future<List<BreedingsTableData>> findByFather(
      String fatherId, String farmId) {
    return (select(breedingsTable)
          ..where((t) => t.fatherId.equals(fatherId))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Filtrer par statut
  Future<List<BreedingsTableData>> findByStatus(String status, String farmId) {
    return (select(breedingsTable)
          ..where((t) => t.status.equals(status))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Filtrer par méthode de reproduction
  Future<List<BreedingsTableData>> findByMethod(String method, String farmId) {
    return (select(breedingsTable)
          ..where((t) => t.method.equals(method))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Obtenir les reproductions en attente (pending)
  Future<List<BreedingsTableData>> findPending(String farmId) {
    return (select(breedingsTable)
          ..where((t) => t.status.equals('pending'))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Obtenir les reproductions en retard (overdue)
  Future<List<BreedingsTableData>> findOverdue(String farmId) {
    final now = DateTime.now();
    return (select(breedingsTable)
          ..where((t) => t.status.equals('pending'))
          ..where((t) => t.expectedBirthDate.isSmallerThanValue(now))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Obtenir les reproductions dont la mise-bas est proche (dans les 7 prochains jours)
  Future<List<BreedingsTableData>> findBirthSoon(String farmId) {
    final now = DateTime.now();
    final sevenDaysLater = now.add(const Duration(days: 7));
    return (select(breedingsTable)
          ..where((t) => t.status.equals('pending'))
          ..where((t) => t.expectedBirthDate.isBiggerOrEqualValue(now))
          ..where(
              (t) => t.expectedBirthDate.isSmallerOrEqualValue(sevenDaysLater))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Obtenir les reproductions par vétérinaire (IA)
  Future<List<BreedingsTableData>> findByVeterinarian(
      String veterinarianId, String farmId) {
    return (select(breedingsTable)
          ..where((t) => t.veterinarianId.equals(veterinarianId))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Obtenir les reproductions dans une plage de dates
  Future<List<BreedingsTableData>> findByDateRange(
      String farmId, DateTime startDate, DateTime endDate) {
    return (select(breedingsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.breedingDate.isBiggerOrEqualValue(startDate))
          ..where((t) => t.breedingDate.isSmallerOrEqualValue(endDate))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Compter reproductions par farmId
  Future<int> countByFarmId(String farmId) async {
    final count = countAll();
    final query = selectOnly(breedingsTable)
      ..addColumns([count])
      ..where(breedingsTable.farmId.equals(farmId))
      ..where(breedingsTable.deletedAt.isNull());

    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Compter reproductions pending par farmId
  Future<int> countPendingByFarmId(String farmId) async {
    final count = countAll();
    final query = selectOnly(breedingsTable)
      ..addColumns([count])
      ..where(breedingsTable.farmId.equals(farmId))
      ..where(breedingsTable.status.equals('pending'))
      ..where(breedingsTable.deletedAt.isNull());

    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }
}
