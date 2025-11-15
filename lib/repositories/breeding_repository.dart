// lib/repositories/breeding_repository.dart

import 'package:drift/drift.dart';
import '../drift/database.dart';
import '../models/breeding.dart';

/// Repository pour la gestion des reproductions
class BreedingRepository {
  final AppDatabase _db;

  BreedingRepository(this._db);

  // === CRUD OPERATIONS ===

  /// Récupère toutes les reproductions d'une ferme
  Future<List<Breeding>> getAll(String farmId) async {
    final items = await _db.breedingDao.findByFarmId(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère une reproduction par ID avec security check
  Future<Breeding?> getById(String id, String farmId) async {
    final item = await _db.breedingDao.findById(id, farmId);
    if (item == null) return null;

    // Security check
    if (item.farmId != farmId) {
      throw Exception('Farm ID mismatch - Security violation');
    }

    return _mapToModel(item);
  }

  /// Crée une nouvelle reproduction
  Future<void> create(Breeding breeding, String farmId) async {
    final companion = _mapToCompanion(breeding, farmId);
    await _db.breedingDao.insertItem(companion);
  }

  /// Met à jour une reproduction existante
  Future<void> update(Breeding breeding, String farmId) async {
    // Security check
    final existing = await _db.breedingDao.findById(breeding.id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Breeding not found or farm mismatch');
    }

    final companion = _mapToCompanion(breeding, farmId);
    await _db.breedingDao.updateItem(companion);
  }

  /// Supprime une reproduction (soft-delete)
  Future<void> delete(String id, String farmId) async {
    await _db.breedingDao.softDelete(id, farmId);
  }

  // === BUSINESS QUERIES ===

  /// Récupère les reproductions d'une mère
  Future<List<Breeding>> getByMother(String farmId, String motherId) async {
    final items = await _db.breedingDao.findByMother(motherId, farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les reproductions d'un père
  Future<List<Breeding>> getByFather(String farmId, String fatherId) async {
    final items = await _db.breedingDao.findByFather(fatherId, farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les reproductions par statut
  Future<List<Breeding>> getByStatus(
      String farmId, BreedingStatus status) async {
    final items = await _db.breedingDao.findByStatus(status.name, farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les reproductions par méthode
  Future<List<Breeding>> getByMethod(
      String farmId, BreedingMethod method) async {
    final items = await _db.breedingDao.findByMethod(method.name, farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les reproductions en attente
  Future<List<Breeding>> getPending(String farmId) async {
    final items = await _db.breedingDao.findPending(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les reproductions en retard
  Future<List<Breeding>> getOverdue(String farmId) async {
    final items = await _db.breedingDao.findOverdue(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les reproductions dont la mise-bas est proche
  Future<List<Breeding>> getBirthSoon(String farmId) async {
    final items = await _db.breedingDao.findBirthSoon(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les reproductions dans une période
  Future<List<Breeding>> getByDateRange(
    String farmId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final items =
        await _db.breedingDao.findByDateRange(farmId, startDate, endDate);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les reproductions par vétérinaire
  Future<List<Breeding>> getByVeterinarian(
      String farmId, String veterinarianId) async {
    final items =
        await _db.breedingDao.findByVeterinarian(veterinarianId, farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  // === STATISTICS ===

  /// Compte les reproductions par statut
  Future<Map<BreedingStatus, int>> getCountsByStatus(String farmId) async {
    final items = await getAll(farmId);
    final counts = <BreedingStatus, int>{};
    for (final breeding in items) {
      counts[breeding.status] = (counts[breeding.status] ?? 0) + 1;
    }
    return counts;
  }

  /// Calcule le taux de succès
  Future<double> getSuccessRate(String farmId) async {
    final items = await getAll(farmId);
    if (items.isEmpty) return 0.0;
    final completed = items.where((b) => b.isCompleted).length;
    return (completed / items.length) * 100;
  }

  // === SYNC OPERATIONS ===

  /// Récupère les reproductions non synchronisées
  Future<List<Breeding>> getUnsynced(String farmId) async {
    final items = await _db.breedingDao.getUnsynced(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Marque une reproduction comme synchronisée
  Future<void> markAsSynced(
    String id,
    String farmId,
    String serverVersion,
  ) async {
    await _db.breedingDao.markSynced(id, farmId, serverVersion);
  }

  // === MAPPERS ===

  /// Convertit BreedingsTableData → Breeding (Model)
  Breeding _mapToModel(BreedingsTableData data) {
    return Breeding(
      id: data.id,
      farmId: data.farmId,
      motherId: data.motherId,
      fatherId: data.fatherId,
      fatherName: data.fatherName,
      method: _parseBreedingMethod(data.method),
      breedingDate: data.breedingDate,
      expectedBirthDate: data.expectedBirthDate,
      actualBirthDate: data.actualBirthDate,
      expectedOffspringCount: data.expectedOffspringCount,
      offspringIds: _parseOffspringIds(data.offspringIds),
      veterinarianId: data.veterinarianId,
      veterinarianName: data.veterinarianName,
      notes: data.notes,
      status: _parseBreedingStatus(data.status),
      synced: data.synced,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      lastSyncedAt: data.lastSyncedAt,
      serverVersion: data.serverVersion,
    );
  }

  /// Convertit Breeding (Model) → BreedingsTableCompanion (Drift)
  BreedingsTableCompanion _mapToCompanion(
    Breeding breeding,
    String farmId,
  ) {
    return BreedingsTableCompanion(
      id: Value(breeding.id),
      farmId: Value(farmId),
      motherId: Value(breeding.motherId),
      fatherId: breeding.fatherId != null
          ? Value(breeding.fatherId!)
          : const Value.absent(),
      fatherName: breeding.fatherName != null
          ? Value(breeding.fatherName!)
          : const Value.absent(),
      method: Value(breeding.method.name),
      breedingDate: Value(breeding.breedingDate),
      expectedBirthDate: Value(breeding.expectedBirthDate),
      actualBirthDate: breeding.actualBirthDate != null
          ? Value(breeding.actualBirthDate!)
          : const Value.absent(),
      expectedOffspringCount: breeding.expectedOffspringCount != null
          ? Value(breeding.expectedOffspringCount!)
          : const Value.absent(),
      offspringIds: Value(_encodeOffspringIds(breeding.offspringIds)),
      veterinarianId: breeding.veterinarianId != null
          ? Value(breeding.veterinarianId!)
          : const Value.absent(),
      veterinarianName: breeding.veterinarianName != null
          ? Value(breeding.veterinarianName!)
          : const Value.absent(),
      notes: breeding.notes != null
          ? Value(breeding.notes!)
          : const Value.absent(),
      status: Value(breeding.status.name),
      synced: Value(breeding.synced),
      lastSyncedAt: breeding.lastSyncedAt != null
          ? Value(breeding.lastSyncedAt!)
          : const Value.absent(),
      serverVersion: breeding.serverVersion != null
          ? Value(breeding.serverVersion!)
          : const Value.absent(),
      deletedAt: const Value.absent(),
      createdAt: Value(breeding.createdAt),
      updatedAt: Value(breeding.updatedAt),
    );
  }

  // === ENUM HELPERS ===

  /// Parse une string en BreedingMethod enum
  BreedingMethod _parseBreedingMethod(String method) {
    return BreedingMethod.values.firstWhere(
      (e) => e.name == method,
      orElse: () => BreedingMethod.natural,
    );
  }

  /// Parse une string en BreedingStatus enum
  BreedingStatus _parseBreedingStatus(String status) {
    return BreedingStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => BreedingStatus.pending,
    );
  }

  /// Parse JSON string en List String
  List<String> _parseOffspringIds(String? json) {
    if (json == null || json.isEmpty) return [];
    try {
      // Simple parsing: "id1,id2,id3" format
      return json.split(',').where((id) => id.isNotEmpty).toList();
    } catch (e) {
      return [];
    }
  }

  /// Encode List String en JSON string
  String? _encodeOffspringIds(List<String> ids) {
    if (ids.isEmpty) return null;
    return ids.join(',');
  }
}
