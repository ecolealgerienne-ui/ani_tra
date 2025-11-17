// lib/models/animal_extensions.dart

import 'animal.dart';
import '../data/animal_config.dart';

/// Extensions pour le modèle Animal
///
/// Fournit des méthodes utilitaires pour afficher les informations
/// de type et de race de manière formatée.
extension AnimalDisplayExtensions on Animal {
  // ==================== TYPE (SPECIES) ====================

  /// Obtenir le nom du type d'animal selon la locale
  String getSpeciesName(String locale) {
    if (speciesId == null) return '';
    return AnimalConfig.getSpeciesName(speciesId!, locale);
  }

  /// Obtenir le nom du type en français
  String get speciesNameFr => getSpeciesName('fr');

  /// Obtenir le nom du type en anglais
  String get speciesNameEn => getSpeciesName('en');

  /// Obtenir le nom du type en arabe
  String get speciesNameAr => getSpeciesName('ar');

  /// Obtenir l'icône du type
  String get speciesIcon {
    if (speciesId == null) return '🐾';
    return AnimalConfig.getSpeciesIcon(speciesId!);
  }

  /// Vérifier si l'animal a un type défini
  bool get hasSpecies => speciesId != null && speciesId!.isNotEmpty;

  // ==================== RACE (BREED) ====================

  /// Vérifier si l'animal a une race définie
  bool get hasBreed => breedId != null && breedId!.isNotEmpty;

  // ==================== AFFICHAGE COMBINÉ ====================

  /// Obtenir le texte du type (species only, breed requires BreedProvider)
  /// Pour afficher la race, utiliser BreedProvider.getById(animal.breedId)
  String getSpeciesBreedDisplay(String locale) {
    if (!hasSpecies) return '';
    return getSpeciesName(locale);
  }

  /// Obtenir le type en français (species only)
  String get speciesBreedDisplayFr => getSpeciesBreedDisplay('fr');

  /// Obtenir le type en anglais (species only)
  String get speciesBreedDisplayEn => getSpeciesBreedDisplay('en');

  /// Obtenir le type en arabe (species only)
  String get speciesBreedDisplayAr => getSpeciesBreedDisplay('ar');

  /// Obtenir l'affichage avec icône : "🐑 Ovin"
  /// Pour inclure la race, utiliser BreedProvider.getById(animal.breedId)
  String getFullDisplay(String locale) {
    if (!hasSpecies) return '';
    return '$speciesIcon ${getSpeciesName(locale)}';
  }

  /// Obtenir l'affichage complet en français avec icône
  String get fullDisplayFr => getFullDisplay('fr');

  /// Obtenir l'affichage complet en anglais avec icône
  String get fullDisplayEn => getFullDisplay('en');

  /// Obtenir l'affichage complet en arabe avec icône
  String get fullDisplayAr => getFullDisplay('ar');

  // ==================== FORMATAGE POUR L'ÂGE ====================

  /// Obtenir l'âge formaté (utilisé déjà dans l'app)
  String get ageFormatted {
    final months = ageInMonths;
    if (months < 12) {
      return '$months mois';
    }
    final years = months ~/ 12;
    final remainingMonths = months % 12;
    if (remainingMonths == 0) {
      return '$years an${years > 1 ? 's' : ''}';
    }
    return '$years an${years > 1 ? 's' : ''} $remainingMonths mois';
  }
}
