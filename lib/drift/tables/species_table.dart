// lib/drift/tables/species_table.dart
import 'package:drift/drift.dart';

class SpeciesTable extends Table {
  @override
  String get tableName => 'species';

  // Primary key
  TextColumn get id => text()();

  // Multi-language names
  TextColumn get nameFr => text().named('name_fr')();
  TextColumn get nameEn => text().named('name_en')();
  TextColumn get nameAr => text().named('name_ar')();

  // Icon/emoji
  TextColumn get icon => text()();

  // Display order
  IntColumn get displayOrder =>
      integer().withDefault(const Constant(0)).named('display_order')();

  @override
  Set<Column> get primaryKey => {id};
}
