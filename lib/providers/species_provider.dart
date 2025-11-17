// lib/providers/species_provider.dart

import 'package:flutter/foundation.dart';
import '../models/animal_species.dart';
import '../repositories/species_repository.dart';

/// SpeciesProvider - Phase 1B TIER 3
/// Lookup table provider (LECTURE SEULE, pas farmId)
/// Cache all species from SQLite pour accès rapide
class SpeciesProvider extends ChangeNotifier {
  final SpeciesRepository _repository;

  // Cache local
  final List<AnimalSpecies> _allSpecies = [];

  // Loading state
  bool _isLoading = false;
  bool _initialized = false;

  SpeciesProvider(this._repository) {
    _loadSpeciesFromRepository();
  }

  // ==================== Getters ====================

  List<AnimalSpecies> get allSpecies => List.unmodifiable(_allSpecies);

  bool get isLoading => _isLoading;

  bool get isInitialized => _initialized;

  int get count => _allSpecies.length;

  /// Toutes les espèces disponibles (ordonnées par displayOrder)
  List<AnimalSpecies> get availableSpecies {
    return _allSpecies.toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  }

  // ==================== Loading ====================

  /// ✅ FIXE: Charger les espèces de manière fiable
  /// Gère les erreurs sans bloquer l'app
  Future<void> _loadSpeciesFromRepository() async {
    // Éviter les appels multiples
    if (_initialized || _isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final species = await _repository.getAll();
      _allSpecies.clear();
      _allSpecies.addAll(species);
      _initialized = true;
    } catch (e) {
      _initialized = false;
      // Ne pas réappeler - attendre un refresh()
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==================== Query Methods ====================

  /// Obtenir une espèce par ID
  AnimalSpecies? getById(String id) {
    try {
      return _allSpecies.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Vérifier si une espèce existe
  bool exists(String id) {
    return _allSpecies.any((s) => s.id == id);
  }

  /// Obtenir le nom d'une espèce dans une locale
  String getSpeciesName(String speciesId, String locale) {
    final species = getById(speciesId);
    if (species == null) return speciesId;
    return species.getName(locale);
  }

  /// Obtenir l'icône d'une espèce
  String getSpeciesIcon(String speciesId) {
    final species = getById(speciesId);
    return species?.icon ?? '🐾';
  }

  /// Vérifier si une espèce est disponible
  bool isSpeciesAvailable(String speciesId) {
    return _allSpecies.any((s) => s.id == speciesId);
  }

  /// Chercher espèces par nom (any language)
  List<AnimalSpecies> search(String query) {
    if (query.isEmpty) return availableSpecies;

    final lowerQuery = query.toLowerCase();
    return _allSpecies
        .where((s) =>
            s.nameFr.toLowerCase().contains(lowerQuery) ||
            s.nameEn.toLowerCase().contains(lowerQuery) ||
            s.nameAr.contains(query))
        .toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  }

  // ==================== Utilities ====================

  void clear() {
    _allSpecies.clear();
    _initialized = false;
    notifyListeners();
  }

  /// Rafraîchir depuis DB
  Future<void> refresh() async {
    _initialized = false;
    await _loadSpeciesFromRepository();
  }

  @override
  String toString() =>
      'SpeciesProvider(${_allSpecies.length} species, initialized=$_initialized)';
}
