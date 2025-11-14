// lib/providers/breeding_provider.dart

import 'package:flutter/foundation.dart';
import '../models/breeding.dart';
import '../repositories/breeding_repository.dart';
import 'auth_provider.dart';

/// BreedingProvider - Phase 1C
/// CHANGEMENT: Utilise Repository pour Breedings (SQLite)
class BreedingProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  final BreedingRepository _repository;
  String _currentFarmId;

  // ==================== I18N Notes (stored in DB) ====================
  // NOTE: Ces constantes correspondent aux clés i18n mais sont en français par défaut
  // car les providers n'ont pas accès au BuildContext pour la traduction.
  // Les notes sont stockées dans la langue active au moment de la création.
  // Pour une vraie i18n, il faudrait soit:
  // 1. Passer BuildContext aux méthodes (refactoring majeur)
  // 2. Stocker en JSON {"type": "failed", "reason": "..."} (meilleure approche)
  // Références: AppStrings.breedingFailedNote, AppStrings.breedingAbortedNote
  static const String _failedNotePrefix = 'Échec:'; // breedingFailedNote
  static const String _abortedNotePrefix = 'Avortement:'; // breedingAbortedNote
  static const String _notSpecified = 'Non précisé'; // reasonNotSpecified

  // Données principales (cache local)
  final List<Breeding> _allBreedings = [];

  // Loading state
  bool _isLoading = false;

  BreedingProvider(this._authProvider, this._repository)
      : _currentFarmId = _authProvider.currentFarmId {
    _authProvider.addListener(_onFarmChanged);
    _loadBreedingsFromRepository();
  }

  void _onFarmChanged() {
    if (_currentFarmId != _authProvider.currentFarmId) {
      _currentFarmId = _authProvider.currentFarmId;
      _loadBreedingsFromRepository();
    }
  }

  // ==================== Getters ====================

  List<Breeding> get breedings => List.unmodifiable(
      _allBreedings.where((b) => b.farmId == _authProvider.currentFarmId));

  bool get isLoading => _isLoading;

  int get count => breedings.length;

  List<Breeding> get pending {
    return breedings.where((b) => b.status == BreedingStatus.pending).toList()
      ..sort((a, b) => a.expectedBirthDate.compareTo(b.expectedBirthDate));
  }

  List<Breeding> get completed {
    return breedings.where((b) => b.status == BreedingStatus.completed).toList()
      ..sort((a, b) => b.actualBirthDate!.compareTo(a.actualBirthDate!));
  }

  List<Breeding> get overdue {
    return breedings.where((b) => b.isOverdue).toList()
      ..sort((a, b) => a.expectedBirthDate.compareTo(b.expectedBirthDate));
  }

  List<Breeding> get birthSoon {
    return breedings.where((b) => b.isBirthSoon).toList()
      ..sort((a, b) =>
          a.daysUntilExpectedBirth.compareTo(b.daysUntilExpectedBirth));
  }

  List<Breeding> get failed {
    return breedings.where((b) => b.hasFailed).toList()
      ..sort((a, b) => b.breedingDate.compareTo(a.breedingDate));
  }

  // ==================== Repository Loading ====================

  Future<void> _loadBreedingsFromRepository() async {
    if (_currentFarmId.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final farmBreedings = await _repository.getAll(_currentFarmId);
      _allBreedings.removeWhere((b) => b.farmId == _currentFarmId);
      _allBreedings.addAll(farmBreedings);
    } catch (e) {
      debugPrint('❌ Error loading breedings from repository: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMockData(List<Breeding> mockBreedings) async {
    await _migrateBreedingsToRepository(mockBreedings);
  }

  Future<void> _migrateBreedingsToRepository(List<Breeding> breedings) async {
    for (final breeding in breedings) {
      try {
        await _repository.create(breeding, breeding.farmId);
      } catch (e) {
        debugPrint('⚠️ Breeding ${breeding.id} already exists or error: $e');
      }
    }
    await _loadBreedingsFromRepository();
  }

  // ==================== Query Methods ====================

  List<Breeding> getByMother(String motherId) {
    return breedings.where((b) => b.motherId == motherId).toList()
      ..sort((a, b) => b.breedingDate.compareTo(a.breedingDate));
  }

  List<Breeding> getByFather(String fatherId) {
    return breedings.where((b) => b.fatherId == fatherId).toList()
      ..sort((a, b) => b.breedingDate.compareTo(a.breedingDate));
  }

  List<Breeding> getByMethod(BreedingMethod method) {
    return breedings.where((b) => b.method == method).toList()
      ..sort((a, b) => b.breedingDate.compareTo(a.breedingDate));
  }

  Breeding? getById(String id) {
    try {
      return breedings.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  // ==================== CRUD ====================

  Future<void> add(Breeding breeding) async {
    try {
      await _repository.create(breeding, _authProvider.currentFarmId);
      _allBreedings.add(breeding);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error adding breeding: $e');
      rethrow;
    }
  }

  Future<void> update(Breeding breeding) async {
    try {
      final updated = breeding.markAsModified();
      await _repository.update(updated, _authProvider.currentFarmId);

      final index = _allBreedings.indexWhere((b) => b.id == breeding.id);
      if (index != -1) {
        _allBreedings[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error updating breeding: $e');
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      await _repository.delete(id, _authProvider.currentFarmId);

      _allBreedings.removeWhere((b) => b.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error deleting breeding: $e');
      rethrow;
    }
  }

  // ==================== Business Methods ====================

  Future<Breeding> recordBreeding({
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
    final breeding = Breeding(
      farmId: _authProvider.currentFarmId,
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

  Future<void> markAsFailed(String breedingId, String reason) async {
    final breeding = getById(breedingId);
    if (breeding == null) return;

    final updated = breeding.copyWith(
      status: BreedingStatus.failed,
      notes: '${breeding.notes ?? ''}\n❌ $_failedNotePrefix $reason'.trim(),
    );

    await update(updated);
  }

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
          '${breeding.notes ?? ''}\n⚠️ $_abortedNotePrefix ${reason ?? _notSpecified}'
              .trim(),
    );

    await update(updated);
  }

  // ==================== Statistics ====================

  double get successRate {
    if (breedings.isEmpty) return 0.0;
    final completedCount = breedings.where((b) => b.isCompleted).length;
    return (completedCount / breedings.length) * 100;
  }

  double get averageOffspringCount {
    final completedWithOffspring =
        breedings.where((b) => b.isCompleted && b.actualOffspringCount > 0);
    if (completedWithOffspring.isEmpty) return 0.0;

    final totalOffspring = completedWithOffspring.fold<int>(
      0,
      (sum, b) => sum + b.actualOffspringCount,
    );

    return totalOffspring / completedWithOffspring.length;
  }

  double get averageGestationDays {
    final completedWithGestation =
        breedings.where((b) => b.gestationDays != null);
    if (completedWithGestation.isEmpty) return 0.0;

    final totalDays = completedWithGestation.fold<int>(
      0,
      (sum, b) => sum + b.gestationDays!,
    );

    return totalDays / completedWithGestation.length;
  }

  Map<BreedingMethod, int> getCountsByMethod() {
    final counts = <BreedingMethod, int>{};
    for (final breeding in breedings) {
      counts[breeding.method] = (counts[breeding.method] ?? 0) + 1;
    }
    return counts;
  }

  int get thisMonthCount {
    final now = DateTime.now();
    return breedings.where((b) {
      return b.breedingDate.year == now.year &&
          b.breedingDate.month == now.month;
    }).length;
  }

  int get birthsThisMonth {
    final now = DateTime.now();
    return breedings.where((b) {
      return b.actualBirthDate != null &&
          b.actualBirthDate!.year == now.year &&
          b.actualBirthDate!.month == now.month;
    }).length;
  }

  // ==================== Utilities ====================

  void clear() {
    _allBreedings.clear();
    notifyListeners();
  }

  Future<void> syncToServer() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  // ==================== Refresh ====================

  Future<void> refresh() async {
    await _loadBreedingsFromRepository();
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onFarmChanged);
    super.dispose();
  }
}
