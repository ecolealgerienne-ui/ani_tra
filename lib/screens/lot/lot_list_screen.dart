// lib/screens/lot/lot_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/lot_provider.dart';
import '../../providers/animal_provider.dart';
import '../../models/lot.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';
import 'lot_detail_screen.dart';

class LotListScreen extends StatefulWidget {
  const LotListScreen({super.key});

  @override
  State<LotListScreen> createState() => _LotListScreenState();
}

class _LotListScreenState extends State<LotListScreen> {
  // PHASE 1B: State variable for status filter (replaces TabController)
  late LotStatus _selectedStatus = LotStatus.open;

  @override
  void initState() {
    super.initState();
    _selectedStatus = LotStatus.open; // Default to open lots
  }

  void _createLot() {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(AppLocalizations.of(context).translate(AppStrings.createLot)),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText:
                AppLocalizations.of(context).translate(AppStrings.lotName),
            hintText: AppLocalizations.of(context)
                .translate(AppStrings.ewesMonthHint),
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
            onPressed: () async {
              if (nameController.text.trim().isEmpty) return;

              // ✅ Créer le lot via provider
              final provider = context.read<LotProvider>();

              try {
                final lot = await provider.createLot(
                  name: nameController.text.trim(),
                );

                if (!mounted) return;
                Navigator.pop(context);

                // ✅ Afficher confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)
                        .translate(AppStrings.lotCreated)),
                    backgroundColor: AppConstants.successGreen,
                  ),
                );

