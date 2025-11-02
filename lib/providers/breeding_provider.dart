// lib/providers/breeding_provider.dart

import 'package:flutter/foundation.dart';
import '../models/breeding.dart';

/// Provider pour la gestion des reproductions
/// Mode MOCK : Données en mémoire uniquement
class BreedingProvider extends ChangeNotifier {
  // === Données en mémoire (MOCK) ===
  List<Breeding> _breedings = [];

  // === Getters ===

  /// Toutes les reproductions
  List<Breeding> get breedings => List.unmodifiable(_breedings);

  /// Nombre total de reproductions
  int get count => _breedings.length;

  /// Reproductions par animal (mère)
  List<Breeding> getByMother(String motherId) {
    return _breedings.where((b) => b.motherId == motherId).toList()
      ..sort((a, b) => b.breedingDate.compareTo(a.breedingDate));
  }

  /// Reproductions par père
  List<Breeding> getByFather(String fatherId) {
    return _breedings.where((b) => b.fatherId == fatherId).toList()
      ..sort((a, b) => b.breedingDate.compareTo(a.breedingDate));
  }

  /// Reproductions en attente
  List<Breeding> get pending {
    return _breedings.where((b) => b.status == BreedingStatus.pending).toList()
      ..sort((a, b) => a.expectedBirthDate.compareTo(b.expectedBirthDate));
  }

  /// Reproductions terminées
  List<Breeding> get completed {
    return _breedings
        .where((b) => b.status == BreedingStatus.completed)
        .toList()
      ..sort((a, b) => b.actualBirthDate!.compareTo(a.actualBirthDate!));
  }

  /// Reproductions en retard
  List<Breeding> get overdue {
    return _breedings.where((b) => b.isOverdue).toList()
      ..sort((a, b) => a.expectedBirthDate.compareTo(b.expectedBirthDate));
  }

  /// Mises-bas imminentes (< 7 jours)
  List<Breeding> get birthSoon {
    return _breedings.where((b) => b.isBirthSoon).toList()
      ..sort((a, b) =>
          a.daysUntilExpectedBirth.compareTo(b.daysUntilExpectedBirth));
  }

  /// Reproductions échouées
  List<Breeding> get failed {
    return _breedings.where((b) => b.hasFailed).toList()
      ..sort((a, b) => b.breedingDate.compareTo(a.breedingDate));
  }

  /// Reproductions par méthode
  List<Breeding> getByMethod(BreedingMethod method) {
    return _breedings.where((b) => b.method == method).toList()
      ..sort((a, b) => b.breedingDate.compareTo(a.breedingDate));
  }

