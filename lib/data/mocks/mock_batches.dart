// lib/data/mocks/mock_batches.dart

import '../../models/batch.dart';

/// Données de test pour les lots d'animaux
class MockBatches {
  static List<Batch> generateBatches() {
    final now = DateTime.now();

    return [
      // ==================== LOT VENTE COMPLÉTÉ ====================
      Batch(
        id: 'batch_001',
        name: 'Vente Septembre 2024',
        purpose: BatchPurpose.sale,
        animalIds: const ['animal_017', 'animal_018'],
        createdAt: now.subtract(const Duration(days: 60)),
        farmId: 'farm_default',
        usedAt: now.subtract(const Duration(days: 59)),
        completed: true,
        synced: true,
      ),

      // ==================== LOT ABATTAGE EN PRÉPARATION ====================
      Batch(
        id: 'batch_002',
        name: 'Abattage Novembre 2025',
        purpose: BatchPurpose.slaughter,
        animalIds: const ['animal_009', 'animal_011', 'animal_013'],
        createdAt: now.subtract(const Duration(days: 2)),
        farmId: 'farm_default',
        completed: false,
        synced: false,
      ),

      // ==================== LOT TRAITEMENT COMPLÉTÉ ====================
      Batch(
        id: 'batch_003',
        name: 'Vermifuge Automne 2024',
        purpose: BatchPurpose.treatment,
        animalIds: const [
          'animal_001',
          'animal_002',
          'animal_003',
          'animal_004',
          'animal_005',
          'animal_009',
          'animal_010',
          'animal_011',
          'animal_012',
          'animal_013',
        ],
        createdAt: now.subtract(const Duration(days: 30)),
        farmId: 'farm_default',
        usedAt: now.subtract(const Duration(days: 29)),
        completed: true,
        synced: true,
      ),

      // ==================== LOT VENTE EN COURS ====================
      Batch(
        id: 'batch_004',
        name: 'Vente Marché Local',
        purpose: BatchPurpose.sale,
        animalIds: const ['animal_009', 'animal_011'],
        createdAt: now.subtract(const Duration(days: 1)),
        farmId: 'farm_default',
        completed: false,
        synced: false,
      ),

      // ==================== LOT AUTRE (TRI) ====================
      Batch(
        id: 'batch_005',
        name: 'Tri Agneaux 2024',
        purpose: BatchPurpose.other,
        animalIds: const [
          'animal_009',
          'animal_010',
          'animal_011',
          'animal_012',
          'animal_013',
        ],
        createdAt: now.subtract(const Duration(days: 15)),
        farmId: 'farm_default',
        usedAt: now.subtract(const Duration(days: 14)),
        completed: true,
        synced: true,
      ),

      // ==================== LOT ABATTAGE AVEC RÉMANENCE ====================
      Batch(
        id: 'batch_006',
        name: 'Abattage Test Rémanence',
        purpose: BatchPurpose.slaughter,
        animalIds: const [
          'animal_009',
          'animal_020', // A une rémanence active
        ],
        createdAt: now.subtract(const Duration(hours: 3)),
        farmId: 'farm_default',
        completed: false,
        synced: false,
      ),
    ];
  }
}
