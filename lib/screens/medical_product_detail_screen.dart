// lib/screens/medical_product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/medical_product_provider.dart';
import '../models/medical_product.dart';
import 'package:intl/intl.dart';

class MedicalProductDetailScreen extends StatefulWidget {
  final String productId;

  const MedicalProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  State<MedicalProductDetailScreen> createState() =>
      _MedicalProductDetailScreenState();
}

class _MedicalProductDetailScreenState extends State<MedicalProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<MedicalProductProvider>();
    final product = productProvider.getProductById(widget.productId);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Produit non trouvé')),
        body: const Center(
          child: Text('Le produit demandé n\'existe pas'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(product.displayName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ouvrir écran d\'édition'),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteDialog(context, product);
              } else if (value == 'duplicate') {
                _duplicateProduct(context, product);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'duplicate',
                child: Row(
                  children: [
                    Icon(Icons.copy),
                    SizedBox(width: 8),
                    Text('Dupliquer'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Supprimer', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.info), text: 'Infos'),
            Tab(icon: Icon(Icons.inventory), text: 'Stock'),
            Tab(icon: Icon(Icons.history), text: 'Historique'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _InfoTab(product: product),
          _StockTab(product: product),
          _HistoryTab(product: product),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, MedicalProduct product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le produit'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer ${product.displayName} ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<MedicalProductProvider>().deleteProduct(product.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to list
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Produit supprimé'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _duplicateProduct(BuildContext context, MedicalProduct product) {
    final newProduct = product.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '${product.name} (Copie)',
      createdAt: DateTime.now(),
      updatedAt: null,
    );
    context.read<MedicalProductProvider>().addProduct(newProduct);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Produit dupliqué'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

// ============================================================================
// TAB 1: INFORMATIONS
// ============================================================================
class _InfoTab extends StatelessWidget {
  final MedicalProduct product;

  const _InfoTab({required this.product});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Alertes
        if (product.isExpired)
          _AlertCard(
            icon: Icons.error,
            title: 'Produit expiré',
            message: 'Ce produit a dépassé sa date d\'expiration',
            color: Colors.red,
          ),
        if (product.isExpiringSoon && !product.isExpired)
          _AlertCard(
            icon: Icons.schedule,
            title: 'Expire bientôt',
            message: 'Ce produit expire dans moins de 30 jours',
            color: Colors.orange,
          ),
        if (product.isLowStock)
          _AlertCard(
            icon: Icons.inventory_2,
            title: 'Stock faible',
            message: 'Le stock est en dessous du minimum recommandé',
            color: Colors.orange,
          ),

        // Informations générales
        _SectionTitle('Informations générales'),
        _InfoCard(
          children: [
            _InfoRow('Nom générique', product.name),
            if (product.commercialName != null)
              _InfoRow('Nom commercial', product.commercialName!),
            _InfoRow('Catégorie', product.category),
            if (product.activeIngredient != null)
              _InfoRow('Principe actif', product.activeIngredient!),
            if (product.manufacturer != null)
              _InfoRow('Fabricant', product.manufacturer!),
            if (product.form != null) _InfoRow('Forme', product.form!),
            if (product.dosage != null && product.dosageUnit != null)
              _InfoRow('Dosage', '${product.dosage} ${product.dosageUnit}'),
          ],
        ),

        const SizedBox(height: 16),

        // Délais d'attente
        _SectionTitle('Délais d\'attente'),
        _InfoCard(
          children: [
            _InfoRow(
              'Viande',
              '${product.withdrawalPeriodMeat} jours',
              icon: Icons.access_time,
              iconColor: Colors.red,
            ),
            _InfoRow(
              'Lait',
              product.withdrawalPeriodMilk > 0
                  ? '${product.withdrawalPeriodMilk} jours'
                  : 'Aucun',
              icon: Icons.opacity,
              iconColor: Colors.blue,
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Stock et prix
        _SectionTitle('Stock et prix'),
        _InfoCard(
          children: [
            _InfoRow(
              'Stock actuel',
              '${product.currentStock} ${product.stockUnit}',
              icon: Icons.inventory,
              iconColor: product.isLowStock ? Colors.orange : Colors.green,
            ),
            _InfoRow(
              'Stock minimum',
              '${product.minStock} ${product.stockUnit}',
              icon: Icons.warning,
              iconColor: Colors.orange,
            ),
            if (product.unitPrice != null)
              _InfoRow(
                'Prix unitaire',
                '${product.unitPrice!.toStringAsFixed(2)} ${product.currency ?? 'EUR'}',
                icon: Icons.euro,
                iconColor: Colors.green,
              ),
            if (product.unitPrice != null)
              _InfoRow(
                'Valeur stock',
                '${(product.currentStock * product.unitPrice!).toStringAsFixed(2)} ${product.currency ?? 'EUR'}',
                icon: Icons.account_balance_wallet,
                iconColor: Colors.purple,
              ),
          ],
        ),

        const SizedBox(height: 16),

        // Lot et expiration
        _SectionTitle('Lot et péremption'),
        _InfoCard(
          children: [
            if (product.batchNumber != null)
              _InfoRow('Numéro de lot', product.batchNumber!),
            if (product.expiryDate != null)
              _InfoRow(
                'Date d\'expiration',
                DateFormat('dd/MM/yyyy').format(product.expiryDate!),
                icon: Icons.event,
                iconColor: product.isExpired
                    ? Colors.red
                    : product.isExpiringSoon
                        ? Colors.orange
                        : Colors.blue,
              ),
            if (product.storageConditions != null)
              _InfoRow('Conservation', product.storageConditions!,
                  icon: Icons.thermostat, iconColor: Colors.blue),
          ],
        ),

        const SizedBox(height: 16),

        // Prescription et notes
        _SectionTitle('Informations complémentaires'),
        _InfoCard(
          children: [
            if (product.prescription != null)
              _InfoRow('Prescription', product.prescription!,
                  icon: Icons.description, iconColor: Colors.red),
            if (product.notes != null)
              _InfoRow('Notes', product.notes!,
                  icon: Icons.notes, iconColor: Colors.grey),
          ],
        ),

        const SizedBox(height: 16),

        // Métadonnées
        _SectionTitle('Métadonnées'),
        _InfoCard(
          children: [
            _InfoRow(
              'Date de création',
              DateFormat('dd/MM/yyyy à HH:mm').format(product.createdAt),
            ),
            if (product.updatedAt != null)
              _InfoRow(
                'Dernière modification',
                DateFormat('dd/MM/yyyy à HH:mm').format(product.updatedAt!),
              ),
            _InfoRow('Statut', product.isActive ? 'Actif' : 'Inactif'),
          ],
        ),

        const SizedBox(height: 80),
      ],
    );
  }
}

// ============================================================================
// TAB 2: STOCK
// ============================================================================
class _StockTab extends StatefulWidget {
  final MedicalProduct product;

  const _StockTab({required this.product});

  @override
  State<_StockTab> createState() => _StockTabState();
}

class _StockTabState extends State<_StockTab> {
  final _quantityController = TextEditingController();

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final stockPercentage =
        (product.currentStock / product.minStock * 100).clamp(0, 100);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Stock status card
        Card(
          color:
              product.isLowStock ? Colors.orange.shade50 : Colors.green.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      product.isLowStock
                          ? Icons.inventory_2
                          : Icons.check_circle,
                      size: 48,
                      color: product.isLowStock
                          ? Colors.orange.shade700
                          : Colors.green.shade700,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${product.currentStock} ${product.stockUnit}',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: product.isLowStock
                                  ? Colors.orange.shade700
                                  : Colors.green.shade700,
                            ),
                          ),
                          Text(
                            product.isLowStock
                                ? 'Stock faible'
                                : 'Stock suffisant',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: stockPercentage / 100,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    product.isLowStock ? Colors.orange : Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${stockPercentage.toStringAsFixed(0)}% du minimum',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Actions rapides
        const Text(
          'Actions rapides',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showStockDialog(context, true),
                icon: const Icon(Icons.add),
                label: const Text('Ajouter'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showStockDialog(context, false),
                icon: const Icon(Icons.remove),
                label: const Text('Retirer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        OutlinedButton.icon(
          onPressed: () => _showAdjustStockDialog(context),
          icon: const Icon(Icons.edit),
          label: const Text('Ajuster le stock manuellement'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),

        const SizedBox(height: 24),

        // Informations de stock
        const Text(
          'Informations',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        _InfoCard(
          children: [
            _InfoRow(
                'Stock actuel', '${product.currentStock} ${product.stockUnit}'),
            _InfoRow(
                'Stock minimum', '${product.minStock} ${product.stockUnit}'),
            _InfoRow(
              'Différence',
              '${(product.currentStock - product.minStock).toStringAsFixed(1)} ${product.stockUnit}',
              iconColor: product.isLowStock ? Colors.orange : Colors.green,
            ),
            if (product.unitPrice != null) ...[
              const Divider(),
              _InfoRow(
                'Prix unitaire',
                '${product.unitPrice!.toStringAsFixed(2)} ${product.currency ?? 'EUR'}',
              ),
              _InfoRow(
                'Valeur totale',
                '${(product.currentStock * product.unitPrice!).toStringAsFixed(2)} ${product.currency ?? 'EUR'}',
              ),
            ],
          ],
        ),

        const SizedBox(height: 24),

        // Historique simulé
        const Text(
          'Mouvements récents',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        _buildMockStockHistory(),
      ],
    );
  }

  Widget _buildMockStockHistory() {
    // Simuler un historique de mouvements
    final movements = [
      {
        'type': 'add',
        'quantity': 10.0,
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'reason': 'Réception commande',
      },
      {
        'type': 'remove',
        'quantity': 5.0,
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'reason': 'Traitement vache #1234',
      },
      {
        'type': 'remove',
        'quantity': 3.0,
        'date': DateTime.now().subtract(const Duration(days: 8)),
        'reason': 'Traitement vache #5678',
      },
      {
        'type': 'add',
        'quantity': 20.0,
        'date': DateTime.now().subtract(const Duration(days: 15)),
        'reason': 'Réception commande',
      },
    ];

    return Column(
      children: movements.map((movement) {
        final isAdd = movement['type'] == 'add';
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isAdd
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              child: Icon(
                isAdd ? Icons.add : Icons.remove,
                color: isAdd ? Colors.green : Colors.orange,
              ),
            ),
            title: Text(
              '${isAdd ? '+' : '-'}${movement['quantity']} ${widget.product.stockUnit}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isAdd ? Colors.green : Colors.orange,
              ),
            ),
            subtitle: Text(movement['reason'] as String),
            trailing: Text(
              DateFormat('dd/MM/yyyy').format(movement['date'] as DateTime),
              style: const TextStyle(fontSize: 11),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showStockDialog(BuildContext context, bool isAddition) {
    _quantityController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isAddition ? 'Ajouter au stock' : 'Retirer du stock'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantité (${widget.product.stockUnit})',
                border: const OutlineInputBorder(),
                prefixIcon: Icon(isAddition ? Icons.add : Icons.remove),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Motif (optionnel)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes),
              ),
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
              final quantity = double.tryParse(_quantityController.text);
              if (quantity != null && quantity > 0) {
                context.read<MedicalProductProvider>().updateStock(
                      widget.product.id,
                      quantity,
                      isAddition: isAddition,
                    );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isAddition
                          ? 'Stock ajouté avec succès'
                          : 'Stock retiré avec succès',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }

  void _showAdjustStockDialog(BuildContext context) {
    _quantityController.text = widget.product.currentStock.toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajuster le stock'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nouveau stock (${widget.product.stockUnit})',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Stock actuel: ${widget.product.currentStock} ${widget.product.stockUnit}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
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
              final newStock = double.tryParse(_quantityController.text);
              if (newStock != null && newStock >= 0) {
                context.read<MedicalProductProvider>().adjustStock(
                      widget.product.id,
                      newStock,
                    );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Stock ajusté avec succès'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TAB 3: HISTORIQUE
// ============================================================================
class _HistoryTab extends StatelessWidget {
  final MedicalProduct product;

  const _HistoryTab({required this.product});

  @override
  Widget build(BuildContext context) {
    // Simuler un historique d'utilisation
    final usageHistory = [
      {
        'animal': 'Vache #1234',
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'quantity': 5.0,
        'reason': 'Traitement mastite',
        'veterinarian': 'Dr. Martin',
      },
      {
        'animal': 'Vache #5678',
        'date': DateTime.now().subtract(const Duration(days: 7)),
        'quantity': 5.0,
        'reason': 'Traitement boiterie',
        'veterinarian': 'Dr. Martin',
      },
      {
        'animal': 'Brebis #9012',
        'date': DateTime.now().subtract(const Duration(days: 12)),
        'quantity': 3.0,
        'reason': 'Infection respiratoire',
        'veterinarian': 'Dr. Dubois',
      },
      {
        'animal': 'Vache #3456',
        'date': DateTime.now().subtract(const Duration(days: 18)),
        'quantity': 5.0,
        'reason': 'Traitement préventif',
        'veterinarian': 'Dr. Martin',
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Statistiques d'utilisation
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Statistiques d\'utilisation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatColumn(
                      label: 'Total utilisé',
                      value: '18 ${product.stockUnit}',
                      icon: Icons.medication,
                      color: Colors.blue,
                    ),
                    _StatColumn(
                      label: 'Animaux traités',
                      value: '4',
                      icon: Icons.pets,
                      color: Colors.green,
                    ),
                    _StatColumn(
                      label: 'Traitements',
                      value: '4',
                      icon: Icons.healing,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Historique des traitements',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        ...usageHistory.map((usage) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.pets,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                usage['animal'] as String,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat('dd/MM/yyyy à HH:mm')
                                    .format(usage['date'] as DateTime),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${usage['quantity']} ${product.stockUnit}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.medical_services, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          usage['reason'] as String,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.person, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          usage['veterinarian'] as String,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),

        const SizedBox(height: 80),
      ],
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatColumn({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
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
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// WIDGETS COMMUNS
// ============================================================================
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;

  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;

  const _InfoRow(
    this.label,
    this.value, {
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: iconColor ?? Colors.grey),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Color color;

  const _AlertCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 13,
                      color: color.withOpacity(0.8),
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
}
