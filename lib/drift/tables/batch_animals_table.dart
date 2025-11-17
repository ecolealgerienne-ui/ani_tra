// lib/drift/tables/batch_animals_table.dart

import 'package:drift/drift.dart';

/// Table de liaison pour les animaux dans un batch
///
/// Table many-to-many permettant de:
/// - Lier plusieurs animaux à un batch
/// - Maintenir l'ordre d'ajout des animaux
/// - Gérer la composition des batches de manière flexible
class BatchAnimalsTable extends Table {
  @override
  String get tableName => 'batch_animals';

  // === Foreign Keys ===

  /// ID du batch
  TextColumn get batchId => text().named('batch_id')();

  /// ID de l'animal
  TextColumn get animalId => text().named('animal_id')();

  // === Metadata ===

  /// Date d'ajout de l'animal au batch
  DateTimeColumn get addedAt => dateTime().named('added_at')();

  // === Primary Key ===
  @override
  Set<Column> get primaryKey => {batchId, animalId};

  // === Constraints ===
  @override
  List<String> get customConstraints => [
        'FOREIGN KEY (batch_id) REFERENCES batches(id) ON DELETE CASCADE',
        'FOREIGN KEY (animal_id) REFERENCES animals(id) ON DELETE CASCADE',
      ];
}
