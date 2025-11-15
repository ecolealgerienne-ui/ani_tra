// lib/drift/daos/farm_preferences_dao.dart

import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/farm_preferences_table.dart';

part 'farm_preferences_dao.g.dart';

/// Data Access Object pour les préférences de ferme
/// Gère toutes les opérations de lecture/écriture sur la table FarmPreferencesTable
@DriftAccessor(tables: [FarmPreferencesTable])
class FarmPreferencesDao extends DatabaseAccessor<AppDatabase>
    with _$FarmPreferencesDaoMixin {
  FarmPreferencesDao(super.db);

  /// Récupère les préférences pour une ferme spécifique (non supprimées)
  /// Retourne une seule row car farmId est unique
  /// Utilisé par FarmPreferencesProvider pour charger les préférences
  Future<FarmPreferencesTableData?> getByFarmId(String farmId) {
    return (select(farmPreferencesTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Récupère une préférence spécifique par ID et ferme
  /// Vérification de sécurité: farmId doit correspondre
  Future<FarmPreferencesTableData?> findById(String id, String farmId) {
    return (select(farmPreferencesTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Récupère toutes les préférences (non supprimées)
  /// Utilisé pour les écrans d'administration multi-fermes
  Future<List<FarmPreferencesTableData>> findAll() {
    return (select(farmPreferencesTable)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
        .get();
  }

  /// Insère de nouvelles préférences de ferme
  Future<int> insertItem(FarmPreferencesTableCompanion item) {
    return into(farmPreferencesTable).insert(item);
  }

  /// Met à jour des préférences existantes
  Future<bool> updateItem(FarmPreferencesTableCompanion item) {
    return update(farmPreferencesTable).replace(item);
  }

  /// Soft-delete des préférences (mark as deleted, don't remove)
  /// Préserve l'historique pour audit trail
  Future<int> softDelete(String id, String farmId) {
    return (update(farmPreferencesTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(FarmPreferencesTableCompanion(
      deletedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Récupère les préférences non synchronisées (Phase 2)
  /// Utilisé par SyncService pour envoyer les données au serveur
  Future<List<FarmPreferencesTableData>> getUnsynced(String farmId) {
    return (select(farmPreferencesTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.synced.equals(false))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
        .get();
  }

  /// Marque des préférences comme synchronisées (Phase 2)
  /// Appelé après confirmation du serveur
  Future<int> markSynced(String id, String farmId, {String? serverVersion}) {
    return (update(farmPreferencesTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(FarmPreferencesTableCompanion(
      synced: const Value(true),
      lastSyncedAt: Value(DateTime.now()),
      serverVersion:
          serverVersion != null ? Value(serverVersion) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Compte le nombre de préférences actives (non supprimées)
  Future<int> count() {
    return (selectOnly(farmPreferencesTable)
          ..addColumns([farmPreferencesTable.id.count()])
          ..where(farmPreferencesTable.deletedAt.isNull()))
        .map((row) => row.read(farmPreferencesTable.id.count()) ?? 0)
        .getSingle();
  }

  /// Vérifie si une ferme a déjà des préférences configurées
  Future<bool> hasPreferences(String farmId) async {
    final prefs = await getByFarmId(farmId);
    return prefs != null;
  }
}
