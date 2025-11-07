// lib/providers/document_provider.dart

import 'package:flutter/foundation.dart';
import '../models/document.dart';
import 'auth_provider.dart';

/// Provider pour la gestion des documents
/// Mode MOCK : Données en mémoire uniquement
class DocumentProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  String _currentFarmId;

  DocumentProvider(this._authProvider)
      : _currentFarmId = _authProvider.currentFarmId {
    _authProvider.addListener(_onFarmChanged);
  }

  void _onFarmChanged() {
    if (_currentFarmId != _authProvider.currentFarmId) {
      _currentFarmId = _authProvider.currentFarmId;
      notifyListeners();
    }
  }

  // === Données en mémoire (MOCK) ===
  List<Document> _allDocuments = [];

  // === Getters ===

  /// Tous les documents
  List<Document> get documents => List.unmodifiable(
    _allDocuments.where((item) => item.farmId == _authProvider.currentFarmId)
  );

  /// Nombre total de documents
  int get count => _allDocuments.length;

  /// Documents par animal
  List<Document> getByAnimal(String animalId) {
    return _allDocuments.where((d) => d.animalId == animalId).toList()
      ..sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
  }

  /// Documents de la ferme (non liés à un animal)
  List<Document> get farmDocuments {
    return _allDocuments.where((d) => d.animalId == null).toList()
      ..sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
  }

  /// Documents par type
  List<Document> getByType(DocumentType type) {
    return _allDocuments.where((d) => d.type == type).toList()
      ..sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
  }

  /// Documents expirés
  List<Document> get expired {
    return _allDocuments.where((d) => d.isExpired).toList()
      ..sort((a, b) => a.expiryDate!.compareTo(b.expiryDate!));
  }

  /// Documents qui expirent bientôt (dans les 30 jours)
  List<Document> get expiringSoon {
    return _allDocuments.where((d) {
      if (d.expiryDate == null) return false;
      final days = d.daysUntilExpiry;
      return days != null && days <= 30 && days > 0;
    }).toList()
      ..sort((a, b) => a.expiryDate!.compareTo(b.expiryDate!));
  }

  /// Documents uploadés ce mois
  List<Document> get thisMonth {
    final now = DateTime.now();
    return _allDocuments.where((d) {
      return d.uploadDate.year == now.year && d.uploadDate.month == now.month;
    }).toList()
      ..sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
  }

  /// Trouver par ID
  Document? getById(String id) {
    try {
      return _allDocuments.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  // === Méthodes CRUD (MOCK) ===

  /// Ajouter un document
  Future<void> add(Document document) async {
    await Future.delayed(const Duration(milliseconds: 100)); // Simulate async
    _allDocuments.add(document);
    notifyListeners();
  }

  /// Mettre à jour un document
  Future<void> update(Document document) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _allDocuments.indexWhere((d) => d.id == document.id);
    if (index != -1) {
      _allDocuments[index] = document.markAsModified();
      notifyListeners();
    }
  }

  /// Supprimer un document
  Future<void> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _allDocuments.removeWhere((d) => d.id == id);
    notifyListeners();
  }

  /// Upload un nouveau document
  Future<Document> uploadDocument({
    required String farmId,
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
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate upload

    final document = Document(
      farmId: farmId,
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
    await Future.delayed(const Duration(milliseconds: 100));
    _allDocuments.removeWhere((d) => d.animalId == animalId);
    notifyListeners();
  }

  // === Statistiques ===

  /// Nombre de documents par type
  Map<DocumentType, int> getCountsByType() {
    final counts = <DocumentType, int>{};
    for (final doc in _allDocuments) {
      counts[doc.type] = (counts[doc.type] ?? 0) + 1;
    }
    return counts;
  }

  /// Taille totale des documents (en bytes)
  int get totalStorageUsed {
    return _allDocuments.fold<int>(
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
    return _allDocuments
        .where((d) => d.fileName.toLowerCase().contains(lowerQuery))
        .toList()
      ..sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
  }

  // === Chargement initial (MOCK) ===

  /// Charger les données de mock
  Future<void> loadMockData(List<Document> mockDocuments) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _allDocuments = mockDocuments;
    notifyListeners();
  }

  /// Réinitialiser les données
  void clear() {
    _allDocuments.clear();
    notifyListeners();
  }

  // === Synchronisation (MOCK - ne fait rien) ===

  /// Synchroniser avec le serveur (placeholder)
  Future<void> syncToServer() async {
    // TODO: Implémenter quand serveur prêt
    await Future.delayed(const Duration(milliseconds: 100));
    debugPrint('🔄 Sync documents simulée (mode mock)');
  }

  /// Marquer comme synchronisé (placeholder)
  void _markAsSynced(String id, String serverVersion) {
    // TODO: Implémenter quand serveur prêt
    debugPrint('✅ Document $id marqué comme synced (mode mock)');
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onFarmChanged);
    super.dispose();
  }
}