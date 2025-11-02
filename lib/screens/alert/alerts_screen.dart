// lib/screens/alerts_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/alert_provider.dart';
import '../../providers/animal_provider.dart';
import '../../models/alert.dart';
import '../../models/alert_type.dart';
import '../../models/alert_category.dart';
import '../animal/animal_detail_screen.dart';
import '../animal/animal_list_screen.dart';
import '../sync/sync_screen.dart';

/// Écran de détails des alertes
///
/// Affiche toutes les alertes triées par priorité :
/// - Urgentes (rouge)
/// - Importantes (orange)
/// - Routine (bleu)
///
/// Chaque alerte est cliquable pour naviguer vers l'entité concernée
class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alertes'),
        actions: [
          // Badge avec le nombre total d'alertes
          Consumer<AlertProvider>(
            builder: (context, alertProvider, child) {
              final count = alertProvider.alertCount;
              if (count == 0) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<AlertProvider>(
        builder: (context, alertProvider, child) {
          // Si aucune alerte
          if (alertProvider.alertCount == 0) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              alertProvider.refresh();
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Résumé en haut
                _buildSummaryCard(alertProvider),
                const SizedBox(height: 24),

                // Alertes URGENTES
                if (alertProvider.urgentAlerts.isNotEmpty) ...[
                  _buildSectionHeader(
                    icon: Icons.error_rounded,
                    title: 'URGENTES',
                    count: alertProvider.urgentAlertCount,
                    color: Colors.red.shade700,
                  ),
                  const SizedBox(height: 12),
                  ...alertProvider.urgentAlerts.map(
                    (alert) =>
                        _buildAlertCard(context, alert, Colors.red.shade700),
                  ),
                  const SizedBox(height: 24),
                ],

                // Alertes IMPORTANTES
                if (alertProvider.importantAlerts.isNotEmpty) ...[
                  _buildSectionHeader(
                    icon: Icons.warning_rounded,
                    title: 'IMPORTANTES',
                    count: alertProvider.importantAlertCount,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(height: 12),
                  ...alertProvider.importantAlerts.map(
                    (alert) =>
                        _buildAlertCard(context, alert, Colors.orange.shade700),
                  ),
                  const SizedBox(height: 24),
                ],

                // Alertes ROUTINE
                if (alertProvider.routineAlerts.isNotEmpty) ...[
                  _buildSectionHeader(
                    icon: Icons.info_rounded,
                    title: 'ROUTINE',
                    count: alertProvider.routineAlerts.length,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(height: 12),
                  ...alertProvider.routineAlerts.map(
                    (alert) =>
                        _buildAlertCard(context, alert, Colors.blue.shade700),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  /// Widget : État vide (aucune alerte)
  Widget _buildEmptyState() {
    return Consumer<AlertProvider>(
      builder: (context, alertProvider, child) {
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: Colors.green.shade300,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Aucune alerte ! 🎉',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tout va bien avec votre troupeau',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 32),
                // Bouton pour forcer le recalcul
                ElevatedButton.icon(
                  onPressed: () {
                    alertProvider.refresh();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Alertes recalculées'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Recalculer les alertes'),
                ),
                const SizedBox(height: 16),
                // Debug info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Debug Info:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Alertes urgentes: ${alertProvider.urgentAlertCount}',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                      Text(
                        'Alertes importantes: ${alertProvider.importantAlertCount}',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                      Text(
                        'Alertes routine: ${alertProvider.routineAlerts.length}',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                      Text(
                        'Total: ${alertProvider.alertCount}',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Widget : Carte de résumé en haut
  Widget _buildSummaryCard(AlertProvider alertProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.notifications_active, color: Colors.white, size: 28),
              SizedBox(width: 12),
              Text(
                'Vue d\'ensemble',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            alertProvider.getSummary(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatBadge(
                label: 'Urgentes',
                value: alertProvider.urgentAlertCount,
                color: Colors.red.shade300,
              ),
              _buildStatBadge(
                label: 'Importantes',
                value: alertProvider.importantAlertCount,
                color: Colors.orange.shade300,
              ),
              _buildStatBadge(
                label: 'Routine',
                value: alertProvider.routineAlerts.length,
                color: Colors.green.shade300,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Widget : Badge de statistique
  Widget _buildStatBadge({
    required String label,
    required int value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$value',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  /// Widget : Header de section
  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required int count,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// Widget : Carte d'alerte
  Widget _buildAlertCard(BuildContext context, Alert alert, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.3), width: 1),
      ),
      child: InkWell(
        onTap: () => _handleAlertTap(context, alert),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icône de catégorie
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getAlertIcon(alert.category),
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Contenu
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      alert.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (alert.actionLabel != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        alert.actionLabel!,
                        style: TextStyle(
                          fontSize: 12,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Flèche
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Obtenir l'icône selon la catégorie d'alerte
  IconData _getAlertIcon(AlertCategory category) {
    switch (category) {
      case AlertCategory.remanence:
        return Icons.medical_services_rounded;
      case AlertCategory.identification:
        return Icons.badge_rounded;
      case AlertCategory.weighing:
        return Icons.monitor_weight_rounded;
      case AlertCategory.sync:
        return Icons.cloud_sync_rounded;
      case AlertCategory.treatment:
        return Icons.healing_rounded;
      case AlertCategory.registre:
        return Icons.pending_actions_rounded;
      case AlertCategory.batch:
        return Icons.inventory_2_rounded;
      case AlertCategory.birth:
        return Icons.child_care_rounded;
      case AlertCategory.death:
        return Icons.dangerous_rounded;
      case AlertCategory.other:
        return Icons.info_rounded;
    }
  }

  /// Gérer le clic sur une alerte
  void _handleAlertTap(BuildContext context, Alert alert) {
    final animalProvider = context.read<AnimalProvider>();

    switch (alert.category) {
      case AlertCategory.remanence:
      case AlertCategory.identification:
        // Naviguer vers l'animal concerné (alerte avec entityId = animalId)
        if (alert.entityId != null) {
          final animal = animalProvider.getAnimalById(alert.entityId!);
          if (animal != null) {
            // Définir l'animal courant et naviguer vers
            animalProvider.setCurrentAnimal(animal);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AnimalDetailScreen(preloadedAnimal: animal), // APRÈS
              ),
            );
          }
        }
        break;

      case AlertCategory.treatment:
        // Traitement à renouveler → Naviguer vers l'animal concerné
        if (alert.entityId != null) {
          final animal = animalProvider.getAnimalById(alert.entityId!);
          if (animal != null) {
            animalProvider.setCurrentAnimal(animal);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AnimalDetailScreen(preloadedAnimal: animal),
              ),
            );
          } else {
            // Animal introuvable
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Animal introuvable : ${alert.entityName}'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
        break;

      case AlertCategory.weighing:
        // Alerte de pesée (multiple animaux)
        if (alert.animalIds != null && alert.animalIds!.isNotEmpty) {
          // 🐛 DEBUG
          print('🐛 animalIds from alert: ${alert.animalIds}');
          print('🐛 Count: ${alert.count}');

          // Naviguer vers AnimalListScreen avec filtre
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AnimalListScreen(
                filterAnimalIds: alert.animalIds!,
                customTitle: 'Animaux à peser (${alert.count})',
              ),
            ),
          );
        } else {
          // Pas d'IDs → Afficher message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(alert.message),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        break;

      case AlertCategory.sync:
        // Naviguer vers l'écran de synchronisation
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SyncScreen(),
          ),
        );
        break;

      case AlertCategory.registre:
        // Événements incomplets
        if (alert.entityId != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Événement incomplet : ${alert.message}'),
              action: SnackBarAction(
                label: 'Compléter',
                onPressed: () {},
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        }
        break;

      case AlertCategory.batch:
        // Lot à finaliser → Naviguer vers la liste des animaux du lot
        if (alert.animalIds != null && alert.animalIds!.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AnimalListScreen(
                filterAnimalIds: alert.animalIds!,
                customTitle: alert.entityName ?? 'Animaux du lot',
              ),
            ),
          );
        } else {
          // Pas d'IDs → Afficher message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(alert.message),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {},
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        }
        break;

      case AlertCategory.birth:
      case AlertCategory.death:
      case AlertCategory.other:
        // Afficher les détails de l'alerte
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${alert.title}\n${alert.message}'),
            duration: const Duration(seconds: 3),
          ),
        );
        break;
    }
  }
}
