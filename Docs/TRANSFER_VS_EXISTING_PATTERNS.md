# Transfer System vs Existing Patterns Comparison

## Overview

This document compares the proposed Transfer system against the existing Movement system, which serves as the primary architectural reference.

---

## 1. DATABASE SCHEMA COMPARISON

### Movement (Existing Reference)

**Table: movements**

```
movements (18 columns)
├── id (TEXT PRIMARY KEY)
├── farm_id (TEXT FK → farms) ✅
├── animal_id (TEXT FK → animals)
├── type (TEXT) - MovementType enum
├── movement_date (DATETIME)
├── from_farm_id (TEXT FK → farms, nullable)
├── to_farm_id (TEXT FK → farms, nullable)
├── price (REAL, nullable)
├── notes (TEXT, nullable)
├── buyer_qr_signature (TEXT, nullable)
├── synced (BOOL default 0) ✅
├── last_synced_at (DATETIME, nullable) ✅
├── server_version (INTEGER, nullable) ✅
├── deleted_at (DATETIME, nullable) ✅
├── created_at (DATETIME)
└── updated_at (DATETIME)
```

**Indexes (10+ composite indexes)**
- idx_movements_farm_id
- idx_movements_animal_id
- idx_movements_type
- idx_movements_movement_date
- idx_movements_from_farm_id
- idx_movements_to_farm_id
- idx_movements_farm_animal (composite)
- idx_movements_farm_type (composite)
- idx_movements_farm_date (composite)
- idx_movements_deleted_at

**Custom Constraints:**
- FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE
- FOREIGN KEY (animal_id) REFERENCES animals(id)

---

### Transfer (Proposed)

**Table: transfers**

```
transfers (20+ columns)
├── id (TEXT PRIMARY KEY)
├── farm_id (TEXT FK → farms) ✅
├── transfer_date (DATETIME)
├── transfer_type (TEXT) - TransferType enum
├── from_farm_id (TEXT FK → farms, nullable)
├── to_farm_id (TEXT FK → farms, nullable)
├── from_user_id (TEXT, nullable)
├── to_user_id (TEXT, nullable)
├── reason (TEXT, nullable)
├── status (TEXT) - TransferStatus enum
├── approved_by_id (TEXT FK → veterinarians, nullable)
├── approval_date (DATETIME, nullable)
├── notes (TEXT, nullable)
├── qr_signature_from (TEXT, nullable)
├── qr_signature_to (TEXT, nullable)
├── synced (BOOL default 0) ✅
├── last_synced_at (DATETIME, nullable) ✅
├── server_version (INTEGER, nullable) ✅
├── deleted_at (DATETIME, nullable) ✅
├── created_at (DATETIME)
└── updated_at (DATETIME)
```

**Proposed Indexes (Similar Pattern)**
- idx_transfers_farm_id
- idx_transfers_transfer_type
- idx_transfers_status
- idx_transfers_transfer_date
- idx_transfers_from_farm_id
- idx_transfers_to_farm_id
- idx_transfers_farm_type (composite)
- idx_transfers_farm_status (composite)
- idx_transfers_farm_date (composite)
- idx_transfers_deleted_at

**Custom Constraints:**
- FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE
- FOREIGN KEY (from_farm_id) REFERENCES farms(id) ON DELETE SET NULL
- FOREIGN KEY (to_farm_id) REFERENCES farms(id) ON DELETE SET NULL
- FOREIGN KEY (approved_by_id) REFERENCES veterinarians(id) ON DELETE SET NULL

---

### Transfer Supporting Tables (New)

**Table: transfer_animals** (Junction Table)

```
transfer_animals (12 columns)
├── id (TEXT PRIMARY KEY)
├── farm_id (TEXT FK → farms)
├── transfer_id (TEXT FK → transfers)
├── animal_id (TEXT FK → animals)
├── quantity (INTEGER, nullable)
├── health_status_at_transfer (TEXT, nullable)
├── notes (TEXT, nullable)
├── synced (BOOL default 0)
├── last_synced_at (DATETIME, nullable)
├── server_version (INTEGER, nullable)
├── deleted_at (DATETIME, nullable)
├── created_at (DATETIME)
└── updated_at (DATETIME)
```

