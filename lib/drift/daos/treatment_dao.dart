// lib/drift/daos/treatment_dao.dart

import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/treatments_table.dart';

part 'treatment_dao.g.dart';

/// DAO pour la gestion des traitements
///
/// Gère les opérations CRUD sur les traitements avec:
/// - Filtrage par farmId (multi-tenancy)
/// - Filtrage par animal
/// - Soft-delete (audit trail)
/// - Support de synchronisation (Phase 2)
@DriftAccessor(tables: [TreatmentsTable])
class TreatmentDao extends DatabaseAccessor<AppDatabase>
    with _$TreatmentDaoMixin {
  TreatmentDao(super.db);

  // === REQUIRED METHODS ===

  /// Récupère tous les traitements d'une ferme (non supprimés)
  ///
  /// Filtre par:
  /// - farmId (multi-tenancy)
  /// - deletedAt IS NULL (soft-delete)
  /// Tri par date décroissante (plus récents d'abord)
  Future<List<TreatmentsTableData>> findByFarmId(String farmId) {
    return (select(treatmentsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.treatmentDate, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Récupère un traitement par ID avec vérification farmId
  ///
  /// Security: Vérifie que le traitement appartient bien à la ferme
  Future<TreatmentsTableData?> findById(String id, String farmId) {
    return (select(treatmentsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Insère un nouveau traitement
  Future<int> insertItem(TreatmentsTableCompanion item) {
    return into(treatmentsTable).insert(item);
  }

  /// Met à jour un traitement existant
  Future<bool> updateItem(TreatmentsTableCompanion item) {
    return update(treatmentsTable).replace(item);
  }

  /// Soft-delete d'un traitement
  ///
  /// Ne supprime pas physiquement, marque comme supprimé
  /// pour garder l'audit trail et l'historique médical
  Future<int> softDelete(String id, String farmId) {
    return (update(treatmentsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(TreatmentsTableCompanion(
      deletedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // === SYNC METHODS (Phase 2 ready) ===

  /// Récupère les traitements non synchronisés
  Future<List<TreatmentsTableData>> getUnsynced(String farmId) {
    return (select(treatmentsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.synced.equals(false))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Marque un traitement comme synchronisé
  Future<int> markSynced(String id, String farmId, int serverVersion) {
    return (update(treatmentsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(TreatmentsTableCompanion(
      synced: const Value(true),
      lastSyncedAt: Value(DateTime.now()),
      serverVersion: Value(serverVersion),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // === BUSINESS QUERIES ===

  /// Récupère les traitements d'un animal
  Future<List<TreatmentsTableData>> findByAnimalId(
    String farmId,
    String animalId,
  ) {
    return (select(treatmentsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.animalId.equals(animalId))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.treatmentDate, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Récupère les traitements d'une campagne
  Future<List<TreatmentsTableData>> findByCampaignId(
    String farmId,
    String campaignId,
  ) {
    return (select(treatmentsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.campaignId.equals(campaignId))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.treatmentDate, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Récupère les traitements d'un produit
  Future<List<TreatmentsTableData>> findByProductId(
    String farmId,
    String productId,
  ) {
    return (select(treatmentsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.productId.equals(productId))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.treatmentDate, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Récupère les traitements dans une période
  Future<List<TreatmentsTableData>> findByDateRange(
    String farmId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return (select(treatmentsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.treatmentDate.isBiggerOrEqualValue(startDate))
          ..where((t) => t.treatmentDate.isSmallerOrEqualValue(endDate))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.treatmentDate, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Récupère les traitements avec délai d'attente actif
  ///
  /// Traitements dont withdrawalEndDate > maintenant
  Future<List<TreatmentsTableData>> findActiveWithdrawalPeriods(
    String farmId,
  ) {
    final now = DateTime.now();
    return (select(treatmentsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.withdrawalEndDate.isBiggerThanValue(now))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.withdrawalEndDate, mode: OrderingMode.asc),
          ]))
        .get();
  }

  /// Récupère les traitements avec délai d'attente actif pour un animal
  Future<List<TreatmentsTableData>> findActiveWithdrawalPeriodsByAnimalId(
    String farmId,
    String animalId,
  ) {
    final now = DateTime.now();
    return (select(treatmentsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.animalId.equals(animalId))
          ..where((t) => t.withdrawalEndDate.isBiggerThanValue(now))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.withdrawalEndDate, mode: OrderingMode.asc),
          ]))
        .get();
  }

  /// Compte les traitements par animal
  Future<int> countByAnimalId(String farmId, String animalId) async {
    final result = await (selectOnly(treatmentsTable)
          ..addColumns([treatmentsTable.id.count()])
          ..where(treatmentsTable.farmId.equals(farmId))
          ..where(treatmentsTable.animalId.equals(animalId))
          ..where(treatmentsTable.deletedAt.isNull()))
        .getSingle();
    return result.read(treatmentsTable.id.count()) ?? 0;
  }
}
