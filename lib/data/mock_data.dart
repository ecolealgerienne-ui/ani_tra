// lib/data/mock_data.dart
// Point d'entrÃ©e principal pour toutes les donnÃ©es de test

import '../models/animal.dart';
import '../models/product.dart';
import '../models/treatment.dart';
import '../models/movement.dart';
import '../models/batch.dart';
import '../models/weight_record.dart';
import '../models/veterinarian.dart';
import '../models/vaccination.dart';

// Import des mocks sÃ©parÃ©s
import 'mocks/mock_animals.dart';
import 'mocks/mock_products.dart';
import 'mocks/mock_treatments.dart';
import 'mocks/mock_movements.dart';
import 'mocks/mock_batches.dart';
import 'mocks/mock_weights.dart';
import 'mocks/mock_veterinarians.dart';
import 'mocks/mock_vaccinations.dart';

/// Classe principale pour accÃ©der Ã  toutes les donnÃ©es de test
///
/// Centralise l'accÃ¨s aux mocks pour faciliter l'initialisation
/// et la maintenance des donnÃ©es de test.
///
/// Usage:
/// ```dart
/// final animals = MockData.animals;
/// final products = MockData.products;
/// ```
class MockData {
  // ==================== ANIMAUX ====================

  /// Liste complÃ¨te des animaux de test (20 animaux)
  static List<Animal> get animals => MockAnimals.generateAnimals();

  /// MÃ©thode pour gÃ©nÃ©rer les animaux (alias pour compatibilitÃ©)
  static List<Animal> generateAnimals() => MockAnimals.generateAnimals();

  // ==================== PRODUITS ====================

  /// Liste complÃ¨te des produits sanitaires (10 produits)
  static List<Product> get products => MockProducts.generateProducts();

  /// MÃ©thode pour gÃ©nÃ©rer les produits (alias pour compatibilitÃ©)
  static List<Product> generateProducts() => MockProducts.generateProducts();

  // ==================== TRAITEMENTS ====================

  /// Liste des traitements (5 traitements)
  static List<Treatment> get treatments => MockTreatments.generateTreatments();

  /// MÃ©thode pour gÃ©nÃ©rer les traitements (alias pour compatibilitÃ©)
  static List<Treatment> generateTreatments() =>
      MockTreatments.generateTreatments();

  // ==================== MOUVEMENTS ====================

  /// Liste des mouvements d'animaux (6 mouvements)
  static List<Movement> get movements => MockMovements.generateMovements();

  /// MÃ©thode pour gÃ©nÃ©rer les mouvements (alias pour compatibilitÃ©)
  static List<Movement> generateMovements() =>
      MockMovements.generateMovements();

  // ==================== LOTS ====================

  /// Liste des lots (6 lots)
  static List<Batch> get batches => MockBatches.generateBatches();

  /// MÃ©thode pour gÃ©nÃ©rer les lots (alias pour compatibilitÃ©)
  static List<Batch> generateBatches() => MockBatches.generateBatches();

  // ==================== PESÃ‰ES ====================

  /// Liste des pesÃ©es (17 pesÃ©es)
  static List<WeightRecord> get weights => MockWeights.generateWeights();

  /// MÃ©thode pour gÃ©nÃ©rer les pesÃ©es (alias pour compatibilitÃ©)
  static List<WeightRecord> generateWeights() => MockWeights.generateWeights();

  // ==================== VÃ‰TÃ‰RINAIRES ====================

  /// Liste des vÃ©tÃ©rinaires (10 vÃ©tÃ©rinaires)
  static List<Veterinarian> get veterinarians =>
      MockVeterinarians.generateVeterinarians();

  /// MÃ©thode pour gÃ©nÃ©rer les vÃ©tÃ©rinaires (alias pour compatibilitÃ©)

  // ==================== VACCINATIONS ====================

  /// Liste des vaccinations (10 vaccinations)
  static List<Vaccination> get vaccinations =>
      MockVaccinations.generateVaccinations();

  /// Méthode pour générer les vaccinations (alias pour compatibilité)
  static List<Vaccination> generateVaccinations() =>
      MockVaccinations.generateVaccinations();
  static List<Veterinarian> generateVeterinarians() =>
      MockVeterinarians.generateVeterinarians();

  // ==================== STATISTIQUES ====================

  /// Statistiques sur les donnÃ©es de test
  static Map<String, int> get stats => {
        'animals': animals.length,
        'products': products.length,
        'treatments': treatments.length,
        'movements': movements.length,
        'batches': batches.length,
        'weights': weights.length,
        'veterinarians': veterinarians.length,
        'vaccinations': vaccinations.length,
      };

  // ==================== UTILITAIRES ====================
}
