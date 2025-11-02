// lib/widgets/stat_card_widget.dart
import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Carte de statistique métier pour l'écran d'accueil
///
/// Affiche une statistique importante avec :
/// - Icône colorée
/// - Valeur principale (grand)
/// - Label descriptif
/// - Variation optionnelle (+/- par rapport à avant)
/// - Action au tap
///
/// Design moderne avec ombre légère et coins arrondis
class StatCardWidget extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final String? subtitle;
  final StatVariation? variation;
  final VoidCallback? onTap;

  const StatCardWidget({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    this.subtitle,
    this.variation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header : Icône et variation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icône dans un conteneur coloré
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 24,
                    ),
                  ),

                  // Badge de variation (si présent)
                  if (variation != null) _buildVariationBadge(variation!),
                ],
              ),
              const SizedBox(height: 16),

              // Valeur principale (grand)
              Text(
                value,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),

              // Label descriptif
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // Sous-titre optionnel
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Construit le badge de variation (+/-)
  Widget _buildVariationBadge(StatVariation variation) {
    final isPositive = variation.value >= 0;
    final color = isPositive ? Colors.green : Colors.red;
    final icon = isPositive ? Icons.trending_up : Icons.trending_down;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            '${isPositive ? '+' : ''}${variation.value}${variation.isPercentage ? '%' : ''}',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Variation d'une statistique
class StatVariation {
  final double value; // Peut être positif ou négatif
  final bool isPercentage; // true = %, false = nombre absolu

  const StatVariation({
    required this.value,
    this.isPercentage = false,
  });

  factory StatVariation.percentage(double percent) {
    return StatVariation(value: percent, isPercentage: true);
  }

  factory StatVariation.absolute(double count) {
    return StatVariation(value: count, isPercentage: false);
  }
}

/// Carte de statistique compacte (version horizontale pour grille)
///
/// Version plus petite pour afficher plusieurs stats côte à côte
class CompactStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final VoidCallback? onTap;

  const CompactStatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Icône compacte
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              // Valeur et label
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Grille de statistiques compactes
///
/// Affiche 2 ou 3 cartes compactes par ligne selon l'espace disponible
class StatsGrid extends StatelessWidget {
  final List<CompactStatCard> stats;
  final int crossAxisCount;

  const StatsGrid({
    super.key,
    required this.stats,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5, // Largeur / Hauteur
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) => stats[index],
    );
  }
}

/// Builder de statistiques prédéfinies pour l'élevage
class FarmStatCards {
  /// Carte pour le nombre total d'animaux
  static StatCardWidget totalAnimals({
    required int count,
    StatVariation? variation,
    VoidCallback? onTap,
  }) {
    return StatCardWidget(
      icon: Icons.pets_rounded,
      iconColor: AppConstants.primaryGreen,
      value: '$count',
      label: count == 1 ? 'Animal' : 'Animaux',
      subtitle: 'Total dans le troupeau',
      variation: variation,
      onTap: onTap,
    );
  }

  /// Carte pour les lots actifs
  static StatCardWidget activeBatches({
    required int count,
    StatVariation? variation,
    VoidCallback? onTap,
  }) {
    return StatCardWidget(
      icon: Icons.inventory_2_rounded,
      iconColor: AppConstants.tertiaryBlue,
      value: '$count',
      label: count == 1 ? 'Lot actif' : 'Lots actifs',
      subtitle: 'En cours de préparation',
      variation: variation,
      onTap: onTap,
    );
  }

  /// Carte pour les traitements actifs
  static StatCardWidget activeTreatments({
    required int count,
    StatVariation? variation,
    VoidCallback? onTap,
  }) {
    return StatCardWidget(
      icon: Icons.medical_services_rounded,
      iconColor: Colors.purple,
      value: '$count',
      label: count == 1 ? 'Traitement' : 'Traitements',
      subtitle: 'En cours',
      variation: variation,
      onTap: onTap,
    );
  }

  /// Carte pour le poids moyen
  static StatCardWidget averageWeight({
    required double weight,
    StatVariation? variation,
    VoidCallback? onTap,
  }) {
    return StatCardWidget(
      icon: Icons.monitor_weight_rounded,
      iconColor: AppConstants.secondaryBrown,
      value: '${weight.toStringAsFixed(1)} kg',
      label: 'Poids moyen',
      subtitle: 'Sur 30 derniers jours',
      variation: variation,
      onTap: onTap,
    );
  }

  /// Carte pour les animaux en alerte
  static StatCardWidget alertAnimals({
    required int count,
    VoidCallback? onTap,
  }) {
    return StatCardWidget(
      icon: Icons.warning_rounded,
      iconColor: Colors.orange.shade700,
      value: '$count',
      label: count == 1 ? 'Animal en alerte' : 'Animaux en alerte',
      subtitle: 'Délai d\'attente < 7 jours',
      onTap: onTap,
    );
  }

  /// Carte pour les animaux critiques
  static StatCardWidget criticalAnimals({
    required int count,
    VoidCallback? onTap,
  }) {
    return StatCardWidget(
      icon: Icons.error_rounded,
      iconColor: Colors.red.shade700,
      value: '$count',
      label: count == 1 ? 'Animal critique' : 'Animaux critiques',
      subtitle: 'Délai d\'attente < 3 jours',
      onTap: onTap,
    );
  }
}
