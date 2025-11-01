// lib/data/animal_config.dart

import '../models/animal_species.dart';
import '../models/breed.dart';
import 'mocks/mock_breeds.dart';

/// Configuration centralisée des types d'animaux et races
///
/// Point unique de configuration pour :
/// - Les types d'animaux disponibles dans l'application
/// - Les races disponibles par type
/// - Les valeurs par défaut
///
/// Cette configuration est utilisée dans toute l'application pour :
/// - Les dropdowns de sélection
/// - Les filtres
/// - Les statistiques
/// - La validation
class AnimalConfig {
  // ==================== TYPES DISPONIBLES ====================

  /// Types d'animaux disponibles dans l'application
  ///
  /// Pour activer/désactiver un type, il suffit de commenter/décommenter la ligne.
  /// L'ordre dans cette liste détermine l'ordre d'affichage dans l'UI.
  static const List<AnimalSpecies> availableSpecies = [
    CommonAnimalSpecies.sheep, // Ovin (activé)
    CommonAnimalSpecies.cattle, // Bovin (activé)
    CommonAnimalSpecies.goat, // Caprin (activé)
    // Ajouter d'autres types ici si nécessaire
  ];

  // ==================== RACES DISPONIBLES ====================

  /// Races disponibles par type d'animal
  ///
  /// Pour ajouter une race, modifier le fichier mock_breeds.dart
  static List<Breed> get availableBreeds => MockBreeds.getAllBreeds();

  // ==================== VALEURS PAR DÉFAUT ====================

  /// Type d'animal par défaut (Ovin)
  static const String defaultSpeciesId = 'sheep';

  /// Race par défaut (Mérinos)
  static const String defaultBreedId = 'merinos';

  // ==================== MÉTHODES UTILITAIRES ====================

  /// Obtenir un type d'animal par ID
  static AnimalSpecies? getSpeciesById(String id) {
    try {
      return availableSpecies.firstWhere((species) => species.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Obtenir les races pour un type d'animal
  static List<Breed> getBreedsBySpecies(String speciesId) {
    return MockBreeds.getBreedsBySpecies(speciesId);
  }

  /// Obtenir une race par ID
  static Breed? getBreedById(String breedId) {
    return MockBreeds.getBreedById(breedId);
  }

  /// Vérifier si un type d'animal est disponible
  static bool isSpeciesAvailable(String speciesId) {
    return availableSpecies.any((species) => species.id == speciesId);
  }

  /// Vérifier si une race est disponible
  static bool isBreedAvailable(String breedId) {
    return availableBreeds.any((breed) => breed.id == breedId);
  }

  /// Obtenir le nom d'un type selon la locale
  static String getSpeciesName(String speciesId, String locale) {
    final species = getSpeciesById(speciesId);
    if (species == null) return speciesId;
    return species.getName(locale);
  }

  /// Obtenir le nom d'une race selon la locale
  static String getBreedName(String breedId, String locale) {
    final breed = getBreedById(breedId);
    if (breed == null) return breedId;
    return breed.getName(locale);
  }

  /// Obtenir l'icône d'un type
  static String getSpeciesIcon(String speciesId) {
    final species = getSpeciesById(speciesId);
    return species?.icon ?? '🐾';
  }

  // ==================== VALIDATION ====================

  /// Valider qu'un type et une race sont compatibles
  static bool isValidBreedForSpecies(String breedId, String speciesId) {
    final breed = getBreedById(breedId);
    if (breed == null) return false;
    return breed.speciesId == speciesId;
  }

  /// Obtenir la première race disponible pour un type
  static String? getFirstBreedForSpecies(String speciesId) {
    final breeds = getBreedsBySpecies(speciesId);
    if (breeds.isEmpty) return null;
    return breeds.first.id;
  }

  // ==================== STATISTIQUES ====================

  /// Nombre total de types disponibles
  static int get totalSpecies => availableSpecies.length;

  /// Nombre total de races disponibles
  static int get totalBreeds => availableBreeds.length;

  /// Nombre de races par type
  static Map<String, int> get breedCountBySpecies {
    final Map<String, int> counts = {};
    for (final species in availableSpecies) {
      counts[species.id] = getBreedsBySpecies(species.id).length;
    }
    return counts;
  }
}
