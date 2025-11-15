// screens/batch_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/batch.dart';
import '../../providers/batch_provider.dart';
import 'lot_create_screen.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';
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
            padding: const EdgeInsets.all(AppConstants.batchListPadding),
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
        label:
            Text(AppLocalizations.of(context).translate(AppStrings.newBatch)),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  /// Widget : État vide
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.batchListEmptyPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory,
              size: AppConstants.batchListEmptyIconSize,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: AppConstants.batchListEmptySpacing),
            Text(
              AppLocalizations.of(context)
                  .translate(AppStrings.noBatchesCreated),
              style: TextStyle(
                fontSize: AppConstants.batchListEmptyTitleSize,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: AppConstants.batchListEmptySpacingSmall),
            Text(
              AppLocalizations.of(context)
                  .translate(AppStrings.batchDescription),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppConstants.batchListEmptyTextSize,
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
        title: Text(AppLocalizations.of(context)
            .translate(AppStrings.deleteBatchTitle)),
        content: Text(
          AppLocalizations.of(context)
              .translate(AppStrings.deleteBatchMessage)
              .replaceAll('{name}', batch.name)
              .replaceAll('{count}', '${batch.animalCount}'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child:
                Text(AppLocalizations.of(context).translate(AppStrings.cancel)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppConstants.statusDanger,
            ),
            child:
                Text(AppLocalizations.of(context).translate(AppStrings.delete)),
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
              AppLocalizations.of(context)
                  .translate(AppStrings.batchDeleted)
                  .replaceAll('{name}', batch.name),
            ),
          ),
        );
      }
    }
  }

  /// Utiliser un lot (naviguer selon l'objectif)
  void _useBatch(BuildContext context, Batch batch) {
    switch (batch.purpose) {
      case BatchPurpose.sale:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${AppLocalizations.of(context).translate(AppStrings.saleOfBatch).replaceAll('{name}', batch.name)} - ${AppLocalizations.of(context).translate(AppStrings.toImplement)}'),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${AppLocalizations.of(context).translate(AppStrings.slaughterOfBatch).replaceAll('{name}', batch.name)} - ${AppLocalizations.of(context).translate(AppStrings.toImplement)}'),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)
                .translate(AppStrings.featureComingSoon)),
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
    final purposeLabel = _getPurposeLabel(context, batch.purpose);

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.batchCardMargin),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.batchCardRadius),
        border: Border.all(
            color: purposeColor.withValues(
                alpha: AppConstants.batchCardBorderAlpha)),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: AppConstants.batchCardShadowAlpha),
            blurRadius: AppConstants.batchCardShadowBlur,
            offset: const Offset(0, AppConstants.batchCardShadowOffset),
          ),
        ],
      ),
      child: Column(
        children: [
          // En-tête
          Padding(
            padding: const EdgeInsets.all(AppConstants.batchCardPadding),
            child: Row(
              children: [
                // Icône
                Container(
                  width: AppConstants.batchCardIconSize,
                  height: AppConstants.batchCardIconSize,
                  decoration: BoxDecoration(
                    color: purposeColor.withValues(
                        alpha: AppConstants.batchCardIconAlpha),
                    borderRadius:
                        BorderRadius.circular(AppConstants.batchCardIconRadius),
                  ),
                  child: Icon(
                    purposeIcon,
                    color: purposeColor,
                    size: AppConstants.batchCardIconInnerSize,
                  ),
                ),

                const SizedBox(width: AppConstants.batchCardSpacing),

                // Infos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        batch.name,
                        style: const TextStyle(
                          fontSize: AppConstants.batchCardNameSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppConstants.batchCardSpacingTiny),
                      Row(
                        children: [
                          Icon(
                            Icons.pets,
                            size: AppConstants.batchCardPetIconSize,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(
                              width: AppConstants.batchCardSpacingTiny),
                          Text(
                            AppLocalizations.of(context)
                                .translate(AppStrings.animalCount)
                                .replaceAll('{count}', '${batch.animalCount}')
                                .replaceAll('{plural}',
                                    batch.animalCount > 1 ? 'aux' : ''),
                            style: TextStyle(
                              fontSize: AppConstants.batchCardInfoSize,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(
                              width: AppConstants.batchCardSpacingSmall),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.batchCardBadgePaddingH,
                              vertical: AppConstants.batchCardBadgePaddingV,
                            ),
                            decoration: BoxDecoration(
                              color: purposeColor.withValues(
                                  alpha: AppConstants.batchCardBadgeAlpha),
                              borderRadius: BorderRadius.circular(
                                  AppConstants.batchCardBadgeRadius),
                            ),
                            child: Text(
                              purposeLabel,
                              style: TextStyle(
                                fontSize: AppConstants.batchCardBadgeSize,
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
                          content: Text(AppLocalizations.of(context)
                              .translate(AppStrings.exportComingSoon)),
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'export',
                      child: Row(
                        children: [
                          const Icon(Icons.file_download,
                              size: AppConstants.batchCardMenuIconSize),
                          const SizedBox(
                              width: AppConstants.batchCardMenuSpacing),
                          Text(AppLocalizations.of(context)
                              .translate(AppStrings.export)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete,
                              size: AppConstants.batchCardMenuIconSize,
                              color: AppConstants.statusDanger),
                          const SizedBox(
                              width: AppConstants.batchCardMenuSpacing),
                          Text(
                            AppLocalizations.of(context)
                                .translate(AppStrings.delete),
                            style: const TextStyle(
                                color: AppConstants.statusDanger),
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
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.batchCardPadding,
                  vertical: AppConstants.batchCardStatusPadding),
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
                    size: AppConstants.batchCardStatusIconSize,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: AppConstants.batchCardMenuSpacing),
                  Text(
                    '${AppLocalizations.of(context).translate(AppStrings.completedOn)} ${_formatDate(batch.usedAt!)}',
                    style: TextStyle(
                      fontSize: AppConstants.batchCardStatusTextSize,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

          // Bouton d'action (si non complété)
          if (!batch.completed)
            Container(
              padding:
                  const EdgeInsets.all(AppConstants.batchCardActionPadding),
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
                      label: Text(_getActionLabel(context, batch.purpose)),
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
        return AppConstants.statusSuccess;
      case BatchPurpose.slaughter:
        return AppConstants.statusDanger;
      case BatchPurpose.treatment:
        return AppConstants.statusInfo;
      case BatchPurpose.other:
        return Colors.grey;
    }
  }

  /// Obtenir le label selon l'objectif
  String _getPurposeLabel(BuildContext context, BatchPurpose purpose) {
    switch (purpose) {
      case BatchPurpose.sale:
        return AppLocalizations.of(context).translate(AppStrings.sale);
      case BatchPurpose.slaughter:
        return AppLocalizations.of(context).translate(AppStrings.slaughter);
      case BatchPurpose.treatment:
        return AppLocalizations.of(context).translate(AppStrings.treatment);
      case BatchPurpose.other:
        return AppLocalizations.of(context).translate(AppStrings.other);
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
  String _getActionLabel(BuildContext context, BatchPurpose purpose) {
    switch (purpose) {
      case BatchPurpose.sale:
        return AppLocalizations.of(context).translate(AppStrings.useForSale);
      case BatchPurpose.slaughter:
        return AppLocalizations.of(context)
            .translate(AppStrings.useForSlaughter);
      case BatchPurpose.treatment:
        return AppLocalizations.of(context)
            .translate(AppStrings.applyTreatment);
      case BatchPurpose.other:
        return AppLocalizations.of(context).translate(AppStrings.use);
    }
  }

  /// Formater une date en DD/MM/YYYY
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
