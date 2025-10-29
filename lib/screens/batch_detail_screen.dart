// screens/batch_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/batch.dart';
import '../models/animal.dart';
import '../providers/batch_provider.dart';
import '../providers/animal_provider.dart';
import '../providers/sync_provider.dart';
import 'batch_scan_screen.dart';
import 'sale_screen.dart';
import 'slaughter_screen.dart';

/// Écran de détails d'un lot
///
/// Affiche toutes les informations d'un lot et permet de :
/// - Voir la liste des animaux
/// - Ajouter/retirer des animaux
/// - Compléter le lot
/// - Supprimer le lot
class BatchDetailScreen extends StatelessWidget {
  final Batch batch;

  const BatchDetailScreen({
    super.key,
    required this.batch,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Lot'),
        actions: [
          // Menu d'actions
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, value),
            itemBuilder: (context) => [
              if (!batch.completed)
                const PopupMenuItem(
                  value: 'add_animals',
                  child: Row(
                    children: [
                      Icon(Icons.add_circle, size: 18),
                      SizedBox(width: 8),
                      Text('Ajouter des animaux'),
                    ],
                  ),
                ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.file_download, size: 18),
                    SizedBox(width: 8),
                    Text('Exporter la liste'),
                  ],
                ),
              ),
              if (!batch.completed)
                const PopupMenuItem(
                  value: 'complete',
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, size: 18, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Compléter le lot',
                          style: TextStyle(color: Colors.green)),
                    ],
                  ),
                ),
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
      body: Consumer2<BatchProvider, AnimalProvider>(
        builder: (context, batchProvider, animalProvider, child) {
          // Récupérer le lot à jour
          final currentBatch = batchProvider.getBatchById(batch.id);

          if (currentBatch == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Lot introuvable',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
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

          // Récupérer les animaux du lot
          final animals = _getAnimalsInBatch(currentBatch, animalProvider);

          return ListView(
            children: [
              // Header du lot
              _buildBatchHeader(context, currentBatch, animals),

              // Statistiques
              _buildStatisticsSection(context, currentBatch, animals),

              // Liste des animaux
              _buildAnimalsSection(
                  context, currentBatch, animals, animalProvider),

              // Actions principales (si non complété)
              if (!currentBatch.completed)
                _buildActionsSection(context, currentBatch),

              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  /// Récupérer les animaux du lot
  List<Animal> _getAnimalsInBatch(Batch batch, AnimalProvider animalProvider) {
    final animals = <Animal>[];
    for (final animalId in batch.animalIds) {
      final animal = animalProvider.getAnimalById(animalId);
      if (animal != null) {
        animals.add(animal);
      }
    }
    return animals;
  }

  /// Header du lot
  Widget _buildBatchHeader(
      BuildContext context, Batch batch, List<Animal> animals) {
    final purposeColor = _getPurposeColor(batch.purpose);
    final purposeIcon = _getPurposeIcon(batch.purpose);
    final purposeLabel = _getPurposeLabel(batch.purpose);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            purposeColor.withOpacity(0.1),
            purposeColor.withOpacity(0.05),
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
              color: purposeColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              purposeIcon,
              size: 40,
              color: purposeColor,
            ),
          ),
          const SizedBox(height: 16),

          // Nom du lot
          Text(
            batch.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Badge objectif
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: purposeColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(purposeIcon, size: 16, color: purposeColor),
                const SizedBox(width: 6),
                Text(
                  purposeLabel,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: purposeColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Statut
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                batch.completed ? Icons.check_circle : Icons.hourglass_empty,
                size: 18,
                color: batch.completed ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 6),
              Text(
                batch.completed ? 'Complété' : 'En cours',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: batch.completed ? Colors.green : Colors.orange,
                ),
              ),
            ],
          ),

          // Dates
          const SizedBox(height: 12),
          Text(
            'Créé le ${_formatDate(batch.createdAt)}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          if (batch.completed && batch.usedAt != null)
            Text(
              'Complété le ${_formatDate(batch.usedAt!)}',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
        ],
      ),
    );
  }

  /// Section statistiques
  Widget _buildStatisticsSection(
    BuildContext context,
    Batch batch,
    List<Animal> animals,
  ) {
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
              const Row(
                children: [
                  Icon(Icons.analytics, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Statistiques',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),

              // Nombre total
              _buildStatRow(
                icon: Icons.pets,
                label: 'Total',
                value:
                    '${animals.length} animal${animals.length > 1 ? 'aux' : ''}',
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 12),

              // Mâles
              _buildStatRow(
                icon: Icons.male,
                label: 'Mâles',
                value: '$maleCount',
                color: Colors.blue,
              ),
              const SizedBox(height: 12),

              // Femelles
              _buildStatRow(
                icon: Icons.female,
                label: 'Femelles',
                value: '$femaleCount',
                color: Colors.pink,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Ligne de statistique
  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: color),
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
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  /// Section liste des animaux
  Widget _buildAnimalsSection(
    BuildContext context,
    Batch batch,
    List<Animal> animals,
    AnimalProvider animalProvider,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.list, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Animaux du lot (${animals.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Liste
            if (animals.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.inbox, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(
                        'Aucun animal dans ce lot',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      if (!batch.completed) ...[
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => _addAnimals(context, batch),
                          icon: const Icon(Icons.add),
                          label: const Text('Ajouter des animaux'),
                        ),
                      ],
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
                  return _buildAnimalTile(
                      context, batch, animal, animalProvider);
                },
              ),
          ],
        ),
      ),
    );
  }

  /// Tuile d'animal
  Widget _buildAnimalTile(
    BuildContext context,
    Batch batch,
    Animal animal,
    AnimalProvider animalProvider,
  ) {
    final sexColor = animal.sex == AnimalSex.male ? Colors.blue : Colors.pink;
    final sexIcon = animal.sex == AnimalSex.male ? Icons.male : Icons.female;

    // Vérifier rémanence active
    final treatments = animalProvider.getAnimalTreatments(animal.id);
    final hasActiveWithdrawal = treatments.any((t) => t.isWithdrawalActive);

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
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            animal.eid,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          if (hasActiveWithdrawal)
            Row(
              children: [
                Icon(
                  Icons.warning,
                  size: 14,
                  color: Colors.red.shade700,
                ),
                const SizedBox(width: 4),
                Text(
                  'Rémanence active',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
        ],
      ),
      trailing: !batch.completed
          ? IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: () => _removeAnimal(context, batch, animal),
              tooltip: 'Retirer du lot',
            )
          : null,
      onTap: () {
        // TODO: Naviguer vers les détails de l'animal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Détails: ${animal.officialNumber ?? animal.eid}'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }

  /// Section actions principales
  Widget _buildActionsSection(BuildContext context, Batch batch) {
    final purposeColor = _getPurposeColor(batch.purpose);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Bouton principal selon l'objectif
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () => _useBatch(context, batch),
              icon: Icon(_getActionIcon(batch.purpose)),
              label: Text(_getActionLabel(batch.purpose)),
              style: ElevatedButton.styleFrom(
                backgroundColor: purposeColor,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Bouton compléter (marquer comme utilisé)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _completeBatch(context, batch),
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Marquer comme complété'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Actions ====================

  /// Gérer les actions du menu
  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'add_animals':
        _addAnimals(context, batch);
        break;
      case 'export':
        _exportBatch(context, batch);
        break;
      case 'complete':
        _completeBatch(context, batch);
        break;
      case 'delete':
        _deleteBatch(context, batch);
        break;
    }
  }

  /// Ajouter des animaux au lot
  void _addAnimals(BuildContext context, Batch batch) {
    final batchProvider = context.read<BatchProvider>();

    // Réactiver le lot
    batchProvider.setActiveBatch(batch.id);

    // Naviguer vers l'écran de scan
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BatchScanScreen(batch: batch),
      ),
    );
  }

  /// Retirer un animal du lot
  Future<void> _removeAnimal(
      BuildContext context, Batch batch, Animal animal) async {
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Retirer cet animal ?'),
        content: Text(
          'Voulez-vous retirer ${animal.officialNumber ?? animal.eid} du lot ?',
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
      final batchProvider = context.read<BatchProvider>();
      final success = batchProvider.removeAnimalFromBatch(animal.id);

      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${animal.officialNumber ?? animal.eid} retiré du lot'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  /// Utiliser le lot (naviguer selon l'objectif)
  void _useBatch(BuildContext context, Batch batch) {
    if (batch.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Le lot est vide'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    switch (batch.purpose) {
      case BatchPurpose.sale:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SaleScreen(),
          ),
        );
        break;

      case BatchPurpose.slaughter:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SlaughterScreen(),
          ),
        );
        break;

      case BatchPurpose.treatment:
      case BatchPurpose.other:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fonctionnalité à venir'),
          ),
        );
        break;
    }
  }

  /// Compléter le lot
  Future<void> _completeBatch(BuildContext context, Batch batch) async {
    if (batch.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Le lot est vide'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final shouldComplete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Compléter le lot ?'),
        content: Text(
          'Le lot "${batch.name}" sera marqué comme complété. '
          'Vous ne pourrez plus y ajouter d\'animaux.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.green),
            child: const Text('Compléter'),
          ),
        ],
      ),
    );

    if (shouldComplete == true && context.mounted) {
      final batchProvider = context.read<BatchProvider>();
      final syncProvider = context.read<SyncProvider>();

      batchProvider.completeBatch(batch.id);
      syncProvider.incrementPendingData();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Lot "${batch.name}" complété'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  /// Exporter le lot
  void _exportBatch(BuildContext context, Batch batch) {
    // TODO: Implémenter export (CSV, PDF, etc.)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export à venir (CSV, PDF)'),
      ),
    );
  }

  /// Supprimer le lot
  Future<void> _deleteBatch(BuildContext context, Batch batch) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le lot ?'),
        content: Text(
          'Voulez-vous vraiment supprimer le lot "${batch.name}" ?\n'
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
      final batchProvider = context.read<BatchProvider>();
      batchProvider.deleteBatch(batch.id);

      if (context.mounted) {
        Navigator.pop(context); // Retour à la liste

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lot "${batch.name}" supprimé'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ==================== Helpers ====================

  /// Obtenir la couleur selon l'objectif
  Color _getPurposeColor(BatchPurpose purpose) {
    switch (purpose) {
      case BatchPurpose.sale:
        return Colors.green;
      case BatchPurpose.slaughter:
        return Colors.red;
      case BatchPurpose.treatment:
        return Colors.blue;
      case BatchPurpose.other:
        return Colors.grey;
    }
  }

  /// Obtenir l'icône selon l'objectif
  IconData _getPurposeIcon(BatchPurpose purpose) {
    switch (purpose) {
      case BatchPurpose.sale:
        return Icons.sell;
      case BatchPurpose.slaughter:
        return Icons.factory;
      case BatchPurpose.treatment:
        return Icons.medical_services;
      case BatchPurpose.other:
        return Icons.category;
    }
  }

  /// Obtenir le label selon l'objectif
  String _getPurposeLabel(BatchPurpose purpose) {
    switch (purpose) {
      case BatchPurpose.sale:
        return 'Vente';
      case BatchPurpose.slaughter:
        return 'Abattage';
      case BatchPurpose.treatment:
        return 'Traitement';
      case BatchPurpose.other:
        return 'Autre';
    }
  }

  /// Obtenir l'icône d'action selon l'objectif
  IconData _getActionIcon(BatchPurpose purpose) {
    switch (purpose) {
      case BatchPurpose.sale:
        return Icons.sell;
      case BatchPurpose.slaughter:
        return Icons.factory;
      case BatchPurpose.treatment:
        return Icons.medical_services;
      case BatchPurpose.other:
        return Icons.play_arrow;
    }
  }

  /// Obtenir le label d'action selon l'objectif
  String _getActionLabel(BatchPurpose purpose) {
    switch (purpose) {
      case BatchPurpose.sale:
        return 'Utiliser pour Vente';
      case BatchPurpose.slaughter:
        return 'Utiliser pour Abattage';
      case BatchPurpose.treatment:
        return 'Appliquer Traitement';
      case BatchPurpose.other:
        return 'Utiliser ce lot';
    }
  }

  /// Formater une date
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
