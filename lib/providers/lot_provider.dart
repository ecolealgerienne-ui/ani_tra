// lib/providers/lot_provider.dart
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/lot.dart';
import '../models/treatment.dart';
import '../models/movement.dart';
import '../repositories/lot_repository.dart';
import '../utils/constants.dart';
import 'auth_provider.dart';

const uuid = Uuid();

/// LotProvider - Phase 1C
/// CHANGEMENT: Utilise Repository pour Lots (SQLite)
class LotProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  final LotRepository _repository;
  String _currentFarmId;

  // Données principales (cache local)
  final List<Lot> _allLots = [];

  // Loading state
  bool _isLoading = false;

  Lot? _activeLot;

  LotProvider(this._authProvider, this._repository)
      : _currentFarmId = _authProvider.currentFarmId {
    _authProvider.addListener(_onFarmChanged);
    _loadLotsFromRepository();
  }

  void _onFarmChanged() {
    if (_currentFarmId != _authProvider.currentFarmId) {
      _currentFarmId = _authProvider.currentFarmId;
      _activeLot = null;
      _loadLotsFromRepository();
    }
  }

  // ==================== Getters ====================

  List<Lot> get lots => List.unmodifiable(
      _allLots.where((l) => l.farmId == _authProvider.currentFarmId));

  List<Lot> get openLots => lots.where((l) => !l.completed).toList();

  List<Lot> get closedLots => lots.where((l) => l.completed).toList();

  Lot? get activeLot => _activeLot;
  bool get isLoading => _isLoading;

  int get openLotsCount => openLots.length;
  int get closedLotsCount => closedLots.length;
  int get totalLotsCount => lots.length;

  // ==================== Repository Loading ====================

  Future<void> _loadLotsFromRepository() async {
    if (_currentFarmId.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final farmLots = await _repository.findAllByFarm(_currentFarmId);
      _allLots.removeWhere((l) => l.farmId == _currentFarmId);
      _allLots.addAll(farmLots);
    } catch (e) {
      debugPrint('❌ Error loading lots from repository: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void loadMockLots(List<Lot> mockLots) {
    _migrateLotsToRepository(mockLots);
  }

  Future<void> _migrateLotsToRepository(List<Lot> lots) async {
    for (final lot in lots) {
      try {
        await _repository.create(lot, lot.farmId);
      } catch (e) {
        debugPrint('⚠️ Lot ${lot.id} already exists or error: $e');
      }
    }
    await _loadLotsFromRepository();
  }

  // ==================== CRUD: Création ====================

  Future<Lot> createLot({
    required String name,
    LotType? type,
    List<String>? initialAnimalIds,
  }) async {
    final lot = Lot(
      id: uuid.v4(),
      name: name,
      type: type,
      animalIds: initialAnimalIds ?? [],
      completed: false,
      synced: false,
      createdAt: DateTime.now(),
      farmId: _authProvider.currentFarmId,
    );

    try {
      debugPrint(
          '📹 Creating lot: name=$name, farmId=$_authProvider.currentFarmId, type=$type');
      await _repository.create(lot, _authProvider.currentFarmId);
      debugPrint('✅ Lot created in DB: ${lot.id}');
      _allLots.add(lot);
      debugPrint('✅ Lot added to memory. Total: ${_allLots.length}');
      _activeLot = lot;
      notifyListeners();
      debugPrint('✅ notifyListeners called');
      return lot;
    } catch (e) {
      debugPrint('❌ Error creating lot: $e');
      rethrow;
    }
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

  Future<void> updateLot(Lot updated) async {
    try {
      await _repository.update(updated, _authProvider.currentFarmId);

      final index = _allLots.indexWhere((l) => l.id == updated.id);
      if (index != -1) {
        _allLots[index] = updated;
        if (_activeLot?.id == updated.id) {
          _activeLot = updated;
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error updating lot: $e');
      rethrow;
    }
  }

  Future<bool> renameLot(String lotId, String newName) async {
    final lot = getLotById(lotId);
    if (lot == null || lot.completed) return false;

    final updated = lot.copyWith(name: newName);
    await updateLot(updated);
    return true;
  }

  // ==================== FIXE RACE CONDITION ====================
  /// ✅ IMPORTANT: Mettre à jour _activeLot IMMÉDIATEMENT avant l'await
  /// pour éviter la race condition lors des scans rapides
  ///
  /// Bug avant: Scans rapides → chaque scan lit _activeLot non-mis-à-jour
  /// Résultat: Seul le dernier animal persiste
  ///
  /// Fix: Mettre à jour _activeLot PUIS sauvegarder en DB

  Future<bool> addAnimalToActiveLot(String animalId) async {
    final lot = _activeLot;
    if (lot == null || lot.completed) return false;
    if (lot.animalIds.contains(animalId)) return false;

    final updatedIds = [...lot.animalIds, animalId];
    final updated = lot.copyWith(animalIds: updatedIds);

    // ✅ ÉTAPE 1: Mettre à jour _activeLot IMMÉDIATEMENT
    // avant l'await pour éviter la race condition lors des scans rapides
    _activeLot = updated;
    notifyListeners();

    debugPrint(
        '📱 Animal $animalId added to lot (mem). Total: ${updated.animalCount}');

    // ✅ ÉTAPE 2: Puis sauvegarder en DB (peut prendre du temps)
    try {
      await updateLot(updated);
      debugPrint('✅ Animal $animalId saved to DB');
      return true;
    } catch (e) {
      // ✅ ÉTAPE 3: Si la sauvegarde échoue, rollback à l'état précédent
      debugPrint('❌ Error saving animal $animalId to DB: $e');
      _activeLot = lot;
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeAnimalFromActiveLot(String animalId) async {
    final lot = _activeLot;
    if (lot == null || lot.completed) return false;
    if (!lot.animalIds.contains(animalId)) return false;

    final updatedIds = lot.animalIds.where((id) => id != animalId).toList();
    final updated = lot.copyWith(animalIds: updatedIds);

    // ✅ Mettre à jour _activeLot IMMÉDIATEMENT
    _activeLot = updated;
    notifyListeners();

    debugPrint(
        '📱 Animal $animalId removed from lot (mem). Total: ${updated.animalCount}');

    try {
      await updateLot(updated);
      debugPrint('✅ Animal $animalId removal saved to DB');
      return true;
    } catch (e) {
      // Revenir à l'état précédent si la sauvegarde échoue
      debugPrint('❌ Error removing animal $animalId from DB: $e');
      _activeLot = lot;
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeAnimalFromLot(String lotId, String animalId) async {
    final lot = getLotById(lotId);
    if (lot == null || lot.completed) return false;
    if (!lot.animalIds.contains(animalId)) return false;

    final updatedIds = lot.animalIds.where((id) => id != animalId).toList();
    final updated = lot.copyWith(animalIds: updatedIds);
    await updateLot(updated);
    return true;
  }

  bool isAnimalInActiveLot(String animalId) {
    return _activeLot?.animalIds.contains(animalId) ?? false;
  }

  // ==================== Finalisation ====================

  Future<bool> finalizeLot(
    String lotId, {
    required LotType type,
    String? productId,
    String? productName,
    DateTime? treatmentDate,
    DateTime? withdrawalEndDate,
    String? veterinarianId,
    String? veterinarianName,
    String? buyerName,
    String? buyerFarmId,
    double? totalPrice,
    double? pricePerAnimal,
    DateTime? saleDate,
    String? slaughterhouseName,
    String? slaughterhouseId,
    DateTime? slaughterDate,
    String? notes,
  }) async {
    final lot = getLotById(lotId);
    if (lot == null || lot.completed) return false;

    final updated = lot.copyWith(
      type: type,
      completed: true,
      completedAt: DateTime.now(),
      productId: productId,
      productName: productName,
      treatmentDate: treatmentDate,
      withdrawalEndDate: withdrawalEndDate,
      veterinarianId: veterinarianId,
      veterinarianName: veterinarianName,
      buyerName: buyerName,
      buyerFarmId: buyerFarmId,
      totalPrice: totalPrice,
      pricePerAnimal: pricePerAnimal,
      saleDate: saleDate,
      slaughterhouseName: slaughterhouseName,
      slaughterhouseId: slaughterhouseId,
      slaughterDate: slaughterDate,
      notes: notes,
    );

    await updateLot(updated);
    if (_activeLot?.id == lotId) {
      _activeLot = null;
    }
    return true;
  }

  // ==================== Duplication ====================

  Future<Lot> duplicateLot(
    Lot sourceLot, {
    String? newName,
    bool keepType = false,
    bool keepAnimals = true,
  }) async {
    final duplicated = Lot(
      id: uuid.v4(),
      name: newName ?? '${sourceLot.name} (copie)',
      type: keepType ? sourceLot.type : null,
      animalIds: keepAnimals ? List.from(sourceLot.animalIds) : [],
      completed: false,
      synced: false,
      createdAt: DateTime.now(),
      productId: keepType ? sourceLot.productId : null,
      productName: keepType ? sourceLot.productName : null,
      treatmentDate: keepType ? DateTime.now() : null,
      withdrawalEndDate: keepType
          ? (sourceLot.withdrawalEndDate != null &&
                  sourceLot.treatmentDate != null
              ? DateTime.now().add(sourceLot.withdrawalEndDate!
                  .difference(sourceLot.treatmentDate!))
              : null)
          : null,
      veterinarianId: keepType ? sourceLot.veterinarianId : null,
      veterinarianName: keepType ? sourceLot.veterinarianName : null,
      buyerName: keepType ? sourceLot.buyerName : null,
      buyerFarmId: keepType ? sourceLot.buyerFarmId : null,
      pricePerAnimal: keepType ? sourceLot.pricePerAnimal : null,
      totalPrice: null,
      saleDate: keepType ? DateTime.now() : null,
      slaughterhouseName: keepType ? sourceLot.slaughterhouseName : null,
      slaughterhouseId: keepType ? sourceLot.slaughterhouseId : null,
      slaughterDate: keepType ? DateTime.now() : null,
      notes: keepType ? sourceLot.notes : null,
      farmId: _authProvider.currentFarmId,
    );

    try {
      await _repository.create(duplicated, _authProvider.currentFarmId);
      _allLots.add(duplicated);
      notifyListeners();
      return duplicated;
    } catch (e) {
      debugPrint('❌ Error duplicating lot: $e');
      rethrow;
    }
  }

  // ==================== Suppression ====================

  Future<void> deleteLot(String lotId) async {
    try {
      await _repository.delete(lotId, _authProvider.currentFarmId);

      _allLots.removeWhere((l) => l.id == lotId);
      if (_activeLot?.id == lotId) {
        _activeLot = null;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error deleting lot: $e');
      rethrow;
    }
  }

  Future<void> cancelActiveLot() async {
    if (_activeLot == null) return;

    if (_activeLot!.animalIds.isEmpty) {
      await deleteLot(_activeLot!.id);
    }

    _activeLot = null;
    notifyListeners();
  }

  // ==================== Utilitaires ====================

  Lot? getLotById(String id) {
    try {
      return lots.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

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
        farmId: lot.farmId,
      );
    }).toList();
  }

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
        notes: 'Acheteur: ${lot.buyerName ?? AppConstants.notAvailable}',
        synced: false,
        createdAt: DateTime.now(),
        farmId: lot.farmId,
      );
    }).toList();
  }

  List<Movement> expandLotToSlaughterMovements(Lot lot) {
    if (lot.type != LotType.slaughter) return [];

    return lot.animalIds.map((animalId) {
      return Movement(
        id: uuid.v4(),
        animalId: animalId,
        type: MovementType.slaughter,
        movementDate: lot.slaughterDate ?? DateTime.now(),
        notes:
            'Abattoir: ${lot.slaughterhouseName ?? AppConstants.notAvailable}',
        synced: false,
        createdAt: DateTime.now(),
        farmId: lot.farmId,
      );
    }).toList();
  }

  // ==================== Migration depuis Campaign ====================

  Future<void> importCampaignAsLot({
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
  }) async {
    final lot = Lot(
      id: id,
      name: name,
      type: LotType.treatment,
      animalIds: animalIds,
      completed: completed,
      synced: false,
      createdAt: createdAt,
      completedAt: completed ? createdAt : null,
      productId: productId,
      productName: productName,
      treatmentDate: campaignDate,
      withdrawalEndDate: withdrawalEndDate,
      veterinarianId: veterinarianId,
      veterinarianName: veterinarianName,
      farmId: _authProvider.currentFarmId,
    );

    try {
      await _repository.create(lot, _authProvider.currentFarmId);
      _allLots.add(lot);
      notifyListeners();
    } catch (e) {
      debugPrint('⚠️ Campaign import error: $e');
    }
  }

  void clearAllLots() {
    _allLots.clear();
    _activeLot = null;
    notifyListeners();
  }

  // ==================== Refresh ====================

  Future<void> refresh() async {
    await _loadLotsFromRepository();
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onFarmChanged);
    super.dispose();
  }
}
