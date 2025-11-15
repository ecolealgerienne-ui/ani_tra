// lib/drift/tables/breedings_table.dart
import 'package:drift/drift.dart';

class BreedingsTable extends Table {
  @override
  String get tableName => 'breedings';

  // Primary key
  TextColumn get id => text()();

  // Multi-tenancy
  TextColumn get farmId => text().named('farm_id')();

  // Parent IDs
  TextColumn get motherId => text().named('mother_id')();
  TextColumn get fatherId => text().nullable().named('father_id')();
  TextColumn get fatherName => text().nullable().named('father_name')();

  // Breeding details
  TextColumn get method => text()(); // 'natural' or 'artificialInsemination'
  DateTimeColumn get breedingDate => dateTime().named('breeding_date')();
  DateTimeColumn get expectedBirthDate =>
      dateTime().named('expected_birth_date')();
  DateTimeColumn get actualBirthDate =>
      dateTime().nullable().named('actual_birth_date')();

  // Offspring
  IntColumn get expectedOffspringCount =>
      integer().nullable().named('expected_offspring_count')();
  TextColumn get offspringIds =>
      text().nullable().named('offspring_ids')(); // JSON array of IDs

  // Veterinarian (if AI)
  TextColumn get veterinarianId => text().nullable().named('veterinarian_id')();
  TextColumn get veterinarianName =>
      text().nullable().named('veterinarian_name')();

  // Additional info
  TextColumn get notes => text().nullable()();
  TextColumn get status =>
      text()(); // 'pending', 'completed', 'failed', 'aborted'

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

  @override
  List<String> get customConstraints => [
        'FOREIGN KEY (farm_id) REFERENCES farms(id)',
        'FOREIGN KEY (mother_id) REFERENCES animals(id)',
        'FOREIGN KEY (father_id) REFERENCES animals(id)',
      ];
}
