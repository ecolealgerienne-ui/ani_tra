import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../models/treatment.dart';
import '../models/movement.dart';
import '../data/mock_data.dart';

class AnimalProvider extends ChangeNotifier {
  List<Animal> _animals = [];
  List<Treatment> _treatments = [];
  List<Movement> _movements = [];
  Animal? _currentAnimal;
  String _searchQuery = '';
  AnimalStatus? _statusFilter;

  AnimalProvider() {
    _loadMockData();
  }

  // Getters
  List<Animal> get animals => _filteredAnimals;
  Animal? get currentAnimal => _currentAnimal;
  String get searchQuery => _searchQuery;
  AnimalStatus? get statusFilter => _statusFilter;

  List<Animal> get _filteredAnimals {
    var filtered = _animals;

    // Filter by status
    if (_statusFilter != null) {
      filtered = filtered.where((a) => a.status == _statusFilter).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((a) {
        final query = _searchQuery.toLowerCase();
        return a.eid.toLowerCase().contains(query) ||
            (a.officialNumber?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return filtered;
  }

  // Stats
  Map<String, int> get stats {
    final alive = _animals.where((a) => a.status == AnimalStatus.alive).length;
    final sold = _animals.where((a) => a.status == AnimalStatus.sold).length;
    final dead = _animals.where((a) => a.status == AnimalStatus.dead).length;
    final females = _animals
        .where(
            (a) => a.sex == AnimalSex.female && a.status == AnimalStatus.alive)
        .length;

    return {
      'total': _animals.length,
      'alive': alive,
      'sold': sold,
      'dead': dead,
      'females': females,
    };
  }

  int get withdrawalAlertsCount {
    final now = DateTime.now();
    return _treatments.where((t) {
      return t.withdrawalEndDate.isAfter(now) && t.daysUntilWithdrawalEnd <= 7;
    }).length;
  }

  // Load mock data
  void _loadMockData() {
    _animals = MockData.animals;
    _treatments = MockData.generateTreatments(_animals);
    _movements = MockData.generateMovements(_animals);
    notifyListeners();
  }

  // Search & Filter
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setStatusFilter(AnimalStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _statusFilter = null;
    notifyListeners();
  }

  // Animal operations
  void setCurrentAnimal(Animal animal) {
    _currentAnimal = animal;
    notifyListeners();
  }

  Animal? findAnimalByEid(String eid) {
    try {
      return _animals.firstWhere((a) => a.eid == eid);
    } catch (e) {
      return null;
    }
  }

  Animal? findAnimalById(String id) {
    try {
      return _animals.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  // Simulate RFID scan (returns random live animal)
  Animal simulateScan() {
    final liveAnimals =
        _animals.where((a) => a.status == AnimalStatus.alive).toList();

    if (liveAnimals.isEmpty) {
      throw Exception('No live animals available');
    }

    final randomIndex = DateTime.now().millisecond % liveAnimals.length;
    final scannedAnimal = liveAnimals[randomIndex];

    setCurrentAnimal(scannedAnimal);
    return scannedAnimal;
  }

  // Get animal treatments
  List<Treatment> getAnimalTreatments(String animalId) {
    return _treatments.where((t) => t.animalId == animalId).toList()
      ..sort((a, b) => b.treatmentDate.compareTo(a.treatmentDate));
  }

  // Get animal movements
  List<Movement> getAnimalMovements(String animalId) {
    return _movements.where((m) => m.animalId == animalId).toList()
      ..sort((a, b) => b.movementDate.compareTo(a.movementDate));
  }

  // Get mother
  Animal? getMother(String? motherId) {
    if (motherId == null) return null;
    return findAnimalById(motherId);
  }

  // Get children
  List<Animal> getChildren(String motherId) {
    return _animals.where((a) => a.motherId == motherId).toList();
  }

  // Add treatment (for campaigns)
  void addTreatment(Treatment treatment) {
    _treatments.add(treatment);
    notifyListeners();
  }

  // Add movement
  void addMovement(Movement movement) {
    _movements.add(movement);

    // Update animal status if needed
    if (movement.type == MovementType.sale) {
      _updateAnimalStatus(movement.animalId, AnimalStatus.sold);
    } else if (movement.type == MovementType.death) {
      _updateAnimalStatus(movement.animalId, AnimalStatus.dead);
    }

    notifyListeners();
  }

  // Add new animal (for births)
  void addAnimal(Animal animal) {
    _animals.add(animal);
    notifyListeners();
  }

  // Update animal status
  void _updateAnimalStatus(String animalId, AnimalStatus status) {
    final index = _animals.indexWhere((a) => a.id == animalId);
    if (index != -1) {
      _animals[index] = _animals[index].copyWith(status: status);
    }
  }

  // Get active withdrawal treatments
  List<Treatment> getActiveWithdrawalTreatments() {
    final now = DateTime.now();
    return _treatments.where((t) {
      return t.withdrawalEndDate.isAfter(now);
    }).toList()
      ..sort((a, b) => a.withdrawalEndDate.compareTo(b.withdrawalEndDate));
  }

  // Ajouter cette méthode dans AnimalProvider

  /// Vérifier si un animal a une rémanence active
  bool hasActiveWithdrawal(String animalId) {
    final treatments = getAnimalTreatments(animalId);

    for (final treatment in treatments) {
      if (treatment.isWithdrawalActive) {
        return true;
      }
    }

    return false;
  }

  /// Obtenir les traitements d'un animal
  List<Treatment> getAnimalTreatments(String animalId) {
    return _treatments.where((t) => t.animalId == animalId).toList();
  }
}
