// lib/data/mocks/mock_movements.dart

import '../../models/movement.dart';

/// Données de test pour les mouvements d'animaux
class MockMovements {
  static List<Movement> generateMovements() {
    final now = DateTime.now();

    return [
      // ==================== NAISSANCES ====================
      Movement(
        id: 'movement_001',
        animalId: 'animal_009',
        type: MovementType.birth,
        movementDate: DateTime(2024, 2, 15),
        farmId: 'farm_default',
        synced: true,
        createdAt: now.subtract(const Duration(days: 250)),
      ),
      Movement(
        id: 'movement_002',
        animalId: 'animal_010',
        type: MovementType.birth,
        movementDate: DateTime(2024, 2, 16),
        farmId: 'farm_default',
        synced: true,
        createdAt: now.subtract(const Duration(days: 249)),
      ),
      Movement(
        id: 'movement_003',
        animalId: 'animal_014',
        type: MovementType.birth,
        movementDate: DateTime(2025, 1, 10),
        farmId: 'farm_default',
        synced: true,
        createdAt: now.subtract(const Duration(days: 30)),
      ),

      // ==================== VENTES ====================
      Movement(
        id: 'movement_004',
        animalId: 'animal_017',
        type: MovementType.sale,
        movementDate: now.subtract(const Duration(days: 60)),
        farmId: 'farm_default',
        price: 85.50,
        notes: 'Vente marché local',
        synced: true,
        createdAt: now.subtract(const Duration(days: 60)),
      ),
      Movement(
        id: 'movement_005',
        animalId: 'animal_018',
        type: MovementType.sale,
        movementDate: now.subtract(const Duration(days: 45)),
        farmId: 'farm_default',
        price: 92.00,
        notes: 'Vente éleveur voisin',
        synced: true,
        createdAt: now.subtract(const Duration(days: 45)),
      ),

      // ==================== MORT ====================
      Movement(
        id: 'movement_006',
        animalId: 'animal_019',
        type: MovementType.death,
        movementDate: now.subtract(const Duration(days: 120)),
        farmId: 'farm_default',
        notes: 'Maladie respiratoire',
        synced: true,
        createdAt: now.subtract(const Duration(days: 120)),
      ),
    ];
  }
}
