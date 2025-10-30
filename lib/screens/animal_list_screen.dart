// lib/screens/animal_list_screen.dart
// Artefact 16 : Liste Animaux Avancée avec Filtres et Group By
// Version : 1.2

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/animal_provider.dart';
import '../models/animal.dart';
//import '../i18n/app_localizations.dart';
import 'scan_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final animalProvider = context.watch<AnimalProvider>();
    final allAnimals = animalProvider.animals;
    final filteredAnimals = _getFilteredAnimals(allAnimals);
    final groupedAnimals = _getGroupedAnimals(filteredAnimals);

    return Scaffold(
      appBar: AppBar(
        title: Text('Animaux (${filteredAnimals.length})'),
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
                    icon: Badge(
                      isLabelVisible: _activeFilterCount > 0,
                      label: Text('$_activeFilterCount'),
                      child: const Icon(Icons.filter_list),
                    ),
                    label: const Text('Filtres'),
                  ),
                ),
                const SizedBox(width: 12),
                // Dropdown Group By
                Expanded(
                  child: DropdownButtonFormField<GroupByOption>(
                    value: _groupBy,
                    decoration: const InputDecoration(
                      labelText: 'Grouper par',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: GroupByOption.values
                        .map((option) => DropdownMenuItem(
                              value: option,
                              child: Text(option.label),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _groupBy = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Liste des animaux
          Expanded(
            child: filteredAnimals.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun animal trouvé',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : _groupBy == GroupByOption.none
                    ? ListView.builder(
                        itemCount: filteredAnimals.length,
                        itemBuilder: (context, index) {
                          final animal = filteredAnimals[index];
                          return _buildAnimalCard(context, animal);
                        },
                      )
                    : ListView.builder(
                        itemCount: groupedAnimals.length,
                        itemBuilder: (context, index) {
                          final groupKey = groupedAnimals.keys.elementAt(index);
                          final groupAnimals = groupedAnimals[groupKey]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header du groupe
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                color: Colors.grey.shade200,
                                child: Text(
                                  '$groupKey (${groupAnimals.length})',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              // Animaux du groupe
                              ...groupAnimals
                                  .map((animal) =>
                                      _buildAnimalCard(context, animal))
                                  .toList(),
                            ],
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ScanScreen()),
          );
        },
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }

  Widget _buildAnimalCard(BuildContext context, Animal animal) {
    final animalProvider = context.read<AnimalProvider>();
    final hasWithdrawal = animalProvider.hasActiveWithdrawal(animal.id);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: animal.sex == AnimalSex.male
              ? Colors.blue.shade100
              : Colors.pink.shade100,
          child: Text(
            animal.sex == AnimalSex.male ? '♂️' : '♀️',
            style: const TextStyle(fontSize: 20),
          ),
        ),
        title: Text(
          animal.officialNumber ?? animal.eid,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (animal.officialNumber != null)
              Text('EID: ${animal.eid}', style: const TextStyle(fontSize: 12)),
            Text(
                '${animal.ageInMonths} mois • ${_getStatusLabel(animal.status)}'),
            if (hasWithdrawal)
              const Text(
                '⚠️ Rémanence active',
                style: TextStyle(
                    color: Colors.orange, fontWeight: FontWeight.w600),
              ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Navigation vers l'écran de détail avec l'animal préchargé
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScanScreen(
                preloadedAnimal: animal,
              ),
            ),
          );
        },
      ),
    );
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

// ==================== Widget Filtres ====================

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
