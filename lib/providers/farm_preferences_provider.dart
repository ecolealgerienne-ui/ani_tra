// lib/providers/farm_preferences_provider.dart
import 'package:flutter/foundation.dart';
import '../models/farm_preferences.dart';
import '../repositories/farm_preferences_repository.dart';
import 'auth_provider.dart';

/// FarmPreferencesProvider - Phase 1 Farm Settings
/// Gère les préférences spécifiques à chaque ferme
/// Écoute les changements de ferme via AuthProvider
class FarmPreferencesProvider with ChangeNotifier {
  final AuthProvider _authProvider;
  final FarmPreferencesRepository _repository;
  String _currentFarmId;

  // Données principales (cache local par farmId)
  final Map<String, FarmPreferences> _preferencesCache = {};

  // Loading state
  bool _isLoading = false;

  FarmPreferencesProvider(this._authProvider, this._repository)
      : _currentFarmId = _authProvider.currentFarmId {
    _authProvider.addListener(_onFarmChanged);
    _loadPreferencesForCurrentFarm();
  }

  void _onFarmChanged() {
    if (_currentFarmId != _authProvider.currentFarmId) {
      _currentFarmId = _authProvider.currentFarmId;
      _loadPreferencesForCurrentFarm();
    }
  }

  // ==================== Getters ====================

  /// Préférences de la ferme actuellement sélectionnée
  FarmPreferences? get currentPreferences =>
      _preferencesCache[_authProvider.currentFarmId];

  /// Est-ce que la ferme actuelle a des préférences configurées
  bool get hasPreferences => currentPreferences != null;

  /// Vétérinaire par défaut de la ferme actuelle
  String? get defaultVeterinarianId =>
      currentPreferences?.defaultVeterinarianId;

  /// Type d'animal par défaut (species) de la ferme actuelle
  String get defaultSpeciesId =>
      currentPreferences?.defaultSpeciesId ?? 'sheep'; // Fallback

  /// Race par défaut de la ferme actuelle
  String? get defaultBreedId => currentPreferences?.defaultBreedId;

  /// Est-ce que la ferme a un vétérinaire par défaut configuré
  bool get hasDefaultVeterinarian =>
      currentPreferences?.hasDefaultVeterinarian ?? false;

  /// Est-ce que la ferme a une race par défaut configurée
  bool get hasDefaultBreed => currentPreferences?.hasDefaultBreed ?? false;

  bool get isLoading => _isLoading;

  // ==================== Repository Loading ====================

  Future<void> _loadPreferencesForCurrentFarm() async {
    if (_currentFarmId.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final preferences = await _repository.getByFarmId(_currentFarmId);
      if (preferences != null) {
        _preferencesCache[_currentFarmId] = preferences;
      } else {
        // Aucune préférence configurée pour cette ferme
        _preferencesCache.remove(_currentFarmId);
      }
    } catch (e) {
      debugPrint(
          '❌ Error loading farm preferences for $_currentFarmId: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==================== CRUD ====================

  /// Crée ou met à jour les préférences de la ferme actuelle
  Future<void> savePreferences(FarmPreferences preferences) async {
    try {
      final farmId = _authProvider.currentFarmId;
      final saved = await _repository.createOrUpdate(
        preferences.copyWith(farmId: farmId),
        farmId,
      );

      _preferencesCache[farmId] = saved;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error saving farm preferences: $e');
      rethrow;
    }
  }

  /// Met à jour le vétérinaire par défaut
  Future<void> updateDefaultVeterinarian(String? veterinarianId) async {
    final current = currentPreferences;
    if (current == null) {
      // Créer nouvelles préférences
      final newPreferences = FarmPreferences(
        id: '', // Sera généré par le repository
        farmId: _authProvider.currentFarmId,
        defaultVeterinarianId: veterinarianId,
        defaultSpeciesId: 'sheep', // Valeur par défaut
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await savePreferences(newPreferences);
    } else {
      // Mettre à jour existantes
      final updated = current.copyWith(
        defaultVeterinarianId: veterinarianId,
      );
      await savePreferences(updated);
    }
  }

  /// Met à jour le type d'animal par défaut (species)
  Future<void> updateDefaultSpecies(String speciesId) async {
    final current = currentPreferences;
    if (current == null) {
      // Créer nouvelles préférences
      final newPreferences = FarmPreferences(
        id: '', // Sera généré par le repository
        farmId: _authProvider.currentFarmId,
        defaultSpeciesId: speciesId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await savePreferences(newPreferences);
    } else {
      // Mettre à jour existantes
      final updated = current.copyWith(defaultSpeciesId: speciesId);
      await savePreferences(updated);
    }
  }

  /// Met à jour la race par défaut
  Future<void> updateDefaultBreed(String? breedId) async {
    final current = currentPreferences;
    if (current == null) {
      // Créer nouvelles préférences
      final newPreferences = FarmPreferences(
        id: '', // Sera généré par le repository
        farmId: _authProvider.currentFarmId,
        defaultSpeciesId: 'sheep', // Valeur par défaut
        defaultBreedId: breedId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await savePreferences(newPreferences);
    } else {
      // Mettre à jour existantes
      final updated = current.copyWith(defaultBreedId: breedId);
      await savePreferences(updated);
    }
  }

  /// Réinitialise les préférences de la ferme actuelle
  Future<void> resetPreferences() async {
    try {
      final farmId = _authProvider.currentFarmId;
      final current = currentPreferences;

      if (current != null) {
        await _repository.delete(current.id, farmId);
        _preferencesCache.remove(farmId);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error resetting farm preferences: $e');
      rethrow;
    }
  }

  // ==================== Helpers ====================

  /// Précharge les préférences pour une ferme spécifique
  /// Utile lors du changement de ferme pour éviter le délai
  Future<void> preloadPreferencesForFarm(String farmId) async {
    if (_preferencesCache.containsKey(farmId)) {
      return; // Déjà en cache
    }

    try {
      final preferences = await _repository.getByFarmId(farmId);
      if (preferences != null) {
        _preferencesCache[farmId] = preferences;
      }
    } catch (e) {
      debugPrint('⚠️ Could not preload preferences for farm $farmId: $e');
    }
  }

  /// Vide le cache des préférences
  void clearCache() {
    _preferencesCache.clear();
    notifyListeners();
  }

  // ==================== Refresh ====================

  Future<void> refresh() async {
    await _loadPreferencesForCurrentFarm();
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onFarmChanged);
    super.dispose();
  }
}
