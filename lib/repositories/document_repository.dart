// lib/repositories/document_repository.dart

import 'package:drift/drift.dart';
import '../drift/database.dart';
import '../models/document.dart';

/// Repository pour la gestion des documents
class DocumentRepository {
  final AppDatabase _db;

  DocumentRepository(this._db);

  // === CRUD OPERATIONS ===

  /// Récupère tous les documents d'une ferme
  Future<List<Document>> getAll(String farmId) async {
    final items = await _db.documentDao.findByFarmId(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère un document par ID avec security check
  Future<Document?> getById(String id, String farmId) async {
    final item = await _db.documentDao.findById(id, farmId);
    if (item == null) return null;

    // Security check
    if (item.farmId != farmId) {
      throw Exception('Farm ID mismatch - Security violation');
    }

    return _mapToModel(item);
  }

  /// Crée un nouveau document
  Future<void> create(Document document, String farmId) async {
    final companion = _mapToCompanion(document, farmId);
    await _db.documentDao.insertItem(companion);
  }

  /// Met à jour un document existant
  Future<void> update(Document document, String farmId) async {
    // Security check
    final existing = await _db.documentDao.findById(document.id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Document not found or farm mismatch');
    }

    final companion = _mapToCompanion(document, farmId);
    await _db.documentDao.updateItem(companion);
  }

  /// Supprime un document (soft-delete)
  Future<void> delete(String id, String farmId) async {
    await _db.documentDao.softDelete(id, farmId);
  }

  // === BUSINESS QUERIES ===

  /// Récupère les documents d'un animal
  Future<List<Document>> getByAnimal(String farmId, String animalId) async {
    final items = await _db.documentDao.findByAnimal(animalId, farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les documents par type
  Future<List<Document>> getByType(String farmId, DocumentType type) async {
    final items = await _db.documentDao.findByType(farmId, type.name);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les documents de la ferme (sans animal)
  Future<List<Document>> getFarmDocuments(String farmId) async {
    final items = await _db.documentDao.findFarmDocuments(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les documents expirés
  Future<List<Document>> getExpired(String farmId) async {
    final items = await _db.documentDao.findExpired(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les documents qui expirent bientôt (dans X jours)
  Future<List<Document>> getExpiringSoon(String farmId, int days) async {
    final items = await _db.documentDao.findExpiringSoon(farmId, days);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Récupère les documents uploadés dans une période
  Future<List<Document>> getByUploadDateRange(
    String farmId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final items =
        await _db.documentDao.findByUploadDateRange(farmId, startDate, endDate);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Recherche par nom de fichier
  Future<List<Document>> searchByFileName(String farmId, String query) async {
    final items = await _db.documentDao.searchByFileName(farmId, query);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Supprime tous les documents d'un animal
  Future<void> deleteAllForAnimal(String farmId, String animalId) async {
    final docs = await getByAnimal(farmId, animalId);
    for (final doc in docs) {
      await delete(doc.id, farmId);
    }
  }

  // === STATISTICS ===

  /// Compte les documents par type
  Future<Map<DocumentType, int>> getCountsByType(String farmId) async {
    final items = await getAll(farmId);
    final counts = <DocumentType, int>{};
    for (final doc in items) {
      counts[doc.type] = (counts[doc.type] ?? 0) + 1;
    }
    return counts;
  }

  /// Calcule la taille totale de stockage utilisée
  Future<int> getTotalStorageUsed(String farmId) async {
    final items = await getAll(farmId);
    return items.fold<int>(
      0,
      (sum, doc) => sum + (doc.fileSizeBytes ?? 0),
    );
  }

  // === SYNC OPERATIONS ===

  /// Récupère les documents non synchronisés
  Future<List<Document>> getUnsynced(String farmId) async {
    final items = await _db.documentDao.getUnsynced(farmId);
    return items.map((data) => _mapToModel(data)).toList();
  }

  /// Marque un document comme synchronisé
  Future<void> markAsSynced(
    String id,
    String farmId,
    String serverVersion,
  ) async {
    await _db.documentDao.markSynced(id, farmId, serverVersion);
  }

  // === MAPPERS ===

  /// Convertit DocumentsTableData → Document (Model)
  Document _mapToModel(DocumentsTableData data) {
    return Document(
      id: data.id,
      farmId: data.farmId,
      animalId: data.animalId,
      type: _parseDocumentType(data.type),
      fileName: data.fileName,
      fileUrl: data.fileUrl,
      fileSizeBytes: data.fileSizeBytes,
      mimeType: data.mimeType,
      uploadDate: data.uploadDate,
      expiryDate: data.expiryDate,
      notes: data.notes,
      uploadedBy: data.uploadedBy,
      synced: data.synced,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      lastSyncedAt: data.lastSyncedAt,
      serverVersion: data.serverVersion,
    );
  }

  /// Convertit Document (Model) → DocumentsTableCompanion (Drift)
  DocumentsTableCompanion _mapToCompanion(
    Document document,
    String farmId,
  ) {
    return DocumentsTableCompanion(
      id: Value(document.id),
      farmId: Value(farmId),
      animalId: document.animalId != null
          ? Value(document.animalId!)
          : const Value.absent(),
      type: Value(document.type.name),
      fileName: Value(document.fileName),
      fileUrl: Value(document.fileUrl),
      fileSizeBytes: document.fileSizeBytes != null
          ? Value(document.fileSizeBytes!)
          : const Value.absent(),
      mimeType: document.mimeType != null
          ? Value(document.mimeType!)
          : const Value.absent(),
      uploadDate: Value(document.uploadDate),
      expiryDate: document.expiryDate != null
          ? Value(document.expiryDate!)
          : const Value.absent(),
      notes: document.notes != null
          ? Value(document.notes!)
          : const Value.absent(),
      uploadedBy: document.uploadedBy != null
          ? Value(document.uploadedBy!)
          : const Value.absent(),
      synced: Value(document.synced),
      lastSyncedAt: document.lastSyncedAt != null
          ? Value(document.lastSyncedAt!)
          : const Value.absent(),
      serverVersion: document.serverVersion != null
          ? Value(document.serverVersion!)
          : const Value.absent(),
      deletedAt: const Value.absent(),
      createdAt: Value(document.createdAt),
      updatedAt: Value(document.updatedAt),
    );
  }

  // === ENUM HELPERS ===

  /// Parse une string en DocumentType enum
  DocumentType _parseDocumentType(String type) {
    return DocumentType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => DocumentType.other,
    );
  }
}
