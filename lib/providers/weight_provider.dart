// lib/providers/weight_provider.dart

import 'package:flutter/foundation.dart';
import '../models/weight_record.dart';

/// Provider pour la gestion des pesées d'animaux
///
/// Gère l'enregistrement et le suivi des pesées pour :
/// - Suivre la croissance des animaux
/// - Calculer les gains de poids
/// - Analyser les performances
class WeightProvider with ChangeNotifier {
  // ==================== État ====================

  List<WeightRecord> _weights = [];

  // ==================== Getters ====================

  /// Toutes les pesées
  List<WeightRecord> get weights => List.unmodifiable(_weights);

  /// Nombre total de pesées
  int get totalWeights => _weights.length;

  // ==================== Méthodes Publiques ====================

  /// Obtenir toutes les pesées d'un animal (triées par date décroissante)
  List<WeightRecord> getAnimalWeights(String animalId) {
    return _weights.where((w) => w.animalId == animalId).toList()
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
  }

  /// Obtenir la pesée la plus récente d'un animal
  WeightRecord? getLatestWeight(String animalId) {
    final animalWeights = getAnimalWeights(animalId);
    return animalWeights.isEmpty ? null : animalWeights.first;
  }

  /// Obtenir le poids moyen d'un animal
  double? getAverageWeight(String animalId) {
    final animalWeights = getAnimalWeights(animalId);
    if (animalWeights.isEmpty) return null;

    final total = animalWeights.fold<double>(
      0.0,
      (sum, record) => sum + record.weight,
    );
    return total / animalWeights.length;
  }

  /// Calculer le gain de poids total d'un animal
  ///
  /// Retourne la différence entre la pesée la plus récente et la plus ancienne
  double? getWeightGain(String animalId) {
    final animalWeights = getAnimalWeights(animalId);
    if (animalWeights.length < 2) return null;

    final latest = animalWeights.first;
    final oldest = animalWeights.last;
    return latest.weight - oldest.weight;
  }

  /// Calculer le gain moyen quotidien (GMQ)
  ///
  /// Retourne le gain de poids par jour entre première et dernière pesée
  double? getDailyWeightGain(String animalId) {
    final animalWeights = getAnimalWeights(animalId);
    if (animalWeights.length < 2) return null;

    final latest = animalWeights.first;
    final oldest = animalWeights.last;

    final weightDiff = latest.weight - oldest.weight;
    final daysDiff = latest.recordedAt.difference(oldest.recordedAt).inDays;

    if (daysDiff <= 0) return null;

    return weightDiff / daysDiff;
  }

  /// Ajouter une nouvelle pesée
  void addWeight(WeightRecord record) {
    _weights.add(record);
    notifyListeners();

    debugPrint(
        '✅ Pesée ajoutée: ${record.weight}kg pour animal ${record.animalId}');
  }

  /// Supprimer une pesée
  void deleteWeight(String weightId) {
    _weights.removeWhere((w) => w.id == weightId);
    notifyListeners();

    debugPrint('🗑️ Pesée $weightId supprimée');
  }

  /// Modifier une pesée existante
  void updateWeight(WeightRecord updatedRecord) {
    final index = _weights.indexWhere((w) => w.id == updatedRecord.id);

    if (index != -1) {
      _weights[index] = updatedRecord;
      notifyListeners();

      debugPrint('✏️ Pesée ${updatedRecord.id} mise à jour');
    } else {
      debugPrint('⚠️ Pesée ${updatedRecord.id} non trouvée');
    }
  }

  /// Charger une liste de pesées
  void loadWeights(List<WeightRecord> weights) {
    _weights = weights;
    notifyListeners();
  }

  // ==================== Méthodes de Chargement ====================

  /// Initialiser avec des données de test (mock)
  void initializeWithMockData(List<WeightRecord> mockWeights) {
    _weights = mockWeights;
    notifyListeners();

    debugPrint('🧪 ${mockWeights.length} pesées de test chargées');
  }

  /// Charger les pesées depuis une source (base locale, API, etc.)
  Future<void> loadWeightsFromDatabase() async {
    // TODO: Implémenter chargement depuis SQLite
    debugPrint('📂 Chargement des pesées...');

    notifyListeners();
  }

  /// Sauvegarder les pesées (vers base locale)
  Future<void> saveWeightsToDatabase() async {
    // TODO: Implémenter sauvegarde vers SQLite
    debugPrint('💾 Sauvegarde des pesées...');
  }

  // ==================== Statistiques ====================

  /// Obtenir les pesées non synchronisées
  List<WeightRecord> get unsyncedWeights {
    return _weights.where((w) => !w.synced).toList();
  }

  /// Nombre de pesées non synchronisées
  int get unsyncedWeightCount => unsyncedWeights.length;

  /// Obtenir les pesées récentes (derniers 30 jours)
  List<WeightRecord> getRecentWeights({int days = 30}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return _weights.where((w) => w.recordedAt.isAfter(cutoffDate)).toList()
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
  }

  /// Obtenir le nombre de pesées par animal
  Map<String, int> get weightCountByAnimal {
    final Map<String, int> counts = {};

    for (final weight in _weights) {
      counts[weight.animalId] = (counts[weight.animalId] ?? 0) + 1;
    }

    return counts;
  }

  /// Obtenir les animaux avec le plus de pesées
  List<MapEntry<String, int>> getTopWeightedAnimals({int limit = 10}) {
    final counts = weightCountByAnimal;
    final sortedEntries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.take(limit).toList();
  }

  // ==================== Méthodes de Test ====================

  /// Réinitialiser toutes les données (pour tests)
  @visibleForTesting
  void reset() {
    _weights.clear();
    notifyListeners();
    debugPrint('🔄 WeightProvider réinitialisé');
  }
}
