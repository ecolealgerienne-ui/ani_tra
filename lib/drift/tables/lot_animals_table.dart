// lib/drift/tables/lot_animals_table.dart

import 'package:drift/drift.dart';

/// Table de liaison pour les animaux dans un lot
///
/// Table many-to-many permettant de:
/// - Lier plusieurs animaux à un lot
/// - Maintenir l'ordre d'ajout des animaux
/// - Gérer la composition des lots de manière flexible
class LotAnimalsTable extends Table {
  @override
  String get tableName => 'lot_animals';

  // === Foreign Keys ===

  /// ID du lot
  TextColumn get lotId => text().named('lot_id')();

  /// ID de l'animal
  TextColumn get animalId => text().named('animal_id')();

  // === Metadata ===

  /// Date d'ajout de l'animal au lot
  DateTimeColumn get addedAt => dateTime().named('added_at')();

  // === Primary Key ===
  @override
  Set<Column> get primaryKey => {lotId, animalId};

  // === Constraints ===
  @override
  List<String> get customConstraints => [
        'FOREIGN KEY (lot_id) REFERENCES lots(id) ON DELETE CASCADE',
        'FOREIGN KEY (animal_id) REFERENCES animals(id) ON DELETE CASCADE',
      ];
}
