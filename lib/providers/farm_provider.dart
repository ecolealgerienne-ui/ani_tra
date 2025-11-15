// lib/providers/farm_provider.dart
import 'package:flutter/foundation.dart';
import '../models/farm.dart';
import '../repositories/farm_repository.dart';
import 'auth_provider.dart';

/// FarmProvider - Phase 1 Farm Settings
/// Gère la liste des fermes disponibles pour l'utilisateur
class FarmProvider with ChangeNotifier {
  final AuthProvider _authProvider;
  final FarmRepository _repository;

  // Données principales (cache local)
  final List<Farm> _allFarms = [];

  // Loading state
  bool _isLoading = false;

  FarmProvider(this._authProvider, this._repository) {
    _authProvider.addListener(_onAuthChanged);
    _loadFarmsFromRepository();
  }

  void _onAuthChanged() {
    // Recharger les fermes si l'utilisateur change
    _loadFarmsFromRepository();
  }

  // ==================== Getters ====================

  /// Toutes les fermes de l'utilisateur actuel
  List<Farm> get farms => List.unmodifiable(_allFarms);

  /// Ferme actuellement sélectionnée
  Farm? get currentFarm {
    try {
      return _allFarms.firstWhere(
        (f) => f.id == _authProvider.currentFarmId,
      );
    } catch (e) {
      return null;
    }
  }

  /// ID de la ferme actuelle (délégué à AuthProvider)
  String get currentFarmId => _authProvider.currentFarmId;

  /// Est-ce qu'une ferme est actuellement sélectionnée
  bool get hasCurrentFarm =>
      _authProvider.currentFarmId.isNotEmpty &&
      _authProvider.currentFarmId != 'farm_default';

  bool get isLoading => _isLoading;

  // ==================== Repository Loading ====================

  Future<void> _loadFarmsFromRepository() async {
    _isLoading = true;
    notifyListeners();

    try {
      // En Phase 1: charger toutes les fermes
      // En Phase 2: filtrer par ownerId de l'utilisateur actuel
      final allFarms = await _repository.getAll();
      _allFarms.clear();
      _allFarms.addAll(allFarms);
    } catch (e) {
      // Ignore errors
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Charge les fermes pour un utilisateur spécifique (Phase 2)
  Future<void> loadFarmsForOwner(String ownerId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final ownerFarms = await _repository.getByOwnerId(ownerId);
      _allFarms.clear();
      _allFarms.addAll(ownerFarms);
    } catch (e) {
      // Ignore errors
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==================== CRUD ====================

  Future<void> addFarm(Farm farm) async {
    try {
      await _repository.create(farm);
      _allFarms.add(farm);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateFarm(Farm farm) async {
    try {
      final updated = farm.copyWith(updatedAt: DateTime.now());
      await _repository.update(updated);

      final index = _allFarms.indexWhere((f) => f.id == farm.id);
      if (index != -1) {
        _allFarms[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteFarm(String id) async {
    try {
      await _repository.delete(id);
      _allFarms.removeWhere((f) => f.id == id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // ==================== Query Methods ====================

  Farm? getFarmById(String id) {
    try {
      return _allFarms.firstWhere((f) => f.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<Farm?> getFarmByCheptelNumber(String cheptelNumber) async {
    try {
      return await _repository.getByCheptelNumber(cheptelNumber);
    } catch (e) {
      return null;
    }
  }

  List<Farm> searchFarms(String query) {
    final lowerQuery = query.toLowerCase();
    return _allFarms.where((f) {
      return f.name.toLowerCase().contains(lowerQuery) ||
          f.location.toLowerCase().contains(lowerQuery) ||
          (f.cheptelNumber?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  // ==================== Farm Selection ====================

  /// Change la ferme actuelle (délégué à AuthProvider)
  /// AuthProvider notifiera tous les listeners (y compris ce provider)
  Future<void> switchFarm(String farmId) async {
    try {
      await _authProvider.switchFarm(farmId);
    } catch (e) {
      rethrow;
    }
  }

  // ==================== Statistics ====================

  int get totalFarms => _allFarms.length;

  // ==================== Refresh ====================

  Future<void> refresh() async {
    await _loadFarmsFromRepository();
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onAuthChanged);
    super.dispose();
  }
}
