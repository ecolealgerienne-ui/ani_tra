// lib/screens/lot_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/lot_provider.dart';
import '../../providers/animal_provider.dart';
import '../../models/lot.dart';
import '../../models/animal.dart';
import '../../i18n/app_localizations.dart';
import '../lot/lot_scan_screen.dart';
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
        title: const Text('Détail du Lot'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, value),
            itemBuilder: (context) {
              final lot = context.read<LotProvider>().getLotById(lotId);
              if (lot == null) return [];

              return [
                if (!lot.completed)
                  const PopupMenuItem(
                    value: 'rename',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18),
                        SizedBox(width: 8),
                        Text('Renommer'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'duplicate',
                  child: Row(
                    children: [
                      Icon(Icons.content_copy, size: 18),
                      SizedBox(width: 8),
                      Text('Dupliquer'),
                    ],
                  ),
                ),
                if (!lot.completed)
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
              ];
            },
          ),
        ],
      ),
      body: Consumer2<LotProvider, AnimalProvider>(
        builder: (context, lotProvider, animalProvider, child) {
          final lot = lotProvider.getLotById(lotId);

          if (lot == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Lot introuvable',
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

          final animals = _getAnimalsInLot(lot, animalProvider);

          return ListView(
            children: [
              _buildHeader(context, lot),
              _buildStatusSection(context, lot),
              if (lot.type != null) _buildTypeSection(context, lot),
              _buildStatisticsSection(context, lot, animals),
              _buildAnimalsSection(context, lot, animals),
              if (!lot.completed) _buildActionsSection(context, lot),
              const SizedBox(height: 80),
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
      if (animal != null) animals.add(animal);
    }
    return animals;
  }

  Widget _buildHeader(BuildContext context, Lot lot) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getTypeColor(lot).withValues(alpha: 0.2),
            _getTypeColor(lot).withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _getTypeColor(lot).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                lot.type?.icon ?? '📋',
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            lot.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade700),
              const SizedBox(width: 6),
              Text(
                DateFormat('dd/MM/yyyy').format(lot.createdAt),
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context, Lot lot) {
    final l10n = AppLocalizations.of(context);
    final isCompleted = lot.completed;
    final statusColor = isCompleted ? Colors.grey : Colors.green;
    final statusIcon = isCompleted ? Icons.lock : Icons.lock_open;
    final statusText = l10n.translate(isCompleted ? 'lot_closed' : 'lot_open');

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
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
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
                  if (isCompleted && lot.completedAt != null)
                    Text(
                      'Le ${DateFormat('dd/MM/yyyy').format(lot.completedAt!)}',
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSection(BuildContext context, Lot lot) {
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
                  Icon(Icons.category, color: _getTypeColor(lot)),
                  const SizedBox(width: 12),
                  Text(
                    'Type: ${lot.type!.label}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Traitement
              if (lot.type == LotType.treatment && lot.productName != null) ...[
                _buildInfoRow('Produit', lot.productName!, Icons.medication),
                if (lot.treatmentDate != null) ...[
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    'Date traitement',
                    DateFormat('dd/MM/yyyy').format(lot.treatmentDate!),
                    Icons.calendar_today,
                  ),
                ],
                if (lot.veterinarianName != null) ...[
                  const SizedBox(height: 12),
                  _buildInfoRow(
                      'Vétérinaire', lot.veterinarianName!, Icons.person),
                ],
              ],

              // Vente
              if (lot.type == LotType.sale) ...[
                if (lot.buyerName != null)
                  _buildInfoRow('Acheteur', lot.buyerName!, Icons.person),
                if (lot.totalPrice != null) ...[
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    'Prix total',
                    '${lot.totalPrice!.toStringAsFixed(2)}€',
                    Icons.euro,
                  ),
                ],
                if (lot.pricePerAnimal != null) ...[
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    'Prix par animal',
                    '${lot.pricePerAnimal!.toStringAsFixed(2)}€',
                    Icons.attach_money,
                  ),
                ],
              ],

              // Abattage
              if (lot.type == LotType.slaughter &&
                  lot.slaughterhouseName != null) ...[
                _buildInfoRow(
                    'Abattoir', lot.slaughterhouseName!, Icons.factory),
                if (lot.slaughterDate != null) ...[
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    'Date',
                    DateFormat('dd/MM/yyyy').format(lot.slaughterDate!),
                    Icons.calendar_today,
                  ),
                ],
              ],

              // Notes
              if (lot.notes != null && lot.notes!.isNotEmpty) ...[
                const Divider(height: 24),
                Text(
                  'Notes',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(lot.notes!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsSection(
      BuildContext context, Lot lot, List<Animal> animals) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Animaux',
              '${lot.animalCount}',
              Icons.pets,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Mâles',
              '${animals.where((a) => a.sex == AnimalSex.male).length}',
              Icons.male,
              Colors.blue.shade700,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Femelles',
              '${animals.where((a) => a.sex == AnimalSex.female).length}',
              Icons.female,
              Colors.pink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
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
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalsSection(
      BuildContext context, Lot lot, List<Animal> animals) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Animaux',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (!lot.completed)
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LotScanScreen(lotId: lot.id),
                      ),
                    );
                  },
                  icon: const Icon(Icons.nfc, size: 18),
                  label: const Text('Scanner'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (animals.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.pets_outlined,
                        size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 8),
                    Text(
                      'Aucun animal',
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade600),
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
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: animal.sex == AnimalSex.male
              ? Colors.blue.withValues(alpha: 0.2)
              : Colors.pink.withValues(alpha: 0.2),
          child: Icon(
            animal.sex == AnimalSex.male ? Icons.male : Icons.female,
            color: animal.sex == AnimalSex.male ? Colors.blue : Colors.pink,
          ),
        ),
        title: Text(animal.displayName),
        subtitle: Text(animal.displayName),
        trailing: !lot.completed
            ? IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () {
                  context
                      .read<LotProvider>()
                      .removeAnimalFromLot(lot.id, animal.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Animal retiré'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
              )
            : null,
      ),
    );
  }

  Widget _buildActionsSection(BuildContext context, Lot lot) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: lot.animalIds.isEmpty
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
              label: Text(l10n.translate('finalize_lot')),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
              label: const Text('Fermer'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
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
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Color _getTypeColor(Lot lot) {
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
        title: const Text('Renommer le lot'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nouveau nom',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              context
                  .read<LotProvider>()
                  .renameLot(lot.id, controller.text.trim());
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Lot renommé'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Renommer'),
          ),
        ],
      ),
    );
  }

  void _showDuplicateDialog(BuildContext context, Lot lot) {
    final nameController = TextEditingController(text: '${lot.name} (copie)');
    bool keepType = lot.type != null;
    bool keepAnimals = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Dupliquer le lot'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nouveau nom'),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Conserver les animaux'),
                subtitle: Text('${lot.animalCount} animaux'),
                value: keepAnimals,
                onChanged: (val) => setState(() => keepAnimals = val ?? true),
              ),
              if (lot.type != null)
                CheckboxListTile(
                  title: const Text('Conserver le type'),
                  subtitle: Text(lot.type!.label),
                  value: keepType,
                  onChanged: (val) => setState(() => keepType = val ?? false),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                final duplicated = context.read<LotProvider>().duplicateLot(
                      lot,
                      newName: nameController.text.trim(),
                      keepType: keepType,
                      keepAnimals: keepAnimals,
                    );

                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LotDetailScreen(lotId: duplicated.id),
                  ),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lot dupliqué'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Dupliquer'),
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
        title: const Text('Supprimer le lot'),
        content: Text('Supprimer "${lot.name}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<LotProvider>().deleteLot(lot.id);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Lot supprimé'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
