# 🐑 ANIMAL TRACE - SYSTÈME DE TRANSFERT D'ANIMAUX
## Specifications Complètes - Phase 1B/1C Ready

**Document:** ANIMAL_TRANSFER_SYSTEM_SPECS.md  
**Version:** 1.0  
**Date:** 15 novembre 2025  
**Status:** READY TO CODE  
**Scope:** Database + Models + Repositories (NO UI, NO SYNC APIs yet)

---

## 📋 TABLE OF CONTENTS

1. [Overview & Architecture](#1-overview--architecture)
2. [Data Models & State Machine](#2-data-models--state-machine)
3. [Database Schema (Drift Tables)](#3-database-schema-drift-tables)
4. [DAOs - Data Access Objects](#4-daos---data-access-objects)
5. [Repositories](#5-repositories)
6. [Models / DTOs (Dart Classes)](#6-models--dtos-dart-classes)
7. [Constants](#7-constants)
8. [i18n Keys](#8-i18n-keys)
9. [API Contracts (Phase 2 Preview)](#9-api-contracts-phase-2-preview)
10. [Implementation Checklist](#10-implementation-checklist)

---

## 1. OVERVIEW & ARCHITECTURE

### 1.1 Business Rules (Summary)

```
✅ Two transaction types:
   - ON_FIELD: Seller scans QR code of buyer farm → immediate
   - REMOTE: Seller enters buyer farm ID manually → notification

✅ Animals vs Lots:
   - Transfer can contain: EITHER individual animals OR full lot (never mix)
   - Individual animals can be sold to farmers OR private individuals
   - Lots can ONLY be sold to farmers (not to private individuals)

✅ Draft Animals:
   - BLOCKED: Animal.isDraft = true → Cannot be transferred
   - Validation: Check at transfer creation time

✅ Veto Requirements:
   - Per-farm configuration: farm.requireVetoForTransfer (boolean)
   - Logic: 
     * If seller.requireVetoForTransfer = true OR buyer.requireVetoForTransfer = true
     * → Transfer status = PENDING_VETO_SIGNATURES
     * → Requires veto signature from seller farm AND/OR buyer farm based on their config
   - Exception: Sales to private individuals (no farm) = ignore veto requirement

✅ Seller Cancellation:
   - BLOCKED after seller confirms

✅ Buyer Cancellation:
   - ALLOWED before buyer confirms (decline)
   - BLOCKED after buyer confirms (contract is binding)

✅ Historical Data:
   - Duplicated to buyer farm (synced)
   - Read-only on buyer side for historical entries
   - Buyer can add NEW entries but cannot modify historical ones

✅ Offline-First:
   - Transfer creation: Works offline (with QR code data cached)
   - Sync happens when online
   - Server validates ID on sync
   - Admin intervention if ID mismatch on sync
```

### 1.2 Architecture Pattern

```
UI Layer
  ↓
Provider (e.g., TransferProvider)
  ↓
Repository (e.g., TransferRepository) ← Business logic + farmId filtering
  ↓
DAO (e.g., TransferDao) ← Database queries
  ↓
Drift SQLite
```

### 1.3 Multi-Tenancy Security

```
RULE 1: Every query must filter by farmId
RULE 2: farmId passed from Repository → DAO
RULE 3: Endpoint method signatures always include farmId parameter
RULE 4: Security check in Repository: verify farmId match after retrieval
```

### 1.4 Project Structure

```
lib/
├── drift/
│   ├── database.dart (add: transfersTable, transferAnimalsTable, transferDocumentsTable)
│   ├── tables/
│   │   ├── transfers_table.dart (NEW)
│   │   ├── transfer_animals_table.dart (NEW)
│   │   └── transfer_documents_table.dart (NEW)
│   └── daos/
│       ├── transfer_dao.dart (NEW)
│       ├── transfer_animals_dao.dart (NEW)
│       └── transfer_documents_dao.dart (NEW)
├── repositories/
│   └── transfer_repository.dart (NEW)
├── providers/
│   └── transfer_provider.dart (NEW)
├── models/
│   ├── transfer.dart (NEW)
│   ├── transfer_animal.dart (NEW)
│   └── transfer_document.dart (NEW)
└── i18n/
    ├── app_strings.dart (ADD keys)
    └── strings_fr.dart (ADD translations)
```

---

## 2. DATA MODELS & STATE MACHINE

### 2.1 Transfer State Machine

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  CREATED (created, not yet confirmed by seller)           │
│      ↓ [seller confirms]                                  │
│  SELLER_CONFIRMED                                          │
│      ↓ [buyer confirms]                                   │
│  BUYER_CONFIRMED                                           │
│      ↓                                                     │
│  ┌─ IF veto required ─────────────────────────────────┐  │
│  │   PENDING_VETO_SIGNATURES                          │  │
│  │       ↓ [veto signature(s) received]               │  │
│  │   VETO_SIGNED                                      │  │
│  │       ↓                                            │  │
│  └────────────────────────────────────────────────────┘  │
│      ↓                                                     │
│  COMPLETED                                                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘

Cancel paths:
  CREATED → SELLER_CANCELLED (seller action)
  SELLER_CONFIRMED → SELLER_CANCELLED (seller action, but NO - blocked after confirm)
  SELLER_CONFIRMED → BUYER_DECLINED (buyer action)
  BUYER_CONFIRMED → Not cancellable (contract binding)
```

### 2.2 Transfer Types

```
enum TransferType {
  ON_FIELD,     // Seller scans QR at farm
  REMOTE,       // Seller enters ID manually
}
```

### 2.3 Transfer Item Types

```
Union type: Movement contains EITHER animals OR lot (not both)

Type A: Individual Animals Transfer
  - animalIds: List<String> (not empty)
  - lotId: null

Type B: Full Lot Transfer
  - animalIds: null (or empty)
  - lotId: String (not null)
```

### 2.4 Buyer Types

```
Union type: Buyer is EITHER a farm OR a private individual

Type A: Farm Buyer
  - buyerFarmId: String (FK to farms table)
  - buyerName: null
  - buyerPhone: null

Type B: Private Individual Buyer
  - buyerFarmId: null
  - buyerName: String (e.g., "Jean Dupont")
  - buyerPhone: String (e.g., "06.12.34.56.78")
  - Note: No veto requirement for private sales
```

### 2.5 Veto Signature Status

```
enum VetoSignatureStatus {
  NOT_REQUIRED,           // Neither farm requires veto
  PENDING_SELLER_VETO,    // Seller farm requires, not yet signed
  PENDING_BUYER_VETO,     // Buyer farm requires, not yet signed
  PENDING_BOTH_VETOS,     // Both require, neither signed
  SIGNED_SELLER_ONLY,     // Only seller veto signed
  SIGNED_BUYER_ONLY,      // Only buyer veto signed
  SIGNED_BOTH,            // Both signed
}
```

---

## 3. DATABASE SCHEMA (DRIFT TABLES)

### 3.1 transfers_table.dart

```dart
// lib/drift/tables/transfers_table.dart
import 'package:drift/drift.dart';

class TransfersTable extends Table {
  @override
  String get tableName => 'transfers';

  // ==================== PRIMARY KEY ====================
  TextColumn get id => text()();

  // ==================== MULTI-TENANCY ====================
  TextColumn get farmId => text().named('farm_id')();  // SELLER farm

  // ==================== TRANSFER METADATA ====================
  TextColumn get transferType => text().named('transfer_type')();  // ON_FIELD | REMOTE
  TextColumn get status => text()();  // CREATED | SELLER_CONFIRMED | BUYER_CONFIRMED | PENDING_VETO_SIGNATURES | VETO_SIGNED | COMPLETED | SELLER_CANCELLED | BUYER_DECLINED

  // ==================== BUYER INFORMATION (Union Type) ====================
  TextColumn get buyerFarmId => text().nullable().named('buyer_farm_id')();  // null if private individual
  TextColumn get buyerName => text().nullable().named('buyer_name')();  // null if farm buyer
  TextColumn get buyerPhone => text().nullable().named('buyer_phone')();  // null if farm buyer

  // ==================== TRANSFER ITEM TYPE ====================
  TextColumn get itemType => text().named('item_type')();  // ANIMALS | LOT
  TextColumn get lotId => text().nullable().named('lot_id')();  // null if ANIMALS type

  // ==================== VETO INFORMATION ====================
  BoolColumn get requiresVetoFromSeller => boolean().named('requires_veto_from_seller')();
  BoolColumn get requiresVetoFromBuyer => boolean().named('requires_veto_from_buyer')();
  BoolColumn get vetoSignedBySeller => boolean().named('veto_signed_by_seller').withDefault(const Constant(false))();
  BoolColumn get vetoSignedByBuyer => boolean().named('veto_signed_by_buyer').withDefault(const Constant(false))();
  DateTimeColumn get vetoSignedBySellerAt => dateTime().nullable().named('veto_signed_by_seller_at')();
  DateTimeColumn get vetoSignedByBuyerAt => dateTime().nullable().named('veto_signed_by_buyer_at')();

  // ==================== CONFIRMATION STATUS ====================
  BoolColumn get sellerConfirmed => boolean().named('seller_confirmed').withDefault(const Constant(false))();
  BoolColumn get buyerConfirmed => boolean().named('buyer_confirmed').withDefault(const Constant(false))();
  DateTimeColumn get sellerConfirmedAt => dateTime().nullable().named('seller_confirmed_at')();
  DateTimeColumn get buyerConfirmedAt => dateTime().nullable().named('buyer_confirmed_at')();

  // ==================== METADATA ====================
  TextColumn get notes => text().nullable();

  // ==================== SYNC FIELDS (Phase 2 Ready) ====================
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable().named('last_synced_at')();
  TextColumn get serverVersion => text().nullable().named('server_version')();

  // ==================== SOFT-DELETE (Audit Trail) ====================
  DateTimeColumn get deletedAt => dateTime().nullable().named('deleted_at')();

  // ==================== TIMESTAMPS ====================
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  // ==================== PRIMARY KEY ====================
  @override
  Set<Column> get primaryKey => {id};

  // ==================== FOREIGN KEYS & INDEXES ====================
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE',
    'FOREIGN KEY (buyer_farm_id) REFERENCES farms(id) ON DELETE SET NULL',
    'FOREIGN KEY (lot_id) REFERENCES lots(id) ON DELETE CASCADE',
    'CREATE INDEX IF NOT EXISTS idx_transfers_farm_id ON transfers(farm_id)',
    'CREATE INDEX IF NOT EXISTS idx_transfers_buyer_farm_id ON transfers(buyer_farm_id)',
    'CREATE INDEX IF NOT EXISTS idx_transfers_status ON transfers(status)',
    'CREATE INDEX IF NOT EXISTS idx_transfers_created_at ON transfers(created_at DESC)',
    'CREATE INDEX IF NOT EXISTS idx_transfers_farm_status ON transfers(farm_id, status)',
    'CREATE INDEX IF NOT EXISTS idx_transfers_deleted_at ON transfers(deleted_at)',
  ];
}
```

### 3.2 transfer_animals_table.dart

```dart
// lib/drift/tables/transfer_animals_table.dart
import 'package:drift/drift.dart';

class TransferAnimalsTable extends Table {
  @override
  String get tableName => 'transfer_animals';

  // ==================== PRIMARY KEY ====================
  TextColumn get id => text()();

  // ==================== MULTI-TENANCY ====================
  TextColumn get farmId => text().named('farm_id')();  // SELLER farm

  // ==================== FOREIGN KEYS ====================
  TextColumn get transferId => text().named('transfer_id')();  // FK to transfers
  TextColumn get animalId => text().named('animal_id')();  // FK to animals

  // ==================== SYNC FIELDS (Phase 2 Ready) ====================
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable().named('last_synced_at')();
  TextColumn get serverVersion => text().nullable().named('server_version')();

  // ==================== SOFT-DELETE (Audit Trail) ====================
  DateTimeColumn get deletedAt => dateTime().nullable().named('deleted_at')();

  // ==================== TIMESTAMPS ====================
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  // ==================== PRIMARY KEY ====================
  @override
  Set<Column> get primaryKey => {id};

  // ==================== UNIQUE CONSTRAINT ====================
  @override
  List<Set<Column>> get uniqueKeys => [
    {transferId, animalId},  // Each animal appears once per transfer
  ];

  // ==================== FOREIGN KEYS & INDEXES ====================
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE',
    'FOREIGN KEY (transfer_id) REFERENCES transfers(id) ON DELETE CASCADE',
    'FOREIGN KEY (animal_id) REFERENCES animals(id) ON DELETE CASCADE',
    'CREATE INDEX IF NOT EXISTS idx_transfer_animals_farm_id ON transfer_animals(farm_id)',
    'CREATE INDEX IF NOT EXISTS idx_transfer_animals_transfer_id ON transfer_animals(transfer_id)',
    'CREATE INDEX IF NOT EXISTS idx_transfer_animals_animal_id ON transfer_animals(animal_id)',
    'CREATE INDEX IF NOT EXISTS idx_transfer_animals_deleted_at ON transfer_animals(deleted_at)',
  ];
}
```

### 3.3 transfer_documents_table.dart

```dart
// lib/drift/tables/transfer_documents_table.dart
import 'package:drift/drift.dart';

class TransferDocumentsTable extends Table {
  @override
  String get tableName => 'transfer_documents';

  // ==================== PRIMARY KEY ====================
  TextColumn get id => text()();

  // ==================== MULTI-TENANCY ====================
  TextColumn get farmId => text().named('farm_id')();  // SELLER farm

  // ==================== FOREIGN KEY ====================
  TextColumn get transferId => text().named('transfer_id')();  // FK to transfers

  // ==================== DOCUMENT METADATA ====================
  TextColumn get documentType => text().named('document_type')();  // TRANSFER_CERTIFICATE, VETERINARY_CERTIFICATE, etc.
  TextColumn get documentFormat => text().named('document_format')();  // PDF, JSON, etc.
  TextColumn get fileName => text().nullable().named('file_name')();  // e.g., "transfer_cert_FARM_20251115.pdf"
  BlobColumn get documentBlob => blob().nullable().named('document_blob')();  // Stored locally
  TextColumn get documentUrl => text().nullable().named('document_url')();  // URL to server (Phase 2)

  // ==================== GENERATION METADATA ====================
  DateTimeColumn get generatedAt => dateTime().named('generated_at')();
  TextColumn get generatedBy => text().nullable().named('generated_by')();  // user ID or system

  // ==================== SIGNATURE STATUS ====================
  BoolColumn get sellerSigned => boolean().named('seller_signed').withDefault(const Constant(false))();
  BoolColumn get buyerSigned => boolean().named('buyer_signed').withDefault(const Constant(false))();
  DateTimeColumn get sellerSignedAt => dateTime().nullable().named('seller_signed_at')();
  DateTimeColumn get buyerSignedAt => dateTime().nullable().named('buyer_signed_at')();

  // ==================== SYNC FIELDS (Phase 2 Ready) ====================
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable().named('last_synced_at')();
  TextColumn get serverVersion => text().nullable().named('server_version')();

  // ==================== SOFT-DELETE (Audit Trail) ====================
  DateTimeColumn get deletedAt => dateTime().nullable().named('deleted_at')();

  // ==================== TIMESTAMPS ====================
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  // ==================== PRIMARY KEY ====================
  @override
  Set<Column> get primaryKey => {id};

  // ==================== FOREIGN KEYS & INDEXES ====================
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE',
    'FOREIGN KEY (transfer_id) REFERENCES transfers(id) ON DELETE CASCADE',
    'CREATE INDEX IF NOT EXISTS idx_transfer_documents_farm_id ON transfer_documents(farm_id)',
    'CREATE INDEX IF NOT EXISTS idx_transfer_documents_transfer_id ON transfer_documents(transfer_id)',
    'CREATE INDEX IF NOT EXISTS idx_transfer_documents_created_at ON transfer_documents(created_at DESC)',
    'CREATE INDEX IF NOT EXISTS idx_transfer_documents_deleted_at ON transfer_documents(deleted_at)',
  ];
}
```

---

## 4. DAOs - DATA ACCESS OBJECTS

### 4.1 transfer_dao.dart

```dart
// lib/drift/daos/transfer_dao.dart
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/transfers_table.dart';

part 'transfer_dao.g.dart';

@DriftAccessor(tables: [TransfersTable])
class TransferDao extends DatabaseAccessor<AppDatabase> with _$TransferDaoMixin {
  TransferDao(AppDatabase db) : super(db);

  // ==================== OBLIGATORY QUERIES ====================

  /// 1. Find all transfers by farm (both as seller and buyer)
  Future<List<TransfersTableData>> findByFarmId(String farmId) {
    return (select(transfersTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
        .get();
  }

  /// 2. Find transfer by ID with security check
  Future<TransfersTableData?> findById(String id, String farmId) {
    return (select(transfersTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// 3. Insert transfer
  Future<int> insertItem(TransfersTableCompanion item) {
    return into(transfersTable).insert(item);
  }

  /// 4. Update transfer (with farmId check)
  Future<int> updateItem(TransfersTableCompanion item, String farmId) {
    return (update(transfersTable)
          ..where((t) => t.id.equals(item.id.value))
          ..where((t) => t.farmId.equals(farmId)))
        .write(item);
  }

  /// 5. Soft delete transfer
  Future<int> softDelete(String id, String farmId) {
    return (update(transfersTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(TransfersTableCompanion(
          deletedAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ));
  }

  /// 6. Get unsynced transfers
  Future<List<TransfersTableData>> getUnsynced(String farmId) {
    return (select(transfersTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.synced.equals(false))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// 7. Mark as synced
  Future<int> markSynced(String id, String farmId) {
    return (update(transfersTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(TransfersTableCompanion(
          synced: const Value(true),
          lastSyncedAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ));
  }

  // ==================== BUSINESS QUERIES ====================

  /// 8. Find transfers by status
  Future<List<TransfersTableData>> findByStatus(String farmId, String status) {
    return (select(transfersTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.status.equals(status))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
        .get();
  }

  /// 9. Find transfers pending seller confirmation
  Future<List<TransfersTableData>> findPendingSellerConfirmation(String farmId) {
    return (select(transfersTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.status.equals('CREATED'))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// 10. Find transfers pending buyer confirmation
  Future<List<TransfersTableData>> findPendingBuyerConfirmation(String farmId) {
    return (select(transfersTable)
          ..where((t) => t.buyerFarmId.equals(farmId))
          ..where((t) => t.status.equals('SELLER_CONFIRMED'))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// 11. Find transfers pending veto signatures
  Future<List<TransfersTableData>> findPendingVetoSignatures(String farmId) {
    return (select(transfersTable)
          ..where((t) => t.farmId.equals(farmId).or(t.buyerFarmId.equals(farmId)))
          ..where((t) => t.status.equals('PENDING_VETO_SIGNATURES'))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// 12. Count transfers by farm
  Future<int> countByFarmId(String farmId) async {
    final count = countAll();
    final query = selectOnly(transfersTable)
      ..addColumns([count])
      ..where(transfersTable.farmId.equals(farmId))
      ..where(transfersTable.deletedAt.isNull());

    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }
}
```

### 4.2 transfer_animals_dao.dart

```dart
// lib/drift/daos/transfer_animals_dao.dart
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/transfer_animals_table.dart';

part 'transfer_animals_dao.g.dart';

@DriftAccessor(tables: [TransferAnimalsTable])
class TransferAnimalsDao extends DatabaseAccessor<AppDatabase> with _$TransferAnimalsDaoMixin {
  TransferAnimalsDao(AppDatabase db) : super(db);

  /// 1. Find animals by transfer ID
  Future<List<TransferAnimalsTableData>> findByTransferId(String transferId, String farmId) {
    return (select(transferAnimalsTable)
          ..where((t) => t.transferId.equals(transferId))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// 2. Insert animal into transfer
  Future<int> insertItem(TransferAnimalsTableCompanion item) {
    return into(transferAnimalsTable).insert(item);
  }

  /// 3. Batch insert animals for transfer
  Future<void> insertBatch(List<TransferAnimalsTableCompanion> items) {
    return batch((batch) {
      batch.insertAll(transferAnimalsTable, items);
    });
  }

  /// 4. Soft delete by transfer
  Future<int> softDeleteByTransferId(String transferId, String farmId) {
    return (update(transferAnimalsTable)
          ..where((t) => t.transferId.equals(transferId))
          ..where((t) => t.farmId.equals(farmId)))
        .write(TransferAnimalsTableCompanion(
          deletedAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ));
  }

  /// 5. Get unsynced transfer animals
  Future<List<TransferAnimalsTableData>> getUnsynced(String farmId) {
    return (select(transferAnimalsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.synced.equals(false))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// 6. Mark as synced
  Future<int> markSynced(String id, String farmId) {
    return (update(transferAnimalsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(TransferAnimalsTableCompanion(
          synced: const Value(true),
          lastSyncedAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ));
  }
}
```

### 4.3 transfer_documents_dao.dart

```dart
// lib/drift/daos/transfer_documents_dao.dart
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/transfer_documents_table.dart';

part 'transfer_documents_dao.g.dart';

@DriftAccessor(tables: [TransferDocumentsTable])
class TransferDocumentsDao extends DatabaseAccessor<AppDatabase> with _$TransferDocumentsDaoMixin {
  TransferDocumentsDao(AppDatabase db) : super(db);

  /// 1. Find documents by transfer ID
  Future<List<TransferDocumentsTableData>> findByTransferId(String transferId, String farmId) {
    return (select(transferDocumentsTable)
          ..where((t) => t.transferId.equals(transferId))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// 2. Find latest document for transfer
  Future<TransferDocumentsTableData?> findLatestByTransferId(String transferId, String farmId) {
    return (select(transferDocumentsTable)
          ..where((t) => t.transferId.equals(transferId))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// 3. Insert document
  Future<int> insertItem(TransferDocumentsTableCompanion item) {
    return into(transferDocumentsTable).insert(item);
  }

  /// 4. Update document
  Future<int> updateItem(TransferDocumentsTableCompanion item, String farmId) {
    return (update(transferDocumentsTable)
          ..where((t) => t.id.equals(item.id.value))
          ..where((t) => t.farmId.equals(farmId)))
        .write(item);
  }

  /// 5. Mark seller as signed
  Future<int> markSellerSigned(String id, String farmId) {
    return (update(transferDocumentsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(TransferDocumentsTableCompanion(
          sellerSigned: const Value(true),
          sellerSignedAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ));
  }

  /// 6. Mark buyer as signed
  Future<int> markBuyerSigned(String id, String farmId) {
    return (update(transferDocumentsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(TransferDocumentsTableCompanion(
          buyerSigned: const Value(true),
          buyerSignedAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ));
  }

  /// 7. Get unsynced documents
  Future<List<TransferDocumentsTableData>> getUnsynced(String farmId) {
    return (select(transferDocumentsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.synced.equals(false))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// 8. Mark as synced
  Future<int> markSynced(String id, String farmId) {
    return (update(transferDocumentsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(TransferDocumentsTableCompanion(
          synced: const Value(true),
          lastSyncedAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ));
  }
}
```

---

## 5. REPOSITORIES

### 5.1 transfer_repository.dart

```dart
// lib/repositories/transfer_repository.dart
import 'package:flutter/foundation.dart';
import '../drift/database.dart';
import '../models/transfer.dart';

class TransferRepository {
  final AppDatabase _db;

  TransferRepository(this._db);

  // ==================== OBLIGATORY METHODS ====================

  /// 1. Get all transfers for a farm
  Future<List<Transfer>> getAllByFarm(String farmId) async {
    final items = await _db.transferDao.findByFarmId(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// 2. Get transfer by ID with security check
  Future<Transfer?> getById(String id, String farmId) async {
    final item = await _db.transferDao.findById(id, farmId);
    if (item == null) return null;

    if (item.farmId != farmId) {
      throw Exception('Farm ID mismatch - Security violation');
    }

    return _mapToModel(item);
  }

  /// 3. Create transfer
  Future<void> create(Transfer transfer, String farmId) async {
    // Validation: farm ID must match
    if (transfer.farmId != farmId) {
      throw Exception('Transfer farm ID mismatch');
    }

    // Validation: draft animals check
    if (transfer.itemType == 'ANIMALS') {
      for (final animalId in transfer.animalIds ?? []) {
        final animal = await _db.animalDao.findById(animalId, farmId);
        if (animal != null && animal.isDraft) {
          throw Exception('Cannot transfer draft animals: $animalId');
        }
      }
    }

    final companion = _mapToCompanion(transfer, farmId);
    await _db.transferDao.insertItem(companion);
    debugPrint('✅ Transfer créé: ${transfer.id} dans farm $farmId');
  }

  /// 4. Update transfer
  Future<void> update(Transfer transfer, String farmId) async {
    final existing = await _db.transferDao.findById(transfer.id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Transfer not found or farm mismatch');
    }

    final companion = _mapToCompanion(transfer, farmId);
    final result = await _db.transferDao.updateItem(companion, farmId);
    if (result == 0) {
      throw Exception('Transfer update failed - no rows affected');
    }
    debugPrint('✅ Transfer mis à jour: ${transfer.id} dans farm $farmId');
  }

  /// 5. Soft delete transfer
  Future<void> delete(String id, String farmId) async {
    final existing = await _db.transferDao.findById(id, farmId);
    if (existing == null) {
      throw Exception('Transfer not found');
    }

    final result = await _db.transferDao.softDelete(id, farmId);
    if (result == 0) {
      throw Exception('Transfer delete failed');
    }
    debugPrint('✅ Transfer supprimé: $id dans farm $farmId');
  }

  /// 6. Get unsynced transfers
  Future<List<Transfer>> getUnsynced(String farmId) async {
    final items = await _db.transferDao.getUnsynced(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// 7. Mark as synced
  Future<void> markSynced(String id, String farmId) async {
    await _db.transferDao.markSynced(id, farmId);
    debugPrint('✅ Transfer marqué synced: $id');
  }

  // ==================== BUSINESS METHODS ====================

  /// 8. Get transfers by status
  Future<List<Transfer>> getByStatus(String farmId, String status) async {
    final items = await _db.transferDao.findByStatus(farmId, status);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// 9. Get pending seller confirmations
  Future<List<Transfer>> getPendingSellerConfirmation(String farmId) async {
    final items = await _db.transferDao.findPendingSellerConfirmation(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// 10. Get pending buyer confirmations
  Future<List<Transfer>> getPendingBuyerConfirmation(String farmId) async {
    final items = await _db.transferDao.findPendingBuyerConfirmation(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// 11. Confirm transfer by seller
  Future<void> confirmBySeller(String transferId, String farmId) async {
    final transfer = await _db.transferDao.findById(transferId, farmId);
    if (transfer == null) {
      throw Exception('Transfer not found');
    }

    if (transfer.status != 'CREATED') {
      throw Exception('Transfer cannot be confirmed - invalid status: ${transfer.status}');
    }

    await _db.transferDao.updateItem(
      TransfersTableCompanion(
        id: Value(transferId),
        status: const Value('SELLER_CONFIRMED'),
        sellerConfirmed: const Value(true),
        sellerConfirmedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
      farmId,
    );
    debugPrint('✅ Transfer confirmé par vendeur: $transferId');
  }

  /// 12. Confirm transfer by buyer
  Future<void> confirmByBuyer(String transferId, String buyerFarmId) async {
    final transfer = await _db.transferDao.findById(transferId, buyerFarmId);
    if (transfer == null) {
      throw Exception('Transfer not found');
    }

    if (transfer.status != 'SELLER_CONFIRMED') {
      throw Exception('Transfer cannot be confirmed by buyer - invalid status: ${transfer.status}');
    }

    // Determine veto requirement
    bool needsSellerVeto = transfer.requiresVetoFromSeller;
    bool needsBuyerVeto = transfer.requiresVetoFromBuyer;

    String newStatus = (needsSellerVeto || needsBuyerVeto) 
      ? 'PENDING_VETO_SIGNATURES' 
      : 'COMPLETED';

    await _db.transferDao.updateItem(
      TransfersTableCompanion(
        id: Value(transferId),
        status: Value(newStatus),
        buyerConfirmed: const Value(true),
        buyerConfirmedAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
      transfer.farmId,  // Keep seller's farmId
    );
    debugPrint('✅ Transfer confirmé par acheteur: $transferId, status: $newStatus');
  }

  /// 13. Decline transfer by buyer (before confirming)
  Future<void> declineByBuyer(String transferId, String buyerFarmId) async {
    final transfer = await _db.transferDao.findById(transferId, buyerFarmId);
    if (transfer == null) {
      throw Exception('Transfer not found');
    }

    if (transfer.buyerConfirmed) {
      throw Exception('Cannot decline - buyer already confirmed');
    }

    await _db.transferDao.updateItem(
      TransfersTableCompanion(
        id: Value(transferId),
        status: const Value('BUYER_DECLINED'),
        updatedAt: Value(DateTime.now()),
      ),
      transfer.farmId,
    );
    debugPrint('✅ Transfer refusé par acheteur: $transferId');
  }

  // ==================== PRIVATE HELPERS ====================

  Transfer _mapToModel(TransfersTableData data) {
    return Transfer(
      id: data.id,
      farmId: data.farmId,
      transferType: data.transferType,
      status: data.status,
      buyerFarmId: data.buyerFarmId,
      buyerName: data.buyerName,
      buyerPhone: data.buyerPhone,
      itemType: data.itemType,
      lotId: data.lotId,
      animalIds: [], // Loaded separately if needed
      requiresVetoFromSeller: data.requiresVetoFromSeller,
      requiresVetoFromBuyer: data.requiresVetoFromBuyer,
      vetoSignedBySeller: data.vetoSignedBySeller,
      vetoSignedByBuyer: data.vetoSignedByBuyer,
      sellerConfirmed: data.sellerConfirmed,
      buyerConfirmed: data.buyerConfirmed,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  TransfersTableCompanion _mapToCompanion(Transfer transfer, String farmId) {
    return TransfersTableCompanion(
      id: Value(transfer.id),
      farmId: Value(farmId),
      transferType: Value(transfer.transferType),
      status: Value(transfer.status),
      buyerFarmId: Value(transfer.buyerFarmId),
      buyerName: Value(transfer.buyerName),
      buyerPhone: Value(transfer.buyerPhone),
      itemType: Value(transfer.itemType),
      lotId: Value(transfer.lotId),
      requiresVetoFromSeller: Value(transfer.requiresVetoFromSeller),
      requiresVetoFromBuyer: Value(transfer.requiresVetoFromBuyer),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );
  }
}
```

---

## 6. MODELS / DTOs (DART CLASSES)

### 6.1 transfer.dart

```dart
// lib/models/transfer.dart

class Transfer {
  final String id;
  final String farmId;  // SELLER farm ID
  final String transferType;  // ON_FIELD | REMOTE
  final String status;  // CREATED | SELLER_CONFIRMED | BUYER_CONFIRMED | PENDING_VETO_SIGNATURES | VETO_SIGNED | COMPLETED | SELLER_CANCELLED | BUYER_DECLINED
  
  // Buyer information (union type)
  final String? buyerFarmId;  // null if private individual
  final String? buyerName;  // null if farm buyer
  final String? buyerPhone;  // null if farm buyer
  
  // Transfer items
  final String itemType;  // ANIMALS | LOT
  final String? lotId;  // null if itemType == ANIMALS
  final List<String> animalIds;  // empty if itemType == LOT
  
  // Veto information
  final bool requiresVetoFromSeller;
  final bool requiresVetoFromBuyer;
  final bool vetoSignedBySeller;
  final bool vetoSignedByBuyer;
  
  // Confirmation status
  final bool sellerConfirmed;
  final bool buyerConfirmed;
  
  // Timestamps
  final DateTime createdAt;
  final DateTime updatedAt;

  Transfer({
    required this.id,
    required this.farmId,
    required this.transferType,
    required this.status,
    this.buyerFarmId,
    this.buyerName,
    this.buyerPhone,
    required this.itemType,
    this.lotId,
    this.animalIds = const [],
    required this.requiresVetoFromSeller,
    required this.requiresVetoFromBuyer,
    this.vetoSignedBySeller = false,
    this.vetoSignedByBuyer = false,
    this.sellerConfirmed = false,
    this.buyerConfirmed = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // Getters
  bool get isPendingSellerConfirmation => status == 'CREATED' && !sellerConfirmed;
  bool get isPendingBuyerConfirmation => status == 'SELLER_CONFIRMED' && !buyerConfirmed;
  bool get isPendingVetoSignatures => status == 'PENDING_VETO_SIGNATURES';
  bool get isCompleted => status == 'COMPLETED';
  bool get isCancelled => status == 'SELLER_CANCELLED' || status == 'BUYER_DECLINED';
  bool get isBuyerPrivateIndividual => buyerFarmId == null;
  bool get isBuyerFarm => buyerFarmId != null;

  Transfer copyWith({
    String? id,
    String? farmId,
    String? transferType,
    String? status,
    String? buyerFarmId,
    String? buyerName,
    String? buyerPhone,
    String? itemType,
    String? lotId,
    List<String>? animalIds,
    bool? requiresVetoFromSeller,
    bool? requiresVetoFromBuyer,
    bool? vetoSignedBySeller,
    bool? vetoSignedByBuyer,
    bool? sellerConfirmed,
    bool? buyerConfirmed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transfer(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      transferType: transferType ?? this.transferType,
      status: status ?? this.status,
      buyerFarmId: buyerFarmId ?? this.buyerFarmId,
      buyerName: buyerName ?? this.buyerName,
      buyerPhone: buyerPhone ?? this.buyerPhone,
      itemType: itemType ?? this.itemType,
      lotId: lotId ?? this.lotId,
      animalIds: animalIds ?? this.animalIds,
      requiresVetoFromSeller: requiresVetoFromSeller ?? this.requiresVetoFromSeller,
      requiresVetoFromBuyer: requiresVetoFromBuyer ?? this.requiresVetoFromBuyer,
      vetoSignedBySeller: vetoSignedBySeller ?? this.vetoSignedBySeller,
      vetoSignedByBuyer: vetoSignedByBuyer ?? this.vetoSignedByBuyer,
      sellerConfirmed: sellerConfirmed ?? this.sellerConfirmed,
      buyerConfirmed: buyerConfirmed ?? this.buyerConfirmed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```

### 6.2 transfer_animal.dart

```dart
// lib/models/transfer_animal.dart

class TransferAnimal {
  final String id;
  final String farmId;  // SELLER farm ID
  final String transferId;
  final String animalId;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransferAnimal({
    required this.id,
    required this.farmId,
    required this.transferId,
    required this.animalId,
    required this.createdAt,
    required this.updatedAt,
  });

  TransferAnimal copyWith({
    String? id,
    String? farmId,
    String? transferId,
    String? animalId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransferAnimal(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      transferId: transferId ?? this.transferId,
      animalId: animalId ?? this.animalId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```

### 6.3 transfer_document.dart

```dart
// lib/models/transfer_document.dart

class TransferDocument {
  final String id;
  final String farmId;  // SELLER farm ID
  final String transferId;
  final String documentType;  // TRANSFER_CERTIFICATE | VETERINARY_CERTIFICATE
  final String documentFormat;  // PDF | JSON
  final String? fileName;
  final List<int>? documentBlob;  // Stored locally
  final String? documentUrl;  // Server URL (Phase 2)
  final DateTime generatedAt;
  final String? generatedBy;
  final bool sellerSigned;
  final bool buyerSigned;
  final DateTime? sellerSignedAt;
  final DateTime? buyerSignedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransferDocument({
    required this.id,
    required this.farmId,
    required this.transferId,
    required this.documentType,
    required this.documentFormat,
    this.fileName,
    this.documentBlob,
    this.documentUrl,
    required this.generatedAt,
    this.generatedBy,
    this.sellerSigned = false,
    this.buyerSigned = false,
    this.sellerSignedAt,
    this.buyerSignedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  TransferDocument copyWith({
    String? id,
    String? farmId,
    String? transferId,
    String? documentType,
    String? documentFormat,
    String? fileName,
    List<int>? documentBlob,
    String? documentUrl,
    DateTime? generatedAt,
    String? generatedBy,
    bool? sellerSigned,
    bool? buyerSigned,
    DateTime? sellerSignedAt,
    DateTime? buyerSignedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransferDocument(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      transferId: transferId ?? this.transferId,
      documentType: documentType ?? this.documentType,
      documentFormat: documentFormat ?? this.documentFormat,
      fileName: fileName ?? this.fileName,
      documentBlob: documentBlob ?? this.documentBlob,
      documentUrl: documentUrl ?? this.documentUrl,
      generatedAt: generatedAt ?? this.generatedAt,
      generatedBy: generatedBy ?? this.generatedBy,
      sellerSigned: sellerSigned ?? this.sellerSigned,
      buyerSigned: buyerSigned ?? this.buyerSigned,
      sellerSignedAt: sellerSignedAt ?? this.sellerSignedAt,
      buyerSignedAt: buyerSignedAt ?? this.buyerSignedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```

---

## 7. CONSTANTS

### 7.1 transfer_constants.dart

```dart
// lib/constants/transfer_constants.dart

class TransferConstants {
  // ==================== TRANSFER TYPES ====================
  static const String transferTypeOnField = 'ON_FIELD';
  static const String transferTypeRemote = 'REMOTE';
  
  static const List<String> transferTypes = [
    transferTypeOnField,
    transferTypeRemote,
  ];

  // ==================== TRANSFER STATUSES ====================
  static const String statusCreated = 'CREATED';
  static const String statusSellerConfirmed = 'SELLER_CONFIRMED';
  static const String statusBuyerConfirmed = 'BUYER_CONFIRMED';
  static const String statusPendingVetoSignatures = 'PENDING_VETO_SIGNATURES';
  static const String statusVetoSigned = 'VETO_SIGNED';
  static const String statusCompleted = 'COMPLETED';
  static const String statusSellerCancelled = 'SELLER_CANCELLED';
  static const String statusBuyerDeclined = 'BUYER_DECLINED';

  static const List<String> allStatuses = [
    statusCreated,
    statusSellerConfirmed,
    statusBuyerConfirmed,
    statusPendingVetoSignatures,
    statusVetoSigned,
    statusCompleted,
    statusSellerCancelled,
    statusBuyerDeclined,
  ];

  // ==================== ITEM TYPES ====================
  static const String itemTypeAnimals = 'ANIMALS';
  static const String itemTypeLot = 'LOT';

  static const List<String> itemTypes = [itemTypeAnimals, itemTypeLot];

  // ==================== DOCUMENT TYPES ====================
  static const String documentTypeTransferCertificate = 'TRANSFER_CERTIFICATE';
  static const String documentTypeVeterinaryCertificate = 'VETERINARY_CERTIFICATE';

  static const List<String> documentTypes = [
    documentTypeTransferCertificate,
    documentTypeVeterinaryCertificate,
  ];

  // ==================== DOCUMENT FORMATS ====================
  static const String documentFormatPdf = 'PDF';
  static const String documentFormatJson = 'JSON';

  static const List<String> documentFormats = [
    documentFormatPdf,
    documentFormatJson,
  ];

  // ==================== TIMEOUTS & DEADLINES ====================
  static const int sellerConfirmationTimeoutHours = 24;
  static const int buyerConfirmationTimeoutHours = 48;
  static const int vetoSignatureTimeoutHours = 72;

  // ==================== CANCELLATION ====================
  // Configurable per deployment - set on server, fetched at app startup
  static const int cancellationDeadlineHours = 24;  // Default, override at runtime
}
```

---

## 8. i18n KEYS

### 8.1 Add to app_strings.dart

```dart
// lib/i18n/app_strings.dart - ADD THESE KEYS

class AppStrings {
  // ... existing keys ...

  // ============ TRANSFERS ====================
  static const String transfers = 'transfers';
  static const String newTransfer = 'newTransfer';
  static const String createTransfer = 'createTransfer';
  static const String transferAnimals = 'transferAnimals';
  static const String transferLot = 'transferLot';
  static const String transferTo = 'transferTo';
  static const String transferFrom = 'transferFrom';
  static const String selectTransferType = 'selectTransferType';
  static const String onFieldTransfer = 'onFieldTransfer';
  static const String remoteTransfer = 'remoteTransfer';
  static const String scanBuyerQr = 'scanBuyerQr';
  static const String enterBuyerFarmId = 'enterBuyerFarmId';
  static const String buyerFarmNotFound = 'buyerFarmNotFound';
  static const String selectItemsToTransfer = 'selectItemsToTransfer';
  static const String selectedAnimals = 'selectedAnimals';
  static const String selectedLot = 'selectedLot';
  
  // Transfer status
  static const String transferStatus = 'transferStatus';
  static const String transferCreated = 'transferCreated';
  static const String transferSellerConfirmed = 'transferSellerConfirmed';
  static const String transferBuyerConfirmed = 'transferBuyerConfirmed';
  static const String transferPendingVeto = 'transferPendingVeto';
  static const String transferVetoSigned = 'transferVetoSigned';
  static const String transferCompleted = 'transferCompleted';
  static const String transferCancelled = 'transferCancelled';
  static const String transferDeclined = 'transferDeclined';
  
  // Transfer actions
  static const String confirmTransfer = 'confirmTransfer';
  static const String declineTransfer = 'declineTransfer';
  static const String cancelTransfer = 'cancelTransfer';
  static const String generateCertificate = 'generateCertificate';
  static const String signCertificate = 'signCertificate';
  static const String viewCertificate = 'viewCertificate';
  
  // Buyer information
  static const String buyerInformation = 'buyerInformation';
  static const String buyerFarm = 'buyerFarm';
  static const String buyerIndividual = 'buyerIndividual';
  static const String buyerName = 'buyerName';
  static const String buyerPhone = 'buyerPhone';
  static const String privateIndividual = 'privateIndividual';
  
  // Veto
  static const String vetoSignatureRequired = 'vetoSignatureRequired';
  static const String waitingForVetoSignature = 'waitingForVetoSignature';
  static const String vetoSignedBySeller = 'vetoSignedBySeller';
  static const String vetoSignedByBuyer = 'vetoSignedByBuyer';
  static const String vetoSignature = 'vetoSignature';
  
  // Draft animals
  static const String draftAnimalsCannotBeTransferred = 'draftAnimalsCannotBeTransferred';
  static const String officiateAnimalsFirst = 'officiateAnimalsFirst';
  
  // Errors
  static const String transferNotFound = 'transferNotFound';
  static const String invalidTransferStatus = 'invalidTransferStatus';
  static const String cannotConfirmTransfer = 'cannotConfirmTransfer';
  static const String cannotDeclineTransfer = 'cannotDeclineTransfer';
  static const String cannotCancelTransfer = 'cannotCancelTransfer';
  static const String transferError = 'transferError';
  
  // Documents
  static const String transferCertificate = 'transferCertificate';
  static const String vetoDocument = 'vetoDocument';
  static const String documentGenerated = 'documentGenerated';
  static const String downloadDocument = 'downloadDocument';
}
```

### 8.2 Add to strings_fr.dart

```dart
// lib/i18n/strings_fr.dart - ADD THESE TRANSLATIONS

{
  // ... existing translations ...
  
  "transfers": "Transferts",
  "newTransfer": "Nouveau transfert",
  "createTransfer": "Créer un transfert",
  "transferAnimals": "Transférer les animaux",
  "transferLot": "Transférer le lot",
  "transferTo": "Transférer à",
  "transferFrom": "Transférer de",
  "selectTransferType": "Sélectionner le type de transfert",
  "onFieldTransfer": "Transfert sur place",
  "remoteTransfer": "Transfert à distance",
  "scanBuyerQr": "Scanner le QR code de l'acheteur",
  "enterBuyerFarmId": "Entrer l'ID de la ferme de l'acheteur",
  "buyerFarmNotFound": "Ferme de l'acheteur non trouvée",
  "selectItemsToTransfer": "Sélectionner les articles à transférer",
  "selectedAnimals": "Animaux sélectionnés",
  "selectedLot": "Lot sélectionné",
  
  "transferStatus": "Statut du transfert",
  "transferCreated": "Transfert créé",
  "transferSellerConfirmed": "Confirmé par le vendeur",
  "transferBuyerConfirmed": "Confirmé par l'acheteur",
  "transferPendingVeto": "En attente de signature vétérinaire",
  "transferVetoSigned": "Signé par le vétérinaire",
  "transferCompleted": "Transfert complété",
  "transferCancelled": "Transfert annulé",
  "transferDeclined": "Transfert refusé",
  
  "confirmTransfer": "Confirmer le transfert",
  "declineTransfer": "Refuser le transfert",
  "cancelTransfer": "Annuler le transfert",
  "generateCertificate": "Générer le certificat",
  "signCertificate": "Signer le certificat",
  "viewCertificate": "Voir le certificat",
  
  "buyerInformation": "Informations de l'acheteur",
  "buyerFarm": "Ferme de l'acheteur",
  "buyerIndividual": "Particulier",
  "buyerName": "Nom de l'acheteur",
  "buyerPhone": "Téléphone de l'acheteur",
  "privateIndividual": "Particulier",
  
  "vetoSignatureRequired": "Signature vétérinaire requise",
  "waitingForVetoSignature": "En attente de signature vétérinaire",
  "vetoSignedBySeller": "Signé par le vétérinaire du vendeur",
  "vetoSignedByBuyer": "Signé par le vétérinaire de l'acheteur",
  "vetoSignature": "Signature vétérinaire",
  
  "draftAnimalsCannotBeTransferred": "Les animaux brouillons ne peuvent pas être transférés",
  "officiateAnimalsFirst": "Veuillez officialiser les animaux d'abord",
  
  "transferNotFound": "Transfert non trouvé",
  "invalidTransferStatus": "Statut de transfert invalide",
  "cannotConfirmTransfer": "Impossible de confirmer le transfert",
  "cannotDeclineTransfer": "Impossible de refuser le transfert",
  "cannotCancelTransfer": "Impossible d'annuler le transfert",
  "transferError": "Erreur lors du transfert",
  
  "transferCertificate": "Certificat de transfert",
  "vetoDocument": "Document vétérinaire",
  "documentGenerated": "Document généré",
  "downloadDocument": "Télécharger le document",
}
```

---

## 9. API CONTRACTS (PHASE 2 PREVIEW)

### 9.1 Transfer Endpoints (Preview - NOT implemented yet)

```
Phase 2 APIs (Server Sync) - FOR REFERENCE ONLY

POST /api/transfers
  Request: { transfer: Transfer, animalIds: List<String> }
  Response: { id: String, status: String }
  Purpose: Create new transfer on server

GET /api/transfers/{farmId}
  Response: { transfers: List<Transfer> }
  Purpose: Sync transfers for farm

PUT /api/transfers/{transferId}/confirm
  Request: { actor: 'seller' | 'buyer' }
  Response: { status: String, nextState: String }
  Purpose: Confirm transfer

GET /api/transfers/{transferId}/document
  Response: { document: TransferDocument }
  Purpose: Retrieve generated certificate

POST /api/transfers/{transferId}/document/sign
  Request: { actor: 'seller' | 'buyer', signature: String }
  Response: { signed: true, signedAt: DateTime }
  Purpose: Sign transfer document
```

### 9.2 Sync Queue Entry Structure (Phase 2)

```dart
// For Phase 2 SyncQueue implementation
class SyncQueueEntry {
  final String id;
  final String entityType;  // 'TRANSFER' | 'TRANSFER_ANIMAL' | 'TRANSFER_DOCUMENT'
  final String entityId;
  final String action;  // 'CREATE' | 'UPDATE' | 'DELETE'
  final String farmId;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final int retryCount;
  final DateTime? lastRetryAt;
  final String? error;
  // ...
}
```

---

## 10. IMPLEMENTATION CHECKLIST

### Phase 1B - Database (THIS SPRINT)

- [ ] **Step 1: Create Drift Tables**
  - [ ] transfers_table.dart
  - [ ] transfer_animals_table.dart
  - [ ] transfer_documents_table.dart

- [ ] **Step 2: Create DAOs**
  - [ ] transfer_dao.dart
  - [ ] transfer_animals_dao.dart
  - [ ] transfer_documents_dao.dart

- [ ] **Step 3: Generate Drift Code**
  - [ ] Run: `flutter pub run build_runner build --delete-conflicting-outputs`
  - [ ] Verify: No errors
  - [ ] Check: `_*.g.dart` files generated

- [ ] **Step 4: Create Repository**
  - [ ] transfer_repository.dart
  - [ ] Implement all CRUD + business methods
  - [ ] Add farmId security checks

- [ ] **Step 5: Create Models**
  - [ ] transfer.dart
  - [ ] transfer_animal.dart
  - [ ] transfer_document.dart

- [ ] **Step 6: Create Constants**
  - [ ] transfer_constants.dart
  - [ ] All enums defined

- [ ] **Step 7: Add i18n Keys**
  - [ ] Update app_strings.dart
  - [ ] Update strings_fr.dart

- [ ] **Step 8: Create Provider (stub)**
  - [ ] transfer_provider.dart (basic structure, inject repository)
  - [ ] No UI methods yet (Phase 2)

- [ ] **Step 9: Validation**
  - [ ] `flutter analyze` → 0 errors
  - [ ] `flutter pub run build_runner build` → Success
  - [ ] `flutter run` → No crashes

### Phase 2 - APIs & Sync

- [ ] Implement sync endpoints
- [ ] Implement PDF generation
- [ ] Implement document signing
- [ ] Add SyncQueue support
- [ ] Add notification system

### Phase 3 - UI

- [ ] Create transfer creation screens
- [ ] Create transfer confirmation flows
- [ ] Create transfer list & detail screens
- [ ] Create veto signature screens
- [ ] Create document viewing/signing UI

---

## 11. FILE STRUCTURE SUMMARY

```
/home/claude/
├── transfers_table.dart                    → Ready to copy
├── transfer_animals_table.dart             → Ready to copy
├── transfer_documents_table.dart           → Ready to copy
├── transfer_dao.dart                       → Ready to copy
├── transfer_animals_dao.dart               → Ready to copy
├── transfer_documents_dao.dart             → Ready to copy
├── transfer.dart                           → Ready to copy
├── transfer_animal.dart                    → Ready to copy
├── transfer_document.dart                  → Ready to copy
├── transfer_repository.dart                → Ready to copy
├── transfer_constants.dart                 → Ready to copy
├── transfer_provider_stub.dart             → Ready to copy (basic)
└── ANIMAL_TRANSFER_SYSTEM_SPECS.md         → This document
```

---

## 12. NEXT ACTIONS

1. **Review this document** - Confirm all specs align with your vision
2. **Generate Dart files** from the code sections above
3. **Place files** in correct directories
4. **Run build_runner** and verify compilation
5. **Test basic CRUD** operations
6. **Proceed to Phase 2** when ready (APIs + sync)

---

**Document Status:** READY TO CODE  
**Last Updated:** 15 novembre 2025  
**Version:** 1.0

