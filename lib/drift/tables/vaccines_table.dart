// lib/drift/tables/vaccines_table.dart

import 'package:drift/drift.dart';

/// Table pour les références de vaccins
///
/// Stocke les informations sur les vaccins disponibles avec:
/// - Espèces cibles (ovine, bovine, caprine)
/// - Maladies ciblées
/// - Protocole de vaccination
/// - Délais d'attente viande/lait
class VaccinesTable extends Table {
  @override
  String get tableName => 'vaccines';

  // === Primary Key ===
  TextColumn get id => text()();

  // === Multi-tenancy ===
  TextColumn get farmId => text().named('farm_id')();

  // === Informations de base ===
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get manufacturer => text().nullable()();

  // === Espèces et maladies cibles (JSON array) ===
  /// Liste des espèces cibles: ["ovine", "bovine", "caprine"]
  TextColumn get targetSpecies => text().named('target_species')();

  /// Liste des maladies ciblées: ["Clostridium", "Pasteurella"]
  TextColumn get targetDiseases => text().named('target_diseases')();

  // === Protocole de vaccination ===
  TextColumn get standardDose => text().nullable().named('standard_dose')();
  IntColumn get injectionsRequired =>
      integer().nullable().named('injections_required')();
  IntColumn get injectionIntervalDays =>
      integer().nullable().named('injection_interval_days')();

  // === Délais d'attente ===
  IntColumn get meatWithdrawalDays => integer().named('meat_withdrawal_days')();
  IntColumn get milkWithdrawalDays => integer().named('milk_withdrawal_days')();

  // === Administration ===
  TextColumn get administrationRoute =>
      text().nullable().named('administration_route')();

  // === Notes ===
  TextColumn get notes => text().nullable()();

  // === État ===
  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true)).named('is_active')();

  // === Sync fields (Phase 2 ready) ===
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSyncedAt =>
      dateTime().nullable().named('last_synced_at')();
  IntColumn get serverVersion => integer().nullable().named('server_version')();

  // === Soft-delete ===
  DateTimeColumn get deletedAt => dateTime().nullable().named('deleted_at')();

  // === Timestamps ===
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        'FOREIGN KEY (farm_id) REFERENCES farms(id)',
      ];
}
