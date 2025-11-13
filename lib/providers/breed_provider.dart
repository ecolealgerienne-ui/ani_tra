// lib/providers/breed_provider.dart

import 'package:flutter/foundation.dart';
import '../models/breed.dart';
import '../repositories/breed_repository.dart';

/// BreedProvider - Phase 1B TIER 3
/// Lookup table provider (LECTURE SEULE, pas farmId)
/// Cache all breeds from SQLite pour accès rapide
class BreedProvider extends ChangeNotifier {
  final BreedRepository _repository;

  // Cache local
  final List<Breed> _allBreeds = [];

  // Loading state
  bool _isLoading = false;
  bool _initialized = false;

  BreedProvider(this._repository) {
    _loadBreedsFromRepository();
  }

  // ==================== Getters ====================

  List<Breed> get allBreeds => List.unmodifiable(_allBreeds);

  bool get isLoading => _isLoading;

  bool get isInitialized => _initialized;

  int get count => _allBreeds.length;

  /// Toutes les races actives (ordonnées par displayOrder)
  List<Breed> get activeBreeds {
    return _allBreeds.where((b) => b.isActive).toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  }

  // ==================== Loading ====================

  /// ✅ FIXE: Charger les races de manière fiable
  /// Gère les erreurs sans bloquer l'app
  Future<void> _loadBreedsFromRepository() async {
    // Éviter les appels multiples
    if (_initialized || _isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final breeds = await _repository.getAll();
      _allBreeds.clear();
      _allBreeds.addAll(breeds);
      _initialized = true;
      debugPrint('✅ BreedProvider: ${_allBreeds.length} races chargées');
    } catch (e) {
      debugPrint('❌ BreedProvider ERROR: $e');
      _initialized = false;
      // Ne pas réappeler - attendre un refresh()
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==================== Query Methods ====================

  /// Obtenir une race par ID
  Breed? getById(String id) {
    try {
      return _allBreeds.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Toutes les races d'une espèce
  List<Breed> getBySpeciesId(String speciesId) {
    return _allBreeds.where((b) => b.speciesId == speciesId).toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  }

  /// Races actives d'une espèce
  List<Breed> getActiveBySpeciesId(String speciesId) {
    return _allBreeds
        .where((b) => b.speciesId == speciesId && b.isActive)
        .toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  }

  /// Chercher races par nom (any language)
  List<Breed> search(String query) {
    if (query.isEmpty) return activeBreeds;

    final lowerQuery = query.toLowerCase();
    return _allBreeds
        .where((b) =>
            b.nameFr.toLowerCase().contains(lowerQuery) ||
            b.nameEn.toLowerCase().contains(lowerQuery) ||
            b.nameAr.contains(query))
        .toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  }

  /// Compter races par espèce
  int countBySpeciesId(String speciesId) {
    return _allBreeds.where((b) => b.speciesId == speciesId).length;
  }

  /// Compter races actives par espèce
  int countActiveBySpeciesId(String speciesId) {
    return _allBreeds
        .where((b) => b.speciesId == speciesId && b.isActive)
        .length;
  }

  /// Vérifier si une race existe
  bool exists(String id) {
    return _allBreeds.any((b) => b.id == id);
  }

  /// Obtenir le nom d'une race dans une locale
  String? getBreedName(String breedId, String locale) {
    final breed = getById(breedId);
    return breed?.getName(locale);
  }

  // ==================== Utilities ====================

  void clear() {
    _allBreeds.clear();
    _initialized = false;
    notifyListeners();
  }

  /// Rafraîchir depuis DB
  Future<void> refresh() async {
    _initialized = false;
    await _loadBreedsFromRepository();
  }

  @override
  String toString() =>
      'BreedProvider(${_allBreeds.length} breeds, initialized=$_initialized)';
}