  /// Trouver par ID
  Breeding? getById(String id) {
    try {
      return _breedings.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  // === Méthodes CRUD (MOCK) ===

  /// Ajouter une reproduction
  Future<void> add(Breeding breeding) async {
    await Future.delayed(const Duration(milliseconds: 100)); // Simulate async
    _breedings.add(breeding);
    notifyListeners();
  }

  /// Mettre à jour une reproduction
  Future<void> update(Breeding breeding) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _breedings.indexWhere((b) => b.id == breeding.id);
    if (index != -1) {
      _breedings[index] = breeding.markAsModified();
      notifyListeners();
    }
  }

  /// Supprimer une reproduction
  Future<void> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _breedings.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  /// Enregistrer une nouvelle reproduction
  Future<Breeding> recordBreeding({
    required String farmId,
    required String motherId,
    String? fatherId,
    String? fatherName,
    required BreedingMethod method,
    required DateTime breedingDate,
    required DateTime expectedBirthDate,
    int? expectedOffspringCount,
    String? veterinarianId,
    String? veterinarianName,
    String? notes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

    final breeding = Breeding(
      farmId: farmId,
      motherId: motherId,
      fatherId: fatherId,
      fatherName: fatherName,
      method: method,
      breedingDate: breedingDate,
      expectedBirthDate: expectedBirthDate,
      expectedOffspringCount: expectedOffspringCount,
      veterinarianId: veterinarianId,
      veterinarianName: veterinarianName,
      notes: notes,
      status: BreedingStatus.pending,
    );

    await add(breeding);
    return breeding;
  }

  /// Enregistrer la mise-bas
  Future<void> recordBirth(
    String breedingId, {
    required DateTime birthDate,
    required List<String> offspringIds,
    String? notes,
  }) async {
    final breeding = getById(breedingId);
    if (breeding == null) return;

    final updated = breeding.copyWith(
      status: BreedingStatus.completed,
      actualBirthDate: birthDate,
      offspringIds: offspringIds,
      notes: notes ?? breeding.notes,
    );

    await update(updated);
  }

  /// Marquer comme échec
  Future<void> markAsFailed(String breedingId, String reason) async {
    final breeding = getById(breedingId);
    if (breeding == null) return;

    final updated = breeding.copyWith(
      status: BreedingStatus.failed,
      notes: '${breeding.notes ?? ''}\n❌ Échec: $reason'.trim(),
    );

    await update(updated);
  }

  /// Marquer comme avortement
  Future<void> markAsAborted(
    String breedingId, {
    required DateTime abortionDate,
    String? reason,
  }) async {
    final breeding = getById(breedingId);
    if (breeding == null) return;

    final updated = breeding.copyWith(
      status: BreedingStatus.aborted,
      actualBirthDate: abortionDate,
      notes:
          '${breeding.notes ?? ''}\n⚠️ Avortement: ${reason ?? "Non précisé"}'
              .trim(),
    );

    await update(updated);
  }

  // === Statistiques ===

  /// Taux de réussite (%) des reproductions
  double get successRate {
    if (_breedings.isEmpty) return 0.0;
    final completed = _breedings.where((b) => b.isCompleted).length;
    return (completed / _breedings.length) * 100;
  }

  /// Nombre moyen de petits par portée
  double get averageOffspringCount {
    final completedWithOffspring =
        _breedings.where((b) => b.isCompleted && b.actualOffspringCount > 0);
    if (completedWithOffspring.isEmpty) return 0.0;

    final totalOffspring = completedWithOffspring.fold<int>(
      0,
      (sum, b) => sum + b.actualOffspringCount,
    );

    return totalOffspring / completedWithOffspring.length;
  }

  /// Durée moyenne de gestation (jours)
  double get averageGestationDays {
    final completedWithGestation =
        _breedings.where((b) => b.gestationDays != null);
    if (completedWithGestation.isEmpty) return 0.0;

    final totalDays = completedWithGestation.fold<int>(
      0,
      (sum, b) => sum + b.gestationDays!,
    );

    return totalDays / completedWithGestation.length;
  }

  /// Nombre de reproductions par méthode
  Map<BreedingMethod, int> getCountsByMethod() {
    final counts = <BreedingMethod, int>{};
    for (final breeding in _breedings) {
      counts[breeding.method] = (counts[breeding.method] ?? 0) + 1;
    }
    return counts;
  }

  /// Reproductions ce mois
  int get thisMonthCount {
    final now = DateTime.now();
    return _breedings.where((b) {
      return b.breedingDate.year == now.year &&
          b.breedingDate.month == now.month;
    }).length;
  }

  /// Mises-bas ce mois
  int get birthsThisMonth {
    final now = DateTime.now();
    return _breedings.where((b) {
      return b.actualBirthDate != null &&
          b.actualBirthDate!.year == now.year &&
          b.actualBirthDate!.month == now.month;
    }).length;
  }

  // === Chargement initial (MOCK) ===

  /// Charger les données de mock
  Future<void> loadMockData(List<Breeding> mockBreedings) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _breedings = mockBreedings;
    notifyListeners();
  }

  /// Réinitialiser les données
  void clear() {
    _breedings.clear();
    notifyListeners();
  }

  // === Synchronisation (MOCK - ne fait rien) ===

  /// Synchroniser avec le serveur (placeholder)
  Future<void> syncToServer() async {
    // TODO: Implémenter quand serveur prêt
    await Future.delayed(const Duration(milliseconds: 100));
    debugPrint('🔄 Sync breedings simulée (mode mock)');
  }

  /// Marquer comme synchronisé (placeholder)
  void _markAsSynced(String id, String serverVersion) {
    // TODO: Implémenter quand serveur prêt
    debugPrint('✅ Breeding $id marqué comme synced (mode mock)');
  }
}
