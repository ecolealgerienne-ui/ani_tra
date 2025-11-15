// lib/repositories/vaccination_repository.dart

import 'dart:convert';
import 'package:drift/drift.dart';
import '../drift/database.dart';
import '../models/vaccination.dart';

/// Repository pour la gestion des vaccinations
///
/// Couche business logic entre les providers et la base de données.
/// Responsabilités:
/// - Mapping Model ↔ Drift Companion
/// - Validation business
/// - Security checks (farmId)
/// - Conversion VaccinationType enum
/// - Conversion JSON pour animalIds (vaccination de groupe)
class VaccinationRepository {
  final AppDatabase _db;

  VaccinationRepository(this._db);

  // === CRUD OPERATIONS ===

  /// Récupère toutes les vaccinations d'une ferme
  Future<List<Vaccination>> getAll(String farmId) async {
    final items = await _db.vaccinationDao.findByFarmId(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère une vaccination par ID avec security check
  Future<Vaccination?> getById(String id, String farmId) async {
    final item = await _db.vaccinationDao.findById(id, farmId);
    if (item == null) return null;

    // Security check
    if (item.farmId != farmId) {
      throw Exception('Farm ID mismatch - Security violation');
    }

    return _mapToModel(item);
  }

  /// Crée une nouvelle vaccination
  Future<void> create(Vaccination vaccination, String farmId) async {
    final companion = _mapToCompanion(vaccination, farmId);
    await _db.vaccinationDao.insertItem(companion);
  }

  /// Met à jour une vaccination existante
  Future<void> update(Vaccination vaccination, String farmId) async {
    // Security check
    final existing = await _db.vaccinationDao.findById(vaccination.id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Vaccination not found or farm mismatch');
    }

    final companion = _mapToCompanion(vaccination, farmId);
    await _db.vaccinationDao.updateItem(companion);
  }

  /// Supprime une vaccination (soft-delete)
  Future<void> delete(String id, String farmId) async {
    await _db.vaccinationDao.softDelete(id, farmId);
  }

  // === BUSINESS QUERIES ===

  /// Récupère les vaccinations d'un animal
  ///
  /// Filtre côté Dart car SQLite ne supporte pas JSON_CONTAINS
  Future<List<Vaccination>> getByAnimalId(
    String farmId,
    String animalId,
  ) async {
    final allVaccinations = await getAll(farmId);

    // Filtrer les vaccinations où l'animal est concerné
    return allVaccinations.where((vaccination) {
      // Vaccination individuelle
      if (vaccination.animalId == animalId) return true;

      // Vaccination de groupe
      if (vaccination.animalIds.contains(animalId)) return true;

      return false;
    }).toList();
  }

  /// Récupère les vaccinations par type
  Future<List<Vaccination>> getByType(
    String farmId,
    VaccinationType type,
  ) async {
    final items = await _db.vaccinationDao.findByType(farmId, type.name);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les vaccinations par maladie
  Future<List<Vaccination>> getByDisease(
    String farmId,
    String disease,
  ) async {
    final items = await _db.vaccinationDao.findByDisease(farmId, disease);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les vaccinations dans une période
  Future<List<Vaccination>> getByDateRange(
    String farmId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final items =
        await _db.vaccinationDao.findByDateRange(farmId, startDate, endDate);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les vaccinations avec rappel à venir
  Future<List<Vaccination>> getUpcomingReminders(String farmId) async {
    final items = await _db.vaccinationDao.findUpcomingReminders(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les vaccinations dont le rappel est en retard
  Future<List<Vaccination>> getOverdueReminders(String farmId) async {
    final items = await _db.vaccinationDao.findOverdueReminders(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Compte les vaccinations par animal
  Future<int> countByAnimalId(String farmId, String animalId) async {
    return await _db.vaccinationDao.countByAnimalId(farmId, animalId);
  }

  // === SYNC OPERATIONS (Phase 2 ready) ===

  /// Récupère les vaccinations non synchronisées
  Future<List<Vaccination>> getUnsynced(String farmId) async {
    final items = await _db.vaccinationDao.getUnsynced(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Marque une vaccination comme synchronisée
  Future<void> markAsSynced(
    String id,
    String farmId,
    int serverVersion,
  ) async {
    await _db.vaccinationDao.markSynced(id, farmId, serverVersion);
  }

  // === MAPPERS ===

  /// Convertit VaccinationsTableData → Vaccination (Model)
  Vaccination _mapToModel(VaccinationsTableData data) {
    return Vaccination(
      id: data.id,
      farmId: data.farmId,
      animalId: data.animalId,
      animalIds: _parseJsonArray(data.animalIds),
      protocolId: data.protocolId,
      vaccineName: data.vaccineName,
      type: _parseVaccinationType(data.type),
      disease: data.disease,
      vaccinationDate: data.vaccinationDate,
      batchNumber: data.batchNumber,
      expiryDate: data.expiryDate,
      dose: data.dose,
      administrationRoute: data.administrationRoute,
      veterinarianId: data.veterinarianId,
      veterinarianName: data.veterinarianName,
      nextDueDate: data.nextDueDate,
      withdrawalPeriodDays: data.withdrawalPeriodDays,
      notes: data.notes,
      synced: data.synced,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      lastSyncedAt: data.lastSyncedAt,
      serverVersion: data.serverVersion?.toString(),
    );
  }

  /// Convertit Vaccination (Model) → VaccinationsTableCompanion (Drift)
  VaccinationsTableCompanion _mapToCompanion(
    Vaccination vaccination,
    String farmId,
  ) {
    return VaccinationsTableCompanion(
      id: Value(vaccination.id),
      farmId: Value(farmId),
      animalId: vaccination.animalId != null
          ? Value(vaccination.animalId!)
          : const Value.absent(),
      animalIds: Value(_encodeJsonArray(vaccination.animalIds)),
      protocolId: vaccination.protocolId != null
          ? Value(vaccination.protocolId!)
          : const Value.absent(),
      vaccineName: Value(vaccination.vaccineName),
      type: Value(vaccination.type.name),
      disease: Value(vaccination.disease),
      vaccinationDate: Value(vaccination.vaccinationDate),
      batchNumber: vaccination.batchNumber != null
          ? Value(vaccination.batchNumber!)
          : const Value.absent(),
      expiryDate: vaccination.expiryDate != null
          ? Value(vaccination.expiryDate!)
          : const Value.absent(),
      dose: Value(vaccination.dose),
      administrationRoute: Value(vaccination.administrationRoute),
      veterinarianId: vaccination.veterinarianId != null
          ? Value(vaccination.veterinarianId!)
          : const Value.absent(),
      veterinarianName: vaccination.veterinarianName != null
          ? Value(vaccination.veterinarianName!)
          : const Value.absent(),
      nextDueDate: vaccination.nextDueDate != null
          ? Value(vaccination.nextDueDate!)
          : const Value.absent(),
      withdrawalPeriodDays: Value(vaccination.withdrawalPeriodDays),
      notes: vaccination.notes != null
          ? Value(vaccination.notes!)
          : const Value.absent(),
      synced: Value(vaccination.synced),
      lastSyncedAt: vaccination.lastSyncedAt != null
          ? Value(vaccination.lastSyncedAt!)
          : const Value.absent(),
      serverVersion: vaccination.serverVersion != null
          ? Value(int.tryParse(vaccination.serverVersion!) ?? 0)
          : const Value.absent(),
      deletedAt: const Value.absent(), // Jamais set manuellement
      createdAt: Value(vaccination.createdAt),
      updatedAt: Value(vaccination.updatedAt),
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

  // === ENUM HELPERS ===

  /// Parse une string en VaccinationType enum
  VaccinationType _parseVaccinationType(String type) {
    return VaccinationType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => VaccinationType.optionnelle,
    );
  }
}