**Indexes:**
- idx_transfer_animals_farm_id
- idx_transfer_animals_transfer_id
- idx_transfer_animals_animal_id
- idx_transfer_animals_farm_transfer (composite)
- idx_transfer_animals_deleted_at

---

**Table: transfer_documents**

```
transfer_documents (15 columns)
├── id (TEXT PRIMARY KEY)
├── farm_id (TEXT FK → farms)
├── transfer_id (TEXT FK → transfers)
├── document_type (TEXT) - TransferDocumentType enum
├── file_path (TEXT)
├── file_name (TEXT)
├── mime_type (TEXT, nullable)
├── file_size (INTEGER, nullable)
├── uploaded_by_id (TEXT, nullable)
├── upload_date (DATETIME)
├── expiry_date (DATETIME, nullable)
├── synced (BOOL default 0)
├── last_synced_at (DATETIME, nullable)
├── server_version (INTEGER, nullable)
├── deleted_at (DATETIME, nullable)
├── created_at (DATETIME)
└── updated_at (DATETIME)
```

**Indexes:**
- idx_transfer_documents_farm_id
- idx_transfer_documents_transfer_id
- idx_transfer_documents_document_type
- idx_transfer_documents_expiry_date
- idx_transfer_documents_deleted_at

---

## 2. DAO PATTERN COMPARISON

### MovementDao (Existing - 250+ lines)

**Required Methods:**
```dart
// CRUD
findByFarmId(String farmId)
findById(String id, String farmId)
insertItem(MovementsTableCompanion item)
updateItem(MovementsTableCompanion item, String farmId)
softDelete(String id, String farmId)

// Sync (Phase 2)
getUnsynced(String farmId)
markSynced(String id, String farmId, int serverVersion)

// Business Queries
findByAnimalId(String farmId, String animalId)
findByType(String farmId, String type)
findByDateRange(String farmId, DateTime start, DateTime end)
findByTypeAndDateRange(String farmId, String type, DateTime start, DateTime end)
findBirths(String farmId)
findPurchases(String farmId)
findSales(String farmId)
findDeaths(String farmId)
findSlaughters(String farmId)

// Analytics
countByType(String farmId, String type)
countByAnimalId(String farmId, String animalId)
calculateTotalSalesAmount(String farmId, DateTime start, DateTime end)
calculateTotalPurchasesAmount(String farmId, DateTime start, DateTime end)
```

### TransferDao (Proposed - 200-250 lines expected)

**Required Methods:**
```dart
// CRUD
findByFarmId(String farmId)
findById(String id, String farmId)
insertItem(TransfersTableCompanion item)
updateItem(TransfersTableCompanion item, String farmId)
softDelete(String id, String farmId)

// Sync (Phase 2)
getUnsynced(String farmId)
markSynced(String id, String farmId, int serverVersion)

// Business Queries
findByType(String farmId, String type)
findByStatus(String farmId, String status)
findByFromFarm(String farmId, String fromFarmId)
findByToFarm(String farmId, String toFarmId)
findByDateRange(String farmId, DateTime start, DateTime end)
findPending(String farmId)
findByApprovalStatus(String farmId)

// Analytics
countByType(String farmId, String type)
countByStatus(String farmId, String status)
countPending(String farmId)
```

### TransferAnimalDao (New - 150-200 lines)

**Key Methods:**
```dart
// CRUD
findByTransferId(String transferId, String farmId)
findByAnimalId(String animalId, String farmId)
insertItem(TransferAnimalsTableCompanion item)
updateItem(TransferAnimalsTableCompanion item, String farmId)
softDelete(String id, String farmId)

// Sync
getUnsynced(String farmId)
markSynced(String id, String farmId, int serverVersion)

// Business
countByTransferId(String transferId, String farmId)
```

### TransferDocumentDao (New - 150-200 lines)

