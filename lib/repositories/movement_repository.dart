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
      type: _parseMovementType(data.type),
      movementDate: data.movementDate,
      fromFarmId: data.fromFarmId,
      toFarmId: data.toFarmId,
      price: data.price,
      notes: data.notes,
      buyerQrSignature: data.buyerQrSignature,
      returnDate: data.returnDate,
      returnNotes: data.returnNotes,
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
      returnDate: movement.returnDate != null
          ? Value(movement.returnDate!)
          : const Value.absent(),
      returnNotes: movement.returnNotes != null
          ? Value(movement.returnNotes!)
          : const Value.absent(),
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
      orElse: () => MovementType.purchase,
    );
  }
}
