// lib/screens/animal_list_screen.dart
// Artefact 16 : Liste Animaux Avancée avec Filtres et Group By
// Version : 1.3 - Ajout recherche par scan

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../providers/animal_provider.dart';
import '../models/animal.dart';
import '../i18n/app_localizations.dart';
import 'scan_screen.dart';
import 'add_animal_screen.dart';

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({super.key});

  @override
  State<AnimalListScreen> createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  final _searchController = TextEditingController();

  // Filtres
  Set<AnimalStatus> _selectedStatuses = {AnimalStatus.alive};
  Set<AnimalSex> _selectedSexes = {};
  Set<String> _selectedAgeRanges = {};
  bool? _hasActiveWithdrawal;
  String? _motherEidFilter;
  String? _batchIdFilter;

  // Group By
  GroupByOption _groupBy = GroupByOption.none;

  // État filtres drawer
  int get _activeFilterCount {
    int count = 0;
    if (_selectedStatuses.length < 4) count++;
    if (_selectedSexes.isNotEmpty) count++;
    if (_selectedAgeRanges.isNotEmpty) count++;
    if (_hasActiveWithdrawal != null) count++;
    if (_motherEidFilter != null && _motherEidFilter!.isNotEmpty) count++;
    if (_batchIdFilter != null) count++;
    return count;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Animal> _getFilteredAnimals(List<Animal> animals) {
    var filtered = animals;

    // Recherche texte
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered
          .where((a) =>
              a.eid.toLowerCase().contains(query) ||
              (a.officialNumber?.toLowerCase().contains(query) ?? false))
          .toList();
    }

    // Filtre statut
    if (_selectedStatuses.isNotEmpty) {
      filtered =
          filtered.where((a) => _selectedStatuses.contains(a.status)).toList();
    }

    // Filtre sexe
    if (_selectedSexes.isNotEmpty) {
      filtered = filtered.where((a) => _selectedSexes.contains(a.sex)).toList();
    }

    // Filtre âge
    if (_selectedAgeRanges.isNotEmpty) {
      filtered = filtered.where((a) {
        final months = a.ageInMonths;
        for (final range in _selectedAgeRanges) {
          if (range == '< 6m' && months < 6) return true;
          if (range == '6-12m' && months >= 6 && months < 12) return true;
          if (range == '1-2 ans' && months >= 12 && months < 24) return true;
          if (range == '> 2 ans' && months >= 24) return true;
        }
        return false;
      }).toList();
    }

    // Filtre rémanence
    if (_hasActiveWithdrawal != null) {
      final animalProvider = context.read<AnimalProvider>();
      filtered = filtered.where((a) {
        final hasActive = animalProvider.hasActiveWithdrawal(a.id);
        return hasActive == _hasActiveWithdrawal;
      }).toList();
    }

    // Filtre mère
    if (_motherEidFilter != null && _motherEidFilter!.isNotEmpty) {
      filtered = filtered.where((a) {
        if (a.motherId == null) return false;
        final mother =
            context.read<AnimalProvider>().getAnimalById(a.motherId!);
        return mother?.eid
                .toLowerCase()
                .contains(_motherEidFilter!.toLowerCase()) ??
            false;
      }).toList();
    }

    return filtered;
  }

  Map<String, List<Animal>> _getGroupedAnimals(List<Animal> animals) {
    final groups = <String, List<Animal>>{};

    switch (_groupBy) {
      case GroupByOption.none:
        return {'all': animals};

      case GroupByOption.sex:
        for (final animal in animals) {
          final key = animal.sex == AnimalSex.male ? '♂️ Mâles' : '♀️ Femelles';
          groups.putIfAbsent(key, () => []).add(animal);
        }
        break;

      case GroupByOption.age:
        for (final animal in animals) {
          final months = animal.ageInMonths;
          String key;
          if (months < 6) {
            key = '🐑 < 6 mois';
          } else if (months < 12) {
            key = '🐑 6-12 mois';
          } else if (months < 24) {
            key = '🐏 1-2 ans';
          } else {
            key = '🐏 > 2 ans';
          }
          groups.putIfAbsent(key, () => []).add(animal);
        }
        break;

      case GroupByOption.status:
        for (final animal in animals) {
          String key;
          switch (animal.status) {
            case AnimalStatus.alive:
              key = '🟢 Vivants';
              break;
            case AnimalStatus.sold:
              key = '🟠 Vendus';
              break;
            case AnimalStatus.dead:
              key = '🔴 Morts';
              break;
            case AnimalStatus.slaughtered:
              key = '🏭 Abattus';
              break;
          }
          groups.putIfAbsent(key, () => []).add(animal);
        }
        break;

      case GroupByOption.withdrawal:
        final animalProvider = context.read<AnimalProvider>();
        for (final animal in animals) {
          final hasActive = animalProvider.hasActiveWithdrawal(animal.id);
          final key =
              hasActive ? '⚠️ Rémanence Active' : '✅ Rémanence Inactive';
          groups.putIfAbsent(key, () => []).add(animal);
        }
        break;

      case GroupByOption.mother:
        for (final animal in animals) {
          if (animal.motherId == null) {
            groups.putIfAbsent('❓ Mère inconnue', () => []).add(animal);
          } else {
            final mother =
                context.read<AnimalProvider>().getAnimalById(animal.motherId!);
            final key = mother != null
                ? '👩 ${mother.officialNumber ?? mother.eid}'
                : '❓ Mère inconnue';
            groups.putIfAbsent(key, () => []).add(animal);
          }
        }
        break;
    }

    return groups;
  }

  void _showFiltersDrawer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _FiltersDrawer(
        selectedStatuses: _selectedStatuses,
        selectedSexes: _selectedSexes,
        selectedAgeRanges: _selectedAgeRanges,
        hasActiveWithdrawal: _hasActiveWithdrawal,
        motherEidFilter: _motherEidFilter,
        onApply: (statuses, sexes, ageRanges, withdrawal, mother) {
          setState(() {
            _selectedStatuses = statuses;
            _selectedSexes = sexes;
            _selectedAgeRanges = ageRanges;
            _hasActiveWithdrawal = withdrawal;
            _motherEidFilter = mother;
          });
        },
        onReset: () {
          setState(() {
            _selectedStatuses = {AnimalStatus.alive};
            _selectedSexes = {};
            _selectedAgeRanges = {};
            _hasActiveWithdrawal = null;
            _motherEidFilter = null;
          });
        },
      ),
    );
  }

  /// 🆕 NOUVEAU : Afficher le dialogue de scan et recherche
  void _showScanAndSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => const _ScanAndSearchDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final animalProvider = context.watch<AnimalProvider>();
    final allAnimals = animalProvider.animals;
    final filteredAnimals = _getFilteredAnimals(allAnimals);
    final groupedAnimals = _getGroupedAnimals(filteredAnimals);

    return Scaffold(
      appBar: AppBar(
        title: Text('Animaux (${filteredAnimals.length})'),
        actions: [
          // 🆕 NOUVEAU : Bouton Scanner
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: AppLocalizations.of(context).translate('scan_to_search'),
            onPressed: _showScanAndSearchDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher EID ou n° officiel...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),

          // Filtres et Group By
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Bouton Filtres
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showFiltersDrawer,
                    icon: _activeFilterCount > 0
                        ? Badge(
                            label: Text('$_activeFilterCount'),
                            child: const Icon(Icons.filter_list),
                          )
                        : const Icon(Icons.filter_list),
                    label: const Text('Filtres'),
                  ),
                ),
                const SizedBox(width: 12),

                // Bouton Group By
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => _GroupBySheet(
                          currentValue: _groupBy,
                          onSelected: (value) {
                            setState(() => _groupBy = value);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                    icon: const Icon(Icons.group_work),
                    label: Text(_groupBy.label),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Liste des animaux
          Expanded(
            child: groupedAnimals.isEmpty
                ? _buildEmptyState()
                : _groupBy == GroupByOption.none
                    ? _buildAnimalList(groupedAnimals['all']!)
                    : _buildGroupedList(groupedAnimals),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddAnimalScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pets, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Aucun animal trouvé',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalList(List<Animal> animals) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: animals.length,
      itemBuilder: (context, index) {
        return _AnimalCard(animal: animals[index]);
      },
    );
  }

  Widget _buildGroupedList(Map<String, List<Animal>> groups) {
    final sortedKeys = groups.keys.toList();
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: sortedKeys.length,
      itemBuilder: (context, groupIndex) {
        final groupName = sortedKeys[groupIndex];
        final groupAnimals = groups[groupName]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête de groupe
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.grey.shade100,
              child: Row(
                children: [
                  Text(
                    groupName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${groupAnimals.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Animaux du groupe
            ...groupAnimals.map((animal) => _AnimalCard(animal: animal)),
          ],
        );
      },
    );
  }
}

// ==================== NOUVEAU DIALOGUE ====================

/// 🆕 Dialogue de scan et recherche
class _ScanAndSearchDialog extends StatefulWidget {
  const _ScanAndSearchDialog();

  @override
  State<_ScanAndSearchDialog> createState() => _ScanAndSearchDialogState();
}

class _ScanAndSearchDialogState extends State<_ScanAndSearchDialog> {
  bool _isScanning = false;
  String? _scannedEID;
  Animal? _foundAnimal;
  final _random = Random();

  /// Simuler le scan d'un EID
  Future<void> _simulateScan() async {
    setState(() {
      _isScanning = true;
      _scannedEID = null;
      _foundAnimal = null;
    });

    // Feedback haptique
    HapticFeedback.mediumImpact();

    // Simuler délai de scan
    await Future.delayed(const Duration(milliseconds: 800));

    final animalProvider = context.read<AnimalProvider>();
    final animals = animalProvider.animals;

    if (animals.isEmpty) {
      if (!mounted) return;
      setState(() {
        _isScanning = false;
      });
      return;
    }

    // Générer un EID "scanné" (prendre un animal aléatoire)
    final randomAnimal = animals[_random.nextInt(animals.length)];
    final scannedEID = randomAnimal.eid;

    // Rechercher l'animal
    final foundAnimal = animalProvider.findByEIDOrNumber(scannedEID);

    // Feedback haptique selon résultat
    if (foundAnimal != null) {
      HapticFeedback.heavyImpact(); // Succès
    } else {
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 100));
      HapticFeedback.heavyImpact(); // Double vibration pour "non trouvé"
    }

    if (!mounted) return;
    setState(() {
      _isScanning = false;
      _scannedEID = scannedEID;
      _foundAnimal = foundAnimal;
    });
  }

  /// Naviguer vers l'écran de détail de l'animal
  void _viewAnimalDetails() {
    if (_foundAnimal == null) return;

    Navigator.pop(context); // Fermer le dialogue
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ScanScreen(preloadedAnimal: _foundAnimal),
      ),
    );
  }

  /// Proposer d'ajouter l'animal non trouvé
  void _addAnimal() {
    if (_scannedEID == null) return;

    Navigator.pop(context); // Fermer le dialogue de scan
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddAnimalScreen(scannedEID: _scannedEID),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.qr_code_scanner, color: Colors.blue),
          const SizedBox(width: 8),
          Text(l10n.translate('scan_to_search')),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bouton Scanner
            SizedBox(
              width: double.infinity,
              height: 120,
              child: ElevatedButton(
                onPressed: _isScanning ? null : _simulateScan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isScanning
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(color: Colors.white),
                          const SizedBox(height: 12),
                          Text(l10n.translate('scanning')),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.nfc, size: 48),
                          const SizedBox(height: 8),
                          Text(
                            l10n.translate('scan_animal'),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
              ),
            ),

            // Résultat du scan
            if (_scannedEID != null) ...[
              const SizedBox(height: 20),

              // EID scanné
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.tag, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.translate('eid_scanned'),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            _scannedEID!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Animal trouvé
              if (_foundAnimal != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200, width: 2),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.green.shade700, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.translate('animal_found'),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 8),
                      _buildAnimalInfoRow(
                        Icons.tag,
                        'EID',
                        _foundAnimal!.eid,
                      ),
                      if (_foundAnimal!.officialNumber != null)
                        _buildAnimalInfoRow(
                          Icons.badge,
                          l10n.translate('official_number'),
                          _foundAnimal!.officialNumber!,
                        ),
                      _buildAnimalInfoRow(
                        _foundAnimal!.sex == AnimalSex.male
                            ? Icons.male
                            : Icons.female,
                        l10n.translate('sex'),
                        l10n.translate(_foundAnimal!.sex == AnimalSex.male
                            ? 'male'
                            : 'female'),
                      ),
                      _buildAnimalInfoRow(
                        Icons.cake,
                        'Âge',
                        '${_foundAnimal!.ageInMonths} mois',
                      ),
                    ],
                  ),
                )
              // Animal non trouvé
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200, width: 2),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning,
                              color: Colors.orange.shade700, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.translate('animal_not_found'),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.translate('animal_not_found_message'),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.orange.shade900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.translate('add_this_animal'),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
      actions: [
        // Bouton Annuler / Scanner un autre
        TextButton(
          onPressed: _scannedEID == null
              ? () => Navigator.pop(context)
              : () => setState(() {
                    _scannedEID = null;
                    _foundAnimal = null;
                  }),
          child: Text(
            _scannedEID == null
                ? l10n.translate('cancel')
                : l10n.translate('scan_another'),
          ),
        ),

        // Bouton Voir détails / Ajouter
        if (_scannedEID != null)
          ElevatedButton(
            onPressed: _foundAnimal != null ? _viewAnimalDetails : _addAnimal,
            style: ElevatedButton.styleFrom(
              backgroundColor: _foundAnimal != null
                  ? Colors.green
                  : Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text(
              _foundAnimal != null
                  ? l10n.translate('view_details')
                  : l10n.translate('add_animal'),
            ),
          ),
      ],
    );
  }

  Widget _buildAnimalInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== WIDGETS EXISTANTS ====================

