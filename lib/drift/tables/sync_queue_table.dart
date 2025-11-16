// lib/drift/tables/sync_queue_table.dart
import 'package:drift/drift.dart';

/// Table de queue pour la synchronisation (Phase 1C STEP 4)
///
/// Cette table stocke tous les items en attente de synchronisation avec le serveur.
/// Elle permet:
/// - Offline mode: enregistrer les changements quand pas de connexion
/// - Retry logic: ré-essayer en cas d'échec (max 3 fois)
/// - Audit trail: historique des tentatives de sync
/// - Cleanup: suppression automatique des items anciens (>30j)
class SyncQueueTable extends Table {
  @override
  String get tableName => 'sync_queue';

  // Primary key
  TextColumn get id => text()();

  // Multi-tenancy: isolation par ferme
  TextColumn get farmId => text().named('farm_id')();

  // Type d'entité (animal, treatment, vaccination, etc.)
  TextColumn get entityType => text().named('entity_type')();

  // ID de l'entité concernée
  TextColumn get entityId => text().named('entity_id')();

  // Action à synchroniser: 'insert', 'update', 'delete'
  TextColumn get action => text()();

  // Payload JSON de l'entité (encrypted en production)
  /// Stocké en BLOB pour supporter UTF-8 et caractères spéciaux
  BlobColumn get payload => blob()();

  // Retry management
  IntColumn get retryCount =>
      integer().withDefault(const Constant(0)).named('retry_count')();
  DateTimeColumn get lastRetryAt =>
      dateTime().nullable().named('last_retry_at')();
  TextColumn get errorMessage => text().nullable().named('error_message')();

  // Sync status
  DateTimeColumn get syncedAt => dateTime().nullable().named('synced_at')();

  // Timestamps
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt =>
      dateTime().nullable().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        // Foreign key vers farms
        'FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE',

        // Unique constraint: éviter duplicatas pour même action sur même entité
        // Un seul item par {farmId, entityId, action} en attente
        'UNIQUE(farm_id, entity_id, action)',
      ];
}
