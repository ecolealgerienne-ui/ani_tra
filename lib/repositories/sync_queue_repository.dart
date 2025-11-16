// lib/repositories/sync_queue_repository.dart
import 'dart:convert';
import 'package:drift/drift.dart' as drift;

import '../drift/database.dart';
import '../drift/tables/sync_queue_table.dart';
import '../models/animal.dart';
import '../utils/sync_config.dart';
import '../utils/sync_validator.dart';
import '../utils/constants.dart';

/// Repository pour gérer la queue de synchronisation (STEP 4)
///
/// Cette classe orchestre toutes les opérations sur la queue:
/// - Ajout d'items avec validation
/// - Récupération des items à synchroniser
/// - Marquage des items synchronisés
/// - Gestion des retries
/// - Cleanup automatique
///
/// IMPORTANT:
/// - Tous les items sont filtrés par farmId (multi-tenancy)
/// - Validation officialID stricte en production
/// - Support retry avec backoff exponentiel
class SyncQueueRepository {
  final AppDatabase _db;

  SyncQueueRepository(this._db);

  // ==================== MÉTHODES PUBLIQUES ====================

  /// Ajouter un item à la queue avec validation
  ///
  /// Paramètres:
  /// - farmId: ID de la ferme (multi-tenancy)
  /// - entityType: Type d'entité (animal, treatment, etc.)
  /// - entityId: UUID de l'entité
  /// - action: Action à synchroniser (insert, update, delete)
  /// - payload: Données à synchroniser (sera sérialisé en JSON)
  /// - forceSyncDev: Bypass validation en mode dev (défaut: false)
  ///
  /// Lève SyncBlockedException si validation échoue
  ///
  /// Retourne: ID de l'item ajouté en queue
  Future<String> enqueueWithValidation(
    String farmId,
    String entityType,
    String entityId,
    String action,
    dynamic payload, {
    bool forceSyncDev = false,
  }) async {
    // ✅ VALIDATION CRITIQUE si entity est un Animal
    if (entityType == SyncEntityType.animal && payload is Animal) {
      final validation = SyncValidator.validateAnimal(payload);

      if (!validation.isValid) {
        if (forceSyncDev && validation.canForceSync) {
          if (SyncConfig.debugLogging) {
            print('⚠️  [DEV FORCE] Ignorant erreurs: ${validation.errorMessage}');
          }
        } else {
          throw SyncBlockedException(validation.errorMessage);
        }
      }
    }

    // Générer ID unique pour l'item
    final itemId = 'sync_${DateTime.now().millisecondsSinceEpoch}_$entityId';

    // Vérifier si item existe déjà (UPSERT logic)
    try {
      final existing = await _db.syncQueueDao.findById(itemId, farmId);

      if (existing != null) {
        // Item existe déjà → UPDATE (bumper updatedAt)
        if (SyncConfig.debugLogging) {
          print('🔄 [SYNC QUEUE] Item déjà en queue, mise à jour: $entityType:$entityId');
        }

        // Pas besoin de réinsérer, juste logger
        return existing.id;
      }
    } catch (_) {
      // Item pas trouvé, continuer pour insertion
    }

    // Sérialiser payload en JSON puis en bytes
    final String jsonPayload;
    if (payload is Animal) {
      jsonPayload = jsonEncode(payload.toJson());
    } else if (payload is Map) {
      jsonPayload = jsonEncode(payload);
    } else {
      jsonPayload = jsonEncode({'data': payload.toString()});
    }

    // Convertir en bytes pour stockage en BLOB
    final payloadBytes = utf8.encode(jsonPayload);

    // Créer companion pour insertion
    final companion = SyncQueueTableCompanion(
      id: drift.Value(itemId),
      farmId: drift.Value(farmId),
      entityType: drift.Value(entityType),
      entityId: drift.Value(entityId),
      action: drift.Value(action),
      payload: drift.Value(payloadBytes),
      retryCount: const drift.Value(0),
      createdAt: drift.Value(DateTime.now()),
    );

    // Insérer en queue
    await _db.syncQueueDao.insertItem(companion);

    if (SyncConfig.debugLogging) {
      print('✅ [SYNC QUEUE] Enqueued: $entityType:$entityId ($action)');
    }

    return itemId;
  }

  /// Récupérer items à synchroniser
  ///
  /// Filtre selon la configuration:
  /// - testMode: retourne [] (pas de sync réelle)
  /// - mockServerMode: retourne items (sync simulée)
  /// - Sinon: retourne items pour sync réelle
  ///
  /// Retourne les items triés par createdAt ASC (FIFO)
  Future<List<SyncQueueTableData>> getPendingForSync(String farmId) async {
    final pending = await _db.syncQueueDao.getPending(farmId);

    // Vérifier si sync autorisée selon config
    if (!SyncValidator.canSyncQueue(
      pendingCount: pending.length,
      totalRetries: pending.fold(0, (sum, item) => sum + item.retryCount),
    )) {
      if (SyncConfig.debugLogging) {
        print('🔴 [SYNC QUEUE] Sync désactivée par config');
      }
      return [];
    }

    if (SyncConfig.debugLogging) {
      print('📤 [SYNC QUEUE] ${pending.length} items prêts à syncer');
    }

    return pending;
  }

  /// Marquer un item comme synchronisé
  ///
  /// Met à jour:
  /// - syncedAt = NOW()
  /// - updatedAt = NOW()
  Future<void> markSynced(String id, String farmId) async {
    await _db.syncQueueDao.markSynced(id, farmId);

    if (SyncConfig.debugLogging) {
      print('✅ [SYNC QUEUE] Marked synced: $id');
    }
  }

