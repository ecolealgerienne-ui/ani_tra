# 🔄 PHASE 1C - STEP 4: sync_queue + Phase 2 Ready Strategy

**Auteur:** Architecture Sync Phase 1→2  
**Date:** 2025-11-15  
**Objectif:** Vérifier + Bloquer + Tester + Nettoyer avant serveur

---

## 📊 TABLE DES MATIÈRES

1. [Checklist Complète de Vérification](#1-checklist-complète-de-vérification)
2. [Blocage OfficialID + Configuration](#2-blocage-officialid--configuration)
3. [Mode Test (Sans Serveur)](#3-mode-test-sans-serveur)
4. [Outils Dev - Bouton Cleanup Queue](#4-outils-dev---bouton-cleanup-queue)
5. [Architecture Complète de Sync](#5-architecture-complète-de-sync)
6. [Recommandations & Best Practices](#6-recommandations--best-practices)

---

## 1. CHECKLIST COMPLÈTE DE VÉRIFICATION

### 1.1 Database Architecture ✅

```dart
// STEP 4 - Vérification complète:

☐ sync_queue Table créée
  └─ Fichier: lib/drift/tables/sync_queue_table.dart
  ☐ Champs: id, farmId, entityType, entityId, action, payload
  ☐ Champs retry: retryCount (default 0), lastRetryAt (nullable), errorMessage
  ☐ Timestamps: createdAt, syncedAt (nullable)
  ☐ Indexes: idx_sync_queue_farm_id, idx_sync_queue_synced_at, idx_sync_queue_retry_count
  ☐ Unique key: {farmId, entityId, action}

☐ SyncQueueDao créé
  └─ Fichier: lib/drift/daos/sync_queue_dao.dart
  ☐ getPending(farmId) → List<SyncQueueTableData>
  ☐ insertItem(item) → Future<int>
  ☐ markSynced(id, farmId) → Future<int>
  ☐ incrementRetry(id, farmId, errorMsg) → Future<int>
  ☐ deleteSynced(farmId, olderThan) → Future<int> (cleanup)
  ☐ countPending(farmId) → Future<int>
  ☐ Ajouté dans database.dart avec @DriftAccessor

☐ SyncConstants définis
  └─ Fichier: lib/utils/constants.dart
  ☐ SyncAction: insert, update, delete
  ☐ SyncEntityType: animal, treatment, vaccination, weight, etc.
  ☐ SyncRetryPolicy: MAX_RETRIES, RETRY_DELAY_MS, etc.
```

### 1.2 All Tables Sync Fields ✅

```dart
// CHAQUE table DOIT avoir ces 3 champs (Phase 2 ready):

☐ Animals Table
  ☐ synced: BoolColumn (default false)
  ☐ lastSyncedAt: DateTimeColumn (nullable)
  ☐ serverVersion: IntColumn (nullable)

☐ Treatments Table
  ☐ synced: BoolColumn (default false)
  ☐ lastSyncedAt: DateTimeColumn (nullable)
  ☐ serverVersion: IntColumn (nullable)

☐ Vaccinations Table
  ☐ synced: BoolColumn (default false)
  ☐ lastSyncedAt: DateTimeColumn (nullable)
  ☐ serverVersion: IntColumn (nullable)

☐ Weights Table
  ☐ synced: BoolColumn (default false)
  ☐ lastSyncedAt: DateTimeColumn (nullable)
  ☐ serverVersion: IntColumn (nullable)

☐ Movements Table
  ☐ synced: BoolColumn (default false)
  ☐ lastSyncedAt: DateTimeColumn (nullable)
  ☐ serverVersion: IntColumn (nullable)

☐ Batches, Lots, Campaigns
  ☐ synced: BoolColumn (default false)
  ☐ lastSyncedAt: DateTimeColumn (nullable)
  ☐ serverVersion: IntColumn (nullable)

// Commande vérification:
grep -r "get synced" lib/drift/tables/ | wc -l
// Doit avoir: 9+ résultats (une par table)
```

### 1.3 All DAOs - getUnsynced() + markSynced() ✅

```dart
// CHAQUE DAO DOIT avoir:

☐ AnimalDao
  ☐ getUnsynced(farmId) → List<AnimalsTableData>
  ☐ markSynced(id, farmId) → Future<int>

☐ TreatmentDao
  ☐ getUnsynced(farmId) → List<TreatmentsTableData>
  ☐ markSynced(id, farmId) → Future<int>

☐ VaccinationDao
  ☐ getUnsynced(farmId) → List<VaccinationsTableData>
  ☐ markSynced(id, farmId) → Future<int>

☐ WeightDao
  ☐ getUnsynced(farmId) → List<WeightsTableData>
  ☐ markSynced(id, farmId) → Future<int>

☐ MovementDao
  ☐ getUnsynced(farmId) → List<MovementsTableData>
  ☐ markSynced(id, farmId) → Future<int>

☐ BatchDao, LotDao, CampaignDao
  ☐ getUnsynced(farmId) → List<...TableData>
  ☐ markSynced(id, farmId) → Future<int>

// Commande vérification:
grep -r "getUnsynced" lib/drift/daos/ | wc -l
// Doit avoir: 9+ résultats
```

### 1.4 All Repositories - getUnsynced() Wrapper ✅

```dart
// CHAQUE Repository DOIT wrapper:

☐ AnimalRepository
  ☐ getUnsynced(farmId) async
    → appelle _db.animalDao.getUnsynced(farmId)
    → mappe vers List<Animal>

☐ TreatmentRepository
  ☐ getUnsynced(farmId) async
    → appelle _db.treatmentDao.getUnsynced(farmId)
    → mappe vers List<Treatment>

☐ VaccinationRepository, WeightRepository, etc.
  ☐ getUnsynced(farmId) async → mappe vers modèles

// Pattern:
Future<List<Animal>> getUnsynced(String farmId) async {
  final items = await _db.animalDao.getUnsynced(farmId);
  return items.map((data) => _mapToModel(data)).toList();
}
```

### 1.5 FarmId Filtering Everywhere ✅

```dart
// Critique: Aucune donnée ne peut être lue/écrite sans farmId

☐ Toutes queries DAO
  ☐ findByFarmId() → where farmId
  ☐ findById() → where farmId + where id
  ☐ getUnsynced() → where farmId
  ☐ Aucun select() sans where farmId

// Commande vérification (recherche violations):
grep -r "select(" lib/drift/daos/ | grep -v ".where((t) => t.farmId"
// Résultat doit être vide!

☐ Toutes opérations Repository
  ☐ getAll(farmId) → passe farmId au DAO
  ☐ create(item, farmId) → ajoute farmId à l'item
  ☐ update(item, farmId) → vérifie farmId avant update
  ☐ delete(id, farmId) → soft-delete avec farmId check
```

### 1.6 Soft-Delete Everywhere ✅

```dart
// Critique: Jamais de hard-delete, toujours soft-delete

☐ Toutes tables
  ☐ deletedAt: DateTimeColumn (nullable)
  ☐ CREATE INDEX idx_xxx_deleted_at ON table(deleted_at)

☐ Toutes queries
  ☐ .where((t) => t.deletedAt.isNull())
  ☐ Aucun select() sans vérification deletedAt

☐ Delete operations
  ☐ softDelete(id, farmId) → UPDATE table SET deleted_at = NOW()
  ☐ Jamais DELETE FROM → hard-delete interdit!

// Commande vérification:
grep -r "deletedAt" lib/drift/daos/ | wc -l
// Doit avoir: 20+ résultats (plusieurs par DAO)
```

### 1.7 Transactions Support ✅

```dart
// Opérations complexes doivent être atomiques

☐ LotRepository.createLotWithAnimals()
  ☐ transaction: insert lot + update animals
  ☐ Si une opération échoue → rollback tous

☐ TreatmentRepository.createTreatmentWithAlert()
  ☐ transaction: insert treatment + insert alert

☐ Aucune opération sans transaction
  ☐ await _db.transaction(() async { ... })
```

### 1.8 Indexes Performance ✅

```dart
// Toutes les tables critiques:

☐ Animals
  ☐ idx_animals_farm_id ON (farm_id)
  ☐ idx_animals_status ON (farm_id, status)
  ☐ idx_animals_eid ON (current_eid)
  ☐ idx_animals_official_number ON (official_number)

☐ SyncQueue
  ☐ idx_sync_queue_farm_id ON (farm_id)
  ☐ idx_sync_queue_synced_at ON (synced_at)
  ☐ idx_sync_queue_retry_count ON (retry_count)

☐ Treatments
  ☐ idx_treatments_farm_id ON (farm_id)
  ☐ idx_treatments_animal_id ON (animal_id)
  ☐ idx_treatments_start_date ON (start_date)
```

---

## 2. BLOCAGE OFFICIALID + CONFIGURATION

### 2.1 SyncConfiguration (Flags Dev/Prod)

Créer: `lib/utils/sync_config.dart`

```dart
import 'package:flutter/foundation.dart';

class SyncConfig {
  // === MODE EXECUTION ===
  
  /// Mode développement: permet sync sans officialID
  /// Mode production: BLOCAGE sync si officialID vide
  static const bool isDevelopmentMode = kDebugMode;
  
  // === FLAGS SYNC ===
  
  /// Activer/désactiver la sync complètement
  static bool syncEnabled = true;
  
  /// Bloquer sync si officialID vide
  static bool blockSyncIfNoOfficialId = !isDevelopmentMode;
  
  /// Simuler le serveur en mode dev (pas d'appel réseau)
  static bool mockServerMode = isDevelopmentMode;
  
  /// Mode test: enregistre mais ne synchronise pas réellement
  static bool testMode = isDevelopmentMode;
  
  // === RETRY POLICY ===
  
  static const int maxRetries = 3;
  static const int retryDelayMs = 5000; // 5 sec
  static const int retryBackoffMultiplier = 2; // exponentiel
  
  // === CLEANUP ===
  
  /// Supprimer sync_queue items après N jours
  static const int cleanupDaysOld = 30;
  
  /// Nettoyer automatiquement au démarrage
  static bool autoCleanup = true;
  
  // === DEBUG ===
  
  static bool debugLogging = isDevelopmentMode;
  static bool debugShowSyncQueue = isDevelopmentMode;
  
  // === HELPERS ===
  
  static bool canSyncWithoutOfficialId() {
    return isDevelopmentMode && !blockSyncIfNoOfficialId;
  }
  
  static bool shouldUseMockServer() {
    return isDevelopmentMode && mockServerMode;
  }
  
  static bool isTestMode() {
    return isDevelopmentMode && testMode;
  }
}
```

### 2.2 SyncValidator (Blocage Intelligent)

Créer: `lib/utils/sync_validator.dart`

```dart
import '../models/animal.dart';
import 'sync_config.dart';

class SyncValidator {
  /// Vérifier si l'animal peut être synchronisé
  static SyncValidationResult validateAnimal(Animal animal) {
    final errors = <String>[];
    
    // ❌ BLOCAGE CRITIQUE: officialNumber vide
    if (animal.officialNumber == null || animal.officialNumber!.isEmpty) {
      if (SyncConfig.blockSyncIfNoOfficialId) {
        errors.add('BLOCAGE: officialNumber obligatoire pour sync');
      } else if (SyncConfig.isDevelopmentMode) {
        print('⚠️  DEV MODE: officialNumber vide mais sync autorisée');
      }
    }
    
    // ⚠️  WARNING: Au moins un identifiant requis
    if ((animal.currentEid == null || animal.currentEid!.isEmpty) &&
        (animal.officialNumber == null || animal.officialNumber!.isEmpty) &&
        (animal.visualId == null || animal.visualId!.isEmpty)) {
      errors.add('Au moins un identifiant requis');
    }
    
    // ❌ ERREUR: ID vide
    if (animal.id.isEmpty) {
      errors.add('Animal ID ne peut pas être vide');
    }
    
    // ❌ ERREUR: Status invalide
    const validStatuses = ['alive', 'sold', 'dead', 'slaughtered'];
    if (!validStatuses.contains(animal.status)) {
      errors.add('Status invalide: ${animal.status}');
    }
    
    return SyncValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      canForceSync: SyncConfig.isDevelopmentMode, // Permis en dev
    );
  }
  
  /// Vérifier si la queue peut être synchronisée
  static bool canSyncQueue({
    required int pendingCount,
    required int retryCount,
  }) {
    // En test mode, pas de sync réelle
    if (SyncConfig.testMode) {
      print('🧪 TEST MODE: Pas de sync réelle');
      return false;
    }
    
    // En mock server mode, simuler sync
    if (SyncConfig.mockServerMode) {
      print('🤖 MOCK SERVER: Sync simulée');
      return true;
    }
    
    // En prod, sync normale
    if (!SyncConfig.syncEnabled) {
      print('🔴 SYNC DÉSACTIVÉE');
      return false;
    }
    
    return true;
  }
}

class SyncValidationResult {
  final bool isValid;
  final List<String> errors;
  final bool canForceSync; // En dev seulement
  
  SyncValidationResult({
    required this.isValid,
    required this.errors,
    required this.canForceSync,
  });
  
  String get errorMessage => errors.join(', ');
}
```

### 2.3 Modification SyncQueueRepository (Blocage)

Ajouter dans: `lib/repositories/sync_queue_repository.dart`

```dart
import '../drift/database.dart';
import '../models/sync_queue_item.dart';
import '../utils/sync_config.dart';
import '../utils/sync_validator.dart';

class SyncQueueRepository {
  final AppDatabase _db;
  
  SyncQueueRepository(this._db);
  
  /// Ajouter un item à la queue avec validation
  Future<void> enqueueWithValidation(
    String farmId,
    String entityType,
    String entityId,
    String action,
    dynamic payload, {
    bool forceSyncDev = false, // Bypass validation en dev
  }) async {
    // ✅ VALIDATION CRITÈRE
    if (entityType == 'animal' && payload is Map) {
      final validation = SyncValidator.validateAnimal(payload);
      
      if (!validation.isValid) {
        if (forceSyncDev && SyncConfig.isDevelopmentMode) {
          print('⚠️  DEV FORCE: Ignorant erreurs: ${validation.errorMessage}');
        } else {
          throw SyncBlockedException(validation.errorMessage);
        }
      }
    }
    
    // ✅ Insertion en queue
    final queueItem = SyncQueueTableCompanion(
      id: Value(DateTime.now().millisecondsSinceEpoch.toString()),
      farmId: Value(farmId),
      entityType: Value(entityType),
      entityId: Value(entityId),
      action: Value(action),
      payload: Value(jsonEncode(payload)),
      retryCount: const Value(0),
      createdAt: Value(DateTime.now()),
    );
    
    await _db.syncQueueDao.insertItem(queueItem);
    
    print('✅ Enqueued: $entityType:$entityId ($action)');
  }
  
  /// Récupérer items à synchroniser
  Future<List<SyncQueueTableData>> getPendingForSync(String farmId) async {
    // Blocage: vérifier si sync est autorisée
    final pending = await _db.syncQueueDao.getPending(farmId);
    
    if (!SyncValidator.canSyncQueue(
      pendingCount: pending.length,
      retryCount: pending.fold(0, (sum, item) => sum + item.retryCount),
    )) {
      return [];
    }
    
    return pending;
  }
  
  /// Nettoyer la queue
  Future<int> cleanupOldSynced(String farmId) async {
    final cutoffDate = DateTime.now()
        .subtract(Duration(days: SyncConfig.cleanupDaysOld));
    
    return await _db.syncQueueDao.deleteSynced(farmId, cutoffDate);
  }
}

class SyncBlockedException implements Exception {
  final String message;
  SyncBlockedException(this.message);
  
  @override
  String toString() => '🔴 SYNC BLOQUÉE: $message';
}
```

---

## 3. MODE TEST (SANS SERVEUR)

### 3.1 MockSyncService (Test Mode)

Créer: `lib/services/mock_sync_service.dart`

```dart
import '../drift/database.dart';
import '../utils/sync_config.dart';

/// Service qui simule un serveur de sync pour tests
class MockSyncService {
  final AppDatabase _db;
  
  MockSyncService(this._db);
  
  /// Simuler une sync réussie (test mode)
  Future<void> simulateSuccessfulSync(String farmId) async {
    if (!SyncConfig.mockServerMode) {
      throw Exception('Mock server mode not enabled');
    }
    
    print('🤖 Simulating successful sync...');
    
    // Récupérer tous les pending
    final pending = await _db.syncQueueDao.getPending(farmId);
    
    // Simuler traitement avec délai
    for (final item in pending) {
      await Future.delayed(Duration(milliseconds: 100));
      await _db.syncQueueDao.markSynced(item.id, farmId);
      print('  ✅ Synced: ${item.entityType}:${item.entityId}');
    }
    
    print('🤖 Mock sync complete! Synced ${pending.length} items');
  }
  
  /// Simuler une sync échouée (test retry logic)
  Future<void> simulateFailedSync(
    String farmId,
    String errorMessage,
  ) async {
    if (!SyncConfig.mockServerMode) {
      throw Exception('Mock server mode not enabled');
    }
    
    print('🤖 Simulating failed sync: $errorMessage');
    
    final pending = await _db.syncQueueDao.getPending(farmId);
    
    for (final item in pending) {
      await Future.delayed(Duration(milliseconds: 50));
      await _db.syncQueueDao.incrementRetry(
        item.id,
        farmId,
        errorMessage,
      );
      print('  ⚠️  Retry incremented: ${item.entityType}:${item.entityId}');
    }
  }
  
  /// Vérifier l'état de la queue
  Future<void> inspectQueue(String farmId) async {
    final pending = await _db.syncQueueDao.getPending(farmId);
    final count = await _db.syncQueueDao.countPending(farmId);
    
    print('📊 Queue Status:');
    print('  Total pending: $count');
    print('  Items:');
    
    for (final item in pending) {
      print('    - ${item.entityType}:${item.entityId} '
            '(action: ${item.action}, retries: ${item.retryCount})');
    }
  }
}
```

### 3.2 Test Screen (Debug UI)

Créer: `lib/screens/debug_sync_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../services/mock_sync_service.dart';
import '../drift/database.dart';
import '../utils/sync_config.dart';
import 'package:provider/provider.dart';

/// Screen de test pour STEP 4 - Visible uniquement en dev
class DebugSyncScreen extends StatefulWidget {
  const DebugSyncScreen({Key? key}) : super(key: key);
  
  @override
  State<DebugSyncScreen> createState() => _DebugSyncScreenState();
}

class _DebugSyncScreenState extends State<DebugSyncScreen> {
  late MockSyncService _mockSync;
  String _farmId = 'farm-001';
  
  @override
  void initState() {
    super.initState();
    final db = context.read<AppDatabase>();
    _mockSync = MockSyncService(db);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔧 Debug Sync - STEP 4'),
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ===== MODE CONFIG =====
          _buildConfigSection(),
          const SizedBox(height: 24),
          
          // ===== SYNC TEST BUTTONS =====
          _buildSyncTestSection(),
          const SizedBox(height: 24),
          
          // ===== QUEUE MANAGEMENT =====
          _buildQueueManagementSection(),
          const SizedBox(height: 24),
          
          // ===== STATUS =====
          _buildStatusSection(),
        ],
      ),
    );
  }
  
  Widget _buildConfigSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('⚙️  Configuration', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('isDevelopmentMode: ${SyncConfig.isDevelopmentMode}'),
            Text('blockSyncIfNoOfficialId: ${SyncConfig.blockSyncIfNoOfficialId}'),
            Text('mockServerMode: ${SyncConfig.mockServerMode}'),
            Text('testMode: ${SyncConfig.testMode}'),
            Text('syncEnabled: ${SyncConfig.syncEnabled}'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  SyncConfig.testMode = !SyncConfig.testMode;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('testMode: ${SyncConfig.testMode}')),
                );
              },
              child: const Text('Toggle Test Mode'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSyncTestSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🔄 Test Sync Operations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  await _mockSync.simulateSuccessfulSync(_farmId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ Sync simulée avec succès')),
                  );
                  setState(() {});
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('❌ Erreur: $e')),
                  );
                }
              },
              icon: const Icon(Icons.cloud_upload),
              label: const Text('Simuler Sync Réussie'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  await _mockSync.simulateFailedSync(
                    _farmId,
                    'Erreur simulation test',
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('⚠️  Sync échouée simulée')),
                  );
                  setState(() {});
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('❌ Erreur: $e')),
                  );
                }
              },
              icon: const Icon(Icons.error),
              label: const Text('Simuler Sync Échouée'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildQueueManagementSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🧹 Queue Management', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  await _mockSync.inspectQueue(_farmId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ Queue inspection en console')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('❌ Erreur: $e')),
                  );
                }
              },
              icon: const Icon(Icons.list),
              label: const Text('Inspecter Queue'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () async {
                final db = context.read<AppDatabase>();
                final deleted = await db.syncQueueRepository.cleanupOldSynced(_farmId);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✅ $deleted items supprimés')),
                );
                setState(() {});
              },
              icon: const Icon(Icons.delete),
              label: const Text('Nettoyer Queue (30+ jours)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () async {
                // Supprimer TOUS les items de la queue
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('⚠️  Attention'),
                    content: const Text('Supprimer TOUS les items de la queue?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Non'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final db = context.read<AppDatabase>();
                          final cutoff = DateTime.fromMillisecondsSinceEpoch(0);
                          await db.syncQueueRepository.cleanupOldSynced(_farmId);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('✅ Queue vidée')),
                          );
                          setState(() {});
                        },
                        child: const Text('Oui, vider'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete_sweep),
              label: const Text('Vider Queue (⚠️  Tous)'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatusSection() {
    return FutureBuilder<int>(
      future: context.read<AppDatabase>().syncQueueDao.countPending(_farmId),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        
        return Card(
          color: snapshot.data! > 0 ? Colors.orange[50] : Colors.green[50],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('📊 Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(
                  'Pending Items: ${snapshot.data}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: snapshot.data! > 0 ? Colors.orange : Colors.green,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
```

### 3.3 Ajouter Screen au Main (Dev Only)

Modifier: `lib/main.dart`

```dart
import 'package:flutter/foundation.dart';
import 'screens/debug_sync_screen.dart';

void main() {
  // ... configuration normale
  
  // Route DEBUG (dev only)
  if (kDebugMode) {
    // Route accessible via devtools ou fab
  }
}

// Dans ton Widget principal (ex: MyApp):
floatingActionButton: kDebugMode
  ? FloatingActionButton(
      heroTag: 'debug',
      backgroundColor: Colors.red,
      child: const Icon(Icons.bug_report),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const DebugSyncScreen(),
          ),
        );
      },
    )
  : null,
```

---

## 4. OUTILS DEV - BOUTON CLEANUP QUEUE

### 4.1 Settings Screen - Sync Management Tab

Ajouter à: `lib/screens/settings_screen.dart` (dans un tab "Sync")

```dart
import 'package:flutter/material.dart';
import '../drift/database.dart';
import '../repositories/sync_queue_repository.dart';
import '../utils/sync_config.dart';
import 'package:provider/provider.dart';

class SyncSettingsTab extends StatefulWidget {
  const SyncSettingsTab({Key? key}) : super(key: key);
  
  @override
  State<SyncSettingsTab> createState() => _SyncSettingsTabState();
}

class _SyncSettingsTabState extends State<SyncSettingsTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // === SECTION: Configuration ===
          Card(
            child: ListTile(
              title: const Text('Bloquer sync sans Official ID'),
              subtitle: const Text('(Recommandé en production)'),
              trailing: Switch(
                value: SyncConfig.blockSyncIfNoOfficialId,
                onChanged: (value) {
                  setState(() {
                    SyncConfig.blockSyncIfNoOfficialId = value;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value
                            ? '🔴 Sync bloquée si officialID vide'
                            : '🟢 Sync autorisée (mode dev)',
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // === SECTION: Queue Status ===
          _buildQueueStatus(context),
          const SizedBox(height: 16),
          
          // === SECTION: Cleanup Actions ===
          _buildCleanupActions(context),
        ],
      ),
    );
  }
  
  Widget _buildQueueStatus(BuildContext context) {
    return FutureBuilder<int>(
      future: context.read<AppDatabase>().syncQueueDao.countPending('farm-001'),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        
        final count = snapshot.data!;
        return Card(
          color: count > 0 ? Colors.orange[50] : Colors.green[50],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sync Queue Status',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  'Pending items: $count',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: count > 0 ? Colors.orange : Colors.green,
                  ),
                ),
                if (count > 0) ...[
                  const SizedBox(height: 8),
                  const Text(
                    '⚠️  Items en attente de synchronisation',
                    style: TextStyle(fontSize: 12, color: Colors.orange),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildCleanupActions(BuildContext context) {
    return Column(
      children: [
        const Text(
          '🧹 Maintenance Queue',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildCleanupButton(
          context,
          icon: Icons.cleaning_services,
          label: 'Nettoyer Queue (items > 30 jours)',
          description: 'Supprimer les items synchronisés depuis > 30 jours',
          onPressed: () async {
            final db = context.read<AppDatabase>();
            final repo = db.syncQueueRepository;
            
            try {
              final count = await repo.cleanupOldSynced('farm-001');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('✅ $count items supprimés')),
              );
              setState(() {});
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('❌ Erreur: $e')),
              );
            }
          },
          color: Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildCleanupButton(
          context,
          icon: Icons.delete_sweep,
          label: 'Vider Tous (⚠️  ATTENTION)',
          description: 'Supprimer TOUS les items de la queue',
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                icon: const Icon(Icons.warning, color: Colors.red),
                title: const Text('⚠️  ATTENTION'),
                content: const Text(
                  'Cela va supprimer TOUS les items de la queue.\n\n'
                  'Utiliser UNIQUEMENT en dev/test !',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final db = context.read<AppDatabase>();
                      // Supprimer tous (cutoff = epoch)
                      await db.syncQueueRepository.cleanupOldSynced('farm-001');
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('✅ Queue vidée')),
                      );
                      setState(() {});
                    },
                    child: const Text('Vider', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
          color: Colors.red,
        ),
      ],
    );
  }
  
  Widget _buildCleanupButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String description,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 5. ARCHITECTURE COMPLÈTE DE SYNC

### 5.1 Flux de Sync Complet

```
┌─────────────────────────────────────────────────────────────┐
│                    SYNC ARCHITECTURE                         │
└─────────────────────────────────────────────────────────────┘

1. CRÉER ANIMAL
   ├─ AnimalScreen
   ├─ AnimalProvider.addAnimal()
   ├─ AnimalRepository.create(animal, farmId)
   │  └─ 🔍 Validation: SyncValidator.validateAnimal()
   │     └─ ❌ SI officialNumber vide + blockSyncIfNoOfficialId=true → ERREUR
   ├─ AnimalDao.insertAnimal()
   │  └─ DB: INSERT INTO animals (synced=false, lastSyncedAt=null)
   └─ ENQUEUE: SyncQueueRepository.enqueueWithValidation()
      └─ DB: INSERT INTO sync_queue (entityType='animal', action='insert')

2. MODE TEST (Sans serveur)
   ├─ SyncConfig.testMode = true
   ├─ Items dans queue mais pas synchronisés
   ├─ DebugSyncScreen.simulateSuccessfulSync()
   │  └─ Boucle sur sync_queue → markSynced()
   └─ UI affiche status: "Pending" ou "Synced"

3. CLEANUP QUEUE
   ├─ Settings → Sync Tab
   ├─ Bouton "Nettoyer (>30j)" ou "Vider Tous"
   └─ SyncQueueRepository.cleanupOldSynced(farmId)
      └─ DELETE FROM sync_queue WHERE synced_at < cutoff

4. MODE PRODUCTION (Avec serveur)
   ├─ Phase 2: SyncService
   ├─ Connexion à API
   ├─ getPending() → items à synchroniser
   ├─ Envoyer batch → serveur
   ├─ Serveur répond success/error
   ├─ Si success → markSynced()
   └─ Si error → incrementRetry() (max 3 fois)
```

### 5.2 States / Status Possibles

```dart
// Chaque item dans sync_queue a un état:

☐ PENDING (synced_at IS NULL, retry_count < MAX)
   └─ Attendant d'être synchronisé
   └─ Affichage: ⏳ En attente

☐ IN_PROGRESS (synced_at IS NULL, retrying)
   └─ Essayant de synchroniser
   └─ Affichage: 🔄 Synchronisation...

☐ SYNCED (synced_at IS NOT NULL, retry_count <= MAX)
   └─ Synchronisé avec succès
   └─ Affichage: ✅ Synchronisé

☐ FAILED (synced_at IS NULL, retry_count >= MAX)
   └─ Échec après N tentatives
   └─ Affichage: ❌ Erreur sync (3 tentatives)

☐ DELETED (HARD DELETE - nettoyage > 30 jours)
   └─ Item remplacé par versionserveur
   └─ Affichage: N/A (supprimé de queue)
```

---

## 6. RECOMMANDATIONS & BEST PRACTICES

### 6.1 ✅ À FAIRE Avant Serveur

```
☐ Vérifier TOUTES les tables ont sync fields
  └─ grep -r "get synced" lib/drift/tables/ | wc -l

☐ Vérifier TOUS les DAOs ont getUnsynced() + markSynced()
  └─ grep -r "getUnsynced" lib/drift/daos/ | wc -l

☐ Vérifier TOUS les Repositories ont getUnsynced()
  └─ grep -r "getUnsynced" lib/repositories/ | wc -l

☐ Vérifier TOUTES les queries filtrent farmId
  └─ PowerShell: Select-String "select(" -Rec lib/drift/daos/ | where {$_ -notmatch "farmId"}

☐ Vérifier AUCUN hard-delete
  └─ grep -r "delete(" lib/ | grep -v "softDelete" | grep -v "deletedAt"

☐ Tester offline mode
  └─ flutter run --offline (créer animals sans serveur)

☐ Tester cleanup batch
  └─ Créer 100 items, marquer synced, cleanup (30j), vérifier supprimés

☐ Tester validation officialID
  └─ Créer animal sans officialID → doit bloquer si blockSyncIfNoOfficialId=true

☐ Tester mode test
  └─ SyncConfig.testMode = true → items en queue mais pas vrais synced
```

### 6.2 ❌ À ÉVITER

```
❌ Hard-delete dans la table
   → Utiliser soft-delete (deletedAt)

❌ Sync sans officialID en prod
   → SyncConfig.blockSyncIfNoOfficialId = true

❌ Oublier farmId dans queries
   → Tous les select() DOIVENT avoir where farmId

❌ Accumuler items en queue indéfiniment
   → Prévoir cleanup automatique ou manuel

❌ Ne pas tester mode dev
   → Vérifier SyncConfig.testMode avant serveur

❌ Tester sync sans officialID sans bypass
   → Utiliser forceSyncDev=true pour tests
```

### 6.3 🔐 Sécurité Multi-Farm

```dart
// Assurer isolation données par farm:

✅ Toutes queries
   .where((t) => t.farmId.equals(farmId))

✅ SyncQueue filtrée par farmId
   getPending(farmId) → where farmId

✅ Cleanup séparé par farm
   cleanupOldSynced(farmId) → where farmId

❌ Jamais charger/modifier données autre farm
   → Security check au Repository level

❌ Jamais sync data entre farms
   → Chaque farm = queue separate
```

### 6.4 Performance

```
⚡ Queries rapides (< 50ms):
   ☐ Indexes sur farmId
   ☐ Indexes sur synced/lastSyncedAt
   ☐ Limit/offset pour pagination

⚡ Sync batch:
   ☐ getPending() retourne max 100 items
   ☐ Envoyer batch au serveur
   ☐ Pas de sync 1 par 1

⚡ Cleanup:
   ☐ Faire cleanup à chaque semaine (batch)
   ☐ Pas de cleanup item-by-item
   ☐ Utiliser cutoff date pour bulk delete
```

---

## CHECKLIST FINALE

```
☐ sync_queue Table + DAO implémentés
☐ SyncValidator bloque/autorise selon config
☐ SyncConfig avec flags dev/prod
☐ DebugSyncScreen pour tester sans serveur
☐ MockSyncService simule serveur
☐ Settings Sync Tab avec cleanup buttons
☐ Tous DAOs ont getUnsynced() + markSynced()
☐ Tous Repositories wrappent getUnsynced()
☐ FarmId filtering partout
☐ Soft-delete implémenté
☐ Transactions pour opérations multi-tables
☐ Tests manuels:
   ☐ Créer animal avec officialID → enqueued ✅
   ☐ Créer animal sans officialID → bloqué ✅
   ☐ Mode test → items en queue, pas synced ✅
   ☐ Mock sync success → items marqués synced ✅
   ☐ Mock sync failure → retry incrémenté ✅
   ☐ Cleanup > 30j → items supprimés ✅
   ☐ Vider queue → tous les items supprimés ✅

🎉 PHASE 1C STEP 4 COMPLÈTE - PRÊT POUR PHASE 2
```

---

**FIN DOCUMENTATION**

*Prêt à l'emploi pour intégration Phase 2 SyncService*
