// providers/batch_provider.dart
import 'package:flutter/foundation.dart';
import '../models/batch.dart';
import 'auth_provider.dart';

/// Provider pour la gestion des lots d'animaux
///
/// Gère la création, modification et utilisation des lots pour :
/// - Vente groupée
/// - Abattage groupé
/// - Traitement groupé
/// - Autres actions de masse
class BatchProvider with ChangeNotifier {
  // ==================== Constantes (clés de messages / logs) ====================
  final AuthProvider _authProvider;
  String _currentFarmId;
  
  BatchProvider(this._authProvider)
      : _currentFarmId = _authProvider.currentFarmId {
    _authProvider.addListener(_onFarmChanged);
  }

  void _onFarmChanged() {
    if (_currentFarmId != _authProvider.currentFarmId) {
      _currentFarmId = _authProvider.currentFarmId;
      _activeBatch = null;
      notifyListeners();
    }
  }

  static const String kLogBatchCreated = 'log.batch.created';
  static const String kLogBatchNoActive = 'log.batch.no_active';
  static const String kLogBatchAnimalAlreadyIn = 'log.batch.animal_already_in';
  static const String kLogBatchAnimalAdded = 'log.batch.animal_added';
  static const String kLogBatchAnimalRemoved = 'log.batch.animal_removed';
  static const String kLogBatchNotFound = 'log.batch.not_found';
  static const String kLogBatchCompleted = 'log.batch.completed';
  static const String kLogBatchDeleted = 'log.batch.deleted';
  static const String kLogBatchActiveReset = 'log.batch.active_reset';
  static const String kLogBatchActivated = 'log.batch.activated';
  static const String kLogBatchLoading = 'log.batch.loading';
  static const String kLogBatchSaving = 'log.batch.saving';
  static const String kLogBatchMockLoaded = 'log.batch.mock_loaded';
  static const String kLogBatchReset = 'log.batch.reset';

  // Pour exceptions (clés d’erreur)
  static const String kErrBatchNotFound = 'err.batch.not_found';
  static const String kErrCannotReactivateCompleted =
      'err.batch.cannot_reactivate_completed';

  // ==================== État ====================

  /// Liste de tous les lots (actifs et complétés)
  List<Batch> _allBatches = [];

  /// Lot actuellement en cours de création (scan en cours)
  Batch? _activeBatch;

  // ==================== Getters ====================

  /// Tous les lots
  List<Batch> get batches => List.unmodifiable(
      _allBatches.where((b) => b.farmId == _authProvider.currentFarmId));

  /// Lots non complétés uniquement
  List<Batch> get activeBatches => batches.where((b) => !b.completed).toList();

  /// Lots complétés uniquement
  List<Batch> get completedBatches =>
      batches.where((b) => b.completed).toList();

  /// Lot en cours de création/modification
  Batch? get activeBatch => _activeBatch;

  /// Y a-t-il un lot actif ?
  bool get hasActiveBatch => _activeBatch != null;

  /// Nombre total de lots
  int get batchCount => _allBatches.length;

  /// Nombre de lots actifs
  int get activeBatchCount => activeBatches.length;

  // ==================== Méthodes Publiques ====================

  /// Créer un nouveau lot et le définir comme actif
  ///
  /// [name] : Nom du lot (ex: "Abattage Novembre 2025")
  /// [purpose] : Objectif du lot (vente, abattage, traitement, autre)
  ///
  /// Retourne le lot créé
  Batch createBatch(String name, BatchPurpose purpose) {
    final batch = Batch(
      id: _generateId(),
      name: name,
      purpose: purpose,
      animalIds: [],
      createdAt: DateTime.now(),
      completed: false,
      synced: false,
    );

    final batchWithFarm = batch.copyWith(farmId: _authProvider.currentFarmId);
    _allBatches.add(batchWithFarm);
    _activeBatch = batchWithFarm;

    notifyListeners();

    // Logs via clés (multi-langue gérée au-dessus si besoin)
    debugPrint('$kLogBatchCreated|name=$name|purpose=${purpose.name}');

    return batch;
  }

