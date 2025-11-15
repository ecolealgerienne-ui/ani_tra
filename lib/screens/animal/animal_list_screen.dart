// lib/screens/animal_list_screen.dart
// Version 2.0 - IntÃƒÆ’Ã‚Â©gration complÃƒÆ’Ã‚Â¨te des alertes
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
import '../../utils/constants.dart';

class AnimalListScreen extends StatefulWidget {
  /// Liste d'IDs ÃƒÆ’Ã‚Â  afficher uniquement (pour filtrer depuis une alerte)
  final List<String>? filterAnimalIds;

  /// Titre personnalisÃƒÆ’Ã‚Â© si on vient d'une alerte
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
  // ✅ PHASE 4 FIX: Inclure les DRAFT par défaut pour afficher les alertes de brouillon
  Set<AnimalStatus> _selectedStatuses = {
    AnimalStatus.alive,
    AnimalStatus.draft
  };
  Set<AnimalSex> _selectedSexes = {};
  Set<String> _selectedAgeRanges = {};
  bool? _hasActiveWithdrawal;
  String? _motherEidFilter;
  String? _batchIdFilter;
  Set<String> _selectedSpecies = {};
  Set<String> _selectedBreeds = {};

  // ÃƒÂ°Ã…Â¸Ã¢â‚¬Â Ã¢â‚¬Â¢ Filtre alertes
  bool _showOnlyWithAlerts = false;

  // Group By - Initialisation intelligente
  late GroupByOption _groupBy;

  @override
  void initState() {
    super.initState();
    // Si on vient d'une alerte avec filtre ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ Pas de groupement
    // Sinon ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ Grouper par alertes par dÃƒÆ’Ã‚Â©faut
    _groupBy = widget.filterAnimalIds != null
        ? GroupByOption.none
        : GroupByOption.alerts;
  }

  // ÃƒÂ°Ã…Â¸Ã¢â‚¬Â Ã¢â‚¬Â¢ ÃƒÆ’Ã¢â‚¬Â°tat des sections collapsibles
  final Map<String, bool> _expandedSections = {
    'urgent':
        false, // Ouvert par dÃƒÂ©faut (prioritÃƒÂ©) // Ouvert par dÃƒÆ’Ã‚Â©faut
    'important': false, // FermÃƒÂ© par dÃƒÂ©faut // Ouvert par dÃƒÆ’Ã‚Â©faut
    'routine':
        false, // FermÃƒÂ© par dÃƒÂ©faut // FermÃƒÆ’Ã‚Â© par dÃƒÆ’Ã‚Â©faut
    'noalert':
        false, // FermÃƒÂ© par dÃƒÂ©faut // ÃƒÂ°Ã…Â¸Ã¢â‚¬ÂÃ‚Â§ OUVERT par dÃƒÆ’Ã‚Â©faut pour voir les animaux
    'withoutOfficialNumber': false, // TOUJOURS ouvert (rÃƒÂ©glementaire)
  };

  // ÃƒÆ’Ã¢â‚¬Â°tat filtres drawer
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

    // ÃƒÂ°Ã…Â¸Ã¢â‚¬Â Ã¢â‚¬Â¢ Si on vient d'une alerte, filtrer uniquement ces animaux
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

    // Filtre ÃƒÆ’Ã‚Â¢ge
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

    // Filtre rÃƒÆ’Ã‚Â©manence
    if (_hasActiveWithdrawal != null) {
      final animalProvider = context.read<AnimalProvider>();
      filtered = filtered.where((a) {
        final hasActive = animalProvider.hasActiveWithdrawal(a.id);
        return hasActive == _hasActiveWithdrawal;
      }).toList();
    }

    // Filtre mÃƒÆ’Ã‚Â¨re
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

    // ÃƒÂ°Ã…Â¸Ã¢â‚¬Â Ã¢â‚¬Â¢ Filtre "Avec alertes uniquement"
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

