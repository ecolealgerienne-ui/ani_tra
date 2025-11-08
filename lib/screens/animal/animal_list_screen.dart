// lib/screens/animal_list_screen.dart
// Version 2.0 - Intégration complète des alertes
// PHASE 1+2 : Alertes prioritaires + Groupes collapsibles

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../providers/animal_provider.dart';
import '../../providers/alert_provider.dart';
import '../../models/animal.dart';
import '../../models/animal_extensions.dart';
import '../../models/alert.dart';
import '../../models/alert_type.dart';
import '../../models/alert_category.dart';
import '../../models/breed.dart';
import '../../data/animal_config.dart';

import 'animal_detail_screen.dart';
import 'add_animal_screen.dart';
import 'animal_finder_screen.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';

class AnimalListScreen extends StatefulWidget {
  /// Liste d'IDs à afficher uniquement (pour filtrer depuis une alerte)
  final List<String>? filterAnimalIds;

  /// Titre personnalisé si on vient d'une alerte
  final String? customTitle;

  const AnimalListScreen({
    super.key,
    this.filterAnimalIds,
    this.customTitle,
  });

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
  Set<String> _selectedSpecies = {};
  Set<String> _selectedBreeds = {};

  // 🆕 Filtre alertes
  bool _showOnlyWithAlerts = false;

  // Group By - Initialisation intelligente
  late GroupByOption _groupBy;

  @override
  void initState() {
    super.initState();
    // Si on vient d'une alerte avec filtre → Pas de groupement
    // Sinon → Grouper par alertes par défaut
    _groupBy = widget.filterAnimalIds != null
        ? GroupByOption.none
        : GroupByOption.alerts;
  }

  // 🆕 État des sections collapsibles
  final Map<String, bool> _expandedSections = {
    'urgent': true, // Ouvert par défaut
    'important': true, // Ouvert par défaut
    'routine': false, // Fermé par défaut
    'noalert': true, // 🔧 OUVERT par défaut pour voir les animaux
  };

  // État filtres drawer
  int get _activeFilterCount {
    int count = 0;
    if (_selectedStatuses.length < 4) count++;
    if (_selectedSexes.isNotEmpty) count++;
    if (_selectedAgeRanges.isNotEmpty) count++;
    if (_hasActiveWithdrawal != null) count++;
    if (_motherEidFilter != null && _motherEidFilter!.isNotEmpty) count++;
    if (_batchIdFilter != null) count++;
    if (_selectedSpecies.isNotEmpty) count++;
    if (_selectedBreeds.isNotEmpty) count++;
    if (_showOnlyWithAlerts) count++;
    return count;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Animal> _getFilteredAnimals(List<Animal> animals) {
    var filtered = animals;
    final animalProvider = context.read<AnimalProvider>();

    // 🆕 Si on vient d'une alerte, filtrer uniquement ces animaux
    if (widget.filterAnimalIds != null) {
      filtered = filtered
          .where((a) => widget.filterAnimalIds!.contains(a.id))
          .toList();
    }

    // Recherche texte (flexible - ignore tirets et espaces)
    final query =
        _searchController.text.toLowerCase().replaceAll(RegExp(r'[-\s]'), '');
    if (query.isNotEmpty) {
      filtered = animalProvider.searchAnimals(_searchController.text);
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
        return mother?.safeEid
                .toLowerCase()
                .contains(_motherEidFilter!.toLowerCase()) ??
            false;
      }).toList();
    }

    // Filtre Type
    if (_selectedSpecies.isNotEmpty) {
      filtered = filtered.where((a) {
        return a.speciesId != null && _selectedSpecies.contains(a.speciesId);
      }).toList();
    }

    // Filtre Race
    if (_selectedBreeds.isNotEmpty) {
      filtered = filtered.where((a) {
        return a.breedId != null && _selectedBreeds.contains(a.breedId);
      }).toList();
    }

    // 🆕 Filtre "Avec alertes uniquement"
    if (_showOnlyWithAlerts) {
      final alertProvider = context.read<AlertProvider>();
      filtered = filtered.where((a) {
        return alertProvider.getAlertsForAnimal(a.id).isNotEmpty;
      }).toList();
    }

