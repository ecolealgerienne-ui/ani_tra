// screens/batch_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/batch.dart';
import '../../providers/batch_provider.dart';
import 'old_batch_create_screen.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
// import '../movement/sale_screen.dart';
// import '../movement/slaughter_screen.dart';

/// Écran de liste des lots
///
/// Affiche tous les lots (actifs et complétés)
/// Permet d'utiliser un lot pour une action (vente, abattage)
class BatchListScreen extends StatelessWidget {
  const BatchListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate(AppStrings.batches)),
      ),
      body: Consumer<BatchProvider>(
        builder: (context, batchProvider, child) {
          final batches = batchProvider.batches;

          if (batches.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: batches.length,
            itemBuilder: (context, index) {
              final batch = batches[index];
              return _BatchCard(
                batch: batch,
                onDelete: () => _deleteBatch(context, batch),
                onUse: () => _useBatch(context, batch),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BatchCreateScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context).translate(AppStrings.newBatch)),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  /// Widget : État vide
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context).translate(AppStrings.noBatchesCreated),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context).translate(AppStrings.batchDescription),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Supprimer un lot
  Future<void> _deleteBatch(BuildContext context, Batch batch) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate(AppStrings.deleteBatchTitle)),
        content: Text(
          AppLocalizations.of(context).translate(AppStrings.deleteBatchMessage)
            .replaceAll('{name}', batch.name)
            .replaceAll('{count}', '${batch.animalCount}'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context).translate(AppStrings.cancel)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text(AppLocalizations.of(context).translate(AppStrings.delete)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      final batchProvider = context.read<BatchProvider>();
      batchProvider.deleteBatch(batch.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).translate(AppStrings.batchDeleted)
                .replaceAll('{name}', batch.name),
            ),
          ),
        );
      }
    }
  }

  /// Utiliser un lot (naviguer selon l'objectif)
  void _useBatch(BuildContext context, Batch batch) {
    // TODO: Décommenter et ajuster les imports une fois les screens disponibles
    switch (batch.purpose) {
      case BatchPurpose.sale:
        // Naviguer vers vente
        // NOTE: Vérifiez le nom du paramètre dans SaleScreen
        // Il peut être: batch, batchId, selectedBatch, etc.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context).translate(AppStrings.saleOfBatch).replaceAll('{name}', batch.name)} - ${AppLocalizations.of(context).translate(AppStrings.toImplement)}'
            ),
          ),
        );
        /*
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SaleScreen(
              batch: batch,  // ou batchId: batch.id
            ),
          ),
        );
        */
        break;

      case BatchPurpose.slaughter:
        // Naviguer vers abattage
        // NOTE: Vérifiez le nom du paramètre dans SlaughterScreen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context).translate(AppStrings.slaughterOfBatch).replaceAll('{name}', batch.name)} - ${AppLocalizations.of(context).translate(AppStrings.toImplement)}'
            ),
          ),
        );
        /*
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SlaughterScreen(
              batch: batch,  // ou batchId: batch.id
            ),
          ),
        );
        */
        break;

      case BatchPurpose.treatment:
      case BatchPurpose.other:
        // TODO: Implémenter traitement groupé
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).translate(AppStrings.featureComingSoon)),
          ),
        );
        break;
    }
  }
}

/// Widget : Carte de lot
class _BatchCard extends StatelessWidget {
  final Batch batch;
  final VoidCallback onDelete;
  final VoidCallback onUse;

  const _BatchCard({
    required this.batch,
    required this.onDelete,
    required this.onUse,
  });

  @override
  Widget build(BuildContext context) {
    final purposeIcon = _getPurposeIcon(batch.purpose);
    final purposeColor = _getPurposeColor(batch.purpose);
    final purposeLabel = _getPurposeLabel(batch.purpose);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: purposeColor.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icône
                CircleAvatar(
                  backgroundColor: purposeColor.withValues(alpha: 0.1),
                  child: Icon(
                    purposeIcon,
                    color: purposeColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),

                // Infos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        batch.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.pets,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${batch.animalCount} animal${batch.animalCount > 1 ? 'aux' : ''}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: purposeColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              purposeLabel,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: purposeColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Menu
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'delete') {
                      onDelete();
                    } else if (value == 'export') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context).translate(AppStrings.exportComingSoon)),
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'export',
                      child: Row(
                        children: [
                          const Icon(Icons.file_download, size: 18),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context).translate(AppStrings.export)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete, size: 18, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context).translate(AppStrings.delete),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Statut
          if (batch.completed)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${AppLocalizations.of(context).translate(AppStrings.completedOn)} ${_formatDate(batch.usedAt!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

          // Bouton d'action (si non complété)
          if (!batch.completed)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onUse,
                      icon: Icon(_getActionIcon(batch.purpose)),
                      label: Text(_getActionLabel(batch.purpose)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: purposeColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
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

  /// Obtenir le label selon l'objectif
  String _getPurposeLabel(BatchPurpose purpose) {
    // Note: Ce widget n'a pas accès à BuildContext dans les méthodes helper
    // Les traductions sont faites directement avec les valeurs françaises
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
    // Note: Ce widget n'a pas accès à BuildContext dans les méthodes helper
    // Les traductions sont faites directement avec les valeurs françaises
    switch (purpose) {
      case BatchPurpose.sale:
        return 'Utiliser pour Vente';
      case BatchPurpose.slaughter:
        return 'Utiliser pour Abattage';
      case BatchPurpose.treatment:
        return 'Appliquer Traitement';
      case BatchPurpose.other:
        return 'Utiliser';
    }
  }

  /// Formater une date en DD/MM/YYYY
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
