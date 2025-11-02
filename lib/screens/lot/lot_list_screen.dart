// lib/screens/lot_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/lot_provider.dart';
import '../../models/lot.dart';
import '../../i18n/app_localizations.dart';
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
        title: Text(AppLocalizations.of(context).translate('create_lot')),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate('lot_name'),
            hintText: 'Ex: Brebis mai 2025',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).translate('cancel')),
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
                  content: Text(
                      AppLocalizations.of(context).translate('lot_created')),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text(AppLocalizations.of(context).translate('save')),
          ),
        ],
      ),
    );
  }

  void _showDuplicateDialog(Lot lot) {
    final nameController = TextEditingController(text: '${lot.name} (copie)');
    bool keepType = lot.type != null;
    bool keepAnimals = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(AppLocalizations.of(context).translate('duplicate_lot')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Source: ${lot.name}'),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context).translate('new_lot_name'),
                ),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: Text(
                    AppLocalizations.of(context).translate('keep_animals')),
                subtitle: Text('${lot.animalCount} animaux'),
                value: keepAnimals,
                onChanged: (val) => setState(() => keepAnimals = val ?? true),
              ),
              if (lot.type != null)
                CheckboxListTile(
                  title:
                      Text(AppLocalizations.of(context).translate('keep_type')),
                  subtitle: Text(lot.type!.label),
                  value: keepType,
                  onChanged: (val) => setState(() => keepType = val ?? false),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context).translate('cancel')),
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
                        .translate('lot_duplicated')),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child:
                  Text(AppLocalizations.of(context).translate('duplicate_lot')),
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
        title: Text(AppLocalizations.of(context).translate('delete_lot')),
        content: Text('Supprimer "${lot.name}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<LotProvider>().deleteLot(lot.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Lot supprimé'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppLocalizations.of(context).translate('delete')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<LotProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('my_lots')),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
                text:
                    '${l10n.translate('open_lots')} (${provider.openLotsCount})'),
            Tab(
                text:
                    '${l10n.translate('closed_lots')} (${provider.closedLotsCount})'),
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
        label: Text(l10n.translate('create_lot')),
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
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              isOpen ? 'Aucun lot ouvert' : 'Aucun lot terminé',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête
              Row(
                children: [
                  // Icône type
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getTypeColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      lot.type?.icon ?? '📋',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Nom + Type
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lot.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getTypeColor(),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            lot.type?.label ??
                                AppLocalizations.of(context)
                                    .translate('type_not_defined'),
                            style: const TextStyle(
                              fontSize: 11,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          isOpen ? Colors.green.shade50 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isOpen ? Colors.green : Colors.grey,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isOpen ? Icons.lock_open : Icons.lock,
                          size: 14,
                          color: isOpen ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppLocalizations.of(context)
                              .translate(isOpen ? 'lot_open' : 'lot_closed'),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isOpen ? Colors.green.shade700 : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Infos
              Row(
                children: [
                  const Icon(Icons.pets, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${lot.animalCount} animaux',
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.calendar_today,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    dateFormat.format(lot.createdAt),
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),

              // Infos spécifiques selon type
              if (lot.type == LotType.treatment && lot.productName != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.medication, size: 16, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(
                      lot.productName!,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ],

              if (lot.type == LotType.sale && lot.buyerName != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      lot.buyerName!,
                      style: const TextStyle(fontSize: 13),
                    ),
                    if (lot.totalPrice != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        '${lot.totalPrice!.toStringAsFixed(2)}€',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ],

              if (lot.type == LotType.slaughter &&
                  lot.slaughterhouseName != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.factory, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      lot.slaughterhouseName!,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 12),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: onDuplicate,
                    icon: const Icon(Icons.content_copy, size: 16),
                    label: Text(
                      AppLocalizations.of(context).translate('duplicate_lot'),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  if (isOpen) ...[
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete, size: 16),
                      label: Text(
                        AppLocalizations.of(context).translate('delete'),
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
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
        return Colors.blue;
      case LotType.sale:
        return Colors.green;
      case LotType.slaughter:
        return Colors.grey;
      case null:
        return Colors.orange;
    }
  }
}
