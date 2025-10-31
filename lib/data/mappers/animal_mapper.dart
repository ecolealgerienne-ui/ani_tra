// lib/data/mappers/animal_mapper.dart
import 'package:drift/drift.dart' show Value;

// IMPORTANT : importer la DB pour accéder aux types générés (db.Animal, db.AnimalsCompanion)
import '../local/db.dart' as db;

import '../../models/animal.dart' as model; // Ton modèle domaine

// ---- helpers enum <-> string ----
String _enumName(Object e) {
  final s = e.toString(); // e.g. AnimalStatus.alive
  final dot = s.indexOf('.');
  return dot >= 0 ? s.substring(dot + 1) : s;
}

String _sexToDb(model.AnimalSex sex) => _enumName(sex).toUpperCase();
model.AnimalSex _sexFromDb(String s) {
  final lower = s.toLowerCase();
  for (final v in model.AnimalSex.values) {
    if (_enumName(v).toLowerCase() == lower) return v;
  }
  return model.AnimalSex.values.first; // fallback
}

String _statusToDb(model.AnimalStatus st) => _enumName(st).toUpperCase();
model.AnimalStatus _statusFromDb(String s) {
  final lower = s.toLowerCase();
  for (final v in model.AnimalStatus.values) {
    if (_enumName(v).toLowerCase() == lower) return v;
  }
  return model.AnimalStatus.values.first; // fallback
}

// ---- DB -> Domaine ----
// NOTE: on utilise db.Animal (type généré par Drift) car on importe ../local/db.dart
model.Animal fromDb(db.Animal row) {
  return model.Animal(
    id: row.id,
    eid: row.eid,
    officialNumber: row.officialNumber,
    birthDate: DateTime.parse(row.birthDate), // non-nullable dans ton modèle
    sex: _sexFromDb(row.sex),
    motherId: row.motherId,
    status: _statusFromDb(row.status),
    createdAt: DateTime.parse(row.createdAt), // non-nullable dans ton modèle
    updatedAt: DateTime.parse(row.updatedAt), // non-nullable dans ton modèle
    days: row.days, // optionnel (nullable)
  );
}

// ---- Domaine -> Companion (INSERT/UPDATE) ----
// NOTE: on retourne db.AnimalsCompanion (type généré par Drift)
db.AnimalsCompanion toCompanion(model.Animal a) {
  return db.AnimalsCompanion(
    id: Value(a.id),
    eid: Value(a.eid),
    officialNumber: Value(a.officialNumber),
    birthDate: Value(a.birthDate.toUtc().toIso8601String()),
    sex: Value(_sexToDb(a.sex)),
    motherId: Value(a.motherId),
    status: Value(_statusToDb(a.status)),
    createdAt: Value(a.createdAt.toUtc().toIso8601String()),
    updatedAt: Value(a.updatedAt.toUtc().toIso8601String()),
    days: Value(a.days),
    isDeleted: const Value(false),
  );
}
