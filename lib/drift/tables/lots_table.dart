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
  
  // âš¡ IMPORTANT: animal_ids stockÃ© en JSON
  // Exemple: '["animal-1", "animal-2", "animal-3"]'
  TextColumn get animalIdsJson => text().named('animal_ids_json')();
  
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable().named('completed_at')();

  // ==================== TREATMENT FIELDS ====================
  TextColumn get productId => text().nullable().named('product_id')();
  TextColumn get productName => text().nullable().named('product_name')();
  DateTimeColumn get treatmentDate => dateTime().nullable().named('treatment_date')();
  DateTimeColumn get withdrawalEndDate => dateTime().nullable().named('withdrawal_end_date')();
  TextColumn get veterinarianId => text().nullable().named('veterinarian_id')();
  TextColumn get veterinarianName => text().nullable().named('veterinarian_name')();

  // ==================== SALE FIELDS ====================
  TextColumn get buyerName => text().nullable().named('buyer_name')();
  TextColumn get buyerFarmId => text().nullable().named('buyer_farm_id')();
  RealColumn get totalPrice => real().nullable().named('total_price')();
  RealColumn get pricePerAnimal => real().nullable().named('price_per_animal')();
  DateTimeColumn get saleDate => dateTime().nullable().named('sale_date')();

  // ==================== SLAUGHTER FIELDS ====================
  TextColumn get slaughterhouseName => text().nullable().named('slaughterhouse_name')();
  TextColumn get slaughterhouseId => text().nullable().named('slaughterhouse_id')();
  DateTimeColumn get slaughterDate => dateTime().nullable().named('slaughter_date')();

  // ==================== NOTES ====================
  TextColumn get notes => text().nullable()();

  // ==================== SYNC FIELDS (future-proof) ====================
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get lastSyncedAt => dateTime().nullable().named('last_synced_at')();
  TextColumn get serverVersion => text().nullable().named('server_version')();
  
  // Soft-delete (audit trail)
  DateTimeColumn get deletedAt => dateTime().nullable().named('deleted_at')();

  @override
  Set<Column> get primaryKey => {id};
}
