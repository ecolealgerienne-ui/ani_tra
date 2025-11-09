// lib/drift/tables/batches_table.dart
import 'package:drift/drift.dart';

class BatchesTable extends Table {
  @override
  String get tableName => 'batches';

  // Primary key
  TextColumn get id => text()();

  // farmId OBLIGATOIRE (multi-tenancy)
  TextColumn get farmId => text().named('farm_id')();

  // Batch data
  TextColumn get name => text()();
  TextColumn get purpose => text()(); // sale, slaughter, treatment, other
  
  // ⚡ IMPORTANT: animal_ids stocké en JSON
  // Exemple: '["animal-1", "animal-2", "animal-3"]'
  TextColumn get animalIdsJson => text().named('animal_ids_json')();
  
  DateTimeColumn get usedAt => dateTime().nullable().named('used_at')();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();

  // Sync fields (future-proof)
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get lastSyncedAt => dateTime().nullable().named('last_synced_at')();
  TextColumn get serverVersion => text().nullable().named('server_version')();

  @override
  Set<Column> get primaryKey => {id};
}
