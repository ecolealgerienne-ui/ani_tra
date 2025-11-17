// lib/repositories/movement_repository.dart

import 'package:drift/drift.dart';
import '../drift/database.dart';
//import '../drift/tables/movements_table.dart';
import '../models/movement.dart';

/// Repository pour la gestion des mouvements d'animaux
///
/// Couche business logic entre les providers et la base de données.
/// Responsabilités:
/// - Mapping Model ↔ Drift Companion
/// - Validation business
/// - Security checks (farmId)
/// - Conversion MovementType enum
/// - Calculs financiers (ventes/achats)
class MovementRepository {
  final AppDatabase _db;

  MovementRepository(this._db);

  // === CRUD OPERATIONS ===

  /// Récupère tous les mouvements d'une ferme
  Future<List<Movement>> getAll(String farmId) async {
    final items = await _db.movementDao.findByFarmId(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère un mouvement par ID avec security check
  Future<Movement?> getById(String id, String farmId) async {
    final item = await _db.movementDao.findById(id, farmId);
    if (item == null) return null;

    // Security check
    if (item.farmId != farmId) {
      throw Exception('Farm ID mismatch - Security violation');
    }

    return _mapToModel(item);
  }

  /// Crée un nouveau mouvement
  Future<void> create(Movement movement, String farmId) async {
    final companion = _mapToCompanion(movement, farmId);
    await _db.movementDao.insertItem(companion);
  }

  /// Met à jour un mouvement existant
  Future<void> update(Movement movement, String farmId) async {
    // Security check
    final existing = await _db.movementDao.findById(movement.id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Movement not found or farm mismatch');
    }

    final companion = _mapToCompanion(movement, farmId);
    await _db.movementDao.updateItem(companion, farmId);
  }

  /// Supprime un mouvement (soft-delete)
  Future<void> delete(String id, String farmId) async {
    await _db.movementDao.softDelete(id, farmId);
  }

  // === BUSINESS QUERIES ===

  /// Récupère les mouvements d'un animal
  Future<List<Movement>> getByAnimalId(
    String farmId,
    String animalId,
  ) async {
    final items = await _db.movementDao.findByAnimalId(farmId, animalId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les mouvements par type
  Future<List<Movement>> getByType(
    String farmId,
    MovementType type,
  ) async {
    final items = await _db.movementDao.findByType(farmId, type.name);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les mouvements dans une période
  Future<List<Movement>> getByDateRange(
    String farmId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final items =
        await _db.movementDao.findByDateRange(farmId, startDate, endDate);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les mouvements d'un type dans une période
  Future<List<Movement>> getByTypeAndDateRange(
    String farmId,
    MovementType type,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final items = await _db.movementDao
        .findByTypeAndDateRange(farmId, type.name, startDate, endDate);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les naissances
  Future<List<Movement>> getBirths(String farmId) async {
    final items = await _db.movementDao.findBirths(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les achats
  Future<List<Movement>> getPurchases(String farmId) async {
    final items = await _db.movementDao.findPurchases(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les ventes
  Future<List<Movement>> getSales(String farmId) async {
    final items = await _db.movementDao.findSales(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les décès
  Future<List<Movement>> getDeaths(String farmId) async {
    final items = await _db.movementDao.findDeaths(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les abattages
  Future<List<Movement>> getSlaughters(String farmId) async {
    final items = await _db.movementDao.findSlaughters(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Compte les mouvements par type
  Future<int> countByType(String farmId, MovementType type) async {
    return await _db.movementDao.countByType(farmId, type.name);
  }

  /// Compte les mouvements d'un animal
  Future<int> countByAnimalId(String farmId, String animalId) async {
    return await _db.movementDao.countByAnimalId(farmId, animalId);
  }

  // === FINANCIAL OPERATIONS ===

  /// Calcule le total des ventes sur une période
  Future<double> calculateTotalSalesAmount(
    String farmId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _db.movementDao
        .calculateTotalSalesAmount(farmId, startDate, endDate);
  }

  /// Calcule le total des achats sur une période
  Future<double> calculateTotalPurchasesAmount(
    String farmId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _db.movementDao
        .calculateTotalPurchasesAmount(farmId, startDate, endDate);
  }

  /// Calcule le bilan financier (ventes - achats) sur une période
  Future<double> calculateFinancialBalance(
    String farmId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final sales = await calculateTotalSalesAmount(farmId, startDate, endDate);
    final purchases =
        await calculateTotalPurchasesAmount(farmId, startDate, endDate);
    return sales - purchases;
  }

  // === PHASE 2: STRUCTURED SALE/SLAUGHTER QUERIES ===

  /// Récupère les ventes par nom d'acheteur
  ///
  /// Recherche partielle sur le nom (insensible à la casse)
  Future<List<Movement>> getSalesByBuyer(
    String farmId,
    String buyerName,
  ) async {
    final items = await _db.movementDao.findSalesByBuyer(farmId, buyerName);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les ventes à une ferme spécifique
  ///
  /// Filtre exact par buyerFarmId (ventes B2B)
  Future<List<Movement>> getSalesByBuyerFarmId(
    String farmId,
    String buyerFarmId,
  ) async {
    final items =
        await _db.movementDao.findSalesByBuyerFarmId(farmId, buyerFarmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les abattages par établissement
  ///
  /// Filtre par slaughterhouseId pour traçabilité
  Future<List<Movement>> getSlaughtersByFacility(
    String farmId,
    String slaughterhouseId,
  ) async {
    final items = await _db.movementDao
        .findSlaughtersByFacility(farmId, slaughterhouseId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Calcule le total des ventes à un acheteur
  ///
  /// Agrégation financière par acheteur sur une période
  Future<double> calculateTotalSalesByBuyer(
    String farmId,
    String buyerFarmId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _db.movementDao
        .calculateTotalSalesByBuyer(farmId, buyerFarmId, startDate, endDate);
  }

  // === PHASE 2: TEMPORARY MOVEMENT QUERIES ===

  /// Récupère les mouvements temporaires actifs (non retournés)
  ///
  /// Tri par date de retour prévue (les plus urgents d'abord)
  Future<List<Movement>> getActiveTemporaryMovements(String farmId) async {
    final items = await _db.movementDao.findActiveTemporaryMovements(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les mouvements temporaires en retard
  ///
  /// Animaux qui auraient dû être retournés
  Future<List<Movement>> getOverdueTemporaryMovements(String farmId) async {
    final items = await _db.movementDao.findOverdueTemporaryMovements(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les mouvements temporaires par type
  ///
  /// Filtre par sous-type (loan, transhumance, boarding, etc.)
  Future<List<Movement>> getTemporaryMovementsByType(
    String farmId,
    String temporaryMovementType,
  ) async {
    final items = await _db.movementDao
        .findTemporaryMovementsByType(farmId, temporaryMovementType);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Compte les mouvements temporaires actifs
  Future<int> countActiveTemporaryMovements(String farmId) async {
    return await _db.movementDao.countActiveTemporaryMovements(farmId);
  }

  /// Compte les mouvements temporaires en retard
  Future<int> countOverdueTemporaryMovements(String farmId) async {
    return await _db.movementDao.countOverdueTemporaryMovements(farmId);
  }

  // === SYNC OPERATIONS (Phase 2 ready) ===

  /// Récupère les mouvements non synchronisés
  Future<List<Movement>> getUnsynced(String farmId) async {
    final items = await _db.movementDao.getUnsynced(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Marque un mouvement comme synchronisé
  Future<void> markAsSynced(
    String id,
    String farmId,
    int serverVersion,
  ) async {
    await _db.movementDao.markSynced(id, farmId, serverVersion);
  }

  // === MAPPERS ===

  /// Convertit MovementsTableData → Movement (Model)
  Movement _mapToModel(MovementsTableData data) {
    return Movement(
      id: data.id,
      farmId: data.farmId,
      animalId: data.animalId,
      lotId: data.lotId,
      type: _parseMovementType(data.type),
      movementDate: data.movementDate,
      fromFarmId: data.fromFarmId,
      toFarmId: data.toFarmId,
      price: data.price,
      notes: data.notes,
      buyerQrSignature: data.buyerQrSignature,
      // Phase 2: Structured Sale/Slaughter Data
      buyerName: data.buyerName,
      buyerFarmId: data.buyerFarmId,
      buyerType: data.buyerType,
      slaughterhouseName: data.slaughterhouseName,
      slaughterhouseId: data.slaughterhouseId,
      // Phase 2: Temporary Movements
      isTemporary: data.isTemporary,
      temporaryMovementType: data.temporaryMovementType,
      expectedReturnDate: data.expectedReturnDate,
      relatedMovementId: data.relatedMovementId,
      // Status
      status: _parseMovementStatus(data.status),
      // Sync
      synced: data.synced,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      lastSyncedAt: data.lastSyncedAt,
      serverVersion: data.serverVersion?.toString(),
    );
  }

  /// Convertit Movement (Model) → MovementsTableCompanion (Drift)
  MovementsTableCompanion _mapToCompanion(
    Movement movement,
    String farmId,
  ) {
    return MovementsTableCompanion(
      id: Value(movement.id),
      farmId: Value(farmId),
      animalId: Value(movement.animalId),
      lotId: movement.lotId != null
          ? Value(movement.lotId!)
          : const Value.absent(),
      type: Value(movement.type.name),
      movementDate: Value(movement.movementDate),
      fromFarmId: movement.fromFarmId != null
          ? Value(movement.fromFarmId!)
          : const Value.absent(),
      toFarmId: movement.toFarmId != null
          ? Value(movement.toFarmId!)
          : const Value.absent(),
      price: movement.price != null
          ? Value(movement.price!)
          : const Value.absent(),
      notes: movement.notes != null
          ? Value(movement.notes!)
          : const Value.absent(),
      buyerQrSignature: movement.buyerQrSignature != null
          ? Value(movement.buyerQrSignature!)
          : const Value.absent(),
      // Phase 2: Structured Sale/Slaughter Data
      buyerName: movement.buyerName != null
          ? Value(movement.buyerName!)
          : const Value.absent(),
      buyerFarmId: movement.buyerFarmId != null
          ? Value(movement.buyerFarmId!)
          : const Value.absent(),
      buyerType: movement.buyerType != null
          ? Value(movement.buyerType!)
          : const Value.absent(),
      slaughterhouseName: movement.slaughterhouseName != null
          ? Value(movement.slaughterhouseName!)
          : const Value.absent(),
      slaughterhouseId: movement.slaughterhouseId != null
          ? Value(movement.slaughterhouseId!)
          : const Value.absent(),
      // Phase 2: Temporary Movements
      isTemporary: Value(movement.isTemporary),
      temporaryMovementType: movement.temporaryMovementType != null
          ? Value(movement.temporaryMovementType!)
          : const Value.absent(),
      expectedReturnDate: movement.expectedReturnDate != null
          ? Value(movement.expectedReturnDate!)
          : const Value.absent(),
      relatedMovementId: movement.relatedMovementId != null
          ? Value(movement.relatedMovementId!)
          : const Value.absent(),
      // Status (required field)
      status: Value(movement.status.name),
      // Sync
      synced: Value(movement.synced),
      lastSyncedAt: movement.lastSyncedAt != null
          ? Value(movement.lastSyncedAt!)
          : const Value.absent(),
      serverVersion: movement.serverVersion != null
          ? Value(int.tryParse(movement.serverVersion!) ?? 0)
          : const Value.absent(),
      deletedAt: const Value.absent(), // Jamais set manuellement
      createdAt: Value(movement.createdAt),
      updatedAt: Value(movement.updatedAt),
    );
  }

  // === ENUM HELPERS ===

  /// Parse une string en MovementType enum
  MovementType _parseMovementType(String type) {
    return MovementType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => MovementType.birth,
    );
  }

  /// Parse une string en MovementStatus enum
  MovementStatus _parseMovementStatus(String status) {
    return MovementStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => MovementStatus.ongoing,
    );
  }
}
