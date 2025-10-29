// lib/screens/animal_list_screen.dart
// Artefact 16 : Liste Animaux Avancée avec Filtres et Group By
// Version : 1.2

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/animal_provider.dart';
import '../models/animal.dart';
import '../i18n/app_localizations.dart';
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
                hintText: '🔍 Rechercher EID ou N°...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() => _searchController.clear());
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),

          // Barre d'outils (Filtres + Group By)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Bouton Filtres
                OutlinedButton.icon(
                  onPressed: _showFiltersDrawer,
                  icon: Icon(Icons.filter_list),
                  label: Text(_activeFilterCount > 0
                      ? 'Filtres ($_activeFilterCount)'
                      : 'Filtres'),
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        _activeFilterCount > 0 ? Colors.blue.shade50 : null,
                  ),
                ),
                SizedBox(width: 12),

                // Dropdown Group By
                Expanded(
                  child: DropdownButtonFormField<GroupByOption>(
                    value: _groupBy,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.group_work),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: GroupByOption.values.map((option) {
                      return DropdownMenuItem(
                        value: option,
                        child: Text(option.label),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _groupBy = value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Liste
          Expanded(
            child: filteredAnimals.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pets, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
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
                          return _AnimalTile(
                            animal: filteredAnimals[index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ScanScreen(
                                    preloadedAnimal: filteredAnimals[index],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: groupedAnimals.keys.length,
                        itemBuilder: (context, index) {
                          final groupKey = groupedAnimals.keys.elementAt(index);
                          final animals = groupedAnimals[groupKey]!;

                          return _GroupExpansionTile(
                            title: groupKey,
                            count: animals.length,
                            animals: animals,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

// ==================== Widgets ====================

class _AnimalTile extends StatelessWidget {
  final Animal animal;
  final VoidCallback onTap;

  const _AnimalTile({
    required this.animal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final animalProvider = context.read<AnimalProvider>();
    final hasWithdrawal = animalProvider.hasActiveWithdrawal(animal.id);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: animal.sex == AnimalSex.male
            ? Colors.blue.shade100
            : Colors.pink.shade100,
        child: Icon(
          animal.sex == AnimalSex.male ? Icons.male : Icons.female,
          color: animal.sex == AnimalSex.male
              ? Colors.blue.shade700
              : Colors.pink.shade700,
        ),
      ),
      title: Text(
        animal.officialNumber ?? animal.eid,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${animal.ageFormatted}'),
          Row(
            children: [
              _StatusBadge(status: animal.status),
              if (hasWithdrawal) ...[
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '⚠️ Rémanence',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.orange.shade900,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final AnimalStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case AnimalStatus.alive:
        color = Colors.green;
        label = 'Vivant';
        break;
      case AnimalStatus.sold:
        color = Colors.orange;
        label = 'Vendu';
        break;
      case AnimalStatus.dead:
        color = Colors.red;
        label = 'Mort';
        break;
      case AnimalStatus.slaughtered:
        color = Colors.grey;
        label = 'Abattu';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color.shade900,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _GroupExpansionTile extends StatelessWidget {
  final String title;
  final int count;
  final List<Animal> animals;

  const _GroupExpansionTile({
    required this.title,
    required this.count,
    required this.animals,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.folder_open),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text('$count animal${count > 1 ? 'aux' : ''}'),
      children: animals.map((animal) {
        return _AnimalTile(
          animal: animal,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ScanScreen(preloadedAnimal: animal),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class _FiltersDrawer extends StatefulWidget {
  final Set<AnimalStatus> selectedStatuses;
  final Set<AnimalSex> selectedSexes;
  final Set<String> selectedAgeRanges;
  final bool? hasActiveWithdrawal;
  final String? motherEidFilter;
  final Function(
    Set<AnimalStatus>,
    Set<AnimalSex>,
    Set<String>,
    bool?,
    String?,
  ) onApply;
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
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filtres',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      widget.onReset();
                      Navigator.pop(context);
                    },
                    child: Text('Réinitialiser'),
                  ),
                ],
              ),
              SizedBox(height: 16),

              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    // Statut
                    Text('Statut',
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
                    }).toList(),

                    Divider(),

                    // Sexe
                    Text('Sexe', style: TextStyle(fontWeight: FontWeight.w600)),
                    CheckboxListTile(
                      title: Text('♂️ Mâle'),
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
                      title: Text('♀️ Femelle'),
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

                    Divider(),

                    // Âge
                    Text('Âge', style: TextStyle(fontWeight: FontWeight.w600)),
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
                    }).toList(),

                    Divider(),

                    // Rémanence
                    Text('Rémanence',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    RadioListTile<bool?>(
                      title: Text('Tous'),
                      value: null,
                      groupValue: _withdrawal,
                      onChanged: (value) => setState(() => _withdrawal = value),
                    ),
                    RadioListTile<bool?>(
                      title: Text('Active'),
                      value: true,
                      groupValue: _withdrawal,
                      onChanged: (value) => setState(() => _withdrawal = value),
                    ),
                    RadioListTile<bool?>(
                      title: Text('Inactive'),
                      value: false,
                      groupValue: _withdrawal,
                      onChanged: (value) => setState(() => _withdrawal = value),
                    ),

                    Divider(),

                    // Mère
                    Text('Mère', style: TextStyle(fontWeight: FontWeight.w600)),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: TextField(
                        controller: _motherController,
                        decoration: InputDecoration(
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
                      child: Text('Annuler'),
                    ),
                  ),
                  SizedBox(width: 12),
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
                      child: Text('Appliquer'),
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
