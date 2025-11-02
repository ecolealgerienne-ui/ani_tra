// screens/weight_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/weight_record.dart';
import '../../models/animal.dart';
import '../../providers/weight_provider.dart';
import '../../providers/animal_provider.dart';
import '../weight/weight_record_screen.dart';
import '../animal/animal_weight_history_screen.dart';

/// Écran de liste des pesées
///
/// Affiche toutes les pesées avec :
/// - Filtres par animal, date, source
/// - Tri par date
/// - Navigation vers détails/historique
class WeightListScreen extends StatefulWidget {
  const WeightListScreen({super.key});

  @override
  State<WeightListScreen> createState() => _WeightListScreenState();
}

class _WeightListScreenState extends State<WeightListScreen> {
  String? _filterAnimalId;
  WeightSource? _filterSource;
  String _sortBy = 'date_desc'; // date_desc, date_asc, weight_desc, weight_asc

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesées'),
        actions: [
          // Filtres
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
          // Tri
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'date_desc',
                child: Text('Date (plus récent)'),
              ),
              const PopupMenuItem(
                value: 'date_asc',
                child: Text('Date (plus ancien)'),
              ),
              const PopupMenuItem(
                value: 'weight_desc',
                child: Text('Poids (décroissant)'),
              ),
              const PopupMenuItem(
                value: 'weight_asc',
                child: Text('Poids (croissant)'),
              ),
            ],
          ),
        ],
      ),
      body: Consumer2<WeightProvider, AnimalProvider>(
        builder: (context, weightProvider, animalProvider, child) {
          var weights = weightProvider.weights.toList();

          // Appliquer les filtres
          if (_filterAnimalId != null) {
            weights =
                weights.where((w) => w.animalId == _filterAnimalId).toList();
          }
          if (_filterSource != null) {
            weights = weights.where((w) => w.source == _filterSource).toList();
          }

          // Appliquer le tri
          weights = _sortWeights(weights);

          if (weights.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              // Filtres actifs
              if (_filterAnimalId != null || _filterSource != null)
                _buildActiveFilters(animalProvider),

              // Statistiques rapides
              _buildQuickStats(weightProvider, weights),

              // Liste
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: weights.length,
                  itemBuilder: (context, index) {
                    final weight = weights[index];
                    final animal =
                        animalProvider.getAnimalById(weight.animalId);
                    return _WeightCard(
                      weight: weight,
                      animal: animal,
                      onTap: () => _showWeightDetails(weight, animal),
                      onDelete: () => _deleteWeight(weight),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WeightRecordScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle Pesée'),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Trier les pesées
  List<WeightRecord> _sortWeights(List<WeightRecord> weights) {
    switch (_sortBy) {
      case 'date_asc':
        weights.sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
        break;
      case 'weight_desc':
        weights.sort((a, b) => b.weight.compareTo(a.weight));
        break;
      case 'weight_asc':
        weights.sort((a, b) => a.weight.compareTo(b.weight));
        break;
      case 'date_desc':
      default:
        weights.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
        break;
    }
    return weights;
  }

  /// Widget: État vide
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.monitor_weight, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 24),
            Text(
              'Aucune pesée',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Commencez par enregistrer\nune première pesée',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget: Filtres actifs
  Widget _buildActiveFilters(AnimalProvider animalProvider) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.blue.shade50,
      child: Row(
        children: [
          const Icon(Icons.filter_list, size: 18, color: Colors.blue),
          const SizedBox(width: 8),
          const Text('Filtres actifs:',
              style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          if (_filterAnimalId != null) ...[
            Chip(
              label: Text(
                animalProvider
                        .getAnimalById(_filterAnimalId!)
                        ?.officialNumber ??
                    'Animal',
                style: const TextStyle(fontSize: 12),
              ),
              onDeleted: () {
                setState(() {
                  _filterAnimalId = null;
                });
              },
              deleteIcon: const Icon(Icons.close, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          if (_filterSource != null) ...[
            Chip(
              label: Text(_filterSource!.frenchName,
                  style: const TextStyle(fontSize: 12)),
              onDeleted: () {
                setState(() {
                  _filterSource = null;
                });
              },
              deleteIcon: const Icon(Icons.close, size: 16),
            ),
          ],
          const Spacer(),
          TextButton(
            onPressed: () {
              setState(() {
                _filterAnimalId = null;
                _filterSource = null;
              });
            },
            child: const Text('Effacer tout'),
          ),
        ],
      ),
    );
  }

  /// Widget: Statistiques rapides
  Widget _buildQuickStats(WeightProvider provider, List<WeightRecord> weights) {
    final total = weights.length;
    final unsyncedCount = weights.where((w) => !w.synced).length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.scale, 'Total', '$total'),
          _buildStatItem(Icons.sync_disabled, 'Non sync', '$unsyncedCount'),
          _buildStatItem(Icons.today, 'Aujourd\'hui',
              '${weights.where((w) => w.isToday).length}'),
        ],
      ),
    );
  }

  /// Widget: Item de statistique
  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.grey.shade700),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  /// Afficher les filtres
  Future<void> _showFilters() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filtres',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),

                  // Filtre par animal
                  ListTile(
                    leading: const Icon(Icons.pets),
                    title: const Text('Filtrer par animal'),
                    trailing: _filterAnimalId != null
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setModalState(() {
                                _filterAnimalId = null;
                              });
                              setState(() {});
                            },
                          )
                        : null,
                    onTap: () async {
                      // TODO: Sélecteur d'animal
                      Navigator.pop(context);
                    },
                  ),

                  // Filtre par source
                  const ListTile(
                    leading: Icon(Icons.source),
                    title: Text('Filtrer par source'),
                  ),

                  ...WeightSource.values.map((source) {
                    return RadioListTile<WeightSource>(
                      value: source,
                      groupValue: _filterSource,
                      onChanged: (value) {
                        setModalState(() {
                          _filterSource = value;
                        });
                        setState(() {});
                      },
                      title: Text('${source.icon} ${source.frenchName}'),
                    );
                  }).toList(),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              _filterAnimalId = null;
                              _filterSource = null;
                            });
                            setState(() {});
                          },
                          child: const Text('Réinitialiser'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Appliquer'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Afficher les détails d'une pesée
  void _showWeightDetails(WeightRecord weight, Animal? animal) {
    if (animal != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnimalWeightHistoryScreen(animal: animal),
        ),
      );
    }
  }

  /// Supprimer une pesée
  Future<void> _deleteWeight(WeightRecord weight) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer cette pesée ?'),
        content: Text(
            'Pesée du ${weight.formattedDate} : ${weight.formattedWeight}'),
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

    if (shouldDelete == true && mounted) {
      final weightProvider = context.read<WeightProvider>();
      weightProvider.removeWeight(weight.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pesée supprimée'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

/// Widget: Carte de pesée
class _WeightCard extends StatelessWidget {
  final WeightRecord weight;
  final Animal? animal;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _WeightCard({
    required this.weight,
    required this.animal,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icône source
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    weight.sourceIcon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Infos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Animal
                    Text(
                      animal?.officialNumber ?? weight.animalId,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Poids
                    Row(
                      children: [
                        Text(
                          weight.formattedWeight,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            weight.sourceLabel,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Date
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          weight.formattedDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        if (!weight.synced) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.sync_disabled,
                            size: 12,
                            color: Colors.orange.shade700,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
