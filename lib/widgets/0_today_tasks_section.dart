// lib/widgets/today_tasks_section.dart
import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Section "Aujourd'hui" sur l'écran d'accueil
///
/// Affiche les tâches et actions à effectuer aujourd'hui :
/// - Animaux à traiter (délai d'attente < 7 jours)
/// - Pesées à effectuer
/// - Lots à finaliser
/// - Autres tâches planifiées
///
/// Design : Liste compacte avec badges de couleur selon l'urgence
class TodayTasksSection extends StatelessWidget {
  final int warningCount; // Animaux avec délai 3-7 jours
  final int criticalCount; // Animaux avec délai < 3 jours
  final int pendingLotsCount; // Lots en attente de finalisation
  final VoidCallback? onTapWarnings;
  final VoidCallback? onTapCritical;
  final VoidCallback? onTapLots;

  const TodayTasksSection({
    super.key,
    required this.warningCount,
    required this.criticalCount,
    required this.pendingLotsCount,
    this.onTapWarnings,
    this.onTapCritical,
    this.onTapLots,
  });

  /// Calcule le nombre total de tâches
  int get totalTasks {
    int count = 0;
    if (warningCount > 0) count++;
    if (criticalCount > 0) count++;
    if (pendingLotsCount > 0) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    // Si aucune tâche, n'affiche rien
    if (totalTasks == 0) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header avec titre et badge de compte
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(
                Icons.today_rounded,
                color: AppConstants.primaryGreen,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Aujourd\'hui',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              // Badge avec le nombre de tâches
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppConstants.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$totalTasks',
                  style: const TextStyle(
                    color: AppConstants.primaryGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Liste des tâches
        _buildTasksList(context),
      ],
    );
  }

  /// Construit la liste des tâches
  Widget _buildTasksList(BuildContext context) {
    final tasks = <Widget>[];

    // Tâche 1 : Animaux en délai critique (< 3 jours)
    if (criticalCount > 0) {
      tasks.add(_TaskItem(
        icon: Icons.warning_rounded,
        iconColor: Colors.red.shade700,
        title: criticalCount == 1
            ? '1 animal en délai critique'
            : '$criticalCount animaux en délai critique',
        subtitle: 'Traitement à surveiller',
        urgency: TaskUrgency.critical,
        onTap: onTapCritical,
      ));
    }

    // Tâche 2 : Animaux en délai d'attente proche (3-7 jours)
    if (warningCount > 0) {
      tasks.add(_TaskItem(
        icon: Icons.info_rounded,
        iconColor: Colors.orange.shade700,
        title: warningCount == 1
            ? '1 animal à surveiller'
            : '$warningCount animaux à surveiller',
        subtitle: 'Délai d\'attente < 7 jours',
        urgency: TaskUrgency.warning,
        onTap: onTapWarnings,
      ));
    }

    // Tâche 3 : Lots en attente de finalisation
    if (pendingLotsCount > 0) {
      tasks.add(_TaskItem(
        icon: Icons.inventory_2_rounded,
        iconColor: AppConstants.tertiaryBlue,
        title: pendingLotsCount == 1
            ? '1 lot à finaliser'
            : '$pendingLotsCount lots à finaliser',
        subtitle: 'Compléter les informations',
        urgency: TaskUrgency.normal,
        onTap: onTapLots,
      ));
    }

    // Affiche les tâches avec séparateurs
    return Column(
      children: [
        for (int i = 0; i < tasks.length; i++) ...[
          tasks[i],
          if (i < tasks.length - 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                height: 1,
                color: Colors.grey.shade300,
              ),
            ),
        ],
      ],
    );
  }
}

/// Niveaux d'urgence pour les tâches
enum TaskUrgency {
  critical, // Rouge (< 3 jours)
  warning, // Orange (3-7 jours)
  normal, // Bleu (autres)
}

/// Widget pour un item de tâche
class _TaskItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final TaskUrgency urgency;
  final VoidCallback? onTap;

  const _TaskItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.urgency,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Icône avec fond coloré
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),

              // Texte
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Flèche (si cliquable)
              if (onTap != null)
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
