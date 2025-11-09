// lib/providers/veterinarian_provider.dart
import 'package:flutter/foundation.dart';
import '../models/veterinarian.dart';
import '../repositories/veterinarian_repository.dart';
import 'auth_provider.dart';

/// VeterinarianProvider - Phase 1C
/// CHANGEMENT: Utilise Repository pour Veterinarians (SQLite)
class VeterinarianProvider with ChangeNotifier {
  final AuthProvider _authProvider;
  final VeterinarianRepository _repository;
  String _currentFarmId;

  // Données principales (cache local)
  final List<Veterinarian> _allVeterinarians = [];

  // Loading state
  bool _isLoading = false;

  VeterinarianProvider(this._authProvider, this._repository)
      : _currentFarmId = _authProvider.currentFarmId {
    _authProvider.addListener(_onFarmChanged);
    _loadVeterinariansFromRepository();
  }

  void _onFarmChanged() {
    if (_currentFarmId != _authProvider.currentFarmId) {
      _currentFarmId = _authProvider.currentFarmId;
      _loadVeterinariansFromRepository();
    }
  }

  // ==================== Getters ====================

  List<Veterinarian> get veterinarians => List.unmodifiable(
      _allVeterinarians.where((v) => v.farmId == _authProvider.currentFarmId));

  bool get isLoading => _isLoading;

  List<Veterinarian> get activeVeterinarians =>
      veterinarians.where((v) => v.isActive).toList();

  List<Veterinarian> get availableVeterinarians =>
      veterinarians.where((v) => v.isAvailable && v.isActive).toList();

  List<Veterinarian> get preferredVeterinarians =>
      veterinarians.where((v) => v.isPreferred && v.isActive).toList();

  List<Veterinarian> get emergencyVeterinarians => veterinarians
      .where((v) => v.emergencyService && v.isAvailable && v.isActive)
      .toList();

  Veterinarian? get defaultVeterinarian {
    try {
      return veterinarians.firstWhere(
        (v) => v.isDefault && v.isActive,
      );
    } catch (e) {
      return null;
    }
  }

  // ==================== Repository Loading ====================

