// screens/campaign_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/campaign.dart';
import '../models/animal.dart';
import '../providers/campaign_provider.dart';
import '../providers/animal_provider.dart';
import '../providers/sync_provider.dart';
import 'campaign_scan_screen.dart';

/// Écran de détails d'une campagne sanitaire
///
/// Affiche :
/// - Informations complètes de la campagne
/// - Liste des animaux traités
/// - Statistiques
/// - Actions (modifier, supprimer, reprendre)
class CampaignDetailScreen extends StatelessWidget {
  final Campaign campaign;

  const CampaignDetailScreen({
    super.key,
    required this.campaign,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la Campagne'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, value),
            itemBuilder: (context) => [
              if (!campaign.completed)
                const PopupMenuItem(
                  value: 'resume',
                  child: Row(
                    children: [
                      Icon(Icons.play_arrow, size: 18),
                      SizedBox(width: 8),
                      Text('Reprendre'),
                    ],
                  ),
                ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.file_download, size: 18),
                    SizedBox(width: 8),
                    Text('Exporter'),
                  ],
                ),
              ),
              if (!campaign.completed)
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Supprimer', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Consumer2<CampaignProvider, AnimalProvider>(
        builder: (context, campaignProvider, animalProvider, child) {
          // Récupérer la campagne à jour
          final currentCampaign = campaignProvider.getCampaignById(campaign.id);

          if (currentCampaign == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Campagne introuvable',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Retour'),
                  ),
                ],
              ),
            );
          }

          // Récupérer les animaux de la campagne
          final animals =
              _getAnimalsInCampaign(currentCampaign, animalProvider);

          return ListView(
            children: [
              // Header
              _buildCampaignHeader(context, currentCampaign),

              // Statut
              _buildStatusSection(context, currentCampaign),

              // Informations produit
              _buildProductSection(context, currentCampaign),

              // Statistiques
              _buildStatisticsSection(context, currentCampaign, animals),

              // Liste des animaux
              _buildAnimalsSection(context, currentCampaign, animals),

              // Actions
              if (!currentCampaign.completed)
                _buildActionsSection(context, currentCampaign),

              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  /// Récupérer les animaux de la campagne
  List<Animal> _getAnimalsInCampaign(
      Campaign campaign, AnimalProvider provider) {
    final animals = <Animal>[];
    for (final animalId in campaign.animalIds) {
      final animal = provider.getAnimalById(animalId);
      if (animal != null) {
        animals.add(animal);
      }
    }
    return animals;
  }

  /// Widget: Header de la campagne
  Widget _buildCampaignHeader(BuildContext context, Campaign campaign) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade50,
            Colors.purple.shade50,
          ],
        ),
      ),
      child: Column(
        children: [
          // Icône
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.medical_services,
              size: 40,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 16),

          // Nom
          Text(
            campaign.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Date
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade700),
              const SizedBox(width: 6),
              Text(
                _formatDate(campaign.campaignDate),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Widget: Section statut
  Widget _buildStatusSection(BuildContext context, Campaign campaign) {
    final isCompleted = campaign.completed;
    final statusColor = isCompleted ? Colors.green : Colors.orange;
    final statusIcon = isCompleted ? Icons.check_circle : Icons.hourglass_empty;
    final statusText = isCompleted ? 'Terminée' : 'En cours';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: statusColor.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(statusIcon, color: statusColor, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Statut',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  if (isCompleted && campaign.completedAt != null)
                    Text(
                      'Le ${_formatDate(campaign.completedAt!)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget: Section produit
  Widget _buildProductSection(BuildContext context, Campaign campaign) {
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
                  Icon(Icons.medication, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Produit Utilisé',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Nom du produit
              _buildInfoRow(
                'Produit',
                campaign.productName,
                Icons.label,
              ),
              const SizedBox(height: 12),

              // Dose
              _buildInfoRow(
                'Dose par animal',
                '${campaign.dosePerAnimal.toStringAsFixed(1)} ml',
                Icons.water_drop,
              ),
              const SizedBox(height: 12),

              // Rémanence
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber,
                      color: Colors.orange.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Délai de rémanence',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Jusqu\'au ${_formatDate(campaign.withdrawalEndDate)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade900,
                            ),
                          ),
                          Text(
                            '${campaign.withdrawalDays} jours',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade800,
                            ),
                          ),
                        ],
                      ),
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

  /// Widget: Section statistiques
  Widget _buildStatisticsSection(
    BuildContext context,
    Campaign campaign,
    List<Animal> animals,
  ) {
    final maleCount = animals.where((a) => a.sex == AnimalSex.male).length;
    final femaleCount = animals.where((a) => a.sex == AnimalSex.female).length;
    final totalDose = campaign.dosePerAnimal * campaign.animalCount;

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
                    child: _buildStatCard(
                      'Total Animaux',
                      '${campaign.animalCount}',
                      Icons.pets,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Dose Totale',
                      '${totalDose.toStringAsFixed(1)} ml',
                      Icons.science,
                      Colors.purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Mâles',
                      '$maleCount',
                      Icons.male,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Femelles',
                      '$femaleCount',
                      Icons.female,
                      Colors.pink,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget: Carte de statistique
  Widget _buildStatCard(
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

  /// Widget: Section liste des animaux
  Widget _buildAnimalsSection(
    BuildContext context,
    Campaign campaign,
    List<Animal> animals,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.list, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Animaux traités (${animals.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            if (animals.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.inbox, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(
                        'Aucun animal traité',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: animals.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final animal = animals[index];
                  return _buildAnimalTile(animal);
                },
              ),
          ],
        ),
      ),
    );
  }

  /// Widget: Tuile d'animal
  Widget _buildAnimalTile(Animal animal) {
    final sexColor = animal.sex == AnimalSex.male ? Colors.blue : Colors.pink;
    final sexIcon = animal.sex == AnimalSex.male ? Icons.male : Icons.female;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: sexColor.withOpacity(0.1),
        child: Icon(sexIcon, color: sexColor, size: 20),
      ),
      title: Text(
        animal.officialNumber ?? animal.eid,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        animal.eid,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      trailing:
          Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
    );
  }

  /// Widget: Section actions
  Widget _buildActionsSection(BuildContext context, Campaign campaign) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () => _resumeCampaign(context, campaign),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Reprendre la Campagne'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _completeCampaign(context, campaign),
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Terminer la Campagne'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Widget: Ligne d'info
  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== Actions ====================

  /// Gérer les actions du menu
  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'resume':
        _resumeCampaign(context, campaign);
        break;
      case 'export':
        _exportCampaign(context, campaign);
        break;
      case 'delete':
        _deleteCampaign(context, campaign);
        break;
    }
  }

  /// Reprendre la campagne
  void _resumeCampaign(BuildContext context, Campaign campaign) {
    final campaignProvider = context.read<CampaignProvider>();
    campaignProvider.setActiveCampaign(campaign);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CampaignScanScreen(),
      ),
    );
  }

  /// Terminer la campagne
  Future<void> _completeCampaign(
      BuildContext context, Campaign campaign) async {
    if (campaign.animalCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Aucun animal traité dans cette campagne'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final shouldComplete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terminer la campagne ?'),
        content: Text(
          'La campagne "${campaign.name}" sera marquée comme terminée.\n'
          '${campaign.animalCount} animaux ont été traités.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.green),
            child: const Text('Terminer'),
          ),
        ],
      ),
    );

    if (shouldComplete == true && context.mounted) {
      final campaignProvider = context.read<CampaignProvider>();
      final animalProvider = context.read<AnimalProvider>();
      final syncProvider = context.read<SyncProvider>();

      // Générer les traitements
      final treatments =
          campaignProvider.generateTreatmentsFromCampaign(campaign);
      for (final treatment in treatments) {
        animalProvider.addTreatment(treatment);
      }

      // Compléter la campagne
      campaignProvider.completeCampaign(campaign.id);
      syncProvider.addPendingData(treatments.length + 1);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '✅ Campagne terminée: ${campaign.animalCount} animaux traités'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      }
    }
  }

  /// Exporter la campagne
  void _exportCampaign(BuildContext context, Campaign campaign) {
    // TODO: Implémenter export (CSV, PDF, etc.)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export à venir (CSV, PDF)'),
      ),
    );
  }

  /// Supprimer la campagne
  Future<void> _deleteCampaign(BuildContext context, Campaign campaign) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la campagne ?'),
        content: Text(
          'Voulez-vous vraiment supprimer la campagne "${campaign.name}" ?\n'
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (shouldDelete == true && context.mounted) {
      final campaignProvider = context.read<CampaignProvider>();
      campaignProvider.deleteCampaign(campaign.id);

      if (context.mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Campagne "${campaign.name}" supprimée'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ==================== Helpers ====================

  /// Formater une date
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
