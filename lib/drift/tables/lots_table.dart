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

  // Type nullable: 'treatment', 'sale', 'slaughter', 'purchase', ou NULL
  TextColumn get type => text().nullable()();

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

  // ==================== SALE/PURCHASE FIELDS ====================

  /// Prix total du lot (pour ventes et achats)
  RealColumn get priceTotal => real().nullable().named('price_total')();

  /// Nom de l'acheteur (pour ventes)
  TextColumn get buyerName => text().nullable().named('buyer_name')();

  /// Nom du vendeur (pour achats)
  TextColumn get sellerName => text().nullable().named('seller_name')();

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
        'FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE',
      ];
}
