// lib/repositories/vaccine_reference_repository.dart

import 'dart:convert';
import 'package:drift/drift.dart';
import '../drift/database.dart';
import '../models/vaccine_reference.dart';
//import '../drift/daos/vaccine_dao.dart';

/// Repository pour la gestion des références de vaccins
/// 
/// Couche business logic entre les providers et la base de données.
/// Responsabilités:
/// - Mapping Model ↔ Drift Companion
/// - Validation business
/// - Security checks (farmId)
/// - Conversion JSON pour listes
class VaccineReferenceRepository {
  final AppDatabase _db;

  VaccineReferenceRepository(this._db);

  // === CRUD OPERATIONS ===

  /// Récupère tous les vaccins d'une ferme
  Future<List<VaccineReference>> getAll(String farmId) async {
    final items = await _db.vaccineDao.findByFarmId(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère un vaccin par ID avec security check
  Future<VaccineReference?> getById(String id, String farmId) async {
    final item = await _db.vaccineDao.findById(id, farmId);
    if (item == null) return null;

    // Security check
    if (item.farmId != farmId) {
      throw Exception('Farm ID mismatch - Security violation');
    }

    return _mapToModel(item);
  }

  /// Crée un nouveau vaccin
  Future<void> create(VaccineReference vaccine, String farmId) async {
    final companion = _mapToCompanion(vaccine, farmId);
    await _db.vaccineDao.insertItem(companion);
  }

  /// Met à jour un vaccin existant
  Future<void> update(VaccineReference vaccine, String farmId) async {
    // Security check
    final existing = await _db.vaccineDao.findById(vaccine.id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Vaccine not found or farm mismatch');
    }

    final companion = _mapToCompanion(vaccine, farmId);
    await _db.vaccineDao.updateItem(companion);
  }

  /// Supprime un vaccin (soft-delete)
  Future<void> delete(String id, String farmId) async {
    await _db.vaccineDao.softDelete(id, farmId);
  }

  // === BUSINESS QUERIES ===

  /// Récupère les vaccins actifs
  Future<List<VaccineReference>> getActive(String farmId) async {
    final items = await _db.vaccineDao.findActiveByFarmId(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Recherche de vaccins par nom
  Future<List<VaccineReference>> searchByName(
    String farmId,
    String query,
  ) async {
    final items = await _db.vaccineDao.searchByName(farmId, query);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les vaccins compatibles avec une espèce
  Future<List<VaccineReference>> getCompatibleWithSpecies(
    String farmId,
    String species,
  ) async {
    final allActive = await getActive(farmId);
    
    // Filtrage côté Dart car SQLite ne supporte pas JSON_CONTAINS
    return allActive.where((vaccine) {
      if (vaccine.targetSpecies.isEmpty) return true; // Compatible avec tout
      return vaccine.targetSpecies.any(
        (s) => s.toLowerCase() == species.toLowerCase(),
      );
    }).toList();
  }

  // === SYNC OPERATIONS (Phase 2 ready) ===

  /// Récupère les vaccins non synchronisés
  Future<List<VaccineReference>> getUnsynced(String farmId) async {
    final items = await _db.vaccineDao.getUnsynced(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Marque un vaccin comme synchronisé
  Future<void> markAsSynced(
    String id,
    String farmId,
    int serverVersion,
  ) async {
    await _db.vaccineDao.markSynced(id, farmId, serverVersion);
  }

  // === MAPPERS ===

  /// Convertit VaccinesTableData → VaccineReference (Model)
  VaccineReference _mapToModel(VaccinesTableData data) {
    return VaccineReference(
      id: data.id,
      farmId: data.farmId,
      name: data.name,
      description: data.description,
      manufacturer: data.manufacturer,
      targetSpecies: _parseJsonArray(data.targetSpecies),
      targetDiseases: _parseJsonArray(data.targetDiseases),
      standardDose: data.standardDose,
      injectionsRequired: data.injectionsRequired,
      injectionIntervalDays: data.injectionIntervalDays,
      meatWithdrawalDays: data.meatWithdrawalDays,
      milkWithdrawalDays: data.milkWithdrawalDays,
      administrationRoute: data.administrationRoute,
      notes: data.notes,
      isActive: data.isActive,
      synced: data.synced,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      lastSyncedAt: data.lastSyncedAt,
      serverVersion: data.serverVersion?.toString(),
    );
  }

  /// Convertit VaccineReference (Model) → VaccinesTableCompanion (Drift)
  VaccinesTableCompanion _mapToCompanion(
    VaccineReference vaccine,
    String farmId,
  ) {
    return VaccinesTableCompanion(
      id: Value(vaccine.id),
      farmId: Value(farmId),
      name: Value(vaccine.name),
      description: vaccine.description != null
          ? Value(vaccine.description!)
          : const Value.absent(),
      manufacturer: vaccine.manufacturer != null
          ? Value(vaccine.manufacturer!)
          : const Value.absent(),
      targetSpecies: Value(_encodeJsonArray(vaccine.targetSpecies)),
      targetDiseases: Value(_encodeJsonArray(vaccine.targetDiseases)),
      standardDose: vaccine.standardDose != null
          ? Value(vaccine.standardDose!)
          : const Value.absent(),
      injectionsRequired: vaccine.injectionsRequired != null
          ? Value(vaccine.injectionsRequired!)
          : const Value.absent(),
      injectionIntervalDays: vaccine.injectionIntervalDays != null
          ? Value(vaccine.injectionIntervalDays!)
          : const Value.absent(),
      meatWithdrawalDays: Value(vaccine.meatWithdrawalDays),
      milkWithdrawalDays: Value(vaccine.milkWithdrawalDays),
      administrationRoute: vaccine.administrationRoute != null
          ? Value(vaccine.administrationRoute!)
          : const Value.absent(),
      notes: vaccine.notes != null
          ? Value(vaccine.notes!)
          : const Value.absent(),
      isActive: Value(vaccine.isActive),
      synced: Value(vaccine.synced),
      lastSyncedAt: vaccine.lastSyncedAt != null
          ? Value(vaccine.lastSyncedAt!)
          : const Value.absent(),
      serverVersion: vaccine.serverVersion != null
          ? Value(int.tryParse(vaccine.serverVersion!) ?? 0)
          : const Value.absent(),
      deletedAt: const Value.absent(), // Jamais set manuellement
      createdAt: Value(vaccine.createdAt),
      updatedAt: Value(vaccine.updatedAt),
    );
  }

  // === JSON HELPERS ===

  /// Parse une string JSON en List String
  List<String> _parseJsonArray(String jsonString) {
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is List) {
        return decoded.cast<String>();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Encode une List String en JSON string
  String _encodeJsonArray(List<String> list) {
    return jsonEncode(list);
  }
}
