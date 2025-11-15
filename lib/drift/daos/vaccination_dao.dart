// lib/drift/daos/vaccination_dao.dart

import 'dart:convert';
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/vaccinations_table.dart';

part 'vaccination_dao.g.dart';

/// DAO pour la gestion des vaccinations
///
/// Gère les opérations CRUD sur les vaccinations avec:
/// - Filtrage par farmId (multi-tenancy)
/// - Filtrage par animal (individuel ou groupe)
/// - Soft-delete (audit trail)
/// - Support de synchronisation (Phase 2)
/// - Conversion JSON pour animalIds
@DriftAccessor(tables: [VaccinationsTable])
class VaccinationDao extends DatabaseAccessor<AppDatabase>
    with _$VaccinationDaoMixin {
  VaccinationDao(super.db);

  // === REQUIRED METHODS ===

  /// Récupère toutes les vaccinations d'une ferme (non supprimées)
  ///
  /// Filtre par:
  /// - farmId (multi-tenancy)
  /// - deletedAt IS NULL (soft-delete)
  /// Tri par date décroissante (plus récents d'abord)
  Future<List<VaccinationsTableData>> findByFarmId(String farmId) {
    return (select(vaccinationsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.vaccinationDate, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Récupère une vaccination par ID avec vérification farmId
  ///
  /// Security: Vérifie que la vaccination appartient bien à la ferme
  Future<VaccinationsTableData?> findById(String id, String farmId) {
    return (select(vaccinationsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Insère une nouvelle vaccination
  Future<int> insertItem(VaccinationsTableCompanion item) {
    return into(vaccinationsTable).insert(item);
  }

  /// Met à jour une vaccination existante
  Future<bool> updateItem(VaccinationsTableCompanion item) {
    return update(vaccinationsTable).replace(item);
  }

  /// Soft-delete d'une vaccination
  ///
  /// Ne supprime pas physiquement, marque comme supprimé
  /// pour garder l'audit trail et l'historique médical
  Future<int> softDelete(String id, String farmId) {
    return (update(vaccinationsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(VaccinationsTableCompanion(
      deletedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // === SYNC METHODS (Phase 2 ready) ===

  /// Récupère les vaccinations non synchronisées
  Future<List<VaccinationsTableData>> getUnsynced(String farmId) {
    return (select(vaccinationsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.synced.equals(false))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Marque une vaccination comme synchronisée
  Future<int> markSynced(String id, String farmId, int serverVersion) {
    return (update(vaccinationsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(VaccinationsTableCompanion(
      synced: const Value(true),
      lastSyncedAt: Value(DateTime.now()),
      serverVersion: Value(serverVersion),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // === BUSINESS QUERIES ===

  /// Récupère les vaccinations d'un animal
  ///
  /// Note: Filtrage sur animalId ET présence dans animalIds JSON
  /// nécessite traitement côté Dart car SQLite ne supporte pas JSON_CONTAINS
  Future<List<VaccinationsTableData>> findByAnimalId(
    String farmId,
    String animalId,
  ) {
    // On récupère toutes les vaccinations et on filtrera côté Dart
    return findByFarmId(farmId);
  }

  /// Récupère les vaccinations par type
  Future<List<VaccinationsTableData>> findByType(
    String farmId,
    String type,
  ) {
    return (select(vaccinationsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.type.equals(type))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.vaccinationDate, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Récupère les vaccinations par maladie
  Future<List<VaccinationsTableData>> findByDisease(
    String farmId,
    String disease,
  ) {
    return (select(vaccinationsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.disease.like('%$disease%'))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.vaccinationDate, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Récupère les vaccinations dans une période
  Future<List<VaccinationsTableData>> findByDateRange(
    String farmId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return (select(vaccinationsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.vaccinationDate.isBiggerOrEqualValue(startDate))
          ..where((t) => t.vaccinationDate.isSmallerOrEqualValue(endDate))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.vaccinationDate, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Récupère les vaccinations avec rappel à venir
  ///
  /// nextDueDate != null ET nextDueDate > maintenant
  Future<List<VaccinationsTableData>> findUpcomingReminders(
    String farmId,
  ) {
    final now = DateTime.now();
    return (select(vaccinationsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.nextDueDate.isNotNull())
          ..where((t) => t.nextDueDate.isBiggerThanValue(now))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.nextDueDate, mode: OrderingMode.asc),
          ]))
        .get();
  }

  /// Récupère les vaccinations dont le rappel est en retard
  ///
  /// nextDueDate != null ET nextDueDate < maintenant
  Future<List<VaccinationsTableData>> findOverdueReminders(
    String farmId,
  ) {
    final now = DateTime.now();
    return (select(vaccinationsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.nextDueDate.isNotNull())
          ..where((t) => t.nextDueDate.isSmallerThanValue(now))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.nextDueDate, mode: OrderingMode.asc),
          ]))
        .get();
  }

  /// Compte les vaccinations par animal
  ///
  /// Note: Compte uniquement les vaccinations individuelles (animalId non null)
  Future<int> countByAnimalId(String farmId, String animalId) async {
    final result = await (selectOnly(vaccinationsTable)
          ..addColumns([vaccinationsTable.id.count()])
          ..where(vaccinationsTable.farmId.equals(farmId))
          ..where(vaccinationsTable.animalId.equals(animalId))
          ..where(vaccinationsTable.deletedAt.isNull()))
        .getSingle();
    return result.read(vaccinationsTable.id.count()) ?? 0;
  }

  // === HELPER METHODS ===

  /// Parse une colonne JSON array en List String
  static List<String> parseJsonArray(String jsonString) {
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is List) {
        return decoded.cast<String>();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Encode une List String en JSON array
  static String encodeJsonArray(List<String> list) {
    return jsonEncode(list);
  }
}