class _AnimalCard extends StatelessWidget {
  final Animal animal;

  const _AnimalCard({required this.animal});

  @override
  Widget build(BuildContext context) {
    final sexColor = animal.sex == AnimalSex.male ? Colors.blue : Colors.pink;
    final sexIcon = animal.sex == AnimalSex.male ? Icons.male : Icons.female;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () {
          final animalProvider = context.read<AnimalProvider>();
          animalProvider.setCurrentAnimal(animal);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ScanScreen(preloadedAnimal: animal),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                backgroundColor: sexColor.withOpacity(0.1),
                radius: 24,
                child: Icon(sexIcon, color: sexColor),
              ),
              const SizedBox(width: 12),

              // Infos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      animal.officialNumber ?? animal.eid,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      animal.eid,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
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
                            color: _getStatusColor(animal.status),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getStatusLabel(animal.status),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${animal.ageInMonths} mois',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Flèche
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(AnimalStatus status) {
    switch (status) {
      case AnimalStatus.alive:
        return Colors.green;
      case AnimalStatus.sold:
        return Colors.orange;
      case AnimalStatus.dead:
        return Colors.red;
      case AnimalStatus.slaughtered:
        return Colors.grey;
    }
  }

  String _getStatusLabel(AnimalStatus status) {
    switch (status) {
      case AnimalStatus.alive:
        return 'Vivant';
      case AnimalStatus.sold:
        return 'Vendu';
      case AnimalStatus.dead:
        return 'Mort';
      case AnimalStatus.slaughtered:
        return 'Abattu';
    }
  }
}

class _GroupBySheet extends StatelessWidget {
  final GroupByOption currentValue;
  final ValueChanged<GroupByOption> onSelected;

