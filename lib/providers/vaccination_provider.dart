// lib/providers/vaccination_provider.dart

import 'package:flutter/foundation.dart';
import '../models/vaccination.dart';
import '../repositories/vaccination_repository.dart';
import 'auth_provider.dart';

/// VaccinationProvider - Phase 1C
/// CHANGEMENT: Utilise Repository pour Vaccinations (SQLite)
class VaccinationProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  final VaccinationRepository _repository;
  String _currentFarmId;

  // Données principales (cache local)
  final List<Vaccination> _allVaccinations = [];

  // Loading state
  bool _isLoading = false;

  VaccinationProvider(this._authProvider, this._repository)
      : _currentFarmId = _authProvider.currentFarmId {
    _authProvider.addListener(_onFarmChanged);
    _loadVaccinationsFromRepository();
  }

  void _onFarmChanged() {
    if (_currentFarmId != _authProvider.currentFarmId) {
      _currentFarmId = _authProvider.currentFarmId;
      _loadVaccinationsFromRepository();
    }
  }

  // ==================== Getters ====================

  List<Vaccination> get vaccinations => List.unmodifiable(
      _allVaccinations.where((v) => v.farmId == _authProvider.currentFarmId));

  bool get isLoading => _isLoading;

  // ==================== Repository Loading ====================

  Future<void> _loadVaccinationsFromRepository() async {
    if (_currentFarmId.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final farmVaccinations = await _repository.getAll(_currentFarmId);
      _allVaccinations.removeWhere((v) => v.farmId == _currentFarmId);
      _allVaccinations.addAll(farmVaccinations);
    } catch (e) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setVaccinations(List<Vaccination> items) {
    _migrateVaccinationsToRepository(items);
  }

  Future<void> _migrateVaccinationsToRepository(
      List<Vaccination> vaccinations) async {
    for (final vaccination in vaccinations) {
      try {
        await _repository.create(vaccination, vaccination.farmId);
      } catch (e) {
      }
    }
    await _loadVaccinationsFromRepository();
  }

  // ==================== CRUD ====================

  Future<void> addVaccination(Vaccination vaccination) async {
    final vaccinationWithFarm =
        vaccination.copyWith(farmId: _authProvider.currentFarmId);

    try {
      await _repository.create(
          vaccinationWithFarm, _authProvider.currentFarmId);
      _allVaccinations.add(vaccinationWithFarm);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateVaccination(Vaccination updated) async {
    try {
      await _repository.update(updated, _authProvider.currentFarmId);

      final index = _allVaccinations.indexWhere((v) => v.id == updated.id);
      if (index != -1) {
        _allVaccinations[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeVaccination(String id) async {
    try {
      await _repository.delete(id, _authProvider.currentFarmId);

      _allVaccinations.removeWhere((v) => v.id == id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // ==================== Query Methods ====================

  List<Vaccination> getVaccinationsForAnimal(String animalId) {
    return vaccinations
        .where((v) => v.animalId == animalId || v.animalIds.contains(animalId))
        .toList()
      ..sort((a, b) => b.vaccinationDate.compareTo(a.vaccinationDate));
  }

  List<Vaccination> getRecentVaccinations({int days = 30}) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return vaccinations.where((v) => v.vaccinationDate.isAfter(cutoff)).toList()
      ..sort((a, b) => b.vaccinationDate.compareTo(a.vaccinationDate));
  }

  List<Vaccination> getVaccinationsWithRemindersDue() {
    return vaccinations.where((v) => v.isReminderDue).toList()
      ..sort((a, b) => a.nextDueDate!.compareTo(b.nextDueDate!));
  }

  List<Vaccination> getVaccinationsInWithdrawalPeriod() {
    return vaccinations.where((v) => v.isInWithdrawalPeriod).toList()
      ..sort((a, b) =>
          a.daysRemainingInWithdrawal.compareTo(b.daysRemainingInWithdrawal));
  }

  bool isAnimalVaccinatedFor(String animalId, String disease) {
    return vaccinations.any((v) =>
        (v.animalId == animalId || v.animalIds.contains(animalId)) &&
        v.disease == disease);
  }

  Vaccination? getLastVaccinationFor(String animalId, String disease) {
    final history = vaccinations
        .where((v) =>
            (v.animalId == animalId || v.animalIds.contains(animalId)) &&
            v.disease == disease)
        .toList()
      ..sort((a, b) => b.vaccinationDate.compareTo(a.vaccinationDate));
    return history.isNotEmpty ? history.first : null;
  }

  // ==================== Refresh ====================

  Future<void> refresh() async {
    await _loadVaccinationsFromRepository();
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
