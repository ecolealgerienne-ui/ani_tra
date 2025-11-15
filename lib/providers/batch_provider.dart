// lib/providers/batch_provider.dart
import 'package:flutter/foundation.dart';
import '../models/batch.dart';
import '../repositories/batch_repository.dart';
import 'auth_provider.dart';

/// BatchProvider - Phase 1C
/// CHANGEMENT: Utilise Repository pour Batches (SQLite)
class BatchProvider with ChangeNotifier {
  final AuthProvider _authProvider;
  final BatchRepository _repository;
  String _currentFarmId;

  // Données principales (cache local)
  final List<Batch> _allBatches = [];

  // Loading state
  bool _isLoading = false;

  // Lot actuellement en cours de création (scan en cours)
  Batch? _activeBatch;

  // ==================== Constantes ====================
  static const String kLogBatchCreated = 'log.batch.created';
  static const String kLogBatchNoActive = 'log.batch.no_active';
  static const String kLogBatchAnimalAlreadyIn = 'log.batch.animal_already_in';
  static const String kLogBatchAnimalAdded = 'log.batch.animal_added';
  static const String kLogBatchAnimalRemoved = 'log.batch.animal_removed';
  static const String kLogBatchNotFound = 'log.batch.not_found';
  static const String kLogBatchCompleted = 'log.batch.completed';
  static const String kLogBatchDeleted = 'log.batch.deleted';
  static const String kLogBatchActiveReset = 'log.batch.active_reset';
  static const String kLogBatchActivated = 'log.batch.activated';
  static const String kLogBatchLoading = 'log.batch.loading';
  static const String kLogBatchSaving = 'log.batch.saving';
  static const String kLogBatchInitialLoaded = 'log.batch.initial_loaded';
  static const String kLogBatchReset = 'log.batch.reset';

  static const String kErrBatchNotFound = 'err.batch.not_found';
  static const String kErrCannotReactivateCompleted =
      'err.batch.cannot_reactivate_completed';

  BatchProvider(this._authProvider, this._repository)
      : _currentFarmId = _authProvider.currentFarmId {
    _authProvider.addListener(_onFarmChanged);
    _loadBatchesFromRepository();
  }

  void _onFarmChanged() {
    if (_currentFarmId != _authProvider.currentFarmId) {
      _currentFarmId = _authProvider.currentFarmId;
      _activeBatch = null;
      _loadBatchesFromRepository();
    }
  }

  // ==================== Getters ====================

  List<Batch> get batches => List.unmodifiable(
      _allBatches.where((b) => b.farmId == _authProvider.currentFarmId));

  List<Batch> get activeBatches => batches.where((b) => !b.completed).toList();

  List<Batch> get completedBatches =>
      batches.where((b) => b.completed).toList();

  Batch? get activeBatch => _activeBatch;
  bool get hasActiveBatch => _activeBatch != null;
  bool get isLoading => _isLoading;

  int get batchCount => batches.length;
  int get activeBatchCount => activeBatches.length;

  // ==================== Repository Loading ====================

