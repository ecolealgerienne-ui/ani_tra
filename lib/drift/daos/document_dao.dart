// lib/drift/daos/document_dao.dart
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/documents_table.dart';

part 'document_dao.g.dart';

@DriftAccessor(tables: [DocumentsTable])
class DocumentDao extends DatabaseAccessor<AppDatabase>
    with _$DocumentDaoMixin {
  DocumentDao(super.db);

  // ==================== MÉTHODES OBLIGATOIRES ====================

  /// 1. findByFarmId - TOUJOURS filtrer par farmId
  Future<List<DocumentsTableData>> findByFarmId(String farmId) {
    return (select(documentsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// 2. findById - Sécurité farmId
  Future<DocumentsTableData?> findById(String id, String farmId) {
    return (select(documentsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// 3. insert - Créer avec farmId
  Future<int> insertItem(DocumentsTableCompanion document) {
    return into(documentsTable).insert(document);
  }

  /// 4. update - B1 FIX: Pass farmId + .write() + security check
  Future<int> updateItem(DocumentsTableCompanion document, String farmId) {
    return (update(documentsTable)
          ..where((t) => t.id.equals(document.id.value))
          ..where((t) => t.farmId.equals(farmId)))
        .write(document);
  }

  /// 5. softDelete - Soft-delete (pas hard delete)
  Future<int> softDelete(String id, String farmId) {
    return (update(documentsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(DocumentsTableCompanion(
      deletedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// 6. getUnsynced - Phase 2 ready
  Future<List<DocumentsTableData>> getUnsynced(String farmId) {
    return (select(documentsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.synced.equals(false))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// 7. markSynced - Phase 2 ready
  Future<int> markSynced(String id, String farmId, String serverVersion) {
    return (update(documentsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(DocumentsTableCompanion(
      synced: const Value(true),
      lastSyncedAt: Value(DateTime.now()),
      serverVersion: Value(serverVersion),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // ==================== MÉTHODES MÉTIER SUPPLÉMENTAIRES ====================

  /// Filtrer par animal
  Future<List<DocumentsTableData>> findByAnimal(
      String animalId, String farmId) {
    return (select(documentsTable)
          ..where((t) => t.animalId.equals(animalId))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Obtenir documents de ferme (sans animal)
  Future<List<DocumentsTableData>> findFarmDocuments(String farmId) {
    return (select(documentsTable)
          ..where((t) => t.animalId.isNull())
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Filtrer par type de document
  Future<List<DocumentsTableData>> findByType(String farmId, String type) {
    return (select(documentsTable)
          ..where((t) => t.type.equals(type))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Obtenir documents expirés
  Future<List<DocumentsTableData>> findExpired(String farmId) {
    final now = DateTime.now();
    return (select(documentsTable)
          ..where((t) => t.expiryDate.isNotNull())
          ..where((t) => t.expiryDate.isSmallerThanValue(now))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Obtenir documents expirant bientôt (dans les X prochains jours)
  Future<List<DocumentsTableData>> findExpiringSoon(String farmId, int days) {
    final now = DateTime.now();
    final targetDate = now.add(Duration(days: days));
    return (select(documentsTable)
          ..where((t) => t.expiryDate.isNotNull())
          ..where((t) => t.expiryDate.isBiggerOrEqualValue(now))
          ..where((t) => t.expiryDate.isSmallerOrEqualValue(targetDate))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Obtenir documents par utilisateur (uploadedBy)
  Future<List<DocumentsTableData>> findByUploader(
      String farmId, String uploaderId) {
    return (select(documentsTable)
          ..where((t) => t.uploadedBy.equals(uploaderId))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Obtenir documents uploadés dans une période
  Future<List<DocumentsTableData>> findByUploadDateRange(
      String farmId, DateTime startDate, DateTime endDate) {
    return (select(documentsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.uploadDate.isBiggerOrEqualValue(startDate))
          ..where((t) => t.uploadDate.isSmallerOrEqualValue(endDate))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Rechercher documents par nom de fichier (LIKE)
  Future<List<DocumentsTableData>> searchByFileName(
      String farmId, String query) {
    return (select(documentsTable)
          ..where((t) => t.fileName.like('%$query%'))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Compter documents par farmId
  Future<int> countByFarmId(String farmId) async {
    final count = countAll();
    final query = selectOnly(documentsTable)
      ..addColumns([count])
      ..where(documentsTable.farmId.equals(farmId))
      ..where(documentsTable.deletedAt.isNull());

    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Compter documents par animal
  Future<int> countByAnimal(String animalId, String farmId) async {
    final count = countAll();
    final query = selectOnly(documentsTable)
      ..addColumns([count])
      ..where(documentsTable.animalId.equals(animalId))
      ..where(documentsTable.farmId.equals(farmId))
      ..where(documentsTable.deletedAt.isNull());

    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Compter documents expirés
  Future<int> countExpired(String farmId) async {
    final now = DateTime.now();
    final count = countAll();
    final query = selectOnly(documentsTable)
      ..addColumns([count])
      ..where(documentsTable.expiryDate.isNotNull())
      ..where(documentsTable.expiryDate.isSmallerThanValue(now))
      ..where(documentsTable.farmId.equals(farmId))
      ..where(documentsTable.deletedAt.isNull());

    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }
}