  /// Ajouter un animal au lot actif
  ///
  /// [animalId] : ID de l'animal à ajouter
  ///
  /// Retourne true si ajouté avec succès, false si doublon
  bool addAnimalToBatch(String animalId) {
    if (_activeBatch == null) {
      debugPrint(kLogBatchNoActive);
      return false;
    }

    // Vérifier doublon
    if (_activeBatch!.animalIds.contains(animalId)) {
      debugPrint('$kLogBatchAnimalAlreadyIn|animalId=$animalId');
      return false;
    }

    // Créer une copie modifiée du lot
    final updatedBatch = Batch(
      id: _activeBatch!.id,
      name: _activeBatch!.name,
      purpose: _activeBatch!.purpose,
      animalIds: [..._activeBatch!.animalIds, animalId],
      createdAt: _activeBatch!.createdAt,
      usedAt: _activeBatch!.usedAt,
      completed: _activeBatch!.completed,
      synced: false, // Marquer comme non synchronisé
    );

    // Remplacer dans la liste
    final index = _allBatches.indexWhere((b) => b.id == _activeBatch!.id);
    if (index != -1) {
      _allBatches[index] = updatedBatch;
      _activeBatch = updatedBatch;
    }

    notifyListeners();

    debugPrint(
        '$kLogBatchAnimalAdded|animalId=$animalId|count=${updatedBatch.animalCount}');

    return true;
  }

  /// Retirer un animal du lot actif
  ///
  /// [animalId] : ID de l'animal à retirer
  ///
  /// Retourne true si retiré avec succès
  bool removeAnimalFromBatch(String animalId) {
    if (_activeBatch == null) {
      debugPrint(kLogBatchNoActive);
      return false;
    }

    if (!_activeBatch!.animalIds.contains(animalId)) {
      debugPrint('$kLogBatchAnimalAlreadyIn|not_present|animalId=$animalId');
      return false;
    }

    // Créer une copie modifiée
    final updatedAnimalIds = List<String>.from(_activeBatch!.animalIds)
      ..remove(animalId);

    final updatedBatch = Batch(
      id: _activeBatch!.id,
      name: _activeBatch!.name,
      purpose: _activeBatch!.purpose,
      animalIds: updatedAnimalIds,
      createdAt: _activeBatch!.createdAt,
      usedAt: _activeBatch!.usedAt,
      completed: _activeBatch!.completed,
      synced: false,
    );

    // Remplacer dans la liste
    final index = _allBatches.indexWhere((b) => b.id == _activeBatch!.id);
    if (index != -1) {
      _allBatches[index] = updatedBatch;
      _activeBatch = updatedBatch;
    }

    notifyListeners();

    debugPrint(
        '$kLogBatchAnimalRemoved|animalId=$animalId|count=${updatedBatch.animalCount}');

    return true;
  }

  /// Vérifier si un animal est déjà dans le lot actif
  ///
  /// Utilisé pour détecter les doublons lors du scan
  bool isAnimalInActiveBatch(String animalId) {
    if (_activeBatch == null) return false;
    return _activeBatch!.animalIds.contains(animalId);
  }

  /// Marquer un lot comme complété (utilisé)
  ///
  /// [batchId] : ID du lot à compléter
  ///
  /// Appelé après une vente, un abattage, etc.
  void completeBatch(String batchId) {
    final index = _allBatches.indexWhere((b) => b.id == batchId);

    if (index == -1) {
      debugPrint('$kLogBatchNotFound|id=$batchId');
      return;
    }

    final batch = _allBatches[index];

    final updatedBatch = Batch(
      id: batch.id,
      name: batch.name,
      purpose: batch.purpose,
      animalIds: batch.animalIds,
      createdAt: batch.createdAt,
      usedAt: DateTime.now(),
      completed: true,
      synced: false,
    );

    _allBatches[index] = updatedBatch;

    // Si c'était le lot actif, le déréférencer
    if (_activeBatch?.id == batchId) {
      _activeBatch = null;
    }

    notifyListeners();

    debugPrint('$kLogBatchCompleted|name=${batch.name}');
  }

