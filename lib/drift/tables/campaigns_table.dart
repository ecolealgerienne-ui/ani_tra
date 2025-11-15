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

  // Soft-delete (audit trail)
  DateTimeColumn get deletedAt => dateTime().nullable().named('deleted_at')();

  @override
  Set<Column> get primaryKey => {id};

  /// Custom constraints + indexes
  /// FK campaigns.farm_id → farms.id + 4 performance indexes
  List<String> get customStatements => [
        // Foreign Key: campaigns.farm_id → farms.id
        'CREATE INDEX IF NOT EXISTS idx_campaigns_farmid ON campaigns(farm_id);',

        // Index for filtering active/completed campaigns by farm
        'CREATE INDEX IF NOT EXISTS idx_campaigns_farm_completed ON campaigns(farm_id, completed);',

        // Index for queries by withdrawal date
        'CREATE INDEX IF NOT EXISTS idx_campaigns_withdrawal_date ON campaigns(withdrawal_end_date, completed);',

        // Index for soft-delete queries (all queries filter on deleted_at)
        'CREATE INDEX IF NOT EXISTS idx_campaigns_deleted_at ON campaigns(deleted_at);',
      ];
}
