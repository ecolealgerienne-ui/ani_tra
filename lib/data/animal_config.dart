// lib/data/animal_config.dart

import '../models/animal_species.dart';

/// Configuration centralisée des types d'animaux
///
/// Point unique de configuration pour :
/// - Les types d'animaux disponibles dans l'application
/// - Les valeurs par défaut
///
/// Cette configuration est utilisée dans toute l'application pour :
/// - Les dropdowns de sélection
/// - Les filtres
/// - Les statistiques
/// - La validation
///
/// NOTE: Pour les races, utiliser directement le BreedProvider qui charge depuis la DB
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

  /// Vérifier si un type d'animal est disponible
  static bool isSpeciesAvailable(String speciesId) {
    return availableSpecies.any((species) => species.id == speciesId);
  }

  /// Obtenir le nom d'un type selon la locale
  static String getSpeciesName(String speciesId, String locale) {
    final species = getSpeciesById(speciesId);
    if (species == null) return speciesId;
    return species.getName(locale);
  }

  /// Obtenir l'icône d'un type
  static String getSpeciesIcon(String speciesId) {
    final species = getSpeciesById(speciesId);
    return species?.icon ?? '🐾';
  }

  // ==================== STATISTIQUES ====================

  /// Nombre total de types disponibles
  static int get totalSpecies => availableSpecies.length;
}
