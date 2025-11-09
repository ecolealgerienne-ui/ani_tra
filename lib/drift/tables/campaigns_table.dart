// lib/drift/tables/campaigns_table.dart
import 'package:drift/drift.dart';

class CampaignsTable extends Table {
  @override
  String get tableName => 'campaigns';

  // Primary key
  TextColumn get id => text()();

  // farmId OBLIGATOIRE (multi-tenancy)
  TextColumn get farmId => text().named('farm_id')();

  // Campaign data
  TextColumn get name => text()();
  TextColumn get productId => text().named('product_id')();
  TextColumn get productName => text().named('product_name')();

  DateTimeColumn get campaignDate => dateTime().named('campaign_date')();
  DateTimeColumn get withdrawalEndDate =>
      dateTime().named('withdrawal_end_date')();

  // Veterinarian (optional)
  TextColumn get veterinarianId => text().nullable().named('veterinarian_id')();
  TextColumn get veterinarianName =>
      text().nullable().named('veterinarian_name')();

  // ⚡ IMPORTANT: animal_ids stocké en JSON
  // Exemple: '["animal-1", "animal-2", "animal-3"]'
  TextColumn get animalIdsJson => text().named('animal_ids_json')();

  BoolColumn get completed => boolean().withDefault(const Constant(false))();

  // Sync fields (future-proof)
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get lastSyncedAt =>
      dateTime().nullable().named('last_synced_at')();
  TextColumn get serverVersion => text().nullable().named('server_version')();

  @override
  Set<Column> get primaryKey => {id};
}