    return filtered;
  }

  Map<String, List<Animal>> _getGroupedAnimals(List<Animal> animals) {
    final groups = <String, List<Animal>>{};

    switch (_groupBy) {
      case GroupByOption.none:
        return {'all': animals};

      // 🆕 NOUVEAU : Grouper par niveau d'alerte
      case GroupByOption.alerts:
        final alertProvider = context.read<AlertProvider>();

        for (final animal in animals) {
          final animalAlerts = alertProvider.getAlertsForAnimal(animal.id);

          if (animalAlerts.isEmpty) {
            groups.putIfAbsent('✅ Sans alerte', () => []).add(animal);
          } else {
            // Trouver l'alerte la plus urgente
            final maxUrgency = animalAlerts
                .map((a) => a.type.priority)
                .reduce((a, b) => a < b ? a : b);

            if (maxUrgency == AlertType.urgent.priority) {
              groups.putIfAbsent('🚨 URGENTS', () => []).add(animal);
            } else if (maxUrgency == AlertType.important.priority) {
              groups.putIfAbsent('⚠️ À SURVEILLER', () => []).add(animal);
            } else {
              groups.putIfAbsent('📋 Routine', () => []).add(animal);
            }
          }
        }
        break;

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

      case GroupByOption.species:
        for (final animal in animals) {
          if (animal.speciesId == null) {
            groups.putIfAbsent('❓ Type non défini', () => []).add(animal);
          } else {
            final key = animal.fullDisplayFr.split(' - ').first;
            groups.putIfAbsent(key, () => []).add(animal);
          }
        }
        break;

      case GroupByOption.breed:
        for (final animal in animals) {
          if (animal.breedId == null) {
            groups.putIfAbsent('❓ Race non définie', () => []).add(animal);
          } else {
            final key = animal.breedNameFr;
            groups.putIfAbsent(key, () => []).add(animal);
          }
        }
        break;
    }

    return groups;
  }

  // 🆕 Obtenir la clé de section pour l'état collapsed
  String _getSectionKey(String groupName) {
    if (groupName.contains('URGENTS')) return 'urgent';
    if (groupName.contains('SURVEILLER')) return 'important';
    if (groupName.contains('Routine')) return 'routine';
    if (groupName.contains('Sans alerte')) return 'noalert';
    return groupName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customTitle ?? 'Animaux'),
        actions: [
          // 🆕 Badge d'alertes
          Consumer<AlertProvider>(
            builder: (context, alertProvider, child) {
              final alertCount = alertProvider.alertCount;
              if (alertCount == 0) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed: () {
                        // Navigation vers alerts_screen si besoin
                      },
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          alertCount > 9 ? '9+' : '$alertCount',
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
              );
            },
          ),
          IconButton(
            icon: Badge(
              isLabelVisible: _activeFilterCount > 0,
              label: Text('$_activeFilterCount'),
              child: const Icon(Icons.filter_list),
            ),
            onPressed: _showFiltersDrawer,
          ),
        ],
      ),
      body: Consumer2<AnimalProvider, AlertProvider>(
        builder: (context, animalProvider, alertProvider, child) {
          final filtered = _getFilteredAnimals(animalProvider.animals);
          final grouped = _getGroupedAnimals(filtered);

          // 🆕 Tri des groupes pour mettre les alertes en premier
          final sortedKeys = grouped.keys.toList();
          if (_groupBy == GroupByOption.alerts) {
            sortedKeys.sort((a, b) {
              const priority = {
                '🚨 URGENTS': 1,
                '⚠️ À SURVEILLER': 2,
                '📋 Routine': 3,
                '✅ Sans alerte': 4,
              };
              return (priority[a] ?? 99).compareTo(priority[b] ?? 99);
            });
          }

          return Column(
            children: [
              // Barre de recherche
              _buildSearchBar(),

              // 🆕 Chips de filtre rapide
              _buildQuickFilters(alertProvider, filtered.length),

              // Liste des animaux
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    alertProvider.refresh();
                    await Future.delayed(const Duration(milliseconds: 500));
                  },
                  child: filtered.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: sortedKeys.length,
                          itemBuilder: (context, index) {
                            final groupName = sortedKeys[index];
                            final groupAnimals = grouped[groupName]!;

                            return _buildGroupSection(
                              groupName,
                              groupAnimals,
                              alertProvider,
                              animalProvider,
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddAnimalScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Widget : Barre de recherche
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText:
              AppLocalizations.of(context).translate(AppStrings.searchHint),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bouton clear (si texte présent)
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                    });
                  },
                ),
              // Bouton scan (toujours visible)
              IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                tooltip: 'Scanner',
                onPressed: _scanAnimal,
              ),
            ],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (value) => setState(() {}),
      ),
    );
  }

  /// Scanner un animal et l'ouvrir
  Future<void> _scanAnimal() async {
    final animal = await Navigator.push<Animal>(
      context,
      MaterialPageRoute(
        builder: (context) => const AnimalFinderScreen(
          mode: AnimalFinderMode.single,
          title: 'Scanner un animal',
        ),
      ),
    );

    if (animal != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnimalDetailScreen(preloadedAnimal: animal),
        ),
      );
    }
  }

  /// 🆕 Widget : Chips de filtre rapide
  Widget _buildQuickFilters(AlertProvider alertProvider, int totalCount) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Chip "Avec alertes"
          FilterChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_amber, size: 16),
                const SizedBox(width: 4),
                Text('Alertes (${alertProvider.alertCount})'),
              ],
            ),
            selected: _showOnlyWithAlerts,
            onSelected: (selected) {
              setState(() {
                _showOnlyWithAlerts = selected;
              });
            },
          ),
          const SizedBox(width: 8),

          // Dropdown Group By
          Expanded(
            child: DropdownButtonFormField<GroupByOption>(
              initialValue: _groupBy,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: GroupByOption.values.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(
                    option.label,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _groupBy = value;
                  });
                }
              },
            ),
          ),

          const SizedBox(width: 8),
          Text(
            '$totalCount',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /// 🆕 Widget : Section de groupe (collapsible si mode alertes)
  Widget _buildGroupSection(
    String groupName,
    List<Animal> animals,
    AlertProvider alertProvider,
    AnimalProvider animalProvider,
  ) {
    final sectionKey = _getSectionKey(groupName);
    final isExpanded = _expandedSections[sectionKey] ?? true;
    final isAlertMode = _groupBy == GroupByOption.alerts;

    // Couleur selon le groupe
    Color getSectionColor() {
      if (groupName.contains('URGENTS')) return Colors.red.shade700;
      if (groupName.contains('SURVEILLER')) return Colors.orange.shade700;
      if (groupName.contains('Routine')) return Colors.blue.shade700;
      return Colors.grey.shade700;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header de section
        InkWell(
          onTap: isAlertMode
              ? () {
                  setState(() {
                    _expandedSections[sectionKey] = !isExpanded;
                  });
                }
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: getSectionColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  groupName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: getSectionColor(),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: getSectionColor().withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${animals.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: getSectionColor(),
                    ),
                  ),
                ),
                const Spacer(),
                if (isAlertMode)
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: getSectionColor(),
                  ),
              ],
            ),
          ),
        ),

        // Liste des animaux (collapsible)
        if (isExpanded || !isAlertMode)
          ...animals.map((animal) {
            final animalAlerts = alertProvider.getAlertsForAnimal(animal.id);

            return _buildAnimalCard(
              animal,
              animalAlerts,
              animalProvider,
            );
          }),

        const SizedBox(height: 16),
      ],
    );
  }

  /// 🆕 Widget : Carte d'animal avec badges d'alertes
  Widget _buildAnimalCard(
    Animal animal,
    List<Alert> alerts,
    AnimalProvider animalProvider,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          animalProvider.setCurrentAnimal(animal);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AnimalDetailScreen(preloadedAnimal: animal),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Icône espèce
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    animal.speciesIcon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Infos animal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      animal.displayName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${animal.fullDisplayFr} • ${animal.ageFormatted}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    // 🆕 Badges d'alertes
                    if (alerts.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: alerts.take(2).map((alert) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getAlertColor(alert.type)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: _getAlertColor(alert.type),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '${alert.category.icon} ${alert.title}',
                              style: TextStyle(
                                fontSize: 11,
                                color: _getAlertColor(alert.type),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),

              // Badge nombre d'alertes
              if (alerts.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getAlertColor(alerts.first.type)
                        .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${alerts.length}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _getAlertColor(alerts.first.type),
                    ),
                  ),
                ),

              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper : Couleur selon type d'alerte
  Color _getAlertColor(AlertType type) {
    switch (type) {
      case AlertType.urgent:
        return Colors.red.shade700;
      case AlertType.important:
        return Colors.orange.shade700;
      case AlertType.routine:
        return Colors.blue.shade700;
    }
  }

  /// Widget : État vide
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey.shade300,
          ),
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
    );
  }

  /// Drawer de filtres (à implémenter - garder l'existant)
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
        selectedSpecies: _selectedSpecies,
        selectedBreeds: _selectedBreeds,
        onApply:
            (statuses, sexes, ageRanges, withdrawal, mother, species, breeds) {
          setState(() {
            _selectedStatuses = statuses;
            _selectedSexes = sexes;
            _selectedAgeRanges = ageRanges;
            _hasActiveWithdrawal = withdrawal;
            _motherEidFilter = mother;
            _selectedSpecies = species;
            _selectedBreeds = breeds;
          });
        },
        onReset: () {
          setState(() {
            _selectedStatuses = {AnimalStatus.alive};
            _selectedSexes = {};
            _selectedAgeRanges = {};
            _hasActiveWithdrawal = null;
            _motherEidFilter = null;
            _selectedSpecies = {};
            _selectedBreeds = {};
          });
        },
      ),
    );
  }
}