      // ÃƒÂ°Ã…Â¸Ã¢â‚¬Â Ã¢â‚¬Â¢ NOUVEAU : Grouper par niveau d'alerte
      // ✅ PHASE 4 FIX: NOUVEAU - Grouper par alertes AVEC groupe Brouillons EN PREMIER
      case GroupByOption.alerts:
        final alertProvider = context.read<AlertProvider>();
        final drafts = <Animal>[];
        final nonDrafts = <Animal>[];

        // 1. Séparer les brouillons des autres
        for (final animal in animals) {
          if (animal.status == AnimalStatus.draft) {
            drafts.add(animal);
          } else {
            nonDrafts.add(animal);
          }
        }

        // 2. Créer le groupe "📋 Brouillons" si NON VIDE
        if (drafts.isNotEmpty) {
          groups['📋 ${AppLocalizations.of(context).translate(AppStrings.drafts)}'] = drafts;
        }

        // 3. Grouper les autres animaux par alerte (URGENT/IMPORTANT/Routine/Aucune alerte)
        for (final animal in nonDrafts) {
          final animalAlerts = alertProvider.getAlertsForAnimal(animal.id);

          if (animalAlerts.isEmpty) {
            groups
                .putIfAbsent(
                    AppLocalizations.of(context).translate(AppStrings.noAlert),
                    () => [])
                .add(animal);
          } else {
            // Trouver l'alerte la plus urgente
            final maxUrgency = animalAlerts
                .map((a) => a.type.priority)
                .reduce((a, b) => a < b ? a : b);

            if (maxUrgency == AlertType.urgent.priority) {
              groups
                  .putIfAbsent(
                      AppLocalizations.of(context).translate(AppStrings.urgent),
                      () => [])
                  .add(animal);
            } else if (maxUrgency == AlertType.important.priority) {
              groups
                  .putIfAbsent(
                      AppLocalizations.of(context)
                          .translate(AppStrings.toMonitor),
                      () => [])
                  .add(animal);
            } else {
              groups
                  .putIfAbsent(
                      AppLocalizations.of(context)
                          .translate(AppStrings.routine),
                      () => [])
                  .add(animal);
            }
          }
        }
        break;

      case GroupByOption.sex:
        for (final animal in animals) {
          final key = animal.sex == AnimalSex.male
              ? '♂️ ${AppLocalizations.of(context).translate(AppStrings.males)}'
              : '♀️ ${AppLocalizations.of(context).translate(AppStrings.females)}';
          groups.putIfAbsent(key, () => []).add(animal);
        }
        break;

      case GroupByOption.age:
        for (final animal in animals) {
          final months = animal.ageInMonths;
          String key;
          if (months < 6) {
            key = '🐑 ${AppLocalizations.of(context).translate(AppStrings.lessThan6Months)}';
          } else if (months < 12) {
            key = '🐑 ${AppLocalizations.of(context).translate(AppStrings.from6To12Months)}';
          } else if (months < 24) {
            key = '🐄 ${AppLocalizations.of(context).translate(AppStrings.from1To2Years)}';
          } else {
            key = '🐄 ${AppLocalizations.of(context).translate(AppStrings.moreThan2Years)}';
          }
          groups.putIfAbsent(key, () => []).add(animal);
        }
        break;

      case GroupByOption.status:
        for (final animal in animals) {
          String key;
          switch (animal.status) {
            case AnimalStatus.draft:
              key = '📋 ${AppLocalizations.of(context).translate(AppStrings.drafts)}';
              break;
            case AnimalStatus.alive:
              key = '🟢 ${AppLocalizations.of(context).translate(AppStrings.statusAlive)}';
              break;
            case AnimalStatus.sold:
              key = '💰 ${AppLocalizations.of(context).translate(AppStrings.soldGroup)}';
              break;
            case AnimalStatus.dead:
              key = '💀 ${AppLocalizations.of(context).translate(AppStrings.deadGroup)}';
              break;
            case AnimalStatus.slaughtered:
              key = '🔪 ${AppLocalizations.of(context).translate(AppStrings.slaughteredGroup)}';
              break;
          }
          groups.putIfAbsent(key, () => []).add(animal);
        }
        break;

