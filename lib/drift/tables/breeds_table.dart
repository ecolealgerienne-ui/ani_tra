// lib/drift/tables/breeds_table.dart
import 'package:drift/drift.dart';

class BreedsTable extends Table {
  @override
  String get tableName => 'breeds';

  // Primary key
  TextColumn get id => text()();

  // Foreign key to species
  TextColumn get speciesId => text().named('species_id')();

  // Multi-language names
  TextColumn get nameFr => text().named('name_fr')();
  TextColumn get nameEn => text().named('name_en')();
  TextColumn get nameAr => text().named('name_ar')();

  // Description (optional)
  TextColumn get description => text().nullable()();

  // Display order
  IntColumn get displayOrder =>
      integer().withDefault(const Constant(0)).named('display_order')();

  // Active flag
  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true)).named('is_active')();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        'FOREIGN KEY (species_id) REFERENCES species(id) ON DELETE CASCADE',
      ];
}
