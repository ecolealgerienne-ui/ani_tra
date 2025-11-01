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

  /// Obtenir le nom de la race selon la locale
  String getBreedName(String locale) {
    if (breedId == null) return '';
    return AnimalConfig.getBreedName(breedId!, locale);
  }

  /// Obtenir le nom de la race en français
  String get breedNameFr => getBreedName('fr');

  /// Obtenir le nom de la race en anglais
  String get breedNameEn => getBreedName('en');

  /// Obtenir le nom de la race en arabe
  String get breedNameAr => getBreedName('ar');

  /// Vérifier si l'animal a une race définie
  bool get hasBreed => breedId != null && breedId!.isNotEmpty;

  // ==================== AFFICHAGE COMBINÉ ====================

  /// Obtenir le texte complet "Type - Race" selon la locale
  String getSpeciesBreedDisplay(String locale) {
    if (!hasSpecies) return '';

    final speciesName = getSpeciesName(locale);

    if (!hasBreed) {
      return speciesName;
    }

    final breedName = getBreedName(locale);
    return '$speciesName - $breedName';
  }

  /// Obtenir "Type - Race" en français
  String get speciesBreedDisplayFr => getSpeciesBreedDisplay('fr');

  /// Obtenir "Type - Race" en anglais
  String get speciesBreedDisplayEn => getSpeciesBreedDisplay('en');

  /// Obtenir "Type - Race" en arabe
  String get speciesBreedDisplayAr => getSpeciesBreedDisplay('ar');

  /// Obtenir l'affichage complet avec icône : "🐑 Ovin - Mérinos"
  String getFullDisplay(String locale) {
    if (!hasSpecies) return '';
    return '$speciesIcon ${getSpeciesBreedDisplay(locale)}';
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
