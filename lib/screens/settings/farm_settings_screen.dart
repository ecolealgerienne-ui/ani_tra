// lib/screens/settings/farm_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/farm_provider.dart';
import '../../providers/farm_preferences_provider.dart';
import '../../providers/veterinarian_provider.dart';
import '../../providers/breed_provider.dart';
import '../../providers/alert_configuration_provider.dart';
import '../../models/farm.dart';
import '../../models/veterinarian.dart';
import '../../models/alert_configuration.dart';
import '../../data/animal_config.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';

/// Farm Settings Screen - Phase 1
/// Écran de configuration des paramètres de ferme
/// 4 sections : Sélection de ferme, Préférences d'élevage, Vétérinaire, Alertes
class FarmSettingsScreen extends StatefulWidget {
  const FarmSettingsScreen({super.key});

  @override
  State<FarmSettingsScreen> createState() => _FarmSettingsScreenState();
}

class _FarmSettingsScreenState extends State<FarmSettingsScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authProvider = context.watch<AuthProvider>();
    final farmProvider = context.watch<FarmProvider>();
    final prefsProvider = context.watch<FarmPreferencesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate(AppStrings.farmSettings)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // En-tête avec subtitle
                Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.translate(AppStrings.farmSettingsTitle),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppConstants.spacingTiny),
                      Text(
                        l10n.translate(AppStrings.farmSettingsSubtitle),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),

                const Divider(),

                // ========================================
                // SECTION 1 : Sélection de la ferme
                // ========================================
                _FarmSelectionSection(
                  farms: farmProvider.farms,
                  currentFarmId: authProvider.currentFarmId,
                  onFarmSelected: (farmId) => _switchFarm(farmId),
                ),

                const Divider(),

                // ========================================
                // SECTION 2 : Préférences d'élevage
                // ========================================
                _BreedingPreferencesSection(
                  defaultSpeciesId: prefsProvider.defaultSpeciesId,
                  defaultBreedId: prefsProvider.defaultBreedId,
                  onSpeciesChanged: (speciesId) =>
                      _updateDefaultSpecies(speciesId),
                  onBreedChanged: (breedId) => _updateDefaultBreed(breedId),
                ),

                const Divider(),

                // ========================================
                // SECTION 3 : Paramètres vétérinaire
                // ========================================
                _VeterinarianSettingsSection(
                  defaultVeterinarianId: prefsProvider.defaultVeterinarianId,
                  onVeterinarianSelected: (vetId) =>
                      _updateDefaultVeterinarian(vetId),
                ),

                const Divider(),

                // ========================================
                // SECTION 4 : Paramètres d'alertes
                // ========================================
                const _AlertSettingsSection(),

                const SizedBox(height: AppConstants.spacingLarge),
              ],
            ),
    );
  }

  // ==================== Actions ====================

  Future<void> _switchFarm(String farmId) async {
    setState(() => _isLoading = true);
    try {
      final authProvider = context.read<AuthProvider>();
      await authProvider.switchFarm(farmId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)
                  .translate(AppStrings.preferencesUpdated),
            ),
            backgroundColor: AppConstants.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)
                  .translate(AppStrings.errorUpdatingPreferences),
            ),
            backgroundColor: AppConstants.statusDanger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updateDefaultSpecies(String speciesId) async {
    setState(() => _isLoading = true);
    try {
      final prefsProvider = context.read<FarmPreferencesProvider>();
      await prefsProvider.updateDefaultSpecies(speciesId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)
                  .translate(AppStrings.preferencesUpdated),
            ),
            backgroundColor: AppConstants.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)
                  .translate(AppStrings.errorUpdatingPreferences),
            ),
            backgroundColor: AppConstants.statusDanger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updateDefaultBreed(String? breedId) async {
    setState(() => _isLoading = true);
    try {
      final prefsProvider = context.read<FarmPreferencesProvider>();
      await prefsProvider.updateDefaultBreed(breedId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)
                  .translate(AppStrings.preferencesUpdated),
            ),
            backgroundColor: AppConstants.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)
                  .translate(AppStrings.errorUpdatingPreferences),
            ),
            backgroundColor: AppConstants.statusDanger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updateDefaultVeterinarian(String? vetId) async {
    setState(() => _isLoading = true);
    try {
      final prefsProvider = context.read<FarmPreferencesProvider>();
      await prefsProvider.updateDefaultVeterinarian(vetId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)
                  .translate(AppStrings.preferencesUpdated),
            ),
            backgroundColor: AppConstants.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)
                  .translate(AppStrings.errorUpdatingPreferences),
            ),
            backgroundColor: AppConstants.statusDanger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

}

