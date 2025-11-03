// lib/providers/vaccination_provider.dart

import 'package:flutter/foundation.dart';
import '../models/vaccination.dart';
import 'auth_provider.dart';

class VaccinationProvider extends ChangeNotifier {
  final AuthProvider _authProvider;

  VaccinationProvider(this._authProvider);

  // === Données en mémoire (MOCK) ===
  List<Vaccination> _allVaccinations = [];

  // === Getters ===

  List<Vaccination> get vaccinations => List.unmodifiable(
        _allVaccinations.where((v) => v.farmId == _authProvider.currentFarmId),
      );

  void setVaccinations(List<Vaccination> items) {
    _allVaccinations.clear();
    _allVaccinations.addAll(items);
    notifyListeners();
  }

  void addVaccination(Vaccination vaccination) {
    _allVaccinations.add(vaccination);
    notifyListeners();
  }

  void updateVaccination(Vaccination updated) {
    final index = _allVaccinations.indexWhere((v) => v.id == updated.id);
    if (index != -1) {
      _allVaccinations[index] = updated;
      notifyListeners();
    }
  }

  void removeVaccination(String id) {
    _allVaccinations.removeWhere((v) => v.id == id);
    notifyListeners();
  }

  List<Vaccination> getVaccinationsForAnimal(String animalId) {
    return _allVaccinations
        .where((v) => v.farmId == _authProvider.currentFarmId)
        .where((v) => v.animalId == animalId || v.animalIds.contains(animalId))
        .toList()
      ..sort((a, b) => b.vaccinationDate.compareTo(a.vaccinationDate));
  }

  List<Vaccination> getRecentVaccinations({int days = 30}) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return _allVaccinations
        .where((v) => v.farmId == _authProvider.currentFarmId)
        .where((v) => v.vaccinationDate.isAfter(cutoff))
        .toList()
      ..sort((a, b) => b.vaccinationDate.compareTo(a.vaccinationDate));
  }

  List<Vaccination> getVaccinationsWithRemindersDue() {
    return _allVaccinations
        .where((v) => v.farmId == _authProvider.currentFarmId)
        .where((v) => v.isReminderDue)
        .toList()
      ..sort((a, b) => a.nextDueDate!.compareTo(b.nextDueDate!));
  }

  List<Vaccination> getVaccinationsInWithdrawalPeriod() {
    return _allVaccinations
        .where((v) => v.farmId == _authProvider.currentFarmId)
        .where((v) => v.isInWithdrawalPeriod)
        .toList()
      ..sort((a, b) =>
          a.daysRemainingInWithdrawal.compareTo(b.daysRemainingInWithdrawal));
  }

  bool isAnimalVaccinatedFor(String animalId, String disease) {
    return _allVaccinations.any((v) =>
        v.farmId == _authProvider.currentFarmId &&
        (v.animalId == animalId || v.animalIds.contains(animalId)) &&
        v.disease == disease);
  }

  Vaccination? getLastVaccinationFor(String animalId, String disease) {
    final history = _allVaccinations
        .where((v) =>
            v.farmId == _authProvider.currentFarmId &&
            (v.animalId == animalId || v.animalIds.contains(animalId)) &&
            v.disease == disease)
        .toList()
      ..sort((a, b) => b.vaccinationDate.compareTo(a.vaccinationDate));
    return history.isNotEmpty ? history.first : null;
  }

  // === Synchronisation (placeholder) ===

  Future<void> syncToServer() async {
    await Future.delayed(const Duration(milliseconds: 100));
    debugPrint('🔄 Sync vaccinations simulée (mode mock)');
  }
}
