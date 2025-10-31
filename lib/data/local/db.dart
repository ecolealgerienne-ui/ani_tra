// lib/data/local/db.dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/animals.dart';
import 'daos/animal_dao.dart';

part 'db.g.dart';

/// Base SQLite locale de l'app (Drift)
@DriftDatabase(
  tables: [Animals],
  daos: [AnimalDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._(QueryExecutor e) : super(e);

  /// Version de schéma : incrémente-la quand tu modifies les tables.
  @override
  int get schemaVersion => 1;

  /// Singleton (lazy)
  static AppDatabase? _instance;

  /// Récupère l’instance de DB (créée au premier appel)
  static Future<AppDatabase> instance() async {
    if (_instance != null) return _instance!;

    // Dossier de stockage applicatif (Android/iOS/Desktop)
    final dir = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dir.path, 'animal_trace.db'));

    // Crée un NativeDatabase en tâche de fond (meilleur pour I/O)
    final executor = NativeDatabase.createInBackground(dbFile);

    _instance = AppDatabase._(executor);
    return _instance!;
  }

  /// (Optionnel) Migration custom quand schemaVersion évolue
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          // Exemple futur :
          // if (from == 1) { await m.addColumn(animals, animals.newField); }
        },
        beforeOpen: (details) async {
          // PRAGMA, seed, etc. si besoin
        },
      );
}