// ==========================================
// SECTION 1: Farm Selection
// ==========================================
class _FarmSelectionSection extends StatelessWidget {
  final List<Farm> farms;
  final String currentFarmId;
  final ValueChanged<String> onFarmSelected;

  const _FarmSelectionSection({
    required this.farms,
    required this.currentFarmId,
    required this.onFarmSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Handle case when no farms are available
    if (farms.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: l10n.translate(AppStrings.farmSelection),
            subtitle: l10n.translate(AppStrings.farmSelectionSubtitle),
            icon: Icons.business,
          ),
          const Padding(
            padding: EdgeInsets.all(AppConstants.farmSettingsSectionPaddingH),
            child: Card(
              elevation: AppConstants.mainCardElevation,
              child: Padding(
                padding: EdgeInsets.all(AppConstants.spacingMedium),
                child: Column(
                  children: [
                    Icon(Icons.warning, color: Colors.orange, size: 48),
                    SizedBox(height: AppConstants.spacingSmall),
                    Text(
                      l10n.translate(AppStrings.noFarmAvailable),
                      style: TextStyle(fontSize: AppConstants.fontSizeImportant),
                    ),
                    SizedBox(height: AppConstants.spacingTiny),
                    Text(
                      l10n.translate(AppStrings.pleaseCreateFarm),
                      style: TextStyle(fontSize: AppConstants.fontSizeSmall, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Find the current farm, or use the first farm if not found
    // This should be safe because we already checked farms.isEmpty above
    final currentFarm = farms.firstWhere(
      (f) => f.id == currentFarmId,
      orElse: () => farms.isNotEmpty ? farms.first :
        throw StateError('No farms available - this should never happen'),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: l10n.translate(AppStrings.farmSelection),
          subtitle: l10n.translate(AppStrings.farmSelectionSubtitle),
          icon: Icons.business,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.farmSettingsSectionPaddingH,
          ),
          child: Card(
            elevation: AppConstants.mainCardElevation,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.farmSettingsCardRadius),
            ),
            child: InkWell(
              onTap: () => _showFarmSelectionDialog(context),
              borderRadius:
                  BorderRadius.circular(AppConstants.farmSettingsCardRadius),
              child: Padding(
                padding: const EdgeInsets.all(
                  AppConstants.farmSettingsCardPadding,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(
                        AppConstants.spacingSmall,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusMedium,
                        ),
                      ),
                      child: Icon(
                        Icons.store,
                        color: Theme.of(context).primaryColor,
                        size: AppConstants.iconSizeMedium,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentFarm.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: AppConstants.spacingTiny),
                          Text(
                            currentFarm.location,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showFarmSelectionDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.copyWith(
            bodyLarge: const TextStyle(color: Colors.black),
            bodyMedium: const TextStyle(color: Colors.black87),
          ),
        ),
        child: AlertDialog(
          title: Text(l10n.translate(AppStrings.selectFarm)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: farms.length,
              itemBuilder: (context, index) {
              final farm = farms[index];
              final isSelected = farm.id == currentFarmId;

              return ListTile(
                leading: Icon(
                  Icons.store,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
                title: Text(
                  farm.name,
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.black,
                  ),
                ),
                subtitle: Text(
                  farm.location,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).primaryColor,
                      )
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  onFarmSelected(farm.id);
                },
              );
            },
          ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.translate(AppStrings.cancel)),
          ),
        ],
        ),
      ),
    );
  }
}

// ==========================================
// SECTION 2: Breeding Preferences
// ==========================================
class _BreedingPreferencesSection extends StatelessWidget {
  final String defaultSpeciesId;
  final String? defaultBreedId;
  final ValueChanged<String> onSpeciesChanged;
  final ValueChanged<String?> onBreedChanged;

  const _BreedingPreferencesSection({
    required this.defaultSpeciesId,
    required this.defaultBreedId,
    required this.onSpeciesChanged,
    required this.onBreedChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final breedProvider = context.watch<BreedProvider>();

    // ✅ Use real species data from AnimalConfig
    final speciesOptions = AnimalConfig.availableSpecies
        .map((species) => {
              'id': species.id,
              'name': species.nameFr,
            })
        .toList();

    // ✅ Use real breed data from BreedProvider (filtered by selected species)
    final availableBreeds = breedProvider.activeBreeds
        .where((breed) => breed.speciesId == defaultSpeciesId)
        .toList();

    final breedOptions = availableBreeds
        .map((breed) => {
              'id': breed.id,
              'name': breed.nameFr,
            })
        .toList();

    // Find selected species, fallback to first if not found (or default if list is empty)
    final selectedSpecies = speciesOptions.isNotEmpty
        ? speciesOptions.firstWhere(
            (s) => s['id'] == defaultSpeciesId,
            orElse: () => speciesOptions.first,
          )
        : {'id': 'sheep', 'name': 'Ovin'}; // Fallback if no species available

    // Find selected breed, fallback to first if not found (or null if no breeds)
    final Map<String, String>? selectedBreed = defaultBreedId != null && breedOptions.isNotEmpty
        ? breedOptions.firstWhere(
            (b) => b['id'] == defaultBreedId,
            orElse: () => breedOptions.first,
          )
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: l10n.translate(AppStrings.breedingPreferences),
          subtitle: l10n.translate(AppStrings.breedingPreferencesSubtitle),
          icon: Icons.pets,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.farmSettingsSectionPaddingH,
          ),
          child: Column(
            children: [
              // Default Species
              _SettingsCard(
                icon: Icons.category,
                title: l10n.translate(AppStrings.defaultSpecies),
                value: selectedSpecies['name']!,
                onTap: () => _showSpeciesDialog(context, speciesOptions),
              ),
              const SizedBox(height: AppConstants.spacingSmall),
              // Default Breed
              _SettingsCard(
                icon: Icons.pets,
                title: l10n.translate(AppStrings.defaultBreed),
                value: selectedBreed?['name'] ??
                    l10n.translate(AppStrings.noneChooseEachTime),
                onTap: () => _showBreedDialog(context, breedOptions),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSpeciesDialog(
      BuildContext context, List<Map<String, String>> speciesOptions) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.copyWith(
            bodyLarge: const TextStyle(color: Colors.black),
            bodyMedium: const TextStyle(color: Colors.black87),
          ),
        ),
        child: AlertDialog(
          title: Text(l10n.translate(AppStrings.selectDefaultSpecies)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: speciesOptions.length,
              itemBuilder: (context, index) {
                final species = speciesOptions[index];
                final isSelected = species['id'] == defaultSpeciesId;

              return ListTile(
                leading: Icon(
                  Icons.category,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
                title: Text(
                  species['name']!,
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.black,
                  ),
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).primaryColor,
                      )
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  onSpeciesChanged(species['id']!);
                },
              );
            },
          ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.translate(AppStrings.cancel)),
          ),
        ],
        ),
      ),
    );
  }

  void _showBreedDialog(
      BuildContext context, List<Map<String, String>> breedOptions) {
    final l10n = AppLocalizations.of(context);
    final List<Map<String, String?>> optionsWithNone = [
      <String, String?>{'id': null, 'name': l10n.translate(AppStrings.noneChooseEachTime)},
      ...breedOptions,
    ];

    showDialog(
      context: context,
      builder: (context) => Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.copyWith(
            bodyLarge: const TextStyle(color: Colors.black),
            bodyMedium: const TextStyle(color: Colors.black87),
          ),
        ),
        child: AlertDialog(
          title: Text(l10n.translate(AppStrings.selectDefaultBreed)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: optionsWithNone.length,
              itemBuilder: (context, index) {
                final breed = optionsWithNone[index];
                final isSelected = breed['id'] == defaultBreedId;

              return ListTile(
                leading: Icon(
                  breed['id'] == null ? Icons.close : Icons.pets,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
                title: Text(
                  breed['name']!,
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.black,
                  ),
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).primaryColor,
                      )
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  onBreedChanged(breed['id']);
                },
              );
            },
          ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.translate(AppStrings.cancel)),
          ),
        ],
        ),
      ),
    );
  }
}

