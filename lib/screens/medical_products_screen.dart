// lib/screens/medical_products_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/medical_product_provider.dart';
import '../models/medical_product.dart';
import '../i18n/app_localizations.dart';
import 'package:intl/intl.dart';

class MedicalProductsScreen extends StatefulWidget {
  const MedicalProductsScreen({super.key});

  @override
  State<MedicalProductsScreen> createState() => _MedicalProductsScreenState();
}

class _MedicalProductsScreenState extends State<MedicalProductsScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'Tous';
  String _sortBy = 'name'; // name, stock, expiry

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<MedicalProductProvider>();
    final l10n = AppLocalizations.of(context);

    // Filtrer les produits
    List<MedicalProduct> filteredProducts = productProvider.activeProducts;

    if (_searchQuery.isNotEmpty) {
      filteredProducts = productProvider.searchProducts(_searchQuery);
    }

    if (_selectedCategory != 'Tous') {
      filteredProducts = filteredProducts
          .where((p) => p.category == _selectedCategory)
          .toList();
    }

    // Trier les produits
    filteredProducts.sort((a, b) {
      switch (_sortBy) {
        case 'stock':
          return a.currentStock.compareTo(b.currentStock);
        case 'expiry':
          if (a.expiryDate == null) return 1;
          if (b.expiryDate == null) return -1;
          return a.expiryDate!.compareTo(b.expiryDate!);
        case 'name':
        default:
          return a.displayName.compareTo(b.displayName);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produits sanitaires'),
        actions: [
          // Alertes
          if (productProvider.hasAlerts())
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.warning),
                  onPressed: () => _showAlertsDialog(context, productProvider),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${productProvider.getTotalAlerts()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          // Menu
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'sort') {
                _showSortDialog(context);
              } else if (value == 'stats') {
                _showStatsDialog(context, productProvider);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'sort',
                child: Row(
                  children: [
                    Icon(Icons.sort),
                    SizedBox(width: 8),
                    Text('Trier'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'stats',
                child: Row(
                  children: [
                    Icon(Icons.bar_chart),
                    SizedBox(width: 8),
                    Text('Statistiques'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un produit...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),

          // Filtres par catégorie
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _CategoryChip(
                  label: 'Tous',
                  count: productProvider.activeProducts.length,
                  isSelected: _selectedCategory == 'Tous',
                  onTap: () {
                    setState(() => _selectedCategory = 'Tous');
                  },
                ),
                ...productProvider.categories.map((category) {
                  final count =
                      productProvider.getProductsByCategory(category).length;
                  return _CategoryChip(
                    label: category,
                    count: count,
                    isSelected: _selectedCategory == category,
                    onTap: () {
                      setState(() => _selectedCategory = category);
                    },
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Stats rapides
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                if (productProvider.lowStockProducts.isNotEmpty)
                  _QuickStatChip(
                    icon: Icons.inventory_2,
                    label:
                        '${productProvider.lowStockProducts.length} stock faible',
                    color: Colors.orange,
                  ),
                if (productProvider.expiringSoonProducts.isNotEmpty)
                  _QuickStatChip(
                    icon: Icons.schedule,
                    label:
                        '${productProvider.expiringSoonProducts.length} expire bientôt',
                    color: Colors.blue,
                  ),
                if (productProvider.expiredProducts.isNotEmpty)
                  _QuickStatChip(
                    icon: Icons.error,
                    label: '${productProvider.expiredProducts.length} expiré',
                    color: Colors.red,
                  ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Liste des produits
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.medical_services_outlined,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'Aucun produit trouvé'
                              : 'Aucun produit',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return _ProductCard(product: product);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to add product screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ouvrir add_medical_product_screen.dart'),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
    );
  }

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Trier par'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Nom'),
              value: 'name',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() => _sortBy = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Stock (croissant)'),
              value: 'stock',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() => _sortBy = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Date d\'expiration'),
              value: 'expiry',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() => _sortBy = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showStatsDialog(BuildContext context, MedicalProductProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Statistiques'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatRow(
              icon: Icons.medical_services,
              label: 'Total produits actifs',
              value: '${provider.stats['total']}',
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            _StatRow(
              icon: Icons.inventory_2,
              label: 'Stock faible',
              value: '${provider.stats['lowStock']}',
              color: Colors.orange,
            ),
            const SizedBox(height: 12),
            _StatRow(
              icon: Icons.schedule,
              label: 'Expire bientôt',
              value: '${provider.stats['expiringSoon']}',
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            _StatRow(
              icon: Icons.error,
              label: 'Expiré',
              value: '${provider.stats['expired']}',
              color: Colors.red,
            ),
            const SizedBox(height: 12),
            _StatRow(
              icon: Icons.category,
              label: 'Catégories',
              value: '${provider.categories.length}',
              color: Colors.purple,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showAlertsDialog(
      BuildContext context, MedicalProductProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.orange),
            const SizedBox(width: 8),
            const Text('Alertes'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (provider.lowStockProducts.isNotEmpty) ...[
                const Text(
                  'Stock faible:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...provider.lowStockProducts.map((p) => ListTile(
                      dense: true,
                      leading: const Icon(Icons.inventory_2, size: 16),
                      title: Text(p.displayName,
                          style: const TextStyle(fontSize: 13)),
                      subtitle: Text('${p.currentStock} ${p.stockUnit}',
                          style: const TextStyle(fontSize: 11)),
                    )),
                const Divider(),
              ],
              if (provider.expiringSoonProducts.isNotEmpty) ...[
                const Text(
                  'Expire bientôt:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...provider.expiringSoonProducts.map((p) => ListTile(
                      dense: true,
                      leading: const Icon(Icons.schedule, size: 16),
                      title: Text(p.displayName,
                          style: const TextStyle(fontSize: 13)),
                      subtitle: Text(
                        p.expiryDate != null
                            ? DateFormat('dd/MM/yyyy').format(p.expiryDate!)
                            : '',
                        style: const TextStyle(fontSize: 11),
                      ),
                    )),
                const Divider(),
              ],
              if (provider.expiredProducts.isNotEmpty) ...[
                const Text(
                  'Expiré:',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                ...provider.expiredProducts.map((p) => ListTile(
                      dense: true,
                      leading:
                          const Icon(Icons.error, size: 16, color: Colors.red),
                      title: Text(p.displayName,
                          style: const TextStyle(fontSize: 13)),
                      subtitle: Text(
                        p.expiryDate != null
                            ? DateFormat('dd/MM/yyyy').format(p.expiryDate!)
                            : '',
                        style: const TextStyle(fontSize: 11, color: Colors.red),
                      ),
                    )),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}

// Widgets personnalisés
class _CategoryChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text('$label ($count)'),
        selected: isSelected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _QuickStatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickStatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        avatar: Icon(icon, size: 16, color: color),
        label: Text(
          label,
          style: TextStyle(fontSize: 11, color: color),
        ),
        backgroundColor: color.withOpacity(0.1),
        side: BorderSide(color: color),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final MedicalProduct product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // Navigate to detail screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ouvrir détails: ${product.displayName}'),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icône catégorie
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getCategoryColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(),
                      color: _getCategoryColor(),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Nom et catégorie
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.displayName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getCategoryColor().withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                product.category,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _getCategoryColor(),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (product.manufacturer != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                product.manufacturer!,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Badges alertes
                  Column(
                    children: [
                      if (product.isLowStock)
                        const Icon(Icons.inventory_2,
                            color: Colors.orange, size: 20),
                      if (product.isExpiringSoon)
                        const Icon(Icons.schedule,
                            color: Colors.blue, size: 20),
                      if (product.isExpired)
                        const Icon(Icons.error, color: Colors.red, size: 20),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Informations complémentaires
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.inventory,
                    label: '${product.currentStock} ${product.stockUnit}',
                    color: product.isLowStock ? Colors.orange : Colors.green,
                  ),
                  const SizedBox(width: 8),
                  _InfoChip(
                    icon: Icons.access_time,
                    label: 'Viande: ${product.withdrawalPeriodMeat}j',
                    color: Colors.blue,
                  ),
                  if (product.withdrawalPeriodMilk > 0) ...[
                    const SizedBox(width: 8),
                    _InfoChip(
                      icon: Icons.opacity,
                      label: 'Lait: ${product.withdrawalPeriodMilk}j',
                      color: Colors.purple,
                    ),
                  ],
                ],
              ),
              if (product.expiryDate != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.event,
                      size: 14,
                      color: product.isExpired
                          ? Colors.red
                          : product.isExpiringSoon
                              ? Colors.orange
                              : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Expire: ${DateFormat('dd/MM/yyyy').format(product.expiryDate!)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: product.isExpired
                            ? Colors.red
                            : product.isExpiringSoon
                                ? Colors.orange
                                : Colors.grey.shade600,
                        fontWeight: product.isExpired || product.isExpiringSoon
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor() {
    switch (product.category) {
      case 'Antibiotique':
        return Colors.red;
      case 'Anti-inflammatoire':
        return Colors.orange;
      case 'Antiparasitaire':
        return Colors.green;
      case 'Vaccin':
        return Colors.blue;
      case 'Corticoïde':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon() {
    switch (product.category) {
      case 'Antibiotique':
        return Icons.medication;
      case 'Anti-inflammatoire':
        return Icons.healing;
      case 'Antiparasitaire':
        return Icons.bug_report;
      case 'Vaccin':
        return Icons.vaccines;
      case 'Corticoïde':
        return Icons.medical_services;
      default:
        return Icons.medication;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
