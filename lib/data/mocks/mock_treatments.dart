// lib/data/mocks/mock_treatments.dart

import '../../models/treatment.dart';

/// Données de test pour les traitements
class MockTreatments {
  static List<Treatment> generateTreatments() {
    final now = DateTime.now();

    return [
      // ==================== TRAITEMENT AVEC RÉMANENCE ACTIVE ====================
      Treatment(
        id: 'treatment_001',
        animalId: 'animal_020',
        productName: 'Ivermectine 1%',
        productId: 'product_001',
        dose: 0.2,
        treatmentDate: now.subtract(const Duration(days: 5)),
        withdrawalEndDate: now.add(const Duration(days: 11)), // 16j - 5j = 11j restants
        veterinarianId: 'vet_001',
        synced: true,
        createdAt: now.subtract(const Duration(days: 5)),
      ),

      // ==================== TRAITEMENT SANS RÉMANENCE (VACCIN) ====================
      Treatment(
        id: 'treatment_002',
        animalId: 'animal_001',
        productName: 'Vaccin Entérotoxémie',
        productId: 'product_002',
        dose: 2.0,
        treatmentDate: now.subtract(const Duration(days: 180)),
        withdrawalEndDate: now.subtract(const Duration(days: 180)),
        veterinarianId: 'vet_003',
        synced: true,
        createdAt: now.subtract(const Duration(days: 180)),
      ),

      // ==================== TRAITEMENT RÉMANENCE TERMINÉE ====================
      Treatment(
        id: 'treatment_003',
        animalId: 'animal_009',
        productName: 'Albendazole',
        productId: 'product_008',
        dose: 5.0,
        treatmentDate: now.subtract(const Duration(days: 60)),
        withdrawalEndDate: now.subtract(const Duration(days: 46)), // 14j passés
        veterinarianId: 'vet_001',
        synced: true,
        createdAt: now.subtract(const Duration(days: 60)),
      ),

      // ==================== AUTRES TRAITEMENTS ====================
      Treatment(
        id: 'treatment_004',
        animalId: 'animal_002',
        productName: 'Vaccin Pasteurellose',
        productId: 'product_006',
        dose: 2.0,
        treatmentDate: now.subtract(const Duration(days: 90)),
        withdrawalEndDate: now.subtract(const Duration(days: 90)),
        veterinarianId: 'vet_002',
        synced: true,
        createdAt: now.subtract(const Duration(days: 90)),
      ),
      Treatment(
        id: 'treatment_005',
        animalId: 'animal_010',
        productName: 'Méloxicam',
        productId: 'product_007',
        dose: 0.5,
        treatmentDate: now.subtract(const Duration(days: 15)),
        withdrawalEndDate: now.subtract(const Duration(days: 10)), // 5j terminés
        veterinarianId: 'vet_001',
        synced: true,
        createdAt: now.subtract(const Duration(days: 15)),
      ),
    ];
  }
}
