// screens/animal_weight_history_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/animal.dart';
import '../models/weight_record.dart';
import '../providers/weight_provider.dart';
import 'weight_record_screen.dart';

/// Écran d'historique des pesées d'un animal
///
/// Affiche :
/// - Graphique d'évolution du poids
/// - Liste chronologique des pesées
/// - Statistiques (GMQ, gain total, moyenne)
class AnimalWeightHistoryScreen extends StatelessWidget {
  final Animal animal;

  const AnimalWeightHistoryScreen({
    super.key,
    required this.animal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des Pesées'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WeightRecordScreen(
                    preselectedAnimal: animal,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<WeightProvider>(
        builder: (context, weightProvider, child) {
          final weights = weightProvider.getAnimalWeights(animal.id);

          if (weights.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView(
            children: [
              // Header animal
              _buildAnimalHeader(context),

              // Statistiques
              _buildStatisticsSection(context, weightProvider, weights),

              // Graphique simple (placeholder)
              _buildChartSection(context, weights),

              // Liste des pesées
              _buildWeightsList(context, weights),
            ],
          );
        },
      ),
    );
  }

  /// Widget: État vide
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.monitor_weight, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 24),
            Text(
              'Aucune pesée',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Cet animal n\'a pas encore été pesé',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeightRecordScreen(
                      preselectedAnimal: animal,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Ajouter une Pesée'),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget: Header animal
  Widget _buildAnimalHeader(BuildContext context) {
    final sexColor = animal.sex == AnimalSex.male ? Colors.blue : Colors.pink;
    final sexIcon = animal.sex == AnimalSex.male ? Icons.male : Icons.female;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            sexColor.withOpacity(0.1),
            sexColor.withOpacity(0.05),
          ],
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: sexColor.withOpacity(0.2),
            child: Icon(sexIcon, size: 40, color: sexColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  animal.officialNumber ?? 'Sans numéro',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  animal.eid,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getAnimalAge(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Widget: Section statistiques
  Widget _buildStatisticsSection(
    BuildContext context,
    WeightProvider provider,
    List<WeightRecord> weights,
  ) {
    final latest = provider.getLatestWeight(animal.id);
    final average = provider.getAverageWeight(animal.id);
    final gain = provider.getWeightGain(animal.id);
    final dailyGain = provider.getDailyWeightGain(animal.id);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.analytics, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Statistiques',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Dernier Poids',
                      latest != null
                          ? '${latest.weight.toStringAsFixed(1)} kg'
                          : 'N/A',
                      Icons.monitor_weight,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatItem(
                      'Nombre de Pesées',
                      '${weights.length}',
                      Icons.list,
                      Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Poids Moyen',
                      average != null
                          ? '${average.toStringAsFixed(1)} kg'
                          : 'N/A',
                      Icons.show_chart,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatItem(
                      'Gain Total',
                      gain != null
                          ? '${gain > 0 ? '+' : ''}${gain.toStringAsFixed(1)} kg'
                          : 'N/A',
                      gain != null && gain > 0
                          ? Icons.trending_up
                          : Icons.trending_down,
                      gain != null && gain > 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
              if (dailyGain != null) ...[
                const SizedBox(height: 12),
                _buildStatItem(
                  'GMQ (Gain Moyen Quotidien)',
                  '${dailyGain.toStringAsFixed(0)} g/jour',
                  Icons.speed,
                  Colors.purple,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Widget: Item de statistique
  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
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

  /// Widget: Graphique (placeholder)
  Widget _buildChartSection(BuildContext context, List<WeightRecord> weights) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.show_chart, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Évolution du Poids',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Graphique simple (placeholder)
              SizedBox(
                height: 200,
                child: CustomPaint(
                  painter: _WeightChartPainter(weights),
                  child: Container(),
                ),
              ),

              const SizedBox(height: 8),

              // Légende
              Center(
                child: Text(
                  'Évolution sur ${weights.length} pesées',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget: Liste des pesées
  Widget _buildWeightsList(BuildContext context, List<WeightRecord> weights) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.history, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Historique Complet',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: weights.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final weight = weights[index];
                final isLatest = index == 0;

                // Calculer la différence avec la pesée précédente
                String? diffText;
                Color? diffColor;
                if (index < weights.length - 1) {
                  final previousWeight = weights[index + 1];
                  final diff = weight.weight - previousWeight.weight;
                  if (diff != 0) {
                    diffText =
                        '${diff > 0 ? '+' : ''}${diff.toStringAsFixed(1)} kg';
                    diffColor = diff > 0 ? Colors.green : Colors.red;
                  }
                }

                return ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isLatest
                          ? Colors.green.shade100
                          : Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        weight.sourceIcon,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(
                        weight.formattedWeight,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              isLatest ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (isLatest) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'ACTUEL',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(weight.formattedDate),
                      if (diffText != null)
                        Text(
                          diffText,
                          style: TextStyle(
                            fontSize: 12,
                            color: diffColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      if (weight.notes != null && weight.notes!.isNotEmpty)
                        Text(
                          weight.notes!,
                          style: TextStyle(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        weight.sourceLabel,
                        style: const TextStyle(fontSize: 11),
                      ),
                      if (!weight.synced)
                        Icon(
                          Icons.sync_disabled,
                          size: 14,
                          color: Colors.orange.shade700,
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Obtenir l'âge de l'animal
  String _getAnimalAge() {
    if (animal.birthDate == null) return 'Âge inconnu';

    final now = DateTime.now();
    final age = now.difference(animal.birthDate!);
    final months = (age.inDays / 30).floor();
    final years = (months / 12).floor();

    if (years > 0) {
      final remainingMonths = months % 12;
      if (remainingMonths > 0) {
        return '$years an${years > 1 ? 's' : ''} et $remainingMonths mois';
      }
      return '$years an${years > 1 ? 's' : ''}';
    }

    return '$months mois';
  }
}

/// Painter pour le graphique simple
class _WeightChartPainter extends CustomPainter {
  final List<WeightRecord> weights;

  _WeightChartPainter(this.weights);

  @override
  void paint(Canvas canvas, Size size) {
    if (weights.isEmpty) return;

    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    // Inverser l'ordre pour avoir du plus ancien au plus récent
    final sortedWeights = weights.reversed.toList();

    // Trouver min et max
    double minWeight =
        sortedWeights.map((w) => w.weight).reduce((a, b) => a < b ? a : b);
    double maxWeight =
        sortedWeights.map((w) => w.weight).reduce((a, b) => a > b ? a : b);

    // Ajouter une marge
    final margin = (maxWeight - minWeight) * 0.1;
    minWeight -= margin;
    maxWeight += margin;

    // Calculer les points
    final path = Path();
    for (int i = 0; i < sortedWeights.length; i++) {
      final x = (i / (sortedWeights.length - 1)) * size.width;
      final y = size.height -
          ((sortedWeights[i].weight - minWeight) / (maxWeight - minWeight)) *
              size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      // Dessiner les points
      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }

    canvas.drawPath(path, paint);

    // Dessiner les axes
    final axisPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    // Axe Y (3 lignes horizontales)
    for (int i = 0; i <= 2; i++) {
      final y = (i / 2) * size.height;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), axisPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
