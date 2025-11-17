// lib/repositories/lot_repository.dart
import 'dart:convert';
import '../models/lot.dart';
import '../drift/database.dart';
import '../drift/daos/lot_dao.dart';
import 'package:drift/drift.dart' as drift;

/// Repository pour gérer la persistance des lots
/// Phase 1C: Avec security checks farmId + Phase 1B: LotStatus support
class LotRepository {
  final LotDao _dao;

  LotRepository(AppDatabase database) : _dao = database.lotDao;

  // ==================== CRUD Operations ====================

  /// Récupérer tous les lots d'une ferme
  Future<List<Lot>> findAllByFarm(String farmId) async {
    final data = await _dao.findAllByFarm(farmId);
    return data.map(_toLot).toList();
  }

  /// Récupérer un lot par son ID (avec vérification farmId)
  Future<Lot?> findById(String id, String farmId) async {
    final data = await _dao.findById(id, farmId);
    if (data == null) return null;

    // Security check
    if (data.farmId != farmId) {
      throw Exception('Farm ID mismatch - Security violation');
    }

    return _toLot(data);
  }

  /// Récupérer les lots ouverts (non complétés) d'une ferme
  Future<List<Lot>> findOpenByFarm(String farmId) async {
    final data = await _dao.findOpenByFarm(farmId);
    return data.map(_toLot).toList();
  }

  /// Récupérer les lots fermés d'une ferme
  Future<List<Lot>> findClosedByFarm(String farmId) async {
    final data = await _dao.findClosedByFarm(farmId);
    return data.map(_toLot).toList();
  }

  /// PHASE 1: ADD - Récupérer les lots archivés d'une ferme
  Future<List<Lot>> findArchivedByFarm(String farmId) async {
    final data = await _dao.findArchivedByFarm(farmId);
    return data.map(_toLot).toList();
  }

  /// Récupérer les lots complétés d'une ferme (closed + archived)
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

  /// Créer un nouveau lot avec validation farmId
  Future<Lot> create(Lot lot, String farmId) async {
    // Security check: vérifier que le lot appartient à cette ferme
    if (lot.farmId != farmId) {
      throw Exception('Farm ID mismatch - Security violation');
    }

    final companion = _toCompanion(lot, isUpdate: false);
    await _dao.insertLot(companion);
    return lot;
  }

  /// Mettre à jour un lot avec security check
  Future<Lot> update(Lot lot, String farmId) async {
    // Security check: vérifier l'ownership
    final existing = await _dao.findById(lot.id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Lot not found or farm mismatch - Security violation');
    }

    // Double-check: le lot à updater doit aussi matcher
    if (lot.farmId != farmId) {
      throw Exception('Farm ID mismatch - Security violation');
    }

    final companion = _toCompanion(lot, isUpdate: true);
    await _dao.updateLot(companion, farmId);
    return lot;
  }

  /// Supprimer un lot avec security check
  Future<void> delete(String id, String farmId) async {
    // Security check: vérifier l'ownership
    final existing = await _dao.findById(id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Lot not found or farm mismatch - Security violation');
    }

    await _dao.deleteLot(id);
  }

  // ==================== Business Logic ====================

  /// Marquer un lot comme complété avec security check
  Future<void> markAsCompleted(String id, String farmId) async {
    // Security check
    final existing = await _dao.findById(id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Lot not found or farm mismatch - Security violation');
    }

    await _dao.markAsCompleted(id, farmId);
  }

  /// PHASE 1: ADD - Marquer un lot comme fermé
  Future<void> markAsClosed(String id, String farmId) async {
    // Security check
    final existing = await _dao.findById(id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Lot not found or farm mismatch - Security violation');
    }

    await _dao.markAsClosed(id, farmId);
  }

  /// PHASE 1: ADD - Archiver un lot
  Future<void> archiveLot(String id, String farmId) async {
    // Security check
    final existing = await _dao.findById(id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Lot not found or farm mismatch - Security violation');
    }

    await _dao.markAsArchived(id, farmId);
  }

