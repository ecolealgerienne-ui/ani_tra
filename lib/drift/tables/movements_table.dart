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
  TextColumn get buyerQrSignature =>
      text().nullable().named('buyer_qr_signature')();

  // === Sale/Slaughter Structured Data ===

  /// Nom de l'acheteur (particulier ou ferme)
  /// Utilisé pour type='sale'
  TextColumn get buyerName => text().nullable().named('buyer_name')();

  /// ID de la ferme acheteuse (si applicable)
  /// Utilisé pour type='sale' avec buyerType='farm'
  TextColumn get buyerFarmId => text().nullable().named('buyer_farm_id')();

  /// Type d'acheteur
  /// Valeurs: 'individual', 'farm', 'trader', 'cooperative'
  /// Utilisé pour type='sale'
  TextColumn get buyerType => text().nullable().named('buyer_type')();

  /// Nom de l'abattoir
  /// Utilisé pour type='slaughter'
  TextColumn get slaughterhouseName =>
      text().nullable().named('slaughterhouse_name')();

  /// Identifiant de l'abattoir (numéro agrément, etc.)
  /// Utilisé pour type='slaughter'
  TextColumn get slaughterhouseId =>
      text().nullable().named('slaughterhouse_id')();

  // === Temporary Movements (loan, transhumance, boarding, etc.) ===

  /// Indique si le mouvement est temporaire (animal doit revenir)
  /// true pour type='temporary_out', false après 'temporary_return'
  BoolColumn get isTemporary =>
      boolean().withDefault(const Constant(false))();

  /// Sous-type de mouvement temporaire
  /// Valeurs: 'loan', 'transhumance', 'boarding', 'quarantine', 'exhibition', etc.
  /// Obligatoire si type='temporary_out' ou 'temporary_return'
  TextColumn get temporaryMovementType =>
      text().nullable().named('temporary_movement_type')();

  /// Date de retour prévue (obligatoire pour temporary_out)
  DateTimeColumn get expectedReturnDate =>
      dateTime().nullable().named('expected_return_date')();

  /// ID du mouvement associé (lien bidirectionnel)
  /// Pour temporary_out: rempli quand le retour est créé
  /// Pour temporary_return: pointe vers le temporary_out original
  TextColumn get relatedMovementId =>
      text().nullable().named('related_movement_id')();

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
      ];
}
