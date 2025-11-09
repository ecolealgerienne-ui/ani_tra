// lib/drift/tables/medical_products_table.dart
import 'package:drift/drift.dart';

class MedicalProductsTable extends Table {
  @override
  String get tableName => 'medical_products';

  // Primary key
  TextColumn get id => text()();

  // Multi-tenancy
  TextColumn get farmId => text().named('farm_id')();

  // Basic info
  TextColumn get name => text()();
  TextColumn get commercialName => text().nullable().named('commercial_name')();
  TextColumn get category => text()();
  TextColumn get activeIngredient => text().nullable().named('active_ingredient')();
  TextColumn get manufacturer => text().nullable()();
  TextColumn get form => text().nullable()();
  RealColumn get dosage => real().nullable()();
  TextColumn get dosageUnit => text().nullable().named('dosage_unit')();

  // Withdrawal periods
  IntColumn get withdrawalPeriodMeat => integer().named('withdrawal_period_meat')();
  IntColumn get withdrawalPeriodMilk => integer().named('withdrawal_period_milk')();

  // Stock management
  RealColumn get currentStock => real().named('current_stock')();
  RealColumn get minStock => real().named('min_stock')();
  TextColumn get stockUnit => text().named('stock_unit')();

  // Price
  RealColumn get unitPrice => real().nullable().named('unit_price')();
  TextColumn get currency => text().nullable()();

  // Additional info
  TextColumn get batchNumber => text().nullable().named('batch_number')();
  DateTimeColumn get expiryDate => dateTime().nullable().named('expiry_date')();
  TextColumn get storageConditions => text().nullable().named('storage_conditions')();
  TextColumn get prescription => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true)).named('is_active')();

  // Product type & target species
  // ProductType enum stored as TEXT ('treatment' or 'vaccine')
  TextColumn get type => text().withDefault(const Constant('treatment'))();
  
  // List<AnimalSpecies> stored as comma-separated TEXT ('ovin,bovin,caprin')
  TextColumn get targetSpecies => text().withDefault(const Constant('')).named('target_species')();

  // Treatment-specific fields
  IntColumn get standardCureDays => integer().nullable().named('standard_cure_days')();
  TextColumn get administrationFrequency => text().nullable().named('administration_frequency')();
  TextColumn get dosageFormula => text().nullable().named('dosage_formula')();

  // Vaccine-specific fields
  TextColumn get vaccinationProtocol => text().nullable().named('vaccination_protocol')();
  
  // List<int> stored as comma-separated TEXT ('21,365')
  TextColumn get reminderDays => text().nullable().named('reminder_days')();
  
  TextColumn get defaultAdministrationRoute => text().nullable().named('default_administration_route')();
  TextColumn get defaultInjectionSite => text().nullable().named('default_injection_site')();

  // Sync fields (Phase 2 ready)
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable().named('last_synced_at')();
  IntColumn get serverVersion => integer().nullable().named('server_version')();

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
  ];
}
