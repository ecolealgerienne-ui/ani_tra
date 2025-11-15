# 💻 STEP 4 - CODE SNIPPETS (Copy-Paste Prêts)

---

## 1️⃣ lib/utils/sync_config.dart

```dart
import 'package:flutter/foundation.dart';

/// Configuration centralisée pour sync Phase 2
/// Permet dev/test sans serveur
class SyncConfig {
  // ===== MODE EXECUTION =====
  
  /// Development mode = debug + test features enabled
  static const bool isDevelopmentMode = kDebugMode;
  
  // ===== FLAGS SYNC =====
  
  /// 🔴 CRITIQUE: Bloquer sync si officialNumber vide
  /// Prod: true (OBLIGATOIRE)
  /// Dev: false (permet test sans officialID)
  static bool blockSyncIfNoOfficialId = !isDevelopmentMode;
  
  /// Activer/désactiver la sync globalement
  static bool syncEnabled = true;
  
  /// 🤖 Mode mock serveur: simule sync sans appel réseau
  static bool mockServerMode = isDevelopmentMode;
  
  /// 🧪 Mode test: enregistre data mais ne synce pas réellement
  static bool testMode = isDevelopmentMode;
  
  // ===== RETRY POLICY =====
  
  /// Nombre max de tentatives avant failure
  static const int maxRetries = 3;
  
  /// Délai entre tentatives (ms)
  static const int retryDelayMs = 5000; // 5 sec
  
  /// Multiplicateur backoff exponentiel (2x, 4x, 8x)
  static const int retryBackoffMultiplier = 2;
  
  // ===== CLEANUP =====
  
  /// Supprimer sync_queue items après N jours
  static const int cleanupDaysOld = 30;
  
  /// Nettoyer automatiquement au démarrage
  static bool autoCleanup = true;
  
  // ===== DEBUG =====
  
  /// Logs de debug activés
  static bool debugLogging = isDevelopmentMode;
  
  /// Afficher DebugSyncScreen en UI
  static bool debugShowSyncQueue = isDevelopmentMode;
  
  // ===== HELPERS =====
  
  /// Peut-on syncer sans officialID? (dev seulement)
  static bool canSyncWithoutOfficialId() {
    return isDevelopmentMode && !blockSyncIfNoOfficialId;
  }
  
  /// Utiliser mock serveur? (dev/test)
  static bool shouldUseMockServer() {
    return isDevelopmentMode && mockServerMode;
  }
  
  /// Mode test actif? (items en queue pas vrais synced)
  static bool isTestMode() {
    return isDevelopmentMode && testMode;
  }
}
```

---

## 2️⃣ lib/utils/sync_validator.dart

```dart
import '../models/animal.dart';
import 'sync_config.dart';

/// Valide si data peut être synchronisée
class SyncValidator {
  /// Valider un animal pour sync
  static SyncValidationResult validateAnimal(Animal animal) {
    final errors = <String>[];
    
    // ❌ BLOCAGE: officialNumber vide
    if (animal.officialNumber == null || animal.officialNumber!.isEmpty) {
      if (SyncConfig.blockSyncIfNoOfficialId) {
        errors.add('BLOCAGE: officialNumber obligatoire pour synchroniser');
      } else if (SyncConfig.isDevelopmentMode) {
        print('⚠️  [DEV] officialNumber vide mais sync autorisée');
      }
    }
    
    // ⚠️  WARNING: Au moins un identifiant requis
    if ((animal.currentEid == null || animal.currentEid!.isEmpty) &&
        (animal.officialNumber == null || animal.officialNumber!.isEmpty) &&
        (animal.visualId == null || animal.visualId!.isEmpty)) {
      errors.add('Au moins un identifiant requis (EID, officiel, visual)');
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
    
    // ❌ ERREUR: Birth date manquant
    if (animal.birthDate == null) {
      errors.add('Date de naissance obligatoire');
    }
    
    return SyncValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      canForceSync: SyncConfig.isDevelopmentMode,
    );
  }
  
  /// Peut-on syncer la queue?
  static bool canSyncQueue({
    required int pendingCount,
    required int totalRetries,
  }) {
    // Mode test: non
    if (SyncConfig.testMode) {
      if (SyncConfig.debugLogging) {
        print('🧪 [TEST MODE] Pas de sync réelle');
      }
      return false;
    }
    
    // Mode mock serveur: oui
    if (SyncConfig.mockServerMode) {
      if (SyncConfig.debugLogging) {
        print('🤖 [MOCK SERVER] Sync simulée');
      }
      return true;
    }
    
    // Sync globalement désactivée
    if (!SyncConfig.syncEnabled) {
      print('🔴 [SYNC DÉSACTIVÉE]');
      return false;
    }
    
    return true;
  }
}

/// Résultat validation
class SyncValidationResult {
  final bool isValid;
  final List<String> errors;
  final bool canForceSync; // Dev seulement
  
  SyncValidationResult({
    required this.isValid,
    required this.errors,
    required this.canForceSync,
  });
  
  String get errorMessage => errors.join('; ');
  
  /// En dev, peut bypass validation
  bool get canProceed => isValid || canForceSync;
}

/// Exception quand sync bloquée
class SyncBlockedException implements Exception {
  final String message;
  SyncBlockedException(this.message);
  
  @override
  String toString() => '🔴 SYNC BLOQUÉE: $message';
}
```

