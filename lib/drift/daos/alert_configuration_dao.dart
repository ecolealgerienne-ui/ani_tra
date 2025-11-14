// lib/drift/daos/alert_configuration_dao.dart

import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/alert_configurations_table.dart';

part 'alert_configuration_dao.g.dart';

/// Data Access Object pour les configurations d'alertes
/// Gère toutes les opérations de lecture/écriture sur la table AlertConfigurationsTable
@DriftAccessor(tables: [AlertConfigurationsTable])
class AlertConfigurationDao extends DatabaseAccessor<AppDatabase>
    with _$AlertConfigurationDaoMixin {
  AlertConfigurationDao(super.db);

  /// Récupère toutes les configurations pour une ferme (non supprimées)
  /// Utilisé pour les écrans d'administration des alertes
  Future<List<AlertConfigurationData>> findByFarmId(String farmId) {
    return (select(alertConfigurationsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(expression: t.severity, mode: OrderingMode.desc)
          ]))
        .get();
  }

  /// Récupère les configurations ACTIVÉES pour une ferme
  /// Utilisé par AlertProvider pour générer les alertes
  /// Cette méthode est critique pour la performance
  Future<List<AlertConfigurationData>> findByFarmIdAndEnabled(String farmId) {
    return (select(alertConfigurationsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.enabled.equals(true))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(expression: t.severity, mode: OrderingMode.desc)
          ]))
        .get();
  }

  /// Récupère une configuration spécifique par ID et ferme
  /// Vérification de sécurité: farmId doit correspondre
  Future<AlertConfigurationData?> findById(String id, String farmId) {
    return (select(alertConfigurationsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Récupère une configuration par type d'évaluation et ferme
  /// Chaque ferme ne peut avoir qu'une config par type d'évaluation
  Future<AlertConfigurationData?> findByEvaluationType(
    String farmId,
    String evaluationType,
  ) {
    return (select(alertConfigurationsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.evaluationType.equals(evaluationType))
          ..where((t) => t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Insère une nouvelle configuration d'alerte
  Future<int> insertItem(AlertConfigurationsTableCompanion item) {
    return into(alertConfigurationsTable).insert(item);
  }

  /// Met à jour une configuration existante
  Future<bool> updateItem(AlertConfigurationsTableCompanion item) {
    return update(alertConfigurationsTable).replace(item);
  }

  /// Soft-delete une configuration (mark as deleted, don't remove)
  /// Préserve l'historique pour audit trail
  Future<int> softDelete(String id, String farmId) {
    return (update(alertConfigurationsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(AlertConfigurationsTableCompanion(
      deletedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Récupère les configurations non synchronisées (Phase 2)
  /// Utilisé par SyncService pour envoyer les données au serveur
  Future<List<AlertConfigurationData>> getUnsynced(String farmId) {
    return (select(alertConfigurationsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.synced.equals(false))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
        .get();
  }

  /// Marque une configuration comme synchronisée (Phase 2)
  /// Appelé après confirmation du serveur
  Future<int> markSynced(String id, String farmId, {String? serverVersion}) {
    return (update(alertConfigurationsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(AlertConfigurationsTableCompanion(
      synced: const Value(true),
      lastSyncedAt: Value(DateTime.now()),
      serverVersion:
          serverVersion != null ? Value(serverVersion) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Bascule l'activation/désactivation d'une configuration
  /// Permet à l'utilisateur de désactiver des types d'alertes sans les supprimer
  Future<int> toggleEnabled(String id, String farmId, bool newState) {
    return (update(alertConfigurationsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(AlertConfigurationsTableCompanion(
      enabled: Value(newState),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Compte le nombre de configurations actives par ferme
  Future<int> countEnabled(String farmId) {
    return (selectOnly(alertConfigurationsTable)
          ..addColumns([alertConfigurationsTable.id.count()])
          ..where(alertConfigurationsTable.farmId.equals(farmId))
          ..where(alertConfigurationsTable.enabled.equals(true))
          ..where(alertConfigurationsTable.deletedAt.isNull()))
        .map((row) => row.read(alertConfigurationsTable.id.count()) ?? 0)
        .getSingle();
  }
}