// ==========================================
// SECTION 3: Veterinarian Settings
// ==========================================
class _VeterinarianSettingsSection extends StatelessWidget {
  final String? defaultVeterinarianId;
  final ValueChanged<String?> onVeterinarianSelected;

  const _VeterinarianSettingsSection({
    required this.defaultVeterinarianId,
    required this.onVeterinarianSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final vetProvider = context.watch<VeterinarianProvider>();

    Veterinarian? selectedVet;
    if (defaultVeterinarianId != null) {
      selectedVet = vetProvider.getVeterinarianById(defaultVeterinarianId!);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: l10n.translate(AppStrings.veterinarianSettings),
          subtitle: l10n.translate(AppStrings.veterinarianSettingsSubtitle),
          icon: Icons.medical_services,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.farmSettingsSectionPaddingH,
          ),
          child: _SettingsCard(
            icon: Icons.person,
            title: l10n.translate(AppStrings.defaultVeterinarian),
            value: selectedVet?.fullName ??
                l10n.translate(AppStrings.noneChooseEachTime),
            subtitle: selectedVet?.clinic,
            onTap: () => _showVeterinarianDialog(context, vetProvider),
          ),
        ),
      ],
    );
  }

  void _showVeterinarianDialog(
      BuildContext context, VeterinarianProvider vetProvider) {
    final l10n = AppLocalizations.of(context);
    final veterinarians = vetProvider.veterinarians;

    final optionsWithNone = [
      null,
      ...veterinarians,
    ];

    showDialog(
      context: context,
      builder: (context) => Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.copyWith(
            bodyLarge: const TextStyle(color: Colors.black),
            bodyMedium: const TextStyle(color: Colors.black87),
          ),
        ),
        child: AlertDialog(
          title: Text(l10n.translate(AppStrings.selectDefaultVeterinarian)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: optionsWithNone.length,
              itemBuilder: (context, index) {
                final vet = optionsWithNone[index];
                final isSelected = vet?.id == defaultVeterinarianId;

              if (vet == null) {
                return ListTile(
                  leading: Icon(
                    Icons.close,
                    color: defaultVeterinarianId == null
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                  title: Text(
                    l10n.translate(AppStrings.noneChooseEachTime),
                    style: TextStyle(
                      fontWeight: defaultVeterinarianId == null
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: defaultVeterinarianId == null
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                    ),
                  ),
                  trailing: defaultVeterinarianId == null
                      ? Icon(
                          Icons.check_circle,
                          color: Theme.of(context).primaryColor,
                        )
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    onVeterinarianSelected(null);
                  },
                );
              }

              return ListTile(
                leading: Icon(
                  Icons.person,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
                title: Text(
                  vet.fullName,
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.black,
                  ),
                ),
                subtitle: Text(
                  vet.clinic ?? '',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).primaryColor,
                      )
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  onVeterinarianSelected(vet.id);
                },
              );
            },
          ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.translate(AppStrings.cancel)),
          ),
        ],
        ),
      ),
    );
  }
}

