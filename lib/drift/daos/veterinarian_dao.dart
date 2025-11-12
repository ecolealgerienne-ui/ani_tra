// lib/drift/daos/veterinarian_dao.dart

import 'dart:convert';
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/veterinarians_table.dart';

part 'veterinarian_dao.g.dart';

/// DAO pour la gestion des vétérinaires
///
/// Gère les opérations CRUD sur les vétérinaires avec:
/// - Filtrage par farmId (multi-tenancy)
/// - Soft-delete (audit trail)
/// - Support de synchronisation (Phase 2)
/// - Conversion JSON pour specialties
@DriftAccessor(tables: [VeterinariansTable])
class VeterinarianDao extends DatabaseAccessor<AppDatabase>
    with _$VeterinarianDaoMixin {
  VeterinarianDao(super.db);

  // === REQUIRED METHODS ===

  /// Récupère tous les vétérinaires d'une ferme (non supprimés)
  ///
  /// Filtre par:
  /// - farmId (multi-tenancy)
  /// - deletedAt IS NULL (soft-delete)
  /// Tri par nom (lastName, firstName)
  Future<List<VeterinariansTableData>> findByFarmId(String farmId) {
    return (select(veterinariansTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(expression: t.lastName, mode: OrderingMode.asc),
            (t) =>
                OrderingTerm(expression: t.firstName, mode: OrderingMode.asc),
          ]))
        .get();
  }

  /// Récupère un vétérinaire par ID avec vérification farmId
  ///
  /// Security: Vérifie que le vétérinaire appartient bien à la ferme
  Future<VeterinariansTableData?> findById(String id, String farmId) {
    return (select(veterinariansTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Insère un nouveau vétérinaire
  Future<int> insertItem(VeterinariansTableCompanion item) {
    return into(veterinariansTable).insert(item);
  }

  /// Met à jour un vétérinaire existant
  Future<bool> updateItem(VeterinariansTableCompanion item) {
    return update(veterinariansTable).replace(item);
  }

  /// Soft-delete d'un vétérinaire
  ///
  /// Ne supprime pas physiquement, marque comme supprimé
  /// pour garder l'audit trail et l'historique des interventions
  Future<int> softDelete(String id, String farmId) {
    return (update(veterinariansTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(VeterinariansTableCompanion(
      deletedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // === SYNC METHODS (Phase 2 ready) ===

  /// Récupère les vétérinaires non synchronisés
  Future<List<VeterinariansTableData>> getUnsynced(String farmId) {
    return (select(veterinariansTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.synced.equals(false))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Marque un vétérinaire comme synchronisé
  Future<int> markSynced(String id, String farmId, int serverVersion) {
    return (update(veterinariansTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(VeterinariansTableCompanion(
      synced: const Value(true),
      lastSyncedAt: Value(DateTime.now()),
      serverVersion: Value(serverVersion),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // === BUSINESS QUERIES ===

  /// Récupère les vétérinaires actifs d'une ferme
  Future<List<VeterinariansTableData>> findActiveByFarmId(String farmId) {
    return (select(veterinariansTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.isActive.equals(true))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(expression: t.lastName, mode: OrderingMode.asc),
            (t) =>
                OrderingTerm(expression: t.firstName, mode: OrderingMode.asc),
          ]))
        .get();
  }

  /// Récupère les vétérinaires disponibles
  Future<List<VeterinariansTableData>> findAvailable(String farmId) {
    return (select(veterinariansTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.isActive.equals(true))
          ..where((t) => t.isAvailable.equals(true))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(expression: t.lastName, mode: OrderingMode.asc),
            (t) =>
                OrderingTerm(expression: t.firstName, mode: OrderingMode.asc),
          ]))
        .get();
  }

  /// Récupère le vétérinaire par défaut
  Future<VeterinariansTableData?> findDefault(String farmId) {
    return (select(veterinariansTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.isDefault.equals(true))
          ..where((t) => t.deletedAt.isNull())
          ..limit(1))
        .getSingleOrNull();
  }

  /// Récupère les vétérinaires préférés
  Future<List<VeterinariansTableData>> findPreferred(String farmId) {
    return (select(veterinariansTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.isPreferred.equals(true))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(expression: t.rating, mode: OrderingMode.desc),
            (t) => OrderingTerm(expression: t.lastName, mode: OrderingMode.asc),
          ]))
        .get();
  }

  /// Récupère les vétérinaires avec service d'urgence
  Future<List<VeterinariansTableData>> findWithEmergencyService(String farmId) {
    return (select(veterinariansTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.emergencyService.equals(true))
          ..where((t) => t.isActive.equals(true))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(expression: t.lastName, mode: OrderingMode.asc),
          ]))
        .get();
  }

  /// Recherche de vétérinaires par nom
  Future<List<VeterinariansTableData>> searchByName(
    String farmId,
    String query,
  ) {
    final pattern = '%${query.toLowerCase()}%';
    return (select(veterinariansTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull())
          ..where((t) =>
              t.firstName.lower().like(pattern) |
              t.lastName.lower().like(pattern))
          ..orderBy([
            (t) => OrderingTerm(expression: t.lastName, mode: OrderingMode.asc),
            (t) =>
                OrderingTerm(expression: t.firstName, mode: OrderingMode.asc),
          ]))
        .get();
  }

  /// Incrémente le compteur d'interventions
  Future<int> incrementInterventions(String id, String farmId) async {
    final vet = await findById(id, farmId);
    if (vet == null) return 0;

    return (update(veterinariansTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(VeterinariansTableCompanion(
      totalInterventions: Value(vet.totalInterventions + 1),
      lastInterventionDate: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
      synced: const Value(false), // À resynchroniser
    ));
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
