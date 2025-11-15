// lib/data/mock_alerts_generator.dart
// Générateur d'alertes mock pour tester le système

import '../models/alert.dart';

/// Générateur d'alertes de test
class MockAlertsGenerator {
  /// Générer des alertes de test pour afficher dans l'UI
  ///
  /// À utiliser TEMPORAIREMENT dans AlertProvider pour tester
  static List<Alert> generateTestAlerts(List<String> animalIds) {
    final alerts = <Alert>[];

    // 🚨 ALERTE URGENTE 1 : Rémanence critique
    alerts.add(Alert.remanence(
      animalId: animalIds[0],
      animalName: 'Animal Test 1',
      daysRemaining: 1, // 1 jour restant = URGENT
      treatmentName: 'Antibiotique XYZ',
    ));

    // 🚨 ALERTE URGENTE 2 : Rémanence dépassée
    alerts.add(Alert.remanence(
      animalId: animalIds[1],
      animalName: 'Animal Test 2',
      daysRemaining: -2, // Dépassé = URGENT
      treatmentName: 'Anti-inflammatoire',
    ));

    // ⚠️ ALERTE IMPORTANTE 1 : Identification manquante
    alerts.add(Alert.missingIdentification(
      animalId: animalIds[2],
      animalName: 'Animal Test 3',
      ageInDays: 200, // > 180 jours = IMPORTANT
    ));

    // ⚠️ ALERTE IMPORTANTE 2 : Identification manquante (jeune)
    alerts.add(Alert.missingIdentification(
      animalId: animalIds[3],
      animalName: 'Animal Test 4',
      ageInDays: 120, // < 180 jours = IMPORTANT quand même
    ));

    // 📋 ALERTE ROUTINE : Pesée recommandée (groupe)
    alerts.add(Alert.weighingRequired(
      animalIds: [animalIds[0], animalIds[2], animalIds[4]], // 3 animaux
      reason: 'Pesée mensuelle',
    ));

    // 🚨 ALERTE URGENTE 3 : Synchronisation critique
    alerts.add(Alert.syncRequired(
      daysSinceLastSync: 15, // > 14 jours = URGENT
      pendingItems: 25,
    ));

    // ⚠️ ALERTE IMPORTANTE 3 : Synchronisation importante
    alerts.add(Alert.syncRequired(
      daysSinceLastSync: 9, // Entre 7 et 14 = IMPORTANT
      pendingItems: 12,
    ));

    // 📋 ALERTE ROUTINE 2 : Traitement à renouveler
    alerts.add(Alert.treatmentRenewal(
      treatmentId: 'treatment_test_1',
      animalId: animalIds[4], // 🆕 AJOUTÉ
      animalName: 'Animal Test 5',
      treatmentName: 'Vermifuge',
      dueDate: DateTime.now().add(const Duration(days: 5)),
    ));

    // 📋 ALERTE ROUTINE 3 : Lot à finaliser
    alerts.add(Alert.batchToFinalize(
      batchId: 'batch_test_1',
      batchName: 'Lot Vente Printemps',
      animalCount: 8,
      animalIds: animalIds.take(8).toList(), // 🆕 AJOUTÉ - Premiers 8 animaux
    ));

    return alerts;
  }

  /// Ajouter des alertes mock au calcul existant
  /// À appeler dans AlertProvider._recalculateAlerts() TEMPORAIREMENT
  static void addMockAlertsToProvider(
    List<Alert> existingAlerts,
    List<String> animalIds,
  ) {
    final mockAlerts = generateTestAlerts(animalIds);
    existingAlerts.addAll(mockAlerts);
  }
}