  /// Supprimer un lot
  ///
  /// [batchId] : ID du lot à supprimer
  void deleteBatch(String batchId) {
    final index = _allBatches.indexWhere((b) => b.id == batchId);

    if (index == -1) {
      debugPrint('$kLogBatchNotFound|id=$batchId');
      return;
    }

    final batch = _allBatches[index];

    _allBatches.removeAt(index);

    // Si c'était le lot actif, le déréférencer
    if (_activeBatch?.id == batchId) {
      _activeBatch = null;
    }

    notifyListeners();

    debugPrint('$kLogBatchDeleted|name=${batch.name}');
  }

  /// Réinitialiser le lot actif (abandon de création)
  void clearActiveBatch() {
    if (_activeBatch != null) {
      debugPrint('$kLogBatchActiveReset|name=${_activeBatch!.name}');
      _activeBatch = null;
      notifyListeners();
    }
  }

  /// Définir un lot existant comme actif (pour modification)
  ///
  /// [batchId] : ID du lot à réactiver
  void setActiveBatch(String batchId) {
    final batch = _allBatches.firstWhere(
      (b) => b.id == batchId,
      orElse: () => throw Exception(kErrBatchNotFound),
    );

    if (batch.completed) {
      // On garde un log neutre (clé), et on ne réactive pas
      debugPrint(kErrCannotReactivateCompleted);
      return;
    }

    _activeBatch = batch;
    notifyListeners();

    debugPrint('$kLogBatchActivated|name=${batch.name}');
  }

  /// Obtenir un lot par son ID
  ///
  /// Retourne null si non trouvé
  Batch? getBatchById(String batchId) {
    try {
      return _allBatches.firstWhere((b) => b.id == batchId);
    } catch (e) {
      return null;
    }
  }

  /// Obtenir tous les lots contenant un animal spécifique
  ///
  /// Utile pour vérifier si un animal est déjà dans un lot
  List<Batch> getBatchesContainingAnimal(String animalId) {
    return _allBatches
        .where((batch) => batch.animalIds.contains(animalId))
        .toList();
  }

  /// Obtenir les lots par objectif
  List<Batch> getBatchesByPurpose(BatchPurpose purpose) {
    return _allBatches.where((b) => b.purpose == purpose).toList();
  }

  // ==================== Méthodes de Chargement ====================

  /// Charger les lots depuis une source (base locale, API, etc.)
  ///
  /// À implémenter avec la base de données SQLite
  Future<void> loadBatches() async {
    // TODO: Implémenter chargement depuis SQLite
    debugPrint(kLogBatchLoading);

    // Pour l'instant, on garde les données en mémoire
    notifyListeners();
  }

  /// Sauvegarder les lots (vers base locale)
  ///
  /// À implémenter avec la base de données SQLite
  Future<void> saveBatches() async {
    // TODO: Implémenter sauvegarde vers SQLite
    debugPrint(kLogBatchSaving);
  }

  /// Initialiser avec des données de test (mock)
  void initializeWithMockData(List<Batch> mockBatches) {
    _allBatches = mockBatches;
    notifyListeners();

    debugPrint('$kLogBatchMockLoaded|count=${mockBatches.length}');
  }

  // ==================== Méthodes Privées ====================

  /// Générer un ID unique pour un lot
  ///
  /// Format: batch_[timestamp]_[random]
  String _generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'batch_${timestamp}_$random';
  }

  // ==================== Statistiques ====================

  /// Obtenir le nombre total d'animaux dans tous les lots actifs
  int get totalAnimalsInActiveBatches {
    return activeBatches.fold(0, (sum, batch) => sum + batch.animalCount);
  }

  /// Obtenir la distribution des lots par objectif
  Map<BatchPurpose, int> get batchesByPurposeCount {
    final Map<BatchPurpose, int> distribution = {
      BatchPurpose.sale: 0,
      BatchPurpose.slaughter: 0,
      BatchPurpose.treatment: 0,
      BatchPurpose.other: 0,
    };

    for (final batch in _allBatches) {
      distribution[batch.purpose] = (distribution[batch.purpose] ?? 0) + 1;
    }

    return distribution;
  }

  /// Réinitialiser toutes les données (pour tests)
  @visibleForTesting
  void reset() {
    _allBatches.clear();
    _activeBatch = null;
    notifyListeners();
    debugPrint(kLogBatchReset);
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onFarmChanged);
    super.dispose();
  }
}
