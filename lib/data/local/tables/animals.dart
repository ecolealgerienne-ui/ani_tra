// lib/data/local/tables/animals.dart
import 'package:drift/drift.dart';

/// Table locale alignée sur lib/models/animal.dart
class Animals extends Table {
  // PK
  TextColumn get id => text()();

  // Identifiant (ear tag / EID)
  TextColumn get eid => text().withLength(min: 1, max: 128)();

  // Numéro officiel (optionnel)
  TextColumn get officialNumber => text().nullable()();

  // Date de naissance (ISO8601, non-null)
  TextColumn get birthDate => text()();

  // Sexe (enum sérialisé en texte: MALE/FEMALE)
  TextColumn get sex => text().withLength(min: 1, max: 16)();

  // Mère (optionnel)
  TextColumn get motherId => text().nullable()();

  // Statut (enum texte: ALIVE/SOLD/DEAD/SLAUGHTERED)
  TextColumn get status => text().withLength(min: 1, max: 32)();

  // Timestamps ISO (UTC, non-null)
  TextColumn get createdAt => text()();
  TextColumn get updatedAt => text()();

  // Attribut optionnel 'days' (présent dans ton JSON)
  IntColumn get days => integer().nullable()();

  // Soft delete
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
