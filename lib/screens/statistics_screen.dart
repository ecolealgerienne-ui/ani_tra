// screens/statistics_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/animal.dart';
import '../models/movement.dart';
import '../providers/animal_provider.dart';
import '../providers/weight_provider.dart';
import '../providers/campaign_provider.dart';
import '../providers/batch_provider.dart';

/// Écran de statistiques avancées
///
/// Affiche :
/// - Répartition du troupeau (sexe, âge, statut)
/// - Évolution (naissances, ventes, morts)
/// - Statistiques de pesée
/// - Campagnes et traitements
/// - Graphiques visuels
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String _selectedPeriod = 'year'; // all, year, month, week

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
        actions: [
          // Sélecteur de période
          PopupMenuButton<String>(
            icon: const Icon(Icons.date_range),
            onSelected: (value) {
              setState(() {
                _selectedPeriod = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('Tout'),
              ),
              const PopupMenuItem(
                value: 'year',
                child: Text('Cette année'),
              ),
              const PopupMenuItem(
                value: 'month',
                child: Text('Ce mois'),
              ),
              const PopupMenuItem(
                value: 'week',
                child: Text('Cette semaine'),
              ),
            ],
          ),
        ],
      ),
      body: Consumer4<AnimalProvider, WeightProvider, CampaignProvider,
          BatchProvider>(
        builder: (context, animalProvider, weightProvider, campaignProvider,
            batchProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Période sélectionnée
              _buildPeriodHeader(),

              const SizedBox(height: 16),

              // Vue d'ensemble
              _buildOverviewSection(animalProvider),

              const SizedBox(height: 16),

              // Répartition du troupeau
              _buildHerdDistribution(animalProvider),

              const SizedBox(height: 16),

              // Mouvements
              _buildMovementsSection(animalProvider),

              const SizedBox(height: 16),

              // Statistiques de pesée
              _buildWeightStatistics(weightProvider, animalProvider),

              const SizedBox(height: 16),

              // Campagnes
              _buildCampaignsSection(campaignProvider),

              const SizedBox(height: 16),

              // Lots
              _buildBatchesSection(batchProvider),

              const SizedBox(height: 16),

              // Performances
              _buildPerformanceSection(animalProvider, weightProvider),
            ],
          );
        },
      ),
    );
  }

  /// Widget: Header de période
  Widget _buildPeriodHeader() {
    String periodText;
    IconData periodIcon;

    switch (_selectedPeriod) {
      case 'week':
        periodText = 'Cette semaine';
        periodIcon = Icons.calendar_view_week;
        break;
      case 'month':
        periodText = 'Ce mois';
        periodIcon = Icons.calendar_view_month;
        break;
      case 'year':
        periodText = 'Cette année';
        periodIcon = Icons.calendar_today;
        break;
      case 'all':
      default:
        periodText = 'Toutes les données';
        periodIcon = Icons.all_inclusive;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(periodIcon, color: Colors.blue.shade700),
          const SizedBox(width: 12),
          Text(
            periodText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
        ],
      ),
    );
  }

  /// Widget: Vue d'ensemble
  Widget _buildOverviewSection(AnimalProvider provider) {
    final total = provider.animals.length;
    final alive =
        provider.animals.where((a) => a.status == AnimalStatus.alive).length;
    final sold =
        provider.animals.where((a) => a.status == AnimalStatus.sold).length;
    final dead =
        provider.animals.where((a) => a.status == AnimalStatus.dead).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.dashboard, size: 20),
                SizedBox(width: 8),
                Text(
                  'Vue d\'ensemble',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildStatBox(
                    'Total',
                    '$total',
                    Icons.pets,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatBox(
                    'Vivants',
                    '$alive',
                    Icons.favorite,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatBox(
                    'Vendus',
                    '$sold',
                    Icons.sell,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatBox(
                    'Morts',
                    '$dead',
                    Icons.error,
                    Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Widget: Répartition du troupeau
  Widget _buildHerdDistribution(AnimalProvider provider) {
    final aliveAnimals =
        provider.animals.where((a) => a.status == AnimalStatus.alive).toList();

    final males = aliveAnimals.where((a) => a.sex == AnimalSex.male).length;
    final females = aliveAnimals.where((a) => a.sex == AnimalSex.female).length;

    // Répartition par âge (approximatif)
    final now = DateTime.now();
    int lambs = 0; // < 6 mois
    int young = 0; // 6-12 mois
    int adults = 0; // > 12 mois

    for (final animal in aliveAnimals) {
      if (animal.birthDate == null) continue;

      final age = now.difference(animal.birthDate!);
      final months = (age.inDays / 30).floor();

      if (months < 6) {
        lambs++;
      } else if (months < 12) {
        young++;
      } else {
        adults++;
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.pie_chart, size: 20),
                SizedBox(width: 8),
                Text(
                  'Répartition du Troupeau',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),

            // Par sexe
            const Text(
              'Par Sexe',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _PercentageBar(
                    label: 'Mâles',
                    value: males,
                    total: aliveAnimals.length,
                    color: Colors.blue,
                    icon: Icons.male,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _PercentageBar(
                    label: 'Femelles',
                    value: females,
                    total: aliveAnimals.length,
                    color: Colors.pink,
                    icon: Icons.female,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Par âge
            const Text(
              'Par Âge',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildAgeStatBox(
                      'Agneaux\n(< 6 mois)', '$lambs', Colors.green),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAgeStatBox(
                      'Jeunes\n(6-12 mois)', '$young', Colors.orange),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAgeStatBox(
                      'Adultes\n(> 12 mois)', '$adults', Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Widget: Section mouvements
  Widget _buildMovementsSection(AnimalProvider provider) {
    final movements = provider.movements;

    final births = movements.where((m) => m.type == MovementType.birth).length;
    final sales = movements.where((m) => m.type == MovementType.sale).length;
    final deaths = movements.where((m) => m.type == MovementType.death).length;
    final slaughters =
        movements.where((m) => m.type == MovementType.slaughter).length;

    // Calculer le total des ventes
    double totalSales = 0;
    for (final movement in movements) {
      if (movement.type == MovementType.sale && movement.price != null) {
        totalSales += movement.price!;
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.swap_horiz, size: 20),
                SizedBox(width: 8),
                Text(
                  'Mouvements',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildMovementRow(
                'Naissances', births, Icons.child_care, Colors.green),
            const SizedBox(height: 12),
            _buildMovementRow('Ventes', sales, Icons.sell, Colors.blue),
            const SizedBox(height: 12),
            _buildMovementRow(
                'Abattages', slaughters, Icons.factory, Colors.orange),
            const SizedBox(height: 12),
            _buildMovementRow('Morts', deaths, Icons.error, Colors.red),
            if (totalSales > 0) ...[
              const Divider(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.euro, color: Colors.green.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chiffre d\'affaires',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            '${totalSales.toStringAsFixed(2)} €',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Widget: Statistiques de pesée
  Widget _buildWeightStatistics(
      WeightProvider weightProvider, AnimalProvider animalProvider) {
    final weights = weightProvider.weights;
    final totalWeights = weights.length;

    // Poids moyen
    double avgWeight = 0;
    if (weights.isNotEmpty) {
      final total = weights.fold<double>(0.0, (sum, w) => sum + w.weight);
      avgWeight = total / weights.length;
    }

    // Pesées récentes (derniers 7 jours)
    final now = DateTime.now();
    final recentWeights = weights.where((w) {
      return now.difference(w.recordedAt).inDays <= 7;
    }).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.monitor_weight, size: 20),
                SizedBox(width: 8),
                Text(
                  'Pesées',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildStatBox(
                    'Total',
                    '$totalWeights',
                    Icons.scale,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatBox(
                    'Récentes (7j)',
                    '$recentWeights',
                    Icons.access_time,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            if (avgWeight > 0) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.show_chart, color: Colors.purple.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Poids moyen',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Text(
                            '${avgWeight.toStringAsFixed(1)} kg',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Widget: Section campagnes
  Widget _buildCampaignsSection(CampaignProvider provider) {
    final total = provider.campaigns.length;
    final active = provider.activeCampaigns.length;
    final completed = provider.completedCampaigns.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.medical_services, size: 20),
                SizedBox(width: 8),
                Text(
                  'Campagnes Sanitaires',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildStatBox(
                    'Total',
                    '$total',
                    Icons.campaign,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatBox(
                    'Actives',
                    '$active',
                    Icons.hourglass_empty,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatBox(
                    'Terminées',
                    '$completed',
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Widget: Section lots
  Widget _buildBatchesSection(BatchProvider provider) {
    final total = provider.batchCount;
    final active = provider.activeBatchCount;
    final completed = provider.completedBatches.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.inventory, size: 20),
                SizedBox(width: 8),
                Text(
                  'Lots',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildStatBox(
                    'Total',
                    '$total',
                    Icons.inventory_2,
                    Colors.deepPurple,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatBox(
                    'Actifs',
                    '$active',
                    Icons.hourglass_empty,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatBox(
                    'Complétés',
                    '$completed',
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Widget: Section performances
  Widget _buildPerformanceSection(
      AnimalProvider animalProvider, WeightProvider weightProvider) {
    // Taux de mortalité
    final total = animalProvider.animals.length;
    final dead = animalProvider.animals
        .where((a) => a.status == AnimalStatus.dead)
        .length;
    final mortalityRate = total > 0 ? (dead / total * 100) : 0.0;

    // Taux de fertilité (nombre de naissances / femelles adultes)
    final females = animalProvider.animals
        .where(
            (a) => a.status == AnimalStatus.alive && a.sex == AnimalSex.female)
        .length;
    final births = animalProvider.movements
        .where((m) => m.type == MovementType.birth)
        .length;
    final fertilityRate = females > 0 ? (births / females * 100) : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.trending_up, size: 20),
                SizedBox(width: 8),
                Text(
                  'Performances',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildPerformanceRow(
              'Taux de mortalité',
              '${mortalityRate.toStringAsFixed(1)}%',
              mortalityRate < 5
                  ? Colors.green
                  : mortalityRate < 10
                      ? Colors.orange
                      : Colors.red,
              Icons.error,
            ),
            const SizedBox(height: 12),
            _buildPerformanceRow(
              'Taux de fertilité',
              '${fertilityRate.toStringAsFixed(1)}%',
              fertilityRate > 80
                  ? Colors.green
                  : fertilityRate > 60
                      ? Colors.orange
                      : Colors.red,
              Icons.child_care,
            ),
          ],
        ),
      ),
    );
  }

  /// Widget: Boîte de statistique
  Widget _buildStatBox(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Widget: Boîte de statistique d'âge
  Widget _buildAgeStatBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Widget: Ligne de mouvement
  Widget _buildMovementRow(
      String label, int count, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  /// Widget: Ligne de performance
  Widget _buildPerformanceRow(
      String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget: Barre de pourcentage
class _PercentageBar extends StatelessWidget {
  final String label;
  final int value;
  final int total;
  final Color color;
  final IconData icon;

  const _PercentageBar({
    required this.label,
    required this.value,
    required this.total,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? (value / total * 100) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              '$value (${percentage.toStringAsFixed(0)}%)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: total > 0 ? value / total : 0,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
