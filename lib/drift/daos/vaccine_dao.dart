// lib/drift/daos/vaccine_dao.dart

import 'dart:convert';
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/vaccines_table.dart';

part 'vaccine_dao.g.dart';

/// DAO pour la gestion des références de vaccins
/// 
/// Gère les opérations CRUD sur les vaccins avec:
/// - Filtrage par farmId (multi-tenancy)
/// - Soft-delete (audit trail)
/// - Support de synchronisation (Phase 2)
/// - Conversion JSON pour targetSpecies et targetDiseases
@DriftAccessor(tables: [VaccinesTable])
class VaccineDao extends DatabaseAccessor<AppDatabase> with _$VaccineDaoMixin {
  VaccineDao(super.db);

  // === REQUIRED METHODS ===

  /// Récupère tous les vaccins d'une ferme (non supprimés)
  /// 
  /// Filtre par:
  /// - farmId (multi-tenancy)
  /// - deletedAt IS NULL (soft-delete)
  Future<List<VaccinesTableData>> findByFarmId(String farmId) {
    return (select(vaccinesTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc),
          ]))
        .get();
  }

  /// Récupère un vaccin par ID avec vérification farmId
  /// 
  /// Security: Vérifie que le vaccin appartient bien à la ferme
  Future<VaccinesTableData?> findById(String id, String farmId) {
    return (select(vaccinesTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Insère un nouveau vaccin
  Future<int> insertItem(VaccinesTableCompanion item) {
    return into(vaccinesTable).insert(item);
  }

  /// Met à jour un vaccin existant
  Future<bool> updateItem(VaccinesTableCompanion item) {
    return update(vaccinesTable).replace(item);
  }

  /// Soft-delete d'un vaccin
  /// 
  /// Ne supprime pas physiquement, marque comme supprimé
  /// pour garder l'audit trail
  Future<int> softDelete(String id, String farmId) {
    return (update(vaccinesTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(VaccinesTableCompanion(
      deletedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // === SYNC METHODS (Phase 2 ready) ===

  /// Récupère les vaccins non synchronisés
  Future<List<VaccinesTableData>> getUnsynced(String farmId) {
    return (select(vaccinesTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.synced.equals(false))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Marque un vaccin comme synchronisé
  Future<int> markSynced(String id, String farmId, int serverVersion) {
    return (update(vaccinesTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(VaccinesTableCompanion(
      synced: const Value(true),
      lastSyncedAt: Value(DateTime.now()),
      serverVersion: Value(serverVersion),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // === BUSINESS QUERIES ===

  /// Récupère les vaccins actifs d'une ferme
  Future<List<VaccinesTableData>> findActiveByFarmId(String farmId) {
    return (select(vaccinesTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.isActive.equals(true))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc),
          ]))
        .get();
  }

  /// Recherche de vaccins par nom (pour autocomplete)
  Future<List<VaccinesTableData>> searchByName(String farmId, String query) {
    final pattern = '%${query.toLowerCase()}%';
    return (select(vaccinesTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull())
          ..where((t) => t.name.lower().like(pattern))
          ..orderBy([
            (t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc),
          ]))
        .get();
  }

  /// Récupère les vaccins compatibles avec une espèce
  /// 
  /// Note: Nécessite de parser le JSON targetSpecies côté app
  /// car SQLite ne supporte pas JSON_CONTAINS nativement
  Future<List<VaccinesTableData>> findCompatibleWithSpecies(
    String farmId,
    String species,
  ) {
    // On récupère tous les vaccins actifs et on filtrera côté Dart
    return findActiveByFarmId(farmId);
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
