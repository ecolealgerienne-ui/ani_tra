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

  /// Assure que les configurations par défaut existent pour une ferme
  /// Crée les configs manquantes si nécessaire
  /// Retourne true si des configs ont été créées
  Future<bool> ensureDefaultConfigs(String farmId) async {
    // Vérifier si la ferme a déjà des configurations
    final existing = await getAll(farmId);
    if (existing.isNotEmpty) {
      return false; // Déjà configuré
    }

    // Créer les configurations par défaut
    // Couleurs harmonisées par sévérité:
    // - Critique (3): Rouge #D32F2F
    // - Important (2): Orange #F57C00
    // - Routine (1): Bleu #1976D2
    final now = DateTime.now();
    final defaultConfigs = [
      // ═══════ CRITIQUE (severity 3) - Rouge ═══════
      // Identification
      AlertConfigurationsTableCompanion.insert(
        id: '${farmId}_config_identification',
        farmId: farmId,
        evaluationType: 'identification',
        type: 'urgent',
        category: 'identification',
        titleKey: 'alertIdentificationTitle',
        messageKey: 'alertIdentificationMsg',
        severity: 3,
        iconName: 'tag',
        colorHex: '#D32F2F',
        enabled: const Value(true),
        synced: const Value(false),
        createdAt: now,
        updatedAt: now,
      ),

      // ═══════ IMPORTANT (severity 2) - Orange ═══════
      // Rémanence
      AlertConfigurationsTableCompanion.insert(
        id: '${farmId}_config_remanence',
        farmId: farmId,
        evaluationType: 'remanence',
        type: 'important',
        category: 'remanence',
        titleKey: 'alertRemanenceTitle',
        messageKey: 'alertRemanenceMsg',
        severity: 2,
        iconName: 'pill',
        colorHex: '#F57C00',
        enabled: const Value(true),
        synced: const Value(false),
        createdAt: now,
        updatedAt: now,
      ),
      // Vaccination
      AlertConfigurationsTableCompanion.insert(
        id: '${farmId}_config_vaccination',
        farmId: farmId,
        evaluationType: 'vaccination',
        type: 'important',
        category: 'treatment',
        titleKey: 'alertVaccinationTitle',
        messageKey: 'alertVaccinationMsg',
        severity: 2,
        iconName: 'syringe',
        colorHex: '#F57C00',
        enabled: const Value(true),
        synced: const Value(false),
        createdAt: now,
        updatedAt: now,
      ),
      // Animaux en brouillon
      AlertConfigurationsTableCompanion.insert(
        id: '${farmId}_config_draft_animals',
        farmId: farmId,
        evaluationType: 'draftAnimals',
        type: 'important',
        category: 'identification',
        titleKey: 'alertDraftAnimalsTitle',
        messageKey: 'alertDraftAnimalsMsg',
        severity: 2,
        iconName: 'edit_note',
        colorHex: '#F57C00',
        enabled: const Value(true),
        synced: const Value(false),
        createdAt: now,
        updatedAt: now,
      ),

      // ═══════ ROUTINE (severity 1) - Bleu ═══════
      // Pesée
      AlertConfigurationsTableCompanion.insert(
        id: '${farmId}_config_weighing',
        farmId: farmId,
        evaluationType: 'weighing',
        type: 'routine',
        category: 'weighing',
        titleKey: 'alertWeighingTitle',
        messageKey: 'alertWeighingMsg',
        severity: 1,
        iconName: 'scale',
        colorHex: '#1976D2',
        enabled: const Value(true),
        synced: const Value(false),
        createdAt: now,
        updatedAt: now,
      ),
      // Synchronisation
      AlertConfigurationsTableCompanion.insert(
        id: '${farmId}_config_sync',
        farmId: farmId,
        evaluationType: 'syncRequired',
        type: 'routine',
        category: 'sync',
        titleKey: 'alertSyncTitle',
        messageKey: 'alertSyncMsg',
        severity: 1,
        iconName: 'cloud_upload',
        colorHex: '#1976D2',
        enabled: const Value(true),
        synced: const Value(false),
        createdAt: now,
        updatedAt: now,
      ),
      // Renouvellement traitement
      AlertConfigurationsTableCompanion.insert(
        id: '${farmId}_config_treatment_renewal',
        farmId: farmId,
        evaluationType: 'treatmentRenewal',
        type: 'routine',
        category: 'treatment',
        titleKey: 'alertTreatmentRenewalTitle',
        messageKey: 'alertTreatmentRenewalMsg',
        severity: 1,
        iconName: 'medication',
        colorHex: '#1976D2',
        enabled: const Value(true),
        synced: const Value(false),
        createdAt: now,
        updatedAt: now,
      ),
      // Lot à finaliser
      AlertConfigurationsTableCompanion.insert(
        id: '${farmId}_config_batch_finalize',
        farmId: farmId,
        evaluationType: 'batchToFinalize',
        type: 'routine',
        category: 'batch',
        titleKey: 'alertBatchFinalizeTitle',
        messageKey: 'alertBatchFinalizeMsg',
        severity: 1,
        iconName: 'inventory',
        colorHex: '#1976D2',
        enabled: const Value(true),
        synced: const Value(false),
        createdAt: now,
        updatedAt: now,
      ),
    ];

    // Insérer toutes les configurations
    for (final config in defaultConfigs) {
      await _db.alertConfigurationDao.insertItem(config);
    }

    return true;
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
