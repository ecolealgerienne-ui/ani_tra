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

  DateTimeColumn get usedAt => dateTime().nullable().named('used_at')();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();

  // Sync fields (future-proof)
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get lastSyncedAt =>
      dateTime().nullable().named('last_synced_at')();
  TextColumn get serverVersion => text().nullable().named('server_version')();

  // Soft-delete (audit trail)
  DateTimeColumn get deletedAt => dateTime().nullable().named('deleted_at')();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {farmId, name}, // Unique batch name par farm
      ];

  @override
  List<String> get customConstraints => [
        'FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE',
      ];
}
