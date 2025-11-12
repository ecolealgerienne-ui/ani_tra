// lib/repositories/weight_repository.dart

import 'package:drift/drift.dart';
import '../drift/database.dart';
//import '../drift/tables/weights_table.dart';
import '../models/weight_record.dart';

/// Repository pour la gestion des pesées
///
/// Couche business logic entre les providers et la base de données.
/// Responsabilités:
/// - Mapping Model ↔ Drift Companion
/// - Validation business
/// - Security checks (farmId)
/// - Conversion WeightSource enum
/// - Statistiques de croissance
class WeightRepository {
  final AppDatabase _db;

  WeightRepository(this._db);

  // === CRUD OPERATIONS ===

  /// Récupère toutes les pesées d'une ferme
  Future<List<WeightRecord>> getAll(String farmId) async {
    final items = await _db.weightDao.findByFarmId(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère une pesée par ID avec security check
  Future<WeightRecord?> getById(String id, String farmId) async {
    final item = await _db.weightDao.findById(id, farmId);
    if (item == null) return null;

    // Security check
    if (item.farmId != farmId) {
      throw Exception('Farm ID mismatch - Security violation');
    }

    return _mapToModel(item);
  }

  /// Crée une nouvelle pesée
  Future<void> create(WeightRecord weight, String farmId) async {
    final companion = _mapToCompanion(weight, farmId);
    await _db.weightDao.insertItem(companion);
  }

  /// Met à jour une pesée existante
  Future<void> update(WeightRecord weight, String farmId) async {
    // Security check
    final existing = await _db.weightDao.findById(weight.id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Weight record not found or farm mismatch');
    }

    final companion = _mapToCompanion(weight, farmId);
    await _db.weightDao.updateItem(companion, farmId);
  }

  /// Supprime une pesée (soft-delete)
  Future<void> delete(String id, String farmId) async {
    await _db.weightDao.softDelete(id, farmId);
  }

  // === BUSINESS QUERIES ===

  /// Récupère les pesées d'un animal
  Future<List<WeightRecord>> getByAnimalId(
    String farmId,
    String animalId,
  ) async {
    final items = await _db.weightDao.findByAnimalId(farmId, animalId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère la dernière pesée d'un animal
  Future<WeightRecord?> getLatestByAnimalId(
    String farmId,
    String animalId,
  ) async {
    final item = await _db.weightDao.findLatestByAnimalId(farmId, animalId);
    if (item == null) return null;
    return _mapToModel(item);
  }

  /// Récupère les pesées dans une période
  Future<List<WeightRecord>> getByDateRange(
    String farmId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final items =
        await _db.weightDao.findByDateRange(farmId, startDate, endDate);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les pesées d'un animal dans une période
  Future<List<WeightRecord>> getByAnimalIdAndDateRange(
    String farmId,
    String animalId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final items = await _db.weightDao
        .findByAnimalIdAndDateRange(farmId, animalId, startDate, endDate);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les pesées par source
  Future<List<WeightRecord>> getBySource(
    String farmId,
    WeightSource source,
  ) async {
    final items = await _db.weightDao.findBySource(farmId, source.name);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les pesées récentes (derniers X jours)
  Future<List<WeightRecord>> getRecent(String farmId, int days) async {
    final items = await _db.weightDao.findRecent(farmId, days);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Compte les pesées d'un animal
  Future<int> countByAnimalId(String farmId, String animalId) async {
    return await _db.weightDao.countByAnimalId(farmId, animalId);
  }

  // === STATISTICS ===

  /// Calcule le poids moyen d'un animal
  Future<double?> getAverageWeight(String farmId, String animalId) async {
    return await _db.weightDao.getAverageWeightByAnimalId(farmId, animalId);
  }

  /// Récupère le poids minimum d'un animal
  Future<double?> getMinWeight(String farmId, String animalId) async {
    return await _db.weightDao.getMinWeightByAnimalId(farmId, animalId);
  }

  /// Récupère le poids maximum d'un animal
  Future<double?> getMaxWeight(String farmId, String animalId) async {
    return await _db.weightDao.getMaxWeightByAnimalId(farmId, animalId);
  }

  /// Calcule le GMQ (Gain Moyen Quotidien) d'un animal
  ///
  /// GMQ = (poids final - poids initial) / nombre de jours
  Future<double?> calculateAverageDailyGain(
    String farmId,
    String animalId,
  ) async {
    final weights = await getByAnimalId(farmId, animalId);

    if (weights.length < 2) return null;

    // Tri par date (plus anciennes d'abord)
    weights.sort((a, b) => a.recordedAt.compareTo(b.recordedAt));

    final firstWeight = weights.first;
    final lastWeight = weights.last;

    final weightDiff = lastWeight.weight - firstWeight.weight;
    final daysDiff =
        lastWeight.recordedAt.difference(firstWeight.recordedAt).inDays;

    if (daysDiff == 0) return null;

    return weightDiff / daysDiff;
  }

  // === SYNC OPERATIONS (Phase 2 ready) ===

  /// Récupère les pesées non synchronisées
  Future<List<WeightRecord>> getUnsynced(String farmId) async {
    final items = await _db.weightDao.getUnsynced(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Marque une pesée comme synchronisée
  Future<void> markAsSynced(
    String id,
    String farmId,
    int serverVersion,
  ) async {
    await _db.weightDao.markSynced(id, farmId, serverVersion);
  }

  // === MAPPERS ===

  /// Convertit WeightsTableData → WeightRecord (Model)
  WeightRecord _mapToModel(WeightsTableData data) {
    return WeightRecord(
      id: data.id,
      farmId: data.farmId,
      animalId: data.animalId,
      weight: data.weight,
      recordedAt: data.recordedAt,
      source: _parseWeightSource(data.source),
      notes: data.notes,
      synced: data.synced,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      lastSyncedAt: data.lastSyncedAt,
      serverVersion: data.serverVersion?.toString(),
    );
  }

  /// Convertit WeightRecord (Model) → WeightsTableCompanion (Drift)
  WeightsTableCompanion _mapToCompanion(
    WeightRecord weight,
    String farmId,
  ) {
    return WeightsTableCompanion(
      id: Value(weight.id),
      farmId: Value(farmId),
      animalId: Value(weight.animalId),
      weight: Value(weight.weight),
      recordedAt: Value(weight.recordedAt),
      source: Value(weight.source.name),
      notes: weight.notes != null ? Value(weight.notes!) : const Value.absent(),
      synced: Value(weight.synced),
      lastSyncedAt: weight.lastSyncedAt != null
          ? Value(weight.lastSyncedAt!)
          : const Value.absent(),
      serverVersion: weight.serverVersion != null
          ? Value(int.tryParse(weight.serverVersion!) ?? 0)
          : const Value.absent(),
      deletedAt: const Value.absent(), // Jamais set manuellement
      createdAt: Value(weight.createdAt),
      updatedAt: Value(weight.updatedAt),
    );
  }

  // === ENUM HELPERS ===

  /// Parse une string en WeightSource enum
  WeightSource _parseWeightSource(String source) {
    return WeightSource.values.firstWhere(
      (e) => e.name == source,
      orElse: () => WeightSource.manual,
    );
  }
}
