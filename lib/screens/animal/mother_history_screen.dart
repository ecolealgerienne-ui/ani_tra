// lib/screens/animal/mother_history_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/animal.dart';
import '../../providers/animal_provider.dart';

/// Écran d'historique des portées d'une mère
///
/// Affiche:
/// - Statistiques de reproduction
/// - Liste des descendants
/// - Informations sur chaque portée
class MotherHistoryScreen extends StatelessWidget {
  final Animal mother;

  const MotherHistoryScreen({
    super.key,
    required this.mother,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique reproduction'),
      ),
      body: Consumer<AnimalProvider>(
        builder: (context, animalProvider, child) {
          final stats = animalProvider.getMotherStats(mother.id);
          final offspring = animalProvider.getOffspring(mother.id);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Informations mère
              _buildMotherCard(context),

              const SizedBox(height: 16),

              // Statistiques
              _buildStatsCard(context, stats),

              const SizedBox(height: 24),

              // Liste descendants
              Text(
                'Descendants (${offspring.length})',
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 8),

              if (offspring.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.info_outline,
                              size: 48, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            'Aucun descendant enregistré',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                ...offspring
                    .map((child) => _buildOffspringCard(context, child)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMotherCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.female, color: Colors.pink),
                const SizedBox(width: 8),
                Text(
                  'Mère: ${mother.displayName}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Âge: ${mother.ageInMonths} mois (${mother.ageInDays} jours)'),
            if (mother.breedId != null) Text('Race: ${mother.breedId}'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context, stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistiques de reproduction',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Total naissances',
                    stats.totalBirths.toString(),
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Vivants',
                    stats.aliveOffspring.toString(),
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Taux survie',
                    stats.formattedSurvivalRate,
                    Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Intervalle moyen',
                    stats.formattedInterval,
                    Colors.purple,
                  ),
                ),
              ],
            ),
            if (stats.lastBirthDate != null) ...[
              const SizedBox(height: 12),
              Text(
                'Dernière naissance: ${DateFormat('dd/MM/yyyy').format(stats.lastBirthDate!)}',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
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

  Widget _buildOffspringCard(BuildContext context, Animal child) {
    final age = child.ageInMonths;
    final statusColor = child.status == AnimalStatus.alive
        ? Colors.green
        : child.status == AnimalStatus.sold
            ? Colors.blue
            : Colors.grey;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.2),
          child: Icon(
            child.sex == AnimalSex.male ? Icons.male : Icons.female,
            color: statusColor,
          ),
        ),
        title: Text(
          child.displayName,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Né le ${DateFormat('dd/MM/yyyy').format(child.birthDate)}'),
            Text('$age mois • ${_getStatusLabel(child.status)}'),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: Navigation vers détails animal
        },
      ),
    );
  }

  String _getStatusLabel(AnimalStatus status) {
    switch (status) {
      case AnimalStatus.alive:
        return 'Vivant';
      case AnimalStatus.sold:
        return 'Vendu';
      case AnimalStatus.dead:
        return 'Mort';
      case AnimalStatus.slaughtered:
        return 'Abattu';
    }
  }
}
