// lib/widgets/farm_preferences_section.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../data/animal_config.dart';

/// Section "Préférences d'élevage" pour l'écran des paramètres
///
/// ÉTAPE 4 : Permet de configurer le type et la race par défaut
/// pour simplifier l'ajout d'animaux.
class FarmPreferencesSection extends StatelessWidget {
  const FarmPreferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
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
                // Header
                Row(
                  children: [
                    Icon(
                      Icons.pets,
                      color: Theme.of(context).primaryColor,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🐑 Préférences d\'élevage',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Valeurs pré-remplies lors de l\'ajout d\'un animal',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const Divider(height: 32),

                // Type d'animal par défaut
                _buildSettingTile(
                  context: context,
                  icon: Icons.category,
                  title: 'Type d\'animal par défaut',
                  value: currentSpecies != null
                      ? '${currentSpecies.icon} ${currentSpecies.nameFr}'
                      : 'Non défini',
                  onTap: () => _showSpeciesSelector(context, settingsProvider),
                ),

                const SizedBox(height: 12),

                // Race par défaut
                _buildSettingTile(
                  context: context,
                  icon: Icons.pets,
                  title: 'Race par défaut',
                  value: currentBreed != null ? currentBreed.nameFr : 'Aucune',
                  onTap: () => _showBreedSelector(context, settingsProvider),
                  enabled: settingsProvider.defaultSpeciesId.isNotEmpty,
                ),

                const SizedBox(height: 16),

                // Info box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Colors.blue.shade700, size: 20),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Ces valeurs seront automatiquement pré-remplies lors de l\'ajout d\'un nouvel animal. Vous pourrez toujours les modifier.',
                          style: TextStyle(fontSize: 12),
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
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: enabled ? Colors.grey.shade50 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: enabled ? Theme.of(context).primaryColor : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: enabled ? Colors.black87 : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
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

  // ==================== DIALOGS ====================

  void _showSpeciesSelector(
    BuildContext context,
    SettingsProvider settingsProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Type d\'animal par défaut'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AnimalConfig.availableSpecies.map((species) {
            final isSelected = species.id == settingsProvider.defaultSpeciesId;
            return RadioListTile<String>(
              title: Text('${species.icon} ${species.nameFr}'),
              value: species.id,
              groupValue: settingsProvider.defaultSpeciesId,
              onChanged: (value) {
                if (value != null) {
                  settingsProvider.setDefaultSpecies(value);
                  // Réinitialiser la race si on change de type
                  final breeds = AnimalConfig.getBreedsBySpecies(value);
                  if (breeds.isNotEmpty) {
                    settingsProvider.setDefaultBreed(breeds.first.id);
                  } else {
                    settingsProvider.setDefaultBreed(null);
                  }
                  Navigator.pop(context);
                }
              },
              activeColor: Theme.of(context).primaryColor,
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  void _showBreedSelector(
    BuildContext context,
    SettingsProvider settingsProvider,
  ) {
    final breeds = AnimalConfig.getBreedsBySpecies(
      settingsProvider.defaultSpeciesId,
    );

    if (breeds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aucune race disponible pour ce type d\'animal'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Race par défaut'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String?>(
                title: const Text('Aucune (à choisir à chaque fois)'),
                value: null,
                groupValue: settingsProvider.defaultBreedId,
                onChanged: (value) {
                  settingsProvider.setDefaultBreed(null);
                  Navigator.pop(context);
                },
                activeColor: Theme.of(context).primaryColor,
              ),
              const Divider(),
              ...breeds.map((breed) {
                return RadioListTile<String>(
                  title: Text(breed.nameFr),
                  subtitle: breed.description != null
                      ? Text(
                          breed.description!,
                          style: const TextStyle(fontSize: 11),
                        )
                      : null,
                  value: breed.id,
                  groupValue: settingsProvider.defaultBreedId,
                  onChanged: (value) {
                    if (value != null) {
                      settingsProvider.setDefaultBreed(value);
                      Navigator.pop(context);
                    }
                  },
                  activeColor: Theme.of(context).primaryColor,
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }
}