**Key Methods:**
```dart
// CRUD
findByTransferId(String transferId, String farmId)
insertItem(TransferDocumentsTableCompanion item)
updateItem(TransferDocumentsTableCompanion item, String farmId)
softDelete(String id, String farmId)

// Sync
getUnsynced(String farmId)
markSynced(String id, String farmId, int serverVersion)

// Business
findByDocumentType(String farmId, String type)
findExpiring(String farmId, DateTime beforeDate)
```

---

## 3. MODEL COMPARISON

### Movement Model (Existing - 150 lines)

```dart
enum MovementType { birth, purchase, sale, death, slaughter }

class Movement implements SyncableEntity {
  // Identification (3)
  final String id;
  final String farmId;
  
  // Business (9)
  final String animalId;
  final MovementType type;
  final DateTime movementDate;
  final String? fromFarmId;
  final String? toFarmId;
  final double? price;
  final String? notes;
  final String? buyerQrSignature;
  
  // Sync (5)
  final bool synced;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSyncedAt;
  final String? serverVersion;
  
  // Methods
  copyWith() // 9 parameters
  markAsSynced()
  markAsModified()
  toJson() // 14 fields
  fromJson() // factory
}
```

### Transfer Model (Proposed - 200+ lines)

```dart
enum TransferType { interFarm, intraFarm, incoming, outgoing, emergency }
enum TransferStatus { pending, accepted, rejected, completed }

class Transfer implements SyncableEntity {
  // Identification (2)
  final String id;
  final String farmId;
  
  // Business (13)
  final TransferType transferType;
  final DateTime transferDate;
  final String? fromFarmId;
  final String? toFarmId;
  final String? reason;
  final TransferStatus status;
  final String? fromUserId;
  final String? toUserId;
  final String? approvedById;
  final DateTime? approvalDate;
  final String? notes;
  final String? qrSignatureFrom;
  final String? qrSignatureTo;
  
  // Sync (5)
  final bool synced;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSyncedAt;
  final String? serverVersion;
  
  // Methods
  copyWith() // 13 parameters
  markAsSynced()
  markAsModified()
  toJson() // 18 fields
  fromJson() // factory
}
```

### TransferAnimal Model (Proposed - 100 lines)

```dart
class TransferAnimal implements SyncableEntity {
  // Identification (3)
  final String id;
  final String farmId;
  
  // Business (4)
  final String transferId;
  final String animalId;
  final int? quantity;
  final String? healthStatusAtTransfer;
  final String? notes;
  
  // Sync (5)
  final bool synced;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSyncedAt;
  final String? serverVersion;
}
```

### TransferDocument Model (Proposed - 120 lines)

```dart
enum TransferDocumentType { 
  healthCertificate, receipt, invoice, customs, other 
}

class TransferDocument implements SyncableEntity {
  // Identification (3)
  final String id;
  final String farmId;
  
  // Business (9)
  final String transferId;
  final TransferDocumentType documentType;
  final String filePath;
  final String fileName;
  final String? mimeType;
  final int? fileSize;
  final String? uploadedById;
  final DateTime uploadDate;
  final DateTime? expiryDate;
  
  // Sync (5)
  final bool synced;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSyncedAt;
  final String? serverVersion;
}
```

---

## 4. REPOSITORY PATTERN COMPARISON

### MovementRepository (Existing - 300 lines)

```dart
class MovementRepository {
  // CRUD (5)
  Future<List<Movement>> getAll(String farmId)
  Future<Movement?> getById(String id, String farmId)
  Future<void> create(Movement movement, String farmId)
  Future<void> update(Movement movement, String farmId)
  Future<void> delete(String id, String farmId)
  
  // Queries (8)
  Future<List<Movement>> getByAnimalId(String farmId, String animalId)
  Future<List<Movement>> getByType(String farmId, MovementType type)
  Future<List<Movement>> getByDateRange(String farmId, DateTime start, DateTime end)
  Future<List<Movement>> getByTypeAndDateRange(String farmId, MovementType type, DateTime start, DateTime end)
  Future<List<Movement>> getBirths(String farmId)
  Future<List<Movement>> getPurchases(String farmId)
  Future<List<Movement>> getSales(String farmId)
  Future<List<Movement>> getDeaths(String farmId)
  Future<List<Movement>> getSlaughters(String farmId)
  
  // Helpers (4)
  Movement _mapToModel(MovementsTableData data)
  MovementsTableCompanion _mapToCompanion(Movement movement, String farmId)
  String _getMovementTypeString(MovementType type)
  MovementType _getMovementType(String type)
}
```

