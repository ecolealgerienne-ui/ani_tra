# 🌾 FARM SETTINGS SCREEN - SPECIFICATIONS DÉTAILLÉES

**Version:** 1.0  
**Date:** 2025-11-14  
**Phase:** 1B/1C - Architecture & Persistence  
**Status:** Ready for Implementation

---

## 📋 TABLE OF CONTENTS

1. [Overview & Architecture](#1-overview--architecture)
2. [Data Models](#2-data-models)
3. [Database Schema](#3-database-schema)
4. [Providers Architecture](#4-providers-architecture)
5. [Repository Pattern](#5-repository-pattern)
6. [UI Components](#6-ui-components)
7. [Data Flow](#7-data-flow)
8. [I18n Keys & Translations](#8-i18n-keys--translations)
9. [Constants](#9-constants)
10. [Edge Cases & Error Handling](#10-edge-cases--error-handling)
11. [Implementation Checklist](#11-implementation-checklist)

---

## 1. OVERVIEW & ARCHITECTURE

### 1.1 Purpose
Farm Settings Screen provides a unified interface for managing all farm-specific configurations:
- Farm selection and switching
- Breeding preferences (default species, breed)
- Default veterinarian assignment
- Alert configurations (enable/disable per farm)

### 1.2 Key Principles

```
Backend = Source of Truth
    ↓
App Drift Database (cached + sync fields)
    ↓
Providers (reactive, farm-aware)
    ↓
UI (FarmSettingsScreen + 4 sections)
    ↓
Phase 2: SyncService (detect synced=false, upload changes)
```

### 1.3 Multi-Farm Architecture

```
AuthProvider.currentFarmId (single source of truth)
    ├─ Persisted in SharedPrefs: 'last_selected_farm_id'
    ├─ Loaded on app startup
    └─ Changed via AuthProvider.switchFarm(farmId)

All Providers Listen to AuthProvider:
    ├─ FarmProvider
    ├─ FarmPreferencesProvider
    ├─ VeterinarianProvider
    ├─ AlertConfigurationProvider
    └─ AnimalProvider (existing)
```

### 1.4 Sync-Ready Architecture (Phase 2)

All data tables include:
```dart
- synced: bool (default: false for new local records)
- lastSyncedAt: DateTime? (null until first sync)
- serverVersion: String? (version from backend)
- deletedAt: DateTime? (soft-delete field)
```

When user modifies data locally:
```
update(item) → mark synced=false → Phase 2 SyncService detects → uploads
```

---

## 2. DATA MODELS

### 2.1 FarmPreferences Model

**File:** `lib/models/farm_preferences.dart`

```dart
import 'syncable_entity.dart';

class FarmPreferences implements SyncableEntity {
  // === Identification ===
  @override
  final String id;
  
  @override
  final String farmId; // FK → Farms
  
  // === Preferences ===
  final String? defaultVeterinarianId; // FK → Veterinarians (nullable)
  final String defaultSpeciesId;       // Ex: 'sheep', 'cattle', 'goat'
  final String? defaultBreedId;        // Ex: 'merinos', 'charolaise'
  
  // === Sync Fields (Phase 2) ===
  @override
  final bool synced;
  
  @override
  final DateTime? lastSyncedAt;
  
  @override
  final String? serverVersion;
  
  // === Soft-Delete & Audit ===
  final DateTime? deletedAt;
  
  @override
  final DateTime createdAt;
  
  @override
  final DateTime updatedAt;
  
  // === Constructor ===
  const FarmPreferences({
    required this.id,
    required this.farmId,
    this.defaultVeterinarianId,
    required this.defaultSpeciesId,
    this.defaultBreedId,
    this.synced = false,
    this.lastSyncedAt,
    this.serverVersion,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  
  // === Getters ===
  
  bool get isActive => deletedAt == null;
  bool get hasDefaultVeterinarian => defaultVeterinarianId != null && 
                                     defaultVeterinarianId!.isNotEmpty;
  bool get hasDefaultBreed => defaultBreedId != null && 
                              defaultBreedId!.isNotEmpty;
  
  // === Methods ===
  
  FarmPreferences copyWith({
    String? defaultVeterinarianId,
    String? defaultSpeciesId,
    String? defaultBreedId,
    bool? synced,
    DateTime? lastSyncedAt,
    String? serverVersion,
    DateTime? deletedAt,
    DateTime? updatedAt,
  }) {
    return FarmPreferences(
      id: id,
      farmId: farmId,
      defaultVeterinarianId: defaultVeterinarianId ?? this.defaultVeterinarianId,
      defaultSpeciesId: defaultSpeciesId ?? this.defaultSpeciesId,
      defaultBreedId: defaultBreedId ?? this.defaultBreedId,
      synced: synced ?? this.synced,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
  
  // === Sync Methods ===
  
  FarmPreferences markAsSynced({required String serverVersion}) {
    return copyWith(
      synced: true,
      lastSyncedAt: DateTime.now(),
      serverVersion: serverVersion,
    );
  }
  
  FarmPreferences markAsModified() {
    return copyWith(
      synced: false,
      updatedAt: DateTime.now(),
    );
  }
  
  // === JSON Serialization ===
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'farm_id': farmId,
    'default_veterinarian_id': defaultVeterinarianId,
    'default_species_id': defaultSpeciesId,
    'default_breed_id': defaultBreedId,
    'synced': synced,
    'last_synced_at': lastSyncedAt?.toIso8601String(),
    'server_version': serverVersion,
    'deleted_at': deletedAt?.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
  
  factory FarmPreferences.fromJson(Map<String, dynamic> json) => FarmPreferences(
    id: json['id'] as String,
    farmId: json['farm_id'] as String,
    defaultVeterinarianId: json['default_veterinarian_id'] as String?,
    defaultSpeciesId: json['default_species_id'] as String,
    defaultBreedId: json['default_breed_id'] as String?,
    synced: json['synced'] as bool? ?? false,
    lastSyncedAt: json['last_synced_at'] != null 
      ? DateTime.parse(json['last_synced_at'] as String)
      : null,
    serverVersion: json['server_version'] as String?,
    deletedAt: json['deleted_at'] != null
      ? DateTime.parse(json['deleted_at'] as String)
      : null,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );
}
```

---

## 3. DATABASE SCHEMA

### 3.1 FarmPreferencesTable (Drift)

**File:** `lib/drift/tables/farm_preferences_table.dart`

```dart
import 'package:drift/drift.dart';

class FarmPreferencesTable extends Table {
  @override
  String get tableName => 'farm_preferences';
  
  // ========== PRIMARY KEY ==========
  TextColumn get id => text()();
  
  // ========== FOREIGN KEY ==========
  /// Reference to farms table
  TextColumn get farmId => text().named('farm_id')();
  
  // ========== PREFERENCES DATA ==========
  /// Default veterinarian for this farm (FK → veterinarians, nullable)
  TextColumn get defaultVeterinarianId => 
    text().nullable().named('default_veterinarian_id')();
  
  /// Default animal species (Ex: 'sheep', 'cattle', 'goat')
  TextColumn get defaultSpeciesId => text().named('default_species_id')();
  
  /// Default animal breed (Ex: 'merinos', 'charolaise', nullable)
  TextColumn get defaultBreedId => text().nullable().named('default_breed_id')();
  
  // ========== SYNC FIELDS (Phase 2) ==========
  /// Has this record been synced to backend?
  BoolColumn get synced => 
    boolean().withDefault(const Constant(false))();
  
  /// When was this record last synced?
  DateTimeColumn get lastSyncedAt => 
    dateTime().nullable().named('last_synced_at')();
  
  /// Version from backend (for conflict resolution)
  TextColumn get serverVersion => 
    text().nullable().named('server_version')();
  
  // ========== SOFT-DELETE & AUDIT ==========
  /// Soft-delete timestamp (null = active)
  DateTimeColumn get deletedAt => 
    dateTime().nullable().named('deleted_at')();
  
  /// Creation timestamp
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  
  /// Last modification timestamp
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  
  // ========== KEYS & CONSTRAINTS ==========
  
  @override
  Set<Column> get primaryKey => {id};
  
  /// One FarmPreferences per Farm (unique constraint)
  @override
  List<Set<Column>> get uniqueKeys => [
    {farmId}, // Only one prefs row per farm
  ];
  
  /// Foreign key constraint
  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (farm_id) REFERENCES farms(id)',
  ];
}
```

### 3.2 Database Indexes (in database.dart)

```dart
Future<void> _createFarmPreferencesIndexes() async {
  // Main index: farmId (lookup by farm)
  await customStatement(
    'CREATE INDEX IF NOT EXISTS idx_farm_prefs_farm_id '
    'ON farm_preferences(farm_id);',
  );
  
  // Index: synced (Phase 2 - find unsync'd records)
  await customStatement(
    'CREATE INDEX IF NOT EXISTS idx_farm_prefs_synced '
    'ON farm_preferences(synced);',
  );
  
  // Composite index: farmId + synced (Phase 2)
  await customStatement(
    'CREATE INDEX IF NOT EXISTS idx_farm_prefs_farm_synced '
    'ON farm_preferences(farm_id, synced);',
  );
  
  // Soft-delete index
  await customStatement(
    'CREATE INDEX IF NOT EXISTS idx_farm_prefs_deleted_at '
    'ON farm_preferences(deleted_at);',
  );
}
```

### 3.3 Add to database.dart

```dart
// In imports section:
import 'tables/farm_preferences_table.dart';
import 'daos/farm_preferences_dao.dart';

// In @DriftDatabase decorator:
tables: [
  // ... existing tables
  FarmPreferencesTable,  // ← ADD THIS
],
daos: [
  // ... existing daos
  FarmPreferencesDao,    // ← ADD THIS
],

// In class body:
@override
FarmPreferencesDao get farmPreferencesDao => FarmPreferencesDao(this);

// In onCreate migration:
await _createFarmPreferencesIndexes();
```

---

## 4. PROVIDERS ARCHITECTURE

### 4.1 FarmProvider (NEW)

**File:** `lib/providers/farm_provider.dart`

```dart
import 'package:flutter/foundation.dart';
import '../models/farm.dart';
import '../repositories/farm_repository.dart';
import 'auth_provider.dart';

/// Provider for Farm management
/// - Load farms from Database
/// - Listen to AuthProvider for farm changes
/// - Expose: farms list, currentFarm
/// - Filtered by currentFarmId
class FarmProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  final FarmRepository _repository;
  String _currentFarmId;
  
  // ========== STATE ==========
  List<Farm> _farms = [];
  bool _isLoading = false;
  String? _error;
  
  FarmProvider(this._authProvider, this._repository)
      : _currentFarmId = _authProvider.currentFarmId {
    // Listen to farm changes in AuthProvider
    _authProvider.addListener(_onFarmChanged);
    
    // Initial load
    _loadFarms();
  }
  
  // ========== LIFECYCLE ==========
  
  void _onFarmChanged() {
    if (_currentFarmId != _authProvider.currentFarmId) {
      _currentFarmId = _authProvider.currentFarmId;
      notifyListeners(); // Notify UI of farm change
    }
  }
  
  @override
  void dispose() {
    _authProvider.removeListener(_onFarmChanged);
    super.dispose();
  }
  
  // ========== GETTERS ==========
  
  /// All farms available to current user
  List<Farm> get farms => List.unmodifiable(_farms);
  
  /// Current selected farm (from AuthProvider.currentFarmId)
  Farm? get currentFarm {
    try {
      return _farms.firstWhere((f) => f.id == _currentFarmId);
    } catch (e) {
      return null;
    }
  }
  
  /// Current farm ID
  String get currentFarmId => _currentFarmId;
  
  /// Loading state
  bool get isLoading => _isLoading;
  
  /// Error state
  String? get error => _error;
  
  /// Has any farms
  bool get hasFarms => _farms.isNotEmpty;
  
  // ========== LOAD DATA ==========
  
  Future<void> _loadFarms() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _farms = await _repository.getAll();
      _error = null;
    } catch (e) {
      _error = 'Error loading farms: $e';
      _farms = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // ========== PUBLIC METHODS ==========
  
  /// Refresh farms from database
  Future<void> refresh() async {
    await _loadFarms();
  }
  
  /// Get farm by ID
  Farm? getFarmById(String id) {
    try {
      return _farms.firstWhere((f) => f.id == id);
    } catch (e) {
      return null;
    }
  }
}
```

---

### 4.2 FarmPreferencesProvider (NEW)

**File:** `lib/providers/farm_preferences_provider.dart`

```dart
import 'package:flutter/foundation.dart';
import '../models/farm_preferences.dart';
import '../repositories/farm_preferences_repository.dart';
import 'auth_provider.dart';

/// Provider for Farm Preferences management
/// - Load preferences for current farm
/// - Listen to AuthProvider for farm changes
/// - Handle updates (mark synced=false)
/// - Expose: preferences for currentFarm
class FarmPreferencesProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  final FarmPreferencesRepository _repository;
  String _currentFarmId;
  
  // ========== STATE ==========
  FarmPreferences? _preferences;
  bool _isLoading = false;
  String? _error;
  
  FarmPreferencesProvider(this._authProvider, this._repository)
      : _currentFarmId = _authProvider.currentFarmId {
    // Listen to farm changes
    _authProvider.addListener(_onFarmChanged);
    
    // Initial load
    _loadPreferences();
  }
  
  // ========== LIFECYCLE ==========
  
  void _onFarmChanged() {
    if (_currentFarmId != _authProvider.currentFarmId) {
      _currentFarmId = _authProvider.currentFarmId;
      _loadPreferences();
    }
  }
  
  @override
  void dispose() {
    _authProvider.removeListener(_onFarmChanged);
    super.dispose();
  }
  
  // ========== GETTERS ==========
  
  /// Preferences for current farm (null if not loaded)
  FarmPreferences? get preferences => _preferences;
  
  /// Current farm ID
  String get currentFarmId => _currentFarmId;
  
  /// Loading state
  bool get isLoading => _isLoading;
  
  /// Error state
  String? get error => _error;
  
  /// Convenience getters
  String? get defaultVeterinarianId => _preferences?.defaultVeterinarianId;
  
  String get defaultSpeciesId => 
    _preferences?.defaultSpeciesId ?? 'sheep';
  
  String? get defaultBreedId => _preferences?.defaultBreedId;
  
  bool get isPreferencesSynced => _preferences?.synced ?? false;
  
  // ========== LOAD DATA ==========
  
  Future<void> _loadPreferences() async {
    if (_currentFarmId.isEmpty) {
      _preferences = null;
      return;
    }
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _preferences = await _repository.getByFarmId(_currentFarmId);
      _error = null;
    } catch (e) {
      _error = 'Error loading preferences: $e';
      _preferences = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // ========== UPDATE METHODS ==========
  
  /// Update default veterinarian
  Future<void> updateDefaultVeterinarian(String? vetId) async {
    if (_preferences == null) return;
    
    try {
      final updated = _preferences!.copyWith(
        defaultVeterinarianId: vetId,
      ).markAsModified(); // ← Mark as NOT synced
      
      await _repository.update(updated, _currentFarmId);
      _preferences = updated;
      notifyListeners();
    } catch (e) {
      _error = 'Error updating veterinarian: $e';
      notifyListeners();
    }
  }
  
  /// Update default species
  Future<void> updateDefaultSpecies(String speciesId) async {
    if (_preferences == null) return;
    
    try {
      final updated = _preferences!.copyWith(
        defaultSpeciesId: speciesId,
      ).markAsModified(); // ← Mark as NOT synced
      
      await _repository.update(updated, _currentFarmId);
      _preferences = updated;
      notifyListeners();
    } catch (e) {
      _error = 'Error updating species: $e';
      notifyListeners();
    }
  }
  
  /// Update default breed
  Future<void> updateDefaultBreed(String? breedId) async {
    if (_preferences == null) return;
    
    try {
      final updated = _preferences!.copyWith(
        defaultBreedId: breedId,
      ).markAsModified(); // ← Mark as NOT synced
      
      await _repository.update(updated, _currentFarmId);
      _preferences = updated;
      notifyListeners();
    } catch (e) {
      _error = 'Error updating breed: $e';
      notifyListeners();
    }
  }
  
  // ========== PUBLIC METHODS ==========
  
  /// Refresh preferences from database
  Future<void> refresh() async {
    await _loadPreferences();
  }
}
```

---

### 4.3 AuthProvider MODIFICATION

**File:** `lib/providers/auth_provider.dart` (MODIFY)

```dart
// ADD IMPORTS at top:
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  static const String _defaultFarmId = 'farm_default';
  static const String _farmIdPrefsKey = 'last_selected_farm_id';
  
  User? _currentUser;
  List<Farm> _farms = [];
  late SharedPreferences _prefs; // ← ADD
  late String _currentFarmId;    // ← CHANGE from const to late
  
  // ========== INIT ==========
  
  AuthProvider() {
    _initAsync();
  }
  
  /// Initialize async (load SharedPrefs)
  Future<void> _initAsync() async {
    _prefs = await SharedPreferences.getInstance();
    
    // Load last selected farm from SharedPrefs
    final savedFarmId = _prefs.getString(_farmIdPrefsKey);
    _currentFarmId = savedFarmId ?? _defaultFarmId;
    
    _initMockUser();
    notifyListeners();
  }
  
  // ========== GETTERS (unchanged) ==========
  
  String get currentFarmId => _currentFarmId;
  // ... rest of getters stay the same
  
  // ========== SWITCH FARM ==========
  
  /// Switch to a different farm
  /// - Updates currentFarmId
  /// - Persists to SharedPreferences
  /// - Notifies all listeners
  Future<void> switchFarm(String farmId) async {
    if (_currentFarmId == farmId) return;
    
    try {
      // Validate farm exists
      if (!_farms.any((f) => f.id == farmId)) {
        throw Exception('Farm not found: $farmId');
      }
      
      // Update state
      _currentFarmId = farmId;
      
      // Persist to SharedPreferences
      await _prefs.setString(_farmIdPrefsKey, farmId);
      
      // Notify all listeners (triggers FarmProvider, etc.)
      notifyListeners();
      
    } catch (e) {
      debugPrint('❌ Error switching farm: $e');
      rethrow;
    }
  }
  
  // ========== MOCK USER (unchanged, but call in _initAsync) ==========
  
  void _initMockUser() {
    final now = DateTime.now();
    _currentUser = User(
      id: 'user_mock_001',
      email: 'martin.dupont@example.com',
      name: 'Martin Dupont',
      phone: '+33600000000',
      farmIds: [_currentFarmId],
      currentFarmId: _currentFarmId,
      createdAt: now,
      updatedAt: now,
    );
    
    _farms = [
      Farm(
        id: _currentFarmId,
        name: 'Ferme Allier',
        location: 'Allier, France',
        ownerId: 'user_mock_001',
        cheptelNumber: 'FR12345',
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
```

---

### 4.4 AlertConfigurationProvider (ENHANCE)

**File:** `lib/providers/alert_configuration_provider.dart` (CREATE if doesn't exist)

```dart
import 'package:flutter/foundation.dart';
import '../models/alert_configuration.dart';
import '../repositories/alert_configuration_repository.dart';
import 'auth_provider.dart';

/// Provider for Alert Configurations
/// - Load configs for current farm
/// - Listen to AuthProvider for farm changes
/// - Toggle enabled/disabled per config
class AlertConfigurationProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  final AlertConfigurationRepository _repository;
  String _currentFarmId;
  
  // ========== STATE ==========
  List<AlertConfiguration> _configurations = [];
  bool _isLoading = false;
  String? _error;
  
  AlertConfigurationProvider(this._authProvider, this._repository)
      : _currentFarmId = _authProvider.currentFarmId {
    _authProvider.addListener(_onFarmChanged);
    _loadConfigurations();
  }
  
  // ========== LIFECYCLE ==========
  
  void _onFarmChanged() {
    if (_currentFarmId != _authProvider.currentFarmId) {
      _currentFarmId = _authProvider.currentFarmId;
      _loadConfigurations();
    }
  }
  
  @override
  void dispose() {
    _authProvider.removeListener(_onFarmChanged);
    super.dispose();
  }
  
  // ========== GETTERS ==========
  
  /// All alert configurations for current farm
  List<AlertConfiguration> get configurations => 
    List.unmodifiable(_configurations);
  
  /// Enabled configurations only
  List<AlertConfiguration> get enabledConfigurations =>
    _configurations.where((c) => c.enabled).toList();
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // ========== LOAD DATA ==========
  
  Future<void> _loadConfigurations() async {
    if (_currentFarmId.isEmpty) {
      _configurations = [];
      return;
    }
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _configurations = await _repository.getAll(_currentFarmId);
      _error = null;
    } catch (e) {
      _error = 'Error loading configurations: $e';
      _configurations = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // ========== TOGGLE ALERT ==========
  
  /// Toggle alert configuration enabled/disabled
  /// - Updates DB
  /// - Marks as synced=false (Phase 2)
  /// - Notifies UI
  Future<void> toggleAlertConfiguration(
    String configId,
    bool newState,
  ) async {
    try {
      // Update in repository (marks synced=false)
      await _repository.toggleEnabled(configId, _currentFarmId, newState);
      
      // Update local state
      final index = _configurations.indexWhere((c) => c.id == configId);
      if (index != -1) {
        _configurations[index] = _configurations[index].copyWith(
          enabled: newState,
        );
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error toggling alert: $e';
      notifyListeners();
    }
  }
  
  // ========== PUBLIC METHODS ==========
  
  Future<void> refresh() async {
    await _loadConfigurations();
  }
  
  AlertConfiguration? getConfigurationById(String id) {
    try {
      return _configurations.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}
```

---

## 5. REPOSITORY PATTERN

### 5.1 FarmPreferencesRepository

**File:** `lib/repositories/farm_preferences_repository.dart`

```dart
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import '../drift/database.dart';
import '../models/farm_preferences.dart';

/// Repository for Farm Preferences
/// - Layer between Provider and DAO
/// - Handles security (farmId validation)
/// - Maps DB models ↔ App models
/// - Marks synced=false on updates
class FarmPreferencesRepository {
  final AppDatabase _db;
  static const _uuid = Uuid();
  
  FarmPreferencesRepository(this._db);
  
  // ========== READ ==========
  
  /// Get preferences for a farm
  Future<FarmPreferences?> getByFarmId(String farmId) async {
    final data = await _db.farmPreferencesDao.findByFarmId(farmId);
    return data != null ? _mapToModel(data) : null;
  }
  
  /// Get by ID with security check
  Future<FarmPreferences?> getById(String id, String farmId) async {
    final data = await _db.farmPreferencesDao.findById(id, farmId);
    if (data == null) return null;
    
    // Security: verify farmId matches
    if (data.farmId != farmId) {
      throw Exception('Security violation: Farm ID mismatch');
    }
    
    return _mapToModel(data);
  }
  
  // ========== CREATE ==========
  
  /// Create new farm preferences
  /// Called when a new farm is added
  Future<FarmPreferences> create(
    FarmPreferences prefs,
    String farmId,
  ) async {
    // Security: verify farmId
    if (prefs.farmId != farmId) {
      throw Exception('Security violation: Farm ID mismatch');
    }
    
    // Check if already exists
    final existing = await _db.farmPreferencesDao.findByFarmId(farmId);
    if (existing != null && existing.deletedAt == null) {
      throw Exception('Farm preferences already exist for this farm');
    }
    
    final now = DateTime.now();
    final newPrefs = prefs.copyWith(
      id: _uuid.v4(),
      createdAt: now,
      updatedAt: now,
    );
    
    final companion = _mapToCompanion(newPrefs);
    await _db.farmPreferencesDao.insertItem(companion);
    
    return newPrefs;
  }
  
  // ========== UPDATE ==========
  
  /// Update farm preferences
  /// Marks synced=false (Phase 2)
  Future<void> update(
    FarmPreferences prefs,
    String farmId,
  ) async {
    // Security: verify farmId
    if (prefs.farmId != farmId) {
      throw Exception('Security violation: Farm ID mismatch');
    }
    
    // Verify exists
    final existing = await _db.farmPreferencesDao.findById(prefs.id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Farm preferences not found');
    }
    
    // Mark as NOT synced (Phase 2)
    final updated = prefs.copyWith(
      synced: false,
      updatedAt: DateTime.now(),
    );
    
    final companion = _mapToCompanion(updated);
    await _db.farmPreferencesDao.updateItem(companion);
  }
  
  // ========== DELETE (Soft) ==========
  
  /// Soft-delete farm preferences
  Future<void> delete(String id, String farmId) async {
    final existing = await _db.farmPreferencesDao.findById(id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Farm preferences not found');
    }
    
    await _db.farmPreferencesDao.softDelete(id, farmId);
  }
  
  // ========== PHASE 2 - SYNC ==========
  
  /// Get unsynced records
  Future<List<FarmPreferences>> getUnsynced(String farmId) async {
    final data = await _db.farmPreferencesDao.getUnsynced(farmId);
    return data.map((d) => _mapToModel(d)).toList();
  }
  
  /// Mark as synced
  Future<void> markSynced(
    String id,
    String farmId, {
    String? serverVersion,
  }) async {
    final existing = await _db.farmPreferencesDao.findById(id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Farm preferences not found');
    }
    
    await _db.farmPreferencesDao.markSynced(
      id,
      farmId,
      serverVersion: serverVersion,
    );
  }
  
  // ========== MAPPERS ==========
  
  FarmPreferences _mapToModel(FarmPreferencesData data) {
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
```

---

## 6. UI COMPONENTS

### 6.1 FarmSettingsScreen Architecture

**File:** `lib/screens/settings/farm_settings_screen.dart`

```
FarmSettingsScreen (StatefulWidget)
├─ AppBar: "Paramètres Ferme" + Back Button
│
├─ SingleChildScrollView (with padding)
│
└─ Column: 4 Sections
    │
    ├─ Section 1: FARM MANAGEMENT
    │   ├─ Header: "🏡 FARM MANAGEMENT"
    │   ├─ Dropdown: Select Farm
    │   │   └─ Options from FarmProvider.farms
    │   │   └─ Current: AuthProvider.currentFarmId
    │   │   └─ onChanged: AuthProvider.switchFarm()
    │   │
    │   └─ [Loading state handling]
    │
    ├─ Divider()
    │
    ├─ Section 2: PREFS D'ÉLEVAGE
    │   ├─ Header: "🐑 PREFS D'ÉLEVAGE"
    │   ├─ Species Dropdown
    │   │   └─ Current: FarmPreferencesProvider.defaultSpeciesId
    │   │   └─ onChanged: updateDefaultSpecies()
    │   │
    │   └─ Breed Dropdown (filtered by species)
    │       └─ Current: FarmPreferencesProvider.defaultBreedId
    │       └─ onChanged: updateDefaultBreed()
    │
    ├─ Divider()
    │
    ├─ Section 3: VÉTÉRINAIRE PAR DÉFAUT
    │   ├─ Header: "🩺 VÉTÉRINAIRE PAR DÉFAUT"
    │   ├─ Display current vet (or "Non défini")
    │   └─ Button: [Changer]
    │       └─ onTap: Show veterinarian picker
    │
    ├─ Divider()
    │
    └─ Section 4: ALERTES CONFIGURÉES
        ├─ Header: "🔔 ALERTES CONFIGURÉES"
        ├─ List of AlertConfigurations
        │   └─ For each config:
        │       ├─ Switch: config.enabled
        │       ├─ Title: AppLocalizations.translate(config.titleKey)
        │       └─ onChanged: toggleAlertConfiguration()
        │
        └─ [Loading state handling]
```

### 6.2 Component Structure

```dart
// Section Header Widget
_buildSectionHeader(
  context: BuildContext,
  icon: String,      // '🏡'
  title: String,     // 'FARM MANAGEMENT'
)

// Dropdown Tile Widget
_buildDropdownTile(
  context: BuildContext,
  label: String,
  value: String,
  items: List<DropdownMenuItem>,
  onChanged: Function(String?),
)

// Alert Toggle Tile Widget
_buildAlertToggleTile(
  context: BuildContext,
  config: AlertConfiguration,
  onChanged: Function(bool),
)

// Loading State Widget
if (farmProvider.isLoading)
  Center(child: CircularProgressIndicator())

// Error State Widget
if (farmProvider.error != null)
  ErrorWidget(message: farmProvider.error!)
```

---

## 7. DATA FLOW

### 7.1 Complete Flow: Changing Farm

```
┌─────────────────────────────────────────────────────────┐
│ FarmSettingsScreen - User changes farm in dropdown       │
└─────────────────────────────────────────────────────────┘
                          ↓
        onChanged: (newFarmId) {
          AuthProvider.switchFarm(newFarmId)
        }
                          ↓
┌─────────────────────────────────────────────────────────┐
│ AuthProvider.switchFarm(farmId)                          │
├─────────────────────────────────────────────────────────┤
│ 1. Validate farm exists in _farms list                   │
│ 2. Update _currentFarmId = farmId                        │
│ 3. Save to SharedPrefs: 'last_selected_farm_id'          │
│ 4. notifyListeners()                                     │
└─────────────────────────────────────────────────────────┘
                          ↓
        All providers listening to AuthProvider
        detect change via _onFarmChanged()
                          ↓
┌─────────────────────────────────────────────────────────┐
│ PARALLEL RELOADS (triggered by notifyListeners)          │
├─────────────────────────────────────────────────────────┤
│                                                          │
│ FarmProvider._onFarmChanged()                            │
│ └─ _currentFarmId = newFarmId                            │
│ └─ notifyListeners() (triggers UI rebuild)              │
│                                                          │
│ FarmPreferencesProvider._onFarmChanged()                 │
│ └─ _currentFarmId = newFarmId                            │
│ └─ _loadPreferences() → FarmPreferencesRepository        │
│ └─ Fetch from DB for new farm                           │
│ └─ notifyListeners()                                    │
│                                                          │
│ VeterinarianProvider._onFarmChanged()                    │
│ └─ _currentFarmId = newFarmId                            │
│ └─ _loadVeterinariansFromRepository()                    │
│ └─ Fetch from DB filtered by farmId                     │
│ └─ notifyListeners()                                    │
│                                                          │
│ AlertConfigurationProvider._onFarmChanged()              │
│ └─ _currentFarmId = newFarmId                            │
│ └─ _loadConfigurations()                                │
│ └─ Fetch configs from DB for new farm                   │
│ └─ notifyListeners()                                    │
│                                                          │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│ FarmSettingsScreen REBUILDS                              │
├─────────────────────────────────────────────────────────┤
│                                                          │
│ Section 1 (FARM MANAGEMENT)                             │
│ └─ Dropdown now shows newFarmId as selected             │
│                                                          │
│ Section 2 (PREFS D'ÉLEVAGE)                             │
│ └─ Display defaultSpeciesId for new farm                │
│ └─ Display defaultBreedId for new farm                  │
│                                                          │
│ Section 3 (VET PAR DÉFAUT)                              │
│ └─ Show vet from FarmPreferences for new farm           │
│                                                          │
│ Section 4 (ALERTES)                                     │
│ └─ Show alert configs for new farm                      │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

### 7.2 Flow: Updating Preferences

```
User changes species in Dropdown
                ↓
_buildSpeciesDropdown(
  onChanged: (speciesId) async {
    await FarmPreferencesProvider.updateDefaultSpecies(speciesId)
  }
)
                ↓
FarmPreferencesProvider.updateDefaultSpecies(speciesId)
├─ prefs.copyWith(defaultSpeciesId: speciesId)
├─ .markAsModified() ← Sets synced=false
├─ Repository.update(updated, farmId)
│  ├─ Validates farmId
│  ├─ Updates DB
│  └─ Sets synced=false (Phase 2)
├─ _preferences = updated
└─ notifyListeners() → UI rebuilds
                ↓
Phase 2 (SyncService runs):
├─ Detects synced=false on FarmPreferences
├─ Uploads to Backend
├─ Backend responds with serverVersion
├─ Repository.markSynced(id, farmId, serverVersion)
└─ Updates DB: synced=true, lastSyncedAt=now, serverVersion=...
```

---

## 8. I18N KEYS & TRANSLATIONS

### 8.1 New Keys Required

**Add to `lib/i18n/app_strings.dart`:**

```dart
// ========== FARM SETTINGS SECTION HEADERS ==========
static const String farmSettingsTitle = 'farmSettingsTitle';
static const String farmManagement = 'farmManagement';
static const String farmPreferences = 'farmPreferences';
static const String defaultVeterinarian = 'defaultVeterinarian';
static const String alertsConfiguration = 'alertsConfiguration';

// ========== FARM MANAGEMENT ==========
static const String selectFarm = 'selectFarm';
static const String currentFarm = 'currentFarm'; // Already exists?
static const String changeFarm = 'changeFarm';
static const String farmSelected = 'farmSelected';

// ========== FARM PREFERENCES ==========
static const String defaultAnimalType = 'defaultAnimalType'; // Already exists?
static const String defaultBreed = 'defaultBreed'; // Already exists?
static const String selectSpecies = 'selectSpecies';
static const String selectBreed = 'selectBreed';
static const String noBreedSelected = 'noBreedSelected'; // Already exists?
static const String preferencesUpdated = 'preferencesUpdated';

// ========== DEFAULT VETERINARIAN ==========
static const String defaultVeterinarianSection = 'defaultVeterinarianSection';
static const String noVeterinarianDefined = 'noVeterinarianDefined'; // Already exists?
static const String selectVeterinarian = 'selectVeterinarian';
static const String changeVeterinarian = 'changeVeterinarian'; // Already exists?
static const String veterinarianUpdated = 'veterinarianUpdated';
static const String veterinarianChanged = 'veterinarianChanged';

// ========== ALERTS CONFIGURATION ==========
static const String alertsConfigured = 'alertsConfigured';
static const String enableAlerts = 'enableAlerts';
static const String disableAlerts = 'disableAlerts';
static const String alertToggled = 'alertToggled';
static const String noAlertsConfigured = 'noAlertsConfigured';

// ========== ERROR & LOADING STATES ==========
static const String loadingPreferences = 'loadingPreferences';
static const String errorLoadingPreferences = 'errorLoadingPreferences';
static const String savingChanges = 'savingChanges';
static const String changesSaved = 'changesSaved';
static const String errorSavingChanges = 'errorSavingChanges';
```

### 8.2 French Translations

**Add to `lib/i18n/strings_fr.dart`:**

```dart
// ========== FARM SETTINGS SECTION HEADERS ==========
'farmSettingsTitle': 'Paramètres de la Ferme',
'farmManagement': '🏡 FARM MANAGEMENT',
'farmPreferences': '🐑 PREFS D\'ÉLEVAGE',
'defaultVeterinarian': '🩺 VÉTÉRINAIRE PAR DÉFAUT',
'alertsConfiguration': '🔔 ALERTES CONFIGURÉES',

// ========== FARM MANAGEMENT ==========
'selectFarm': 'Sélectionner une ferme',
'currentFarm': 'Ferme actuelle',
'changeFarm': 'Changer de ferme',
'farmSelected': 'Ferme sélectionnée: {farmName}',

// ========== FARM PREFERENCES ==========
'defaultAnimalType': 'Type d\'animal par défaut',
'defaultBreed': 'Race par défaut',
'selectSpecies': 'Sélectionner le type d\'animal',
'selectBreed': 'Sélectionner la race',
'noBreedSelected': 'Aucune race',
'preferencesUpdated': 'Préférences d\'élevage mises à jour',

// ========== DEFAULT VETERINARIAN ==========
'defaultVeterinarianSection': 'Vétérinaire par défaut',
'noVeterinarianDefined': 'Aucun vétérinaire défini',
'selectVeterinarian': 'Sélectionner un vétérinaire',
'changeVeterinarian': 'Changer de vétérinaire',
'veterinarianUpdated': 'Vétérinaire par défaut mis à jour',
'veterinarianChanged': 'Vétérinaire changé: {vetName}',

// ========== ALERTS CONFIGURATION ==========
'alertsConfigured': 'Alertes configurées',
'enableAlerts': 'Activer les alertes',
'disableAlerts': 'Désactiver les alertes',
'alertToggled': 'Alerte {alertName}: {state}',
'noAlertsConfigured': 'Aucune alerte configurée',

// ========== ERROR & LOADING STATES ==========
'loadingPreferences': 'Chargement des préférences...',
'errorLoadingPreferences': 'Erreur lors du chargement des préférences',
'savingChanges': 'Enregistrement des modifications...',
'changesSaved': 'Modifications enregistrées',
'errorSavingChanges': 'Erreur lors de l\'enregistrement',
```

---

## 9. CONSTANTS

### 9.1 FarmSettings Constants

**Add to `lib/utils/constants.dart`:**

```dart
class FarmSettingsConstants {
  // ========== SIZING ==========
  static const double sectionSpacing = AppConstants.spacingLarge;
  static const double sectionHeaderHeight = 48.0;
  
  // ========== ANIMATION ==========
  static const Duration toggleDuration = Duration(milliseconds: 200);
  
  // ========== COLORS ==========
  static const Color sectionHeaderColor = AppConstants.primaryGreen;
  static const Color farmManagementBgColor = Color(0xFFF0F8FF);
  static const Color prefsBgColor = Color(0xFFFFF8F0);
  static const Color vetBgColor = Color(0xFFF8F0FF);
  static const Color alertsBgColor = Color(0xFFFFF0F0);
  
  // ========== ICONS ==========
  static const String iconFarmManagement = '🏡';
  static const String iconPrefs = '🐑';
  static const String iconVet = '🩺';
  static const String iconAlerts = '🔔';
  
  // ========== SHARED PREFERENCES KEYS ==========
  static const String prefKeyLastSelectedFarmId = 'last_selected_farm_id';
  static const String prefKeyFarmSettings = 'farm_settings';
  
  // ========== ERROR MESSAGES ==========
  static const String errorFarmNotFound = 'Ferme non trouvée';
  static const String errorLoadingFarm = 'Erreur lors du chargement de la ferme';
  static const String errorSwitchingFarm = 'Erreur lors du changement de ferme';
}
```

---

## 10. EDGE CASES & ERROR HANDLING

### 10.1 Scenarios

#### **Scenario 1: No Farms Available**
```
Condition: AuthProvider.farms.isEmpty

UI Behavior:
├─ Show loading spinner
├─ If error: show error message
└─ If no farms: show "Aucune ferme disponible"

Backend Sync (Phase 2):
└─ SyncService should fetch farms from backend
```

#### **Scenario 2: Invalid Farm ID**
```
Condition: User tries to select farm that doesn't exist

Error Handling:
├─ Repository throws exception
├─ Provider catches and sets error state
├─ UI shows error snackbar
└─ Current farm selection reverted
```

#### **Scenario 3: Network Error on Switch Farm**
```
Condition: switchFarm() called but backend unavailable (Phase 2)

Behavior:
├─ Local switch succeeds (currentFarmId changes)
├─ Data loads from local DB cache
├─ UI updates normally
├─ Phase 2: SyncService detects sync needed
└─ Retries when network available
```

#### **Scenario 4: Preferences Don't Exist**
```
Condition: Farm exists but no FarmPreferences record

Handling:
├─ getByFarmId() returns null
├─ Provider.preferences = null
├─ UI shows default values or "À configurer"
└─ First update creates the record
```

#### **Scenario 5: Concurrent Updates**
```
Condition: User updates 2 preferences simultaneously

Solution:
├─ Each update marks synced=false independently
├─ Both updates persisted to DB
├─ Phase 2: SyncService sends both to backend
└─ Backend merges changes (timestamp-based)
```

### 10.2 Error Handling Patterns

```dart
// In Provider methods
try {
  final data = await repository.getByFarmId(farmId);
  _preferences = data;
  _error = null;
} catch (e) {
  debugPrint('❌ Error: $e');
  _error = e.toString();
  _preferences = null;
} finally {
  _isLoading = false;
  notifyListeners();
}

// In UI
if (farmPreferencesProvider.error != null) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(farmPreferencesProvider.error!),
      backgroundColor: Colors.red,
    ),
  );
}
```

---

## 11. IMPLEMENTATION CHECKLIST

### Phase 1: Data Models & Database

- [ ] Create `lib/models/farm_preferences.dart`
- [ ] Create `lib/drift/tables/farm_preferences_table.dart`
- [ ] Create `lib/drift/daos/farm_preferences_dao.dart`
- [ ] Add table to `database.dart` (@DriftDatabase)
- [ ] Add DAO to `database.dart` (@DriftAccessor)
- [ ] Add indexes in `database.dart` (_createFarmPreferencesIndexes)
- [ ] Run `flutter pub run build_runner build --delete-conflicting-outputs`

### Phase 2: Repositories

- [ ] Create `lib/repositories/farm_preferences_repository.dart`
- [ ] Implement CRUD operations
- [ ] Implement sync methods (getUnsynced, markSynced)
- [ ] Add security checks (farmId validation)

### Phase 3: Providers

- [ ] Modify `lib/providers/auth_provider.dart` (switchFarm + SharedPrefs)
- [ ] Create `lib/providers/farm_provider.dart`
- [ ] Create `lib/providers/farm_preferences_provider.dart`
- [ ] Create/Enhance `lib/providers/alert_configuration_provider.dart`
- [ ] Register in `main.dart` MultiProvider

### Phase 4: UI Components

- [ ] Create `lib/screens/settings/farm_settings_screen.dart`
- [ ] Build Section 1: Farm Management (dropdown)
- [ ] Build Section 2: Prefs d'Élevage (species + breed dropdowns)
- [ ] Build Section 3: Vétérinaire (display + change button)
- [ ] Build Section 4: Alertes (toggle list)
- [ ] Add error/loading states
- [ ] Add reusable widgets

### Phase 5: I18n & Constants

- [ ] Add keys to `app_strings.dart`
- [ ] Add translations to `strings_fr.dart`
- [ ] Add constants to `constants.dart`
- [ ] Verify all strings are translated

### Phase 6: Integration & Testing

- [ ] Inject providers in `main.dart`
- [ ] Test farm switching (all sections update)
- [ ] Test preference updates (mark synced=false)
- [ ] Test alert toggle
- [ ] Test persistence (restart app → farm still selected)
- [ ] Test error states

### Phase 7: Phase 2 Sync-Ready

- [ ] Verify sync fields present in all tables
- [ ] Verify markAsModified() sets synced=false
- [ ] Create SyncService (Phase 2 actual implementation)
- [ ] Test sync flow (upload/download)

---

## 📊 ARCHITECTURE DIAGRAM

```
┌──────────────────────────────────────────────────────────────┐
│                    FARM SETTINGS SCREEN                      │
│                                                               │
│  Section 1: Farm Management (Dropdown)                       │
│  Section 2: Prefs d'Élevage (Species + Breed)               │
│  Section 3: Vétérinaire (Display + Change)                  │
│  Section 4: Alertes (Toggle Configs)                        │
└──────────────────────────────────────────────────────────────┘
                           │
                    ┌──────┴──────┐
                    ▼             ▼
         ┌──────────────────┐  ┌──────────────────────┐
         │ AuthProvider     │  │ Other Providers      │
         │ (currentFarmId)  │  │ - FarmProvider       │
         │ - switchFarm()   │  │ - FarmPrefsProvider  │
         │ - SharedPrefs    │  │ - VetProvider        │
         └──────────────────┘  │ - AlertConfigProvider│
                    │          └──────────────────────┘
                    │                    │
                    └────────┬───────────┘
                             ▼
         ┌──────────────────────────────────────┐
         │      REPOSITORIES (Business Logic)    │
         │ - FarmRepository                      │
         │ - FarmPreferencesRepository           │
         │ - VeterinarianRepository              │
         │ - AlertConfigurationRepository        │
         └──────────────────────────────────────┘
                             │
                    ┌────────┴────────┐
                    ▼                 ▼
         ┌──────────────────┐  ┌──────────────────────┐
         │   DAOs (Drift)   │  │ SYNC FIELDS (Phase2) │
         │ - FarmDao        │  │ - synced: bool       │
         │ - FarmPrefsDao   │  │ - lastSyncedAt       │
         │ - VetDao         │  │ - serverVersion      │
         │ - AlertConfigDao │  │ - deletedAt          │
         └──────────────────┘  └──────────────────────┘
                    │
                    ▼
         ┌──────────────────────────────────────┐
         │   SQLite (Drift Database)            │
         │ - farms                              │
         │ - farm_preferences                   │
         │ - veterinarians                      │
         │ - alert_configurations               │
         └──────────────────────────────────────┘
                    │
         ┌──────────┴────────────┐
         ▼                       ▼
    [Local Cache]         [Phase 2: Backend]
    (Offline First)        (SyncService)
                           - Upload changes
                           - Download updates
```

---

## 🎯 KEY POINTS RECAP

1. **Multi-Farm:** Everything filtered by `AuthProvider.currentFarmId`
2. **Persistence:** Last selected farm saved in SharedPrefs, loaded on startup
3. **Reactive:** All providers listen to AuthProvider changes
4. **Sync-Ready:** All tables have sync fields (synced, lastSyncedAt, serverVersion)
5. **Database-First:** All prefs stored in Drift, not SharedPrefs
6. **Security:** FarmId validation at Repository level
7. **Soft-Delete:** Maintains audit trail via deletedAt field
8. **Backend-Aligned:** Structure ready for server synchronization

---

**END OF SPECS DOCUMENT**

Status: ✅ Ready for Implementation
