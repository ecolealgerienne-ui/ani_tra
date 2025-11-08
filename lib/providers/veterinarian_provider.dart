// lib/providers/veterinarian_provider.dart
import 'package:flutter/foundation.dart';
import '../models/veterinarian.dart';
import 'auth_provider.dart';

class VeterinarianProvider with ChangeNotifier {
  final AuthProvider _authProvider;
  String _currentFarmId;

  VeterinarianProvider(this._authProvider)
      : _currentFarmId = _authProvider.currentFarmId {
    _authProvider.addListener(_onFarmChanged);
  }

  void _onFarmChanged() {
    if (_currentFarmId != _authProvider.currentFarmId) {
      _currentFarmId = _authProvider.currentFarmId;
      notifyListeners();
    }
  }

  final List<Veterinarian> _allVeterinarians = [];

  List<Veterinarian> get veterinarians => List.unmodifiable(_allVeterinarians
      .where((item) => item.farmId == _authProvider.currentFarmId));

  // Filtres
  List<Veterinarian> get activeVeterinarians =>
      _allVeterinarians.where((v) => v.isActive).toList();

  List<Veterinarian> get availableVeterinarians =>
      _allVeterinarians.where((v) => v.isAvailable && v.isActive).toList();

  List<Veterinarian> get preferredVeterinarians =>
      _allVeterinarians.where((v) => v.isPreferred && v.isActive).toList();

  List<Veterinarian> get emergencyVeterinarians => _allVeterinarians
      .where((v) => v.emergencyService && v.isAvailable && v.isActive)
      .toList();

  // ✅ CORRECTION : Utiliser cast() au lieu de orElse avec null as Type
  Veterinarian? get defaultVeterinarian {
    try {
      return _allVeterinarians.firstWhere(
        (v) => v.isDefault && v.isActive,
      );
    } catch (e) {
      return null;
    }
  }

  // ==================== Mock Data ====================

  void loadMockVets(List<Veterinarian> mockVets) {
    _allVeterinarians.clear();
    _allVeterinarians.addAll(mockVets);
    notifyListeners();
  }

  // Statistiques
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

  // Spécialités disponibles
  List<String> get allSpecialties {
    final specialties = <String>{};
    for (var vet in activeVeterinarians) {
      specialties.addAll(vet.specialties);
    }
    return specialties.toList()..sort();
  }

  // CRUD Operations
  Veterinarian? getVeterinarianById(String id) {
    try {
      return _allVeterinarians.firstWhere((v) => v.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Veterinarian> getVeterinariansBySpecialty(String specialty) {
    return _allVeterinarians
        .where((v) => v.specialties.contains(specialty) && v.isActive)
        .toList();
  }

  List<Veterinarian> searchVeterinarians(String query) {
    final lowerQuery = query.toLowerCase();
    return _allVeterinarians.where((v) {
      return v.isActive &&
          (v.firstName.toLowerCase().contains(lowerQuery) ||
              v.lastName.toLowerCase().contains(lowerQuery) ||
              v.fullName.toLowerCase().contains(lowerQuery) ||
              (v.clinic?.toLowerCase().contains(lowerQuery) ?? false) ||
              (v.city?.toLowerCase().contains(lowerQuery) ?? false) ||
              v.specialties.any((s) => s.toLowerCase().contains(lowerQuery)));
    }).toList();
  }

  void addVeterinarian(Veterinarian veterinarian) {
    final veterinarianWithFarm =
        veterinarian.copyWith(farmId: _authProvider.currentFarmId);
    _allVeterinarians.add(veterinarianWithFarm);
    notifyListeners();
  }

  void updateVeterinarian(Veterinarian veterinarian) {
    final index = _allVeterinarians.indexWhere((v) => v.id == veterinarian.id);
    if (index != -1) {
      _allVeterinarians[index] =
          veterinarian.copyWith(updatedAt: DateTime.now());
      notifyListeners();
    }
  }

  void deleteVeterinarian(String id) {
    final index = _allVeterinarians.indexWhere((v) => v.id == id);
    if (index != -1) {
      _allVeterinarians[index] = _allVeterinarians[index].copyWith(
        isActive: false,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  // Gestion des préférés
  void togglePreferred(String id) {
    final index = _allVeterinarians.indexWhere((v) => v.id == id);
    if (index != -1) {
      _allVeterinarians[index] = _allVeterinarians[index].copyWith(
        isPreferred: !_allVeterinarians[index].isPreferred,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  // Gestion de la disponibilité
  void toggleAvailability(String id) {
    final index = _allVeterinarians.indexWhere((v) => v.id == id);
    if (index != -1) {
      _allVeterinarians[index] = _allVeterinarians[index].copyWith(
        isAvailable: !_allVeterinarians[index].isAvailable,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  // Mise à jour du rating
  void updateRating(String id, int rating) {
    final index = _allVeterinarians.indexWhere((v) => v.id == id);
    if (index != -1) {
      _allVeterinarians[index] = _allVeterinarians[index].copyWith(
        rating: rating,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  // Incrémenter les interventions
  void incrementInterventions(String id) {
    final index = _allVeterinarians.indexWhere((v) => v.id == id);
    if (index != -1) {
      _allVeterinarians[index] = _allVeterinarians[index].copyWith(
        totalInterventions: _allVeterinarians[index].totalInterventions + 1,
        lastInterventionDate: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  // Obtenir le vétérinaire le plus actif
  Veterinarian? getMostActiveVeterinarian() {
    if (activeVeterinarians.isEmpty) return null;
    return activeVeterinarians
        .reduce((a, b) => a.totalInterventions > b.totalInterventions ? a : b);
  }

  // Obtenir les vétérinaires par note
  List<Veterinarian> getVeterinariansByRating(int minRating) {
    return activeVeterinarians.where((v) => v.rating >= minRating).toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onFarmChanged);
    super.dispose();
  }
}
