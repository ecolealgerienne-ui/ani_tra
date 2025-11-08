// lib/widgets/farm_preferences_section.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../data/animal_config.dart';
import '../i18n/app_localizations.dart';
import '../i18n/app_strings.dart';
import '../utils/constants.dart';

class FarmPreferencesSection extends StatelessWidget {
  const FarmPreferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        final currentSpecies = AnimalConfig.getSpeciesById(
          settingsProvider.defaultSpeciesId,
        );
        final currentBreed = settingsProvider.defaultBreedId != null
            ? AnimalConfig.getBreedById(settingsProvider.defaultBreedId!)
            : null;

        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.pets,
                      color: Theme.of(context).primaryColor,
                      size: AppConstants.iconSizeMediumLarge,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${l10n.translate(AppStrings.farmEmojiSheep)} ${l10n.translate(AppStrings.farmPreferencesTitle)}',
                            style: const TextStyle(
                              fontSize: AppConstants.fontSizeImportant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.translate(AppStrings.farmPreferencesSubtitle),
                            style: const TextStyle(
                              fontSize: AppConstants.fontSizeSmall,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32),
                _buildSettingTile(
                  context: context,
                  icon: Icons.category,
                  title: l10n.translate(AppStrings.defaultAnimalType),
                  value: currentSpecies != null
                      ? '${currentSpecies.icon} ${currentSpecies.nameFr}'
                      : l10n.translate(AppStrings.notDefined),
                  onTap: () => _showSpeciesSelector(context, settingsProvider),
                ),
                const SizedBox(height: 12),
                _buildSettingTile(
                  context: context,
                  icon: Icons.pets,
                  title: l10n.translate(AppStrings.defaultBreed),
                  value: currentBreed != null
                      ? currentBreed.nameFr
                      : l10n.translate(AppStrings.noBreedSelected),
                  onTap: () => _showBreedSelector(context, settingsProvider),
                  enabled: settingsProvider.defaultSpeciesId.isNotEmpty,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadiusMedium),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Colors.blue.shade700,
                          size: AppConstants.iconSizeRegular),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.translate(AppStrings.farmPreferencesInfo),
                          style: const TextStyle(
                              fontSize: AppConstants.fontSizeSmall),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
    bool enabled = true,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: enabled ? Colors.grey.shade50 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: enabled ? Theme.of(context).primaryColor : Colors.grey,
              size: AppConstants.iconSizeRegular,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeBody,
                      fontWeight: FontWeight.w500,
                      color: enabled ? Colors.black87 : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeSectionTitle,
                      fontWeight: FontWeight.bold,
                      color: enabled
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: enabled ? Colors.grey : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  void _showSpeciesSelector(
    BuildContext context,
    SettingsProvider settingsProvider,
  ) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate(AppStrings.defaultAnimalType)),
        content: RadioGroup<String>(
          groupValue: settingsProvider.defaultSpeciesId,
          onChanged: (value) {
            if (value != null) {
              settingsProvider.setDefaultSpecies(value);
              final breeds = AnimalConfig.getBreedsBySpecies(value);
              if (breeds.isNotEmpty) {
                settingsProvider.setDefaultBreed(breeds.first.id);
              } else {
                settingsProvider.setDefaultBreed(null);
              }
              Navigator.pop(context);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: AnimalConfig.availableSpecies.map((species) {
              return RadioListTile<String>(
                title: Text('${species.icon} ${species.nameFr}'),
                value: species.id,
                activeColor: Theme.of(context).primaryColor,
              );
            }).toList(),
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

  void _showBreedSelector(
    BuildContext context,
    SettingsProvider settingsProvider,
  ) {
    final l10n = AppLocalizations.of(context);
    final breeds = AnimalConfig.getBreedsBySpecies(
      settingsProvider.defaultSpeciesId,
    );

    if (breeds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.translate(AppStrings.noBreedAvailable)),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate(AppStrings.defaultBreed)),
        content: RadioGroup<String?>(
          groupValue: settingsProvider.defaultBreedId,
          onChanged: (value) {
            settingsProvider.setDefaultBreed(value);
            Navigator.pop(context);
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String?>(
                  title: Text(l10n.translate(AppStrings.noneChooseEachTime)),
                  value: null,
                  activeColor: Theme.of(context).primaryColor,
                ),
                const Divider(),
                ...breeds.map((breed) {
                  return RadioListTile<String?>(
                    title: Text(breed.nameFr),
                    subtitle: breed.description != null
                        ? Text(
                            breed.description!,
                            style: const TextStyle(
                                fontSize: AppConstants.fontSizeTiny),
                          )
                        : null,
                    value: breed.id,
                    activeColor: Theme.of(context).primaryColor,
                  );
                }),
              ],
            ),
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