  /// Ajouter un animal au lot avec security check
  Future<void> addAnimalToLot(
      String lotId, String animalId, String farmId) async {
    // Security check
    final existing = await _dao.findById(lotId, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Lot not found or farm mismatch - Security violation');
    }

    await _dao.addAnimalToLot(lotId, animalId, farmId);
  }

  /// Retirer un animal du lot avec security check
  Future<void> removeAnimalFromLot(
      String lotId, String animalId, String farmId) async {
    // Security check
    final existing = await _dao.findById(lotId, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Lot not found or farm mismatch - Security violation');
    }

    await _dao.removeAnimalFromLot(lotId, animalId, farmId);
  }

  /// Définir le type du lot avec security check
  Future<void> setLotType(String id, LotType type, String farmId) async {
    // Security check
    final existing = await _dao.findById(id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Lot not found or farm mismatch - Security violation');
    }

    await _dao.setLotType(id, type.name, farmId);
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

  /// Insérer plusieurs lots (pour migration) avec validation farmId
  Future<void> insertAll(List<Lot> lots, String farmId) async {
    for (final lot in lots) {
      // Vérifier que tous les lots appartiennent à cette ferme
      if (lot.farmId != farmId) {
        throw Exception(
            'Farm ID mismatch in lot ${lot.id} - Security violation');
      }
      await create(lot, farmId);
    }
  }

  /// Supprimer tous les lots d'une ferme
  Future<void> deleteAllByFarm(String farmId) async {
    final lots = await findAllByFarm(farmId);
    for (final lot in lots) {
      await delete(lot.id, farmId);
    }
  }

  // PHASE 2: ADD - Migration helper (run once to populate status from completed)
  Future<int> migrateStatusFromCompleted() async {
    return await _dao.migrateStatusFromCompleted();
  }

  // ==================== Conversion Methods ====================

  /// PHASE 1: MODIFY - Convertir LotsTableData en Lot avec status fallback
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

    // PHASE 1: Décoder status avec fallback à completed
    LotStatus? status;
    if (data.status != null) {
      try {
        status = LotStatus.values.byName(data.status!);
      } catch (e) {
        // Fallback: déduire depuis completed
        status = data.completed ? LotStatus.closed : LotStatus.open;
      }
    } else {
      // Pas de status? Fallback à completed boolean
      status = data.completed ? LotStatus.closed : LotStatus.open;
    }

    return Lot(
      id: data.id,
      farmId: data.farmId,
      name: data.name,
      type: type,
      animalIds: animalIds,
      status: status,
      completed: data.completed,
      completedAt: data.completedAt,
      // Treatment fields
      productId: data.productId,
      productName: data.productName,
      treatmentDate: data.treatmentDate,
      withdrawalEndDate: data.withdrawalEndDate,
      veterinarianId: data.veterinarianId,
      veterinarianName: data.veterinarianName,
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

  /// PHASE 1: MODIFY - Convertir Lot en LotsTableCompanion avec status
  LotsTableCompanion _toCompanion(Lot lot, {required bool isUpdate}) {
    // Encoder animal_ids en JSON
    final animalIdsJson = jsonEncode(lot.animalIds);

    return LotsTableCompanion(
      id: drift.Value(lot.id),
      farmId: drift.Value(lot.farmId),
      name: drift.Value(lot.name),
      type: drift.Value(lot.type?.name),
      animalIdsJson: drift.Value(animalIdsJson),
      // PHASE 1: ADD - Encoder status
      status: lot.status != null
          ? drift.Value(lot.status!.name)
          : const drift.Value(null),
      completed: drift.Value(lot.completed),
      completedAt: drift.Value(lot.completedAt),
      // Treatment fields
      productId: drift.Value(lot.productId),
      productName: drift.Value(lot.productName),
      treatmentDate: drift.Value(lot.treatmentDate),
      withdrawalEndDate: drift.Value(lot.withdrawalEndDate),
      veterinarianId: drift.Value(lot.veterinarianId),
      veterinarianName: drift.Value(lot.veterinarianName),
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
