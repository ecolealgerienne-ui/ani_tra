// lib/drift/tables/animals_table.dart
import 'package:drift/drift.dart';

class AnimalsTable extends Table {
  @override
  String get tableName => 'animals';

  // Primary key
  TextColumn get id => text()();

  // Multi-tenancy
  TextColumn get farmId => text().named('farm_id')();

  // Localisation physique
  /// Localisation physique actuelle de l'animal (peut différer de farmId)
  /// NULL = animal chez son propriétaire (farmId)
  /// Non-NULL = animal en mouvement temporaire (prêt, transhumance, etc.)
  TextColumn get currentLocationFarmId =>
      text().nullable().named('current_location_farm_id')();

  // Identifications
  TextColumn get currentEid => text().nullable().named('current_eid')();
  TextColumn get officialNumber => text().nullable().named('official_number')();
  TextColumn get visualId => text().nullable().named('visual_id')();

  // EID History (stored as JSON)
  TextColumn get eidHistory => text().nullable().named('eid_history')();

  // Biological data
  DateTimeColumn get birthDate => dateTime().named('birth_date')();
  TextColumn get sex => text()(); // 'male' or 'female'
  TextColumn get motherId => text().nullable().named('mother_id')();

  // Status
  TextColumn get status =>
      text()(); // 'alive', 'sold', 'dead', 'slaughtered', 'draft'

  // DRAFT System
  DateTimeColumn get validatedAt =>
      dateTime().nullable().named('validated_at')();

  // Species & Breed
  TextColumn get speciesId => text().nullable().named('species_id')();
  TextColumn get breedId => text().nullable().named('breed_id')();

  // Photo
  TextColumn get photoUrl => text().nullable().named('photo_url')();

  // Notes libres sur l'animal (max 1000 caractères)
  TextColumn get notes => text().nullable()();

  // Deprecated field (kept for compatibility)
  IntColumn get days => integer().nullable()();

  // Sync fields (Phase 2 ready)
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSyncedAt =>
      dateTime().nullable().named('last_synced_at')();
  TextColumn get serverVersion => text().nullable().named('server_version')();

  // Soft-delete (audit trail)
  DateTimeColumn get deletedAt => dateTime().nullable().named('deleted_at')();

  // Timestamps
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};

  // ==================== B2: Foreign Key Constraint ====================
  /// ⚡ IMPORTANT: customConstraints MUST return String (singular), not List!
  /// Only include FOREIGN KEY here, NOT CREATE INDEX statements
  /// Indexes are defined in database.dart within _createAnimalsIndexes()
  @override
  List<String> get customConstraints => [
        'FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE',
        // ==================== UNIQUE Constraints ====================
        // Un EID (current_eid) doit être unique par ferme (doublons interdits)
        // Note: SQLite permet plusieurs NULL sans violation
        'UNIQUE(farm_id, current_eid)',
        // Un numéro officiel (official_number) doit être unique par ferme
        'UNIQUE(farm_id, official_number)',
        // visual_id: PAS de contrainte UNIQUE (doublons autorisés)
      ];
}
