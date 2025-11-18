// lib/screens/lot_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/lot_provider.dart';
import '../../providers/animal_provider.dart';
import '../../providers/movement_provider.dart';
import '../../models/lot.dart';
import '../../models/animal.dart';
import '../../models/movement.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';
import '../animal/animal_finder_screen.dart';
import '../lot/lot_finalize_screen.dart';

class LotDetailScreen extends StatelessWidget {
  final String lotId;

  const LotDetailScreen({
    super.key,
    required this.lotId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context).translate(AppStrings.lotDetail)),
        actions: [
          Consumer<LotProvider>(
            builder: (context, lotProvider, _) {
              final lot = lotProvider.getLotById(lotId);

              // PHASE 1B: Hide menu button for archived lots (view-only)
              if (lot != null && lot.status == LotStatus.archived) {
                return const SizedBox.shrink();
              }

              return PopupMenuButton<String>(
                onSelected: (value) => _handleMenuAction(context, value),
                itemBuilder: (context) {
                  final lot = context.read<LotProvider>().getLotById(lotId);
                  if (lot == null) return [];

                  return [
                    if (lot.status == LotStatus.open)
                      PopupMenuItem(
                        value: 'rename',
                        child: Row(
                          children: [
                            const Icon(Icons.edit,
                                size: AppConstants.iconSizeRegular),
                            const SizedBox(width: AppConstants.spacingSmall),
                            Text(AppLocalizations.of(context)
                                .translate(AppStrings.rename)),
                          ],
                        ),
                      ),
                    PopupMenuItem(
                      value: 'duplicate',
                      child: Row(
                        children: [
                          const Icon(Icons.content_copy,
                              size: AppConstants.iconSizeRegular),
                          const SizedBox(width: AppConstants.spacingSmall),
                          Text(AppLocalizations.of(context)
                              .translate(AppStrings.duplicate)),
                        ],
                      ),
                    ),
                    // PHASE 1: ADD - Archive button for closed lots
                    if (lot.status == LotStatus.closed)
                      PopupMenuItem(
                        value: 'archive',
                        child: Row(
                          children: [
                            const Icon(Icons.archive,
                                size: AppConstants.iconSizeRegular),
                            const SizedBox(width: AppConstants.spacingSmall),
                            Text(AppLocalizations.of(context)
                                .translate(AppStrings.lotStatusArchived)),
                          ],
                        ),
                      ),
                    if (lot.status == LotStatus.open)
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete,
                                size: AppConstants.iconSizeRegular,
                                color: AppConstants.statusDanger),
                            const SizedBox(width: AppConstants.spacingSmall),
                            Text(
                              AppLocalizations.of(context)
                                  .translate(AppStrings.delete),
                              style: const TextStyle(
                                  color: AppConstants.statusDanger),
                            ),
                          ],
                        ),
                      ),
                  ];
                },
              );
            },
          ),
        ],
      ),
      body: Consumer3<LotProvider, AnimalProvider, MovementProvider>(
        builder: (context, lotProvider, animalProvider, movementProvider, child) {
          final lot = lotProvider.getLotById(lotId);

          if (lot == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: AppConstants.iconSizeLarge,
                      color: Colors.grey.shade400),
                  const SizedBox(height: AppConstants.spacingMedium),
                  Text(
                    AppLocalizations.of(context)
                        .translate(AppStrings.lotNotFound),
                    style: TextStyle(
                        fontSize: AppConstants.fontSizeImportant,
                        color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: AppConstants.spacingMedium),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(AppLocalizations.of(context)
                        .translate(AppStrings.back)),
                  ),
                ],
              ),
            );
          }

          final animals = _getAnimalsInLot(lot, animalProvider);
          // Récupérer les mouvements liés au lot
          final lotMovements = movementProvider.movements
              .where((m) => m.lotId == lotId)
              .toList();

          return ListView(
            children: [
              _buildHeader(context, lot),
              _buildStatusSection(context, lot),
              if (lot.type != null) _buildTypeSection(context, lot, lotMovements),
              _buildStatisticsSection(context, lot, animals),
              _buildAnimalsSection(context, lot, animals),
              if (lot.status == LotStatus.open)
                _buildActionsSection(context, lot, animals),
              const SizedBox(height: AppConstants.fabPaddingBottom),
            ],
          );
        },
      ),
    );
  }

  List<Animal> _getAnimalsInLot(Lot lot, AnimalProvider provider) {
    final animals = <Animal>[];
    for (final animalId in lot.animalIds) {
      final animal = provider.getAnimalById(animalId);
      if (animal != null) {
        // Pour les lots ouverts, inclure seulement les animaux actifs
        // Pour les lots fermés/archivés, inclure tous les animaux
        if (lot.status == LotStatus.open) {
          if (animal.status == AnimalStatus.alive) {
            animals.add(animal);
          }
        } else {
          animals.add(animal);
        }
      }
    }
    return animals;
  }

  Widget _buildHeader(BuildContext context, Lot lot) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getTypeColor(lot).withValues(alpha: AppConstants.opacityMedium),
            _getTypeColor(lot).withValues(alpha: AppConstants.opacityLight),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: AppConstants.headerCircleSize,
            height: AppConstants.headerCircleSize,
            decoration: BoxDecoration(
              color: _getTypeColor(lot)
                  .withValues(alpha: AppConstants.opacityMedium),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                lot.type?.icon ?? '📋',
                style: const TextStyle(fontSize: AppConstants.headerIconSize),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            lot.name,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeLargeTitle,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today,
                  size: AppConstants.iconSizeSmall,
                  color: Colors.grey.shade700),
              const SizedBox(width: AppConstants.spacingSmall),
              Text(
                DateFormat('dd/MM/yyyy').format(lot.createdAt),
                style: TextStyle(
                    fontSize: AppConstants.fontSizeSubtitle,
                    color: Colors.grey.shade700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context, Lot lot) {
    final isClosed =
        lot.status == LotStatus.closed || lot.status == LotStatus.archived;
    final statusColor = isClosed ? Colors.grey : AppConstants.successGreen;
    final statusIcon = isClosed ? Icons.lock : Icons.lock_open;
    final statusText =
        AppLocalizations.of(context).translate(lot.status == LotStatus.open
            ? AppStrings.lotOpened
            : lot.status == LotStatus.closed
                ? AppStrings.lotClosed
                : lot.status == LotStatus.archived
                    ? AppStrings.lotArchived
                    : AppStrings.lotOpened);

    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: AppConstants.opacityLight),
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          border: Border.all(color: statusColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(statusIcon,
                color: statusColor, size: AppConstants.iconSizeMedium),
            const SizedBox(width: AppConstants.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).translate(AppStrings.status),
                    style: TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: AppConstants.spacingMicro),
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeImportant,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  if (isClosed && lot.completedAt != null)
                    Text(
                      '${AppLocalizations.of(context).translate(AppStrings.onThe)} ${DateFormat('dd/MM/yyyy').format(lot.completedAt!)}',
                      style: TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          color: Colors.grey.shade600),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSection(BuildContext context, Lot lot, List<Movement> lotMovements) {
    final firstMovement = lotMovements.isNotEmpty ? lotMovements.first : null;

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppConstants.spacingMedium),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.category, color: _getTypeColor(lot)),
                  const SizedBox(width: AppConstants.spacingSmall),
                  Text(
                    '${AppLocalizations.of(context).translate(AppStrings.type)}: ${lot.type!.label}',
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeBody,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingMedium),

              // TRAITEMENT
              if (lot.type == LotType.treatment && lot.productName != null) ...[
                _buildInfoRow(
                    AppLocalizations.of(context).translate(AppStrings.product),
                    lot.productName!,
                    Icons.medication),
                if (lot.treatmentDate != null) ...[
                  const SizedBox(height: AppConstants.spacingSmall),
                  _buildInfoRow(
                    AppLocalizations.of(context)
                        .translate(AppStrings.treatmentDate),
                    DateFormat('dd/MM/yyyy').format(lot.treatmentDate!),
                    Icons.calendar_today,
                  ),
                ],
                if (lot.veterinarianName != null) ...[
                  const SizedBox(height: AppConstants.spacingSmall),
                  _buildInfoRow(
                      AppLocalizations.of(context)
                          .translate(AppStrings.veterinarian),
                      lot.veterinarianName!,
                      Icons.person),
                ],
              ],

              // VENTE
              if (lot.type == LotType.sale) ...[
                if (firstMovement?.buyerName != null) ...[
                  _buildInfoRow(
                    AppLocalizations.of(context).translate(AppStrings.buyer),
                    firstMovement!.buyerName!,
                    Icons.person,
                  ),
                ],
                if (firstMovement?.buyerFarmId != null) ...[
                  const SizedBox(height: AppConstants.spacingSmall),
                  _buildInfoRow(
                    AppLocalizations.of(context).translate(AppStrings.buyerFarmId),
                    firstMovement!.buyerFarmId!,
                    Icons.badge,
                  ),
                ],
                if (firstMovement?.buyerType != null) ...[
                  const SizedBox(height: AppConstants.spacingSmall),
                  _buildInfoRow(
                    AppLocalizations.of(context).translate(AppStrings.type),
                    _getBuyerTypeLabel(context, firstMovement!.buyerType!),
                    Icons.category,
                  ),
                ],
                // Calculer le prix total du lot (somme des prix de tous les mouvements)
                if (lotMovements.any((m) => m.price != null)) ...[
                  const SizedBox(height: AppConstants.spacingSmall),
                  Builder(builder: (context) {
                    final totalPrice = lotMovements
                        .where((m) => m.price != null)
                        .fold<double>(0.0, (sum, m) => sum + m.price!);
                    return _buildInfoRow(
                      AppLocalizations.of(context).translate(AppStrings.totalPrice),
                      '${totalPrice.toStringAsFixed(2)}€',
                      Icons.euro,
                    );
                  }),
                ],
                if (lot.completedAt != null) ...[
                  const SizedBox(height: AppConstants.spacingSmall),
                  _buildInfoRow(
                    AppLocalizations.of(context).translate(AppStrings.saleDate),
                    DateFormat('dd/MM/yyyy').format(lot.completedAt!),
                    Icons.calendar_today,
                  ),
                ],
              ],

              // ABATTAGE
              if (lot.type == LotType.slaughter && firstMovement != null) ...[
                if (firstMovement.slaughterhouseName != null) ...[
                  _buildInfoRow(
                    AppLocalizations.of(context).translate(AppStrings.slaughterhouse),
                    firstMovement.slaughterhouseName!,
                    Icons.business,
                  ),
                ],
                if (firstMovement.slaughterhouseId != null) ...[
                  const SizedBox(height: AppConstants.spacingSmall),
                  _buildInfoRow(
                    AppLocalizations.of(context).translate(AppStrings.slaughterhouseId),
                    firstMovement.slaughterhouseId!,
                    Icons.badge,
                  ),
                ],
                if (lot.completedAt != null) ...[
                  const SizedBox(height: AppConstants.spacingSmall),
                  _buildInfoRow(
                    AppLocalizations.of(context).translate(AppStrings.dateSlaughter),
                    DateFormat('dd/MM/yyyy').format(lot.completedAt!),
                    Icons.calendar_today,
                  ),
                ],
              ],

              // ACHAT
              if (lot.type == LotType.purchase) ...[
                if (lot.sellerName != null) ...[
                  _buildInfoRow(
                    AppLocalizations.of(context).translate(AppStrings.seller),
                    lot.sellerName!,
                    Icons.person_outline,
                  ),
                ],
                if (lot.priceTotal != null) ...[
                  const SizedBox(height: AppConstants.spacingSmall),
                  _buildInfoRow(
                    AppLocalizations.of(context).translate(AppStrings.totalPrice),
                    '${lot.priceTotal!.toStringAsFixed(2)}€',
                    Icons.euro,
                  ),
                ],
                if (lot.completedAt != null) ...[
                  const SizedBox(height: AppConstants.spacingSmall),
                  _buildInfoRow(
                    AppLocalizations.of(context).translate(AppStrings.purchaseDate),
                    DateFormat('dd/MM/yyyy').format(lot.completedAt!),
                    Icons.calendar_today,
                  ),
                ],
              ],

              // Notes (lot ou mouvement)
              if ((lot.notes != null && lot.notes!.isNotEmpty) ||
                  (firstMovement?.notes != null && firstMovement!.notes!.isNotEmpty)) ...[
                const Divider(height: AppConstants.spacingLarge),
                Text(
                  AppLocalizations.of(context).translate(AppStrings.notes),
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingTiny),
                // Afficher notes du lot si présentes
                if (lot.notes != null && lot.notes!.isNotEmpty)
                  Text(lot.notes!),
                // Afficher notes du mouvement si présentes et différentes
                if (firstMovement?.notes != null &&
                    firstMovement!.notes!.isNotEmpty &&
                    firstMovement.notes != lot.notes) ...[
                  if (lot.notes != null && lot.notes!.isNotEmpty)
                    const SizedBox(height: AppConstants.spacingSmall),
                  Text(firstMovement.notes!),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getBuyerTypeLabel(BuildContext context, String buyerType) {
    final l10n = AppLocalizations.of(context);
    switch (buyerType) {
      case 'individual':
        return l10n.translate(AppStrings.buyerTypeIndividual);
      case 'farm':
        return l10n.translate(AppStrings.buyerTypeFarm);
      case 'trader':
        return l10n.translate(AppStrings.buyerTypeTrader);
      case 'cooperative':
        return l10n.translate(AppStrings.buyerTypeCooperative);
      default:
        return buyerType;
    }
  }

  Widget _buildStatisticsSection(
      BuildContext context, Lot lot, List<Animal> animals) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              AppLocalizations.of(context).translate(AppStrings.animals),
              '${animals.length}',
              Icons.pets,
              AppConstants.primaryBlue,
            ),
          ),
          const SizedBox(width: AppConstants.spacingSmall),
          Expanded(
            child: _buildStatCard(
              context,
              AppLocalizations.of(context).translate(AppStrings.males),
              '${animals.where((a) => a.sex == AnimalSex.male).length}',
              Icons.male,
              Colors.blue.shade700,
            ),
          ),
          const SizedBox(width: AppConstants.spacingSmall),
          Expanded(
            child: _buildStatCard(
              context,
              AppLocalizations.of(context).translate(AppStrings.females),
              '${animals.where((a) => a.sex == AnimalSex.female).length}',
              Icons.female,
              Colors.pink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value,
      IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingSmall),
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppConstants.opacityLight),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: AppConstants.iconSizeMedium),
          const SizedBox(height: AppConstants.spacingSmall),
          Text(
            value,
            style: TextStyle(
              fontSize: AppConstants.fontSizeLargeTitle,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: AppConstants.spacingTiny),
          Text(
            label,
            style: TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalsSection(
      BuildContext context, Lot lot, List<Animal> animals) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).translate(AppStrings.animals),
                style: const TextStyle(
                    fontSize: AppConstants.fontSizeImportant,
                    fontWeight: FontWeight.bold),
              ),
              if (!lot.completed)
                TextButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push<List<Animal>>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AnimalFinderScreen(
                          mode: AnimalFinderMode.multiple,
                          title: AppLocalizations.of(context)
                              .translate(AppStrings.scanAnimals),
                          allowedStatuses: const [AnimalStatus.alive],
                          lotId: lot.id,
                          animalIdsInLot: lot.animalIds,
                        ),
                      ),
                    );

                    if (result != null && context.mounted) {
                      final lotProvider = context.read<LotProvider>();
                      lotProvider.setActiveLot(lot);

                      for (final animal in result) {
                        if (!lot.animalIds.contains(animal.id)) {
                          lotProvider.addAnimalToActiveLot(animal.id);
                        }
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '${result.length} ${AppLocalizations.of(context).translate(AppStrings.animalsAdded)}'),
                          backgroundColor: AppConstants.successGreen,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.qr_code_scanner,
                      size: AppConstants.iconSizeRegular),
                  label: Text(AppLocalizations.of(context)
                      .translate(AppStrings.scanner)),
                ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSmall),
          if (animals.isEmpty)
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingLarge),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.pets_outlined,
                        size: AppConstants.iconSizeMediumLarge,
                        color: Colors.grey.shade400),
                    const SizedBox(height: AppConstants.spacingSmall),
                    Text(
                      AppLocalizations.of(context)
                          .translate(AppStrings.noAnimals),
                      style: TextStyle(
                          fontSize: AppConstants.fontSizeSubtitle,
                          color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            )
          else
            ...animals.map((animal) => _buildAnimalCard(context, lot, animal)),
        ],
      ),
    );
  }

  Widget _buildAnimalCard(BuildContext context, Lot lot, Animal animal) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingSmall),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: animal.sex == AnimalSex.male
              ? Colors.blue.withValues(alpha: AppConstants.opacityMedium)
              : Colors.pink.withValues(alpha: AppConstants.opacityMedium),
          child: Icon(
            animal.sex == AnimalSex.male ? Icons.male : Icons.female,
            color: animal.sex == AnimalSex.male
                ? AppConstants.primaryBlue
                : Colors.pink,
          ),
        ),
        title: Text(animal.displayName),
        subtitle: Text(animal.displayName),
        trailing: !lot.completed
            ? IconButton(
                icon: const Icon(Icons.remove_circle,
                    color: AppConstants.statusDanger),
                onPressed: () {
                  context
                      .read<LotProvider>()
                      .removeAnimalFromLot(lot.id, animal.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)
                          .translate(AppStrings.animalRemovedFromLot)),
                      backgroundColor: AppConstants.warningOrange,
                    ),
                  );
                },
              )
            : null,
      ),
    );
  }

  Widget _buildActionsSection(
      BuildContext context, Lot lot, List<Animal> animals) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: animals.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LotFinalizeScreen(lotId: lot.id),
                        ),
                      );
                    },
              icon: const Icon(Icons.check_circle),
              label: Text(l10n.translate(AppStrings.finalizeLot)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.spacingMedium),
                backgroundColor: AppConstants.successGreen,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacingSmall),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
              label: Text(
                  AppLocalizations.of(context).translate(AppStrings.close)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.spacingMedium),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon,
            size: AppConstants.iconSizeSmall, color: Colors.grey.shade600),
        const SizedBox(width: AppConstants.spacingSmall),
        Text(
          '$label: ',
          style: TextStyle(
              fontSize: AppConstants.fontSizeSubtitle,
              color: Colors.grey.shade600),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
                fontSize: AppConstants.fontSizeSubtitle,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Color _getTypeColor(Lot lot) {
    switch (lot.type) {
      case LotType.treatment:
        return AppConstants.primaryBlue;
      case LotType.purchase:
        return Colors.blue.shade700;
      case LotType.sale:
        return AppConstants.successGreen;
      case LotType.slaughter:
        return AppConstants.statusGrey;
      case null:
        return AppConstants.warningOrange;
    }
  }

  void _handleMenuAction(BuildContext context, String action) {
    final lot = context.read<LotProvider>().getLotById(lotId);
    if (lot == null) return;

    switch (action) {
      case 'rename':
        _showRenameDialog(context, lot);
        break;
      case 'duplicate':
        _showDuplicateDialog(context, lot);
        break;
      case 'archive':
        _showArchiveDialog(context, lot);
        break;
      case 'delete':
        _showDeleteDialog(context, lot);
        break;
    }
  }

  void _showRenameDialog(BuildContext context, Lot lot) {
    final controller = TextEditingController(text: lot.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate(AppStrings.rename)),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText:
                AppLocalizations.of(context).translate(AppStrings.newName),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                Text(AppLocalizations.of(context).translate(AppStrings.cancel)),
          ),
          ElevatedButton(
            onPressed: () {
              context
                  .read<LotProvider>()
                  .renameLot(lot.id, controller.text.trim());
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)
                      .translate(AppStrings.lotRenamed)),
                  backgroundColor: AppConstants.successGreen,
                ),
              );
            },
            child:
                Text(AppLocalizations.of(context).translate(AppStrings.rename)),
          ),
        ],
      ),
    );
  }

  void _showDuplicateDialog(BuildContext context, Lot lot) {
    final nameController = TextEditingController(
        text:
            '${lot.name} ${AppLocalizations.of(context).translate(AppStrings.copySuffix)}');
    bool keepType = lot.type != null;
    bool keepAnimals = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
              AppLocalizations.of(context).translate(AppStrings.duplicate)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)
                        .translate(AppStrings.newName)),
              ),
              const SizedBox(height: AppConstants.spacingMedium),
              CheckboxListTile(
                title: Text(AppLocalizations.of(context)
                    .translate(AppStrings.keepAnimals)),
                subtitle: Text(
                    '${context.read<LotProvider>().getActiveAnimalCount(lot.id, context.read<AnimalProvider>().animals)} ${AppLocalizations.of(context).translate(AppStrings.animals).toLowerCase()}'),
                value: keepAnimals,
                onChanged: (val) => setState(() => keepAnimals = val ?? true),
              ),
              if (lot.type != null)
                CheckboxListTile(
                  title: Text(AppLocalizations.of(context)
                      .translate(AppStrings.keepType)),
                  subtitle: Text(lot.type!.label),
                  value: keepType,
                  onChanged: (val) => setState(() => keepType = val ?? false),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                  AppLocalizations.of(context).translate(AppStrings.cancel)),
            ),
            ElevatedButton(
              onPressed: () {
                final duplicated = context.read<LotProvider>().duplicateLot(
                      lot,
                      newName: nameController.text.trim(),
                      keepType: keepType,
                      keepAnimals: keepAnimals,
                    );
                Future<void> showDuplicateDialog() async {
                  Navigator.pop(context);
                  final duplicatedLot = await duplicated;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LotDetailScreen(lotId: duplicatedLot.id),
                    ),
                  );
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)
                        .translate(AppStrings.lotDuplicated)),
                    backgroundColor: AppConstants.successGreen,
                  ),
                );
              },
              child: Text(
                  AppLocalizations.of(context).translate(AppStrings.duplicate)),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Lot lot) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate(AppStrings.delete)),
        content: Text(AppLocalizations.of(context)
            .translate(AppStrings.deleteLotConfirm)
            .replaceAll('{name}', lot.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                Text(AppLocalizations.of(context).translate(AppStrings.cancel)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<LotProvider>().deleteLot(lot.id);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)
                      .translate(AppStrings.batchDeleted)
                      .replaceAll('{name}', lot.name)),
                  backgroundColor: AppConstants.statusDanger,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.statusDanger),
            child:
                Text(AppLocalizations.of(context).translate(AppStrings.delete)),
          ),
        ],
      ),
    );
  }

  // PHASE 1: ADD - Archive dialog
  void _showArchiveDialog(BuildContext context, Lot lot) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(AppLocalizations.of(context).translate(AppStrings.archiveLot)),
        content: Text(AppLocalizations.of(context)
            .translate(AppStrings.lotArchived)
            .replaceAll('{name}', lot.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                Text(AppLocalizations.of(context).translate(AppStrings.cancel)),
          ),
          ElevatedButton(
            onPressed: () async {
              final success =
                  await context.read<LotProvider>().archiveLot(lot.id);
              if (!context.mounted) return;
              Navigator.pop(context);
              if (success) {
                Navigator.pop(context); // Revenir à la list
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)
                          .translate(AppStrings.lotArchived),
                    ),
                    backgroundColor: AppConstants.successGreen,
                  ),
                );
              }
            },
            child: Text(AppLocalizations.of(context)
                .translate(AppStrings.lotStatusArchived)),
          ),
        ],
      ),
    );
  }
}
