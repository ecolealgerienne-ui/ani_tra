// lib/drift/tables/farms_table.dart

import 'package:drift/drift.dart';

class FarmsTable extends Table {
  @override
  String get tableName => 'farms';

  // Primary key
  TextColumn get id => text()();

  // Farm data
  TextColumn get name => text()();
  TextColumn get location => text()();
  TextColumn get ownerId => text().named('owner_id')();
  TextColumn get cheptelNumber => text().nullable().named('cheptel_number')();

  // Groupe (optionnel)
  TextColumn get groupId => text().nullable().named('group_id')();
  TextColumn get groupName => text().nullable().named('group_name')();

  // Ferme par défaut (pour sélection automatique)
  BoolColumn get isDefault =>
      boolean().withDefault(const Constant(false)).named('is_default')();

  // Timestamps
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}
