// lib/drift/tables/movements_table.dart

import 'package:drift/drift.dart';

/// Table pour les mouvements d'animaux
/// 
/// Stocke les mouvements avec:
/// - Lien vers l'animal (FK → animals)
/// - Type de mouvement (birth, purchase, sale, death, slaughter)
/// - Informations de traçabilité (ferme origine/destination)
/// - Prix et signature QR (pour ventes)
class MovementsTable extends Table {
  @override
  String get tableName => 'movements';

  // === Primary Key ===
  TextColumn get id => text()();

  // === Multi-tenancy ===
  TextColumn get farmId => text().named('farm_id')();

  // === Foreign Key ===
  TextColumn get animalId => text().named('animal_id')();

  // === Données métier ===
  /// Type: "birth", "purchase", "sale", "death", "slaughter" (MovementType enum)
  TextColumn get type => text()();
  
  /// Date du mouvement
  DateTimeColumn get movementDate => dateTime().named('movement_date')();
  
  /// ID de la ferme d'origine (pour purchase)
  TextColumn get fromFarmId => text().nullable().named('from_farm_id')();
  
  /// ID de la ferme de destination (pour sale)
  TextColumn get toFarmId => text().nullable().named('to_farm_id')();
  
  /// Prix (pour purchase/sale)
  RealColumn get price => real().nullable()();
  
  /// Notes optionnelles
  TextColumn get notes => text().nullable()();
  
  /// Signature QR de l'acheteur (pour sale)
  TextColumn get buyerQrSignature => text().nullable().named('buyer_qr_signature')();

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
