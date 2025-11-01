// lib/data/mocks/mock_weights.dart

import '../../models/weight_record.dart';

/// Données de test pour les pesées
class MockWeights {
  static List<WeightRecord> generateWeights() {
    final now = DateTime.now();

    return [
      // ==================== BREBIS ANIMAL_001 - HISTORIQUE 6 MOIS ====================
      WeightRecord(
        id: 'weight_001',
        animalId: 'animal_001',
        weight: 58.5,
        recordedAt: now.subtract(const Duration(days: 180)),
        source: WeightSource.manual,
        synced: true,
        createdAt: now.subtract(const Duration(days: 180)),
      ),
      WeightRecord(
        id: 'weight_002',
        animalId: 'animal_001',
        weight: 60.2,
        recordedAt: now.subtract(const Duration(days: 90)),
        source: WeightSource.manual,
        synced: true,
        createdAt: now.subtract(const Duration(days: 90)),
      ),
      WeightRecord(
        id: 'weight_003',
        animalId: 'animal_001',
        weight: 62.8,
        recordedAt: now.subtract(const Duration(days: 30)),
        source: WeightSource.manual,
        notes: 'Bonne condition',
        synced: true,
        createdAt: now.subtract(const Duration(days: 30)),
      ),

      // ==================== AGNEAU ANIMAL_009 - CROISSANCE ====================
      WeightRecord(
        id: 'weight_004',
        animalId: 'animal_009',
        weight: 12.5,
        recordedAt: now.subtract(const Duration(days: 200)),
        source: WeightSource.manual,
        notes: 'À la naissance',
        synced: true,
        createdAt: now.subtract(const Duration(days: 200)),
      ),
      WeightRecord(
        id: 'weight_005',
        animalId: 'animal_009',
        weight: 18.3,
        recordedAt: now.subtract(const Duration(days: 150)),
        source: WeightSource.manual,
        synced: true,
        createdAt: now.subtract(const Duration(days: 150)),
      ),
      WeightRecord(
        id: 'weight_006',
        animalId: 'animal_009',
        weight: 25.7,
        recordedAt: now.subtract(const Duration(days: 100)),
        source: WeightSource.manual,
        synced: true,
        createdAt: now.subtract(const Duration(days: 100)),
      ),
      WeightRecord(
        id: 'weight_007',
        animalId: 'animal_009',
        weight: 32.4,
        recordedAt: now.subtract(const Duration(days: 50)),
        source: WeightSource.manual,
        synced: true,
        createdAt: now.subtract(const Duration(days: 50)),
      ),
      WeightRecord(
        id: 'weight_008',
        animalId: 'animal_009',
        weight: 38.9,
        recordedAt: now.subtract(const Duration(days: 10)),
        source: WeightSource.manual,
        notes: 'Prêt pour la vente',
        synced: false,
        createdAt: now.subtract(const Duration(days: 10)),
      ),

      // ==================== BREBIS ANIMAL_002 ====================
      WeightRecord(
        id: 'weight_009',
        animalId: 'animal_002',
        weight: 55.8,
        recordedAt: now.subtract(const Duration(days: 120)),
        source: WeightSource.manual,
        synced: true,
        createdAt: now.subtract(const Duration(days: 120)),
      ),
      WeightRecord(
        id: 'weight_010',
        animalId: 'animal_002',
        weight: 59.3,
        recordedAt: now.subtract(const Duration(days: 20)),
        source: WeightSource.manual,
        synced: false,
        createdAt: now.subtract(const Duration(days: 20)),
      ),

      // ==================== AGNEAU ANIMAL_014 - RÉCENT ====================
      WeightRecord(
        id: 'weight_011',
        animalId: 'animal_014',
        weight: 4.2,
        recordedAt: now.subtract(const Duration(days: 30)),
        source: WeightSource.manual,
        notes: 'Naissance',
        synced: true,
        createdAt: now.subtract(const Duration(days: 30)),
      ),
      WeightRecord(
        id: 'weight_012',
        animalId: 'animal_014',
        weight: 8.7,
        recordedAt: now.subtract(const Duration(days: 5)),
        source: WeightSource.manual,
        notes: 'Bonne croissance',
        synced: false,
        createdAt: now.subtract(const Duration(days: 5)),
      ),

      // ==================== BÉLIER ANIMAL_006 ====================
      WeightRecord(
        id: 'weight_013',
        animalId: 'animal_006',
        weight: 85.5,
        recordedAt: now.subtract(const Duration(days: 90)),
        source: WeightSource.manual,
        synced: true,
        createdAt: now.subtract(const Duration(days: 90)),
      ),
      WeightRecord(
        id: 'weight_014',
        animalId: 'animal_006',
        weight: 88.2,
        recordedAt: now.subtract(const Duration(days: 15)),
        source: WeightSource.manual,
        synced: false,
        createdAt: now.subtract(const Duration(days: 15)),
      ),

      // ==================== AGNEAU ANIMAL_010 ====================
      WeightRecord(
        id: 'weight_015',
        animalId: 'animal_010',
        weight: 11.8,
        recordedAt: now.subtract(const Duration(days: 200)),
        source: WeightSource.manual,
        synced: true,
        createdAt: now.subtract(const Duration(days: 200)),
      ),
      WeightRecord(
        id: 'weight_016',
        animalId: 'animal_010',
        weight: 24.5,
        recordedAt: now.subtract(const Duration(days: 100)),
        source: WeightSource.manual,
        synced: true,
        createdAt: now.subtract(const Duration(days: 100)),
      ),
      WeightRecord(
        id: 'weight_017',
        animalId: 'animal_010',
        weight: 35.2,
        recordedAt: now.subtract(const Duration(days: 20)),
        source: WeightSource.manual,
        synced: false,
        createdAt: now.subtract(const Duration(days: 20)),
      ),
    ];
  }
}
