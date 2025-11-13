# PHASE 1: SQLITE LOCAL PERSISTENCE - IMPLEMENTATION GUIDE

**Version:** 1.0  
**Date:** 2025-11-09  
**Status:** Ready for Implementation  
**Objective:** Replace in-memory Provider lists with SQLite persistence via Drift ORM

---

## 📚 TABLE OF CONTENTS

1. [Introduction & Context](#1-introduction--context)
2. [Règles de Développement Drift](#2-règles-de-développement-drift)
3. [Cohérence Globale & Dépendances](#3-cohérence-globale--dépendances)
4. [Phase 1A - Foundation (Animals)](#4-phase-1a---foundation-animals)
5. [Phase 1B - Expand (Remaining Tables)](#5-phase-1b---expand-remaining-tables)
6. [Phase 1C - Polish](#6-phase-1c---polish)
7. [Validation Finale](#7-validation-finale)
8. [Troubleshooting](#8-troubleshooting)

---

## 1. INTRODUCTION & CONTEXT

### 1.1 Project State
```
BEFORE (Phase 0 - Current):
  UI → Providers → Mock Lists (in-memory)
  Data lost on app restart

AFTER (Phase 1 - Target):
  UI → Providers → Repository → DAO → SQLite
  Data persists locally
```

### 1.2 Key Principle
**"Write Once, Integrate Later"**
- Repository layer = easy to add SyncService Phase 2
- DAO queries support farmId filtering
- sync_queue table exists (Phase 2 ready)
- No refactoring when adding sync

### 1.3 Tech Stack
- **ORM:** Drift (formerly Moor)
- **Database:** SQLite (built-in mobile)
- **Pattern:** Repository → DAO → SQLite

### 1.4 Project Structure Reference
```
/mnt/project/
├── models/              (Animal, Treatment, etc.)
├── providers/           (AnimalProvider, TreatmentProvider, etc.)
├── mock_data.dart       (Central mock data)
├── mock_animals.dart    (Animal mock data)
├── mock_treatments.dart (Treatment mock data)
└── ... other mock files

NEW in Phase 1:
├── drift/
│   ├── database.dart    (Main database)
│   ├── tables/          (Table definitions)
│   │   ├── animals_table.dart
│   │   ├── treatments_table.dart
│   │   └── ...
│   └── daos/            (Data Access Objects)
│       ├── animal_dao.dart
│       ├── treatment_dao.dart
│       └── ...
└── repositories/        (Business logic layer)
    ├── animal_repository.dart
    ├── treatment_repository.dart
    └── ...
```

### 1.5 Existing Rules to Respect
- ✅ I18n system (12 critical rules)
- ✅ Constants (no hardcoded values)
- ✅ Provider architecture
- ✅ Mock data organization
- ✅ farmId filtering everywhere

---

## 2. RÈGLES DE DÉVELOPPEMENT DRIFT

### 2.1 Table Definition Pattern (OBLIGATOIRE)

```dart
// drift/tables/xxx_table.dart
import 'package:drift/drift.dart';

class XxxTable extends Table {
  // Primary key
  TextColumn get id => text()();
  
  // farmId OBLIGATOIRE (multi-tenancy)
  TextColumn get farmId => text().named('farm_id')();
  
  // Business fields
  TextColumn get name => text()();
  // ... autres champs
  
  // Sync fields (Phase 2 ready)
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable().named('last_synced_at')();
  IntColumn get serverVersion => integer().nullable().named('server_version')();
  
  // Soft-delete (audit trail)
  DateTimeColumn get deletedAt => dateTime().nullable().named('deleted_at')();
  
  // Timestamps
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  
  @override
  Set<Column> get primaryKey => {id};
  
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (farm_id) REFERENCES farms(id)',
  ];
}
```

### 2.2 DAO Pattern (OBLIGATOIRE)

```dart
// drift/daos/xxx_dao.dart
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/xxx_table.dart';

part 'xxx_dao.g.dart';

@DriftAccessor(tables: [XxxTable])
class XxxDao extends DatabaseAccessor<AppDatabase> with _$XxxDaoMixin {
  XxxDao(AppDatabase db) : super(db);
  
  // MÉTHODES OBLIGATOIRES :
  
  // 1. findByFarmId - TOUJOURS filtrer par farmId
  Future<List<XxxTableData>> findByFarmId(String farmId) {
    return (select(xxxTable)
      ..where((t) => t.farmId.equals(farmId))
      ..where((t) => t.deletedAt.isNull()))
      .get();
  }
  
  // 2. findById - Sécurité farmId
  Future<XxxTableData?> findById(String id, String farmId) {
    return (select(xxxTable)
      ..where((t) => t.id.equals(id))
      ..where((t) => t.farmId.equals(farmId))
      ..where((t) => t.deletedAt.isNull()))
      .getSingleOrNull();
  }
  
  // 3. insert - Créer avec farmId
  Future<int> insertItem(XxxTableCompanion item) {
    return into(xxxTable).insert(item);
  }
  
  // 4. update - Vérifier farmId
  Future<bool> updateItem(XxxTableCompanion item) {
    return update(xxxTable).replace(item);
  }
  
  // 5. softDelete - Soft-delete (pas hard delete)
  Future<int> softDelete(String id, String farmId) {
    return (update(xxxTable)
      ..where((t) => t.id.equals(id))
      ..where((t) => t.farmId.equals(farmId)))
      .write(XxxTableCompanion(
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ));
  }
  
  // 6. getUnsynced - Phase 2 ready
  Future<List<XxxTableData>> getUnsynced(String farmId) {
    return (select(xxxTable)
      ..where((t) => t.farmId.equals(farmId))
      ..where((t) => t.synced.equals(false))
      ..where((t) => t.deletedAt.isNull()))
      .get();
  }
  
  // 7. markSynced - Phase 2 ready
  Future<int> markSynced(String id, String farmId) {
    return (update(xxxTable)
      ..where((t) => t.id.equals(id))
      ..where((t) => t.farmId.equals(farmId)))
      .write(XxxTableCompanion(
        synced: const Value(true),
        lastSyncedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ));
  }
}
```

### 2.3 Repository Pattern (OBLIGATOIRE)

```dart
// repositories/xxx_repository.dart
import '../drift/database.dart';
import '../models/xxx.dart';

class XxxRepository {
  final AppDatabase _db;
  
  XxxRepository(this._db);
  
  // MÉTHODES OBLIGATOIRES :
  
  // 1. getAll - Liste par farmId
  Future<List<Xxx>> getAll(String farmId) async {
    final items = await _db.xxxDao.findByFarmId(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }
  
  // 2. getById - Sécurité farmId
  Future<Xxx?> getById(String id, String farmId) async {
    final item = await _db.xxxDao.findById(id, farmId);
    if (item == null) return null;
    
    // Security check
    if (item.farmId != farmId) {
      throw Exception('Farm ID mismatch - Security violation');
    }
    
    return _mapToModel(item);
  }
  
  // 3. create - Créer avec farmId
  Future<void> create(Xxx item, String farmId) async {
    final companion = _mapToCompanion(item, farmId);
    await _db.xxxDao.insertItem(companion);
  }
  
  // 4. update - Vérifier farmId
  Future<void> update(Xxx item, String farmId) async {
    // Security check
    final existing = await _db.xxxDao.findById(item.id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Item not found or farm mismatch');
    }
    
    final companion = _mapToCompanion(item, farmId);
    await _db.xxxDao.updateItem(companion);
  }
  
  // 5. delete - Soft-delete
  Future<void> delete(String id, String farmId) async {
    await _db.xxxDao.softDelete(id, farmId);
  }
  
  // 6. getUnsynced - Phase 2 ready
  Future<List<Xxx>> getUnsynced(String farmId) async {
    final items = await _db.xxxDao.getUnsynced(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }
  
  // MAPPERS
  Xxx _mapToModel(XxxTableData data) {
    return Xxx(
      id: data.id,
      farmId: data.farmId,
      // ... autres champs
      synced: data.synced,
      lastSyncedAt: data.lastSyncedAt,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }
  
  XxxTableCompanion _mapToCompanion(Xxx item, String farmId) {
    return XxxTableCompanion(
      id: Value(item.id),
      farmId: Value(farmId),
      // ... autres champs
      synced: Value(item.synced),
      lastSyncedAt: Value(item.lastSyncedAt),
      createdAt: Value(item.createdAt),
      updatedAt: Value(item.updatedAt),
    );
  }
}
```

### 2.4 Conventions de Nommage

**Tables:**
- Nom: PascalCase + "Table" → `AnimalsTable`, `TreatmentsTable`
- Fichier: snake_case → `animals_table.dart`, `treatments_table.dart`

**DAOs:**
- Nom: PascalCase + "Dao" → `AnimalDao`, `TreatmentDao`
- Fichier: snake_case → `animal_dao.dart`, `treatment_dao.dart`

**Repositories:**
- Nom: PascalCase + "Repository" → `AnimalRepository`
- Fichier: snake_case → `animal_repository.dart`

**Colonnes SQL:**
- snake_case → `farm_id`, `created_at`, `last_synced_at`

### 2.5 Erreurs à Éviter

❌ **Oublier farmId filtering**
```dart
// MAUVAIS
Future<List<Animal>> getAll() {
  return select(animals).get(); // ❌ Data leakage !
}

// BON
Future<List<Animal>> getAll(String farmId) {
  return (select(animals)
    ..where((t) => t.farmId.equals(farmId)))
    .get();
}
```

❌ **Hard-delete au lieu de soft-delete**
```dart
// MAUVAIS
await delete(animals).delete(item); // ❌ Perte audit trail !

// BON
await (update(animals)
  ..where((t) => t.id.equals(id)))
  .write(AnimalsCompanion(deletedAt: Value(DateTime.now())));
```

❌ **Oublier deleted_at dans queries**
```dart
// MAUVAIS
select(animals).get(); // ❌ Affiche items supprimés !

// BON
(select(animals)
  ..where((t) => t.deletedAt.isNull()))
  .get();
```

---

## 3. COHÉRENCE GLOBALE & DÉPENDANCES

### 3.1 Ordre d'Implémentation (CRITIQUE)

**Respecter les Foreign Keys pour éviter erreurs !**

```
📦 NIVEAU 0: Standalone (pas de FK)
  └── farms

📦 NIVEAU 1: Référentielles (FK simples)
  ├── species
  ├── breeds (FK → species)
  ├── medical_products
  ├── vaccines
  └── veterinarians

📦 NIVEAU 2: Tables principales (FK → Niveau 1)
  ├── animals (FK → breeds, farms)
  ├── treatments (FK → animals, medical_products)
  ├── vaccinations (FK → animals, vaccines)
  ├── weights (FK → animals)
  └── movements (FK → animals)

📦 NIVEAU 3: Tables complexes
  ├── batches (JSON animal_ids)
  ├── lots (JSON animal_ids)
  └── campaigns

📦 NIVEAU 4: Sync
  └── sync_queue
```

### 3.2 Patterns Obligatoires Partout

✅ **farmId filtering** dans TOUS les DAOs  
✅ **Indexes** (farmId + colonnes critiques)  
✅ **Soft-delete** (deleted_at)  
✅ **Sync fields** (synced, lastSyncedAt, serverVersion)  
✅ **Timestamps** (createdAt, updatedAt)  
✅ **Repository security check** (farmId match)

### 3.3 Vérifications Croisées

Avant de passer à Phase 1C :
- [ ] Toutes les Foreign Keys valides
- [ ] Tous les indexes créés
- [ ] Toutes les méthodes DAO identiques (getAll, getById, etc.)
- [ ] Tous les Repositories ont security checks
- [ ] Aucun hardcoded string (constantes + i18n)

---

## 4. PHASE 1A - FOUNDATION (ANIMALS)

**Objectif:** Valider le pattern complet avec 1 table (Animals)  
**Durée estimée:** 1-2 sessions  
**Validation:** Pattern fonctionne = GO pour Phase 1B

---

### PHASE 1A - STEP 1: Setup Drift Dependencies

📁 **FICHIERS REQUIS**
- Aucun (modification pubspec.yaml)

📋 **OBJECTIF**
Ajouter Drift + SQLite dependencies au projet

📝 **MODIFICATIONS pubspec.yaml**

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  # ... autres dépendances existantes ...
  
  # AJOUTER :
  drift: ^2.14.0
  sqlite3_flutter_libs: ^0.5.18
  path_provider: ^2.1.1
  path: ^1.8.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  # ... autres dev dependencies ...
  
  # AJOUTER :
  drift_dev: ^2.14.0
  build_runner: ^2.4.6
```

📝 **CONSTANTES**
Aucune

📝 **I18N - CLÉS**
Aucune

📝 **I18N - TRADUCTIONS FR**
Aucune

⚡ **COMMANDES**
```bash
flutter pub get
```

✅ **VALIDATION**
- `flutter pub get` réussit sans erreurs
- Packages installés dans pubspec.lock
- Pas d'erreurs de dépendances

🚀 **NEXT**
Phase 1A Step 2

---

### PHASE 1A - STEP 2: Create Database Main File

📁 **FICHIERS REQUIS**
- Aucun (création nouveau fichier)

📋 **OBJECTIF**
Créer le fichier principal Drift database

📝 **CODE COMPLET**

Créer fichier: `lib/drift/database.dart`

```dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Tables imports (à ajouter au fur et à mesure)
import 'tables/animals_table.dart';

// DAOs imports (à ajouter au fur et à mesure)
import 'daos/animal_dao.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    AnimalsTable,
    // Autres tables ajoutées progressivement
  ],
  daos: [
    AnimalDao,
    // Autres DAOs ajoutés progressivement
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      
      // Enable foreign keys
      await customStatement('PRAGMA foreign_keys = ON;');
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Migrations futures ici
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'animal_trace.db'));
    return NativeDatabase(file);
  });
}
```

📝 **CONSTANTES**

Créer/Modifier fichier: `lib/utils/constants.dart`

```dart
// DATABASE
class DatabaseConstants {
  static const String dbName = 'animal_trace.db';
  static const int schemaVersion = 1;
}
```

📝 **I18N - CLÉS**
Aucune (pas d'UI pour l'instant)

📝 **I18N - TRADUCTIONS FR**
Aucune

⚡ **COMMANDES**
Aucune (attendre Step 4 pour build_runner)

✅ **VALIDATION**
- Fichier `lib/drift/database.dart` créé
- Pas d'erreurs de compilation (imports en rouge c'est normal, tables pas encore créées)
- Constantes dans `lib/utils/constants.dart`

🚀 **NEXT**
Phase 1A Step 3

---

### PHASE 1A - STEP 3: Create Animals Table Definition

📁 **FICHIERS REQUIS**
- `/mnt/project/models/animal.dart` (pour voir les champs)

📋 **OBJECTIF**
Créer la définition Drift de la table animals avec tous les champs requis

📝 **CODE COMPLET**

Créer fichier: `lib/drift/tables/animals_table.dart`

```dart
import 'package:drift/drift.dart';

class AnimalsTable extends Table {
  @override
  String get tableName => 'animals';

  // Primary key
  TextColumn get id => text()();

  // Multi-tenancy
  TextColumn get farmId => text().named('farm_id')();

  // Species & Breed
  TextColumn get speciesId => text().named('species_id')();
  TextColumn get breedId => text().nullable().named('breed_id')();

  // Identifications
  TextColumn get currentEid => text().nullable().named('current_eid')();
  TextColumn get officialNumber => text().nullable().named('official_number')();
  TextColumn get visualId => text().nullable().named('visual_id')();

  // Biological data
  DateTimeColumn get birthDate => dateTime().nullable().named('birth_date')();
  TextColumn get sex => text()(); // 'male' or 'female'
  TextColumn get motherId => text().nullable().named('mother_id')();

  // Status
  TextColumn get status => text()(); // 'alive', 'sold', 'dead', 'slaughtered'

  // Sync fields (Phase 2 ready)
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable().named('last_synced_at')();
  IntColumn get serverVersion => integer().nullable().named('server_version')();

  // Soft-delete
  DateTimeColumn get deletedAt => dateTime().nullable().named('deleted_at')();

  // Timestamps
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (farm_id) REFERENCES farms(id)',
    'FOREIGN KEY (mother_id) REFERENCES animals(id)',
    'FOREIGN KEY (breed_id) REFERENCES breeds(id)',
  ];
}
```

📝 **CONSTANTES**

Ajouter dans `lib/utils/constants.dart`:

```dart
// ANIMAL STATUS
class AnimalStatus {
  static const String alive = 'alive';
  static const String sold = 'sold';
  static const String dead = 'dead';
  static const String slaughtered = 'slaughtered';
}

// ANIMAL SEX
class AnimalSex {
  static const String male = 'male';
  static const String female = 'female';
}
```

📝 **I18N - CLÉS**
Aucune (table backend uniquement)

📝 **I18N - TRADUCTIONS FR**
Aucune

⚡ **COMMANDES**
Aucune (attendre Step 4 pour build_runner)

✅ **VALIDATION**
- Fichier `lib/drift/tables/animals_table.dart` créé
- Pas d'erreurs de compilation
- Constantes ajoutées dans constants.dart

🚀 **NEXT**
Phase 1A Step 4

---

### PHASE 1A - STEP 4: Generate Drift Code (First Build)

📁 **FICHIERS REQUIS**
- Aucun (utilise fichiers créés Steps 2-3)

📋 **OBJECTIF**
Générer les fichiers Drift (.g.dart) avec build_runner

📝 **CODE COMPLET**
Aucun (commande seulement)

📝 **CONSTANTES**
Aucune

📝 **I18N - CLÉS**
Aucune

📝 **I18N - TRADUCTIONS FR**
Aucune

⚡ **COMMANDES**
```bash
# Nettoyer les builds précédents (si existe)
flutter clean

# Regénérer
flutter pub get

# Build runner
flutter pub run build_runner build --delete-conflicting-outputs
```

✅ **VALIDATION**
- Fichier `lib/drift/database.g.dart` généré
- Classe `AnimalsTableData` existe dans database.g.dart
- Classe `AnimalsTableCompanion` existe dans database.g.dart
- Pas d'erreurs de compilation
- Warnings "missing DAO" normaux (Step 5 va les créer)

⚠️ **ERREURS POSSIBLES**

**Erreur:** `Could not resolve annotation`
```bash
Solution:
1. Vérifier imports dans database.dart
2. Supprimer .dart_tool/ et build/
3. Relancer flutter pub get
4. Relancer build_runner
```

**Erreur:** `Conflicting outputs`
```bash
Solution:
Utiliser --delete-conflicting-outputs
```

🚀 **NEXT**
Phase 1A Step 5

---

### PHASE 1A - STEP 5: Create AnimalDao

📁 **FICHIERS REQUIS**
- Aucun (utilise database.g.dart généré)

📋 **OBJECTIF**
Créer le DAO (Data Access Object) pour les opérations CRUD sur animals

📝 **CODE COMPLET**

Créer fichier: `lib/drift/daos/animal_dao.dart`

```dart
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/animals_table.dart';

part 'animal_dao.g.dart';

@DriftAccessor(tables: [AnimalsTable])
class AnimalDao extends DatabaseAccessor<AppDatabase> with _$AnimalDaoMixin {
  AnimalDao(AppDatabase db) : super(db);

  // 1. Get all animals by farmId
  Future<List<AnimalsTableData>> findByFarmId(String farmId) {
    return (select(animalsTable)
      ..where((t) => t.farmId.equals(farmId))
      ..where((t) => t.deletedAt.isNull()))
      .get();
  }

  // 2. Get animal by ID (with farmId security)
  Future<AnimalsTableData?> findById(String id, String farmId) {
    return (select(animalsTable)
      ..where((t) => t.id.equals(id))
      ..where((t) => t.farmId.equals(farmId))
      ..where((t) => t.deletedAt.isNull()))
      .getSingleOrNull();
  }

  // 3. Get animal by EID
  Future<AnimalsTableData?> findByEid(String eid, String farmId) {
    return (select(animalsTable)
      ..where((t) => t.currentEid.equals(eid))
      ..where((t) => t.farmId.equals(farmId))
      ..where((t) => t.deletedAt.isNull()))
      .getSingleOrNull();
  }

  // 4. Get animals by status
  Future<List<AnimalsTableData>> findByStatus(String status, String farmId) {
    return (select(animalsTable)
      ..where((t) => t.farmId.equals(farmId))
      ..where((t) => t.status.equals(status))
      ..where((t) => t.deletedAt.isNull()))
      .get();
  }

  // 5. Search animals (by EID, visual ID, official number)
  Future<List<AnimalsTableData>> searchAnimals(String query, String farmId) {
    return (select(animalsTable)
      ..where((t) => t.farmId.equals(farmId))
      ..where((t) => 
        t.currentEid.like('%$query%') |
        t.visualId.like('%$query%') |
        t.officialNumber.like('%$query%')
      )
      ..where((t) => t.deletedAt.isNull()))
      .get();
  }

  // 6. Insert animal
  Future<int> insertAnimal(AnimalsTableCompanion animal) {
    return into(animalsTable).insert(animal);
  }

  // 7. Update animal
  Future<bool> updateAnimal(AnimalsTableCompanion animal) {
    return update(animalsTable).replace(animal);
  }

  // 8. Soft-delete animal
  Future<int> softDeleteAnimal(String id, String farmId) {
    return (update(animalsTable)
      ..where((t) => t.id.equals(id))
      ..where((t) => t.farmId.equals(farmId)))
      .write(AnimalsTableCompanion(
        deletedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ));
  }

  // 9. Get unsynced animals (Phase 2 ready)
  Future<List<AnimalsTableData>> getUnsynced(String farmId) {
    return (select(animalsTable)
      ..where((t) => t.farmId.equals(farmId))
      ..where((t) => t.synced.equals(false))
      ..where((t) => t.deletedAt.isNull()))
      .get();
  }

  // 10. Mark animal as synced (Phase 2 ready)
  Future<int> markSynced(String id, String farmId) {
    return (update(animalsTable)
      ..where((t) => t.id.equals(id))
      ..where((t) => t.farmId.equals(farmId)))
      .write(AnimalsTableCompanion(
        synced: const Value(true),
        lastSyncedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ));
  }

  // 11. Count animals by farmId
  Future<int> countByFarmId(String farmId) {
    final query = selectOnly(animalsTable)
      ..addColumns([animalsTable.id.count()])
      ..where(animalsTable.farmId.equals(farmId))
      ..where(animalsTable.deletedAt.isNull());
    
    return query.map((row) => row.read(animalsTable.id.count())!).getSingle();
  }
}
```

📝 **CONSTANTES**
Aucune (déjà dans Step 3)

📝 **I18N - CLÉS**
Aucune

📝 **I18N - TRADUCTIONS FR**
Aucune

⚡ **COMMANDES**
```bash
# Regénérer avec le nouveau DAO
flutter pub run build_runner build --delete-conflicting-outputs
```

✅ **VALIDATION**
- Fichier `lib/drift/daos/animal_dao.g.dart` généré
- Pas d'erreurs de compilation
- Classe `AnimalDao` accessible
- Méthodes `findByFarmId`, `findById`, etc. disponibles

🚀 **NEXT**
Phase 1A Step 6

---

### PHASE 1A - STEP 6: Create AnimalRepository

📁 **FICHIERS REQUIS**
- `/mnt/project/models/animal.dart`

📋 **OBJECTIF**
Créer le Repository pour la logique métier Animals (bridge entre Provider et DAO)

📝 **CODE COMPLET**

Créer fichier: `lib/repositories/animal_repository.dart`

```dart
import '../drift/database.dart';
import '../models/animal.dart';
import 'package:drift/drift.dart' as drift;

class AnimalRepository {
  final AppDatabase _db;

  AnimalRepository(this._db);

  // 1. Get all animals
  Future<List<Animal>> getAll(String farmId) async {
    final data = await _db.animalDao.findByFarmId(farmId);
    return data.map((d) => _mapToModel(d)).toList();
  }

  // 2. Get animal by ID
  Future<Animal?> getById(String id, String farmId) async {
    final data = await _db.animalDao.findById(id, farmId);
    if (data == null) return null;

    // Security check
    if (data.farmId != farmId) {
      throw Exception('Farm ID mismatch - Security violation');
    }

    return _mapToModel(data);
  }

  // 3. Get animal by EID
  Future<Animal?> getByEid(String eid, String farmId) async {
    final data = await _db.animalDao.findByEid(eid, farmId);
    return data != null ? _mapToModel(data) : null;
  }

  // 4. Get animals by status
  Future<List<Animal>> getByStatus(String status, String farmId) async {
    final data = await _db.animalDao.findByStatus(status, farmId);
    return data.map((d) => _mapToModel(d)).toList();
  }

  // 5. Search animals
  Future<List<Animal>> search(String query, String farmId) async {
    final data = await _db.animalDao.searchAnimals(query, farmId);
    return data.map((d) => _mapToModel(d)).toList();
  }

  // 6. Create animal
  Future<void> create(Animal animal, String farmId) async {
    final companion = _mapToCompanion(animal, farmId);
    await _db.animalDao.insertAnimal(companion);
  }

  // 7. Update animal
  Future<void> update(Animal animal, String farmId) async {
    // Security check
    final existing = await _db.animalDao.findById(animal.id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Animal not found or farm mismatch');
    }

    final companion = _mapToCompanion(animal, farmId);
    await _db.animalDao.updateAnimal(companion);
  }

  // 8. Delete animal (soft-delete)
  Future<void> delete(String id, String farmId) async {
    await _db.animalDao.softDeleteAnimal(id, farmId);
  }

  // 9. Get unsynced animals (Phase 2 ready)
  Future<List<Animal>> getUnsynced(String farmId) async {
    final data = await _db.animalDao.getUnsynced(farmId);
    return data.map((d) => _mapToModel(d)).toList();
  }

  // 10. Count animals
  Future<int> count(String farmId) async {
    return await _db.animalDao.countByFarmId(farmId);
  }

  // === MAPPERS ===

  Animal _mapToModel(AnimalsTableData data) {
    return Animal(
      id: data.id,
      farmId: data.farmId,
      speciesId: data.speciesId,
      breedId: data.breedId,
      currentEid: data.currentEid,
      officialNumber: data.officialNumber,
      visualId: data.visualId,
      birthDate: data.birthDate,
      sex: data.sex,
      motherId: data.motherId,
      status: data.status,
      synced: data.synced,
      lastSyncedAt: data.lastSyncedAt,
      serverVersion: data.serverVersion,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  drift.AnimalsTableCompanion _mapToCompanion(Animal animal, String farmId) {
    return drift.AnimalsTableCompanion(
      id: drift.Value(animal.id),
      farmId: drift.Value(farmId),
      speciesId: drift.Value(animal.speciesId),
      breedId: animal.breedId != null 
        ? drift.Value(animal.breedId!) 
        : const drift.Value.absent(),
      currentEid: animal.currentEid != null 
        ? drift.Value(animal.currentEid!) 
        : const drift.Value.absent(),
      officialNumber: animal.officialNumber != null 
        ? drift.Value(animal.officialNumber!) 
        : const drift.Value.absent(),
      visualId: animal.visualId != null 
        ? drift.Value(animal.visualId!) 
        : const drift.Value.absent(),
      birthDate: animal.birthDate != null 
        ? drift.Value(animal.birthDate!) 
        : const drift.Value.absent(),
      sex: drift.Value(animal.sex),
      motherId: animal.motherId != null 
        ? drift.Value(animal.motherId!) 
        : const drift.Value.absent(),
      status: drift.Value(animal.status),
      synced: drift.Value(animal.synced),
      lastSyncedAt: animal.lastSyncedAt != null 
        ? drift.Value(animal.lastSyncedAt!) 
        : const drift.Value.absent(),
      serverVersion: animal.serverVersion != null 
        ? drift.Value(animal.serverVersion!) 
        : const drift.Value.absent(),
      deletedAt: const drift.Value.absent(),
      createdAt: drift.Value(animal.createdAt),
      updatedAt: drift.Value(animal.updatedAt),
    );
  }
}
```

📝 **CONSTANTES**
Aucune

📝 **I18N - CLÉS**
Aucune

📝 **I18N - TRADUCTIONS FR**
Aucune

⚡ **COMMANDES**
Aucune (pas de génération nécessaire)

✅ **VALIDATION**
- Fichier `lib/repositories/animal_repository.dart` créé
- Pas d'erreurs de compilation
- Méthodes `getAll`, `create`, `update`, `delete` disponibles
- Security checks présents

🚀 **NEXT**
Phase 1A Step 7

---

### PHASE 1A - STEP 7: Initialize Database in main.dart

📁 **FICHIERS REQUIS**
- `/mnt/project/main.dart`

📋 **OBJECTIF**
Initialiser la database au démarrage de l'app et injecter dans les Providers

📝 **CODE COMPLET**

Modifier `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Database
import 'drift/database.dart';

// Repositories
import 'repositories/animal_repository.dart';

// Providers
import 'providers/animal_provider.dart';
// ... autres providers existants

// Reste imports existants
// ...

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  final database = AppDatabase();
  
  // Initialize repositories
  final animalRepository = AnimalRepository(database);
  
  runApp(MyApp(
    database: database,
    animalRepository: animalRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;
  final AnimalRepository animalRepository;

  const MyApp({
    super.key,
    required this.database,
    required this.animalRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Database provider (pour accès global si nécessaire)
        Provider<AppDatabase>.value(value: database),
        
        // Repositories providers
        Provider<AnimalRepository>.value(value: animalRepository),
        
        // Business providers (modifiés pour utiliser Repository)
        ChangeNotifierProvider(
          create: (_) => AnimalProvider(animalRepository),
        ),
        
        // ... autres providers existants (non modifiés pour l'instant)
      ],
      child: MaterialApp(
        title: 'Animal Trace',
        // ... reste config existante
      ),
    );
  }
}
```

📝 **CONSTANTES**
Aucune

📝 **I18N - CLÉS**
Aucune

📝 **I18N - TRADUCTIONS FR**
Aucune

⚡ **COMMANDES**
Aucune

✅ **VALIDATION**
- main.dart modifié
- Pas d'erreurs de compilation
- Database initialisée au démarrage
- Repository injecté dans Provider

🚀 **NEXT**
Phase 1A Step 8

---

### PHASE 1A - STEP 8: Integrate Repository in AnimalProvider

📁 **FICHIERS REQUIS**
- `/mnt/project/providers/animal_provider.dart`

📋 **OBJECTIF**
Modifier AnimalProvider pour utiliser Repository au lieu de mock lists

📝 **CODE COMPLET**

Modifier `lib/providers/animal_provider.dart`:

```dart
import 'package:flutter/foundation.dart';
import '../models/animal.dart';
import '../repositories/animal_repository.dart';

class AnimalProvider extends ChangeNotifier {
  final AnimalRepository _repository;

  // Current farmId (injecté depuis AuthProvider ou SettingsProvider)
  String _currentFarmId = '';

  // Cache local (pour performance UI)
  List<Animal> _animals = [];
  bool _isLoading = false;

  AnimalProvider(this._repository);

  // Getters
  List<Animal> get animals => _animals;
  bool get isLoading => _isLoading;

  // Set current farm (appelé au login ou switch farm)
  Future<void> setCurrentFarm(String farmId) async {
    if (_currentFarmId == farmId) return;
    
    _currentFarmId = farmId;
    await loadAnimals();
  }

  // Load animals from database
  Future<void> loadAnimals() async {
    if (_currentFarmId.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _animals = await _repository.getAll(_currentFarmId);
    } catch (e) {
      debugPrint('Error loading animals: $e');
      _animals = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get animal by ID
  Future<Animal?> getAnimalById(String id) async {
    if (_currentFarmId.isEmpty) return null;

    try {
      return await _repository.getById(id, _currentFarmId);
    } catch (e) {
      debugPrint('Error getting animal: $e');
      return null;
    }
  }

  // Get animal by EID
  Future<Animal?> getAnimalByEid(String eid) async {
    if (_currentFarmId.isEmpty) return null;

    try {
      return await _repository.getByEid(eid, _currentFarmId);
    } catch (e) {
      debugPrint('Error getting animal by EID: $e');
      return null;
    }
  }

  // Get animals by status
  Future<List<Animal>> getAnimalsByStatus(String status) async {
    if (_currentFarmId.isEmpty) return [];

    try {
      return await _repository.getByStatus(status, _currentFarmId);
    } catch (e) {
      debugPrint('Error getting animals by status: $e');
      return [];
    }
  }

  // Search animals
  Future<List<Animal>> searchAnimals(String query) async {
    if (_currentFarmId.isEmpty) return [];

    try {
      return await _repository.search(query, _currentFarmId);
    } catch (e) {
      debugPrint('Error searching animals: $e');
      return [];
    }
  }

  // Add animal
  Future<bool> addAnimal(Animal animal) async {
    if (_currentFarmId.isEmpty) return false;

    try {
      await _repository.create(animal, _currentFarmId);
      await loadAnimals(); // Refresh list
      return true;
    } catch (e) {
      debugPrint('Error adding animal: $e');
      return false;
    }
  }

  // Update animal
  Future<bool> updateAnimal(Animal animal) async {
    if (_currentFarmId.isEmpty) return false;

    try {
      await _repository.update(animal, _currentFarmId);
      await loadAnimals(); // Refresh list
      return true;
    } catch (e) {
      debugPrint('Error updating animal: $e');
      return false;
    }
  }

  // Delete animal
  Future<bool> deleteAnimal(String id) async {
    if (_currentFarmId.isEmpty) return false;

    try {
      await _repository.delete(id, _currentFarmId);
      await loadAnimals(); // Refresh list
      return true;
    } catch (e) {
      debugPrint('Error deleting animal: $e');
      return false;
    }
  }

  // Get animal count
  Future<int> getAnimalCount() async {
    if (_currentFarmId.isEmpty) return 0;

    try {
      return await _repository.count(_currentFarmId);
    } catch (e) {
      debugPrint('Error counting animals: $e');
      return 0;
    }
  }

  // Get unsynced animals (Phase 2 ready)
  Future<List<Animal>> getUnsyncedAnimals() async {
    if (_currentFarmId.isEmpty) return [];

    try {
      return await _repository.getUnsynced(_currentFarmId);
    } catch (e) {
      debugPrint('Error getting unsynced animals: $e');
      return [];
    }
  }

  // Refresh (pull-to-refresh)
  Future<void> refresh() async {
    await loadAnimals();
  }
}
```

📝 **CONSTANTES**
Aucune

📝 **I18N - CLÉS**
Aucune (erreurs en debug seulement)

📝 **I18N - TRADUCTIONS FR**
Aucune

⚡ **COMMANDES**
Aucune

✅ **VALIDATION**
- AnimalProvider modifié
- Plus de mock lists en mémoire
- Utilise Repository pour toutes opérations
- Méthodes async correctes
- Pas d'erreurs de compilation

🚀 **NEXT**
Phase 1A Step 9

---

### PHASE 1A - STEP 9: Test Animals Table (Manual Validation)

📁 **FICHIERS REQUIS**
- Aucun (test manuel de l'app)

📋 **OBJECTIF**
Valider que Animals table fonctionne correctement avec SQLite

📝 **CODE COMPLET**
Aucun (tests manuels)

📝 **CONSTANTES**
Aucune

📝 **I18N - CLÉS**
Aucune

📝 **I18N - TRADUCTIONS FR**
Aucune

⚡ **COMMANDES**
```bash
# Lancer l'app
flutter run

# OU sur émulateur spécifique
flutter run -d <device_id>
```

✅ **VALIDATION CHECKLIST**

**1. App Démarrage**
- [ ] App démarre sans crash
- [ ] Database initialisée (pas d'erreurs console)
- [ ] animal_trace.db créé dans app documents

**2. Liste Animals (si écran existe)**
- [ ] Liste vide au démarrage (database vide)
- [ ] Pas d'erreurs affichées

**3. Créer Animal (si formulaire existe)**
- [ ] Formulaire s'ouvre
- [ ] Sauvegarder animal → succès
- [ ] Animal apparaît dans liste

**4. Persistence**
- [ ] Fermer app
- [ ] Relancer app
- [ ] Animal créé est toujours là (persisted!)

**5. CRUD Operations**
- [ ] Modifier animal → succès
- [ ] Supprimer animal → soft-delete fonctionne
- [ ] Animal disparu de liste (deleted_at != null)

**6. Logs Console**
- [ ] Pas d'erreurs SQL
- [ ] Pas de farmId mismatch errors
- [ ] Queries exécutées correctement

⚠️ **ERREURS POSSIBLES**

**Erreur:** `Table animals doesn't exist`
```
Solution:
1. Supprimer app de l'émulateur
2. Relancer flutter run (database recréée)
```

**Erreur:** `Farm ID mismatch`
```
Solution:
1. Vérifier que _currentFarmId est set dans Provider
2. Vérifier que setCurrentFarm() est appelé au démarrage
```

**Erreur:** `Null check operator used on a null value`
```
Solution:
1. Vérifier que nullable fields ont .nullable() dans table
2. Vérifier que mappers gèrent les nulls
```

🚀 **NEXT**
Phase 1A Step 10 (si validation OK)  
Sinon: Debug et revenir à Step précédent

---

### PHASE 1A - STEP 10: Pattern Validation & Phase 1B Preparation

📁 **FICHIERS REQUIS**
- Aucun (analyse du pattern)

📋 **OBJECTIF**
Valider que le pattern Animals fonctionne et documenter les learnings pour Phase 1B

📝 **PATTERN VALIDATION CHECKLIST**

**✅ Table Definition**
- [ ] Tous les champs requis présents
- [ ] farmId filtering présent
- [ ] Sync fields présents (synced, lastSyncedAt, serverVersion)
- [ ] Soft-delete présent (deletedAt)
- [ ] Timestamps présents (createdAt, updatedAt)
- [ ] Foreign keys définis
- [ ] Primary key correct

**✅ DAO**
- [ ] findByFarmId() filtre par farmId + deletedAt
- [ ] findById() security check (farmId + deletedAt)
- [ ] insert, update fonctionnent
- [ ] softDelete() utilise deletedAt
- [ ] getUnsynced() présent (Phase 2 ready)
- [ ] markSynced() présent (Phase 2 ready)

**✅ Repository**
- [ ] Méthodes business logic claires
- [ ] Security checks sur getById, update
- [ ] Mappers _mapToModel / _mapToCompanion fonctionnent
- [ ] Gestion nullable fields correcte
- [ ] farmId passé partout

**✅ Provider**
- [ ] Plus de mock lists
- [ ] Utilise Repository pour toutes opérations
- [ ] _currentFarmId géré correctement
- [ ] loadAnimals() fonctionne
- [ ] CRUD operations fonctionnent
- [ ] notifyListeners() aux bons endroits

**✅ Integration**
- [ ] Database initialisée dans main.dart
- [ ] Repository injecté dans Provider
- [ ] Provider accessible dans UI
- [ ] Pas de regressions UI

📝 **LEARNINGS & AJUSTEMENTS**

Noter ici les points à ajuster pour Phase 1B:

```
✅ Ce qui a bien fonctionné:
- [À compléter après tests]

⚠️ Problèmes rencontrés:
- [À compléter après tests]

📝 Ajustements nécessaires:
- [À compléter après tests]
```

📝 **CONSTANTES**
Aucune

📝 **I18N - CLÉS**
Aucune

📝 **I18N - TRADUCTIONS FR**
Aucune

⚡ **COMMANDES**
Aucune

✅ **VALIDATION**
- [ ] Pattern Animals validé à 100%
- [ ] Aucune régression UI
- [ ] Database fonctionne correctement
- [ ] Documentation learnings complète

🚀 **NEXT**
**SI VALIDATION OK:** Phase 1B Step 1 (Farms Table)  
**SI VALIDATION KO:** Corriger problèmes Phase 1A avant de continuer

---

## 5. PHASE 1B - EXPAND (REMAINING TABLES)

**Objectif:** Appliquer le pattern validé × toutes les tables restantes  
**Durée estimée:** 3-5 sessions  
**Ordre:** Respecter dépendances Foreign Keys

---

### 🏗️ PHASE 1B ARCHITECTURE

**Ordre d'implémentation (CRITIQUE):**

```
Phase 1B.1: Standalone & Referential Tables
  Step 1-6:   Farms Table
  Step 7-12:  Species Table
  Step 13-18: Breeds Table (FK → species)
  Step 19-24: MedicalProducts Table
  Step 25-30: Vaccines Table
  Step 31-36: Veterinarians Table

Phase 1B.2: Main Data Tables (depend on 1B.1)
  Step 37-42: Treatments Table (FK → animals, medical_products)
  Step 43-48: Vaccinations Table (FK → animals, vaccines)
  Step 49-54: Weights Table (FK → animals)
  Step 55-60: Movements Table (FK → animals)

Phase 1B.3: Complex Tables
  Step 61-66: Batches Table (JSON animal_ids)
  Step 67-72: Lots Table (JSON animal_ids)
  Step 73-78: Campaigns Table
```

---

### PHASE 1B.1 - STANDALONE & REFERENTIAL TABLES

---

### PHASE 1B - STEP 1: Farms Table Definition

📁 **FICHIERS REQUIS**
- Aucun (table standalone, pas de FK externes)

📋 **OBJECTIF**
Créer la table farms (table de base pour multi-tenancy)

📝 **CODE COMPLET**

Créer fichier: `lib/drift/tables/farms_table.dart`

```dart
import 'package:drift/drift.dart';

class FarmsTable extends Table {
  @override
  String get tableName => 'farms';

  // Primary key
  TextColumn get id => text()();

  // Farm data
  TextColumn get name => text()();
  TextColumn get location => text().nullable()();
  TextColumn get ownerId => text().nullable().named('owner_id')();
  TextColumn get cheptelNumber => text().nullable().named('cheptel_number')();

  // Timestamps
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {cheptelNumber}, // Numéro de cheptel unique
  ];
}
```

📝 **CONSTANTES**
Aucune nouvelle

📝 **I18N - CLÉS**
Aucune

📝 **I18N - TRADUCTIONS FR**
Aucune

⚡ **COMMANDES**
```bash
# Modifier database.dart pour ajouter FarmsTable
# Puis regénérer
flutter pub run build_runner build --delete-conflicting-outputs
```

✅ **VALIDATION**
- FarmsTable ajoutée dans database.dart imports
- FarmsTable ajoutée dans @DriftDatabase(tables: [...])
- database.g.dart régénéré
- FarmsTableData existe
- Pas d'erreurs compilation

🚀 **NEXT**
Phase 1B Step 2

---

### PHASE 1B - STEP 2: FarmDao

📁 **FICHIERS REQUIS**
- Aucun

📋 **OBJECTIF**
Créer FarmDao pour CRUD operations sur farms

📝 **CODE COMPLET**

Créer fichier: `lib/drift/daos/farm_dao.dart`

```dart
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/farms_table.dart';

part 'farm_dao.g.dart';

@DriftAccessor(tables: [FarmsTable])
class FarmDao extends DatabaseAccessor<AppDatabase> with _$FarmDaoMixin {
  FarmDao(AppDatabase db) : super(db);

  // 1. Get all farms
  Future<List<FarmsTableData>> findAll() {
    return select(farmsTable).get();
  }

  // 2. Get farm by ID
  Future<FarmsTableData?> findById(String id) {
    return (select(farmsTable)
      ..where((t) => t.id.equals(id)))
      .getSingleOrNull();
  }

  // 3. Get farm by cheptel number
  Future<FarmsTableData?> findByCheptelNumber(String cheptelNumber) {
    return (select(farmsTable)
      ..where((t) => t.cheptelNumber.equals(cheptelNumber)))
      .getSingleOrNull();
  }

  // 4. Insert farm
  Future<int> insertFarm(FarmsTableCompanion farm) {
    return into(farmsTable).insert(farm);
  }

  // 5. Update farm
  Future<bool> updateFarm(FarmsTableCompanion farm) {
    return update(farmsTable).replace(farm);
  }

  // 6. Delete farm (hard delete - used rarely, only for admin)
  Future<int> deleteFarm(String id) {
    return (delete(farmsTable)
      ..where((t) => t.id.equals(id)))
      .go();
  }

  // 7. Count farms
  Future<int> countFarms() {
    final query = selectOnly(farmsTable)
      ..addColumns([farmsTable.id.count()]);
    
    return query.map((row) => row.read(farmsTable.id.count())!).getSingle();
  }
}
```

📝 **CONSTANTES**
Aucune

📝 **I18N - CLÉS**
Aucune

📝 **I18N - TRADUCTIONS FR**
Aucune

⚡ **COMMANDES**
```bash
# Ajouter FarmDao dans database.dart
# Puis regénérer
flutter pub run build_runner build --delete-conflicting-outputs
```

✅ **VALIDATION**
- FarmDao ajouté dans database.dart (daos: [...])
- farm_dao.g.dart généré
- Pas d'erreurs compilation

🚀 **NEXT**
Phase 1B Step 3

---

### PHASE 1B - STEP 3: FarmRepository

📁 **FICHIERS REQUIS**
- `/mnt/project/models/farm.dart` (si existe, sinon le créer)

📋 **OBJECTIF**
Créer FarmRepository

📝 **CODE COMPLET - MODELS (si pas existe)**

Créer fichier: `lib/models/farm.dart`

```dart
class Farm {
  final String id;
  final String name;
  final String? location;
  final String? ownerId;
  final String? cheptelNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  Farm({
    required this.id,
    required this.name,
    this.location,
    this.ownerId,
    this.cheptelNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  Farm copyWith({
    String? id,
    String? name,
    String? location,
    String? ownerId,
    String? cheptelNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Farm(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      ownerId: ownerId ?? this.ownerId,
      cheptelNumber: cheptelNumber ?? this.cheptelNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```

📝 **CODE COMPLET - REPOSITORY**

Créer fichier: `lib/repositories/farm_repository.dart`

```dart
import '../drift/database.dart';
import '../models/farm.dart';
import 'package:drift/drift.dart' as drift;

class FarmRepository {
  final AppDatabase _db;

  FarmRepository(this._db);

  // 1. Get all farms
  Future<List<Farm>> getAll() async {
    final data = await _db.farmDao.findAll();
    return data.map((d) => _mapToModel(d)).toList();
  }

  // 2. Get farm by ID
  Future<Farm?> getById(String id) async {
    final data = await _db.farmDao.findById(id);
    return data != null ? _mapToModel(data) : null;
  }

  // 3. Get farm by cheptel number
  Future<Farm?> getByCheptelNumber(String cheptelNumber) async {
    final data = await _db.farmDao.findByCheptelNumber(cheptelNumber);
    return data != null ? _mapToModel(data) : null;
  }

  // 4. Create farm
  Future<void> create(Farm farm) async {
    final companion = _mapToCompanion(farm);
    await _db.farmDao.insertFarm(companion);
  }

  // 5. Update farm
  Future<void> update(Farm farm) async {
    final companion = _mapToCompanion(farm);
    await _db.farmDao.updateFarm(companion);
  }

  // 6. Delete farm
  Future<void> delete(String id) async {
    await _db.farmDao.deleteFarm(id);
  }

  // 7. Count farms
  Future<int> count() async {
    return await _db.farmDao.countFarms();
  }

  // === MAPPERS ===

  Farm _mapToModel(FarmsTableData data) {
    return Farm(
      id: data.id,
      name: data.name,
      location: data.location,
      ownerId: data.ownerId,
      cheptelNumber: data.cheptelNumber,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  drift.FarmsTableCompanion _mapToCompanion(Farm farm) {
    return drift.FarmsTableCompanion(
      id: drift.Value(farm.id),
      name: drift.Value(farm.name),
      location: farm.location != null 
        ? drift.Value(farm.location!) 
        : const drift.Value.absent(),
      ownerId: farm.ownerId != null 
        ? drift.Value(farm.ownerId!) 
        : const drift.Value.absent(),
      cheptelNumber: farm.cheptelNumber != null 
        ? drift.Value(farm.cheptelNumber!) 
        : const drift.Value.absent(),
      createdAt: drift.Value(farm.createdAt),
      updatedAt: drift.Value(farm.updatedAt),
    );
  }
}
```

📝 **CONSTANTES**
Aucune

📝 **I18N - CLÉS**
Aucune

📝 **I18N - TRADUCTIONS FR**
Aucune

⚡ **COMMANDES**
Aucune

✅ **VALIDATION**
- farm.dart créé (si n'existait pas)
- farm_repository.dart créé
- Pas d'erreurs compilation

🚀 **NEXT**
Phase 1B Step 4

---

### PHASE 1B - STEP 4-6: Complete Farm Integration (Condensed)

**Steps 4-6 sont similaires à Steps 7-9 de Phase 1A**

📋 **OBJECTIF**
Compléter l'intégration Farm (Provider + main.dart + tests)

📝 **ACTIONS REQUISES**

**Step 4:** Modifier main.dart
- Créer FarmRepository
- Injecter dans MultiProvider

**Step 5:** Créer/Modifier FarmProvider (si existe)
- Utiliser FarmRepository
- Méthodes CRUD standards

**Step 6:** Tester
- App démarre OK
- Farms persisted dans SQLite

✅ **VALIDATION**
- Farm table opérationnelle
- Pattern identique à Animals

🚀 **NEXT**
Phase 1B Step 7 (Species Table)

---

### 📋 PHASE 1B - STEPS 7-78: REMAINING TABLES (TEMPLATE)

**Les steps 7-78 suivent EXACTEMENT le même pattern que Farms:**

**Pour chaque table:**
1. Table Definition (Step X)
2. DAO Creation (Step X+1)
3. Repository Creation (Step X+2)
4. main.dart Integration (Step X+3)
5. Provider Integration (Step X+4)
6. Test & Validation (Step X+5)

**Tables à implémenter:**
- Species (Steps 7-12)
- Breeds (Steps 13-18) - FK species
- MedicalProducts (Steps 19-24)
- Vaccines (Steps 25-30)
- Veterinarians (Steps 31-36)
- Treatments (Steps 37-42) - FK animals, medical_products
- Vaccinations (Steps 43-48) - FK animals, vaccines
- Weights (Steps 49-54) - FK animals
- Movements (Steps 55-60) - FK animals
- Batches (Steps 61-66) - JSON animal_ids
- Lots (Steps 67-72) - JSON animal_ids
- Campaigns (Steps 73-78)

**Référence:** Utiliser le pattern Animals/Farms comme template exact

---

## 6. PHASE 1C - POLISH

**Objectif:** Finaliser, optimiser, valider la cohérence globale  
**Durée estimée:** 1-2 sessions

---

### PHASE 1C - STEP 1: Soft-Delete Global Verification

📁 **FICHIERS REQUIS**
- Tous les DAOs créés dans Phase 1B

📋 **OBJECTIF**
Vérifier que soft-delete est implémenté partout

📝 **CODE VERIFICATION**

Pour CHAQUE DAO, vérifier:

```dart
// ✅ Méthode softDelete existe
Future<int> softDelete(String id, String farmId) {
  return (update(table)
    ..where((t) => t.id.equals(id))
    ..where((t) => t.farmId.equals(farmId)))
    .write(TableCompanion(
      deletedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
}

// ✅ Toutes les queries excluent deleted_at
Future<List<Data>> findByFarmId(String farmId) {
  return (select(table)
    ..where((t) => t.farmId.equals(farmId))
    ..where((t) => t.deletedAt.isNull())) // ← OBLIGATOIRE
    .get();
}
```

📝 **CONSTANTES**
Aucune

📝 **I18N - CLÉS**
Aucune

📝 **I18N - TRADUCTIONS FR**
Aucune

⚡ **COMMANDES**
```bash
# Rechercher tous les select() sans deletedAt check
grep -r "select(" lib/drift/daos/ | grep -v "deletedAt"
```

✅ **VALIDATION**
- [ ] Tous les DAOs ont softDelete()
- [ ] Tous les findXxx() excluent deleted_at
- [ ] Aucun delete() direct (hard-delete)

🚀 **NEXT**
Phase 1C Step 2

---

### PHASE 1C - STEP 2: Indexes Optimization

📁 **FICHIERS REQUIS**
- Tous les fichiers tables créés

📋 **OBJECTIF**
Vérifier et optimiser les indexes pour performance

📝 **INDEXES REQUIS PAR TABLE**

**Animals:**
```dart
@override
List<String> get customConstraints => [
  'CREATE INDEX IF NOT EXISTS idx_animals_farm_id ON animals(farm_id)',
  'CREATE INDEX IF NOT EXISTS idx_animals_status ON animals(farm_id, status)',
  'CREATE INDEX IF NOT EXISTS idx_animals_eid ON animals(current_eid)',
  'CREATE INDEX IF NOT EXISTS idx_animals_official_number ON animals(official_number)',
];
```

**Treatments:**
```dart
@override
List<String> get customConstraints => [
  'CREATE INDEX IF NOT EXISTS idx_treatments_farm_id ON treatments(farm_id)',
  'CREATE INDEX IF NOT EXISTS idx_treatments_animal_id ON treatments(animal_id)',
  'CREATE INDEX IF NOT EXISTS idx_treatments_start_date ON treatments(start_date)',
];
```

**Pattern général:**
- Index sur farmId (toutes les tables)
- Index sur FK critiques (animal_id, etc.)
- Index sur colonnes de recherche fréquentes (date, status)

📝 **CONSTANTES**
Aucune

📝 **I18N - CLÉS**
Aucune

📝 **I18N - TRADUCTIONS FR**
Aucune

⚡ **COMMANDES**
```bash
# Après ajout indexes, regénérer
flutter pub run build_runner build --delete-conflicting-outputs
```

✅ **VALIDATION**
- [ ] Indexes farmId sur toutes tables
- [ ] Indexes FK sur tables avec relations
- [ ] Indexes colonnes recherche fréquentes

🚀 **NEXT**
Phase 1C Step 3

---

### PHASE 1C - STEP 3: Transaction Patterns Implementation

📁 **FICHIERS REQUIS**
- Tous les Repositories créés

📋 **OBJECTIF**
Implémenter patterns de transactions pour opérations complexes

📝 **CODE PATTERNS**

**Pattern 1: Create Lot + Update Animals**

Créer fichier: `lib/repositories/lot_repository.dart` (extension)

```dart
// Ajouter méthode transaction
Future<void> createLotWithAnimals(
  Lot lot,
  List<String> animalIds,
  String farmId,
) async {
  return _db.transaction(() async {
    // 1. Insert lot
    await create(lot, farmId);
    
    // 2. Update animals status
    for (var animalId in animalIds) {
      final animal = await _db.animalDao.findById(animalId, farmId);
      if (animal != null) {
        await _db.animalDao.updateAnimal(
          drift.AnimalsTableCompanion(
            id: drift.Value(animalId),
            status: drift.Value('in_lot'),
            updatedAt: drift.Value(DateTime.now()),
          ),
        );
      }
    }
    
    // If any fails, all rollback automatically
  });
}
```

**Pattern 2: Create Treatment + Alert**

```dart
Future<void> createTreatmentWithAlert(
  Treatment treatment,
  Alert alert,
  String farmId,
) async {
  return _db.transaction(() async {
    // 1. Insert treatment
    await _treatmentRepository.create(treatment, farmId);
    
    // 2. Insert alert si withdrawal period > 0
    if (treatment.withdrawalPeriodDays != null && 
        treatment.withdrawalPeriodDays! > 0) {
      await _alertRepository.create(alert, farmId);
    }
  });
}
```

📝 **CONSTANTES**
Aucune

📝 **I18N - CLÉS**
Aucune

📝 **I18N - TRADUCTIONS FR**
Aucune

⚡ **COMMANDES**
Aucune

✅ **VALIDATION**
- [ ] Transaction patterns créés
- [ ] Rollback fonctionne en cas d'erreur
- [ ] Aucune donnée partielle

🚀 **NEXT**
Phase 1C Step 4

---

### PHASE 1C - STEP 4: sync_queue Table Implementation

📁 **FICHIERS REQUIS**
- Aucun (nouvelle table Phase 2 ready)

📋 **OBJECTIF**
Créer sync_queue table pour Phase 2

📝 **CODE COMPLET**

Créer fichier: `lib/drift/tables/sync_queue_table.dart`

```dart
import 'package:drift/drift.dart';

class SyncQueueTable extends Table {
  @override
  String get tableName => 'sync_queue';

  // Primary key
  TextColumn get id => text()();

  // Multi-tenancy
  TextColumn get farmId => text().named('farm_id')();

  // Entity info
  TextColumn get entityType => text().named('entity_type')(); // 'animal', 'treatment', etc.
  TextColumn get entityId => text().named('entity_id')(); // UUID of entity
  TextColumn get action => text()(); // 'insert', 'update', 'delete'

  // Payload (full JSON of entity)
  BlobColumn get payload => blob()();

  // Retry management
  IntColumn get retryCount => integer().withDefault(const Constant(0)).named('retry_count')();
  DateTimeColumn get lastRetryAt => dateTime().nullable().named('last_retry_at')();
  TextColumn get errorMessage => text().nullable().named('error_message')();

  // Timestamps
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get syncedAt => dateTime().nullable().named('synced_at')();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {farmId, entityId, action}, // Un seul action par entité
  ];

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (farm_id) REFERENCES farms(id)',
    'CREATE INDEX IF NOT EXISTS idx_sync_queue_farm_id ON sync_queue(farm_id)',
    'CREATE INDEX IF NOT EXISTS idx_sync_queue_synced_at ON sync_queue(synced_at)',
    'CREATE INDEX IF NOT EXISTS idx_sync_queue_retry_count ON sync_queue(retry_count)',
  ];
}
```

Créer fichier: `lib/drift/daos/sync_queue_dao.dart`

```dart
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/sync_queue_table.dart';

part 'sync_queue_dao.g.dart';

@DriftAccessor(tables: [SyncQueueTable])
class SyncQueueDao extends DatabaseAccessor<AppDatabase> with _$SyncQueueDaoMixin {
  SyncQueueDao(AppDatabase db) : super(db);

  // 1. Get pending items (not synced)
  Future<List<SyncQueueTableData>> getPending(String farmId) {
    return (select(syncQueueTable)
      ..where((t) => t.farmId.equals(farmId))
      ..where((t) => t.syncedAt.isNull())
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
      .get();
  }

  // 2. Insert queue item
  Future<int> insertItem(SyncQueueTableCompanion item) {
    return into(syncQueueTable).insert(item);
  }

  // 3. Mark as synced
  Future<int> markSynced(String id, String farmId) {
    return (update(syncQueueTable)
      ..where((t) => t.id.equals(id))
      ..where((t) => t.farmId.equals(farmId)))
      .write(SyncQueueTableCompanion(
        syncedAt: Value(DateTime.now()),
      ));
  }

  // 4. Increment retry count
  Future<int> incrementRetry(String id, String farmId, String errorMessage) {
    return (update(syncQueueTable)
      ..where((t) => t.id.equals(id))
      ..where((t) => t.farmId.equals(farmId)))
      .write(SyncQueueTableCompanion(
        retryCount: Value(Expression.custom('retry_count + 1')),
        lastRetryAt: Value(DateTime.now()),
        errorMessage: Value(errorMessage),
      ));
  }

  // 5. Delete synced items (cleanup old data)
  Future<int> deleteSynced(String farmId, DateTime olderThan) {
    return (delete(syncQueueTable)
      ..where((t) => t.farmId.equals(farmId))
      ..where((t) => t.syncedAt.isSmallerThanValue(olderThan)))
      .go();
  }

  // 6. Count pending
  Future<int> countPending(String farmId) {
    final query = selectOnly(syncQueueTable)
      ..addColumns([syncQueueTable.id.count()])
      ..where(syncQueueTable.farmId.equals(farmId))
      ..where(syncQueueTable.syncedAt.isNull());
    
    return query.map((row) => row.read(syncQueueTable.id.count())!).getSingle();
  }
}
```

📝 **CONSTANTES**

Ajouter dans `lib/utils/constants.dart`:

```dart
// SYNC QUEUE ACTIONS
class SyncAction {
  static const String insert = 'insert';
  static const String update = 'update';
  static const String delete = 'delete';
}

// SYNC QUEUE ENTITY TYPES
class SyncEntityType {
  static const String animal = 'animal';
  static const String treatment = 'treatment';
  static const String vaccination = 'vaccination';
  static const String weight = 'weight';
  static const String movement = 'movement';
  static const String batch = 'batch';
  static const String lot = 'lot';
  static const String campaign = 'campaign';
}
```

📝 **I18N - CLÉS**
Aucune (backend seulement)

📝 **I18N - TRADUCTIONS FR**
Aucune

⚡ **COMMANDES**
```bash
# Ajouter SyncQueueTable et SyncQueueDao dans database.dart
# Puis regénérer
flutter pub run build_runner build --delete-conflicting-outputs
```

✅ **VALIDATION**
- [ ] sync_queue table créée
- [ ] SyncQueueDao fonctionnel
- [ ] Indexes créés
- [ ] Prêt pour Phase 2

🚀 **NEXT**
Phase 1C Step 5

---

### PHASE 1C - STEP 5: Mock Data Migration to SQLite

📁 **FICHIERS REQUIS**
- `/mnt/project/mock_data.dart`
- `/mnt/project/mock_animals.dart`
- `/mnt/project/mock_treatments.dart`
- Tous les autres mock_*.dart

📋 **OBJECTIF**
Migrer toutes les données mock vers SQLite au premier lancement

📝 **CODE COMPLET**

Créer fichier: `lib/utils/database_migration.dart`

```dart
import '../drift/database.dart';
import '../repositories/animal_repository.dart';
import '../repositories/treatment_repository.dart';
import '../repositories/vaccination_repository.dart';
import '../repositories/weight_repository.dart';
import '../repositories/batch_repository.dart';
import '../repositories/lot_repository.dart';
// ... autres repositories

import '../mock_data.dart';

class DatabaseMigration {
  final AppDatabase _db;
  final String _farmId;

  DatabaseMigration(this._db, this._farmId);

  Future<void> migrateAllMockData() async {
    print('🔄 Starting mock data migration...');

    try {
      // Check if already migrated
      final animalCount = await _db.animalDao.countByFarmId(_farmId);
      if (animalCount > 0) {
        print('✅ Database already contains data. Skipping migration.');
        return;
      }

      print('📦 Database empty. Migrating mock data...');

      // Migration dans l'ordre des dépendances FK
      await _migrateReferentialData();
      await _migrateAnimals();
      await _migrateTreatments();
      await _migrateVaccinations();
      await _migrateWeights();
      await _migrateMovements();
      await _migrateBatches();
      await _migrateLots();
      await _migrateCampaigns();

      print('✅ Mock data migration completed successfully!');
    } catch (e) {
      print('❌ Error during migration: $e');
      rethrow;
    }
  }

  Future<void> _migrateReferentialData() async {
    print('  📋 Migrating referential data...');
    
    // Breeds
    for (var breed in MockData.breeds) {
      final repository = BreedRepository(_db);
      await repository.create(breed);
    }
    
    // Medical Products
    for (var product in MockData.medicalProducts) {
      final repository = MedicalProductRepository(_db);
      await repository.create(product);
    }
    
    // Vaccines
    for (var vaccine in MockData.vaccines) {
      final repository = VaccineRepository(_db);
      await repository.create(vaccine);
    }
    
    // Veterinarians
    for (var vet in MockData.veterinarians) {
      final repository = VeterinarianRepository(_db);
      await repository.create(vet);
    }
    
    print('  ✅ Referential data migrated');
  }

  Future<void> _migrateAnimals() async {
    print('  🐑 Migrating animals...');
    
    final repository = AnimalRepository(_db);
    
    for (var animal in MockData.animals) {
      try {
        await repository.create(animal, _farmId);
      } catch (e) {
        print('  ⚠️  Error migrating animal ${animal.id}: $e');
      }
    }
    
    print('  ✅ Animals migrated');
  }

  Future<void> _migrateTreatments() async {
    print('  💊 Migrating treatments...');
    
    final repository = TreatmentRepository(_db);
    
    for (var treatment in MockData.treatments) {
      try {
        await repository.create(treatment, _farmId);
      } catch (e) {
        print('  ⚠️  Error migrating treatment ${treatment.id}: $e');
      }
    }
    
    print('  ✅ Treatments migrated');
  }

  Future<void> _migrateVaccinations() async {
    print('  💉 Migrating vaccinations...');
    
    final repository = VaccinationRepository(_db);
    
    for (var vaccination in MockData.vaccinations) {
      try {
        await repository.create(vaccination, _farmId);
      } catch (e) {
        print('  ⚠️  Error migrating vaccination ${vaccination.id}: $e');
      }
    }
    
    print('  ✅ Vaccinations migrated');
  }

  Future<void> _migrateWeights() async {
    print('  ⚖️  Migrating weights...');
    
    final repository = WeightRepository(_db);
    
    for (var weight in MockData.weights) {
      try {
        await repository.create(weight, _farmId);
      } catch (e) {
        print('  ⚠️  Error migrating weight ${weight.id}: $e');
      }
    }
    
    print('  ✅ Weights migrated');
  }

  Future<void> _migrateMovements() async {
    print('  🚚 Migrating movements...');
    
    final repository = MovementRepository(_db);
    
    for (var movement in MockData.movements) {
      try {
        await repository.create(movement, _farmId);
      } catch (e) {
        print('  ⚠️  Error migrating movement ${movement.id}: $e');
      }
    }
    
    print('  ✅ Movements migrated');
  }

  Future<void> _migrateBatches() async {
    print('  📦 Migrating batches...');
    
    final repository = BatchRepository(_db);
    
    for (var batch in MockData.batches) {
      try {
        await repository.create(batch, _farmId);
      } catch (e) {
        print('  ⚠️  Error migrating batch ${batch.id}: $e');
      }
    }
    
    print('  ✅ Batches migrated');
  }

  Future<void> _migrateLots() async {
    print('  📋 Migrating lots...');
    
    final repository = LotRepository(_db);
    
    for (var lot in MockData.lots) {
      try {
        await repository.create(lot, _farmId);
      } catch (e) {
        print('  ⚠️  Error migrating lot ${lot.id}: $e');
      }
    }
    
    print('  ✅ Lots migrated');
  }

  Future<void> _migrateCampaigns() async {
    print('  📅 Migrating campaigns...');
    
    final repository = CampaignRepository(_db);
    
    for (var campaign in MockData.campaigns) {
      try {
        await repository.create(campaign, _farmId);
      } catch (e) {
        print('  ⚠️  Error migrating campaign ${campaign.id}: $e');
      }
    }
    
    print('  ✅ Campaigns migrated');
  }
}
```

**Modifier main.dart:**

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  final database = AppDatabase();
  
  // Mock farmId (Phase 3 = real auth)
  const mockFarmId = 'farm-001';
  
  // Migrate mock data on first launch
  final migration = DatabaseMigration(database, mockFarmId);
  await migration.migrateAllMockData();
  
  // Initialize repositories
  final animalRepository = AnimalRepository(database);
  // ... autres repositories
  
  runApp(MyApp(
    database: database,
    animalRepository: animalRepository,
    // ... autres repositories
  ));
}
```

📝 **CONSTANTES**
Aucune

📝 **I18N - CLÉS**
Aucune

📝 **I18N - TRADUCTIONS FR**
Aucune

⚡ **COMMANDES**
```bash
# Test migration
flutter run

# Check logs pour voir la migration
```

✅ **VALIDATION**
- [ ] Premier lancement → migration exécutée
- [ ] Deuxième lancement → "already contains data"
- [ ] Toutes données mock présentes dans SQLite
- [ ] Aucune erreur FK

🚀 **NEXT**
Phase 1C Step 6

---

### PHASE 1C - STEP 6: Integration Tests (All Screens)

📁 **FICHIERS REQUIS**
- Aucun (tests manuels UI)

📋 **OBJECTIF**
Tester tous les écrans avec SQLite persistence

📝 **TEST CHECKLIST**

**🏠 Home Screen**
- [ ] Liste animals s'affiche
- [ ] Données viennent de SQLite (pas mock)
- [ ] Pull-to-refresh fonctionne
- [ ] Navigation vers détail fonctionne

**🐑 Animal Detail Screen**
- [ ] Affiche animal depuis SQLite
- [ ] Modifier animal → persiste
- [ ] Supprimer animal → soft-delete fonctionne
- [ ] Historique poids/traitements affiche

**💊 Treatment Screen**
- [ ] Liste treatments par animal
- [ ] Ajouter treatment → persiste
- [ ] Modifier treatment → fonctionne
- [ ] Alerte withdrawal period créée

**💉 Vaccination Screen**
- [ ] Liste vaccinations par animal
- [ ] Ajouter vaccination → persiste
- [ ] Next booster calculé correctement

**⚖️  Weight Screen**
- [ ] Historique poids par animal
- [ ] Ajouter pesée → persiste
- [ ] Graphique affiche correctement

**📦 Batch Screen**
- [ ] Créer batch avec animals → transaction fonctionne
- [ ] Animals status updated
- [ ] Liste batches affiche

**📋 Lot Screen**
- [ ] Créer lot unifié → fonctionne
- [ ] Finaliser lot → persiste
- [ ] Actions lot affichées

**⚙️  Settings Screen**
- [ ] Switch farm (si multi-farm) → filtre données
- [ ] Paramètres persistent

**🔄 Sync Status (UI si existe)**
- [ ] Pending sync count correct
- [ ] sync_queue vide (Phase 1)

📝 **CONSTANTES**
Aucune

📝 **I18N - CLÉS**
Aucune

📝 **I18N - TRADUCTIONS FR**
Aucune

⚡ **COMMANDES**
```bash
flutter run
# Tester manuellement tous les écrans
```

✅ **VALIDATION**
- [ ] Tous écrans fonctionnels
- [ ] Aucune régression UI
- [ ] Données persistent
- [ ] farmId filtering fonctionne
- [ ] Soft-delete fonctionne partout

🚀 **NEXT**
Phase 1C Step 7

---

### PHASE 1C - STEP 7: Performance Validation

📁 **FICHIERS REQUIS**
- Aucun (tests de performance)

📋 **OBJECTIF**
Valider que les performances sont acceptables avec SQLite

📝 **PERFORMANCE TESTS**

**Test 1: Query Speed**
```dart
// Ajouter dans un test ou debug screen
final stopwatch = Stopwatch()..start();
final animals = await animalRepository.getAll(farmId);
stopwatch.stop();
print('⏱️  Query animals: ${stopwatch.elapsedMilliseconds}ms');
// Target: <50ms pour 1000 animals
```

**Test 2: Search Speed**
```dart
final stopwatch = Stopwatch()..start();
final results = await animalRepository.search('FR', farmId);
stopwatch.stop();
print('⏱️  Search animals: ${stopwatch.elapsedMilliseconds}ms');
// Target: <100ms
```

**Test 3: Insert Speed**
```dart
final stopwatch = Stopwatch()..start();
await animalRepository.create(animal, farmId);
stopwatch.stop();
print('⏱️  Insert animal: ${stopwatch.elapsedMilliseconds}ms');
// Target: <50ms
```

**Test 4: Transaction Speed**
```dart
final stopwatch = Stopwatch()..start();
await lotRepository.createLotWithAnimals(lot, animalIds, farmId);
stopwatch.stop();
print('⏱️  Transaction: ${stopwatch.elapsedMilliseconds}ms');
// Target: <200ms
```

**Test 5: Database Size**
```bash
# Après migration complète
adb shell run-as com.your.app ls -lh /data/data/com.your.app/databases/
# Target: <10MB pour données mock
```

📝 **CONSTANTES**
Aucune

📝 **I18N - CLÉS**
Aucune

📝 **I18N - TRADUCTIONS FR**
Aucune

⚡ **COMMANDES**
```bash
flutter run --profile
# Tester performance en mode profile (plus proche de prod)
```

✅ **VALIDATION**
- [ ] Queries < 50ms (getAll)
- [ ] Search < 100ms
- [ ] Insert < 50ms
- [ ] Transactions < 200ms
- [ ] Database size < 10MB
- [ ] UI fluide (60 FPS)

⚠️ **SI PERFORMANCE KO:**
- Vérifier indexes présents
- Utiliser EXPLAIN QUERY PLAN
- Optimiser queries avec .limit()

🚀 **NEXT**
Phase 1C Step 8

---

### PHASE 1C - STEP 8: Phase 2 Readiness Check

📁 **FICHIERS REQUIS**
- Aucun (checklist validation)

📋 **OBJECTIF**
Vérifier que Phase 1 est 100% prête pour Phase 2 (SyncService)

📝 **PHASE 2 READINESS CHECKLIST**

**✅ Database Architecture**
- [ ] sync_queue table existe
- [ ] sync_queue indexes créés
- [ ] PRAGMA foreign_keys = ON

**✅ All Tables**
- [ ] synced field présent partout
- [ ] lastSyncedAt field présent partout
- [ ] serverVersion field présent partout
- [ ] deletedAt field présent partout (soft-delete)

**✅ All DAOs**
- [ ] getUnsynced(farmId) méthode présente
- [ ] markSynced(id, farmId) méthode présente
- [ ] farmId filtering sur toutes queries
- [ ] deleted_at excluded sur toutes queries

**✅ All Repositories**
- [ ] farmId security checks
- [ ] Transaction support
- [ ] getUnsynced() wrapper présent

**✅ Sync Queue**
- [ ] SyncQueueDao.getPending() fonctionne
- [ ] SyncQueueDao.markSynced() fonctionne
- [ ] SyncQueueDao.incrementRetry() fonctionne

**✅ Performance**
- [ ] Indexes optimisés
- [ ] Queries rapides
- [ ] Database size raisonnable

**✅ Data Integrity**
- [ ] Foreign keys respectées
- [ ] Pas de data leakage (farmId filtering OK)
- [ ] Transactions atomiques
- [ ] Soft-delete préserve audit trail

📝 **CONSTANTES**
Aucune

📝 **I18N - CLÉS**
Aucune

📝 **I18N - TRADUCTIONS FR**
Aucune

⚡ **COMMANDES**
Aucune

✅ **VALIDATION**
- [ ] Tous items checklist validés
- [ ] Aucun refactoring majeur nécessaire pour Phase 2
- [ ] Architecture propre et maintenable

🎉 **SI VALIDATION OK:**
**PHASE 1 TERMINÉE ! Prêt pour Phase 2 (SyncService)**

🚀 **NEXT**
Phase 2 Implementation (voir PHASE_2_SPEC.md)

---

## 7. VALIDATION FINALE

### 7.1 Technical Validation Checklist

**Database**
- [ ] SQLite database créée
- [ ] Toutes tables créées (animals, treatments, vaccinations, weights, movements, batches, lots, campaigns, sync_queue, referential tables)
- [ ] Foreign keys configurées
- [ ] Indexes optimisés
- [ ] Migrations fonctionnelles

**DAOs**
- [ ] Un DAO par table
- [ ] Méthodes CRUD complètes
- [ ] farmId filtering partout
- [ ] Soft-delete implémenté
- [ ] getUnsynced() + markSynced() (Phase 2 ready)

**Repositories**
- [ ] Un Repository par entité
- [ ] Business logic layer propre
- [ ] Security checks farmId
- [ ] Mappers Model ↔ Companion
- [ ] Transaction support

**Providers**
- [ ] Plus de mock lists
- [ ] Utilisent Repositories
- [ ] _currentFarmId géré
- [ ] notifyListeners() corrects
- [ ] Méthodes async correctes

**Integration**
- [ ] Database initialisée dans main.dart
- [ ] Repositories injectés
- [ ] Providers connectés
- [ ] Mock data migrée

### 7.2 Functional Validation Checklist

**Data Persistence**
- [ ] Données persistent après restart
- [ ] CRUD operations fonctionnent
- [ ] Soft-delete fonctionne
- [ ] Transactions atomiques

**Multi-Farm**
- [ ] farmId filtering fonctionne
- [ ] Aucune data leakage
- [ ] Switch farm possible (si UI existe)

**Performance**
- [ ] Queries rapides (<50ms)
- [ ] UI fluide (60 FPS)
- [ ] Database size raisonnable (<10MB mock)

**UI**
- [ ] Tous écrans fonctionnels
- [ ] Aucune régression
- [ ] Pull-to-refresh fonctionne
- [ ] Navigation OK

### 7.3 Phase 2 Readiness Checklist

- [ ] sync_queue table prête
- [ ] Sync fields partout
- [ ] getUnsynced() methods partout
- [ ] markSynced() methods partout
- [ ] Transaction support
- [ ] Aucun refactoring majeur nécessaire

---

## 8. TROUBLESHOOTING

### 8.1 Build Runner Errors

**❌ Error: "Could not resolve annotation"**
```bash
Solution:
1. flutter clean
2. rm -rf .dart_tool build
3. flutter pub get
4. flutter pub run build_runner build --delete-conflicting-outputs
```

**❌ Error: "Conflicting outputs"**
```bash
Solution:
flutter pub run build_runner build --delete-conflicting-outputs
```

**❌ Error: "Part file not found"**
```bash
Solution:
Vérifier que la ligne part 'xxx.g.dart'; est présente en haut du fichier
```

### 8.2 Foreign Key Errors

**❌ Error: "FOREIGN KEY constraint failed"**
```bash
Cause: Insertion dans mauvais ordre (enfant avant parent)

Solution:
1. Vérifier ordre d'insertion (parents d'abord)
2. Vérifier PRAGMA foreign_keys = ON
3. Vérifier FK définies dans customConstraints
```

**❌ Error: "No such table: xxx"**
```bash
Solution:
1. Désinstaller app de l'émulateur
2. Relancer flutter run (database recréée)
```

### 8.3 farmId Filtering Errors

**❌ Error: "Data leakage" (données d'autres farms affichées)**
```bash
Cause: Oubli farmId filtering dans query

Solution:
1. Vérifier TOUS les select() ont .where((t) => t.farmId.equals(farmId))
2. Chercher: grep -r "select(" lib/drift/daos/ | grep -v "farmId"
```

**❌ Error: "Farm ID mismatch - Security violation"**
```bash
Cause: Tentative d'accéder à données d'une autre farm

Solution:
C'est normal ! Le security check fonctionne.
Vérifier que _currentFarmId est correct dans Provider.
```

### 8.4 Soft-Delete Errors

**❌ Error: "Items supprimés toujours affichés"**
```bash
Cause: Oubli ..where((t) => t.deletedAt.isNull())

Solution:
1. Ajouter check deleted_at dans TOUS les select()
2. Chercher: grep -r "select(" lib/drift/daos/ | grep -v "deletedAt"
```

### 8.5 Performance Issues

**❌ Problem: "Queries lentes (>100ms)"**
```bash
Cause: Indexes manquants

Solution:
1. Vérifier indexes sur farmId
2. Vérifier indexes sur FK
3. Utiliser EXPLAIN QUERY PLAN:
   await customSelect('EXPLAIN QUERY PLAN SELECT * FROM animals WHERE farm_id = ?', variables: [Variable(farmId)]).get();
```

**❌ Problem: "App freeze sur grandes listes"**
```bash
Cause: Queries sur UI thread

Solution:
1. Vérifier que méthodes Provider sont async
2. Utiliser FutureBuilder / StreamBuilder
3. Paginer les résultats avec .limit() et .offset()
```

### 8.6 Migration Errors

**❌ Error: "Null check operator used on null"**
```bash
Cause: Champ nullable mal géré dans mapper

Solution:
Utiliser:
field: data.field != null ? Value(data.field!) : const Value.absent()
```

**❌ Error: "Invalid JSON" (dans sync_queue payload)**
```bash
Cause: Entity non serializable

Solution:
Vérifier que models ont toJson() / fromJson()
```

---

## 9. DOCUMENT USAGE GUIDE

### Comment utiliser ce document

**Démarrage nouvelle session:**
```
1. Upload PHASE_1_IMPLEMENTATION.md à Claude
2. Dire: "Phase 1A Step 5" (ou le step où tu en es)
3. Claude lit le document, trouve le step, exécute
```

**Après chaque step:**
```
1. Claude livre fichiers dans /mnt/user-data/outputs/
2. Télécharger les fichiers
3. Intégrer dans projet
4. Valider selon checklist
5. Passer au step suivant
```

**Si erreurs:**
```
1. Check section Troubleshooting
2. Corriger selon solutions
3. Revalider step avant de continuer
```

**Fin Phase 1:**
```
1. Validation finale (Section 7)
2. Si OK → Phase 2
3. Si KO → Corriger puis revalider
```

---

## 10. NOTES FINALES

### ✅ Règles Critiques Rappel

1. **TOUJOURS** filtrer par farmId dans queries
2. **TOUJOURS** exclure deleted_at dans queries
3. **TOUJOURS** utiliser soft-delete (pas hard-delete)
4. **TOUJOURS** vérifier FK order lors migration
5. **TOUJOURS** utiliser transactions pour opérations multi-tables

### 🎯 Objectifs Phase 1

- ✅ Mock lists → SQLite persistence
- ✅ Repository pattern clean
- ✅ farmId security partout
- ✅ Phase 2 ready (sync_queue, getUnsynced, markSynced)
- ✅ Performance OK
- ✅ Aucune régression UI

### 🚀 Next Steps

**Après Phase 1:**
1. Valider checklist Section 7
2. Documenter learnings
3. Commit Git avec tag "phase-1-complete"
4. Passer à Phase 2 (SyncService)

---

**END OF DOCUMENT**

*Last updated: 2025-11-09*
*Version: 1.0*
*Status: Ready for Implementation*
