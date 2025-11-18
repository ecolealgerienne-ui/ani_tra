// lib/drift/tables/sync_queue_table.dart

import 'package:drift/drift.dart';

/// Table de queue pour la synchronisation (STEP 4)
///
/// Stocke tous les items en attente de synchronisation avec le serveur.
/// Permet : offline mode, retry logic, audit trail, cleanup automatique.
class SyncQueueTable extends Table {
  @override
  String get tableName => 'sync_queue';

  // ==================== IDENTIFIANTS ====================

  /// ID unique de l'item dans la queue
  TextColumn get id => text()();

  /// ID de la ferme (multi-tenancy)
  TextColumn get farmId => text().named('farm_id')();

  // ==================== ENTITÉ ====================

  /// Type d'entité : 'animal', 'treatment', 'vaccination', etc.
  TextColumn get entityType => text().named('entity_type')();

  /// ID de l'entité concernée
  TextColumn get entityId => text().named('entity_id')();

  /// Action : 'insert', 'update', 'delete'
  TextColumn get action => text()();

  /// Payload JSON sérialisé (données complètes de l'entité)
  BlobColumn get payload => blob()();

  // ==================== RETRY ====================

  /// Nombre de tentatives de sync (max 3)
  IntColumn get retryCount => integer().named('retry_count').withDefault(const Constant(0))();

  /// Message d'erreur de la dernière tentative
  TextColumn get errorMessage => text().named('error_message').nullable()();

  /// Date de la dernière tentative
  DateTimeColumn get lastRetryAt => dateTime().named('last_retry_at').nullable()();

  // ==================== TIMESTAMPS ====================

  /// Date de création (ajout à la queue)
  DateTimeColumn get createdAt => dateTime().named('created_at')();

  /// Date de dernière modification
  DateTimeColumn get updatedAt => dateTime().named('updated_at').nullable()();

  /// Date de synchronisation réussie (NULL = pending)
  DateTimeColumn get syncedAt => dateTime().named('synced_at').nullable()();

  // ==================== CONFIGURATION ====================

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {farmId, entityId, action}, // Éviter doublons
  ];
}
