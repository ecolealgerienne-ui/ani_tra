// lib/repositories/farm_preferences_repository.dart

import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import '../drift/database.dart';
import '../models/farm_preferences.dart';

/// Repository pour les préférences de ferme
/// Couche métier entre Provider et DAO
/// Gère la sécurité (farmId validation) et le mapping
class FarmPreferencesRepository {
  final AppDatabase _db;
  static const _uuid = Uuid();

  FarmPreferencesRepository(this._db);

  /// Récupère les préférences pour une ferme spécifique
  /// Retourne null si aucune préférence n'existe
  /// Unique constraint: une seule préférence par ferme
  Future<FarmPreferences?> getByFarmId(String farmId) async {
    final data = await _db.farmPreferencesDao.getByFarmId(farmId);
    if (data == null) return null;

    // Vérification de sécurité supplémentaire
    if (data.farmId != farmId) {
      throw Exception(
          'Security violation: Farm ID mismatch in FarmPreferences');
    }

    return _mapToModel(data);
  }

  /// Récupère une préférence spécifique par ID
  /// Sécurité: farmId doit correspondre
  Future<FarmPreferences?> getById(String id, String farmId) async {
    final data = await _db.farmPreferencesDao.findById(id, farmId);
    if (data == null) return null;

    // Vérification de sécurité supplémentaire
    if (data.farmId != farmId) {
      throw Exception(
          'Security violation: Farm ID mismatch in FarmPreferences');
    }

    return _mapToModel(data);
  }

  /// Récupère toutes les préférences (pour admin multi-fermes)
  /// Non supprimées uniquement
  Future<List<FarmPreferences>> getAll() async {
    final data = await _db.farmPreferencesDao.findAll();
    return data.map((d) => _mapToModel(d)).toList();
  }

  /// Crée de nouvelles préférences de ferme
  /// Génère un UUID automatiquement
  /// Vérifie qu'aucune préférence n'existe déjà pour cette ferme
  Future<FarmPreferences> create(
    FarmPreferences preferences,
    String farmId,
  ) async {
    // Sécurité: vérifier que farmId correspond
    if (preferences.farmId != farmId) {
      throw Exception('Security violation: Farm ID mismatch');
    }

    // Vérifier qu'aucune préférence n'existe déjà pour cette ferme
    final existing = await _db.farmPreferencesDao.getByFarmId(farmId);
    if (existing != null && existing.deletedAt == null) {
      throw Exception(
        'FarmPreferences already exist for this farm. Use update instead.',
      );
    }

    final now = DateTime.now();
    final newPreferences = preferences.copyWith(
      id: _uuid.v4(),
      createdAt: now,
      updatedAt: now,
    );

    final companion = _mapToCompanion(newPreferences);
    await _db.farmPreferencesDao.insertItem(companion);

    return newPreferences;
  }

  /// Met à jour les préférences existantes
  Future<void> update(
    FarmPreferences preferences,
    String farmId,
  ) async {
    // Sécurité: vérifier farmId
    if (preferences.farmId != farmId) {
      throw Exception('Security violation: Farm ID mismatch');
    }

    // Vérifier que les préférences existent et appartiennent à la bonne ferme
    final existing =
        await _db.farmPreferencesDao.findById(preferences.id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('FarmPreferences not found or farm mismatch');
    }

    final updated = preferences.copyWith(updatedAt: DateTime.now());
    final companion = _mapToCompanion(updated);
    await _db.farmPreferencesDao.updateItem(companion);
  }

  /// Crée ou met à jour les préférences (upsert)
  /// Pratique pour sauvegarder sans vérifier l'existence
  Future<FarmPreferences> createOrUpdate(
    FarmPreferences preferences,
    String farmId,
  ) async {
    // Sécurité: vérifier farmId
    if (preferences.farmId != farmId) {
      throw Exception('Security violation: Farm ID mismatch');
    }

    final existing = await _db.farmPreferencesDao.getByFarmId(farmId);

    if (existing == null || existing.deletedAt != null) {
      // Créer nouvelles préférences
      return await create(preferences, farmId);
    } else {
      // Mettre à jour existantes
      await update(
        preferences.copyWith(id: existing.id),
        farmId,
      );
      return preferences.copyWith(
        id: existing.id,
        updatedAt: DateTime.now(),
      );
    }
  }

  /// Supprime (soft-delete) les préférences
  Future<void> delete(String id, String farmId) async {
    // Vérifier existence et sécurité
    final existing = await _db.farmPreferencesDao.findById(id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('FarmPreferences not found or farm mismatch');
    }

    await _db.farmPreferencesDao.softDelete(id, farmId);
  }

  /// Vérifie si une ferme a des préférences configurées
  Future<bool> hasPreferences(String farmId) async {
    return await _db.farmPreferencesDao.hasPreferences(farmId);
  }

  /// Récupère les préférences non synchronisées (Phase 2)
  /// Utilisé par SyncService
  Future<List<FarmPreferences>> getUnsynced(String farmId) async {
    final data = await _db.farmPreferencesDao.getUnsynced(farmId);
    return data.map((d) => _mapToModel(d)).toList();
  }

  /// Marque les préférences comme synchronisées (Phase 2)
  /// Appelé après confirmation du serveur
  Future<void> markSynced(
    String id,
    String farmId, {
    String? serverVersion,
  }) async {
    // Vérifier existence et sécurité
    final existing = await _db.farmPreferencesDao.findById(id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('FarmPreferences not found or farm mismatch');
    }

    await _db.farmPreferencesDao.markSynced(
      id,
      farmId,
      serverVersion: serverVersion,
    );
  }

  /// Compte le nombre total de préférences actives
  /// Utile pour les statistiques admin
  Future<int> count() async {
    return await _db.farmPreferencesDao.count();
  }

  // ========== MAPPERS ==========

  /// Mappe FarmPreferencesTableData (DB) → FarmPreferences (Model)
  FarmPreferences _mapToModel(FarmPreferencesTableData data) {
    return FarmPreferences(
      id: data.id,
      farmId: data.farmId,
      defaultVeterinarianId: data.defaultVeterinarianId,
      defaultSpeciesId: data.defaultSpeciesId,
      defaultBreedId: data.defaultBreedId,
      synced: data.synced,
      lastSyncedAt: data.lastSyncedAt,
      serverVersion: data.serverVersion,
      deletedAt: data.deletedAt,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  /// Mappe FarmPreferences (Model) → FarmPreferencesTableCompanion (DB)
  FarmPreferencesTableCompanion _mapToCompanion(FarmPreferences model) {
    return FarmPreferencesTableCompanion(
      id: Value(model.id),
      farmId: Value(model.farmId),
      defaultVeterinarianId: model.defaultVeterinarianId != null
          ? Value(model.defaultVeterinarianId!)
          : const Value.absent(),
      defaultSpeciesId: Value(model.defaultSpeciesId),
      defaultBreedId: model.defaultBreedId != null
          ? Value(model.defaultBreedId!)
          : const Value.absent(),
      synced: Value(model.synced),
      lastSyncedAt: model.lastSyncedAt != null
          ? Value(model.lastSyncedAt!)
          : const Value.absent(),
      serverVersion: model.serverVersion != null
          ? Value(model.serverVersion!)
          : const Value.absent(),
      deletedAt: model.deletedAt != null
          ? Value(model.deletedAt!)
          : const Value.absent(),
      createdAt: Value(model.createdAt),
      updatedAt: Value(model.updatedAt),
    );
  }
}