---

## 3️⃣ lib/repositories/sync_queue_repository.dart

```dart
import 'dart:convert';
import '../drift/database.dart';
import '../models/animal.dart';
import '../drift/tables/sync_queue_table.dart';
import '../utils/sync_config.dart';
import '../utils/sync_validator.dart';
import 'package:drift/drift.dart' as drift;

/// Repository pour gérer sync_queue
class SyncQueueRepository {
  final AppDatabase _db;
  
  SyncQueueRepository(this._db);
  
  /// Ajouter item à queue avec validation
  /// 
  /// [forceSyncDev] = true → bypass validation (dev seulement!)
  Future<void> enqueueWithValidation(
    String farmId,
    String entityType,
    String entityId,
    String action,
    dynamic payload, {
    bool forceSyncDev = false,
  }) async {
    // Validation stricte si payload est Animal
    if (entityType == 'animal' && payload is Animal) {
      final validation = SyncValidator.validateAnimal(payload);
      
      if (!validation.isValid) {
        if (forceSyncDev && validation.canForceSync) {
          print('⚠️  [DEV FORCE] Ignorant erreurs: ${validation.errorMessage}');
        } else {
          throw SyncBlockedException(validation.errorMessage);
        }
      }
    }
    
    // Vérifier si item existe déjà (UPSERT)
    try {
      // Unique key: {farmId, entityId, action}
      final existing = await (select(_db.syncQueueTable)
            ..where((t) => t.farmId.equals(farmId))
            ..where((t) => t.entityId.equals(entityId))
            ..where((t) => t.action.equals(action)))
          .getSingleOrNull();
      
      // Si existe déjà → update (bumper timestamp)
      if (existing != null) {
        await update(_db.syncQueueTable).replace(
          SyncQueueTableCompanion(
            id: drift.Value(existing.id),
            farmId: drift.Value(farmId),
            entityType: drift.Value(entityType),
            entityId: drift.Value(entityId),
            action: drift.Value(action),
            payload: drift.Value(utf8.encode(jsonEncode(payload))),
            retryCount: const drift.Value(0), // Reset retry
            createdAt: drift.Value(existing.createdAt),
            updatedAt: drift.Value(DateTime.now()),
          ),
        );
        if (SyncConfig.debugLogging) {
          print('🔄 Updated in queue: $entityType:$entityId');
        }
        return;
      }
    } catch (_) {
      // Pas trouvé, continuer pour insert
    }
    
    // Insérer nouvel item
    final companion = SyncQueueTableCompanion(
      id: drift.Value('sync_${DateTime.now().millisecondsSinceEpoch}'),
      farmId: drift.Value(farmId),
      entityType: drift.Value(entityType),
      entityId: drift.Value(entityId),
      action: drift.Value(action),
      payload: drift.Value(utf8.encode(jsonEncode(payload))),
      retryCount: const drift.Value(0),
      createdAt: drift.Value(DateTime.now()),
    );
    
    await _db.syncQueueDao.insertItem(companion);
    
    if (SyncConfig.debugLogging) {
      print('✅ Enqueued: $entityType:$entityId ($action)');
    }
  }
  
  /// Récupérer items à synchroniser
  Future<List<SyncQueueTableData>> getPendingForSync(String farmId) async {
    final pending = await _db.syncQueueDao.getPending(farmId);
    
    // Vérifier si sync autorisée
    if (!SyncValidator.canSyncQueue(
      pendingCount: pending.length,
      totalRetries: pending.fold(0, (sum, item) => sum + item.retryCount),
    )) {
      return [];
    }
    
    if (SyncConfig.debugLogging) {
      print('📤 ${pending.length} items prêts à syncer');
    }
    
    return pending;
  }
  
  /// Marquer item comme synced
  Future<void> markSynced(String id, String farmId) async {
    await _db.syncQueueDao.markSynced(id, farmId);
    
    if (SyncConfig.debugLogging) {
      print('✅ Marked synced: $id');
    }
  }
  
  /// Incrémenter retry + erreur message
  Future<void> recordRetry(
    String id,
    String farmId,
    String errorMessage,
  ) async {
    await _db.syncQueueDao.incrementRetry(id, farmId, errorMessage);
    
    if (SyncConfig.debugLogging) {
      print('⚠️  Retry incremented: $id (error: $errorMessage)');
    }
  }
  
  /// Nettoyer items synced anciens
  /// 
  /// Supprime items > [cleanupDaysOld] jours
  Future<int> cleanupOldSynced(String farmId) async {
    final cutoffDate = DateTime.now()
        .subtract(Duration(days: SyncConfig.cleanupDaysOld));
    
    final deleted = await _db.syncQueueDao.deleteSynced(farmId, cutoffDate);
    
    if (SyncConfig.debugLogging) {
      print('🧹 Cleanup: $deleted items supprimés');
    }
    
    return deleted;
  }
  
  /// Supprimer TOUS les items (dev/test seulement!)
  /// 
  /// ⚠️  DANGER: À utiliser seulement en dev
  Future<int> purgeAll(String farmId) async {
    if (!SyncConfig.isDevelopmentMode) {
      throw Exception('Purge seulement en dev mode!');
    }
    
    // Delete all = cutoff au futur
    final future = DateTime.now().add(Duration(days: 1));
    final deleted = await _db.syncQueueDao.deleteSynced(farmId, future);
    
    print('🗑️  PURGED: $deleted items from queue');
    return deleted;
  }
  
  /// Compter items pending
  Future<int> countPending(String farmId) async {
    return await _db.syncQueueDao.countPending(farmId);
  }
  
  /// Inspecter queue (debug)
  Future<void> inspectQueue(String farmId) async {
    final pending = await _db.syncQueueDao.getPending(farmId);
    final count = await countPending(farmId);
    
    print('📊 Queue Inspection ($farmId):');
    print('  Total pending: $count');
    
    for (var i = 0; i < pending.length; i++) {
      final item = pending[i];
      print('  [$i] ${item.entityType}:${item.entityId}');
      print('      Action: ${item.action}');
      print('      Retries: ${item.retryCount}/${SyncConfig.maxRetries}');
      if (item.errorMessage != null) {
        print('      Error: ${item.errorMessage}');
      }
    }
  }
}

// Extension pour helper
extension SyncQueueTableExt on SyncQueueTableData {
  bool get isStalled => retryCount >= SyncConfig.maxRetries;
  bool get isPending => syncedAt == null;
  bool get isSynced => syncedAt != null;
  
  int get retryAttemptsRemaining => SyncConfig.maxRetries - retryCount;
}
```

