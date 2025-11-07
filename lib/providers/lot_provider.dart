// lib/providers/lot_provider.dart
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/lot.dart';
import 'auth_provider.dart';

import '../models/treatment.dart';
import '../models/movement.dart';

const uuid = Uuid();

/// Provider de gestion des lots
class LotProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  String _currentFarmId;

  LotProvider(this._authProvider)
      : _currentFarmId = _authProvider.currentFarmId {
    _authProvider.addListener(_onFarmChanged);
  }

  void _onFarmChanged() {
    if (_currentFarmId != _authProvider.currentFarmId) {
      _currentFarmId = _authProvider.currentFarmId;
      notifyListeners();
    }
  }

  List<Lot> _allLots = [];
  Lot? _activeLot;

  // ==================== Getters ====================

  List<Lot> get lots => List.unmodifiable(
    _allLots.where((item) => item.farmId == _authProvider.currentFarmId)
  );

  List<Lot> get openLots => _allLots.where((l) => !l.completed).toList();

  List<Lot> get closedLots => _allLots.where((l) => l.completed).toList();

  Lot? get activeLot => _activeLot;

  int get openLotsCount => openLots.length;
  int get closedLotsCount => closedLots.length;
  int get totalLotsCount => _allLots.length;

  // ==================== Création ====================

  /// Crée un nouveau lot (nom uniquement, type optionnel)
  Lot createLot({
    required String name,
    LotType? type,
    List<String>? initialAnimalIds,
  }) {
    final lot = Lot(
      id: uuid.v4(),
      name: name,
      type: type,
      animalIds: initialAnimalIds ?? [],
      completed: false,
      synced: false,
      createdAt: DateTime.now(),
    );

    final lotWithFarm = lot.copyWith(farmId: _authProvider.currentFarmId);
    _allLots.add(lotWithFarm);
    _activeLot = lot;
    notifyListeners();

    return lot;
  }

  // ==================== Sélection ====================

  void setActiveLot(Lot? lot) {
    _activeLot = lot;
    notifyListeners();
  }

  void clearActiveLot() {
    _activeLot = null;
    notifyListeners();
  }

  // ==================== Modification ====================

  /// Met à jour un lot
  void updateLot(Lot updated) {
    final index = _allLots.indexWhere((l) => l.id == updated.id);
    if (index != -1) {
      _allLots[index] = updated;
      if (_activeLot?.id == updated.id) {
        _activeLot = updated;
      }
      notifyListeners();
    }
  }

  /// Modifie le nom d'un lot (si ouvert)
  bool renameLot(String lotId, String newName) {
    final lot = getLotById(lotId);
    if (lot == null || lot.completed) return false;

    final updated = lot.copyWith(name: newName);
    updateLot(updated);
    return true;
  }

  /// Ajoute un animal au lot actif
  bool addAnimalToActiveLot(String animalId) {
    final lot = _activeLot;
    if (lot == null || lot.completed) return false;

    if (lot.animalIds.contains(animalId)) return false;

    final updatedIds = [...lot.animalIds, animalId];
    final updated = lot.copyWith(animalIds: updatedIds);
    updateLot(updated);
    return true;
  }

  /// Retire un animal du lot actif
  bool removeAnimalFromActiveLot(String animalId) {
    final lot = _activeLot;
    if (lot == null || lot.completed) return false;

    if (!lot.animalIds.contains(animalId)) return false;

    final updatedIds = lot.animalIds.where((id) => id != animalId).toList();
    final updated = lot.copyWith(animalIds: updatedIds);
    updateLot(updated);
    return true;
  }

  // ✅ AJOUT: Retire un animal d'un lot spécifique (par ID)
  bool removeAnimalFromLot(String lotId, String animalId) {
    final lot = getLotById(lotId);
    if (lot == null || lot.completed) return false;

    if (!lot.animalIds.contains(animalId)) return false;

    final updatedIds = lot.animalIds.where((id) => id != animalId).toList();
    final updated = lot.copyWith(animalIds: updatedIds);
    updateLot(updated);
    return true;
  }

  /// Vérifie si un animal est dans le lot actif
  bool isAnimalInActiveLot(String animalId) {
    return _activeLot?.animalIds.contains(animalId) ?? false;
  }

  // ==================== Finalisation ====================

  /// Finalise un lot (définit le type + données + ferme)
  bool finalizeLot(
    String lotId, {
    required LotType type,
    // Données Traitement
    String? productId,
    String? productName,
    DateTime? treatmentDate,
    DateTime? withdrawalEndDate,
    String? veterinarianId,
    String? veterinarianName,
    // Données Vente
    String? buyerName,
    String? buyerFarmId,
    double? totalPrice,
    double? pricePerAnimal,
    DateTime? saleDate,
    // Données Abattage
    String? slaughterhouseName,
    String? slaughterhouseId,
    DateTime? slaughterDate,
    // Notes
    String? notes,
  }) {
    final lot = getLotById(lotId);
    if (lot == null || lot.completed) return false;

    final updated = lot.copyWith(
      type: type,
      completed: true,
      completedAt: DateTime.now(),
      // Traitement
      productId: productId,
      productName: productName,
      treatmentDate: treatmentDate,
      withdrawalEndDate: withdrawalEndDate,
      veterinarianId: veterinarianId,
      veterinarianName: veterinarianName,
      // Vente
      buyerName: buyerName,
      buyerFarmId: buyerFarmId,
      totalPrice: totalPrice,
      pricePerAnimal: pricePerAnimal,
      saleDate: saleDate,
      // Abattage
      slaughterhouseName: slaughterhouseName,
      slaughterhouseId: slaughterhouseId,
      slaughterDate: slaughterDate,
      // Notes
      notes: notes,
    );

    updateLot(updated);
    if (_activeLot?.id == lotId) {
      _activeLot = null;
    }
    return true;
  }

  // ==================== Duplication ====================

  /// Duplique un lot existant
  Lot duplicateLot(
    Lot sourceLot, {
    String? newName,
    bool keepType = false,
    bool keepAnimals = true,
  }) {
    final duplicated = Lot(
      id: uuid.v4(),
      name: newName ?? '${sourceLot.name} (copie)',

      // Type : conservé ou non
      type: keepType ? sourceLot.type : null,

      // Animaux : conservés ou liste vide
      animalIds: keepAnimals ? List.from(sourceLot.animalIds) : [],

      // Statut : toujours ouvert
      completed: false,
      synced: false,
      createdAt: DateTime.now(),

      // Si keepType = true, conserver les données spécifiques
      // Traitement
      productId: keepType ? sourceLot.productId : null,
      productName: keepType ? sourceLot.productName : null,
      treatmentDate: keepType ? DateTime.now() : null, // Nouvelle date
      withdrawalEndDate: keepType
          ? (sourceLot.withdrawalEndDate != null &&
                  sourceLot.treatmentDate != null
              ? DateTime.now().add(sourceLot.withdrawalEndDate!
                  .difference(sourceLot.treatmentDate!))
              : null)
          : null,
      veterinarianId: keepType ? sourceLot.veterinarianId : null,
      veterinarianName: keepType ? sourceLot.veterinarianName : null,

      // Vente
      buyerName: keepType ? sourceLot.buyerName : null,
      buyerFarmId: keepType ? sourceLot.buyerFarmId : null,
      pricePerAnimal: keepType ? sourceLot.pricePerAnimal : null,
      // Prix total recalculé si nécessaire
      totalPrice: null,
      saleDate: keepType ? DateTime.now() : null,

      // Abattage
      slaughterhouseName: keepType ? sourceLot.slaughterhouseName : null,
      slaughterhouseId: keepType ? sourceLot.slaughterhouseId : null,
      slaughterDate: keepType ? DateTime.now() : null,

      // Notes
      notes: keepType ? sourceLot.notes : null,
    );

    final duplicatedWithFarm = duplicated.copyWith(farmId: _authProvider.currentFarmId);
    _allLots.add(duplicatedWithFarm);
    notifyListeners();

    return duplicated;
  }

  // ==================== Suppression ====================

  void deleteLot(String lotId) {
    _allLots.removeWhere((l) => l.id == lotId);
    if (_activeLot?.id == lotId) {
      _activeLot = null;
    }
    notifyListeners();
  }

  void cancelActiveLot() {
    if (_activeLot == null) return;

    // Si aucun animal, supprimer
    if (_activeLot!.animalIds.isEmpty) {
      _allLots.removeWhere((l) => l.id == _activeLot!.id);
    }

    _activeLot = null;
    notifyListeners();
  }

  // ==================== Utilitaires ====================

  Lot? getLotById(String id) {
    try {
      return _allLots.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Convertit un lot de traitement en traitements individuels
  List<Treatment> expandLotToTreatments(Lot lot) {
    if (lot.type != LotType.treatment) return [];

    return lot.animalIds.map((animalId) {
      return Treatment(
        id: uuid.v4(),
        animalId: animalId,
        productId: lot.productId ?? '',
        productName: lot.productName ?? '',
        dose: 0.0,
        treatmentDate: lot.treatmentDate ?? DateTime.now(),
        withdrawalEndDate: lot.withdrawalEndDate ?? DateTime.now(),
        notes: lot.notes,
        createdAt: DateTime.now(),
      );
    }).toList();
  }

  /// Convertit un lot de vente en mouvements
  List<Movement> expandLotToSaleMovements(Lot lot) {
    if (lot.type != LotType.sale) return [];

    return lot.animalIds.map((animalId) {
      return Movement(
        id: uuid.v4(),
        animalId: animalId,
        type: MovementType.sale,
        movementDate: lot.saleDate ?? DateTime.now(),
        toFarmId: lot.buyerFarmId,
        price: lot.pricePerAnimal,
        notes: 'Acheteur: ${lot.buyerName ?? "N/A"}',
        synced: false,
        createdAt: DateTime.now(),
      );
    }).toList();
  }

  /// Convertit un lot d'abattage en mouvements
  List<Movement> expandLotToSlaughterMovements(Lot lot) {
    if (lot.type != LotType.slaughter) return [];

    return lot.animalIds.map((animalId) {
      return Movement(
        id: uuid.v4(),
        animalId: animalId,
        type: MovementType.slaughter,
        movementDate: lot.slaughterDate ?? DateTime.now(),
        notes: 'Abattoir: ${lot.slaughterhouseName ?? "N/A"}',
        synced: false,
        createdAt: DateTime.now(),
      );
    }).toList();
  }

  // ==================== Mock / Reset ====================

  void loadMockLots(List<Lot> mockLots) {
    _allLots = mockLots;
    notifyListeners();
  }

  void clearAllLots() {
    _allLots.clear();
    _activeLot = null;
    notifyListeners();
  }

  // ==================== Migration depuis Campaign ====================

  /// Importe une campagne comme un lot de traitement fermé
  void importCampaignAsLot({
    required String id,
    required String name,
    required String productId,
    required String productName,
    required DateTime campaignDate,
    required DateTime withdrawalEndDate,
    String? veterinarianId,
    String? veterinarianName,
    required List<String> animalIds,
    required bool completed,
    required DateTime createdAt,
  }) {
    final lot = Lot(
      id: id,
      name: name,
      type: LotType.treatment,
      animalIds: animalIds,
      completed: completed,
      synced: false,
      createdAt: createdAt,
      completedAt: completed ? createdAt : null,
      // Données traitement
      productId: productId,
      productName: productName,
      treatmentDate: campaignDate,
      withdrawalEndDate: withdrawalEndDate,
      veterinarianId: veterinarianId,
      veterinarianName: veterinarianName,
    );

    final lotWithFarm = lot.copyWith(farmId: _authProvider.currentFarmId);
    _allLots.add(lotWithFarm);
    notifyListeners();
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onFarmChanged);
    super.dispose();
  }
}