// lib/providers/treatment_provider.dart

import 'package:flutter/foundation.dart';
import '../models/treatment.dart';
import '../repositories/treatment_repository.dart';
import 'auth_provider.dart';

/// TreatmentProvider - Phase 1C
/// CHANGEMENT: Utilise Repository pour Treatments (SQLite)
class TreatmentProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  final TreatmentRepository _repository;
  String _currentFarmId;

  // Données principales (cache local)
  final List<Treatment> _allTreatments = [];

  // Loading state
  bool _isLoading = false;

  TreatmentProvider(this._authProvider, this._repository)
      : _currentFarmId = _authProvider.currentFarmId {
    _authProvider.addListener(_onFarmChanged);
    _loadTreatmentsFromRepository();
  }

  void _onFarmChanged() {
    if (_currentFarmId != _authProvider.currentFarmId) {
      _currentFarmId = _authProvider.currentFarmId;
      _loadTreatmentsFromRepository();
    }
  }

  // ==================== Getters ====================

  List<Treatment> get treatments => List.unmodifiable(
      _allTreatments.where((t) => t.farmId == _authProvider.currentFarmId));

  bool get isLoading => _isLoading;

  // ==================== Repository Loading ====================

  Future<void> _loadTreatmentsFromRepository() async {
    if (_currentFarmId.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final farmTreatments = await _repository.getAll(_currentFarmId);
      _allTreatments.removeWhere((t) => t.farmId == _currentFarmId);
      _allTreatments.addAll(farmTreatments);
    } catch (e) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setTreatments(List<Treatment> items) {
    _migrateTreatmentsToRepository(items);
  }

  Future<void> _migrateTreatmentsToRepository(
      List<Treatment> treatments) async {
    for (final treatment in treatments) {
      try {
        await _repository.create(treatment, treatment.farmId);
      } catch (e) {
      }
    }
    await _loadTreatmentsFromRepository();
  }

  // ==================== CRUD ====================

  Future<void> addTreatment(Treatment treatment) async {
    final treatmentWithFarm =
        treatment.copyWith(farmId: _authProvider.currentFarmId);

    try {
      await _repository.create(treatmentWithFarm, _authProvider.currentFarmId);
      _allTreatments.add(treatmentWithFarm);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTreatment(Treatment updated) async {
    try {
      await _repository.update(updated, _authProvider.currentFarmId);

      final index = _allTreatments.indexWhere((t) => t.id == updated.id);
      if (index != -1) {
        _allTreatments[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeTreatment(String id) async {
    try {
      await _repository.delete(id, _authProvider.currentFarmId);

      _allTreatments.removeWhere((t) => t.id == id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // ==================== Query Methods ====================

  /// Récupère les traitements d'un animal
  List<Treatment> getTreatmentsForAnimal(String animalId) {
    return treatments.where((t) => t.animalId == animalId).toList()
      ..sort((a, b) => b.treatmentDate.compareTo(a.treatmentDate));
  }

  /// Récupère les traitements récents
  List<Treatment> getRecentTreatments({int days = 30}) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return treatments.where((t) => t.treatmentDate.isAfter(cutoff)).toList()
      ..sort((a, b) => b.treatmentDate.compareTo(a.treatmentDate));
  }

  /// Récupère les traitements avec délai d'attente actif
  List<Treatment> getTreatmentsInWithdrawalPeriod() {
    return treatments.where((t) => t.isWithdrawalActive).toList()
      ..sort((a, b) =>
          a.daysUntilWithdrawalEnd.compareTo(b.daysUntilWithdrawalEnd));
  }

  /// Récupère les traitements avec délai d'attente actif pour un animal
  List<Treatment> getActiveWithdrawalTreatmentsForAnimal(String animalId) {
    return getTreatmentsForAnimal(animalId)
        .where((t) => t.isWithdrawalActive)
        .toList()
      ..sort((a, b) =>
          a.daysUntilWithdrawalEnd.compareTo(b.daysUntilWithdrawalEnd));
  }

  /// Vérifie si un animal a un délai d'attente actif
  bool hasActiveWithdrawal(String animalId) {
    return getTreatmentsForAnimal(animalId).any((t) => t.isWithdrawalActive);
  }

  /// Récupère les traitements d'une campagne
  List<Treatment> getTreatmentsForCampaign(String campaignId) {
    return treatments.where((t) => t.campaignId == campaignId).toList()
      ..sort((a, b) => b.treatmentDate.compareTo(a.treatmentDate));
  }

  /// Récupère les traitements avec un produit spécifique
  List<Treatment> getTreatmentsWithProduct(String productId) {
    return treatments.where((t) => t.productId == productId).toList()
      ..sort((a, b) => b.treatmentDate.compareTo(a.treatmentDate));
  }

  /// Compte les traitements pour un animal
  int countTreatmentsForAnimal(String animalId) {
    return getTreatmentsForAnimal(animalId).length;
  }

  /// Récupère le dernier traitement pour un animal
  Treatment? getLastTreatmentForAnimal(String animalId) {
    final treatments = getTreatmentsForAnimal(animalId);
    return treatments.isNotEmpty ? treatments.first : null;
  }

  // ==================== Refresh ====================

  Future<void> refresh() async {
    await _loadTreatmentsFromRepository();
  }

  Future<void> syncToServer() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onFarmChanged);
    super.dispose();
  }
}
