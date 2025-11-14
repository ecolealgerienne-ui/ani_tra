// lib/seeds/alert_configuration_seeds.dart

import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import '../models/alert_configuration.dart';
import '../drift/database.dart';
import '../i18n/app_strings.dart';
import 'package:drift/drift.dart';

const _uuid = Uuid();

/// Configurations d'alertes par défaut pour les fermes
/// 8 types couvrant les workflows principaux
class AlertConfigurationSeeds {
  /// Génère la liste complète de configurations pour une ferme
  static List<AlertConfiguration> generateSeedsForFarm(String farmId) {
    final now = DateTime.now();

    return [
      // ========== 1. REMANENCE (Délai abattage) ==========
      AlertConfiguration(
        id: _uuid.v4(),
        farmId: farmId,
        evaluationType: AlertEvaluationType.remanence,
        type: 'urgent',
        category: 'remanence',
        titleKey: AppStrings.alertRemanenceTitle,
        messageKey: AppStrings.alertRemanenceMsg,
        severity: 3,
        iconName: '📋',
        colorHex: '#D32F2F',
        enabled: true,
        synced: false,
        lastSyncedAt: null,
        serverVersion: null,
        deletedAt: null,
        createdAt: now,
        updatedAt: now,
      ),

      // ========== 2. WEIGHING (Pesée manquante) ==========
      AlertConfiguration(
        id: _uuid.v4(),
        farmId: farmId,
        evaluationType: AlertEvaluationType.weighing,
        type: 'routine',
        category: 'weighing',
        titleKey: AppStrings.alertWeighingTitle,
        messageKey: AppStrings.alertWeighingMsg,
        severity: 2,
        iconName: '⚖️',
        colorHex: '#F57C00',
        enabled: true,
        synced: false,
        lastSyncedAt: null,
        serverVersion: null,
        deletedAt: null,
        createdAt: now,
        updatedAt: now,
      ),

      // ========== 3. VACCINATION (Vaccination due) ==========
      AlertConfiguration(
        id: _uuid.v4(),
        farmId: farmId,
        evaluationType: AlertEvaluationType.vaccination,
        type: 'important',
        category: 'treatment',
        titleKey: AppStrings.alertVaccinationTitle,
        messageKey: AppStrings.alertVaccinationMsg,
        severity: 2,
        iconName: '💉',
        colorHex: '#1976D2',
        enabled: true,
        synced: false,
        lastSyncedAt: null,
        serverVersion: null,
        deletedAt: null,
        createdAt: now,
        updatedAt: now,
      ),

      // ========== 4. IDENTIFICATION (EID manquant) ==========
      AlertConfiguration(
        id: _uuid.v4(),
        farmId: farmId,
        evaluationType: AlertEvaluationType.identification,
        type: 'urgent',
        category: 'identification',
        titleKey: AppStrings.alertIdentificationTitle,
        messageKey: AppStrings.alertIdentificationMsg,
        severity: 3,
        iconName: '🏷️',
        colorHex: '#D32F2F',
        enabled: true,
        synced: false,
        lastSyncedAt: null,
        serverVersion: null,
        deletedAt: null,
        createdAt: now,
        updatedAt: now,
      ),

      // ========== 5. SYNC REQUIRED (Sync en retard) ==========
      AlertConfiguration(
        id: _uuid.v4(),
        farmId: farmId,
        evaluationType: AlertEvaluationType.syncRequired,
        type: 'routine',
        category: 'sync',
        titleKey: AppStrings.alertSyncTitle,
        messageKey: AppStrings.alertSyncMsg,
        severity: 1,
        iconName: '🔄',
        colorHex: '#388E3C',
        enabled: true,
        synced: false,
        lastSyncedAt: null,
        serverVersion: null,
        deletedAt: null,
        createdAt: now,
        updatedAt: now,
      ),

      // ========== 6. TREATMENT RENEWAL (Traitement à renouveler) ==========
      AlertConfiguration(
        id: _uuid.v4(),
        farmId: farmId,
        evaluationType: AlertEvaluationType.treatmentRenewal,
        type: 'important',
        category: 'treatment',
        titleKey: AppStrings.alertTreatmentTitle,
        messageKey: AppStrings.alertTreatmentMsg,
        severity: 2,
        iconName: '💊',
        colorHex: '#1976D2',
        enabled: true,
        synced: false,
        lastSyncedAt: null,
        serverVersion: null,
        deletedAt: null,
        createdAt: now,
        updatedAt: now,
      ),

      // ========== 7. BATCH TO FINALIZE (Lot à finaliser) ==========
      AlertConfiguration(
        id: _uuid.v4(),
        farmId: farmId,
        evaluationType: AlertEvaluationType.batchToFinalize,
        type: 'routine',
        category: 'batch',
        titleKey: AppStrings.alertBatchTitle,
        messageKey: AppStrings.alertBatchMsg,
        severity: 1,
        iconName: '📦',
        colorHex: '#388E3C',
        enabled: true,
        synced: false,
        lastSyncedAt: null,
        serverVersion: null,
        deletedAt: null,
        createdAt: now,
        updatedAt: now,
      ),

      // ========== 8. BROUILLONS (Animaux en attente validation) ==========
      // ⚠️ NOTE: Brouillon n'a pas d'evaluationType dédié pour l'instant
      // C'est un calcul spécial qui reste en legacy (_calculateIncompleteEvents)
      // Cette config est un placeholder pour la future intégration Phase 2.2
      // Pour l'instant, brouillon est toujours calculé via _calculateIncompleteEvents()
      // mais avec cette config, vous pouvez l'activer/désactiver depuis la BD
    ];
  }

  /// Initialise les configurations pour une ferme
  /// À appeler lors du premier lancement avec une ferme
  static Future<void> seedDatabase(
    AppDatabase db,
    String farmId,
  ) async {
    debugPrint('🌱 [SEEDS] Vérification seeds pour farm: $farmId');

    // Vérifier si déjà seedées
    final existing = await db.alertConfigurationDao.findByFarmId(farmId);
    if (existing.isNotEmpty) {
      debugPrint(
          '✅ [SEEDS] Configurations déjà seeded (${existing.length} configs)');
      return;
    }

    debugPrint('📦 [SEEDS] Création des configurations...');
    final seeds = generateSeedsForFarm(farmId);

    for (final config in seeds) {
      final companion = _mapToCompanion(config);
      await db.alertConfigurationDao.insertItem(companion);
      debugPrint(
          '   ✅ Seeded: ${config.evaluationType.toString().split('.').last}');
    }

    debugPrint(
        '✅ [SEEDS] Seeded ${seeds.length} alert configurations pour farm $farmId');
  }

  /// Mappe AlertConfiguration → Companion (interne)
  static AlertConfigurationsTableCompanion _mapToCompanion(
    AlertConfiguration model,
  ) {
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
