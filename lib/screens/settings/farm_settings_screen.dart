// lib/screens/settings/farm_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/farm_provider.dart';
import '../../providers/farm_preferences_provider.dart';
import '../../providers/veterinarian_provider.dart';
import '../../models/farm.dart';
import '../../models/veterinarian.dart';
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
                _AlertSettingsSection(
                  onManageAlerts: () => _navigateToAlertSettings(),
                ),

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

  void _navigateToAlertSettings() {
    // TODO: Navigate to alert configuration screen when implemented
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gestion des alertes - À implémenter en Phase 1B'),
      ),
    );
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
                      'Aucune ferme disponible',
                      style: TextStyle(fontSize: AppConstants.fontSizeImportant),
                    ),
                    SizedBox(height: AppConstants.spacingTiny),
                    Text(
                      'Veuillez créer une ferme pour continuer',
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

    final currentFarm = farms.firstWhere(
      (f) => f.id == currentFarmId,
      orElse: () => farms.first,
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
      builder: (context) => AlertDialog(
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
                  ),
                ),
                subtitle: Text(farm.location),
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
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.translate(AppStrings.cancel)),
          ),
        ],
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

    // TODO: Replace with actual species/breed data from providers
    // For now, using hardcoded values for Phase 1
    final speciesOptions = [
      {'id': 'sheep', 'name': 'Ovin'},
      {'id': 'goat', 'name': 'Caprin'},
      {'id': 'cattle', 'name': 'Bovin'},
    ];

    final breedOptions = [
      {'id': 'merinos', 'name': 'Mérinos'},
      {'id': 'suffolk', 'name': 'Suffolk'},
      {'id': 'texel', 'name': 'Texel'},
    ];

    final selectedSpecies = speciesOptions.firstWhere(
      (s) => s['id'] == defaultSpeciesId,
      orElse: () => speciesOptions.first,
    );

    final Map<String, String>? selectedBreed = defaultBreedId != null
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
      builder: (context) => AlertDialog(
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
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.translate(AppStrings.cancel)),
          ),
        ],
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
      builder: (context) => AlertDialog(
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
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.translate(AppStrings.cancel)),
          ),
        ],
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
      builder: (context) => AlertDialog(
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
                  ),
                ),
                subtitle: Text(vet.clinic ?? ''),
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
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.translate(AppStrings.cancel)),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// SECTION 4: Alert Settings
// ==========================================
class _AlertSettingsSection extends StatelessWidget {
  final VoidCallback onManageAlerts;

  const _AlertSettingsSection({
    required this.onManageAlerts,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: l10n.translate(AppStrings.alertSettings),
          subtitle: l10n.translate(AppStrings.alertSettingsSubtitle),
          icon: Icons.notifications_active,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.farmSettingsSectionPaddingH,
          ),
          child: _SettingsCard(
            icon: Icons.settings,
            title: l10n.translate(AppStrings.manageAlertPreferences),
            value: '',
            onTap: onManageAlerts,
            showChevron: true,
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
  final bool showChevron;

  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
    required this.onTap,
    this.showChevron = true,
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
              if (showChevron)
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
