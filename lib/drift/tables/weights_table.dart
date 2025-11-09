// lib/drift/tables/weights_table.dart

import 'package:drift/drift.dart';

/// Table pour les pesées d'animaux
/// 
/// Stocke l'historique des pesées avec:
/// - Lien vers l'animal (FK → animals)
/// - Source de la pesée (balance, estimation, vétérinaire)
/// - Traçabilité complète des mesures
class WeightsTable extends Table {
  @override
  String get tableName => 'weights';

  // === Primary Key ===
  TextColumn get id => text()();

  // === Multi-tenancy ===
  TextColumn get farmId => text().named('farm_id')();

  // === Foreign Key ===
  TextColumn get animalId => text().named('animal_id')();

  // === Données métier ===
  /// Poids en kilogrammes
  RealColumn get weight => real()();
  
  /// Date et heure de la pesée
  DateTimeColumn get recordedAt => dateTime().named('recorded_at')();
  
  /// Source: "scale", "manual", "estimated", "veterinary" (WeightSource enum)
  TextColumn get source => text()();
  
  /// Notes optionnelles
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
    'FOREIGN KEY (animal_id) REFERENCES animals(id)',
  ];
}