      case GroupByOption.withdrawal:
        final animalProvider = context.read<AnimalProvider>();
        for (final animal in animals) {
          final hasActive = animalProvider.hasActiveWithdrawal(animal.id);
          final key = hasActive
              ? '⚠️ ${AppLocalizations.of(context).translate(AppStrings.withdrawalActive)}'
              : '✅ ${AppLocalizations.of(context).translate(AppStrings.withdrawalInactive)}';
          groups.putIfAbsent(key, () => []).add(animal);
        }
        break;

      case GroupByOption.mother:
        for (final animal in animals) {
          if (animal.motherId == null) {
            groups
                .putIfAbsent('❓ ${AppLocalizations.of(context).translate(AppStrings.unknownMother)}', () => [])
                .add(animal);
          } else {
            final mother =
                context.read<AnimalProvider>().getAnimalById(animal.motherId!);
            final key = mother != null
                ? '🐐 ${mother.officialNumber ?? mother.eid}'
                : '❓ ${AppLocalizations.of(context).translate(AppStrings.unknownMother)}';
            groups.putIfAbsent(key, () => []).add(animal);
          }
        }
        break;

      case GroupByOption.species:
        for (final animal in animals) {
          if (animal.speciesId == null) {
            groups
                .putIfAbsent('❓ ${AppLocalizations.of(context).translate(AppStrings.undefinedType)}', () => [])
                .add(animal);
          } else {
            final key = animal.fullDisplayFr.split(' - ').first;
            groups.putIfAbsent(key, () => []).add(animal);
          }
        }
        break;