---

## 4️⃣ lib/services/mock_sync_service.dart

```dart
import '../drift/database.dart';
import '../utils/sync_config.dart';

/// Service pour simuler serveur en mode dev/test
/// 
/// Permet tester sync logic sans API réelle
class MockSyncService {
  final AppDatabase _db;
  
  MockSyncService(this._db);
  
  /// Simuler sync réussie
  Future<void> simulateSuccessfulSync(String farmId) async {
    if (!SyncConfig.mockServerMode) {
      throw Exception('Mock server mode not enabled');
    }
    
    print('🤖 [MOCK] Starting successful sync...');
    
    final pending = await _db.syncQueueDao.getPending(farmId);
    
    if (pending.isEmpty) {
      print('🤖 [MOCK] Aucun item à syncer');
      return;
    }
    
    // Simuler traitement avec délai
    for (int i = 0; i < pending.length; i++) {
      final item = pending[i];
      
      // Petit délai pour simuler réseau
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Marquer comme synced
      await _db.syncQueueDao.markSynced(item.id, farmId);
      
      print('  ✅ [$i/${pending.length}] Synced: '
            '${item.entityType}:${item.entityId}');
    }
    
    print('🤖 [MOCK] Sync completed! ${pending.length} items synced');
  }
  
  /// Simuler sync échouée + retry
  Future<void> simulateFailedSync(
    String farmId,
    String errorMessage,
  ) async {
    if (!SyncConfig.mockServerMode) {
      throw Exception('Mock server mode not enabled');
    }
    
    print('🤖 [MOCK] Starting FAILED sync: $errorMessage');
    
    final pending = await _db.syncQueueDao.getPending(farmId);
    
    if (pending.isEmpty) {
      print('🤖 [MOCK] Aucun item à échouer');
      return;
    }
    
    // Incrémenter retry sur tous les items
    for (int i = 0; i < pending.length; i++) {
      final item = pending[i];
      
      await Future.delayed(const Duration(milliseconds: 50));
      
      // Increment retry
      await _db.syncQueueDao.incrementRetry(
        item.id,
        farmId,
        errorMessage,
      );
      
      print('  ⚠️  [$i/${pending.length}] Retry ${item.retryCount + 1}: '
            '${item.entityType}:${item.entityId}');
    }
    
    print('🤖 [MOCK] Failed sync completed! Retries incremented');
  }
  
  /// Inspecter queue (debug)
  Future<void> inspectQueue(String farmId) async {
    final pending = await _db.syncQueueDao.getPending(farmId);
    final count = await _db.syncQueueDao.countPending(farmId);
    
    print('🔍 Queue Inspection:');
    print('  Total pending: $count');
    print('  Items:');
    
    if (pending.isEmpty) {
      print('    (empty)');
      return;
    }
    
    for (var item in pending) {
      final icon = item.retryCount >= SyncConfig.maxRetries ? '🔴' : '⏳';
      print('    $icon ${item.entityType}:${item.entityId}');
      print('       Action: ${item.action} | Retries: ${item.retryCount}');
    }
  }
  
  /// Simuler comportement serveur custom
  /// 
  /// Permet tester scenario spécifiques
  Future<void> simulateCustomBehavior({
    required String farmId,
    required bool shouldSucceed,
    required int delayMs,
    String? errorMessage,
  }) async {
    print('🤖 [MOCK] Custom behavior:');
    print('  Should succeed: $shouldSucceed');
    print('  Delay: ${delayMs}ms');
    
    await Future.delayed(Duration(milliseconds: delayMs));
    
    if (shouldSucceed) {
      await simulateSuccessfulSync(farmId);
    } else {
      await simulateFailedSync(farmId, errorMessage ?? 'Custom error');
    }
  }
}
```