### TransferRepository (Proposed - 350+ lines)

```dart
class TransferRepository {
  // CRUD (5)
  Future<List<Transfer>> getAll(String farmId)
  Future<Transfer?> getById(String id, String farmId)
  Future<void> create(Transfer transfer, String farmId)
  Future<void> update(Transfer transfer, String farmId)
  Future<void> delete(String id, String farmId)
  
  // Queries (10+)
  Future<List<Transfer>> getByType(String farmId, TransferType type)
  Future<List<Transfer>> getByStatus(String farmId, TransferStatus status)
  Future<List<Transfer>> getByFromFarm(String farmId, String fromFarmId)
  Future<List<Transfer>> getByToFarm(String farmId, String toFarmId)
  Future<List<Transfer>> getByDateRange(String farmId, DateTime start, DateTime end)
  Future<List<Transfer>> getPending(String farmId)
  Future<List<Transfer>> getByApprovalStatus(String farmId, bool approved)
  
  // Workflow (4)
  Future<void> approveTransfer(String transferId, String farmId, String vetId)
  Future<void> rejectTransfer(String transferId, String farmId, String reason)
  Future<void> completeTransfer(String transferId, String farmId)
  
  // Animals (3)
  Future<List<TransferAnimal>> getTransferAnimals(String transferId, String farmId)
  Future<void> addAnimalToTransfer(TransferAnimal animal, String farmId)
  Future<void> removeAnimalFromTransfer(String animalId, String transferId, String farmId)
  
  // Documents (2)
  Future<List<TransferDocument>> getTransferDocuments(String transferId, String farmId)
  Future<void> attachDocument(TransferDocument doc, String farmId)
  
  // Helpers (6)
  Transfer _mapToModel(TransfersTableData data)
  TransfersTableCompanion _mapToCompanion(Transfer transfer, String farmId)
  TransferAnimal _mapAnimalToModel(TransferAnimalsTableData data)
  TransferDocument _mapDocumentToModel(TransferDocumentsTableData data)
  String _getEnumString(dynamic enum)
  dynamic _getEnumValue(String value)
}
```

---

## 5. PROVIDER PATTERN COMPARISON

### Existing Providers Structure

Most providers follow this pattern:

```dart
final animalProvider = StateNotifierProvider<AnimalProvider, AsyncValue<List<Animal>>>((ref) {
  return AnimalProvider(ref.watch(animalRepositoryProvider));
});

class AnimalProvider extends StateNotifier<AsyncValue<List<Animal>>> {
  final AnimalRepository _repository;
  
  AnimalProvider(this._repository) : super(const AsyncValue.loading());
  
  Future<void> loadAnimals(String farmId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getAll(farmId));
  }
  
  Future<void> createAnimal(Animal animal) async {
    // Create logic
  }
}
```

### TransferProvider (Proposed - Similar Pattern)

