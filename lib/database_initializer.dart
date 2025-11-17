// lib/database_initializer.dart
import 'package:animal_trace/drift/database.dart';

class DatabaseInitializer {
  static const String _tag = '🗄️ DatabaseInitializer';

  /// Initialise la base de données sans données de test
  static Future<AppDatabase> initialize() async {
    try {
      print('$_tag Initializing database...');

      final db = AppDatabase();

      // Vérifier que la connexion fonctionne
      await db.customStatement('SELECT 1');

      print('$_tag ✅ Database initialized successfully');

      return db;
    } catch (e) {
      print('$_tag ❌ Error initializing database: $e');
      rethrow;
    }
  }
}