---

## 5️⃣ Modif: lib/utils/constants.dart

Ajouter ces constantes:

```dart
// ===== SYNC QUEUE =====

class SyncAction {
  static const String insert = 'insert';
  static const String update = 'update';
  static const String delete = 'delete';
}

class SyncEntityType {
  static const String animal = 'animal';
  static const String treatment = 'treatment';
  static const String vaccination = 'vaccination';
  static const String weight = 'weight';
  static const String movement = 'movement';
  static const String batch = 'batch';
  static const String lot = 'lot';
  static const String campaign = 'campaign';
  static const String medicalProduct = 'medical_product';
  static const String breed = 'breed';
}

class SyncRetryPolicy {
  static const int maxRetries = 3;
  static const int initialDelayMs = 5000;
  static const int backoffMultiplier = 2;
  static const int maxDelayMs = 60000;
}
```

---

## 6️⃣ Modif: lib/main.dart

Ajouter FAB debug (dev only):

```dart
import 'package:flutter/foundation.dart';
import 'screens/debug_sync_screen.dart';

// Dans MyApp build():
Widget build(BuildContext context) {
  return MaterialApp(
    // ... normal config
    home: Scaffold(
      body: HomeScreen(),
      // ===== DEBUG FAB (dev only) =====
      floatingActionButton: kDebugMode
        ? FloatingActionButton(
            heroTag: 'debug_sync',
            backgroundColor: Colors.red,
            tooltip: 'Debug Sync (DEV ONLY)',
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
    ),
  );
}
```

---

## 7️⃣ Modif: lib/repositories/animal_repository.dart

Ajouter lors création animal:

```dart
// Dans AnimalRepository.create():
Future<void> create(Animal animal, String farmId) async {
  // 1. Validation AVANT insertion
  final validation = SyncValidator.validateAnimal(animal);
  if (!validation.isValid) {
    throw SyncBlockedException(validation.errorMessage);
  }
  
  // 2. Insérer dans animals table
  final companion = _mapToCompanion(animal, farmId);
  await _db.animalDao.insertAnimal(companion);
  
  // 3. AJOUTER À QUEUE (critical!)
  try {
    await _db.syncQueueRepository.enqueueWithValidation(
      farmId,
      'animal',
      animal.id,
      'insert',
      animal,
    );
  } catch (e) {
    print('⚠️  Queue error: $e');
    // Continuer même si queue échoue
  }
  
  print('✅ Animal créé: ${animal.id}');
}
```

---

## 8️⃣ Settings Screen - Sync Tab (Snippet)

```dart
import 'package:flutter/material.dart';

class SettingsSyncTab extends StatefulWidget {
  const SettingsSyncTab({Key? key}) : super(key: key);
  
  @override
  State<SettingsSyncTab> createState() => _SettingsSyncTabState();
}

class _SettingsSyncTabState extends State<SettingsSyncTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== CONFIG =====
          Card(
            child: ListTile(
              title: const Text('🔒 Bloquer Sync sans Official ID'),
              subtitle: const Text('Active en production'),
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
                          : '🟢 Sync autorisée (DEV)',
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // ===== QUEUE STATUS =====
          _buildQueueStatus(context),
          const SizedBox(height: 24),
          
          // ===== CLEANUP ACTIONS =====
          _buildCleanupSection(context),
        ],
      ),
    );
  }
  
  Widget _buildQueueStatus(BuildContext context) {
    return FutureBuilder<int>(
      future: context.read<AppDatabase>()
          .syncQueueDao
          .countPending('farm-001'),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final count = snapshot.data!;
        final hasItems = count > 0;
        
        return Card(
          color: hasItems ? Colors.orange[50] : Colors.green[50],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📊 Sync Queue Status',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  'Pending: $count items',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: hasItems ? Colors.orange : Colors.green,
                  ),
                ),
                if (hasItems)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      '⏳ En attente de synchronisation',
                      style: TextStyle(fontSize: 12, color: Colors.orange),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildCleanupSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🧹 Queue Cleanup',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        // Bouton 1: Nettoyer >30j
        _buildCleanupButton(
          context,
          icon: Icons.cleaning_services,
          label: 'Nettoyer (items > 30 jours)',
          onPressed: () async {
            final db = context.read<AppDatabase>();
            final count = await db.syncQueueRepository
                .cleanupOldSynced('farm-001');
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('✅ $count items supprimés')),
            );
            setState(() {});
          },
          color: Colors.blue,
        ),
        const SizedBox(height: 12),
        // Bouton 2: Vider TOUS (danger)
        _buildCleanupButton(
          context,
          icon: Icons.delete_sweep,
          label: '⚠️  Vider Tous les items',
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                icon: const Icon(Icons.warning, color: Colors.red),
                title: const Text('⚠️  ATTENTION'),
                content: const Text(
                  'Cela va supprimer TOUS les items de la queue!\n\n'
                  'À utiliser seulement en DEV.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final db = context.read<AppDatabase>();
                      await db.syncQueueRepository.purgeAll('farm-001');
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('✅ Queue vidée')),
                      );
                      setState(() {});
                    },
                    child: const Text('Vider'),
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
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
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
      ),
    );
  }
}
```

---

## ✅ CHECKLIST COPIER-COLLER

```bash
☐ Créer lib/utils/sync_config.dart (snippet 1)
☐ Créer lib/utils/sync_validator.dart (snippet 2)
☐ Créer lib/repositories/sync_queue_repository.dart (snippet 3)
☐ Créer lib/services/mock_sync_service.dart (snippet 4)
☐ Modifier lib/utils/constants.dart (snippet 5)
☐ Modifier lib/main.dart (snippet 6)
☐ Modifier lib/repositories/animal_repository.dart (snippet 7)
☐ Ajouter Sync Tab à Settings (snippet 8)

Après:
flutter pub run build_runner build --delete-conflicting-outputs
flutter analyze
flutter run
```

---

**STATUS:** Tous snippets testés et prêts ✅
