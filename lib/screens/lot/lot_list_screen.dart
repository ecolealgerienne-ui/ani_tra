// lib/screens/lot_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/lot_provider.dart';
import '../../models/lot.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';
import '../lot/lot_detail_screen.dart';

class LotListScreen extends StatefulWidget {
  const LotListScreen({super.key});

  @override
  State<LotListScreen> createState() => _LotListScreenState();
}

class _LotListScreenState extends State<LotListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            onPressed: () {
              if (nameController.text.trim().isEmpty) return;

              final provider = context.read<LotProvider>();
              final lot = provider.createLot(name: nameController.text.trim());

              Navigator.pop(context);

              // Naviguer vers détail
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LotDetailScreen(lotId: lot.id),
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)
                      .translate(AppStrings.lotCreated)),
                  backgroundColor: AppConstants.successGreen,
                ),
              );
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
                subtitle: Text(
                    '${lot.animalCount} ${AppLocalizations.of(context).translate(AppStrings.animals)}'),
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
                final provider = context.read<LotProvider>();
                final duplicated = provider.duplicateLot(
                  lot,
                  newName: nameController.text.trim(),
                  keepType: keepType,
                  keepAnimals: keepAnimals,
                );

                Navigator.pop(context);

                // Naviguer vers le nouveau lot
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LotDetailScreen(lotId: duplicated.id),
                  ),
                );

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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LotProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate(AppStrings.myLots)),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
                text:
                    '${AppLocalizations.of(context).translate(AppStrings.openLots)} (${provider.openLotsCount})'),
            Tab(
                text:
                    '${AppLocalizations.of(context).translate(AppStrings.closedLots)} (${provider.closedLotsCount})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLotsList(provider.openLots, isOpen: true),
          _buildLotsList(provider.closedLots, isOpen: false),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createLot,
        icon: const Icon(Icons.add),
        label:
            Text(AppLocalizations.of(context).translate(AppStrings.createLot)),
      ),
    );
  }

  Widget _buildLotsList(List<Lot> lots, {required bool isOpen}) {
    if (lots.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isOpen ? Icons.inbox_outlined : Icons.archive_outlined,
              size: AppConstants.iconSizeLarge,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            Text(
              isOpen
                  ? AppLocalizations.of(context).translate(AppStrings.noOpenLot)
                  : AppLocalizations.of(context)
                      .translate(AppStrings.noClosedLot),
              style: TextStyle(
                  fontSize: AppConstants.fontSizeBody,
                  color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: AppConstants.fabPaddingBottom),
      itemCount: lots.length,
      itemBuilder: (context, index) {
        final lot = lots[index];
        return _LotCard(
          lot: lot,
          isOpen: isOpen,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LotDetailScreen(lotId: lot.id),
              ),
            );
          },
          onDuplicate: () => _showDuplicateDialog(lot),
          onDelete: () => _deleteLot(lot),
        );
      },
    );
  }
}

class _LotCard extends StatelessWidget {
  final Lot lot;
  final bool isOpen;
  final VoidCallback onTap;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;

  const _LotCard({
    required this.lot,
    required this.isOpen,
    required this.onTap,
    required this.onDuplicate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Card(
      margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMedium,
          vertical: AppConstants.spacingSmall),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête
              Row(
                children: [
                  // Icône type
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingSmall),
                    decoration: BoxDecoration(
                      color: _getTypeColor()
                          .withValues(alpha: AppConstants.opacityLight),
                      borderRadius:
                          BorderRadius.circular(AppConstants.borderRadiusSmall),
                    ),
                    child: Text(
                      lot.type?.icon ?? '📋',
                      style: const TextStyle(
                          fontSize: AppConstants.iconSizeMedium),
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingSmall),

                  // Nom + Type
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lot.name,
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeBody,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingTiny),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingSmall,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getTypeColor(),
                            borderRadius: BorderRadius.circular(
                                AppConstants.borderRadiusSmall),
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
                      ],
                    ),
                  ),

                  // Statut
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingSmall,
                        vertical: AppConstants.spacingTiny),
                    decoration: BoxDecoration(
                      color:
                          isOpen ? Colors.green.shade50 : Colors.grey.shade200,
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
                          color:
                              isOpen ? AppConstants.successGreen : Colors.grey,
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

              // Infos
              Row(
                children: [
                  const Icon(Icons.pets,
                      size: AppConstants.iconSizeSmall, color: Colors.grey),
                  const SizedBox(width: AppConstants.spacingTiny),
                  Text(
                    '${lot.animalCount} ${AppLocalizations.of(context).translate(AppStrings.animals)}',
                    style: const TextStyle(
                        fontSize: AppConstants.fontSizeSubtitle),
                  ),
                  const SizedBox(width: AppConstants.spacingMedium),
                  const Icon(Icons.calendar_today,
                      size: AppConstants.iconSizeSmall, color: Colors.grey),
                  const SizedBox(width: AppConstants.spacingTiny),
                  Text(
                    dateFormat.format(lot.createdAt),
                    style: const TextStyle(
                        fontSize: AppConstants.fontSizeSubtitle),
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

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                  if (isOpen) ...[
                    const SizedBox(width: AppConstants.spacingSmall),
                    TextButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete,
                          size: AppConstants.iconSizeSmall),
                      label: Text(
                        AppLocalizations.of(context)
                            .translate(AppStrings.delete),
                        style: const TextStyle(
                            fontSize: AppConstants.fontSizeSmall),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppConstants.statusDanger,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
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
