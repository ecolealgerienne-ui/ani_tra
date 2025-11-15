// lib/providers/document_provider.dart

import 'package:flutter/foundation.dart';
import '../models/document.dart';
import '../repositories/document_repository.dart';
import 'auth_provider.dart';

/// DocumentProvider - Phase 1C
/// CHANGEMENT: Utilise Repository pour Documents (SQLite)
class DocumentProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  final DocumentRepository _repository;
  String _currentFarmId;

  // Données principales (cache local)
  final List<Document> _allDocuments = [];

  // Loading state
  bool _isLoading = false;

  DocumentProvider(this._authProvider, this._repository)
      : _currentFarmId = _authProvider.currentFarmId {
    _authProvider.addListener(_onFarmChanged);
    _loadDocumentsFromRepository();
  }

  void _onFarmChanged() {
    if (_currentFarmId != _authProvider.currentFarmId) {
      _currentFarmId = _authProvider.currentFarmId;
      _loadDocumentsFromRepository();
    }
  }

  // === Getters ===

  List<Document> get documents => List.unmodifiable(
      _allDocuments.where((d) => d.farmId == _authProvider.currentFarmId));

  bool get isLoading => _isLoading;

  int get count => documents.length;

  /// Documents par animal
  List<Document> getByAnimal(String animalId) {
    return documents.where((d) => d.animalId == animalId).toList()
      ..sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
  }

  /// Documents de la ferme (non liés à un animal)
  List<Document> get farmDocuments {
    return documents.where((d) => d.animalId == null).toList()
      ..sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
  }

  /// Documents par type
  List<Document> getByType(DocumentType type) {
    return documents.where((d) => d.type == type).toList()
      ..sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
  }

  /// Documents expirés
  List<Document> get expired {
    return documents.where((d) => d.isExpired).toList()
      ..sort((a, b) => a.expiryDate!.compareTo(b.expiryDate!));
  }

  /// Documents qui expirent bientôt (dans les 30 jours)
  List<Document> get expiringSoon {
    return documents.where((d) {
      if (d.expiryDate == null) return false;
      final days = d.daysUntilExpiry;
      return days != null && days <= 30 && days > 0;
    }).toList()
      ..sort((a, b) => a.expiryDate!.compareTo(b.expiryDate!));
  }

  /// Documents uploadés ce mois
  List<Document> get thisMonth {
    final now = DateTime.now();
    return documents.where((d) {
      return d.uploadDate.year == now.year && d.uploadDate.month == now.month;
    }).toList()
      ..sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
  }

  /// Trouver par ID
  Document? getById(String id) {
    try {
      return documents.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  // === Repository Loading ===

  Future<void> _loadDocumentsFromRepository() async {
    if (_currentFarmId.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final farmDocuments = await _repository.getAll(_currentFarmId);
      _allDocuments.removeWhere((d) => d.farmId == _currentFarmId);
      _allDocuments.addAll(farmDocuments);
    } catch (e) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadInitialData(List<Document> documents) async {
    await _migrateDocumentsToRepository(documents);
  }

  Future<void> _migrateDocumentsToRepository(List<Document> documents) async {
    for (final document in documents) {
      try {
        await _repository.create(document, document.farmId);
      } catch (e) {
      }
    }
    await _loadDocumentsFromRepository();
  }

  // === CRUD ===

  /// Ajouter un document
  Future<void> add(Document document) async {
    final documentWithFarm = document;

    try {
      await _repository.create(documentWithFarm, _authProvider.currentFarmId);
      _allDocuments.add(documentWithFarm);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Mettre à jour un document
  Future<void> update(Document document) async {
    try {
      final updated = document.markAsModified();
      await _repository.update(updated, _authProvider.currentFarmId);

      final index = _allDocuments.indexWhere((d) => d.id == document.id);
      if (index != -1) {
        _allDocuments[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Supprimer un document
  Future<void> delete(String id) async {
    try {
      await _repository.delete(id, _authProvider.currentFarmId);

      _allDocuments.removeWhere((d) => d.id == id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Upload un nouveau document
  Future<Document> uploadDocument({
    String? animalId,
    required DocumentType type,
    required String fileName,
    required String fileUrl,
    int? fileSizeBytes,
    String? mimeType,
    DateTime? expiryDate,
    String? notes,
    String? uploadedBy,
  }) async {
    final document = Document(
      farmId: _authProvider.currentFarmId,
      animalId: animalId,
      type: type,
      fileName: fileName,
      fileUrl: fileUrl,
      fileSizeBytes: fileSizeBytes,
      mimeType: mimeType,
      uploadDate: DateTime.now(),
      expiryDate: expiryDate,
      notes: notes,
      uploadedBy: uploadedBy,
    );

    await add(document);
    return document;
  }

  /// Supprimer tous les documents d'un animal
  Future<void> deleteAllForAnimal(String animalId) async {
    try {
      await _repository.deleteAllForAnimal(
          _authProvider.currentFarmId, animalId);
      _allDocuments.removeWhere((d) => d.animalId == animalId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // === Statistiques ===

  /// Nombre de documents par type
  Map<DocumentType, int> getCountsByType() {
    final counts = <DocumentType, int>{};
    for (final doc in documents) {
      counts[doc.type] = (counts[doc.type] ?? 0) + 1;
    }
    return counts;
  }

  /// Taille totale des documents (en bytes)
  int get totalStorageUsed {
    return documents.fold<int>(
      0,
      (sum, doc) => sum + (doc.fileSizeBytes ?? 0),
    );
  }

  /// Taille totale formatée
  String get formattedTotalStorage {
    final bytes = totalStorageUsed;
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)}KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  /// Nombre de documents uploadés ce mois
  int get thisMonthCount => thisMonth.length;

  /// Nombre de documents qui expirent bientôt
  int get expiringSoonCount => expiringSoon.length;

  /// Nombre de documents expirés
  int get expiredCount => expired.length;

  // === Recherche ===

  /// Rechercher par nom de fichier
  List<Document> searchByFileName(String query) {
    final lowerQuery = query.toLowerCase();
    return documents
        .where((d) => d.fileName.toLowerCase().contains(lowerQuery))
        .toList()
      ..sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
  }

  // === Utilities ===

  void clear() {
    _allDocuments.clear();
    notifyListeners();
  }

  Future<void> syncToServer() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<void> refresh() async {
    await _loadDocumentsFromRepository();
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onFarmChanged);
    super.dispose();
  }
}
