// lib/repositories/lot_repository.dart
import 'dart:convert';
import '../models/lot.dart';
import '../drift/database.dart';
import '../drift/daos/lot_dao.dart';
//import '../drift/tables/lots_table.dart';
import 'package:drift/drift.dart' as drift;

/// Repository pour gérer la persistance des lots
///
/// Fait le pont entre les models Dart et la base de données Drift
class LotRepository {
  final LotDao _dao;

  LotRepository(AppDatabase database) : _dao = database.lotDao;

  // ==================== CRUD Operations ====================

  /// Récupérer tous les lots d'une ferme
  Future<List<Lot>> findAllByFarm(String farmId) async {
    final data = await _dao.findAllByFarm(farmId);
    return data.map(_toLot).toList();
  }

  /// Récupérer un lot par son ID
  Future<Lot?> findById(String id) async {
    final data = await _dao.findById(id);
    return data != null ? _toLot(data) : null;
  }

  /// Récupérer les lots ouverts (non complétés) d'une ferme
  Future<List<Lot>> findOpenByFarm(String farmId) async {
    final data = await _dao.findOpenByFarm(farmId);
    return data.map(_toLot).toList();
  }

  /// Récupérer les lots complétés d'une ferme
  Future<List<Lot>> findCompletedByFarm(String farmId) async {
    final data = await _dao.findCompletedByFarm(farmId);
    return data.map(_toLot).toList();
  }

  /// Récupérer les lots par type pour une ferme
  Future<List<Lot>> findByTypeAndFarm(LotType type, String farmId) async {
    final typeString = type.name;
    final data = await _dao.findByTypeAndFarm(typeString, farmId);
    return data.map(_toLot).toList();
  }

  /// Récupérer les lots sans type défini pour une ferme
  Future<List<Lot>> findWithoutTypeByFarm(String farmId) async {
    final data = await _dao.findWithoutTypeByFarm(farmId);
    return data.map(_toLot).toList();
  }

  /// Récupérer les lots contenant un animal spécifique
  Future<List<Lot>> findByAnimalId(String animalId, String farmId) async {
    final data = await _dao.findByAnimalId(animalId, farmId);
    return data.map(_toLot).toList();
  }

  /// Récupérer les lots de traitement par produit
  Future<List<Lot>> findByProductId(String productId, String farmId) async {
    final data = await _dao.findByProductId(productId, farmId);
    return data.map(_toLot).toList();
  }

  /// Récupérer les lots de traitement par vétérinaire
  Future<List<Lot>> findByVeterinarianId(
      String veterinarianId, String farmId) async {
    final data = await _dao.findByVeterinarianId(veterinarianId, farmId);
    return data.map(_toLot).toList();
  }

  /// Créer un nouveau lot
  Future<Lot> create(Lot lot) async {
    final companion = _toCompanion(lot, isUpdate: false);
    await _dao.insertLot(companion);
    return lot;
  }

  /// Mettre à jour un lot
  Future<Lot> update(Lot lot) async {
    final companion = _toCompanion(lot, isUpdate: true);
    await _dao.updateLot(companion);
    return lot;
  }

  /// Supprimer un lot
  Future<void> delete(String id) async {
    await _dao.deleteLot(id);
  }

  // ==================== Business Logic ====================

  /// Marquer un lot comme complété
  Future<void> markAsCompleted(String id) async {
    await _dao.markAsCompleted(id);
  }

  /// Ajouter un animal au lot
  Future<void> addAnimalToLot(String lotId, String animalId) async {
    await _dao.addAnimalToLot(lotId, animalId);
  }

  /// Retirer un animal du lot
  Future<void> removeAnimalFromLot(String lotId, String animalId) async {
    await _dao.removeAnimalFromLot(lotId, animalId);
  }

  /// Définir le type du lot
  Future<void> setLotType(String id, LotType type) async {
    await _dao.setLotType(id, type.name);
  }

  /// Compter les lots d'une ferme
  Future<int> countByFarm(String farmId) async {
    return await _dao.countByFarm(farmId);
  }

  /// Compter les lots ouverts d'une ferme
  Future<int> countOpenByFarm(String farmId) async {
    return await _dao.countOpenByFarm(farmId);
  }

  /// Compter les lots par type pour une ferme
  Future<int> countByTypeAndFarm(LotType type, String farmId) async {
    return await _dao.countByTypeAndFarm(type.name, farmId);
  }

