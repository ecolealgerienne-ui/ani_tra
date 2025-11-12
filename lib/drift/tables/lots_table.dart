// lib/drift/tables/lots_table.dart
import 'package:drift/drift.dart';

class LotsTable extends Table {
  @override
  String get tableName => 'lots';

  // Primary key
  TextColumn get id => text()();

  // farmId OBLIGATOIRE (multi-tenancy)
  TextColumn get farmId => text().named('farm_id')();

  // Core lot data
  TextColumn get name => text()();

  // Type nullable: 'treatment', 'sale', 'slaughter', ou NULL
  TextColumn get type => text().nullable()();

  // ⚠️ IMPORTANT: animal_ids stocké en JSON
  // Exemple: '["animal-1", "animal-2", "animal-3"]'
  TextColumn get animalIdsJson => text().named('animal_ids_json')();

  // PHASE 1: ADD - Status nullable: 'open', 'closed', 'archived'
  TextColumn get status => text().nullable().named('status')();

  // PHASE 1: KEEP - for backward-compatibility during migration
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt =>
      dateTime().nullable().named('completed_at')();

  // ==================== TREATMENT FIELDS ====================
  TextColumn get productId => text().nullable().named('product_id')();
  TextColumn get productName => text().nullable().named('product_name')();
  DateTimeColumn get treatmentDate =>
      dateTime().nullable().named('treatment_date')();
  DateTimeColumn get withdrawalEndDate =>
      dateTime().nullable().named('withdrawal_end_date')();
  TextColumn get veterinarianId => text().nullable().named('veterinarian_id')();
  TextColumn get veterinarianName =>
      text().nullable().named('veterinarian_name')();

  // ==================== SALE FIELDS ====================
  TextColumn get buyerName => text().nullable().named('buyer_name')();
  TextColumn get buyerFarmId => text().nullable().named('buyer_farm_id')();
  RealColumn get totalPrice => real().nullable().named('total_price')();
  RealColumn get pricePerAnimal =>
      real().nullable().named('price_per_animal')();
  DateTimeColumn get saleDate => dateTime().nullable().named('sale_date')();

  // ==================== SLAUGHTER FIELDS ====================
  TextColumn get slaughterhouseName =>
      text().nullable().named('slaughterhouse_name')();
  TextColumn get slaughterhouseId =>
      text().nullable().named('slaughterhouse_id')();
  DateTimeColumn get slaughterDate =>
      dateTime().nullable().named('slaughter_date')();

  // ==================== NOTES ====================
  TextColumn get notes => text().nullable()();

  // ==================== SYNC FIELDS (future-proof) ====================
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get lastSyncedAt =>
      dateTime().nullable().named('last_synced_at')();
  TextColumn get serverVersion => text().nullable().named('server_version')();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        // FK vers farms (multi-tenancy)
        'FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE',

        // Indexes pour performance
        'CREATE INDEX IF NOT EXISTS idx_lots_farm_id ON lots(farm_id)',
        'CREATE INDEX IF NOT EXISTS idx_lots_status ON lots(farm_id, status)',
        'CREATE INDEX IF NOT EXISTS idx_lots_created_at ON lots(farm_id, created_at DESC)',
      ];
}
