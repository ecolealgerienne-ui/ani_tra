// lib/drift/tables/vaccinations_table.dart

import 'package:drift/drift.dart';

/// Table pour les vaccinations
/// 
/// Stocke les vaccinations appliquées aux animaux avec:
/// - Lien vers animal(aux) (FK → animals OU liste JSON)
/// - Informations protocole et vaccin
/// - Dates et rappels
/// - Support vaccination individuelle ET de groupe
class VaccinationsTable extends Table {
  @override
  String get tableName => 'vaccinations';

  // === Primary Key ===
  TextColumn get id => text()();

  // === Multi-tenancy ===
  TextColumn get farmId => text().named('farm_id')();

  // === Animal(aux) concerné(s) ===
  /// ID animal simple (vaccination individuelle) - nullable
  TextColumn get animalId => text().nullable().named('animal_id')();
  
  /// Liste IDs animaux (JSON array) pour vaccination de groupe
  /// Ex: ["animal-1", "animal-2", "animal-3"]
  TextColumn get animalIds => text().named('animal_ids')();

  // === Protocole ===
  TextColumn get protocolId => text().nullable().named('protocol_id')();
  TextColumn get vaccineName => text().named('vaccine_name')();
  
  /// Type: "obligatoire", "recommandee", "optionnelle" (VaccinationType enum)
  TextColumn get type => text()();
  
  TextColumn get disease => text()();

  // === Administration ===
  DateTimeColumn get vaccinationDate => dateTime().named('vaccination_date')();
  TextColumn get batchNumber => text().nullable().named('batch_number')();
  DateTimeColumn get expiryDate => dateTime().nullable().named('expiry_date')();
  TextColumn get dose => text()();
  TextColumn get administrationRoute => text().named('administration_route')();

  // === Acteurs ===
  TextColumn get veterinarianId => text().nullable().named('veterinarian_id')();
  TextColumn get veterinarianName => text().nullable().named('veterinarian_name')();

  // === Rappel ===
  DateTimeColumn get nextDueDate => dateTime().nullable().named('next_due_date')();

  // === Délai d'attente ===
  IntColumn get withdrawalPeriodDays => integer().named('withdrawal_period_days')();

  // === Notes ===
  TextColumn get notes => text().nullable()();

  // === Sync fields (Phase 2 ready) ===
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable().named('last_synced_at')();
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
    // Note: animalId nullable, pas de FK strict car peut être vaccination de groupe
  ];
}
