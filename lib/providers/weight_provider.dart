// lib/providers/weight_provider.dart
import 'package:flutter/foundation.dart';
import '../models/weight_record.dart';

/// Provider de gestion des pesées.
/// Aucune chaîne affichée à l'utilisateur n'est émise ici.
/// Toute validation/erreur côté UI doit passer par vos clés de traduction.
class WeightProvider extends ChangeNotifier {
  // (Optionnel) Clés techniques si besoin de logs externes
  static const String kLogWeightsSet = 'log.weight.set_list';
  static const String kLogWeightAdded = 'log.weight.added';
  static const String kLogWeightUpdated = 'log.weight.updated';
  static const String kLogWeightRemoved = 'log.weight.removed';

  final List<WeightRecord> _weights = [];

  /// Accès en lecture seule
  List<WeightRecord> get weights => List.unmodifiable(_weights);

  /// Remplace la liste complète (utile pour init/mocks/sync)
  void setWeights(List<WeightRecord> items) {
    _weights
      ..clear()
      ..addAll(items);
    notifyListeners();
    // debugPrint(kLogWeightsSet); // à activer si vous tracez via des clés
  }

  /// Ajoute un enregistrement de poids
  void addWeight(WeightRecord record) {
    _weights.add(record);
    notifyListeners();
    // debugPrint(kLogWeightAdded);
  }

  /// Met à jour un enregistrement existant (par id)
  void updateWeight(WeightRecord updated) {
    final idx = _weights.indexWhere((w) => w.id == updated.id);
    if (idx != -1) {
      _weights[idx] = updated;
      notifyListeners();
      // debugPrint(kLogWeightUpdated);
    }
  }

  /// Supprime un enregistrement par id
  void removeWeight(String id) {
    final before = _weights.length;
    _weights.removeWhere((w) => w.id == id); // removeWhere retourne void
    if (_weights.length < before) {
      notifyListeners();
      // debugPrint(kLogWeightRemoved);
    }
  }

  /// Retourne les poids enregistrés sur les `days` derniers jours (par défaut 30)
  List<WeightRecord> getRecentWeights({int days = 30}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return _weights.where((w) => w.recordedAt.isAfter(cutoffDate)).toList();
  }

  /// Poids moyen sur les `days` derniers jours (null si aucun)
  double? averageRecentWeight({int days = 30}) {
    final recent = getRecentWeights(days: days);
    if (recent.isEmpty) return null;

    // Utilise le champ réel du modèle: `weight`
    final sum = recent.fold<double>(0.0, (acc, w) => acc + w.weight);
    return sum / recent.length;
  }

  /// Retourne l’historique trié par date croissante (utile aux graphes)
  List<WeightRecord> get timelineSorted {
    final copy = [..._weights];
    copy.sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    return copy;
  }
}
