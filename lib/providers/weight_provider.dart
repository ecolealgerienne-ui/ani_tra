// lib/providers/weight_provider.dart
import 'package:flutter/foundation.dart';
import '../models/weight_record.dart';
import '../repositories/weight_repository.dart';
import 'auth_provider.dart';

/// WeightProvider - Phase 1C
/// CHANGEMENT: Utilise Repository pour WeightRecords (SQLite)
class WeightProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  final WeightRepository _repository;
  String _currentFarmId;

  // Données principales (cache local)
  final List<WeightRecord> _allWeightRecords = [];

  // Loading state
  bool _isLoading = false;

  // Constantes
  static const String kLogWeightsSet = 'log.weight.set_list';
  static const String kLogWeightAdded = 'log.weight.added';
  static const String kLogWeightUpdated = 'log.weight.updated';
  static const String kLogWeightRemoved = 'log.weight.removed';

  WeightProvider(this._authProvider, this._repository)
      : _currentFarmId = _authProvider.currentFarmId {
    _authProvider.addListener(_onFarmChanged);
    _loadWeightsFromRepository();
  }

  void _onFarmChanged() {
    if (_currentFarmId != _authProvider.currentFarmId) {
      _currentFarmId = _authProvider.currentFarmId;
      _loadWeightsFromRepository();
    }
  }

  // ==================== Getters ====================

  List<WeightRecord> get weights => List.unmodifiable(
      _allWeightRecords.where((w) => w.farmId == _authProvider.currentFarmId));

  bool get isLoading => _isLoading;

  List<WeightRecord> get timelineSorted {
    final copy = [...weights];
    copy.sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    return copy;
  }

  // ==================== Repository Loading ====================

  Future<void> _loadWeightsFromRepository() async {
    if (_currentFarmId.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final farmWeights = await _repository.getAll(_currentFarmId);
      _allWeightRecords.removeWhere((w) => w.farmId == _currentFarmId);
      _allWeightRecords.addAll(farmWeights);
    } catch (e) {
      debugPrint('❌ Error loading weights from repository: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setWeights(List<WeightRecord> items) {
    _migrateWeightsToRepository(items);
  }

  Future<void> _migrateWeightsToRepository(List<WeightRecord> weights) async {
    for (final weight in weights) {
      try {
        await _repository.create(weight, weight.farmId);
      } catch (e) {
        debugPrint('⚠️ Weight ${weight.id} already exists or error: $e');
      }
    }
    await _loadWeightsFromRepository();
  }

  // ==================== CRUD ====================

  Future<void> addWeight(WeightRecord record) async {
    final recordWithFarm = record.copyWith(farmId: _authProvider.currentFarmId);

    try {
      await _repository.create(recordWithFarm, _authProvider.currentFarmId);
      _allWeightRecords.add(recordWithFarm);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error adding weight: $e');
      rethrow;
    }
  }

  Future<void> updateWeight(WeightRecord updated) async {
    try {
      await _repository.update(updated, _authProvider.currentFarmId);

      final idx = _allWeightRecords.indexWhere((w) => w.id == updated.id);
      if (idx != -1) {
        _allWeightRecords[idx] = updated;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error updating weight: $e');
      rethrow;
    }
  }

  Future<void> removeWeight(String id) async {
    try {
      await _repository.delete(id, _authProvider.currentFarmId);

      final before = _allWeightRecords.length;
      _allWeightRecords.removeWhere((w) => w.id == id);
      if (_allWeightRecords.length < before) {
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error removing weight: $e');
      rethrow;
    }
  }

  // ==================== Query Methods ====================

  List<WeightRecord> getRecentWeights({int days = 30}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return weights.where((w) => w.recordedAt.isAfter(cutoffDate)).toList();
  }

  double? averageRecentWeight({int days = 30}) {
    final recent = getRecentWeights(days: days);
    if (recent.isEmpty) return null;

    final sum = recent.fold<double>(0.0, (acc, w) => acc + w.weight);
    return sum / recent.length;
  }

  // ==================== Refresh ====================

  Future<void> refresh() async {
    await _loadWeightsFromRepository();
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onFarmChanged);
    super.dispose();
  }
}
