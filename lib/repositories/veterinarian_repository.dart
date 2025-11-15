// lib/repositories/veterinarian_repository.dart

import 'dart:convert';
import 'package:drift/drift.dart';
import '../drift/database.dart';
import '../models/veterinarian.dart';
//import '../drift/daos/veterinarian_dao.dart';

/// Repository pour la gestion des vétérinaires
///
/// Couche business logic entre les providers et la base de données.
/// Responsabilités:
/// - Mapping Model ↔ Drift Companion
/// - Validation business
/// - Security checks (farmId)
/// - Conversion JSON pour specialties
/// - Gestion des statistiques d'interventions
class VeterinarianRepository {
  final AppDatabase _db;

  VeterinarianRepository(this._db);

  // === CRUD OPERATIONS ===

  /// Récupère tous les vétérinaires d'une ferme
  Future<List<Veterinarian>> getAll(String farmId) async {
    final items = await _db.veterinarianDao.findByFarmId(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère un vétérinaire par ID avec security check
  Future<Veterinarian?> getById(String id, String farmId) async {
    final item = await _db.veterinarianDao.findById(id, farmId);
    if (item == null) return null;

    // Security check
    if (item.farmId != farmId) {
      throw Exception('Farm ID mismatch - Security violation');
    }

    return _mapToModel(item);
  }

  /// Crée un nouveau vétérinaire
  Future<void> create(Veterinarian veterinarian, String farmId) async {
    final companion = _mapToCompanion(veterinarian, farmId);
    await _db.veterinarianDao.insertItem(companion);
  }

  /// Met à jour un vétérinaire existant
  Future<void> update(Veterinarian veterinarian, String farmId) async {
    // Security check
    final existing =
        await _db.veterinarianDao.findById(veterinarian.id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Veterinarian not found or farm mismatch');
    }

    final companion = _mapToCompanion(veterinarian, farmId);
    await _db.veterinarianDao.updateItem(companion);
  }

  /// Supprime un vétérinaire (soft-delete)
  Future<void> delete(String id, String farmId) async {
    await _db.veterinarianDao.softDelete(id, farmId);
  }

  // === BUSINESS QUERIES ===

  /// Récupère les vétérinaires actifs
  Future<List<Veterinarian>> getActive(String farmId) async {
    final items = await _db.veterinarianDao.findActiveByFarmId(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les vétérinaires disponibles
  Future<List<Veterinarian>> getAvailable(String farmId) async {
    final items = await _db.veterinarianDao.findAvailable(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère le vétérinaire par défaut
  Future<Veterinarian?> getDefault(String farmId) async {
    final item = await _db.veterinarianDao.findDefault(farmId);
    if (item == null) return null;
    return _mapToModel(item);
  }

  /// Récupère les vétérinaires préférés
  Future<List<Veterinarian>> getPreferred(String farmId) async {
    final items = await _db.veterinarianDao.findPreferred(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les vétérinaires avec service d'urgence
  Future<List<Veterinarian>> getWithEmergencyService(String farmId) async {
    final items = await _db.veterinarianDao.findWithEmergencyService(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Recherche de vétérinaires par nom
  Future<List<Veterinarian>> searchByName(
    String farmId,
    String query,
  ) async {
    final items = await _db.veterinarianDao.searchByName(farmId, query);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Incrémente le compteur d'interventions
  ///
  /// Appelé après chaque intervention (traitement, vaccination, etc.)
  Future<void> incrementInterventions(String id, String farmId) async {
    await _db.veterinarianDao.incrementInterventions(id, farmId);
  }

  // === SYNC OPERATIONS (Phase 2 ready) ===

  /// Récupère les vétérinaires non synchronisés
  Future<List<Veterinarian>> getUnsynced(String farmId) async {
    final items = await _db.veterinarianDao.getUnsynced(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Marque un vétérinaire comme synchronisé
  Future<void> markAsSynced(
    String id,
    String farmId,
    int serverVersion,
  ) async {
    await _db.veterinarianDao.markSynced(id, farmId, serverVersion);
  }

  // === MAPPERS ===

  /// Convertit VeterinariansTableData → Veterinarian (Model)
  Veterinarian _mapToModel(VeterinariansTableData data) {
    return Veterinarian(
      id: data.id,
      farmId: data.farmId,
      firstName: data.firstName,
      lastName: data.lastName,
      title: data.title,
      licenseNumber: data.licenseNumber,
      specialties: _parseJsonArray(data.specialties),
      clinic: data.clinic,
      phone: data.phone,
      mobile: data.mobile,
      email: data.email,
      address: data.address,
      city: data.city,
      postalCode: data.postalCode,
      country: data.country,
      isAvailable: data.isAvailable,
      emergencyService: data.emergencyService,
      workingHours: data.workingHours,
      consultationFee: data.consultationFee,
      emergencyFee: data.emergencyFee,
      currency: data.currency,
      notes: data.notes,
      isPreferred: data.isPreferred,
      isDefault: data.isDefault,
      rating: data.rating,
      totalInterventions: data.totalInterventions,
      lastInterventionDate: data.lastInterventionDate,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      isActive: data.isActive,
      synced: data.synced,
      lastSyncedAt: data.lastSyncedAt,
      serverVersion: data.serverVersion?.toString(),
    );
  }

  /// Convertit Veterinarian (Model) → VeterinariansTableCompanion (Drift)
  VeterinariansTableCompanion _mapToCompanion(
    Veterinarian veterinarian,
    String farmId,
  ) {
    return VeterinariansTableCompanion(
      id: Value(veterinarian.id),
      farmId: Value(farmId),
      firstName: Value(veterinarian.firstName),
      lastName: Value(veterinarian.lastName),
      title: veterinarian.title != null
          ? Value(veterinarian.title!)
          : const Value.absent(),
      licenseNumber: Value(veterinarian.licenseNumber),
      specialties: Value(_encodeJsonArray(veterinarian.specialties)),
      clinic: veterinarian.clinic != null
          ? Value(veterinarian.clinic!)
          : const Value.absent(),
      phone: Value(veterinarian.phone),
      mobile: veterinarian.mobile != null
          ? Value(veterinarian.mobile!)
          : const Value.absent(),
      email: veterinarian.email != null
          ? Value(veterinarian.email!)
          : const Value.absent(),
      address: veterinarian.address != null
          ? Value(veterinarian.address!)
          : const Value.absent(),
      city: veterinarian.city != null
          ? Value(veterinarian.city!)
          : const Value.absent(),
      postalCode: veterinarian.postalCode != null
          ? Value(veterinarian.postalCode!)
          : const Value.absent(),
      country: veterinarian.country != null
          ? Value(veterinarian.country!)
          : const Value.absent(),
      isAvailable: Value(veterinarian.isAvailable),
      emergencyService: Value(veterinarian.emergencyService),
      workingHours: veterinarian.workingHours != null
          ? Value(veterinarian.workingHours!)
          : const Value.absent(),
      consultationFee: veterinarian.consultationFee != null
          ? Value(veterinarian.consultationFee!)
          : const Value.absent(),
      emergencyFee: veterinarian.emergencyFee != null
          ? Value(veterinarian.emergencyFee!)
          : const Value.absent(),
      currency: veterinarian.currency != null
          ? Value(veterinarian.currency!)
          : const Value.absent(),
      notes: veterinarian.notes != null
          ? Value(veterinarian.notes!)
          : const Value.absent(),
      isPreferred: Value(veterinarian.isPreferred),
      isDefault: Value(veterinarian.isDefault),
      rating: Value(veterinarian.rating),
      totalInterventions: Value(veterinarian.totalInterventions),
      lastInterventionDate: veterinarian.lastInterventionDate != null
          ? Value(veterinarian.lastInterventionDate!)
          : const Value.absent(),
      isActive: Value(veterinarian.isActive),
      synced: Value(veterinarian.synced),
      lastSyncedAt: veterinarian.lastSyncedAt != null
          ? Value(veterinarian.lastSyncedAt!)
          : const Value.absent(),
      serverVersion: veterinarian.serverVersion != null
          ? Value(int.tryParse(veterinarian.serverVersion!) ?? 0)
          : const Value.absent(),
      deletedAt: const Value.absent(), // Jamais set manuellement
      createdAt: Value(veterinarian.createdAt),
      updatedAt: Value(veterinarian.updatedAt),
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
