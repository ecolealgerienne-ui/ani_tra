// lib/providers/animal_provider.dart
import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../models/treatment.dart';
import '../models/movement.dart';
import '../models/product.dart';
import '../data/mock_data.dart';

class AnimalProvider extends ChangeNotifier {
  // Données principales
  final List<Product> _products = [];
  final List<Animal> _animals = [];
  final List<Treatment> _treatments = [];
  final List<Movement> _movements = [];

  // État courant / filtres
  Animal? _currentAnimal;
  String _searchQuery = '';
  AnimalStatus? _statusFilter;

  AnimalProvider() {
    _loadMockData();
  }

  // ==================== Getters ====================

  List<Product> get products => List.unmodifiable(_products);
  List<Animal> get animals => List.unmodifiable(_animals);
  List<Treatment> get treatments => List.unmodifiable(_treatments);
  List<Movement> get movements => List.unmodifiable(_movements);

  Animal? get currentAnimal => _currentAnimal;
  String get searchQuery => _searchQuery;
  AnimalStatus? get statusFilter => _statusFilter;

  /// Animaux filtrés selon recherche et statut
  List<Animal> get filteredAnimals {
    Iterable<Animal> list = _animals;

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((a) {
        // Aucun texte UI ici (multi-langue côté interface)
        final eid = a.eid?.toLowerCase() ?? '';
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
    _animals
      ..clear()
      ..addAll(animals);
    _products
      ..clear()
      ..addAll(products);
    _treatments
      ..clear()
      ..addAll(treatments);
    _movements
      ..clear()
      ..addAll(movements);

    if (_currentAnimal != null) {
      _currentAnimal = _animals.firstWhere((a) => a.id == _currentAnimal!.id,
          orElse: () => _currentAnimal!);
    }

    notifyListeners();
  }

  void _loadMockData() {
    // no-op : à remplir si tu veux précharger des mocks
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
      return _animals.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Treatment> getAnimalTreatments(String animalId) {
    return _treatments.where((t) => t.animalId == animalId).toList();
  }

  List<Movement> getAnimalMovements(String animalId) {
    return _movements.where((m) => m.animalId == animalId).toList();
  }

  // ==================== CRUD: Animals ====================

  void addAnimal(Animal animal) {
    _animals.add(animal);
    notifyListeners();
  }

  void updateAnimal(Animal updated) {
    final i = _animals.indexWhere((a) => a.id == updated.id);
    if (i != -1) {
      _animals[i] = updated;
      if (_currentAnimal?.id == updated.id) {
        _currentAnimal = updated;
      }
      notifyListeners();
    }
  }

  void removeAnimal(String id) {
    final before = _animals.length;
    _animals.removeWhere((a) => a.id == id);
    if (_animals.length < before) {
      if (_currentAnimal?.id == id) {
        _currentAnimal = null;
      }
      notifyListeners();
    }
  }

  // ==================== CRUD: Treatments ====================

  void addTreatment(Treatment t) {
    _treatments.add(t);
    notifyListeners();
  }

  void updateTreatment(Treatment updated) {
    final i = _treatments.indexWhere((t) => t.id == updated.id);
    if (i != -1) {
      _treatments[i] = updated;
      notifyListeners();
    }
  }

  void removeTreatment(String id) {
    final before = _treatments.length;
    _treatments.removeWhere((t) => t.id == id);
    if (_treatments.length < before) {
      notifyListeners();
    }
  }

  // ==================== CRUD: Movements ====================

  void addMovement(Movement m) {
    _movements.add(m);
    notifyListeners();
  }

  void updateMovement(Movement updated) {
    final i = _movements.indexWhere((m) => m.id == updated.id);
    if (i != -1) {
      _movements[i] = updated;
      notifyListeners();
    }
  }

  void removeMovement(String id) {
    final before = _movements.length;
    _movements.removeWhere((m) => m.id == id);
    if (_movements.length < before) {
      notifyListeners();
    }
  }

  // ==================== Produits ====================

  void setProducts(List<Product> items) {
    _products
      ..clear()
      ..addAll(items);
    notifyListeners();
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
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

  int get totalAnimals => _animals.length;
  int get totalTreatments => _treatments.length;
  int get totalMovements => _movements.length;
}