  const _GroupBySheet({
    required this.currentValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grouper par',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...GroupByOption.values.map((option) {
            return RadioListTile<GroupByOption>(
              title: Text(option.label),
              value: option,
              groupValue: currentValue,
              onChanged: (value) {
                if (value != null) onSelected(value);
              },
            );
          }),
        ],
      ),
    );
  }
}

class _FiltersDrawer extends StatefulWidget {
  final Set<AnimalStatus> selectedStatuses;
  final Set<AnimalSex> selectedSexes;
  final Set<String> selectedAgeRanges;
  final bool? hasActiveWithdrawal;
  final String? motherEidFilter;
  final Function(Set<AnimalStatus>, Set<AnimalSex>, Set<String>, bool?, String?)
      onApply;
  final VoidCallback onReset;

  const _FiltersDrawer({
    required this.selectedStatuses,
    required this.selectedSexes,
    required this.selectedAgeRanges,
    required this.hasActiveWithdrawal,
    required this.motherEidFilter,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<_FiltersDrawer> createState() => _FiltersDrawerState();
}

class _FiltersDrawerState extends State<_FiltersDrawer> {
  late Set<AnimalStatus> _statuses;
  late Set<AnimalSex> _sexes;
  late Set<String> _ageRanges;
  late bool? _withdrawal;
  late TextEditingController _motherController;

  @override
  void initState() {
    super.initState();
    _statuses = Set.from(widget.selectedStatuses);
    _sexes = Set.from(widget.selectedSexes);
    _ageRanges = Set.from(widget.selectedAgeRanges);
    _withdrawal = widget.hasActiveWithdrawal;
    _motherController =
        TextEditingController(text: widget.motherEidFilter ?? '');
  }

  @override
  void dispose() {
    _motherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filtres',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      widget.onReset();
                      Navigator.pop(context);
                    },
                    child: const Text('Réinitialiser'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    // Statut
                    const Text('Statut',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    ...AnimalStatus.values.map((status) {
                      return CheckboxListTile(
                        title: Text(_getStatusLabel(status)),
                        value: _statuses.contains(status),
                        onChanged: (checked) {
                          setState(() {
                            if (checked == true) {
                              _statuses.add(status);
                            } else {
                              _statuses.remove(status);
                            }
                          });
                        },
                      );
                    }),

                    const Divider(),

                    // Sexe
                    const Text('Sexe',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    CheckboxListTile(
                      title: const Text('♂️ Mâle'),
                      value: _sexes.contains(AnimalSex.male),
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            _sexes.add(AnimalSex.male);
                          } else {
                            _sexes.remove(AnimalSex.male);
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('♀️ Femelle'),
                      value: _sexes.contains(AnimalSex.female),
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            _sexes.add(AnimalSex.female);
                          } else {
                            _sexes.remove(AnimalSex.female);
                          }
                        });
                      },
                    ),

                    const Divider(),

                    // Âge
                    const Text('Âge',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    ...['< 6m', '6-12m', '1-2 ans', '> 2 ans'].map((range) {
                      return CheckboxListTile(
                        title: Text(range),
                        value: _ageRanges.contains(range),
                        onChanged: (checked) {
                          setState(() {
                            if (checked == true) {
                              _ageRanges.add(range);
                            } else {
                              _ageRanges.remove(range);
                            }
                          });
                        },
                      );
                    }),

                    const Divider(),

                    // Rémanence
                    const Text('Rémanence',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    RadioListTile<bool?>(
                      title: const Text('Tous'),
                      value: null,
                      groupValue: _withdrawal,
                      onChanged: (value) => setState(() => _withdrawal = value),
                    ),
                    RadioListTile<bool?>(
                      title: const Text('Active'),
                      value: true,
                      groupValue: _withdrawal,
                      onChanged: (value) => setState(() => _withdrawal = value),
                    ),
                    RadioListTile<bool?>(
                      title: const Text('Inactive'),
                      value: false,
                      groupValue: _withdrawal,
                      onChanged: (value) => setState(() => _withdrawal = value),
                    ),

                    const Divider(),

                    // Mère
                    const Text('Mère',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: TextField(
                        controller: _motherController,
                        decoration: const InputDecoration(
                          hintText: 'EID de la mère',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Boutons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Annuler'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onApply(
                          _statuses,
                          _sexes,
                          _ageRanges,
                          _withdrawal,
                          _motherController.text.isEmpty
                              ? null
                              : _motherController.text,
                        );
                        Navigator.pop(context);
                      },
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
  }

  String _getStatusLabel(AnimalStatus status) {
    switch (status) {
      case AnimalStatus.alive:
        return '🟢 Vivant';
      case AnimalStatus.sold:
        return '🟠 Vendu';
      case AnimalStatus.dead:
        return '🔴 Mort';
      case AnimalStatus.slaughtered:
        return '🏭 Abattu';
    }
  }
}

// ==================== Enums ====================

enum GroupByOption {
  none,
  sex,
  age,
  status,
  withdrawal,
  mother,
}

extension GroupByOptionExt on GroupByOption {
  String get label {
    switch (this) {
      case GroupByOption.none:
        return 'Aucun';
      case GroupByOption.sex:
        return 'Par Sexe';
      case GroupByOption.age:
        return 'Par Âge';
      case GroupByOption.status:
        return 'Par Statut';
      case GroupByOption.withdrawal:
        return 'Par Rémanence';
      case GroupByOption.mother:
        return 'Par Mère';
    }
  }
}
