// lib/drift/tables/alert_configurations_table.dart

import 'package:drift/drift.dart';

/// Table des configurations d'alertes
/// Stocke les règles et paramètres pour la génération dynamique d'alertes
/// Une configuration peut générer plusieurs instances Alert selon les données
@DataClassName('AlertConfigurationData')
class AlertConfigurationsTable extends Table {
  /// Identifiant unique (UUID)
  TextColumn get id => text()();

  /// Ferme propriétaire (multi-tenancy)
  TextColumn get farmId => text().named('farm_id')();

  /// Type d'évaluation (remanence, weighing, vaccination, etc.)
  TextColumn get evaluationType => text().named('evaluation_type')();

  /// Type d'alerte (urgent, important, routine)
  TextColumn get type => text()();

  /// Catégorie d'alerte (remanence, identification, registre, etc.)
  TextColumn get category => text()();

  /// Clé de traduction pour le titre (ex: alertRemanenceTitle)
  TextColumn get titleKey => text().named('title_key')();

  /// Clé de traduction pour le message (ex: alertRemanenceMsg)
  TextColumn get messageKey => text().named('message_key')();

  /// Niveau de sévérité (1 = faible, 2 = moyen, 3 = critique)
  IntColumn get severity => integer()();

  /// Emoji ou nom d'icône pour affichage
  TextColumn get iconName => text().named('icon_name')();

  /// Couleur en hexadécimal (#D32F2F)
  TextColumn get colorHex => text().named('color_hex')();

  /// Activation/désactivation de cette configuration par l'éleveur
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();

  // ========== SYNC FIELDS (Phase 2) ==========
  /// Flag de synchronisation serveur
  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  /// Timestamp de la dernière synchronisation
  DateTimeColumn get lastSyncedAt =>
      dateTime().nullable().named('last_synced_at')();

  /// Version serveur pour résolution de conflits
  TextColumn get serverVersion =>
      text().nullable().named('server_version')();

  // ========== SOFT-DELETE & AUDIT ==========
  /// Timestamp de suppression (soft-delete)
  DateTimeColumn get deletedAt => dateTime().nullable().named('deleted_at')();

  /// Timestamp de création
  DateTimeColumn get createdAt => dateTime().named('created_at')();

  /// Timestamp de dernière modification
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {farmId, evaluationType}, // Une config par type d'évaluation par ferme
  ];

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (farm_id) REFERENCES farms(id)',
  ];
}