```dart
final transferProvider = StateNotifierProvider<TransferProvider, AsyncValue<List<Transfer>>>((ref) {
  return TransferProvider(
    ref.watch(transferRepositoryProvider),
    ref.watch(authProvider),
  );
});

class TransferProvider extends StateNotifier<AsyncValue<List<Transfer>>> {
  final TransferRepository _repository;
  final AuthProvider _auth;
  
  // State
  List<TransferAnimal>? _currentTransferAnimals;
  List<TransferDocument>? _currentTransferDocuments;
  
  TransferProvider(this._repository, this._auth) 
    : super(const AsyncValue.loading());
  
  // Load transfers
  Future<void> loadTransfers(String farmId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getAll(farmId));
  }
  
  // CRUD
  Future<void> createTransfer(Transfer transfer) async { }
  Future<void> updateTransfer(Transfer transfer) async { }
  Future<void> deleteTransfer(String transferId) async { }
  
  // Workflow
  Future<void> approveTransfer(String transferId, String vetId) async { }
  Future<void> rejectTransfer(String transferId, String reason) async { }
  Future<void> completeTransfer(String transferId) async { }
  
  // Animals
  Future<void> loadTransferAnimals(String transferId) async { }
  Future<void> addAnimalToTransfer(TransferAnimal animal) async { }
  Future<void> removeAnimalFromTransfer(String animalId) async { }
  
  // Documents
  Future<void> loadTransferDocuments(String transferId) async { }
  Future<void> attachDocument(TransferDocument doc) async { }
}
```

---

## 6. UI COMPONENT COMPARISON

### Existing Screen Structure (Example: Animal List)

```
lib/screens/animal/
├── animal_list_screen.dart (300-500 lines)
│   ├── List view with filters
│   ├── Search functionality
│   ├── FAB for create
│   ├── Card-based items
│   └─ Detail navigation
├── animal_detail_screen.dart (400-600 lines)
│   ├── Tabs/sections
│   ├── Edit capability
│   ├── Related data (weights, movements, etc)
│   └─ Actions (delete, etc)
└── animal_form_screen.dart (500-700 lines)
    ├── Form validation
    ├── Image upload
    ├── RFID scanning
    └─ Save/Cancel buttons
```

### Proposed Transfer Screen Structure

```
lib/screens/transfer/
├── transfer_list_screen.dart (400-600 lines)
│   ├── List with status filters
│   ├── Type/status badges
│   ├── Pending count badge
│   ├── FAB for new transfer
│   └─ Navigation to detail
├── transfer_detail_screen.dart (500-700 lines)
│   ├── Transfer info section
│   ├── Animals list (expandable)
│   ├── Documents section
│   ├── Approval workflow UI
│   ├── Timeline view
│   └─ Action buttons (approve, reject, complete)
├── transfer_form_screen.dart (600-800 lines)
│   ├── Farm selector (from/to)
│   ├── Animal multi-selector
│   ├── Reason textarea
│   ├── Date picker
│   ├── Health status fields
│   └─ Save button
├── transfer_approval_screen.dart (300-400 lines)
│   ├── Pending transfers list
│   ├── Approval/rejection buttons
│   ├── Digital signature
│   └─ Notes field
└── transfer_document_upload.dart (200-300 lines)
    ├── Document type selector
    ├── File picker
    ├── Expiry date (optional)
    └─ Upload button
```

### Supporting Widgets

**Existing Examples:**
- AnimalCard (list item)
- AnimalStatusBadge
- WeightHistoryChart
- VaccinationTimeline

**Proposed Transfers Widgets:**
- TransferCard (list item)
- TransferStatusBadge (pending/accepted/rejected/completed)
- TransferAnimalsList (expandable list)
- TransferDocumentPreview
- TransferTimeline
- ApprovalWorkflowWidget

---

## 7. I18N KEYS COMPARISON

### Movement I18n Keys (18-20 keys)

```dart
'movement.title'
'movement.list'
'movement.type'
'movement.date'
'movement.animal'
'movement.price'
'movement.notes'
'movementType.birth'
'movementType.purchase'
'movementType.sale'
'movementType.death'
'movementType.slaughter'
// ... about 8-10 more
```

### Transfer I18n Keys (40-50 keys)

