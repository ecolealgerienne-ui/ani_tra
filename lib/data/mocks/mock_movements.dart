<<<<<<< HEAD
// lib/data/mocks/mock_movements.dart

import '../../models/movement.dart';

/// Données de test pour les mouvements d'animaux
class MockMovements {
  static List<Movement> generateMovements() {
    final now = DateTime.now();

    return [
      // NOTE: Birth movements removed - births are NOT business movements

      // ==================== VENTES ====================
      Movement(
        id: 'movement_004',
        animalId: 'animal_017',
        type: MovementType.sale,
        movementDate: now.subtract(const Duration(days: 60)),
        farmId: 'farm_default',
        price: 85.50,
        notes: 'Vente marché local',
        status: MovementStatus.closed,
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
        status: MovementStatus.closed,
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
        status: MovementStatus.closed,
        synced: true,
        createdAt: now.subtract(const Duration(days: 120)),
      ),
    ];
  }
}
=======
// lib/data/mocks/mock_movements.dart

import '../../models/movement.dart';

/// Données de test pour les mouvements d'animaux
class MockMovements {
  static List<Movement> generateMovements() {
    final now = DateTime.now();

    return [
      // NOTE: Birth movements removed - births are NOT business movements

      // ==================== VENTES ====================
      Movement(
        id: 'movement_004',
        animalId: 'animal_017',
        type: MovementType.sale,
        movementDate: now.subtract(const Duration(days: 60)),
        farmId: 'farm_default',
        price: 85.50,
        notes: 'Vente marché local',
        status: MovementStatus.closed,
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
        status: MovementStatus.closed,
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
        status: MovementStatus.closed,
        synced: true,
        createdAt: now.subtract(const Duration(days: 120)),
      ),
    ];
  }
}
>>>>>>> 3c7c4af37e3aa7af66c651b44054d6108094b1b2
