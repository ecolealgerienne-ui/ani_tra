// lib/screens/animal/mother_history_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/animal.dart';
import '../../providers/animal_provider.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
//import '../../utils/constants.dart';

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
        title: Text(AppLocalizations.of(context)
            .translate(AppStrings.reproductionHistory)),
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
                '${AppLocalizations.of(context).translate(AppStrings.descendants)} (${offspring.length})',
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 8),

              if (offspring.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(Icons.info_outline,
                              size: 48, color: Colors.grey),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)
                                .translate(AppStrings.noDescendants),
                            style: const TextStyle(color: Colors.grey),
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
                  '${AppLocalizations.of(context).translate(AppStrings.mother)}: ${mother.displayName}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('${AppLocalizations.of(context).translate(AppStrings.age)}: ${mother.ageInMonths} ${AppLocalizations.of(context).translate(AppStrings.months)} (${mother.ageInDays} ${AppLocalizations.of(context).translate(AppStrings.days)})'),
            if (mother.breedId != null) Text('${AppLocalizations.of(context).translate(AppStrings.breed)}: ${mother.breedId}'),
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
              AppLocalizations.of(context)
                  .translate(AppStrings.reproductionStats),
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
                    AppLocalizations.of(context)
                        .translate(AppStrings.totalBirths),
                    stats.totalBirths.toString(),
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    AppLocalizations.of(context)
                        .translate(AppStrings.aliveFemales),
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
                    AppLocalizations.of(context)
                        .translate(AppStrings.survivalRate),
                    stats.formattedSurvivalRate,
                    Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    AppLocalizations.of(context)
                        .translate(AppStrings.avgInterval),
                    stats.formattedInterval,
                    Colors.purple,
                  ),
                ),
              ],
            ),
            if (stats.lastBirthDate != null) ...[
              const SizedBox(height: 12),
              Text(
                '${AppLocalizations.of(context).translate(AppStrings.lastBirth)}: ${DateFormat('dd/MM/yyyy').format(stats.lastBirthDate!)}',
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
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color.withValues(alpha: 0.8),
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
          backgroundColor: statusColor.withValues(alpha: 0.2),
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
            Text('${AppLocalizations.of(context).translate(AppStrings.bornOn)} ${DateFormat('dd/MM/yyyy').format(child.birthDate)}'),
            Text('$age ${AppLocalizations.of(context).translate(AppStrings.months)} • ${_getStatusLabel(context, child.status)}'),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: Navigation vers détails animal
        },
      ),
    );
  }

  String _getStatusLabel(BuildContext context, AnimalStatus status) {
    switch (status) {
      case AnimalStatus.draft:
        return AppLocalizations.of(context).translate(AppStrings.draftStatus);
      case AnimalStatus.alive:
        return AppLocalizations.of(context).translate(AppStrings.alive);
      case AnimalStatus.sold:
        return AppLocalizations.of(context).translate(AppStrings.sold);
      case AnimalStatus.dead:
        return AppLocalizations.of(context).translate(AppStrings.dead);
      case AnimalStatus.slaughtered:
        return AppLocalizations.of(context).translate(AppStrings.slaughtered);
    }
  }
}
