// lib/data/mock_data.dart
// Point d'entrée principal pour toutes les données de test

import '../models/animal.dart';
import '../models/product.dart';
import '../models/treatment.dart';
import '../models/movement.dart';
import '../models/batch.dart';
import '../models/weight_record.dart';
import '../models/veterinarian.dart';

// Import des mocks séparés
import 'mocks/mock_animals.dart';
import 'mocks/mock_products.dart';
import 'mocks/mock_treatments.dart';
import 'mocks/mock_movements.dart';
import 'mocks/mock_batches.dart';
import 'mocks/mock_weights.dart';
import 'mocks/mock_veterinarians.dart';

/// Classe principale pour accéder à toutes les données de test
///
/// Centralise l'accès aux mocks pour faciliter l'initialisation
/// et la maintenance des données de test.
///
/// Usage:
/// ```dart
/// final animals = MockData.animals;
/// final products = MockData.products;
/// ```
class MockData {
  // ==================== ANIMAUX ====================

  /// Liste complète des animaux de test (20 animaux)
  static List<Animal> get animals => MockAnimals.generateAnimals();

  /// Méthode pour générer les animaux (alias pour compatibilité)
  static List<Animal> generateAnimals() => MockAnimals.generateAnimals();

  // ==================== PRODUITS ====================

  /// Liste complète des produits sanitaires (10 produits)
  static List<Product> get products => MockProducts.generateProducts();

  /// Méthode pour générer les produits (alias pour compatibilité)
  static List<Product> generateProducts() => MockProducts.generateProducts();

  // ==================== TRAITEMENTS ====================

  /// Liste des traitements (5 traitements)
  static List<Treatment> get treatments => MockTreatments.generateTreatments();

  /// Méthode pour générer les traitements (alias pour compatibilité)
  static List<Treatment> generateTreatments() =>
      MockTreatments.generateTreatments();

  // ==================== MOUVEMENTS ====================

  /// Liste des mouvements d'animaux (6 mouvements)
  static List<Movement> get movements => MockMovements.generateMovements();

  /// Méthode pour générer les mouvements (alias pour compatibilité)
  static List<Movement> generateMovements() =>
      MockMovements.generateMovements();

  // ==================== LOTS ====================

  /// Liste des lots (6 lots)
  static List<Batch> get batches => MockBatches.generateBatches();

  /// Méthode pour générer les lots (alias pour compatibilité)
  static List<Batch> generateBatches() => MockBatches.generateBatches();

  // ==================== PESÉES ====================

  /// Liste des pesées (17 pesées)
  static List<WeightRecord> get weights => MockWeights.generateWeights();

  /// Méthode pour générer les pesées (alias pour compatibilité)
  static List<WeightRecord> generateWeights() => MockWeights.generateWeights();

  // ==================== VÉTÉRINAIRES ====================

  /// Liste des vétérinaires (10 vétérinaires)
  static List<Veterinarian> get veterinarians =>
      MockVeterinarians.generateVeterinarians();

  /// Méthode pour générer les vétérinaires (alias pour compatibilité)
  static List<Veterinarian> generateVeterinarians() =>
      MockVeterinarians.generateVeterinarians();

  // ==================== STATISTIQUES ====================

  /// Statistiques sur les données de test
  static Map<String, int> get stats => {
        'animals': animals.length,
        'products': products.length,
        'treatments': treatments.length,
        'movements': movements.length,
        'batches': batches.length,
        'weights': weights.length,
        'veterinarians': veterinarians.length,
      };

  // ==================== UTILITAIRES ====================

  /// Affiche un résumé des données de test dans la console
  static void printSummary() {
    print('📊 Données de Test - Résumé');
    print('━' * 50);
    stats.forEach((key, value) {
      print('  $key: $value');
    });
    print('━' * 50);
  }
}