```dart
// Types (5)
'transferType.interFarm'
'transferType.intraFarm'
'transferType.incoming'
'transferType.outgoing'
'transferType.emergency'

// Statuses (4)
'transferStatus.pending'
'transferStatus.accepted'
'transferStatus.rejected'
'transferStatus.completed'

// Document Types (5)
'transferDocumentType.healthCertificate'
'transferDocumentType.receipt'
'transferDocumentType.invoice'
'transferDocumentType.customs'
'transferDocumentType.other'

// UI Labels (15+)
'transfer.title'
'transfer.list'
'transfer.new'
'transfer.details'
'transfer.fromFarm'
'transfer.toFarm'
'transfer.animals'
'transfer.documents'
'transfer.reason'
'transfer.status'
'transfer.approvedBy'
'transfer.approvalDate'
'transfer.qrSignature'
'transfer.createdAt'
'transfer.notes'

// Actions (10+)
'transfer.create'
'transfer.edit'
'transfer.delete'
'transfer.approve'
'transfer.reject'
'transfer.complete'
'transfer.track'
'transfer.export'
'transfer.addAnimal'
'transfer.removeAnimal'
'transfer.uploadDocument'

// Messages (10+)
'transfer.confirmDelete'
'transfer.successCreate'
'transfer.successUpdate'
'transfer.successApprove'
'transfer.successReject'
'transfer.errorApprove'
'transfer.noPending'
'transfer.noAnimals'
'transfer.noDocuments'
// ... more messages
```

---

## 8. CONSTANTS COMPARISON

### Movement Constants (10-15 values)

```dart
class MovementConstants {
  static const String MOVEMENT_TYPE_BIRTH = 'birth';
  static const String MOVEMENT_TYPE_PURCHASE = 'purchase';
  static const String MOVEMENT_TYPE_SALE = 'sale';
  static const String MOVEMENT_TYPE_DEATH = 'death';
  static const String MOVEMENT_TYPE_SLAUGHTER = 'slaughter';
  
  static const List<String> MOVEMENT_TYPES = [...];
  
  static const int MOVEMENT_LIST_PAGE_SIZE = 20;
}
```

### Transfer Constants (30-40 values)

```dart
class TransferConstants {
  // Types (5)
  static const String TRANSFER_TYPE_INTER_FARM = 'inter_farm';
  static const String TRANSFER_TYPE_INTRA_FARM = 'intra_farm';
  static const String TRANSFER_TYPE_INCOMING = 'incoming';
  static const String TRANSFER_TYPE_OUTGOING = 'outgoing';
  static const String TRANSFER_TYPE_EMERGENCY = 'emergency';
  
  static const List<String> TRANSFER_TYPES = [...];
  
  // Statuses (4)
  static const String TRANSFER_STATUS_PENDING = 'pending';
  static const String TRANSFER_STATUS_ACCEPTED = 'accepted';
  static const String TRANSFER_STATUS_REJECTED = 'rejected';
  static const String TRANSFER_STATUS_COMPLETED = 'completed';
  
  static const List<String> TRANSFER_STATUSES = [...];
  
  // Document Types (5)
  static const String DOC_TYPE_HEALTH = 'health_certificate';
  static const String DOC_TYPE_RECEIPT = 'receipt';
  static const String DOC_TYPE_INVOICE = 'invoice';
  static const String DOC_TYPE_CUSTOMS = 'customs';
  static const String DOC_TYPE_OTHER = 'other';
  
  // Configuration
  static const int MIN_TRANSFER_DATE_DAYS_PAST = 0;
  static const int MAX_TRANSFER_DATE_DAYS_FUTURE = 30;
  static const int MAX_DOCUMENT_FILE_SIZE = 10 * 1024 * 1024;
  static const int TRANSFER_LIST_PAGE_SIZE = 20;
  static const int MAX_ANIMALS_PER_TRANSFER = 1000;
}
```

---

## 9. COMPLEXITY & EFFORT COMPARISON

