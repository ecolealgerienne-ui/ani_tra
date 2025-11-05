// screens/campaign_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/campaign.dart';
import '../../models/animal.dart';
import '../../providers/campaign_provider.dart';
import '../../providers/animal_provider.dart';
import '../../providers/sync_provider.dart';
import '0_campaign_scan_screen.dart';

/// Écran de détails d'une campagne sanitaire
///
/// Affiche :
/// - Informations complètes de la campagne
/// - Liste des animaux traités
/// - Statistiques
/// - Actions (modifier, supprimer, reprendre, ajouter/retirer animaux)
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
          // Bouton Ajouter un animal
          if (!campaign.completed)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Ajouter un animal',
              onPressed: () => _showAddAnimalDialog(context),
            ),
          // Bouton Retirer des animaux
          if (!campaign.completed && campaign.animalCount > 0)
            IconButton(
              icon: const Icon(Icons.remove),
              tooltip: 'Retirer des animaux',
              onPressed: () => _showRemoveAnimalDialog(context),
            ),
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
          color: statusColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: statusColor.withValues(alpha: 0.3)),
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
                  if (isCompleted && campaign.updatedAt != null)
                    Text(
                      'Le ${_formatDate(campaign.updatedAt!)}',
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
              Row(
                children: [
                  Icon(Icons.medication, color: Colors.blue.shade700),
                  const SizedBox(width: 12),
                  const Text(
                    'Produit utilisé',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoRow('Nom', campaign.productName, Icons.label),
              const SizedBox(height: 12),
              _buildInfoRow('Date de traitement',
                  _formatDate(campaign.campaignDate), Icons.calendar_today),
              const SizedBox(height: 12),
              _buildInfoRow(
                'Fin de rémanence',
                _formatDate(campaign.withdrawalEndDate),
                Icons.warning_amber,
              ),
              if (campaign.veterinarianName != null) ...[
                const SizedBox(height: 12),
                _buildInfoRow('Vétérinaire', campaign.veterinarianName!,
                    Icons.medical_services),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Widget: Section statistiques
  Widget _buildStatisticsSection(
      BuildContext context, Campaign campaign, List<Animal> animals) {
    final maleCount = animals.where((a) => a.sex == AnimalSex.male).length;
    final femaleCount = animals.where((a) => a.sex == AnimalSex.female).length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.bar_chart, color: Colors.purple.shade700),
                  const SizedBox(width: 12),
                  const Text(
                    'Statistiques',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Total',
                      value: campaign.animalCount.toString(),
                      icon: Icons.pets,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Mâles',
                      value: maleCount.toString(),
                      icon: Icons.male,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Femelles',
                      value: femaleCount.toString(),
                      icon: Icons.female,
                      color: Colors.pink,
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

  /// Widget: Section animaux
  Widget _buildAnimalsSection(
      BuildContext context, Campaign campaign, List<Animal> animals) {
    if (animals.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(Icons.pets, size: 48, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'Aucun animal traité',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),
                if (!campaign.completed)
                  ElevatedButton.icon(
                    onPressed: () => _showAddAnimalDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter un animal'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.pets, color: Colors.orange.shade700),
                  const SizedBox(width: 12),
                  Text(
                    'Animaux traités (${campaign.animalCount})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: animals.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return _buildAnimalTile(context, campaign, animals[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Widget: Tuile d'animal avec bouton supprimer
  Widget _buildAnimalTile(
      BuildContext context, Campaign campaign, Animal animal) {
    final sexColor = animal.sex == AnimalSex.male ? Colors.blue : Colors.pink;
    final sexIcon = animal.sex == AnimalSex.male ? Icons.male : Icons.female;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: sexColor.withValues(alpha: 0.1),
        child: Icon(sexIcon, color: sexColor, size: 20),
      ),
      title: Text(
        animal.displayName,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        animal.displayName,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      trailing: campaign.completed
          ? Icon(Icons.check_circle, color: Colors.green.shade600, size: 20)
          : IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
              tooltip: 'Retirer cet animal',
              onPressed: () => _confirmRemoveAnimal(context, campaign, animal),
            ),
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

  /// Afficher le dialogue d'ajout d'animal
  void _showAddAnimalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _AddAnimalDialog(campaign: campaign),
    );
  }

  /// Afficher le dialogue de retrait d'animal
  void _showRemoveAnimalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _RemoveAnimalDialog(campaign: campaign),
    );
  }

  /// Confirmer le retrait d'un animal (bouton direct)
  Future<void> _confirmRemoveAnimal(
      BuildContext context, Campaign campaign, Animal animal) async {
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Retirer cet animal ?'),
        content: Text(
          'Voulez-vous retirer "${animal.displayName}" de la campagne ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Retirer'),
          ),
        ],
      ),
    );

    if (shouldRemove == true && context.mounted) {
      final campaignProvider = context.read<CampaignProvider>();
      campaignProvider.setActiveCampaign(campaign);

      final success =
          campaignProvider.removeAnimalFromActiveCampaign(animal.id);

      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ Animal retiré: ${animal.displayName}',
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

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
      final treatments = campaignProvider.expandCampaignToTreatments(campaign);
      for (final treatment in treatments) {
        animalProvider.addTreatment(treatment);
      }

      // Compléter la campagne
      campaignProvider.completeActiveCampaign();
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

// ==================== Widgets Utilitaires ====================

/// Widget de carte statistique
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
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
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== DIALOGUES ====================

/// Dialogue pour ajouter un animal à la campagne
class _AddAnimalDialog extends StatefulWidget {
  final Campaign campaign;

  const _AddAnimalDialog({required this.campaign});

  @override
  State<_AddAnimalDialog> createState() => _AddAnimalDialogState();
}

class _AddAnimalDialogState extends State<_AddAnimalDialog> {
  final _eidController = TextEditingController();
  Animal? _scannedAnimal;
  bool _isScanning = false;
  String? _errorMessage;

  @override
  void dispose() {
    _eidController.dispose();
    super.dispose();
  }

  /// Simuler le scan d'un animal
  void _simulateScan() {
    setState(() {
      _isScanning = true;
      _errorMessage = null;
      _scannedAnimal = null;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      final animalProvider = context.read<AnimalProvider>();
      final campaignProvider = context.read<CampaignProvider>();

      // Chercher un animal vivant qui n'est pas déjà dans la campagne
      final availableAnimals = animalProvider.animals
          .where((a) =>
              a.status == AnimalStatus.alive &&
              !widget.campaign.animalIds.contains(a.id))
          .toList();

      if (availableAnimals.isEmpty) {
        setState(() {
          _isScanning = false;
          _errorMessage =
              'Aucun animal disponible (tous déjà dans la campagne ou pas d\'animaux vivants)';
        });
        return;
      }

      // Prendre un animal aléatoirement pour simuler
      final mockAnimal = (availableAnimals..shuffle()).first;

      setState(() {
        _isScanning = false;
        _scannedAnimal = mockAnimal;
        _eidController.text = mockAnimal.displayName;
      });
    });
  }

  /// Rechercher un animal par EID saisi manuellement
  void _searchByEID(String eid) {
    if (eid.trim().isEmpty) return;

    final animalProvider = context.read<AnimalProvider>();
    final animal = animalProvider.animals.firstWhere(
      (a) => (a.currentEid?.toLowerCase() ?? '') == eid.trim().toLowerCase(),
      orElse: () => animalProvider.animals.firstWhere(
        (a) =>
            (a.officialNumber?.toLowerCase() ?? '') == eid.trim().toLowerCase(),
        orElse: () => throw Exception('Animal non trouvé'),
      ),
    );

    // Vérifier si déjà dans la campagne
    if (widget.campaign.animalIds.contains(animal.id)) {
      setState(() {
        _errorMessage = 'Cet animal est déjà dans la campagne';
        _scannedAnimal = null;
      });
      return;
    }

    setState(() {
      _scannedAnimal = animal;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.add_circle, color: Colors.green),
          SizedBox(width: 8),
          Text('Ajouter un animal'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Champ EID
            TextField(
              controller: _eidController,
              decoration: const InputDecoration(
                labelText: 'EID de l\'animal',
                hintText: 'FRxxxxxxxxxxxx',
                prefixIcon: Icon(Icons.tag),
                border: OutlineInputBorder(),
              ),
              enabled: !_isScanning,
              onSubmitted: _searchByEID,
            ),

            const SizedBox(height: 16),

            // Boutons Scanner et Rechercher
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isScanning ? null : _simulateScan,
                    icon: _isScanning
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.qr_code_scanner, size: 20),
                    label: Text(_isScanning ? 'Scan...' : 'Scanner'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isScanning
                        ? null
                        : () => _searchByEID(_eidController.text),
                    icon: const Icon(Icons.search, size: 20),
                    label: const Text('Rechercher'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

            // Message d'erreur
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning,
                        color: Colors.orange.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.orange.shade900,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Informations de l'animal scanné
            if (_scannedAnimal != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: Colors.green.shade700, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Animal détecté',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'EID: ${_scannedAnimal!.eid}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    if (_scannedAnimal!.officialNumber != null)
                      Text(
                        'N° officiel: ${_scannedAnimal!.officialNumber}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    Text(
                      'Sexe: ${_scannedAnimal!.sex == AnimalSex.male ? "Mâle" : "Femelle"}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    Text(
                      'Âge: ${_scannedAnimal!.ageInMonths} mois',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _scannedAnimal == null
              ? null
              : () {
                  final campaignProvider = context.read<CampaignProvider>();
                  campaignProvider.setActiveCampaign(widget.campaign);

                  final success = campaignProvider
                      .addAnimalToActiveCampaign(_scannedAnimal!.id);

                  Navigator.pop(context);

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '✅ Animal ajouté: ${_scannedAnimal!.officialNumber ?? _scannedAnimal!.eid}',
                        ),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: const Text('Ajouter'),
        ),
      ],
    );
  }
}

/// Dialogue pour retirer un animal de la campagne
class _RemoveAnimalDialog extends StatefulWidget {
  final Campaign campaign;

  const _RemoveAnimalDialog({required this.campaign});

  @override
  State<_RemoveAnimalDialog> createState() => _RemoveAnimalDialogState();
}

class _RemoveAnimalDialogState extends State<_RemoveAnimalDialog> {
  final _eidController = TextEditingController();
  Animal? _scannedAnimal;
  bool _isScanning = false;
  String? _errorMessage;

  @override
  void dispose() {
    _eidController.dispose();
    super.dispose();
  }

  /// Simuler le scan d'un animal à retirer
  void _simulateScan() {
    setState(() {
      _isScanning = true;
      _errorMessage = null;
      _scannedAnimal = null;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      final animalProvider = context.read<AnimalProvider>();

      // Chercher un animal qui EST dans la campagne
      final campaignAnimals = animalProvider.animals
          .where((a) => widget.campaign.animalIds.contains(a.id))
          .toList();

      if (campaignAnimals.isEmpty) {
        setState(() {
          _isScanning = false;
          _errorMessage = 'Aucun animal dans la campagne';
        });
        return;
      }

      // Prendre un animal aléatoirement pour simuler
      final mockAnimal = (campaignAnimals..shuffle()).first;

      setState(() {
        _isScanning = false;
        _scannedAnimal = mockAnimal;
        _eidController.text = mockAnimal.displayName;
      });
    });
  }

  /// Rechercher un animal par EID saisi manuellement
  void _searchByEID(String eid) {
    if (eid.trim().isEmpty) return;

    final animalProvider = context.read<AnimalProvider>();

    try {
      final animal = animalProvider.animals.firstWhere(
        (a) => (a.currentEid?.toLowerCase() ?? '') == eid.trim().toLowerCase(),
        orElse: () => animalProvider.animals.firstWhere(
          (a) =>
              (a.officialNumber?.toLowerCase() ?? '') ==
              eid.trim().toLowerCase(),
          orElse: () => throw Exception('Animal non trouvé'),
        ),
      );

      // Vérifier si dans la campagne
      if (!widget.campaign.animalIds.contains(animal.id)) {
        setState(() {
          _errorMessage = 'Cet animal n\'est pas dans la campagne';
          _scannedAnimal = null;
        });
        return;
      }

      setState(() {
        _scannedAnimal = animal;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Animal non trouvé';
        _scannedAnimal = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.remove_circle, color: Colors.red),
          SizedBox(width: 8),
          Text('Retirer un animal'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Scannez ou saisissez l\'EID de l\'animal à retirer de la campagne.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),

            const SizedBox(height: 16),

            // Champ EID
            TextField(
              controller: _eidController,
              decoration: const InputDecoration(
                labelText: 'EID de l\'animal',
                hintText: 'FRxxxxxxxxxxxx',
                prefixIcon: Icon(Icons.tag),
                border: OutlineInputBorder(),
              ),
              enabled: !_isScanning,
              onSubmitted: _searchByEID,
            ),

            const SizedBox(height: 16),

            // Boutons Scanner et Rechercher
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isScanning ? null : _simulateScan,
                    icon: _isScanning
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.qr_code_scanner, size: 20),
                    label: Text(_isScanning ? 'Scan...' : 'Scanner'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isScanning
                        ? null
                        : () => _searchByEID(_eidController.text),
                    icon: const Icon(Icons.search, size: 20),
                    label: const Text('Rechercher'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

            // Message d'erreur
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.red.shade900,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Informations de l'animal scanné
            if (_scannedAnimal != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning,
                            color: Colors.orange.shade700, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Animal à retirer',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'EID: ${_scannedAnimal!.eid}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    if (_scannedAnimal!.officialNumber != null)
                      Text(
                        'N° officiel: ${_scannedAnimal!.officialNumber}',
                        style: const TextStyle(fontSize: 13),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _scannedAnimal == null
              ? null
              : () {
                  final campaignProvider = context.read<CampaignProvider>();
                  campaignProvider.setActiveCampaign(widget.campaign);

                  final success = campaignProvider
                      .removeAnimalFromActiveCampaign(_scannedAnimal!.id);

                  Navigator.pop(context);

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '✅ Animal retiré: ${_scannedAnimal!.officialNumber ?? _scannedAnimal!.eid}',
                        ),
                        backgroundColor: Colors.orange,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Retirer'),
        ),
      ],
    );
  }
}
