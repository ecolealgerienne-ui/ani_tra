// lib/drift/tables/veterinarians_table.dart

import 'package:drift/drift.dart';

/// Table pour les vétérinaires
/// 
/// Stocke les informations sur les vétérinaires avec:
/// - Informations personnelles et professionnelles
/// - Coordonnées complètes
/// - Disponibilité et service d'urgence
/// - Tarifs et préférences
/// - Statistiques d'interventions
class VeterinariansTable extends Table {
  @override
  String get tableName => 'veterinarians';

  // === Primary Key ===
  TextColumn get id => text()();

  // === Multi-tenancy ===
  TextColumn get farmId => text().named('farm_id')();

  // === Informations personnelles ===
  TextColumn get firstName => text().named('first_name')();
  TextColumn get lastName => text().named('last_name')();
  TextColumn get title => text().nullable()(); // Dr., Pr., etc.

  // === Informations professionnelles ===
  TextColumn get licenseNumber => text().named('license_number')();
  
  /// Liste des spécialités (JSON array): ["Ovins", "Bovins"]
  TextColumn get specialties => text()();
  
  TextColumn get clinic => text().nullable()();

  // === Coordonnées ===
  TextColumn get phone => text()();
  TextColumn get mobile => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get postalCode => text().nullable().named('postal_code')();
  TextColumn get country => text().nullable()();

  // === Disponibilité ===
  BoolColumn get isAvailable => boolean().withDefault(const Constant(true)).named('is_available')();
  BoolColumn get emergencyService => boolean().withDefault(const Constant(false)).named('emergency_service')();
  TextColumn get workingHours => text().nullable().named('working_hours')();

  // === Tarifs ===
  RealColumn get consultationFee => real().nullable().named('consultation_fee')();
  RealColumn get emergencyFee => real().nullable().named('emergency_fee')();
  TextColumn get currency => text().nullable()();

  // === Notes et préférences ===
  TextColumn get notes => text().nullable()();
  BoolColumn get isPreferred => boolean().withDefault(const Constant(false)).named('is_preferred')();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false)).named('is_default')();
  IntColumn get rating => integer().withDefault(const Constant(5))();

  // === Statistiques ===
  IntColumn get totalInterventions => integer().withDefault(const Constant(0)).named('total_interventions')();
  DateTimeColumn get lastInterventionDate => dateTime().nullable().named('last_intervention_date')();

  // === État ===
  BoolColumn get isActive => boolean().withDefault(const Constant(true)).named('is_active')();

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
  ];
}