| Aspect | Movement | Transfer | Ratio |
|--------|----------|----------|-------|
| **Database** |  |  |  |
| Tables | 1 | 3 | 3x |
| Columns | 18 | 35+ | 2x |
| DAOs | 1 | 3 | 3x |
| Indexes | 10 | 15 | 1.5x |
| **Models** |  |  |  |
| Model classes | 1 | 3 | 3x |
| Enums | 1 | 2 | 2x |
| Interfaces | 1 | 3 | 3x |
| **Repositories** |  |  |  |
| Repository classes | 1 | 1 | 1x |
| Methods | 15+ | 20+ | 1.3x |
| Logic complexity | Medium | Medium-High | 1.5x |
| **Providers** |  |  |  |
| Provider classes | 1 | 1 | 1x |
| State properties | 3-5 | 5-7 | 1.5x |
| Methods | 10+ | 15+ | 1.5x |
| **UI** |  |  |  |
| Screens | 2-3 | 5+ | 2-2.5x |
| Widgets | 3-4 | 5-6 | 1.5x |
| Lines of UI code | 1000-1500 | 2000-3000 | 2-2.5x |
| **I18n** |  |  |  |
| Keys | 18-20 | 45-50 | 2.5x |
| Translations needed | 18-20 | 180-200 | 10x |
| **Constants** |  |  |  |
| Values | 10-15 | 30-40 | 2.5-3x |
| **Total LOC** | 2000-2500 | 4500-6000 | 2-2.5x |
| **Estimated Hours** | N/A (existing) | 15-22 | N/A |

---

## 10. Key Differences

### What Transfer Has That Movement Doesn't

1. **Multi-step approval workflow** (pending → accepted/rejected → completed)
2. **Multiple farms involved** (from/to with different contexts)
3. **User tracking** (from_user, to_user, approver)
4. **Multiple animals per transfer** (junction table needed)
5. **Document management** (certificates, receipts, customs)
6. **Health status snapshots** (capture state at transfer time)
7. **Expiry dates** (for health certificates)
8. **QR dual-signature** (from both farms)
9. **Reason tracking** (why transfer occurred)

### What's Similar

1. **Database pattern** (same Drift ORM approach)
2. **Multi-tenancy** (farmId filtering)
3. **Sync readiness** (synced, lastSyncedAt, serverVersion fields)
4. **Soft-delete** (deletedAt field, not hard-delete)
5. **Timestamps** (createdAt, updatedAt)
6. **Repository pattern** (same business logic layer)
7. **Provider pattern** (same state management)
8. **I18n approach** (same localization system)
9. **Constants management** (same pattern)

---

## 11. Recommendations

### Best Practices to Follow

1. **Use Movement as Reference**
   - Copy/adapt table structure
   - Reuse DAO patterns
   - Follow repository conventions
   - Mirror provider architecture

2. **Phase the Implementation**
   - Phase 1: Database (3 tables, 3 DAOs)
   - Phase 2: Models (3 models, enums)
   - Phase 3: Repository (business logic)
   - Phase 4: Provider (state management)
   - Phase 5: UI (screens + widgets)
   - Phase 6: I18n + Constants + Testing

3. **Testing Strategy**
   - Unit test DAOs (queries, filtering)
   - Integration test Repository (mappings, validation)
   - Provider tests (state transitions)
   - UI tests (navigation, forms)
   - E2E tests (workflow, multi-farm)

4. **Code Generation**
   - Run build_runner after DAO updates
   - Generate .g.dart files
   - Test generation completion
   - Rebuild entire app after schema changes

---

## 12. Success Criteria

- [ ] All 3 Drift tables created and indexed
- [ ] All 3 DAOs implemented with required methods
- [ ] All 3 models with SyncableEntity implementation
- [ ] Repository with complete business logic
- [ ] Provider with async state management
- [ ] 5+ screens with proper navigation
- [ ] All i18n keys for 4 languages
- [ ] Constants class with all values
- [ ] No analyzer warnings (flutter analyze = 0)
- [ ] Successful app build (flutter run)
- [ ] Multi-farm security validated
- [ ] Soft-delete working correctly
- [ ] Phase 2 sync fields properly initialized

---

## Conclusion

The Transfer system is approximately **2-2.5x more complex** than the Movement system due to:
- 3x database tables/DAOs (vs 1)
- 3x model classes (vs 1)
- 2-2.5x UI components (vs basic list/detail)
- 2.5x more i18n keys
- Multi-step approval workflow
- Document management
- Multiple animals per transfer

**Estimated effort: 15-22 hours** following established patterns in the codebase.

