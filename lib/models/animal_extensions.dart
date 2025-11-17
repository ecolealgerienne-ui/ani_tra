// lib/models/animal_extensions.dart

import 'animal.dart';
import '../providers/species_provider.dart';

/// Extensions pour le modèle Animal
///
/// Fournit des méthodes utilitaires pour afficher les informations
/// de type et de race de manière formatée.
extension AnimalDisplayExtensions on Animal {
  // ==================== TYPE (SPECIES) ====================

  /// Obtenir le nom du type d'animal selon la locale
  /// Nécessite un SpeciesProvider pour charger les données depuis la DB
  String getSpeciesName(String locale, SpeciesProvider? speciesProvider) {
    if (speciesId == null) return '';
    if (speciesProvider == null) return speciesId!;
    return speciesProvider.getSpeciesName(speciesId!, locale);
  }

  /// Obtenir le nom du type en français
  String speciesNameFr(SpeciesProvider? speciesProvider) => getSpeciesName('fr', speciesProvider);

  /// Obtenir le nom du type en anglais
  String speciesNameEn(SpeciesProvider? speciesProvider) => getSpeciesName('en', speciesProvider);

  /// Obtenir le nom du type en arabe
  String speciesNameAr(SpeciesProvider? speciesProvider) => getSpeciesName('ar', speciesProvider);

  /// Obtenir l'icône du type
  String speciesIcon(SpeciesProvider? speciesProvider) {
    if (speciesId == null) return '🐾';
    if (speciesProvider == null) return '🐾';
    return speciesProvider.getSpeciesIcon(speciesId!);
  }

  /// Vérifier si l'animal a un type défini
  bool get hasSpecies => speciesId != null && speciesId!.isNotEmpty;

  // ==================== RACE (BREED) ====================

  /// Vérifier si l'animal a une race définie
  bool get hasBreed => breedId != null && breedId!.isNotEmpty;

  // ==================== AFFICHAGE COMBINÉ ====================

  /// Obtenir le texte du type (species only, breed requires BreedProvider)
  /// Pour afficher la race, utiliser BreedProvider.getById(animal.breedId)
  String getSpeciesBreedDisplay(String locale, SpeciesProvider? speciesProvider) {
    if (!hasSpecies) return '';
    return getSpeciesName(locale, speciesProvider);
  }

  /// Obtenir le type en français (species only)
  String speciesBreedDisplayFr(SpeciesProvider? speciesProvider) => getSpeciesBreedDisplay('fr', speciesProvider);

  /// Obtenir le type en anglais (species only)
  String speciesBreedDisplayEn(SpeciesProvider? speciesProvider) => getSpeciesBreedDisplay('en', speciesProvider);

  /// Obtenir le type en arabe (species only)
  String speciesBreedDisplayAr(SpeciesProvider? speciesProvider) => getSpeciesBreedDisplay('ar', speciesProvider);

  /// Obtenir l'affichage avec icône : "🐑 Ovin"
  /// Pour inclure la race, utiliser BreedProvider.getById(animal.breedId)
  String getFullDisplay(String locale, SpeciesProvider? speciesProvider) {
    if (!hasSpecies) return '';
    return '${speciesIcon(speciesProvider)} ${getSpeciesName(locale, speciesProvider)}';
  }

  /// Obtenir l'affichage complet en français avec icône
  String fullDisplayFr(SpeciesProvider? speciesProvider) => getFullDisplay('fr', speciesProvider);

  /// Obtenir l'affichage complet en anglais avec icône
  String fullDisplayEn(SpeciesProvider? speciesProvider) => getFullDisplay('en', speciesProvider);

  /// Obtenir l'affichage complet en arabe avec icône
  String fullDisplayAr(SpeciesProvider? speciesProvider) => getFullDisplay('ar', speciesProvider);

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
