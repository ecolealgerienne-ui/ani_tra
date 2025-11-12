// lib/drift/tables/animals_table.dart
import 'package:drift/drift.dart';

class AnimalsTable extends Table {
  @override
  String get tableName => 'animals';

  // Primary key
  TextColumn get id => text()();

  // Multi-tenancy
  TextColumn get farmId => text().named('farm_id')();

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
  TextColumn get status => text()(); // 'alive', 'sold', 'dead', 'slaughtered'

  // Species & Breed
  TextColumn get speciesId => text().nullable().named('species_id')();
  TextColumn get breedId => text().nullable().named('breed_id')();

  // Photo
  TextColumn get photoUrl => text().nullable().named('photo_url')();

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

  // ==================== B2: Foreign Key Constraints + Indexes ====================
  // Combine les FK et les indexes pour l'intégrité et la performance
  @override
  List<String> get customConstraints => [
        // FK pour intégrité référentielle
        'FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE',

        // Index 1: Recherches par ferme (TRÈS FRÉQUENT)
        'CREATE INDEX IF NOT EXISTS idx_animals_farm_id ON animals(farm_id)',

        // Index 2: Recherches multi-colonnes farm + statut (filtrage courant)
        'CREATE INDEX IF NOT EXISTS idx_animals_farm_status ON animals(farm_id, status)',

        // Index 3: Tri descendant par date de création (pagination/listing)
        'CREATE INDEX IF NOT EXISTS idx_animals_created_desc ON animals(created_at DESC)',

        // Index 4: Soft-delete check (toutes les queries excluent deleted_at)
        'CREATE INDEX IF NOT EXISTS idx_animals_deleted_at ON animals(deleted_at)',

        // Index 5: Recherches par EID (identification courante)
        'CREATE INDEX IF NOT EXISTS idx_animals_farm_eid ON animals(farm_id, current_eid)',
      ];
}