      case GroupByOption.breed:
        for (final animal in animals) {
          if (animal.breedId == null) {
            groups
                .putIfAbsent(
                    '❓ ${AppLocalizations.of(context).translate(AppStrings.undefinedBreed)}', () => [])
                .add(animal);
          } else {
            final key = animal.breedNameFr;
            groups.putIfAbsent(key, () => []).add(animal);
          }
        }
        break;
    }

    // Ã°Å¸â€ â€¢ SÃƒÂ©parer les animaux sans numÃƒÂ©ro officiel (TOUJOURS visibles en dernier)
    final withoutOfficialNumber = animals
        .where((a) => a.officialNumber == null || a.officialNumber!.isEmpty)
        .toList();

    if (withoutOfficialNumber.isNotEmpty) {
      groups[AppLocalizations.of(context)
              .translate(AppStrings.animalsWithoutOfficialNumber)] =
          withoutOfficialNumber;
    }

    return groups;
  }

  // ÃƒÂ°Ã…Â¸Ã¢â‚¬Â Ã¢â‚¬Â¢ Obtenir la clÃƒÆ’Ã‚Â© de section pour l'ÃƒÆ’Ã‚Â©tat collapsed
  /// Ã°Å¸â€Â§ Obtenir les libellÃƒÂ©s des filtres appliquÃƒÂ©s
  String _getAppliedFiltersLabel() {
    final filters = <String>[];

    // Statut - NE pas afficher si c'est le dÃƒÂ©faut (alive seulement)
    if (_selectedStatuses.length < 4 &&
        _selectedStatuses != {AnimalStatus.alive}) {
      filters.add(AppLocalizations.of(context).translate(AppStrings.status));
    }

    // Sexe
    if (_selectedSexes.isNotEmpty) {
      filters.add(AppLocalizations.of(context).translate(AppStrings.sex));
    }

    // Ãƒâ€šge
    if (_selectedAgeRanges.isNotEmpty) {
      filters.add(AppLocalizations.of(context).translate(AppStrings.age));
    }

    // RÃƒÂ©manence
    if (_hasActiveWithdrawal != null) {
      filters.add(AppLocalizations.of(context).translate(AppStrings.withdrawal));
    }

    // MÃƒÂ¨re
    if (_motherEidFilter != null && _motherEidFilter!.isNotEmpty) {
      filters.add(AppLocalizations.of(context).translate(AppStrings.mother));
    }

    // Lot
    if (_batchIdFilter != null) {
      filters.add(AppLocalizations.of(context).translate(AppStrings.batch));
    }

    // EspÃƒÂ¨ce
    if (_selectedSpecies.isNotEmpty) {
      filters.add(AppLocalizations.of(context).translate(AppStrings.species));
    }

    // Race
    if (_selectedBreeds.isNotEmpty) {
      filters.add(AppLocalizations.of(context).translate(AppStrings.breed));
    }

    if (filters.isEmpty) {
      return '';
    }
    return '${AppLocalizations.of(context).translate(AppStrings.filtersLabel)}: ${filters.join(', ')}';
  }

  String _getSectionKey(String groupName) {
    if (groupName.contains('URGENTS')) return 'urgent';
    if (groupName.contains('SURVEILLER')) return 'important';
    if (groupName.contains('Routine')) return 'routine';
    if (groupName.contains('Sans alerte')) return 'noalert';
    if (groupName.contains('Sans numÃƒÂ©ro')) return 'withoutOfficialNumber';
    return groupName;
  }

  /// Ã°Å¸â€Â§ RÃƒÂ©initialiser _expandedSections selon le mode GroupBy actuel
  void _resetExpandedSections() {
    _expandedSections.clear();
    switch (_groupBy) {
      case GroupByOption.none:
        _expandedSections['all'] = false;
        break;
      case GroupByOption.alerts:
        _expandedSections['urgent'] = false;
        _expandedSections['important'] = false;
        _expandedSections['routine'] = false;
        _expandedSections['withoutOfficialNumber'] = false;
        _expandedSections['noalert'] = false;
        break;
      case GroupByOption.sex:
        _expandedSections['♂️ Mâles'] = false;
        _expandedSections['♀️ Femelles'] = false;
        break;
      case GroupByOption.age:
        _expandedSections['🐑 < 6 mois'] = false;
        _expandedSections['🐑 6-12 mois'] = false;
        _expandedSections['🐄 1-2 ans'] = false;
        _expandedSections['🐄 > 2 ans'] = false;
        break;
      case GroupByOption.status:
        _expandedSections['🟢 Vivants'] = false;
        _expandedSections['💰 Vendus'] = false;
        _expandedSections['💀 Morts'] = false;
        _expandedSections['🔪 Abattus'] = false;
        break;
      case GroupByOption.withdrawal:
        _expandedSections['⚠️ Rémanence Active'] = false;
        _expandedSections['✅ Rémanence Inactive'] = false;
        break;
      case GroupByOption.mother:
        _expandedSections['❓ Mère inconnue'] = false;
        break;
      case GroupByOption.species:
        _expandedSections['❓ Type non défini'] = false;
        break;
      case GroupByOption.breed:
        _expandedSections['❓ Race non définie'] = false;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customTitle ?? AppLocalizations.of(context).translate(AppStrings.animals)),
        actions: [
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

          // ÃƒÂ°Ã…Â¸Ã¢â‚¬Â Ã¢â‚¬Â¢ Tri des groupes pour mettre les alertes en premier
          // Ã°Å¸â€Â§ Tri des groupes - Sans numÃƒÂ©ro officiel EN PREMIER toujours
          final sortedKeys = grouped.keys.toList();

          // Ã°Å¸â€ â€¢ Extraire "Sans numÃƒÂ©ro officiel" et le mettre EN PREMIER toujours
          final officialNumberKey = AppLocalizations.of(context)
              .translate(AppStrings.animalsWithoutOfficialNumber);
          final hasWithoutOfficialNumber =
              sortedKeys.contains(officialNumberKey);
          if (hasWithoutOfficialNumber) {
            sortedKeys.remove(officialNumberKey);
            sortedKeys.insert(0, officialNumberKey);
          }

          if (_groupBy == GroupByOption.alerts) {
            final Map<String, int> priority = {
              '📋 ${AppLocalizations.of(context).translate(AppStrings.drafts)}':
                  0, // ✅ PHASE 4 FIX: Brouillons TOUJOURS EN PREMIER
              AppLocalizations.of(context).translate(AppStrings.urgent): 1,
              AppLocalizations.of(context).translate(AppStrings.toMonitor): 2,
              AppLocalizations.of(context).translate(AppStrings.routine): 3,
              AppLocalizations.of(context).translate(AppStrings.noAlert): 4,
            };

            sortedKeys.sort((a, b) {
              // "Sans numÃƒÂ©ro officiel" reste EN PREMIER
              if (a == officialNumberKey) return -1;
              if (b == officialNumberKey) return 1;
              return (priority[a] ?? 99).compareTo(priority[b] ?? 99);
            });
          } else if (_groupBy == GroupByOption.status) {
            final Map<String, int> priority = {
              '📋 ${AppLocalizations.of(context).translate(AppStrings.drafts)}': 1,
              '🟢 ${AppLocalizations.of(context).translate(AppStrings.statusAlive)}': 2,
              '💰 ${AppLocalizations.of(context).translate(AppStrings.soldGroup)}': 3,
              '💀 ${AppLocalizations.of(context).translate(AppStrings.deadGroup)}': 4,
              '🔪 ${AppLocalizations.of(context).translate(AppStrings.slaughteredGroup)}': 5,
            };

            sortedKeys.sort((a, b) {
              // "Sans numéro officiel" reste EN PREMIER
              if (a == officialNumberKey) return -1;
              if (b == officialNumberKey) return 1;
              return (priority[a] ?? 99).compareTo(priority[b] ?? 99);
            });
          }

          return Column(
            children: [
              // Barre de recherche
              _buildSearchBar(),

              // ÃƒÂ°Ã…Â¸Ã¢â‚¬Â Ã¢â‚¬Â¢ Chips de filtre rapide
              _buildQuickFilters(alertProvider, filtered.length),

              // Liste des animaux
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    alertProvider.refresh();
                    await Future.delayed(AppConstants.longAnimation);
                  },
                  child: filtered.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppConstants.spacingMedium),
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
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText:
              AppLocalizations.of(context).translate(AppStrings.searchHint),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bouton clear (si texte prÃƒÆ’Ã‚Â©sent)
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
                tooltip:
                    AppLocalizations.of(context).translate(AppStrings.scanner),
                onPressed: _scanAnimal,
              ),
            ],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
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
        builder: (context) => AnimalFinderScreen(
          mode: AnimalFinderMode.single,
          title: AppLocalizations.of(context).translate(AppStrings.scanAnimal),
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

  /// ÃƒÂ°Ã…Â¸Ã¢â‚¬Â Ã¢â‚¬Â¢ Widget : Chips de filtre rapide + Affichage GroupBy et Filtres
  Widget _buildQuickFilters(AlertProvider alertProvider, int totalCount) {
    final hasFilters = _getAppliedFiltersLabel().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ligne contrÃƒÂ´les: Alertes + Dropdown GroupBy
          Row(
            children: [
              // Chip "Avec alertes"
              FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.warning_amber, size: AppConstants.iconSizeXSmall),
                    const SizedBox(width: AppConstants.spacingTiny),
                    Text('${AppLocalizations.of(context).translate(AppStrings.alerts)} (${alertProvider.alertCount})'),
                  ],
                ),
                selected: _showOnlyWithAlerts,
                onSelected: (selected) {
                  setState(() {
                    _showOnlyWithAlerts = selected;
                  });
                },
              ),
              const SizedBox(width: AppConstants.spacingSmall),

              // Dropdown Group By
              Expanded(
                child: DropdownButtonFormField<GroupByOption>(
                  initialValue: _groupBy,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                    ),
                  ),
                  items: GroupByOption.values.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Text(
                        option.label(context),
                        style: const TextStyle(fontSize: AppConstants.fontSizeBody),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _resetExpandedSections();
                        _groupBy = value;
                      });
                    }
                  },
                ),
              ),

              const SizedBox(width: AppConstants.spacingSmall),
              Text(
                '$totalCount',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppConstants.fontSizeSectionTitle,
                ),
              ),
            ],
          ),

          // Ligne affichage Filtres (si filtres appliquÃƒÂ©s)
          if (hasFilters) ...[
            const SizedBox(height: AppConstants.spacingExtraSmall),
            Text(
              _getAppliedFiltersLabel(),
              style: TextStyle(
                fontSize: AppConstants.fontSizeSubtitle,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// ÃƒÂ°Ã…Â¸Ã¢â‚¬Â Ã¢â‚¬Â¢ Widget : Section de groupe (collapsible si mode alertes)
  Widget _buildGroupSection(
    String groupName,
    List<Animal> animals,
    AlertProvider alertProvider,
    AnimalProvider animalProvider,
  ) {
    final sectionKey = _getSectionKey(groupName);
    final isExpanded = _expandedSections[sectionKey] ?? false;

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
          onTap: () {
            setState(() {
              _expandedSections[sectionKey] = !isExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingSmall, horizontal: AppConstants.spacingMedium),
            margin: const EdgeInsets.only(bottom: AppConstants.spacingExtraSmall),
            decoration: BoxDecoration(
              color: getSectionColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            ),
            child: Row(
              children: [
                // ✅ PHASE 4 FIX: Expanded pour éviter overflow quand groupName est long
                Expanded(
                  child: Text(
                    groupName,
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeSectionTitle,
                      fontWeight: FontWeight.bold,
                      color: getSectionColor(),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingExtraSmall),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: getSectionColor().withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
                  ),
                  child: Text(
                    '${animals.length}',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeSmall,
                      fontWeight: FontWeight.bold,
                      color: getSectionColor(),
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: getSectionColor(),
                ),
              ],
            ),
          ),
        ),

        // Liste des animaux (collapsible)
        if (isExpanded)
          ...animals.map((animal) {
            final animalAlerts = alertProvider.getAlertsForAnimal(animal.id);

            return _buildAnimalCard(
              animal,
              animalAlerts,
              animalProvider,
            );
          }),

        const SizedBox(height: AppConstants.spacingMedium),
      ],
    );
  }

  /// ÃƒÂ°Ã…Â¸Ã¢â‚¬Â Ã¢â‚¬Â¢ Widget : Carte d'animal avec badges d'alertes
  Widget _buildAnimalCard(
    Animal animal,
    List<Alert> alerts,
    AnimalProvider animalProvider,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingExtraSmall),
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
          padding: const EdgeInsets.all(AppConstants.spacingSmall),
          child: Row(
            children: [
              // IcÃƒÆ’Ã‚Â´ne espÃƒÆ’Ã‚Â¨ce
              Container(
                width: AppConstants.iconContainerSize,
                height: AppConstants.iconContainerSize,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                ),
                child: Center(
                  child: Text(
                    animal.speciesIcon,
                    style: const TextStyle(fontSize: AppConstants.fontSizeExtraLarge),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingSmall),

              // Infos animal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            animal.officialNumber ?? animal.displayName,
                            style: const TextStyle(
                              fontSize: AppConstants.fontSizeSectionTitle,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (animal.isDraft)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(AppConstants.borderRadiusTiny),
                              border: Border.all(
                                color: Colors.orange.shade700,
                                width: 1.0,
                              ),
                            ),
                            child: Text(
                              '🟡 ${AppLocalizations.of(context).translate(AppStrings.draftStatus)}',
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeMicro,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange.shade700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingTiny),
                    Text(
                      '${animal.fullDisplayFr} • ${animal.ageFormatted}',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeSubtitle,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    // ÃƒÂ°Ã…Â¸Ã¢â‚¬Â Ã¢â‚¬Â¢ Badges d'alertes
                    if (alerts.isNotEmpty) ...[
                      const SizedBox(height: AppConstants.spacingExtraSmall),
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
                              borderRadius: BorderRadius.circular(AppConstants.borderRadiusTiny),
                              border: Border.all(
                                color: _getAlertColor(alert.type),
                                width: 1.0,
                              ),
                            ),
                            child: Text(
                              '${alert.category.icon} ${alert.getTitle(context)}',
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeTiny,
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
                  padding: const EdgeInsets.all(AppConstants.spacingExtraSmall),
                  decoration: BoxDecoration(
                    color: _getAlertColor(alerts.first.type)
                        .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${alerts.length}',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeBody,
                      fontWeight: FontWeight.bold,
                      color: _getAlertColor(alerts.first.type),
                    ),
                  ),
                ),

              const SizedBox(width: AppConstants.spacingExtraSmall),
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

  /// Widget : ÃƒÆ’Ã¢â‚¬Â°tat vide
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: AppConstants.iconSizeHuge,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            AppLocalizations.of(context).translate(AppStrings.noAnimalFoundMessage),
            style: TextStyle(
              fontSize: AppConstants.fontSizeImportant,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  /// Drawer de filtres (ÃƒÆ’Ã‚Â  implÃƒÆ’Ã‚Â©menter - garder l'existant)
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

// ÃƒÂ°Ã…Â¸Ã¢â‚¬Â Ã¢â‚¬Â¢ Enum mis ÃƒÆ’Ã‚Â  jour avec option "alerts"
enum GroupByOption {
  alerts, // ÃƒÂ°Ã…Â¸Ã¢â‚¬Â Ã¢â‚¬Â¢ NOUVEAU en premier !
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
  String label(BuildContext context) {
    // ÃƒÂ¢Ã¢â‚¬Â Ã‚Â Ajouter BuildContext
    switch (this) {
      case GroupByOption.alerts:
        return AppLocalizations.of(context).translate(AppStrings.byAlert);
      case GroupByOption.none:
        return AppLocalizations.of(context).translate(AppStrings.none);
      case GroupByOption.sex:
        return AppLocalizations.of(context).translate(AppStrings.bySex);
      case GroupByOption.age:
        return AppLocalizations.of(context).translate(AppStrings.byAge);
      case GroupByOption.status:
        return AppLocalizations.of(context).translate(AppStrings.byStatus);
      case GroupByOption.withdrawal:
        return AppLocalizations.of(context).translate(AppStrings.byWithdrawal);
      case GroupByOption.mother:
        return AppLocalizations.of(context).translate(AppStrings.byMother);
      case GroupByOption.species:
        return AppLocalizations.of(context).translate(AppStrings.byType);
      case GroupByOption.breed:
        return AppLocalizations.of(context).translate(AppStrings.byBreed);
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
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).translate(AppStrings.groupBy),
            style: const TextStyle(fontSize: AppConstants.fontSizeLarge, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          RadioGroup<GroupByOption>(
            groupValue: currentValue,
            onChanged: (value) {
              if (value != null) onSelected(value);
            },
            child: Column(
              children: GroupByOption.values.map((option) {
                return RadioListTile<GroupByOption>(
                  title: Text(option.label(context)),
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
      Set<String>, Set<String>) onApply; // MODIFIÃƒÆ’Ã¢â‚¬Â°
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
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context).translate(AppStrings.filters),
                    style: const TextStyle(
                        fontSize: AppConstants.fontSizeExtraLarge, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      widget.onReset();
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)
                        .translate(AppStrings.reset)),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingMedium),

              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    // Statut
                    Text(
                        AppLocalizations.of(context)
                            .translate(AppStrings.statusAnimal),
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    ...AnimalStatus.values.map((status) {
                      return CheckboxListTile(
                        title: Text(_getStatusLabel(context,
                            status)), // ÃƒÂ¢Ã¢â‚¬Â Ã‚Â Ajouter context
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
                    Text(AppLocalizations.of(context).translate(AppStrings.sex),
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    CheckboxListTile(
                      title: Text(
                          '♂️ ${AppLocalizations.of(context).translate(AppStrings.male)}'),
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
                      title: Text(
                          '♀️ ${AppLocalizations.of(context).translate(AppStrings.female)}'),
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

                    // ÃƒÆ’Ã¢â‚¬Å¡ge
                    Text(AppLocalizations.of(context).translate(AppStrings.age),
                        style: const TextStyle(fontWeight: FontWeight.w600)),
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
                    Text(
                        AppLocalizations.of(context)
                            .translate(AppStrings.animalType),
                        style: const TextStyle(fontWeight: FontWeight.w600)),
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
                    Text(
                        AppLocalizations.of(context)
                            .translate(AppStrings.breed),
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    if (_species.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(AppConstants.spacingMedium),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate(AppStrings.selectTypeFirst),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    else
                      ...() {
                        // Obtenir toutes les races des types sÃƒÆ’Ã‚Â©lectionnÃƒÆ’Ã‚Â©s
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
                                    style: const TextStyle(fontSize: AppConstants.fontSizeTiny),
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

                    // RÃƒÆ’Ã‚Â©manence
                    Text(
                        AppLocalizations.of(context)
                            .translate(AppStrings.withdrawal),
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    RadioGroup<bool?>(
                      groupValue: _withdrawal,
                      onChanged: (value) => setState(() => _withdrawal = value),
                      child: Column(
                        children: [
                          RadioListTile<bool?>(
                            title: Text(AppLocalizations.of(context)
                                .translate(AppStrings.all)),
                            value: null,
                          ),
                          RadioListTile<bool?>(
                            title: Text(AppLocalizations.of(context)
                                .translate(AppStrings.active)),
                            value: true,
                          ),
                          RadioListTile<bool?>(
                            title: Text(AppLocalizations.of(context)
                                .translate(AppStrings.inactive)),
                            value: false,
                          ),
                        ],
                      ),
                    ),

                    const Divider(),

                    // MÃƒÆ’Ã‚Â¨re
                    Text(
                        AppLocalizations.of(context)
                            .translate(AppStrings.mother),
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: TextField(
                        controller: _motherController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)
                              .translate(AppStrings.motherEid),
                          border: const OutlineInputBorder(),
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
                      child: Text(AppLocalizations.of(context)
                          .translate(AppStrings.cancel)),
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingSmall),
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
                      child: Text(AppLocalizations.of(context)
                          .translate(AppStrings.apply)),
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

  String _getStatusLabel(BuildContext context, AnimalStatus status) {
    switch (status) {
      case AnimalStatus.draft:
        return AppLocalizations.of(context).translate(AppStrings.draftStatus);
      case AnimalStatus.alive:
        return AppLocalizations.of(context).translate(AppStrings.statusAlive);
      case AnimalStatus.sold:
        return AppLocalizations.of(context).translate(AppStrings.statusSold);
      case AnimalStatus.dead:
        return AppLocalizations.of(context).translate(AppStrings.statusDead);
      case AnimalStatus.slaughtered:
        return AppLocalizations.of(context)
            .translate(AppStrings.statusSlaughtered);
    }
  }
}

// ==================== Enums ====================