  Future<void> _loadBatchesFromRepository() async {
    if (_currentFarmId.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final farmBatches = await _repository.findAllByFarm(_currentFarmId);
      _allBatches.removeWhere((b) => b.farmId == _currentFarmId);
      _allBatches.addAll(farmBatches);
    } catch (e) {
      // Ignore errors
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void initializeWithInitialData(List<Batch> batches) {
    _migrateBatchesToRepository(batches);
  }

  Future<void> _migrateBatchesToRepository(List<Batch> batches) async {
    for (final batch in batches) {
      try {
        await _repository.create(batch, batch.farmId);
      } catch (e) {
        // Ignore errors
      }
    }
    await _loadBatchesFromRepository();
  }

  // ==================== CRUD: Batches ====================

  Future<Batch> createBatch(String name, BatchPurpose purpose) async {
    final batch = Batch(
      id: _generateId(),
      name: name,
      purpose: purpose,
      animalIds: [],
      createdAt: DateTime.now(),
      completed: false,
      synced: false,
      farmId: _authProvider.currentFarmId,
    );

    try {
      await _repository.create(batch, _authProvider.currentFarmId);
      _allBatches.add(batch);
      _activeBatch = batch;
      notifyListeners();
      return batch;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addAnimalToBatch(String animalId) async {
    if (_activeBatch == null) return false;
    if (_activeBatch!.animalIds.contains(animalId)) return false;

    final updatedBatch = Batch(
      id: _activeBatch!.id,
      name: _activeBatch!.name,
      purpose: _activeBatch!.purpose,
      animalIds: [..._activeBatch!.animalIds, animalId],
      createdAt: _activeBatch!.createdAt,
      usedAt: _activeBatch!.usedAt,
      completed: _activeBatch!.completed,
      synced: false,
      farmId: _activeBatch!.farmId,
    );

    try {
      await _repository.update(updatedBatch, _authProvider.currentFarmId);

      final index = _allBatches.indexWhere((b) => b.id == _activeBatch!.id);
      if (index != -1) {
        _allBatches[index] = updatedBatch;
        _activeBatch = updatedBatch;
      }
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeAnimalFromBatch(String animalId) async {
    if (_activeBatch == null) return false;
    if (!_activeBatch!.animalIds.contains(animalId)) return false;

    final updatedAnimalIds = List<String>.from(_activeBatch!.animalIds)
      ..remove(animalId);

    final updatedBatch = Batch(
      id: _activeBatch!.id,
      name: _activeBatch!.name,
      purpose: _activeBatch!.purpose,
      animalIds: updatedAnimalIds,
      createdAt: _activeBatch!.createdAt,
      usedAt: _activeBatch!.usedAt,
      completed: _activeBatch!.completed,
      synced: false,
      farmId: _activeBatch!.farmId,
    );

    try {
      await _repository.update(updatedBatch, _authProvider.currentFarmId);

      final index = _allBatches.indexWhere((b) => b.id == _activeBatch!.id);
      if (index != -1) {
        _allBatches[index] = updatedBatch;
        _activeBatch = updatedBatch;
      }
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool isAnimalInActiveBatch(String animalId) {
    if (_activeBatch == null) return false;
    return _activeBatch!.animalIds.contains(animalId);
  }

  Future<void> completeBatch(String batchId) async {
    final index = _allBatches.indexWhere((b) => b.id == batchId);
    if (index == -1) return;

    final batch = _allBatches[index];
    final updatedBatch = Batch(
      id: batch.id,
      name: batch.name,
      purpose: batch.purpose,
      animalIds: batch.animalIds,
      createdAt: batch.createdAt,
      usedAt: DateTime.now(),
      completed: true,
      synced: false,
      farmId: batch.farmId,
    );

    try {
      await _repository.update(updatedBatch, _authProvider.currentFarmId);

      _allBatches[index] = updatedBatch;
      if (_activeBatch?.id == batchId) {
        _activeBatch = null;
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteBatch(String batchId) async {
    try {
      await _repository.delete(batchId, _authProvider.currentFarmId);

      _allBatches.removeWhere((b) => b.id == batchId);
      if (_activeBatch?.id == batchId) {
        _activeBatch = null;
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void clearActiveBatch() {
    if (_activeBatch != null) {
      _activeBatch = null;
      notifyListeners();
    }
  }

  void setActiveBatch(String batchId) {
    final batch = _allBatches.firstWhere(
      (b) => b.id == batchId,
      orElse: () => throw Exception(kErrBatchNotFound),
    );

    if (batch.completed) return;

    _activeBatch = batch;
    notifyListeners();
  }

  // ==================== Query Methods ====================

  Batch? getBatchById(String batchId) {
    try {
      return batches.firstWhere((b) => b.id == batchId);
    } catch (e) {
      return null;
    }
  }

  List<Batch> getBatchesContainingAnimal(String animalId) {
    return batches
        .where((batch) => batch.animalIds.contains(animalId))
        .toList();
  }

  List<Batch> getBatchesByPurpose(BatchPurpose purpose) {
    return batches.where((b) => b.purpose == purpose).toList();
  }

  // ==================== Statistics ====================

  int get totalAnimalsInActiveBatches {
    return activeBatches.fold(0, (sum, batch) => sum + batch.animalCount);
  }

  Map<BatchPurpose, int> get batchesByPurposeCount {
    final Map<BatchPurpose, int> distribution = {
      BatchPurpose.sale: 0,
      BatchPurpose.slaughter: 0,
      BatchPurpose.treatment: 0,
      BatchPurpose.other: 0,
    };

    for (final batch in batches) {
      distribution[batch.purpose] = (distribution[batch.purpose] ?? 0) + 1;
    }

    return distribution;
  }

  // ==================== Refresh ====================

  Future<void> refresh() async {
    await _loadBatchesFromRepository();
  }

  // ==================== Private ====================

  String _generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'batch_${timestamp}_$random';
  }

  @visibleForTesting
  void reset() {
    _allBatches.clear();
    _activeBatch = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onFarmChanged);
    super.dispose();
  }
}
