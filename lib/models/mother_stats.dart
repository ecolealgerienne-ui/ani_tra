// lib/models/mother_stats.dart

/// Statistiques de reproduction d'une mère
class MotherStats {
  /// Nombre total de naissances
  final int totalBirths;

  /// Nombre de descendants vivants
  final int aliveOffspring;

  /// Date de la dernière naissance
  final DateTime? lastBirthDate;

  /// Intervalle moyen entre naissances
  final Duration? averageInterval;

  const MotherStats({
    required this.totalBirths,
    required this.aliveOffspring,
    this.lastBirthDate,
    this.averageInterval,
  });

  /// Formattage de l'intervalle moyen en mois
  String get formattedInterval {
    if (averageInterval == null) return 'N/A';
    final months = (averageInterval!.inDays / 30).round();
    return '$months mois';
  }

  /// Nombre de descendants décédés/vendus
  int get nonAliveOffspring => totalBirths - aliveOffspring;

  /// Taux de survie en pourcentage
  double get survivalRate {
    if (totalBirths == 0) return 0.0;
    return (aliveOffspring / totalBirths) * 100;
  }

  /// Affichage formatté du taux de survie
  String get formattedSurvivalRate {
    return '${survivalRate.toStringAsFixed(1)}%';
  }
}
