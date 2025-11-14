// lib/drift/tables/treatments_table.dart

import 'package:drift/drift.dart';

/// Table pour les traitements médicaux
///
/// Stocke les traitements appliqués aux animaux avec:
/// - Lien vers l'animal (FK → animals)
/// - Lien vers le produit (FK → medical_products)
/// - Dates et délais d'attente
/// - Informations vétérinaire et campagne
class TreatmentsTable extends Table {
  @override
  String get tableName => 'treatments';

  // === Primary Key ===
  TextColumn get id => text()();

  // === Multi-tenancy ===
  TextColumn get farmId => text().named('farm_id')();

  // === Foreign Keys ===
  TextColumn get animalId => text().named('animal_id')();
  TextColumn get productId => text().named('product_id')();

  // === Données métier ===
  TextColumn get productName => text().named('product_name')();
  RealColumn get dose => real()();
  DateTimeColumn get treatmentDate => dateTime().named('treatment_date')();
  DateTimeColumn get withdrawalEndDate =>
      dateTime().named('withdrawal_end_date')();
  TextColumn get notes => text().nullable()();

  // === Acteurs ===
  TextColumn get veterinarianId => text().nullable().named('veterinarian_id')();
  TextColumn get veterinarianName =>
      text().nullable().named('veterinarian_name')();
  TextColumn get campaignId => text().nullable().named('campaign_id')();

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
        'FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE',
        'FOREIGN KEY (animal_id) REFERENCES animals(id)',
        'FOREIGN KEY (veterinarian_id) REFERENCES veterinarians(id)',
      ];
}
