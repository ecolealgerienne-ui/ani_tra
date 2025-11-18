// lib/repositories/animal_repository.dart
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../drift/database.dart';
import '../models/animal.dart';
import '../models/eid_change.dart';
import '../utils/constants.dart';
import 'sync_queue_repository.dart';

class AnimalRepository {
  final AppDatabase _db;
  late final SyncQueueRepository _syncQueue;

  AnimalRepository(this._db) {
    _syncQueue = SyncQueueRepository(_db);
  }

  // ==================== MÉTHODES OBLIGATOIRES ====================

  /// 1. getAll - Liste par farmId
  Future<List<Animal>> getAll(String farmId) async {
    final items = await _db.animalDao.findByFarmId(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// 2. getById - Sécurité farmId
  Future<Animal?> getById(String id, String farmId) async {
    final item = await _db.animalDao.findById(id, farmId);
    if (item == null) return null;

    // Security check
    if (item.farmId != farmId) {
      throw Exception('Farm ID mismatch - Security violation');
    }

    return _mapToModel(item);
  }

  /// 3. create - Créer avec farmId (A6: avec logging)
  /// STEP4: Transaction + enqueue sync
  Future<void> create(Animal animal, String farmId) async {
    await _db.transaction(() async {
      final companion = _mapToCompanion(animal, farmId);
      await _db.animalDao.insertItem(companion);

      // Enqueue pour sync (validation interne)
      await _syncQueue.enqueueAnimal(farmId, animal, SyncAction.insert);
    });
    debugPrint('🐑 Animal créé: ${animal.id} dans farm $farmId');
  }

  /// 4. update - Vérifier farmId (A6: avec logging)
  /// ⚡ B1 FIX: Pass farmId to updateItem() for mandatory security check
  /// STEP4: Transaction + enqueue sync
  Future<void> update(Animal animal, String farmId) async {
    // Security check
    final existing = await _db.animalDao.findById(animal.id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Animal not found or farm mismatch');
    }

    await _db.transaction(() async {
      final companion = _mapToCompanion(animal, farmId);
      final result = await _db.animalDao.updateItem(companion, farmId);
      if (result == 0) {
        throw Exception('Animal update failed - no rows affected');
      }

      // Enqueue pour sync (validation interne)
      await _syncQueue.enqueueAnimal(farmId, animal, SyncAction.update);
    });
    debugPrint('🐑 Animal mis à jour: ${animal.id} dans farm $farmId');
  }

  /// 5. delete - Soft-delete (A6: avec logging)
  /// STEP4: Transaction + enqueue sync
  Future<void> delete(String id, String farmId) async {
    // Get animal before delete for sync queue
    final existing = await _db.animalDao.findById(id, farmId);
    if (existing == null) {
      throw Exception('Animal not found');
    }

    await _db.transaction(() async {
      await _db.animalDao.softDelete(id, farmId);

      // Enqueue pour sync (pas de validation pour delete)
      final animal = _mapToModel(existing);
      await _syncQueue.enqueueAnimal(farmId, animal, SyncAction.delete);
    });
    debugPrint('🐑 Animal supprimé (soft): $id dans farm $farmId');
  }

  /// 6. getUnsynced - Phase 2 ready
  Future<List<Animal>> getUnsynced(String farmId) async {
    final items = await _db.animalDao.getUnsynced(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  // ==================== MÉTHODES MÉTIER SUPPLÉMENTAIRES ====================

  /// Rechercher par EID
  Future<Animal?> findByEid(String eid, String farmId) async {
    final item = await _db.animalDao.findByEid(eid, farmId);
    if (item == null) return null;
    return _mapToModel(item);
  }

  /// Rechercher par numéro officiel
  Future<Animal?> findByOfficialNumber(
      String officialNumber, String farmId) async {
    final item =
        await _db.animalDao.findByOfficialNumber(officialNumber, farmId);
    if (item == null) return null;
    return _mapToModel(item);
  }

  /// Filtrer par espèce
  Future<List<Animal>> findBySpecies(String speciesId, String farmId) async {
    final items = await _db.animalDao.findBySpecies(speciesId, farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Filtrer par statut
  Future<List<Animal>> findByStatus(String status, String farmId) async {
    final items = await _db.animalDao.findByStatus(status, farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Filtrer par sexe
  Future<List<Animal>> findBySex(String sex, String farmId) async {
    final items = await _db.animalDao.findBySex(sex, farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Compter animaux (B3 optimisé)
  Future<int> count(String farmId) async {
    return await _db.animalDao.countByFarmId(farmId);
  }

  /// Obtenir les mères potentielles
  Future<List<Animal>> getPotentialMothers(String farmId) async {
    final items = await _db.animalDao.getPotentialMothers(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  // ==================== PRIORITY 3: AMÉLIORATIONS ====================

  /// A1: Rechercher animaux nés entre deux dates
  Future<List<Animal>> findByBirthDateRange(
    String farmId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final items = await _db.animalDao.findByBirthDateRange(
      farmId,
      startDate,
      endDate,
    );
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// A1: Rechercher animaux par plage d'âge (en jours)
  Future<List<Animal>> findByAgeRangeInDays(
    String farmId,
    int minDays,
    int maxDays,
  ) async {
    final items = await _db.animalDao.findByAgeRangeInDays(
      farmId,
      minDays,
      maxDays,
    );
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// A2: Recherche composée espèce + statut
  Future<List<Animal>> findBySpeciesAndStatus(
    String farmId,
    String speciesId,
    String status,
  ) async {
    final items = await _db.animalDao.findBySpeciesAndStatus(
      farmId,
      speciesId,
      status,
    );
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// A2: Recherche composée statut + sexe
  Future<List<Animal>> findByStatusAndSex(
    String farmId,
    String status,
    String sex,
  ) async {
    final items = await _db.animalDao.findByStatusAndSex(
      farmId,
      status,
      sex,
    );
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// A3: Obtenir femelles en âge de reproduction (logique métier)
  Future<List<Animal>> getFemalesOfReproductiveAge(String farmId) async {
    final items = await _db.animalDao.getFemalesOfReproductiveAge(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// A4: Pagination support
  Future<PaginatedAnimals> getAnimalsPaginated(
    String farmId, {
    required int page,
    required int pageSize,
  }) async {
    final offset = (page - 1) * pageSize;
    final items = await _db.animalDao.findByFarmIdPaginated(
      farmId,
      limit: pageSize,
      offset: offset,
    );
    final total = await _db.animalDao.countByFarmIdForPagination(farmId);

    return PaginatedAnimals(
      animals: items.map((data) => _mapToModel(data)).toList(),
      total: total,
      page: page,
      pageSize: pageSize,
      totalPages: (total / pageSize).ceil(),
    );
  }

  // ==================== DRAFT SYSTEM METHODS ====================

  /// Valider un animal (DRAFT → ALIVE)
  /// Rend l'animal immuable (sauf nom)
  Future<void> validateAnimal(String id, String farmId) async {
    // Security check
    final existing = await _db.animalDao.findById(id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Animal not found or farm mismatch');
    }

    final result = await _db.animalDao.validateAnimal(id, farmId);
    if (result == 0) {
      throw Exception('Animal validation failed - no rows affected');
    }
    debugPrint('✅ Animal validé: $id dans farm $farmId');
  }

  /// Supprimer un animal BROUILLON (vrai delete, pas soft-delete)
  /// ⚠️ DRAFT only - une fois validé, on ne peut plus supprimer
  Future<void> deleteDraftAnimal(String id, String farmId) async {
    // Security check
    final existing = await _db.animalDao.findById(id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Animal not found or farm mismatch');
    }

    // Vérifier que c'est vraiment un brouillon
    if (existing.status != 'draft' || existing.validatedAt != null) {
      throw Exception('Cannot delete non-draft animal');
    }

    // Hard delete (pas soft-delete pour DRAFT)
    await _db.animalDao.softDelete(id, farmId);
    debugPrint('✅ Animal DRAFT supprimé: $id dans farm $farmId');
  }

  /// L'animal est-il modifiable?
  /// ✅ DRAFT: tout modifiable
  /// ✅ ALIVE: nom seulement (via repository)
  /// ❌ DEAD/SOLD/SLAUGHTERED: rien
  bool isAnimalModifiable(Animal animal) {
    return animal.isDraft;
  }

  /// L'animal peut-il recevoir des soins?
  /// ✅ ALIVE validé
  /// ❌ DRAFT, DEAD, SOLD, SLAUGHTERED: non
  bool canAnimalReceiveCare(Animal animal) {
    return animal.canReceiveCare;
  }

  /// Obtenir tous les DRAFT d'une ferme
  Future<List<Animal>> getDraftAnimals(String farmId) async {
    final items = await _db.animalDao.findDraftAnimals(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Obtenir les DRAFT créés avant une date (pour alertes)
  Future<List<Animal>> getDraftOlderThan(
    String farmId,
    DateTime beforeDate,
  ) async {
    final items = await _db.animalDao.findDraftOlderThan(farmId, beforeDate);
    return items.map((data) => _mapToModel(data)).toList();
  }

  // ==================== MAPPERS ====================

  /// Mapper AnimalsTableData vers Animal (model)
  Animal _mapToModel(AnimalsTableData data) {
    // B4 FIX: Decode eidHistory from JSON avec logging
    List<EidChange>? eidHistory;
    if (data.eidHistory != null) {
      try {
        final jsonList = jsonDecode(data.eidHistory!) as List;
        eidHistory = jsonList
            .map((e) => EidChange.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (e) {
        // B4: Logging d'erreur au lieu de silencieux
        debugPrint('⚡ ERREUR parsing eidHistory pour animal ${data.id}: $e');
        eidHistory = null;
      }
    }

    return Animal(
      id: data.id,
      farmId: data.farmId,
      currentEid: data.currentEid,
      eidHistory: eidHistory,
      officialNumber: data.officialNumber,
      birthDate: data.birthDate,
      sex: AnimalSex.values.firstWhere((e) => e.name == data.sex),
      motherId: data.motherId,
      status: AnimalStatus.values.firstWhere((e) => e.name == data.status),
      validatedAt: data.validatedAt,
      speciesId: data.speciesId,
      breedId: data.breedId,
      visualId: data.visualId,
      photoUrl: data.photoUrl,
      days: data.days,
      synced: data.synced,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      lastSyncedAt: data.lastSyncedAt,
      serverVersion: data.serverVersion,
    );
  }

  /// Mapper Animal (model) vers AnimalsTableCompanion
  AnimalsTableCompanion _mapToCompanion(Animal animal, String farmId) {
    // Encode eidHistory to JSON
    String? eidHistoryJson;
    if (animal.eidHistory != null && animal.eidHistory!.isNotEmpty) {
      eidHistoryJson =
          jsonEncode(animal.eidHistory!.map((e) => e.toJson()).toList());
    }

    return AnimalsTableCompanion(
      id: Value(animal.id),
      farmId: Value(farmId),
      currentEid: Value(animal.currentEid),
      eidHistory: Value(eidHistoryJson),
      officialNumber: Value(animal.officialNumber),
      birthDate: Value(animal.birthDate),
      sex: Value(animal.sex.name),
      motherId: Value(animal.motherId),
      status: Value(animal.status.name),
      validatedAt: Value(animal.validatedAt),
      speciesId: Value(animal.speciesId),
      breedId: Value(animal.breedId),
      visualId: Value(animal.visualId),
      photoUrl: Value(animal.photoUrl),
      days: Value(animal.days),
      synced: Value(animal.synced),
      createdAt: Value(animal.createdAt),
      updatedAt: Value(animal.updatedAt),
      lastSyncedAt: Value(animal.lastSyncedAt),
      serverVersion: Value(animal.serverVersion),
      deletedAt: const Value.absent(), // Pas de soft-delete à la création
    );
  }
}

// ==================== HELPER CLASSES ====================

/// A4: Classe helper pour résultats paginés
class PaginatedAnimals {
  final List<Animal> animals;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  PaginatedAnimals({
    required this.animals,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  bool get hasNextPage => page < totalPages;
  bool get hasPreviousPage => page > 1;
}
