// lib/providers/animal_provider.dart
// (Garder le début identique jusqu'à la ligne ~30)
import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../models/treatment.dart';
import '../models/movement.dart';
import '../models/product.dart';
import '../models/mother_stats.dart';
import 'auth_provider.dart';
import '../repositories/animal_repository.dart';
import '../../utils/constants.dart';

// lib/providers/animal_provider.dart
// (Garder le début identique jusqu'à la ligne ~30)

class AnimalProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  final AnimalRepository _repository;
  String _currentFarmId;

  final List<Product> _allProducts = [];
  final List<Animal> _allAnimals = [];
  final List<Treatment> _allTreatments = [];
  final List<Movement> _allMovements = [];

  bool _isLoading = false;

  Animal? _currentAnimal;
  String _searchQuery = '';
  AnimalStatus? _statusFilter;

  // ==================== A5: Cache TTL pour refresh optimisé ====================
  DateTime? _lastRefreshTime;
  final Duration _cacheTTL = const Duration(minutes: 5);

  AnimalProvider(this._authProvider, this._repository)
      : _currentFarmId = _authProvider.currentFarmId {
    _authProvider.addListener(_onFarmChanged);
    _loadAnimalsFromRepository();
  }

  void _onFarmChanged() {
    if (_currentFarmId != _authProvider.currentFarmId) {
      _currentFarmId = _authProvider.currentFarmId;
      _currentAnimal = null;
      _searchQuery = '';
      _statusFilter = null;
      _lastRefreshTime = null; // Invalider le cache
      _loadAnimalsFromRepository();
    }
  }

  // ==================== Getters ====================

  List<Product> get products => List.unmodifiable(
      _allProducts.where((p) => p.farmId == _authProvider.currentFarmId));

  List<Animal> get animals => List.unmodifiable(
      _allAnimals.where((a) => a.farmId == _authProvider.currentFarmId));

  List<Treatment> get treatments => List.unmodifiable(
      _allTreatments.where((t) => t.farmId == _authProvider.currentFarmId));

  List<Movement> get movements => List.unmodifiable(
      _allMovements.where((m) => m.farmId == _authProvider.currentFarmId));

  Animal? get currentAnimal => _currentAnimal;
  String get searchQuery => _searchQuery;
  AnimalStatus? get statusFilter => _statusFilter;
  bool get isLoading => _isLoading;

  /// A5: Getter pour savoir si le cache est valide
  bool get _isCacheValid {
    if (_lastRefreshTime == null) return false;
    return DateTime.now().difference(_lastRefreshTime!).inMinutes <
        _cacheTTL.inMinutes;
  }

  /// Animaux filtrés selon recherche et statut
  List<Animal> get filteredAnimals {
    Iterable<Animal> list = animals;

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((a) {
        final eid = a.currentEid?.toLowerCase() ?? '';
        final off = a.officialNumber?.toLowerCase() ?? '';
        final sex = a.sex.name.toLowerCase();
        final status = a.status.name.toLowerCase();
        return eid.contains(q) ||
            off.contains(q) ||
            sex.contains(q) ||
            status.contains(q);
      });
    }

    if (_statusFilter != null) {
      list = list.where((a) => a.status == _statusFilter);
    }

    return List<Animal>.unmodifiable(list);
  }

  // ==================== Initialisation ====================

  /// Charge les animaux depuis SQLite
  Future<void> _loadAnimalsFromRepository() async {
    if (_currentFarmId.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final farmAnimals = await _repository.getAll(_currentFarmId);

      _allAnimals.removeWhere((a) => a.farmId == _currentFarmId);
      _allAnimals.addAll(farmAnimals);
      _lastRefreshTime = DateTime.now(); // A5: Marquer le refresh
    } catch (e) {
      debugPrint('❌ Error loading animals from repository: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Initialise avec mock data
  void initializeWithMockData(
    List<Animal> animals,
    List<Product> products,
    List<Treatment> treatments,
    List<Movement> movements,
  ) {
    _allProducts
      ..clear()
      ..addAll(products);
    _allTreatments
      ..clear()
      ..addAll(treatments);
    _allMovements
      ..clear()
      ..addAll(movements);

    _migrateAnimalsToRepository(animals);
  }

  /// Migre les animaux mock vers SQLite
  Future<void> _migrateAnimalsToRepository(List<Animal> animals) async {
    for (final animal in animals) {
      try {
        await _repository.create(animal, animal.farmId);
      } catch (e) {
        debugPrint('⚠️ Animal ${animal.id} already exists or error: $e');
      }
    }
    await _loadAnimalsFromRepository();
  }

  void _loadMockData() {
    // no-op
  }

  // ==================== Sélection / Filtres ====================

  void setCurrentAnimal(Animal? animal) {
    _currentAnimal = animal;
    notifyListeners();
  }

  void clearCurrentAnimal() {
    _currentAnimal = null;
    notifyListeners();
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void setStatusFilter(AnimalStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }

  // ==================== Accès par identifiant ====================

  Animal? getAnimalById(String id) {
    try {
      return animals.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  Animal? findByEIDOrNumber(String query) {
    if (query.trim().isEmpty) return null;

    final q = query.toLowerCase().trim();

    try {
      return animals.firstWhere(
        (a) => (a.currentEid?.toLowerCase() ?? '').contains(q),
      );
    } catch (_) {
      try {
        return animals.firstWhere(
          (a) => (a.officialNumber?.toLowerCase() ?? '').contains(q),
        );
      } catch (_) {
        return null;
      }
    }
  }

  List<Treatment> getAnimalTreatments(String animalId) {
    return treatments.where((t) => t.animalId == animalId).toList();
  }

  List<Movement> getAnimalMovements(String animalId) {
    return movements.where((m) => m.animalId == animalId).toList();
  }

  // ==================== CRUD: Animals ====================

  Future<void> addAnimal(Animal animal) async {
    final withFarm = animal.copyWith(farmId: _authProvider.currentFarmId);

    try {
      await _repository.create(withFarm, _authProvider.currentFarmId);

      _allAnimals.add(withFarm);
      _lastRefreshTime = DateTime.now(); // A5: Invalider cache
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error adding animal: $e');
      rethrow;
    }
  }

  Future<void> updateAnimal(Animal updated) async {
    try {
      await _repository.update(updated, _authProvider.currentFarmId);

      final i = _allAnimals.indexWhere((a) => a.id == updated.id);
      if (i != -1) {
        _allAnimals[i] = updated;
        if (_currentAnimal?.id == updated.id) {
          _currentAnimal = updated;
        }
        _lastRefreshTime = DateTime.now(); // A5: Invalider cache
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error updating animal: $e');
      rethrow;
    }
  }

  Future<void> removeAnimal(String id) async {
    try {
      await _repository.delete(id, _authProvider.currentFarmId);

      final before = _allAnimals.length;
      _allAnimals.removeWhere((a) => a.id == id);
      if (_allAnimals.length < before) {
        if (_currentAnimal?.id == id) {
          _currentAnimal = null;
        }
        _lastRefreshTime = DateTime.now(); // A5: Invalider cache
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error removing animal: $e');
      rethrow;
    }
  }

  // ==================== CRUD: Treatments ====================

  void addTreatment(Treatment t) {
    final withFarm = t.copyWith(farmId: _authProvider.currentFarmId);
    _allTreatments.add(withFarm);
    notifyListeners();
  }

  void updateTreatment(Treatment updated) {
    final i = _allTreatments.indexWhere((t) => t.id == updated.id);
    if (i != -1) {
      _allTreatments[i] = updated;
      notifyListeners();
    }
  }

  void removeTreatment(String id) {
    final before = _allTreatments.length;
    _allTreatments.removeWhere((t) => t.id == id);
    if (_allTreatments.length < before) {
      notifyListeners();
    }
  }

  // ==================== CRUD: Movements ====================

  void addMovement(Movement m) {
    final withFarm = m.copyWith(farmId: _authProvider.currentFarmId);
    _allMovements.add(withFarm);
    notifyListeners();
  }

  void updateMovement(Movement updated) {
    final i = _allMovements.indexWhere((m) => m.id == updated.id);
    if (i != -1) {
      _allMovements[i] = updated;
      notifyListeners();
    }
  }

  void removeMovement(String id) {
    final before = _allMovements.length;
    _allMovements.removeWhere((m) => m.id == id);
    if (_allMovements.length < before) {
      notifyListeners();
    }
  }

  // ==================== Produits ====================

  void setProducts(List<Product> items) {
    _allProducts
      ..clear()
      ..addAll(items);
    notifyListeners();
  }

  Product? getProductById(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  // ==================== Logique métier ====================

  bool hasActiveWithdrawal(String animalId) {
    final animalTreats = getAnimalTreatments(animalId);
    for (final t in animalTreats) {
      if (t.isWithdrawalActive) return true;
    }
    return false;
  }

  // ==================== Compteurs ====================

  int get totalAnimals => animals.length;
  int get totalTreatments => treatments.length;
  int get totalMovements => movements.length;

  List<Treatment> getActiveWithdrawalTreatments() {
    return treatments.where((t) => t.isWithdrawalActive).toList();
  }

  Map<String, int> get stats {
    return {
      'total': animals.length,
      'alive': animals.where((a) => a.status == AnimalStatus.alive).length,
      'male': animals.where((a) => a.sex == AnimalSex.male).length,
      'female': animals.where((a) => a.sex == AnimalSex.female).length,
      'sold': animals.where((a) => a.status == AnimalStatus.sold).length,
      'dead': animals.where((a) => a.status == AnimalStatus.dead).length,
      'slaughtered':
          animals.where((a) => a.status == AnimalStatus.slaughtered).length,
    };
  }

  Future<void> updateAnimalStatus(
      String animalId, AnimalStatus newStatus) async {
    final animal = getAnimalById(animalId);
    if (animal != null) {
      final updated = animal.copyWith(status: newStatus);
      await updateAnimal(updated);
    }
  }

  // ==================== A3: Recherche avancée ====================

  /// A1: Animaux nés entre deux dates
  Future<List<Animal>> searchAnimalsByBirthDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _repository.findByBirthDateRange(
      _currentFarmId,
      startDate,
      endDate,
    );
  }

  /// A1: Animaux par plage d'âge
  Future<List<Animal>> searchAnimalsByAgeRange(
    int minDays,
    int maxDays,
  ) async {
    return await _repository.findByAgeRangeInDays(
      _currentFarmId,
      minDays,
      maxDays,
    );
  }

  /// A2: Recherche composée espèce + statut
  Future<List<Animal>> searchBySpeciesAndStatus(
    String speciesId,
    String status,
  ) async {
    return await _repository.findBySpeciesAndStatus(
      _currentFarmId,
      speciesId,
      status,
    );
  }

  /// A2: Recherche composée statut + sexe
  Future<List<Animal>> searchByStatusAndSex(
    String status,
    String sex,
  ) async {
    return await _repository.findByStatusAndSex(
      _currentFarmId,
      status,
      sex,
    );
  }

  /// A3: Femelles en âge de reproduction
  Future<List<Animal>> getFemalesOfReproductiveAge() async {
    return await _repository.getFemalesOfReproductiveAge(_currentFarmId);
  }

  /// A4: Pagination support
  Future<PaginatedAnimals> getAnimalsPaginated({
    required int page,
    required int pageSize,
  }) async {
    return await _repository.getAnimalsPaginated(
      _currentFarmId,
      page: page,
      pageSize: pageSize,
    );
  }

  // ==================== Recherche intelligente ====================

  List<Animal> searchAnimals(String query) {
    if (query.isEmpty) return List.from(animals);

    final lowercaseQuery = query.toLowerCase();

    return animals.where((animal) {
      if (animal.currentEid?.toLowerCase().contains(lowercaseQuery) == true) {
        return true;
      }

      if (animal.officialNumber?.toLowerCase().contains(lowercaseQuery) ==
          true) {
        return true;
      }

      if (animal.visualId?.toLowerCase().contains(lowercaseQuery) == true) {
        return true;
      }

      if (animal.eidHistory != null) {
        for (final eidChange in animal.eidHistory!) {
          if (eidChange.oldEid.toLowerCase().contains(lowercaseQuery) ||
              eidChange.newEid.toLowerCase().contains(lowercaseQuery)) {
            return true;
          }
        }
      }

      return false;
    }).toList();
  }

  Animal? findAnimalByAnyId(String id) {
    try {
      return animals.firstWhere((animal) {
        if (animal.currentEid == id) return true;
        if (animal.officialNumber == id) return true;
        if (animal.visualId == id) return true;

        if (animal.eidHistory != null) {
          return animal.eidHistory!.any(
              (eidChange) => eidChange.oldEid == id || eidChange.newEid == id);
        }

        return false;
      });
    } catch (_) {
      return null;
    }
  }

  // ==================== Changement EID ====================

  Future<bool> changeAnimalEid({
    required String animalId,
    required String newEid,
    required String reason,
    String? notes,
  }) async {
    final animal = getAnimalById(animalId);
    if (animal == null) return false;

    final updated = animal.changeEid(
      newEid: newEid,
      reason: reason,
      notes: notes,
    );

    try {
      await updateAnimal(updated);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==================== 🆕 PART3 - VALIDATION MÈRE ====================

  /// Récupère toutes les femelles pouvant être mères
  List<Animal> get potentialMothers {
    return animals.where((a) => a.canBeMother).toList()
      ..sort((a, b) {
        final aNum = a.officialNumber ?? a.currentEid ?? '';
        final bNum = b.officialNumber ?? b.currentEid ?? '';
        return aNum.compareTo(bNum);
      });
  }

  /// Compte le nombre de naissances d'une mère
  int getBirthCountForMother(String motherId) {
    return animals.where((a) => a.motherId == motherId).length;
  }

  /// Récupère tous les enfants d'une mère
  List<Animal> getOffspring(String motherId) {
    return animals.where((a) => a.motherId == motherId).toList()
      ..sort((a, b) => b.birthDate.compareTo(a.birthDate));
  }

  /// Statistiques de reproduction d'une mère
  MotherStats getMotherStats(String motherId) {
    final offspring = getOffspring(motherId);

    return MotherStats(
      totalBirths: offspring.length,
      aliveOffspring:
          offspring.where((a) => a.status == AnimalStatus.alive).length,
      lastBirthDate: offspring.isNotEmpty ? offspring.first.birthDate : null,
      averageInterval: _calculateAverageInterval(offspring),
    );
  }

  Duration? _calculateAverageInterval(List<Animal> offspring) {
    if (offspring.length < 2) return null;

    final intervals = <int>[];
    for (var i = 0; i < offspring.length - 1; i++) {
      final interval =
          offspring[i].birthDate.difference(offspring[i + 1].birthDate).inDays;
      intervals.add(interval);
    }

    final avgDays = intervals.reduce((a, b) => a + b) ~/ intervals.length;
    return Duration(days: avgDays);
  }

  /// Validation : vérifie les animaux sans mère déclarée
  List<Animal> getAnimalsWithoutMother() {
    return animals.where((a) {
      final bornInFarm = a.birthDate.isAfter(DateTime(2020));
      return bornInFarm && a.motherId == null;
    }).toList();
  }

  // ==================== A5: Refresh optimisé ====================

  /// Rafraîchit les données depuis SQLite avec gestion du cache
  /// Si cache valide (<5 min), ne recharge pas
  Future<void> refresh({bool forceRefresh = false}) async {
    if (!forceRefresh && _isCacheValid) {
      debugPrint('📦 Cache valid, skip refresh');
      return;
    }
    await _loadAnimalsFromRepository();
  }

  /// Invalide complètement le cache
  void invalidateCache() {
    _lastRefreshTime = null;
  }

  // ==================== DRAFT SYSTEM ====================
  /// Valider un animal (DRAFT → ALIVE)
  Future<void> validateAnimal(String animalId) async {
    try {
      final animal = _allAnimals.firstWhere((a) => a.id == animalId);
      final updated = animal.copyWith(
        status: AnimalStatus.alive,
        validatedAt: DateTime.now(),
      );
      await updateAnimal(updated);
      debugPrint('✅ Animal validé: $animalId');
    } catch (e) {
      debugPrint('❌ Error validating animal: $e');
      rethrow;
    }
  }

  /// Supprimer un animal (hard delete pour DRAFT)
  Future<void> deleteAnimal(String animalId) async {
    try {
      await removeAnimal(animalId);
      debugPrint('✅ Animal supprimé: $animalId');
    } catch (e) {
      debugPrint('❌ Error deleting animal: $e');
      rethrow;
    }
  }

  // ==================== DRAFT ALERTES ====================

  /// Getter: Tous les animaux DRAFT en alerte (> 48h)
  List<Animal> get alertableDrafts {
    return animals.where((animal) {
      if (animal.status != AnimalStatus.draft) return false;
      return isDraftAlerting(animal);
    }).toList();
  }

  /// Getter: Tous les animaux groupés par statut
  Map<AnimalStatus, List<Animal>> get groupedByStatus {
    final grouped = <AnimalStatus, List<Animal>>{};

    for (final status in AnimalStatus.values) {
      grouped[status] = animals.where((a) => a.status == status).toList();
    }

    return grouped;
  }

  /// Vérifier si un animal DRAFT est en alerte (> 48h)
  bool isDraftAlerting(Animal animal) {
    if (animal.status != AnimalStatus.draft) return false;

    final hoursSinceCreation =
        DateTime.now().difference(animal.createdAt).inHours;
    return hoursSinceCreation >= AppConstants.draftAlertHours;
  }

  /// Vérifier si un animal DRAFT est en alerte CRITIQUE (> 7j)
  bool isDraftCritical(Animal animal) {
    if (animal.status != AnimalStatus.draft) return false;

    final hoursSinceCreation =
        DateTime.now().difference(animal.createdAt).inHours;
    return hoursSinceCreation >= AppConstants.draftAlertLimitHours;
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onFarmChanged);
    super.dispose();
  }
}
