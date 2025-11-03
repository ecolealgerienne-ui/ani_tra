// lib/providers/vaccination_provider.dart

import 'package:flutter/foundation.dart';
import '../models/vaccination.dart';
import 'auth_provider.dart';

/// Provider pour la gestion des vaccinations
/// Mode MOCK : Données en mémoire uniquement
class VaccinationProvider extends ChangeNotifier {
  final AuthProvider _authProvider;

  VaccinationProvider(this._authProvider);

  // === Données en mémoire (MOCK) ===
  List<Vaccination> _allVaccinations = [];

  // === Getters ===

  /// Toutes les vaccinations
  List<Vaccination> get vaccinations => List.unmodifiable(
    _allVaccinations.where((item) => item.farmId == _authProvider.currentFarmId)
  );

  /// Nombre total de vaccinations
  int get count => _allVaccinations.length;

  /// Vaccinations par animal
  List<Vaccination> getByAnimal(String animalId) {
    return _allVaccinations.where((v) => v.animalId == animalId).toList()
      ..sort((a, b) => b.administrationDate.compareTo(a.administrationDate));
  }

  /// Vaccinations planifiées
  List<Vaccination> get planned {
    return _allVaccinations
        .where((v) => v.status == VaccinationStatus.planned)
        .toList()
      ..sort((a, b) => a.administrationDate.compareTo(b.administrationDate));
  }

  /// Vaccinations administrées
  List<Vaccination> get administered {
    return _allVaccinations
        .where((v) => v.status == VaccinationStatus.administered)
        .toList()
      ..sort((a, b) => b.administrationDate.compareTo(a.administrationDate));
  }

  /// Vaccinations en retard
  List<Vaccination> get overdue {
    return _allVaccinations.where((v) => v.isOverdue).toList()
      ..sort((a, b) => a.administrationDate.compareTo(b.administrationDate));
  }

  /// Rappels à venir (dans les 30 jours)
  List<Vaccination> get upcomingReminders {
    return _allVaccinations.where((v) => v.isReminderDue).toList()
      ..sort((a, b) => a.nextDueDate!.compareTo(b.nextDueDate!));
  }

  /// Vaccinations avec réactions adverses
  List<Vaccination> get withAdverseReactions {
    return _allVaccinations
        .where(
            (v) => v.adverseReaction != null && v.adverseReaction!.isNotEmpty)
        .toList();
  }

  /// Trouver par ID
  Vaccination? getById(String id) {
    try {
      return _allVaccinations.firstWhere((v) => v.id == id);
    } catch (e) {
      return null;
    }
  }

  // === Méthodes CRUD (MOCK) ===

  /// Ajouter une vaccination
  Future<void> add(Vaccination vaccination) async {
    await Future.delayed(const Duration(milliseconds: 100)); // Simulate async
    _allVaccinations.add(vaccination);
    notifyListeners();
  }

  /// Mettre à jour une vaccination
  Future<void> update(Vaccination vaccination) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _allVaccinations.indexWhere((v) => v.id == vaccination.id);
    if (index != -1) {
      _allVaccinations[index] = vaccination.markAsModified();
      notifyListeners();
    }
  }

  /// Supprimer une vaccination
  Future<void> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _allVaccinations.removeWhere((v) => v.id == id);
    notifyListeners();
  }

  /// Marquer comme administrée
  Future<void> markAsAdministered(
    String id, {
    required DateTime administrationDate,
    String? batchNumber,
    double? dosage,
    String? administrationRoute,
    String? injectionSite,
    String? administeredBy,
    DateTime? nextDueDate,
    String? notes,
  }) async {
    final vaccination = getById(id);
    if (vaccination == null) return;

    final updated = vaccination.copyWith(
      status: VaccinationStatus.administered,
      administrationDate: administrationDate,
      batchNumber: batchNumber ?? vaccination.batchNumber,
      dosage: dosage ?? vaccination.dosage,
      administrationRoute:
          administrationRoute ?? vaccination.administrationRoute,
      injectionSite: injectionSite ?? vaccination.injectionSite,
      administeredBy: administeredBy ?? vaccination.administeredBy,
      nextDueDate: nextDueDate ?? vaccination.nextDueDate,
      notes: notes ?? vaccination.notes,
    );

    await update(updated);
  }

  /// Enregistrer une réaction adverse
  Future<void> recordAdverseReaction(String id, String reaction) async {
    final vaccination = getById(id);
    if (vaccination == null) return;

    final updated = vaccination.copyWith(adverseReaction: reaction);
    await update(updated);
  }

  /// Planifier un rappel
  Future<void> scheduleReminder(
    String animalId,
    String productId,
    String productName,
    DateTime dueDate, {
    String? veterinarianId,
    String? veterinarianName,
    String? notes,
  }) async {
    final vaccination = Vaccination(
      farmId: 'mock-farm-001', // Mode MOCK
      animalId: animalId,
      productId: productId,
      productName: productName,
      administrationDate: dueDate,
      status: VaccinationStatus.planned,
      veterinarianId: veterinarianId,
      veterinarianName: veterinarianName,
      notes: notes,
    );

    await add(vaccination);
  }

  // === Statistiques ===

  /// Taux de vaccination par produit
  Map<String, int> getVaccinationCountsByProduct() {
    final counts = <String, int>{};
    for (final vacc in _allVaccinations.where((v) => v.isAdministered)) {
      counts[vacc.productName] = (counts[vacc.productName] ?? 0) + 1;
    }
    return counts;
  }

  /// Nombre de vaccinations ce mois
  int get vaccinationsThisMonth {
    final now = DateTime.now();
    return _allVaccinations.where((v) {
      return v.isAdministered &&
          v.administrationDate.year == now.year &&
          v.administrationDate.month == now.month;
    }).length;
  }

  /// Taux de conformité (administrées vs planifiées)
  double get complianceRate {
    if (_allVaccinations.isEmpty) return 0.0;
    final administered = _allVaccinations.where((v) => v.isAdministered).length;
    return administered / _allVaccinations.length;
  }

  // === Chargement initial (MOCK) ===

  /// Charger les données de mock
  Future<void> loadMockData(List<Vaccination> mockVaccinations) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _allVaccinations = mockVaccinations;
    notifyListeners();
  }

  /// Réinitialiser les données
  void clear() {
    _allVaccinations.clear();
    notifyListeners();
  }

  // === Synchronisation (MOCK - ne fait rien) ===

  /// Synchroniser avec le serveur (placeholder)
  Future<void> syncToServer() async {
    // TODO: Implémenter quand serveur prêt
    await Future.delayed(const Duration(milliseconds: 100));
    debugPrint('🔄 Sync vaccinations simulée (mode mock)');
  }

  /// Marquer comme synchronisé (placeholder)
  void _markAsSynced(String id, String serverVersion) {
    // TODO: Implémenter quand serveur prêt
    debugPrint('✅ Vaccination $id marquée comme synced (mode mock)');
  }
}
