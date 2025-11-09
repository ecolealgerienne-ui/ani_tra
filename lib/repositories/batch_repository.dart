// lib/repositories/batch_repository.dart
import 'dart:convert';
import '../models/batch.dart';
import '../drift/database.dart';
import '../drift/daos/batch_dao.dart';
import 'package:drift/drift.dart' as drift;

/// Repository pour gérer la persistance des batches
/// Phase 1C: Avec security checks farmId
class BatchRepository {
  final BatchDao _dao;

  BatchRepository(AppDatabase database) : _dao = database.batchDao;

  // ==================== CRUD Operations ====================

  /// Récupérer tous les batches d'une ferme
  Future<List<Batch>> findAllByFarm(String farmId) async {
    final data = await _dao.findAllByFarm(farmId);
    return data.map(_toBatch).toList();
  }

  /// Récupérer un batch par son ID (avec vérification farmId)
  Future<Batch?> findById(String id, String farmId) async {
    final data = await _dao.findById(id);
    if (data == null) return null;

    // Security check
    if (data.farmId != farmId) {
      throw Exception('Farm ID mismatch - Security violation');
    }

    return _toBatch(data);
  }

  /// Récupérer les batches actifs (non complétés) d'une ferme
  Future<List<Batch>> findActiveByFarm(String farmId) async {
    final data = await _dao.findActiveByFarm(farmId);
    return data.map(_toBatch).toList();
  }

  /// Récupérer les batches complétés d'une ferme
  Future<List<Batch>> findCompletedByFarm(String farmId) async {
    final data = await _dao.findCompletedByFarm(farmId);
    return data.map(_toBatch).toList();
  }

  /// Récupérer les batches par objectif pour une ferme
  Future<List<Batch>> findByPurposeAndFarm(
      BatchPurpose purpose, String farmId) async {
    final purposeString = purpose.name;
    final data = await _dao.findByPurposeAndFarm(purposeString, farmId);
    return data.map(_toBatch).toList();
  }

  /// Récupérer les batches contenant un animal spécifique
  Future<List<Batch>> findByAnimalId(String animalId, String farmId) async {
    final data = await _dao.findByAnimalId(animalId, farmId);
    return data.map(_toBatch).toList();
  }

  /// Créer un nouveau batch avec validation farmId
  Future<Batch> create(Batch batch, String farmId) async {
    // Security check: vérifier que le batch appartient à cette ferme
    if (batch.farmId != farmId) {
      throw Exception('Farm ID mismatch - Security violation');
    }

    final companion = _toCompanion(batch, isUpdate: false);
    await _dao.insertBatch(companion);
    return batch;
  }

  /// Mettre à jour un batch avec security check
  Future<Batch> update(Batch batch, String farmId) async {
    // Security check: vérifier l'ownership
    final existing = await _dao.findById(batch.id);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Batch not found or farm mismatch - Security violation');
    }

    // Double-check: le batch à updater doit aussi matcher
    if (batch.farmId != farmId) {
      throw Exception('Farm ID mismatch - Security violation');
    }

    final companion = _toCompanion(batch, isUpdate: true);
    await _dao.updateBatch(companion);
    return batch;
  }

  /// Supprimer un batch avec security check
  Future<void> delete(String id, String farmId) async {
    // Security check: vérifier l'ownership
    final existing = await _dao.findById(id);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Batch not found or farm mismatch - Security violation');
    }

    await _dao.deleteBatch(id);
  }

  // ==================== Business Logic ====================

  /// Marquer un batch comme complété avec security check
  Future<void> markAsCompleted(String id, String farmId) async {
    // Security check
    final existing = await _dao.findById(id);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Batch not found or farm mismatch - Security violation');
    }

    await _dao.markAsCompleted(id);
  }

  /// Ajouter un animal au batch avec security check
  Future<void> addAnimalToBatch(
      String batchId, String animalId, String farmId) async {
    // Security check
    final existing = await _dao.findById(batchId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Batch not found or farm mismatch - Security violation');
    }

    await _dao.addAnimalToBatch(batchId, animalId);
  }

  /// Retirer un animal du batch avec security check
  Future<void> removeAnimalFromBatch(
      String batchId, String animalId, String farmId) async {
    // Security check
    final existing = await _dao.findById(batchId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Batch not found or farm mismatch - Security violation');
    }

    await _dao.removeAnimalFromBatch(batchId, animalId);
  }

  /// Compter les batches d'une ferme
  Future<int> countByFarm(String farmId) async {
    return await _dao.countByFarm(farmId);
  }

  /// Compter les batches actifs d'une ferme
  Future<int> countActiveByFarm(String farmId) async {
    return await _dao.countActiveByFarm(farmId);
  }

  /// Récupérer les batches non synchronisés d'une ferme
  Future<List<Batch>> findUnsyncedByFarm(String farmId) async {
    final data = await _dao.findUnsyncedByFarm(farmId);
    return data.map(_toBatch).toList();
  }

  // ==================== Migration Support ====================

  /// Insérer plusieurs batches (pour migration) avec validation farmId
  Future<void> insertAll(List<Batch> batches, String farmId) async {
    for (final batch in batches) {
      // Vérifier que tous les batches appartiennent à cette ferme
      if (batch.farmId != farmId) {
        throw Exception(
            'Farm ID mismatch in batch ${batch.id} - Security violation');
      }
      await create(batch, farmId);
    }
  }

  /// Supprimer tous les batches d'une ferme
  Future<void> deleteAllByFarm(String farmId) async {
    final batches = await findAllByFarm(farmId);
    for (final batch in batches) {
      await delete(batch.id, farmId);
    }
  }

  // ==================== Conversion Methods ====================

  /// Convertir BatchesTableData en Batch
  Batch _toBatch(BatchesTableData data) {
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

    // Convertir le purpose string en enum
    BatchPurpose purpose;
    try {
      purpose = BatchPurpose.values.byName(data.purpose);
    } catch (e) {
      purpose = BatchPurpose.other;
    }

    return Batch(
      id: data.id,
      farmId: data.farmId,
      name: data.name,
      purpose: purpose,
      animalIds: animalIds,
      createdAt: data.createdAt,
      usedAt: data.usedAt,
      completed: data.completed,
      notes: data.notes,
      synced: data.synced,
      updatedAt: data.updatedAt,
      lastSyncedAt: data.lastSyncedAt,
      serverVersion: data.serverVersion,
    );
  }

  /// Convertir Batch en BatchesTableCompanion
  BatchesTableCompanion _toCompanion(Batch batch, {required bool isUpdate}) {
    // Encoder animal_ids en JSON
    final animalIdsJson = jsonEncode(batch.animalIds);

    return BatchesTableCompanion(
      id: drift.Value(batch.id),
      farmId: drift.Value(batch.farmId),
      name: drift.Value(batch.name),
      purpose: drift.Value(batch.purpose.name),
      animalIdsJson: drift.Value(animalIdsJson),
      usedAt: drift.Value(batch.usedAt),
      completed: drift.Value(batch.completed),
      notes: drift.Value(batch.notes),
      synced: drift.Value(batch.synced),
      createdAt: drift.Value(batch.createdAt),
      updatedAt: drift.Value(batch.updatedAt),
      lastSyncedAt: drift.Value(batch.lastSyncedAt),
      serverVersion: drift.Value(batch.serverVersion),
    );
  }
}
