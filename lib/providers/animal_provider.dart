// lib/providers/animal_provider.dart
import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../models/treatment.dart';
import '../models/movement.dart';
import '../models/product.dart';
import '../models/mother_stats.dart';
import 'auth_provider.dart';
import '../repositories/animal_repository.dart';

/// AnimalProvider - Phase 1A
/// CHANGEMENT: Utilise Repository pour Animals (SQLite)
/// IDENTIQUE: Treatment/Movement/Product restent en mock
class AnimalProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  final AnimalRepository _repository;
  String _currentFarmId;

  // Données principales (NON FILTRÉES - contient toutes les fermes)
  final List<Product> _allProducts = [];
  final List<Animal> _allAnimals = []; // ← Cache local, alimenté par Repository
  final List<Treatment> _allTreatments = [];
  final List<Movement> _allMovements = [];

  // Loading state (nouveau)
  bool _isLoading = false;

  // État courant / filtres
  Animal? _currentAnimal;
  String _searchQuery = '';
  AnimalStatus? _statusFilter;

  AnimalProvider(this._authProvider, this._repository)
      : _currentFarmId = _authProvider.currentFarmId {
    _authProvider.addListener(_onFarmChanged);
    _loadAnimalsFromRepository(); // ← Charge depuis SQLite au démarrage
  }

  void _onFarmChanged() {
    if (_currentFarmId != _authProvider.currentFarmId) {
      _currentFarmId = _authProvider.currentFarmId;
      _currentAnimal = null;
      _searchQuery = '';
      _statusFilter = null;
      _loadAnimalsFromRepository(); // ← Recharge depuis SQLite
    }
  }

  // ==================== Getters FILTRÉS par farmId ====================

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
  bool get isLoading => _isLoading; // ← Nouveau getter

  /// Animaux filtrés selon recherche et statut
  List<Animal> get filteredAnimals {
    Iterable<Animal> list = animals; // Déjà filtré par farmId

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

  /// Charge les animaux depuis SQLite (appelé au démarrage et au changement de ferme)
  Future<void> _loadAnimalsFromRepository() async {
    if (_currentFarmId.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Charger TOUS les animaux de la database (toutes fermes)
      // Note: getAll filtre déjà par farmId, mais on pourrait charger toutes les fermes
      final farmAnimals = await _repository.getAll(_currentFarmId);

      // Remplacer les animaux de cette ferme dans le cache
      _allAnimals.removeWhere((a) => a.farmId == _currentFarmId);
      _allAnimals.addAll(farmAnimals);
    } catch (e) {
      debugPrint('❌ Error loading animals from repository: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Initialise avec mock data (compatibilité - pour Treatment/Movement/Product)
  void initializeWithMockData(
    List<Animal> animals,
    List<Product> products,
    List<Treatment> treatments,
    List<Movement> movements,
  ) {
    // Products, Treatments, Movements restent en mock
    _allProducts
      ..clear()
      ..addAll(products);
    _allTreatments
      ..clear()
      ..addAll(treatments);
    _allMovements
      ..clear()
      ..addAll(movements);

    // Animals: on les sauvegarde dans SQLite puis on recharge
    _migrateAnimalsToRepository(animals);
  }

  /// Migre les animaux mock vers SQLite (appelé par initializeWithMockData)
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
    // no-op - gardé pour compatibilité
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
  // ⚠️ CHANGEMENT: Ces méthodes sont maintenant ASYNC et utilisent Repository

  Future<void> addAnimal(Animal animal) async {
    final withFarm = animal.copyWith(farmId: _authProvider.currentFarmId);

    try {
      // Sauvegarder dans SQLite
      await _repository.create(withFarm, _authProvider.currentFarmId);

      // Mettre à jour le cache local
      _allAnimals.add(withFarm);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error adding animal: $e');
      rethrow;
    }
  }

  Future<void> updateAnimal(Animal updated) async {
    try {
      // Mettre à jour dans SQLite
      await _repository.update(updated, _authProvider.currentFarmId);

      // Mettre à jour le cache local
      final i = _allAnimals.indexWhere((a) => a.id == updated.id);
      if (i != -1) {
        _allAnimals[i] = updated;
        if (_currentAnimal?.id == updated.id) {
          _currentAnimal = updated;
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error updating animal: $e');
      rethrow;
    }
  }

  Future<void> removeAnimal(String id) async {
    try {
      // Supprimer de SQLite (soft-delete)
      await _repository.delete(id, _authProvider.currentFarmId);

      // Supprimer du cache local
      final before = _allAnimals.length;
      _allAnimals.removeWhere((a) => a.id == id);
      if (_allAnimals.length < before) {
        if (_currentAnimal?.id == id) {
          _currentAnimal = null;
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error removing animal: $e');
      rethrow;
    }
  }

  // ==================== CRUD: Treatments ====================
  // ⚠️ IDENTIQUE: Restent synchrones avec mock lists

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
  // ⚠️ IDENTIQUE: Restent synchrones avec mock lists

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
  // ⚠️ IDENTIQUE: Restent synchrones avec mock lists

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

  // ==================== Refresh ====================

  /// Rafraîchit les données depuis SQLite (pour pull-to-refresh)
  Future<void> refresh() async {
    await _loadAnimalsFromRepository();
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onFarmChanged);
    super.dispose();
  }
}
