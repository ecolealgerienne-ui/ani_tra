// lib/repositories/treatment_repository.dart

import 'package:drift/drift.dart';
import '../drift/database.dart';
import '../models/treatment.dart';

/// Repository pour la gestion des traitements
///
/// Couche business logic entre les providers et la base de données.
/// Responsabilités:
/// - Mapping Model ↔ Drift Companion
/// - Validation business
/// - Security checks (farmId)
/// - Gestion des délais d'attente
class TreatmentRepository {
  final AppDatabase _db;

  TreatmentRepository(this._db);

  // === CRUD OPERATIONS ===

  /// Récupère tous les traitements d'une ferme
  Future<List<Treatment>> getAll(String farmId) async {
    final items = await _db.treatmentDao.findByFarmId(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère un traitement par ID avec security check
  Future<Treatment?> getById(String id, String farmId) async {
    final item = await _db.treatmentDao.findById(id, farmId);
    if (item == null) return null;

    // Security check
    if (item.farmId != farmId) {
      throw Exception('Farm ID mismatch - Security violation');
    }

    return _mapToModel(item);
  }

  /// Crée un nouveau traitement
  Future<void> create(Treatment treatment, String farmId) async {
    final companion = _mapToCompanion(treatment, farmId);
    await _db.treatmentDao.insertItem(companion);
  }

  /// Met à jour un traitement existant
  Future<void> update(Treatment treatment, String farmId) async {
    // Security check
    final existing = await _db.treatmentDao.findById(treatment.id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Treatment not found or farm mismatch');
    }

    final companion = _mapToCompanion(treatment, farmId);
    await _db.treatmentDao.updateItem(companion);
  }

  /// Supprime un traitement (soft-delete)
  Future<void> delete(String id, String farmId) async {
    await _db.treatmentDao.softDelete(id, farmId);
  }

  // === BUSINESS QUERIES ===

  /// Récupère les traitements d'un animal
  Future<List<Treatment>> getByAnimalId(String farmId, String animalId) async {
    final items = await _db.treatmentDao.findByAnimalId(farmId, animalId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les traitements d'une campagne
  Future<List<Treatment>> getByCampaignId(
    String farmId,
    String campaignId,
  ) async {
    final items = await _db.treatmentDao.findByCampaignId(farmId, campaignId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les traitements d'un produit
  Future<List<Treatment>> getByProductId(
    String farmId,
    String productId,
  ) async {
    final items = await _db.treatmentDao.findByProductId(farmId, productId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les traitements dans une période
  Future<List<Treatment>> getByDateRange(
    String farmId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final items =
        await _db.treatmentDao.findByDateRange(farmId, startDate, endDate);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les traitements avec délai d'attente actif
  Future<List<Treatment>> getActiveWithdrawalPeriods(String farmId) async {
    final items = await _db.treatmentDao.findActiveWithdrawalPeriods(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les traitements avec délai d'attente actif pour un animal
  Future<List<Treatment>> getActiveWithdrawalPeriodsByAnimalId(
    String farmId,
    String animalId,
  ) async {
    final items = await _db.treatmentDao
        .findActiveWithdrawalPeriodsByAnimalId(farmId, animalId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Compte les traitements par animal
  Future<int> countByAnimalId(String farmId, String animalId) async {
    return await _db.treatmentDao.countByAnimalId(farmId, animalId);
  }

  // === SYNC OPERATIONS (Phase 2 ready) ===

  /// Récupère les traitements non synchronisés
  Future<List<Treatment>> getUnsynced(String farmId) async {
    final items = await _db.treatmentDao.getUnsynced(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Marque un traitement comme synchronisé
  Future<void> markAsSynced(
    String id,
    String farmId,
    int serverVersion,
  ) async {
    await _db.treatmentDao.markSynced(id, farmId, serverVersion);
  }

  // === MAPPERS ===

  /// Convertit TreatmentsTableData → Treatment (Model)
  Treatment _mapToModel(TreatmentsTableData data) {
    return Treatment(
      id: data.id,
      farmId: data.farmId,
      animalId: data.animalId,
      productId: data.productId,
      productName: data.productName,
      dose: data.dose,
      treatmentDate: data.treatmentDate,
      withdrawalEndDate: data.withdrawalEndDate,
      notes: data.notes,
      veterinarianId: data.veterinarianId,
      veterinarianName: data.veterinarianName,
      campaignId: data.campaignId,
      synced: data.synced,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      lastSyncedAt: data.lastSyncedAt,
      serverVersion: data.serverVersion?.toString(),
    );
  }

  /// Convertit Treatment (Model) → TreatmentsTableCompanion (Drift)
  TreatmentsTableCompanion _mapToCompanion(
    Treatment treatment,
    String farmId,
  ) {
    return TreatmentsTableCompanion(
      id: Value(treatment.id),
      farmId: Value(farmId),
      animalId: Value(treatment.animalId),
      productId: Value(treatment.productId),
      productName: Value(treatment.productName),
      dose: Value(treatment.dose),
      treatmentDate: Value(treatment.treatmentDate),
      withdrawalEndDate: Value(treatment.withdrawalEndDate),
      notes: treatment.notes != null
          ? Value(treatment.notes!)
          : const Value.absent(),
      veterinarianId: treatment.veterinarianId != null
          ? Value(treatment.veterinarianId!)
          : const Value.absent(),
      veterinarianName: treatment.veterinarianName != null
          ? Value(treatment.veterinarianName!)
          : const Value.absent(),
      campaignId: treatment.campaignId != null
          ? Value(treatment.campaignId!)
          : const Value.absent(),
      synced: Value(treatment.synced),
      lastSyncedAt: treatment.lastSyncedAt != null
          ? Value(treatment.lastSyncedAt!)
          : const Value.absent(),
      serverVersion: treatment.serverVersion != null
          ? Value(int.tryParse(treatment.serverVersion!) ?? 0)
          : const Value.absent(),
      deletedAt: const Value.absent(), // Jamais set manuellement
      createdAt: Value(treatment.createdAt),
      updatedAt: Value(treatment.updatedAt),
    );
  }
}