  /// Enregistrer une tentative de retry en échec
  ///
  /// Incrémente retryCount et stocke l'erreur
  /// Si retryCount >= maxRetries, l'item devient "stalled"
  Future<void> recordRetry(
    String id,
    String farmId,
    String errorMessage,
  ) async {
    await _db.syncQueueDao.incrementRetry(id, farmId, errorMessage);

    if (SyncConfig.debugLogging) {
      print('⚠️  [SYNC QUEUE] Retry recorded: $id (error: $errorMessage)');
    }
  }

  /// Nettoyer les items synchronisés anciens
  ///
  /// Supprime items avec:
  /// - syncedAt NOT NULL (déjà synchronisé)
  /// - syncedAt < NOW() - cleanupDaysOld jours
  ///
  /// Retourne: nombre d'items supprimés
  Future<int> cleanupOldSynced(String farmId) async {
    final cutoffDate = DateTime.now()
        .subtract(Duration(days: SyncConfig.cleanupDaysOld));

    final deleted = await _db.syncQueueDao.deleteSynced(farmId, cutoffDate);

    if (SyncConfig.debugLogging) {
      print('🧹 [SYNC QUEUE] Cleanup: $deleted items supprimés (>${SyncConfig.cleanupDaysOld}j)');
    }

    return deleted;
  }

  /// Purger TOUS les items de la queue (dev/test seulement!)
  ///
  /// ⚠️ DANGER: Supprime TOUS les items, même non synchronisés!
  /// À utiliser UNIQUEMENT en développement pour tests
  ///
  /// Lève exception si pas en mode dev
  Future<int> purgeAll(String farmId) async {
    if (!SyncConfig.isDevelopmentMode) {
      throw Exception('⚠️  purgeAll() seulement autorisé en mode développement!');
    }

    final deleted = await _db.syncQueueDao.deleteAll(farmId);

    print('🗑️  [SYNC QUEUE] PURGED: $deleted items supprimés (DEV ONLY)');

    return deleted;
  }

  /// Compter les items en attente
  Future<int> countPending(String farmId) async {
    return await _db.syncQueueDao.countPending(farmId);
  }

  /// Compter les items déjà synchronisés
  Future<int> countSynced(String farmId) async {
    return await _db.syncQueueDao.countSynced(farmId);
  }

  /// Récupérer les items en échec après max retries
  ///
  /// Items "stalled" nécessitent intervention manuelle:
  /// - Reset retry count
  /// - Ou suppression manuelle
  /// - Ou correction données
  Future<List<SyncQueueTableData>> getStalledItems(String farmId) async {
    return await _db.syncQueueDao.findStalled(
      farmId,
      maxRetries: SyncConfig.maxRetries,
    );
  }

  /// Reset le compteur de retry pour un item
  ///
  /// Utilisé pour re-tenter un item "stalled"
  Future<void> resetRetryCount(String id, String farmId) async {
    await _db.syncQueueDao.resetRetryCount(id, farmId);

    if (SyncConfig.debugLogging) {
      print('🔄 [SYNC QUEUE] Retry count reset: $id');
    }
  }

  /// Inspecter la queue (debug)
  ///
  /// Affiche dans la console:
  /// - Nombre d'items pending
  /// - Détail de chaque item
  /// - Retries et erreurs
  Future<void> inspectQueue(String farmId) async {
    final pending = await _db.syncQueueDao.getPending(farmId);
    final synced = await countSynced(farmId);
    final stalled = await getStalledItems(farmId);

    print('════════════════════════════════════════');
    print('📊 [SYNC QUEUE] Inspection ($farmId)');
    print('════════════════════════════════════════');
    print('Pending:  ${pending.length} items');
    print('Synced:   $synced items');
    print('Stalled:  ${stalled.length} items');
    print('────────────────────────────────────────');

    if (pending.isEmpty) {
      print('(queue vide)');
    } else {
      for (var i = 0; i < pending.length; i++) {
        final item = pending[i];
        final icon = item.retryCount >= SyncConfig.maxRetries ? '🔴' : '⏳';

        print('$icon [$i] ${item.entityType}:${item.entityId}');
        print('   Action: ${item.action}');
        print('   Retries: ${item.retryCount}/${SyncConfig.maxRetries}');
        print('   Created: ${item.createdAt}');

        if (item.errorMessage != null) {
          print('   Error: ${item.errorMessage}');
        }
      }
    }

    print('════════════════════════════════════════');
  }

  /// Récupérer un item spécifique par ID
  Future<SyncQueueTableData?> getItemById(String id, String farmId) async {
    return await _db.syncQueueDao.findById(id, farmId);
  }

  /// Récupérer tous les items (pending + synced) pour debug
  ///
  /// ⚠️ Peut retourner beaucoup de données!
  Future<List<SyncQueueTableData>> getAllItems(String farmId) async {
    return await _db.syncQueueDao.getAll(farmId);
  }

  /// Décoder le payload d'un item
  ///
  /// Retourne Map<String, dynamic> du JSON décodé
  Map<String, dynamic> decodePayload(SyncQueueTableData item) {
    try {
      final jsonString = utf8.decode(item.payload);
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      if (SyncConfig.debugLogging) {
        print('❌ [SYNC QUEUE] Erreur décodage payload: $e');
      }
      return {};
    }
  }
}
