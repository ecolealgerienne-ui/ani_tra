// lib/repositories/alert_configuration_repository.dart

import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart'; // ← ADD THIS LINE
import '../drift/database.dart';
import '../models/alert_configuration.dart';

/// Repository pour les configurations d'alertes
/// Couche métier entre Provider et DAO
/// Gère la sécurité (farmId validation) et le mapping
class AlertConfigurationRepository {
  final AppDatabase _db;
  static const _uuid = Uuid();

  AlertConfigurationRepository(this._db);

  /// Récupère toutes les configurations pour une ferme
  /// Non supprimées uniquement
  Future<List<AlertConfiguration>> getAll(String farmId) async {
    final data = await _db.alertConfigurationDao.findByFarmId(farmId);
    return data.map((d) => _mapToModel(d)).toList();
  }

  /// Récupère les configurations ACTIVÉES pour une ferme
  /// Utilisé par AlertProvider pour la génération d'alertes
  /// Triées par sévérité (critique → faible)
  Future<List<AlertConfiguration>> getEnabled(String farmId) async {
    final data = await _db.alertConfigurationDao.findByFarmIdAndEnabled(farmId);
    return data.map((d) => _mapToModel(d)).toList();
  }

  /// Récupère une configuration spécifique
  /// Sécurité: farmId doit correspondre
  Future<AlertConfiguration?> getById(String id, String farmId) async {
    final data = await _db.alertConfigurationDao.findById(id, farmId);
    if (data == null) return null;

    // Vérification de sécurité supplémentaire
    if (data.farmId != farmId) {
      throw Exception(
          'Security violation: Farm ID mismatch in AlertConfiguration');
    }

    return _mapToModel(data);
  }

  /// Récupère une configuration par type d'évaluation
  /// Chaque ferme n'a qu'une config par type
  Future<AlertConfiguration?> getByEvaluationType(
    String farmId,
    AlertEvaluationType evaluationType,
  ) async {
    final data = await _db.alertConfigurationDao.findByEvaluationType(
      farmId,
      evaluationType.toStringValue(),
    );
    if (data == null) return null;
    return _mapToModel(data);
  }

  /// Crée une nouvelle configuration d'alerte
  /// Génère un UUID automatiquement
  Future<AlertConfiguration> create(
    AlertConfiguration config,
    String farmId,
  ) async {
    // Sécurité: vérifier que farmId correspond
    if (config.farmId != farmId) {
      throw Exception('Security violation: Farm ID mismatch');
    }

    // Vérifier qu'une config n'existe pas déjà pour ce type
    final existing = await _db.alertConfigurationDao.findByEvaluationType(
      farmId,
      config.evaluationType.toStringValue(),
    );
    if (existing != null && existing.deletedAt == null) {
      throw Exception(
        'AlertConfiguration already exists for this evaluationType',
      );
    }

    final now = DateTime.now();
    final newConfig = config.copyWith(
      id: _uuid.v4(),
      createdAt: now,
      updatedAt: now,
    );

    final companion = _mapToCompanion(newConfig);
    await _db.alertConfigurationDao.insertItem(companion);

    return newConfig;
  }

  /// Met à jour une configuration existante
  Future<void> update(
    AlertConfiguration config,
    String farmId,
  ) async {
    // Sécurité: vérifier farmId
    if (config.farmId != farmId) {
      throw Exception('Security violation: Farm ID mismatch');
    }

    // Vérifier que la config existe et appartient à la bonne ferme
    final existing =
        await _db.alertConfigurationDao.findById(config.id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('AlertConfiguration not found or farm mismatch');
    }

    final updated = config.copyWith(updatedAt: DateTime.now());
    final companion = _mapToCompanion(updated);
    await _db.alertConfigurationDao.updateItem(companion);
  }

  /// Supprime (soft-delete) une configuration
  Future<void> delete(String id, String farmId) async {
    // Vérifier existence et sécurité
    final existing = await _db.alertConfigurationDao.findById(id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('AlertConfiguration not found or farm mismatch');
    }

    await _db.alertConfigurationDao.softDelete(id, farmId);
  }

  /// Bascule l'activation/désactivation d'une configuration
  /// Permet au farmer de désactiver des alertes sans les supprimer
  Future<void> toggleEnabled(
    String id,
    String farmId,
    bool newState,
  ) async {
    // Vérifier existence et sécurité
    final existing = await _db.alertConfigurationDao.findById(id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('AlertConfiguration not found or farm mismatch');
    }

    await _db.alertConfigurationDao.toggleEnabled(id, farmId, newState);
  }

  /// Récupère les configurations non synchronisées (Phase 2)
  /// Utilisé par SyncService
  Future<List<AlertConfiguration>> getUnsynced(String farmId) async {
    final data = await _db.alertConfigurationDao.getUnsynced(farmId);
    return data.map((d) => _mapToModel(d)).toList();
  }

  /// Marque les configs comme synchronisées (Phase 2)
  /// Appelé après confirmation du serveur
  Future<void> markSynced(
    String id,
    String farmId, {
    String? serverVersion,
  }) async {
    // Vérifier existence et sécurité
    final existing = await _db.alertConfigurationDao.findById(id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('AlertConfiguration not found or farm mismatch');
    }

    await _db.alertConfigurationDao.markSynced(
      id,
      farmId,
      serverVersion: serverVersion,
    );
  }

  /// Compte les configurations activées pour une ferme
  /// Utile pour les statistiques
  Future<int> countEnabled(String farmId) async {
    return await _db.alertConfigurationDao.countEnabled(farmId);
  }

  // ========== MAPPERS ==========

  /// Mappe AlertConfigurationData (DB) → AlertConfiguration (Model)
  AlertConfiguration _mapToModel(AlertConfigurationData data) {
    return AlertConfiguration(
      id: data.id,
      farmId: data.farmId,
      evaluationType:
          AlertEvaluationTypeExtension.fromString(data.evaluationType),
      type: data.type,
      category: data.category,
      titleKey: data.titleKey,
      messageKey: data.messageKey,
      severity: data.severity,
      iconName: data.iconName,
      colorHex: data.colorHex,
      enabled: data.enabled,
      synced: data.synced,
      lastSyncedAt: data.lastSyncedAt,
      serverVersion: data.serverVersion,
      deletedAt: data.deletedAt,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  /// Mappe AlertConfiguration (Model) → AlertConfigurationsTableCompanion (DB)
  AlertConfigurationsTableCompanion _mapToCompanion(AlertConfiguration model) {
    return AlertConfigurationsTableCompanion(
      id: Value(model.id),
      farmId: Value(model.farmId),
      evaluationType: Value(model.evaluationType.toStringValue()),
      type: Value(model.type),
      category: Value(model.category),
      titleKey: Value(model.titleKey),
      messageKey: Value(model.messageKey),
      severity: Value(model.severity),
      iconName: Value(model.iconName),
      colorHex: Value(model.colorHex),
      enabled: Value(model.enabled),
      synced: Value(model.synced),
      lastSyncedAt: model.lastSyncedAt != null
          ? Value(model.lastSyncedAt!)
          : const Value.absent(),
      serverVersion: model.serverVersion != null
          ? Value(model.serverVersion!)
          : const Value.absent(),
      deletedAt: model.deletedAt != null
          ? Value(model.deletedAt!)
          : const Value.absent(),
      createdAt: Value(model.createdAt),
      updatedAt: Value(model.updatedAt),
    );
  }
}
