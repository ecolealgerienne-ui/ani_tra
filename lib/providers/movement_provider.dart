// lib/providers/movement_provider.dart

import 'package:flutter/foundation.dart';
import '../models/movement.dart';
import '../repositories/movement_repository.dart';
import 'auth_provider.dart';

/// MovementProvider
/// Gère l'état des mouvements d'animaux (naissances, achats, ventes, décès, abattages)
class MovementProvider with ChangeNotifier {
  final AuthProvider _authProvider;
  final MovementRepository _repository;
  String _currentFarmId;

  // Données principales (cache local)
  final List<Movement> _allMovements = [];

  // Loading state
  bool _isLoading = false;

  // Filtres
  MovementType? _typeFilter;
  DateTime? _startDateFilter;
  DateTime? _endDateFilter;

  MovementProvider(this._authProvider, this._repository)
      : _currentFarmId = _authProvider.currentFarmId {
    _authProvider.addListener(_onFarmChanged);
    _loadMovementsFromRepository();
  }

  void _onFarmChanged() {
    if (_currentFarmId != _authProvider.currentFarmId) {
      _currentFarmId = _authProvider.currentFarmId;
      _typeFilter = null;
      _startDateFilter = null;
      _endDateFilter = null;
      _loadMovementsFromRepository();
    }
  }

  // ==================== Getters ====================

  List<Movement> get movements => List.unmodifiable(
      _allMovements.where((m) => m.farmId == _authProvider.currentFarmId));

  bool get isLoading => _isLoading;
  MovementType? get typeFilter => _typeFilter;
  DateTime? get startDateFilter => _startDateFilter;
  DateTime? get endDateFilter => _endDateFilter;

  /// Mouvements filtrés selon les critères actifs
  List<Movement> get filteredMovements {
    Iterable<Movement> list = movements;

    // Filtre par type
    if (_typeFilter != null) {
      list = list.where((m) => m.type == _typeFilter);
    }

    // Filtre par période
    if (_startDateFilter != null) {
      list = list.where((m) => m.movementDate.isAfter(_startDateFilter!) ||
          m.movementDate.isAtSameMomentAs(_startDateFilter!));
    }
    if (_endDateFilter != null) {
      list = list.where((m) => m.movementDate.isBefore(_endDateFilter!) ||
          m.movementDate.isAtSameMomentAs(_endDateFilter!));
    }

    // Trier par date décroissante (plus récent en premier)
    final sorted = list.toList()
      ..sort((a, b) => b.movementDate.compareTo(a.movementDate));

    return List<Movement>.unmodifiable(sorted);
  }

  /// Mouvements par type
  List<Movement> getMovementsByType(MovementType type) {
    return movements.where((m) => m.type == type).toList()
      ..sort((a, b) => b.movementDate.compareTo(a.movementDate));
  }

  /// Mouvements d'un animal spécifique
  List<Movement> getMovementsByAnimalId(String animalId) {
    return movements.where((m) => m.animalId == animalId).toList()
      ..sort((a, b) => b.movementDate.compareTo(a.movementDate));
  }

  /// Statistiques par type
  int getCountByType(MovementType type) {
    return movements.where((m) => m.type == type).length;
  }

  // ==================== Repository Loading ====================

  Future<void> _loadMovementsFromRepository() async {
    if (_currentFarmId.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final farmMovements = await _repository.getAll(_currentFarmId);
      _allMovements.removeWhere((m) => m.farmId == _currentFarmId);
      _allMovements.addAll(farmMovements);
    } catch (e) {
      debugPrint('Error loading movements: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Rafraîchir les mouvements
  Future<void> refresh() async {
    await _loadMovementsFromRepository();
  }

  // ==================== Filtres ====================

  void setTypeFilter(MovementType? type) {
    _typeFilter = type;
    notifyListeners();
  }

  void setDateRangeFilter(DateTime? startDate, DateTime? endDate) {
    _startDateFilter = startDate;
    _endDateFilter = endDate;
    notifyListeners();
  }

  void clearFilters() {
    _typeFilter = null;
    _startDateFilter = null;
    _endDateFilter = null;
    notifyListeners();
  }

  // ==================== CRUD Operations ====================

  /// Ajouter un mouvement
  Future<void> addMovement(Movement movement) async {
    try {
      await _repository.create(movement, _currentFarmId);
      await _loadMovementsFromRepository();
    } catch (e) {
      debugPrint('Error creating movement: $e');
      rethrow;
    }
  }

  /// Mettre à jour un mouvement
  Future<void> updateMovement(Movement movement) async {
    try {
      await _repository.update(movement, _currentFarmId);
      await _loadMovementsFromRepository();
    } catch (e) {
      debugPrint('Error updating movement: $e');
      rethrow;
    }
  }

  /// Supprimer un mouvement
  Future<void> deleteMovement(String movementId) async {
    try {
      await _repository.delete(movementId, _currentFarmId);
      await _loadMovementsFromRepository();
    } catch (e) {
      debugPrint('Error deleting movement: $e');
      rethrow;
    }
  }

  /// Récupérer un mouvement par ID
  Movement? getMovementById(String id) {
    try {
      return movements.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  // ==================== Initialisation ====================

  void initializeWithInitialData(List<Movement> movements) {
    _migrateMovementsToRepository(movements);
  }

  Future<void> _migrateMovementsToRepository(List<Movement> movements) async {
    for (final movement in movements) {
      try {
        final existing = await _repository.getById(movement.id, _currentFarmId);
        if (existing == null) {
          await _repository.create(movement, _currentFarmId);
        }
      } catch (e) {
        debugPrint('Error migrating movement ${movement.id}: $e');
      }
    }
    await _loadMovementsFromRepository();
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onFarmChanged);
    super.dispose();
  }
}