// ==========================================
// SECTION 4: Alert Settings
// ==========================================
class _AlertSettingsSection extends StatelessWidget {
  const _AlertSettingsSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final alertProvider = context.watch<AlertConfigurationProvider>();

    // Sort configurations by severity: CRITIQUE (3) → IMPORTANT (2) → ROUTINE (1)
    final configs = alertProvider.configurations.toList()
      ..sort((a, b) => b.severity.compareTo(a.severity));
    final stats = alertProvider.stats;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: l10n.translate(AppStrings.alertSettings),
          subtitle: l10n.translate(AppStrings.alertSettingsSubtitle),
          icon: Icons.notifications_active,
        ),

        // Statistics Card
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.farmSettingsSectionPaddingH,
          ),
          child: Card(
            elevation: AppConstants.mainCardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.farmSettingsCardRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.farmSettingsCardPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _AlertStat(
                    label: AppLocalizations.of(context).translate(AppStrings.total),
                    value: stats['total'].toString(),
                    color: Colors.blue,
                  ),
                  _AlertStat(
                    label: AppLocalizations.of(context).translate(AppStrings.enabled),
                    value: stats['enabled'].toString(),
                    color: AppConstants.successGreen,
                  ),
                  _AlertStat(
                    label: AppLocalizations.of(context).translate(AppStrings.disabled),
                    value: stats['disabled'].toString(),
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: AppConstants.spacingSmall),

        // Alert Configurations List
        if (alertProvider.isLoading)
          const Padding(
            padding: EdgeInsets.all(AppConstants.spacingLarge),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        else if (configs.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.farmSettingsSectionPaddingH,
            ),
            child: Card(
              elevation: AppConstants.mainCardElevation,
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMedium),
                child: Column(
                  children: [
                    const Icon(Icons.info_outline, size: 48, color: Colors.blue),
                    const SizedBox(height: AppConstants.spacingSmall),
                    Text(
                      l10n.translate(AppStrings.initializingAlerts),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: AppConstants.fontSizeImportant,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingTiny),
                    Text(
                      l10n.translate(AppStrings.creatingDefaultConfigs),
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: AppConstants.fontSizeSmall,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ...configs.map((config) => _AlertConfigItem(config: config)),
      ],
    );
  }
}

/// Single Alert Configuration Item with Toggle
class _AlertConfigItem extends StatelessWidget {
  final AlertConfiguration config;

  const _AlertConfigItem({required this.config});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final alertProvider = context.read<AlertConfigurationProvider>();

    // Get title from i18n
    final title = l10n.translate(config.titleKey);

    // Parse color from hex
    final color = Color(int.parse(config.colorHex.replaceFirst('#', '0xFF')));

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.farmSettingsSectionPaddingH,
        vertical: 4,
      ),
      child: Card(
        elevation: AppConstants.mainCardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.farmSettingsCardRadius),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.farmSettingsCardPadding,
            vertical: 8,
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            ),
            child: Text(
              config.iconName,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppConstants.fontSizeImportant,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _SeverityBadge(severity: config.severity, color: color),
            ],
          ),
          trailing: Switch(
            value: config.enabled,
            activeTrackColor: color,
            onChanged: (value) async {
              try {
                await alertProvider.toggleEnabled(config.id, value);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value
                            ? l10n.translate(AppStrings.alertEnabled).replaceFirst('{title}', title)
                            : l10n.translate(AppStrings.alertDisabled).replaceFirst('{title}', title),
                      ),
                      backgroundColor: value ? AppConstants.successGreen : Colors.grey,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${AppLocalizations.of(context).translate(AppStrings.errorUpdatingPreferences)}: $e'),
                      backgroundColor: AppConstants.statusDanger,
                    ),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}

