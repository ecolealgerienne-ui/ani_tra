// lib/drift/daos/weight_dao.dart

import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/weights_table.dart';

part 'weight_dao.g.dart';

/// DAO pour la gestion des pesées
///
/// Gère les opérations CRUD sur les pesées avec:
/// - Filtrage par farmId (multi-tenancy)
/// - Filtrage par animal
/// - Soft-delete (audit trail)
/// - Support de synchronisation (Phase 2)
@DriftAccessor(tables: [WeightsTable])
class WeightDao extends DatabaseAccessor<AppDatabase> with _$WeightDaoMixin {
  WeightDao(super.db);

  // === REQUIRED METHODS ===

  /// Récupère toutes les pesées d'une ferme (non supprimées)
  ///
  /// Filtre par:
  /// - farmId (multi-tenancy)
  /// - deletedAt IS NULL (soft-delete)
  /// Tri par date décroissante (plus récentes d'abord)
  Future<List<WeightsTableData>> findByFarmId(String farmId) {
    return (select(weightsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.recordedAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Récupère une pesée par ID avec vérification farmId
  ///
  /// Security: Vérifie que la pesée appartient bien à la ferme
  Future<WeightsTableData?> findById(String id, String farmId) {
    return (select(weightsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Insère une nouvelle pesée
  Future<int> insertItem(WeightsTableCompanion item) {
    return into(weightsTable).insert(item);
  }

  /// Met à jour une pesée existante
  Future<bool> updateItem(WeightsTableCompanion item) {
    return update(weightsTable).replace(item);
  }

  /// Soft-delete d'une pesée
  ///
  /// Ne supprime pas physiquement, marque comme supprimé
  /// pour garder l'audit trail et l'historique de croissance
  Future<int> softDelete(String id, String farmId) {
    return (update(weightsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(WeightsTableCompanion(
      deletedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // === SYNC METHODS (Phase 2 ready) ===

  /// Récupère les pesées non synchronisées
  Future<List<WeightsTableData>> getUnsynced(String farmId) {
    return (select(weightsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.synced.equals(false))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Marque une pesée comme synchronisée
  Future<int> markSynced(String id, String farmId, int serverVersion) {
    return (update(weightsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(WeightsTableCompanion(
      synced: const Value(true),
      lastSyncedAt: Value(DateTime.now()),
      serverVersion: Value(serverVersion),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // === BUSINESS QUERIES ===

  /// Récupère les pesées d'un animal
  ///
  /// Tri chronologique décroissant (plus récentes d'abord)
  Future<List<WeightsTableData>> findByAnimalId(
    String farmId,
    String animalId,
  ) {
    return (select(weightsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.animalId.equals(animalId))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.recordedAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Récupère la dernière pesée d'un animal
  Future<WeightsTableData?> findLatestByAnimalId(
    String farmId,
    String animalId,
  ) {
    return (select(weightsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.animalId.equals(animalId))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.recordedAt, mode: OrderingMode.desc),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Récupère les pesées dans une période
  Future<List<WeightsTableData>> findByDateRange(
    String farmId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return (select(weightsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.recordedAt.isBiggerOrEqualValue(startDate))
          ..where((t) => t.recordedAt.isSmallerOrEqualValue(endDate))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.recordedAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Récupère les pesées d'un animal dans une période
  Future<List<WeightsTableData>> findByAnimalIdAndDateRange(
    String farmId,
    String animalId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return (select(weightsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.animalId.equals(animalId))
          ..where((t) => t.recordedAt.isBiggerOrEqualValue(startDate))
          ..where((t) => t.recordedAt.isSmallerOrEqualValue(endDate))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.recordedAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Récupère les pesées par source
  Future<List<WeightsTableData>> findBySource(
    String farmId,
    String source,
  ) {
    return (select(weightsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.source.equals(source))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.recordedAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Récupère les pesées récentes (derniers X jours)
  Future<List<WeightsTableData>> findRecent(String farmId, int days) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return (select(weightsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.recordedAt.isBiggerOrEqualValue(cutoffDate))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.recordedAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Compte les pesées d'un animal
  Future<int> countByAnimalId(String farmId, String animalId) async {
    final result = await (selectOnly(weightsTable)
          ..addColumns([weightsTable.id.count()])
          ..where(weightsTable.farmId.equals(farmId))
          ..where(weightsTable.animalId.equals(animalId))
          ..where(weightsTable.deletedAt.isNull()))
        .getSingle();
    return result.read(weightsTable.id.count()) ?? 0;
  }

  /// Calcule le poids moyen d'un animal
  Future<double?> getAverageWeightByAnimalId(
    String farmId,
    String animalId,
  ) async {
    final result = await (selectOnly(weightsTable)
          ..addColumns([weightsTable.weight.avg()])
          ..where(weightsTable.farmId.equals(farmId))
          ..where(weightsTable.animalId.equals(animalId))
          ..where(weightsTable.deletedAt.isNull()))
        .getSingle();
    return result.read(weightsTable.weight.avg());
  }

  /// Récupère le poids minimum d'un animal
  Future<double?> getMinWeightByAnimalId(
    String farmId,
    String animalId,
  ) async {
    final result = await (selectOnly(weightsTable)
          ..addColumns([weightsTable.weight.min()])
          ..where(weightsTable.farmId.equals(farmId))
          ..where(weightsTable.animalId.equals(animalId))
          ..where(weightsTable.deletedAt.isNull()))
        .getSingle();
    return result.read(weightsTable.weight.min());
  }

  /// Récupère le poids maximum d'un animal
  Future<double?> getMaxWeightByAnimalId(
    String farmId,
    String animalId,
  ) async {
    final result = await (selectOnly(weightsTable)
          ..addColumns([weightsTable.weight.max()])
          ..where(weightsTable.farmId.equals(farmId))
          ..where(weightsTable.animalId.equals(animalId))
          ..where(weightsTable.deletedAt.isNull()))
        .getSingle();
    return result.read(weightsTable.weight.max());
  }
}