// 🆕 Enum mis à jour avec option "alerts"
enum GroupByOption {
  alerts, // 🆕 NOUVEAU en premier !
  none,
  sex,
  age,
  status,
  withdrawal,
  mother,
  species,
  breed,
}

extension GroupByOptionExt on GroupByOption {
  String get label {
    switch (this) {
      case GroupByOption.alerts:
        return 'Par Alerte'; // 🆕
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
      case GroupByOption.species:
        return 'Par Type';
      case GroupByOption.breed:
        return 'Par Race';
    }
  }
}

// ==================== FILTRES DRAWER ====================
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
          RadioGroup<GroupByOption>(
            groupValue: currentValue,
            onChanged: (value) {
              if (value != null) onSelected(value);
            },
            child: Column(
              children: GroupByOption.values.map((option) {
                return RadioListTile<GroupByOption>(
                  title: Text(option.label),
                  value: option,
                );
              }).toList(),
            ),
          ),
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
  final Set<String> selectedSpecies; // NOUVEAU
  final Set<String> selectedBreeds; // NOUVEAU
  final Function(Set<AnimalStatus>, Set<AnimalSex>, Set<String>, bool?, String?,
      Set<String>, Set<String>) onApply; // MODIFIÉ
  final VoidCallback onReset;

  const _FiltersDrawer({
    required this.selectedStatuses,
    required this.selectedSexes,
    required this.selectedAgeRanges,
    required this.hasActiveWithdrawal,
    required this.motherEidFilter,
    required this.selectedSpecies, // NOUVEAU
    required this.selectedBreeds, // NOUVEAU
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
  late Set<String> _species; // NOUVEAU
  late Set<String> _breeds; // NOUVEAU

  @override
  void initState() {
    super.initState();
    _statuses = Set.from(widget.selectedStatuses);
    _sexes = Set.from(widget.selectedSexes);
    _ageRanges = Set.from(widget.selectedAgeRanges);
    _withdrawal = widget.hasActiveWithdrawal;
    _motherController =
        TextEditingController(text: widget.motherEidFilter ?? '');
    _species = Set.from(widget.selectedSpecies); // NOUVEAU
    _breeds = Set.from(widget.selectedBreeds); // NOUVEAU
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

                    // NOUVEAU : Type d'animal
                    const Text('Type d\'animal',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    ...AnimalConfig.availableSpecies.map((species) {
                      return CheckboxListTile(
                        title: Text('${species.icon} ${species.nameFr}'),
                        value: _species.contains(species.id),
                        onChanged: (checked) {
                          setState(() {
                            if (checked == true) {
                              _species.add(species.id);
                            } else {
                              _species.remove(species.id);
                              // Retirer les races de ce type
                              final breedsToRemove =
                                  AnimalConfig.getBreedsBySpecies(species.id)
                                      .map((b) => b.id)
                                      .toSet();
                              _breeds.removeAll(breedsToRemove);
                            }
                          });
                        },
                      );
                    }),

                    const Divider(),

                    // NOUVEAU : Race
                    const Text('Race',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    if (_species.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Sélectionnez d\'abord un type',
                          style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    else
                      ...() {
                        // Obtenir toutes les races des types sélectionnés
                        final availableBreeds = <Breed>[];
                        for (final speciesId in _species) {
                          availableBreeds.addAll(
                              AnimalConfig.getBreedsBySpecies(speciesId));
                        }
                        return availableBreeds.map((breed) {
                          return CheckboxListTile(
                            title: Text(breed.nameFr),
                            subtitle: breed.description != null
                                ? Text(
                                    breed.description!,
                                    style: const TextStyle(fontSize: 11),
                                  )
                                : null,
                            value: _breeds.contains(breed.id),
                            onChanged: (checked) {
                              setState(() {
                                if (checked == true) {
                                  _breeds.add(breed.id);
                                } else {
                                  _breeds.remove(breed.id);
                                }
                              });
                            },
                          );
                        });
                      }(),

                    const Divider(),

                    // Rémanence
                    const Text('Rémanence',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    RadioGroup<bool?>(
                      groupValue: _withdrawal,
                      onChanged: (value) => setState(() => _withdrawal = value),
                      child: const Column(
                        children: [
                          RadioListTile<bool?>(
                            title: Text('Tous'),
                            value: null,
                          ),
                          RadioListTile<bool?>(
                            title: Text('Active'),
                            value: true,
                          ),
                          RadioListTile<bool?>(
                            title: Text('Inactive'),
                            value: false,
                          ),
                        ],
                      ),
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
                          _species, // NOUVEAU
                          _breeds, // NOUVEAU
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
