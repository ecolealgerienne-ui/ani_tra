// lib/providers/animal_provider.dart
import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../models/treatment.dart';
import '../models/movement.dart';
import '../models/product.dart';
import 'auth_provider.dart';

class AnimalProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  
  // Données principales (NON FILTRÉES - contient toutes les fermes)
  final List<Product> _allProducts = [];
  final List<Animal> _allAnimals = [];
  final List<Treatment> _allTreatments = [];
  final List<Movement> _allMovements = [];

  // État courant / filtres
  Animal? _currentAnimal;
  String _searchQuery = '';
  AnimalStatus? _statusFilter;

  AnimalProvider(this._authProvider) {
    _loadMockData();
  }

  // ==================== Getters FILTRÉS par farmId ====================

  List<Product> get products => List.unmodifiable(
    _allProducts.where((p) => p.farmId == _authProvider.currentFarmId)
  );
  
  List<Animal> get animals => List.unmodifiable(
    _allAnimals.where((a) => a.farmId == _authProvider.currentFarmId)
  );
  
  List<Treatment> get treatments => List.unmodifiable(
    _allTreatments.where((t) => t.farmId == _authProvider.currentFarmId)
  );
  
  List<Movement> get movements => List.unmodifiable(
    _allMovements.where((m) => m.farmId == _authProvider.currentFarmId)
  );

  Animal? get currentAnimal => _currentAnimal;
  String get searchQuery => _searchQuery;
  AnimalStatus? get statusFilter => _statusFilter;

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

  void initializeWithMockData(
    List<Animal> animals,
    List<Product> products,
    List<Treatment> treatments,
    List<Movement> movements,
  ) {
    _allAnimals
      ..clear()
      ..addAll(animals);
    _allProducts
      ..clear()
      ..addAll(products);
    _allTreatments
      ..clear()
      ..addAll(treatments);
    _allMovements
      ..clear()
      ..addAll(movements);

    if (_currentAnimal != null) {
      _currentAnimal = animals.firstWhere((a) => a.id == _currentAnimal!.id,
          orElse: () => _currentAnimal!);
    }

    notifyListeners();
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

  void addAnimal(Animal animal) {
    final withFarm = animal.copyWith(farmId: _authProvider.currentFarmId);
    _allAnimals.add(withFarm);
    notifyListeners();
  }

  void updateAnimal(Animal updated) {
    final i = _allAnimals.indexWhere((a) => a.id == updated.id);
    if (i != -1) {
      _allAnimals[i] = updated;
      if (_currentAnimal?.id == updated.id) {
        _currentAnimal = updated;
      }
      notifyListeners();
    }
  }

  void removeAnimal(String id) {
    final before = _allAnimals.length;
    _allAnimals.removeWhere((a) => a.id == id);
    if (_allAnimals.length < before) {
      if (_currentAnimal?.id == id) {
        _currentAnimal = null;
      }
      notifyListeners();
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
      'slaughtered': animals.where((a) => a.status == AnimalStatus.slaughtered).length,
    };
  }

  void updateAnimalStatus(String animalId, AnimalStatus newStatus) {
    final animal = getAnimalById(animalId);
    if (animal != null) {
      final updated = animal.copyWith(status: newStatus);
      updateAnimal(updated);
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

      if (animal.officialNumber?.toLowerCase().contains(lowercaseQuery) == true) {
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

  bool changeAnimalEid({
    required String animalId,
    required String newEid,
    required String reason,
    String? notes,
  }) {
    final animal = getAnimalById(animalId);
    if (animal == null) return false;

    final updated = animal.changeEid(
      newEid: newEid,
      reason: reason,
      notes: notes,
    );

    updateAnimal(updated);
    return true;
  }
}