  Future<void> _loadVeterinariansFromRepository() async {
    if (_currentFarmId.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final farmVeterinarians = await _repository.getAll(_currentFarmId);
      _allVeterinarians.removeWhere((v) => v.farmId == _currentFarmId);
      _allVeterinarians.addAll(farmVeterinarians);
    } catch (e) {
      debugPrint('❌ Error loading veterinarians from repository: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void loadMockVets(List<Veterinarian> mockVets) {
    _migrateVeterinariansToRepository(mockVets);
  }

  Future<void> _migrateVeterinariansToRepository(List<Veterinarian> vets) async {
    for (final vet in vets) {
      try {
        await _repository.create(vet, vet.farmId);
      } catch (e) {
        debugPrint('⚠️ Veterinarian ${vet.id} already exists or error: $e');
      }
    }
    await _loadVeterinariansFromRepository();
  }

  // ==================== Statistics ====================

  Map<String, dynamic> get stats {
    final active = activeVeterinarians;
    return {
      'total': active.length,
      'available': availableVeterinarians.length,
      'preferred': preferredVeterinarians.length,
      'emergency': emergencyVeterinarians.length,
      'totalInterventions':
          active.fold<int>(0, (sum, v) => sum + v.totalInterventions),
    };
  }

  List<String> get allSpecialties {
    final specialties = <String>{};
    for (var vet in activeVeterinarians) {
      specialties.addAll(vet.specialties);
    }
    return specialties.toList()..sort();
  }

  // ==================== CRUD ====================

  Future<void> addVeterinarian(Veterinarian veterinarian) async {
    final veterinarianWithFarm =
        veterinarian.copyWith(farmId: _authProvider.currentFarmId);

    try {
      await _repository.create(veterinarianWithFarm, _authProvider.currentFarmId);
      _allVeterinarians.add(veterinarianWithFarm);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error adding veterinarian: $e');
      rethrow;
    }
  }

  Future<void> updateVeterinarian(Veterinarian veterinarian) async {
    try {
      final updated = veterinarian.copyWith(updatedAt: DateTime.now());
      await _repository.update(updated, _authProvider.currentFarmId);
      
      final index = _allVeterinarians.indexWhere((v) => v.id == veterinarian.id);
      if (index != -1) {
        _allVeterinarians[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error updating veterinarian: $e');
      rethrow;
    }
  }

  Future<void> deleteVeterinarian(String id) async {
    try {
      final index = _allVeterinarians.indexWhere((v) => v.id == id);
      if (index != -1) {
        final updated = _allVeterinarians[index].copyWith(
          isActive: false,
          updatedAt: DateTime.now(),
        );
        await _repository.update(updated, _authProvider.currentFarmId);
        _allVeterinarians[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error deleting veterinarian: $e');
      rethrow;
    }
  }

  // ==================== Query Methods ====================

  Veterinarian? getVeterinarianById(String id) {
    try {
      return veterinarians.firstWhere((v) => v.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Veterinarian> getVeterinariansBySpecialty(String specialty) {
    return veterinarians
        .where((v) => v.specialties.contains(specialty) && v.isActive)
        .toList();
  }

  List<Veterinarian> searchVeterinarians(String query) {
    final lowerQuery = query.toLowerCase();
    return veterinarians.where((v) {
      return v.isActive &&
          (v.firstName.toLowerCase().contains(lowerQuery) ||
              v.lastName.toLowerCase().contains(lowerQuery) ||
              v.fullName.toLowerCase().contains(lowerQuery) ||
              (v.clinic?.toLowerCase().contains(lowerQuery) ?? false) ||
              (v.city?.toLowerCase().contains(lowerQuery) ?? false) ||
              v.specialties.any((s) => s.toLowerCase().contains(lowerQuery)));
    }).toList();
  }

  // ==================== Toggles ====================

  Future<void> togglePreferred(String id) async {
    final index = _allVeterinarians.indexWhere((v) => v.id == id);
    if (index != -1) {
      final updated = _allVeterinarians[index].copyWith(
        isPreferred: !_allVeterinarians[index].isPreferred,
        updatedAt: DateTime.now(),
      );
      await updateVeterinarian(updated);
    }
  }

  Future<void> toggleAvailability(String id) async {
    final index = _allVeterinarians.indexWhere((v) => v.id == id);
    if (index != -1) {
      final updated = _allVeterinarians[index].copyWith(
        isAvailable: !_allVeterinarians[index].isAvailable,
        updatedAt: DateTime.now(),
      );
      await updateVeterinarian(updated);
    }
  }

  Future<void> updateRating(String id, int rating) async {
    final index = _allVeterinarians.indexWhere((v) => v.id == id);
    if (index != -1) {
      final updated = _allVeterinarians[index].copyWith(
        rating: rating,
        updatedAt: DateTime.now(),
      );
      await updateVeterinarian(updated);
    }
  }

  Future<void> incrementInterventions(String id) async {
    final index = _allVeterinarians.indexWhere((v) => v.id == id);
    if (index != -1) {
      final updated = _allVeterinarians[index].copyWith(
        totalInterventions: _allVeterinarians[index].totalInterventions + 1,
        lastInterventionDate: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await updateVeterinarian(updated);
    }
  }

  // ==================== Statistics ====================

  Veterinarian? getMostActiveVeterinarian() {
    if (activeVeterinarians.isEmpty) return null;
    return activeVeterinarians
        .reduce((a, b) => a.totalInterventions > b.totalInterventions ? a : b);
  }

  List<Veterinarian> getVeterinariansByRating(int minRating) {
    return activeVeterinarians.where((v) => v.rating >= minRating).toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
  }

  // ==================== Refresh ====================

  Future<void> refresh() async {
    await _loadVeterinariansFromRepository();
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onFarmChanged);
    super.dispose();
  }
}
