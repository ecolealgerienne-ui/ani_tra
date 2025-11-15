// lib/drift/tables/farm_preferences_table.dart
import 'package:drift/drift.dart';

/// Table des préférences par ferme
///
/// Stocke les paramètres par défaut pour chaque ferme :
/// - Vétérinaire par défaut
/// - Type d'animal par défaut (species)
/// - Race par défaut
///
/// Contrainte : Une seule ligne de préférences par ferme (unique: farmId)
class FarmPreferencesTable extends Table {
  @override
  String get tableName => 'farm_preferences';

  // ═══════════════════════════════════════════════════════════
  // PRIMARY KEY
  // ═══════════════════════════════════════════════════════════

  TextColumn get id => text()();

  // ═══════════════════════════════════════════════════════════
  // FOREIGN KEY
  // ═══════════════════════════════════════════════════════════

  /// Référence à la table farms
  TextColumn get farmId => text().named('farm_id')();

  // ═══════════════════════════════════════════════════════════
  // PREFERENCES DATA
  // ═══════════════════════════════════════════════════════════

  /// Vétérinaire par défaut pour cette ferme (FK → veterinarians, nullable)
  TextColumn get defaultVeterinarianId =>
      text().nullable().named('default_veterinarian_id')();

  /// Type d'animal par défaut (Ex: 'sheep', 'cattle', 'goat')
  TextColumn get defaultSpeciesId => text().named('default_species_id')();

  /// Race par défaut (Ex: 'merinos', 'charolaise', nullable)
  TextColumn get defaultBreedId =>
      text().nullable().named('default_breed_id')();

  // ═══════════════════════════════════════════════════════════
  // SYNC FIELDS (Phase 2)
  // ═══════════════════════════════════════════════════════════

  /// Cette ligne a-t-elle été synchronisée avec le backend ?
  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  /// Quand cette ligne a-t-elle été synchronisée pour la dernière fois ?
  DateTimeColumn get lastSyncedAt =>
      dateTime().nullable().named('last_synced_at')();

  /// Version du serveur (pour résolution de conflits)
  TextColumn get serverVersion =>
      text().nullable().named('server_version')();

  // ═══════════════════════════════════════════════════════════
  // SOFT-DELETE & AUDIT
  // ═══════════════════════════════════════════════════════════

  /// Soft-delete timestamp (null = active)
  DateTimeColumn get deletedAt => dateTime().nullable().named('deleted_at')();

  /// Date de création
  DateTimeColumn get createdAt => dateTime().named('created_at')();

  /// Date de dernière modification
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  // ═══════════════════════════════════════════════════════════
  // KEYS & CONSTRAINTS
  // ═══════════════════════════════════════════════════════════

  @override
  Set<Column> get primaryKey => {id};

  /// Une seule ligne de préférences par ferme
  @override
  List<Set<Column>> get uniqueKeys => [
        {farmId}, // Only one prefs row per farm
      ];

  /// Foreign key constraint
  @override
  List<String> get customConstraints => [
        'FOREIGN KEY (farm_id) REFERENCES farms(id)',
      ];
}