/// Severity Badge Widget
class _SeverityBadge extends StatelessWidget {
  final int severity;
  final Color color;

  const _SeverityBadge({required this.severity, required this.color});

  @override
  Widget build(BuildContext context) {
    final label = _getSeverityLabel(severity);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  String _getSeverityLabel(int severity) {
    switch (severity) {
      case 3:
        return 'CRITIQUE';
      case 2:
        return 'IMPORTANT';
      case 1:
      default:
        return 'ROUTINE';
    }
  }
}

/// Alert Statistics Widget
class _AlertStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _AlertStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

// ==========================================
// REUSABLE WIDGETS
// ==========================================

/// Section Header Widget
class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.farmSettingsSectionPaddingH,
        AppConstants.spacingMedium,
        AppConstants.farmSettingsSectionPaddingH,
        AppConstants.spacingSmall,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppConstants.farmSettingsIconSize,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: AppConstants.spacingSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: AppConstants.farmSettingsSectionTitleSize,
                      ),
                ),
                const SizedBox(height: AppConstants.spacingTiny),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontSize: AppConstants.farmSettingsSectionSubtitleSize,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Settings Card Widget
class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppConstants.mainCardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.farmSettingsCardRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(AppConstants.farmSettingsCardRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.farmSettingsCardPadding),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingSmall),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadiusMedium),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: AppConstants.iconSizeMedium,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: AppConstants.spacingTiny),
                    if (value.isNotEmpty)
                      Text(
                        value,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: AppConstants.spacingTiny),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[500],
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
