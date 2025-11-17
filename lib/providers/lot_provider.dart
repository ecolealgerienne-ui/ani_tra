// lib/providers/lot_provider.dart
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/lot.dart';
import '../models/animal.dart';
import '../models/treatment.dart';
import '../models/movement.dart';
import '../repositories/lot_repository.dart';
import 'auth_provider.dart';

const uuid = Uuid();

/// LotProvider - Phase 1C + Phase 1B (LotStatus)
/// CHANGEMENT: Utilise Repository pour Lots (SQLite) + Status support
class LotProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  final LotRepository _repository;
  String _currentFarmId;

  // ==================== I18N Notes (stored in DB) ====================
  // NOTE: Ces constantes correspondent aux clés i18n mais sont en français par défaut
  // car les providers n'ont pas accès au BuildContext pour la traduction.
  // Les notes des movements sont stockées dans la langue active au moment de la création.
  // Références: AppStrings.buyerNoteLabel, AppStrings.slaughterhouseNoteLabel
  static const String _buyerLabel = 'Acheteur:'; // buyerNoteLabel
  static const String _slaughterhouseLabel = 'Abattoir:'; // slaughterhouseNoteLabel

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

  /// PHASE 1: MODIFY - Use status with backward-compat via Lot.isOpen
  List<Lot> get openLots =>
      lots.where((l) => l.isOpen).toList();

  /// PHASE 1: MODIFY - Use status with backward-compat via Lot.isClosed
  List<Lot> get closedLots =>
      lots.where((l) => l.isClosed).toList();

  /// PHASE 1: ADD - Get archived lots via Lot.isArchived
  List<Lot> get archivedLots =>
      lots.where((l) => l.isArchived).toList();

  Lot? get activeLot => _activeLot;
  bool get isLoading => _isLoading;

  int get openLotsCount => openLots.length;
  int get closedLotsCount => closedLots.length;
  int get archivedLotsCount => archivedLots.length;
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
      // Ignore errors
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void loadInitialLots(List<Lot> lots) {
    _migrateLotsToRepository(lots);
  }

  Future<void> _migrateLotsToRepository(List<Lot> lots) async {
    for (final lot in lots) {
      try {
        await _repository.create(lot, lot.farmId);
      } catch (e) {
        // Ignore errors
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
      status: LotStatus.open, // PHASE 1: ADD
      completed: false,
      synced: false,
      createdAt: DateTime.now(),
      farmId: _authProvider.currentFarmId,
    );

    try {
      await _repository.create(lot, _authProvider.currentFarmId);
      _allLots.add(lot);
      _activeLot = lot;
      notifyListeners();
      return lot;
    } catch (e) {
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
      rethrow;
    }
  }

  Future<bool> renameLot(String lotId, String newName) async {
    final lot = getLotById(lotId);
    if (lot == null || lot.status != LotStatus.open) return false;

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
    if (lot == null || lot.status != LotStatus.open) return false;
    if (lot.animalIds.contains(animalId)) return false;

    final updatedIds = [...lot.animalIds, animalId];
    final updated = lot.copyWith(animalIds: updatedIds);

    // ✅ ÉTAPE 1: Mettre à jour _activeLot IMMÉDIATEMENT
    // avant l'await pour éviter la race condition lors des scans rapides
    _activeLot = updated;
    notifyListeners();

    // ✅ ÉTAPE 2: Puis sauvegarder en DB (peut prendre du temps)
    try {
      await updateLot(updated);
      return true;
    } catch (e) {
      // ✅ ÉTAPE 3: Si la sauvegarde échoue, rollback à l'état précédent
      _activeLot = lot;
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeAnimalFromActiveLot(String animalId) async {
    final lot = _activeLot;
    if (lot == null || lot.status != LotStatus.open) return false;
    if (!lot.animalIds.contains(animalId)) return false;

    final updatedIds = lot.animalIds.where((id) => id != animalId).toList();
    final updated = lot.copyWith(animalIds: updatedIds);

    // ✅ Mettre à jour _activeLot IMMÉDIATEMENT
    _activeLot = updated;
    notifyListeners();

    try {
      await updateLot(updated);
      return true;
    } catch (e) {
      // Revenir à l'état précédent si la sauvegarde échoue
      _activeLot = lot;
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeAnimalFromLot(String lotId, String animalId) async {
    final lot = getLotById(lotId);
    if (lot == null || lot.status != LotStatus.open) return false;
    if (!lot.animalIds.contains(animalId)) return false;

    final updatedIds = lot.animalIds.where((id) => id != animalId).toList();
    final updated = lot.copyWith(animalIds: updatedIds);
    await updateLot(updated);
    return true;
  }

  bool isAnimalInActiveLot(String animalId) {
    return _activeLot?.animalIds.contains(animalId) ?? false;
  }

  // ==================== ANIMAUX TOTAUX (pour lots fermés/archivés) ====================
  /// 🔍 Retourne les IDs de TOUS les animaux dans le lot
  /// (snapshot à la fermeture, peu importe leur statut actuel)
  ///
  /// Utilisé pour:
  /// - Lots fermés: afficher les animaux au moment de la fermeture
  /// - Lots archivés: historique complet
  List<String> getTotalAnimalIds(String lotId) {
    final lot = getLotById(lotId);
    if (lot == null) return [];
    return lot.animalIds; // Retourne TOUS les IDs
  }

  /// 📊 Retourne le nombre TOTAL d'animaux dans le lot
  /// (peu importe leur statut actuel)
  int getTotalAnimalCount(String lotId) {
    return getTotalAnimalIds(lotId).length;
  }

  // ==================== ANIMAUX ACTIFS (pour lots ouverts) ====================
  /// 🔍 Retourne les IDs des animaux ACTIFS dans le lot
  ///
  /// Un animal est ACTIF si son statut = AnimalStatus.alive
  /// Les animaux vendus, morts ou abattus sont exclus
  ///
  /// ⚠️ Nécessite AnimalProvider pour accéder au statut des animaux
  List<String> getActiveAnimalIds(String lotId, List<Animal> allAnimals) {
    final lot = getLotById(lotId);
    if (lot == null) return [];

    return lot.animalIds.where((animalId) {
      // Chercher l'animal dans la liste fournie
      final animal = allAnimals.firstWhere(
        (a) => a.id == animalId,
        orElse: () => Animal(
          id: animalId,
          birthDate: DateTime.now(),
          sex: AnimalSex.male,
          status: AnimalStatus.alive, // Valeur par défaut si non trouvé
        ),
      );
      // Inclure seulement les animaux ACTIFS
      return animal.status == AnimalStatus.alive;
    }).toList();
  }

  /// 📊 Retourne le nombre d'animaux ACTIFS dans le lot
  ///
  /// Compte uniquement les animaux avec status = AnimalStatus.alive
  /// Les animaux vendus, morts ou abattus ne sont pas comptés
  int getActiveAnimalCount(String lotId, List<Animal> allAnimals) {
    return getActiveAnimalIds(lotId, allAnimals).length;
  }

  // ==================== Finalisation ====================

  /// PHASE 1: MODIFY - Use status=closed instead of completed=true
  /// PHASE 2: Removed deprecated sale/slaughter parameters (now stored in Movement)
  Future<bool> finalizeLot(
    String lotId, {
    LotType? type,
    String? productId,
    String? productName,
    DateTime? treatmentDate,
    DateTime? withdrawalEndDate,
    String? veterinarianId,
    String? veterinarianName,
    String? notes,
  }) async {
    final lot = getLotById(lotId);
    if (lot == null || lot.status != LotStatus.open) return false;

    final updated = lot.copyWith(
      type: type,
      status: LotStatus.closed, // PHASE 1: USE status instead of completed
      completed: true, // PHASE 1: KEEP for compat
      completedAt: DateTime.now(),
      productId: productId,
      productName: productName,
      treatmentDate: treatmentDate,
      withdrawalEndDate: withdrawalEndDate,
      veterinarianId: veterinarianId,
      veterinarianName: veterinarianName,
      notes: notes,
    );

    await updateLot(updated);
    if (_activeLot?.id == lotId) {
      _activeLot = null;
    }
    return true;
  }

  // ==================== Archivage ====================

  /// PHASE 1: ADD - Archive a closed lot
  Future<bool> archiveLot(String lotId) async {
    final lot = getLotById(lotId);
    if (lot == null || lot.status != LotStatus.closed) return false;

    final updated = lot.copyWith(status: LotStatus.archived);
    await updateLot(updated);
    return true;
  }

  // ==================== Duplication ====================

  /// PHASE 1: MODIFY - New lot always has status=open
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
      status: LotStatus.open, // PHASE 1: Always open
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
      notes: keepType ? sourceLot.notes : null,
      farmId: _authProvider.currentFarmId,
    );

    try {
      await _repository.create(duplicated, _authProvider.currentFarmId);
      _allLots.add(duplicated);
      notifyListeners();
      return duplicated;
    } catch (e) {
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

  /// DEPRECATED: Cette méthode n'est plus utilisée depuis la suppression des champs sale du Lot
  ///
  /// Les Movement de vente doivent maintenant être créés LORS de la finalisation du lot
  /// avec les données passées directement, pas extraites du Lot.
  ///
  /// TODO: Refactoriser pour accepter les données de vente en paramètres
  @Deprecated('Sale data no longer stored in Lot. Create Movement directly with sale data.')
  List<Movement> expandLotToSaleMovements(Lot lot) {
    // Cette méthode retourne maintenant une liste vide
    // Les Movement doivent être créés différemment
    return [];
  }

  /// DEPRECATED: Cette méthode n'est plus utilisée depuis la suppression des champs slaughter du Lot
  ///
  /// Les Movement d'abattage doivent maintenant être créés LORS de la finalisation du lot
  /// avec les données passées directement, pas extraites du Lot.
  ///
  /// TODO: Refactoriser pour accepter les données d'abattage en paramètres
  @Deprecated('Slaughter data no longer stored in Lot. Create Movement directly with slaughter data.')
  List<Movement> expandLotToSlaughterMovements(Lot lot) {
    // Cette méthode retourne maintenant une liste vide
    // Les Movement doivent être créés différemment
    return [];
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
      status:
          completed ? LotStatus.closed : LotStatus.open, // PHASE 1: SET status
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
      // Ignore errors
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