                // ✅ Naviguer vers détail du lot
                await Future.delayed(AppConstants.mediumAnimation);
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LotDetailScreen(lotId: lot.id),
                  ),
                );
              } catch (e) {
                if (!mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context).translate(AppStrings.error),
                    ),
                    backgroundColor: AppConstants.statusDanger,
                  ),
                );
              }
            },
            child:
                Text(AppLocalizations.of(context).translate(AppStrings.save)),
          ),
        ],
      ),
    );
  }

  void _showDuplicateDialog(Lot lot) {
    final nameController = TextEditingController(
        text:
            '${lot.name} ${AppLocalizations.of(context).translate(AppStrings.addCopieToName)}');
    bool keepType = lot.type != null;
    bool keepAnimals = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
              AppLocalizations.of(context).translate(AppStrings.duplicateLot)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context)
                  .translate(AppStrings.source)
                  .replaceAll('{name}', lot.name)),
              const SizedBox(height: AppConstants.spacingMedium),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)
                      .translate(AppStrings.newLotName),
                ),
              ),
              const SizedBox(height: AppConstants.spacingMedium),
              CheckboxListTile(
                title: Text(AppLocalizations.of(context)
                    .translate(AppStrings.keepAnimals)),
                subtitle: Text(_buildAnimalCountDisplay(context, lot)),
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
              onPressed: () async {
                final provider = context.read<LotProvider>();
                final duplicated = await provider.duplicateLot(
                  lot,
                  newName: nameController.text.trim(),
                  keepType: keepType,
                  keepAnimals: keepAnimals,
                );

                if (!mounted) return;
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)
                        .translate(AppStrings.lotDuplicated)),
                    backgroundColor: AppConstants.successGreen,
                  ),
                );

                // Naviguer vers le nouveau lot
                await Future.delayed(AppConstants.mediumAnimation);
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LotDetailScreen(lotId: duplicated.id),
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

  void _deleteLot(Lot lot) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(AppLocalizations.of(context).translate(AppStrings.deleteLot)),
        content: Text(AppLocalizations.of(context)
            .translate(AppStrings.deleteLotQuestion)
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

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)
                      .translate(AppStrings.lotDeleted)),
                  backgroundColor: AppConstants.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.statusDanger,
            ),
            child:
                Text(AppLocalizations.of(context).translate(AppStrings.delete)),
          ),
        ],
      ),
    );
  }

  // PHASE 1B: Archive lot dialog
  void _archiveLot(Lot lot) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(AppLocalizations.of(context).translate(AppStrings.archiveLot)),
        content: Text(
            '${AppLocalizations.of(context).translate(AppStrings.archiveConfirmMessage)}: ${lot.name}?'),
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
              if (!mounted) return;
              Navigator.pop(context);

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)
                        .translate(AppStrings.lotArchived)),
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

  // PHASE 1B: Get status label for subtitle
  String _getStatusLabel(LotStatus status) {
    switch (status) {
      case LotStatus.open:
        return AppLocalizations.of(context).translate(AppStrings.lotStatusOpen);
      case LotStatus.closed:
        return AppLocalizations.of(context)
            .translate(AppStrings.lotStatusClosed);
      case LotStatus.archived:
        return AppLocalizations.of(context)
            .translate(AppStrings.lotStatusArchived);
    }
  }

  // PHASE 1B: Helper to display animal count based on lot status and type
  String _buildAnimalCountDisplay(BuildContext context, Lot lot) {
    final lotProvider = context.read<LotProvider>();
    final animalProvider = context.read<AnimalProvider>();

    if (lot.status == LotStatus.open) {
      // OUVERTS: afficher seulement les animaux ACTIFS
      final activeCount =
          lotProvider.getActiveAnimalCount(lot.id, animalProvider.animals);
      return '$activeCount ${AppLocalizations.of(context).translate(AppStrings.animals)}';
    } else {
      // FERMÉS/ARCHIVÉS
      final totalCount = lotProvider.getTotalAnimalCount(lot.id);

      // PHASE 1B: Pour VENTE et ABATTAGE: tous inactifs par construction
      // Afficher juste le total sans "(X actifs)"
      if (lot.type == LotType.sale || lot.type == LotType.slaughter) {
        return '$totalCount ${AppLocalizations.of(context).translate(AppStrings.animals)}';
      }

      // Pour TRAITEMENT: certains peuvent rester vivants
      // Afficher avec le nombre d'actifs
      final activeCount =
          lotProvider.getActiveAnimalCount(lot.id, animalProvider.animals);

      if (totalCount == activeCount) {
        // Si tous sont toujours actifs
        return '$totalCount ${AppLocalizations.of(context).translate(AppStrings.animals)}';
      } else {
        // Afficher le format "5 animaux (3 actifs)"
        final animalsLabel =
            AppLocalizations.of(context).translate(AppStrings.animals);
        return '$totalCount $animalsLabel ($activeCount ${AppLocalizations.of(context).translate(AppStrings.active).toLowerCase()})';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context).translate(AppStrings.lots)),
            // PHASE 1B: Dynamic subtitle with count
            Consumer<LotProvider>(
              builder: (context, lotProvider, _) {
                final count = _selectedStatus == LotStatus.open
                    ? lotProvider.openLotsCount
                    : _selectedStatus == LotStatus.closed
                        ? lotProvider.closedLotsCount
                        : lotProvider.archivedLotsCount;

                return Text(
                  '${_getStatusLabel(_selectedStatus)} ($count)',
                  style: Theme.of(context).textTheme.bodySmall,
                );
              },
            ),
          ],
        ),
        actions: [
          // PHASE 1B: Menu button with all statuses
          Consumer<LotProvider>(
            builder: (context, lotProvider, _) {
              return PopupMenuButton<LotStatus>(
                onSelected: (LotStatus status) {
                  setState(() {
                    _selectedStatus = status;
                  });
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<LotStatus>>[
                  PopupMenuItem<LotStatus>(
                    value: LotStatus.open,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Text(AppLocalizations.of(context)
                              .translate(AppStrings.openLots)),
                        ),
                        const SizedBox(width: AppConstants.spacingSmall),
                        Text(
                          '(${lotProvider.openLotsCount})',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: AppConstants.fontSizeSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<LotStatus>(
                    value: LotStatus.closed,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Text(AppLocalizations.of(context)
                              .translate(AppStrings.closedLots)),
                        ),
                        const SizedBox(width: AppConstants.spacingSmall),
                        Text(
                          '(${lotProvider.closedLotsCount})',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: AppConstants.fontSizeSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<LotStatus>(
                    value: LotStatus.archived,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Text(AppLocalizations.of(context)
                              .translate(AppStrings.lotStatusArchived)),
                        ),
                        const SizedBox(width: AppConstants.spacingSmall),
                        Text(
                          '(${lotProvider.archivedLotsCount})',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: AppConstants.fontSizeSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createLot,
        tooltip: AppLocalizations.of(context).translate(AppStrings.createLot),
        child: const Icon(Icons.add),
      ),
      body: Consumer<LotProvider>(
        builder: (context, lotProvider, _) {
          // PHASE 1B: Get lots based on selected status
          final lots = _selectedStatus == LotStatus.open
              ? lotProvider.openLots
              : _selectedStatus == LotStatus.closed
                  ? lotProvider.closedLots
                  : lotProvider.archivedLots;

          return _buildLotList(context, lots);
        },
      ),
    );
  }

  Widget _buildLotList(BuildContext context, List<Lot> lots) {
    if (lots.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2,
              size: AppConstants.iconSizeLarge,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            Text(
              AppLocalizations.of(context).translate(AppStrings.noLots),
              style: TextStyle(
                fontSize: AppConstants.fontSizeSubtitle,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      itemCount: lots.length,
      itemBuilder: (context, index) {
        final lot = lots[index];

        // PHASE 1B: Determine which actions to show based on status
        final showDelete = _selectedStatus == LotStatus.open;
        final showArchive = _selectedStatus == LotStatus.closed;
        final isViewOnly = _selectedStatus == LotStatus.archived;

        // PHASE 1B: Calculate animal count display based on lot status
        final animalCountDisplay = _buildAnimalCountDisplay(context, lot);

        return _LotCard(
          lot: lot,
          animalCountDisplay: animalCountDisplay,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LotDetailScreen(lotId: lot.id),
              ),
            );
          },
          onDuplicate: () => _showDuplicateDialog(lot),
          onDelete: showDelete ? () => _deleteLot(lot) : null,
          onArchive: showArchive ? () => _archiveLot(lot) : null,
          isViewOnly: isViewOnly,
        );
      },
    );
  }
}

/// Widget: Carte de lot
/// PHASE 1B: UPDATED - Add isViewOnly parameter and animalCountDisplay
class _LotCard extends StatelessWidget {
  final Lot lot;
  final VoidCallback onTap;
  final VoidCallback onDuplicate;
  final VoidCallback? onDelete;
  final VoidCallback? onArchive;
  final bool isViewOnly;
  final String animalCountDisplay;

  const _LotCard({
    required this.lot,
    required this.onTap,
    required this.onDuplicate,
    required this.onDelete,
    this.onArchive,
    this.isViewOnly = false,
    required this.animalCountDisplay,
  });

  @override
  Widget build(BuildContext context) {
    //final dateFormat = DateFormat('dd/MM/yyyy');
    final isOpen = lot.isOpen;

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMedium),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // En-tête: nom + type + statut
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lot.name,
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeSectionTitle,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.spacingSmall),

            // Type et Statut
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingSmall,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getTypeColor(),
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadiusSmall),
                  ),
                  child: Text(
                    lot.type?.label ??
                        AppLocalizations.of(context)
                            .translate(AppStrings.typeNotDefined),
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeTiny,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingSmall),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingSmall,
                      vertical: AppConstants.spacingTiny),
                  decoration: BoxDecoration(
                    color: isOpen ? Colors.green.shade50 : Colors.grey.shade200,
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadiusSmall),
                    border: Border.all(
                      color: isOpen ? AppConstants.successGreen : Colors.grey,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isOpen ? Icons.lock_open : Icons.lock,
                        size: AppConstants.iconSizeTiny,
                        color: isOpen ? AppConstants.successGreen : Colors.grey,
                      ),
                      const SizedBox(width: AppConstants.spacingTiny),
                      Text(
                        AppLocalizations.of(context).translate(isOpen
                            ? AppStrings.lotOpened
                            : AppStrings.lotClosed),
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeTiny,
                          fontWeight: FontWeight.bold,
                          color: isOpen ? Colors.green.shade700 : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.spacingSmall),

            // Infos: animaux + date
            Row(
              children: [
                const Icon(Icons.pets,
                    size: AppConstants.iconSizeSmall, color: Colors.grey),
                const SizedBox(width: AppConstants.spacingTiny),
                Text(
                  animalCountDisplay,
                  style:
                      const TextStyle(fontSize: AppConstants.fontSizeSubtitle),
                ),
                const SizedBox(width: AppConstants.spacingMedium),
                const Icon(Icons.calendar_today,
                    size: AppConstants.iconSizeSmall, color: Colors.grey),
                const SizedBox(width: AppConstants.spacingTiny),
                Text(
                  DateFormat('dd/MM/yyyy').format(lot.createdAt),
                  style:
                      const TextStyle(fontSize: AppConstants.fontSizeSubtitle),
                ),
              ],
            ),

            // Infos spécifiques selon type
            if (lot.type == LotType.treatment && lot.productName != null) ...[
              const SizedBox(height: AppConstants.spacingSmall),
              Row(
                children: [
                  const Icon(Icons.medication,
                      size: AppConstants.iconSizeSmall,
                      color: AppConstants.primaryBlue),
                  const SizedBox(width: AppConstants.spacingTiny),
                  Text(
                    lot.productName!,
                    style: const TextStyle(
                        fontSize: AppConstants.fontSizeSubtitle),
                  ),
                ],
              ),
            ],

            if (lot.type == LotType.sale && lot.buyerName != null) ...[
              const SizedBox(height: AppConstants.spacingSmall),
              Row(
                children: [
                  const Icon(Icons.person,
                      size: AppConstants.iconSizeSmall,
                      color: AppConstants.successGreen),
                  const SizedBox(width: AppConstants.spacingTiny),
                  Text(
                    lot.buyerName!,
                    style: const TextStyle(
                        fontSize: AppConstants.fontSizeSubtitle),
                  ),
                  if (lot.totalPrice != null) ...[
                    const SizedBox(width: AppConstants.spacingSmall),
                    Text(
                      '${lot.totalPrice!.toStringAsFixed(2)}€',
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeSubtitle,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ],

            if (lot.type == LotType.slaughter &&
                lot.slaughterhouseName != null) ...[
              const SizedBox(height: AppConstants.spacingSmall),
              Row(
                children: [
                  const Icon(Icons.factory,
                      size: AppConstants.iconSizeSmall, color: Colors.grey),
                  const SizedBox(width: AppConstants.spacingTiny),
                  Text(
                    lot.slaughterhouseName!,
                    style: const TextStyle(
                        fontSize: AppConstants.fontSizeSubtitle),
                  ),
                ],
              ),
            ],

            const SizedBox(height: AppConstants.spacingSmall),

            // Actions (PHASE 1B: Updated based on status)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // PHASE 1B: Show Duplicate only if not archived (not view-only)
                if (!isViewOnly) ...[
                  TextButton.icon(
                    onPressed: onDuplicate,
                    icon: const Icon(Icons.content_copy,
                        size: AppConstants.iconSizeSmall),
                    label: Text(
                      AppLocalizations.of(context)
                          .translate(AppStrings.duplicate),
                      style:
                          const TextStyle(fontSize: AppConstants.fontSizeSmall),
                    ),
                  ),
                ],

                // PHASE 1B: Show Delete only for open lots
                if (onDelete != null) ...[
                  const SizedBox(width: AppConstants.spacingSmall),
                  TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete,
                        size: AppConstants.iconSizeSmall),
                    label: Text(
                      AppLocalizations.of(context).translate(AppStrings.delete),
                      style:
                          const TextStyle(fontSize: AppConstants.fontSizeSmall),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppConstants.statusDanger,
                    ),
                  ),
                ],

                // PHASE 1B: Show Archive only for closed lots
                if (onArchive != null) ...[
                  const SizedBox(width: AppConstants.spacingSmall),
                  TextButton.icon(
                    onPressed: onArchive,
                    icon: const Icon(Icons.archive,
                        size: AppConstants.iconSizeSmall),
                    label: Text(
                      AppLocalizations.of(context)
                          .translate(AppStrings.lotStatusArchived),
                      style:
                          const TextStyle(fontSize: AppConstants.fontSizeSmall),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppConstants.warningOrange,
                    ),
                  ),
                ],
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Color _getTypeColor() {
    switch (lot.type) {
      case LotType.treatment:
        return AppConstants.primaryBlue;
      case LotType.sale:
        return AppConstants.successGreen;
      case LotType.slaughter:
        return AppConstants.statusGrey;
      case null:
        return AppConstants.warningOrange;
    }
  }
}