  /// Récupérer les lots non synchronisés d'une ferme
  Future<List<Lot>> findUnsyncedByFarm(String farmId) async {
    final data = await _dao.findUnsyncedByFarm(farmId);
    return data.map(_toLot).toList();
  }

  /// Récupérer les lots avec dates de rémanence proches
  Future<List<Lot>> findWithUpcomingWithdrawal(
      String farmId, DateTime beforeDate) async {
    final data = await _dao.findWithUpcomingWithdrawal(farmId, beforeDate);
    return data.map(_toLot).toList();
  }

  // ==================== Migration Support ====================

  /// Insérer plusieurs lots (pour migration)
  Future<void> insertAll(List<Lot> lots) async {
    for (final lot in lots) {
      await create(lot);
    }
  }

  /// Supprimer tous les lots d'une ferme
  Future<void> deleteAllByFarm(String farmId) async {
    final lots = await findAllByFarm(farmId);
    for (final lot in lots) {
      await delete(lot.id);
    }
  }

  // ==================== Conversion Methods ====================

  /// Convertir LotsTableData en Lot
  Lot _toLot(LotsTableData data) {
    // Décoder le JSON des animal_ids
    List<String> animalIds = [];
    try {
      final decoded = jsonDecode(data.animalIdsJson);
      if (decoded is List) {
        animalIds = decoded.cast<String>();
      }
    } catch (e) {
      animalIds = [];
    }

    // Convertir le type string en enum (nullable)
    LotType? type;
    if (data.type != null) {
      try {
        type = LotType.values.byName(data.type!);
      } catch (e) {
        type = null;
      }
    }

    return Lot(
      id: data.id,
      farmId: data.farmId,
      name: data.name,
      type: type,
      animalIds: animalIds,
      completed: data.completed,
      completedAt: data.completedAt,
      // Treatment fields
      productId: data.productId,
      productName: data.productName,
      treatmentDate: data.treatmentDate,
      withdrawalEndDate: data.withdrawalEndDate,
      veterinarianId: data.veterinarianId,
      veterinarianName: data.veterinarianName,
      // Sale fields
      buyerName: data.buyerName,
      buyerFarmId: data.buyerFarmId,
      totalPrice: data.totalPrice,
      pricePerAnimal: data.pricePerAnimal,
      saleDate: data.saleDate,
      // Slaughter fields
      slaughterhouseName: data.slaughterhouseName,
      slaughterhouseId: data.slaughterhouseId,
      slaughterDate: data.slaughterDate,
      // Notes
      notes: data.notes,
      // Sync fields
      synced: data.synced,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      lastSyncedAt: data.lastSyncedAt,
      serverVersion: data.serverVersion,
    );
  }

  /// Convertir Lot en LotsTableCompanion
  LotsTableCompanion _toCompanion(Lot lot, {required bool isUpdate}) {
    // Encoder animal_ids en JSON
    final animalIdsJson = jsonEncode(lot.animalIds);

    return LotsTableCompanion(
      id: drift.Value(lot.id),
      farmId: drift.Value(lot.farmId),
      name: drift.Value(lot.name),
      type: drift.Value(lot.type?.name),
      animalIdsJson: drift.Value(animalIdsJson),
      completed: drift.Value(lot.completed),
      completedAt: drift.Value(lot.completedAt),
      // Treatment fields
      productId: drift.Value(lot.productId),
      productName: drift.Value(lot.productName),
      treatmentDate: drift.Value(lot.treatmentDate),
      withdrawalEndDate: drift.Value(lot.withdrawalEndDate),
      veterinarianId: drift.Value(lot.veterinarianId),
      veterinarianName: drift.Value(lot.veterinarianName),
      // Sale fields
      buyerName: drift.Value(lot.buyerName),
      buyerFarmId: drift.Value(lot.buyerFarmId),
      totalPrice: drift.Value(lot.totalPrice),
      pricePerAnimal: drift.Value(lot.pricePerAnimal),
      saleDate: drift.Value(lot.saleDate),
      // Slaughter fields
      slaughterhouseName: drift.Value(lot.slaughterhouseName),
      slaughterhouseId: drift.Value(lot.slaughterhouseId),
      slaughterDate: drift.Value(lot.slaughterDate),
      // Notes
      notes: drift.Value(lot.notes),
      // Sync fields
      synced: drift.Value(lot.synced),
      createdAt: drift.Value(lot.createdAt),
      updatedAt: drift.Value(lot.updatedAt),
      lastSyncedAt: drift.Value(lot.lastSyncedAt),
      serverVersion: drift.Value(lot.serverVersion),
    );
  }
}
