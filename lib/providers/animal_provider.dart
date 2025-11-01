// lib/providers/animal_provider.dart
import 'package:flutter/material.dart';
import '../models/animal.dart';
import '../models/treatment.dart';
import '../models/movement.dart';
import '../models/product.dart';
import '../models/eid_change.dart';

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
        final eid = a.currentEid.toLowerCase();
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

  /// 🆕 MÉTHODE AJOUTÉE : Recherche par EID ou N° officiel
  ///
  /// Recherche un animal dont l'EID ou le N° officiel contient la query.
  /// Retourne le premier animal correspondant ou null si aucun match.
  Animal? findByEIDOrNumber(String query) {
    if (query.trim().isEmpty) return null;

    final q = query.toLowerCase().trim();

    try {
      // Chercher par EID (contient la query)
      return _animals.firstWhere(
        (a) => a.currentEid.toLowerCase().contains(q),
      );
    } catch (_) {
      // Si pas trouvé par EID, chercher par N° officiel
      try {
        return _animals.firstWhere(
          (a) => (a.officialNumber?.toLowerCase() ?? '').contains(q),
        );
      } catch (_) {
        // Aucun match
        return null;
      }
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

  /// Retourne tous les traitements avec rémanence active
  List<Treatment> getActiveWithdrawalTreatments() {
    return _treatments.where((t) => t.isWithdrawalActive).toList();
  }

  /// Statistiques du troupeau
  Map<String, int> get stats {
    return {
      'total': _animals.length,
      'alive': _animals.where((a) => a.status == AnimalStatus.alive).length,
      'male': _animals.where((a) => a.sex == AnimalSex.male).length,
      'female': _animals.where((a) => a.sex == AnimalSex.female).length,
      'sold': _animals.where((a) => a.status == AnimalStatus.sold).length,
      'dead': _animals.where((a) => a.status == AnimalStatus.dead).length,
      'slaughtered':
          _animals.where((a) => a.status == AnimalStatus.slaughtered).length,
    };
  }

  /// Met à jour le statut d'un animal
  void updateAnimalStatus(String animalId, AnimalStatus newStatus) {
    final animal = getAnimalById(animalId);
    if (animal != null) {
      final updated = animal.copyWith(status: newStatus);
      updateAnimal(updated);
    }
  }

  // ==================== CHANGEMENT D'EID ====================

  /// Changer l'EID d'un animal (en cas de puce perdue/cassée)
  ///
  /// Crée automatiquement un enregistrement dans l'historique
  ///
  /// [animalId] : ID de l'animal
  /// [newEid] : Nouveau code EID
  /// [reason] : Raison du changement (voir EidChangeReason)
  /// [notes] : Notes optionnelles
  ///
  /// Retourne true si le changement a réussi
  bool changeAnimalEid({
    required String animalId,
    required String newEid,
    required String reason,
    String? notes,
  }) {
    final animal = getAnimalById(animalId);
    if (animal == null) {
      debugPrint('❌ Animal non trouvé: $animalId');
      return false;
    }

    // Vérifier que le nouvel EID est différent
    if (animal.currentEid == newEid) {
      debugPrint('⚠️ Le nouvel EID est identique à l\'actuel');
      return false;
    }

    // Vérifier que le nouvel EID n'existe pas déjà
    final existingAnimal = _animals
        .where(
          (a) => a.currentEid == newEid && a.id != animalId,
        )
        .firstOrNull;

    if (existingAnimal != null) {
      debugPrint('❌ EID $newEid déjà utilisé par un autre animal');
      return false;
    }

    // Créer l'animal mis à jour avec le nouvel EID
    final updatedAnimal = animal.changeEid(
      newEid: newEid,
      reason: reason,
      notes: notes,
    );

    // Mettre à jour dans la liste
    updateAnimal(updatedAnimal);

    debugPrint(
        '✅ EID changé: ${animal.currentEid} → $newEid (raison: $reason)');
    return true;
  }

  /// Obtenir l'historique des changements d'EID d'un animal
  List<EidChange> getAnimalEidHistory(String animalId) {
    final animal = getAnimalById(animalId);
    if (animal == null) return [];
    return animal.eidHistory ?? [];
  }

  /// Vérifier si un EID existe déjà dans le troupeau
  bool isEidExists(String eid, {String? excludeAnimalId}) {
    return _animals.any((a) =>
        a.currentEid == eid &&
        (excludeAnimalId == null || a.id != excludeAnimalId));
  }

  /// Obtenir tous les EID utilisés (actuels + historique)
  Set<String> getAllUsedEids() {
    final eids = <String>{};

    for (final animal in _animals) {
      // EID actuel
      eids.add(animal.currentEid);

      // EID historiques
      if (animal.eidHistory != null) {
        for (final change in animal.eidHistory!) {
          eids.add(change.oldEid);
          eids.add(change.newEid);
        }
      }
    }

    return eids;
  }
}
