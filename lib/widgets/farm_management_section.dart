// lib/widgets/farm_management_section.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';

/// Section gestion de ferme pour Settings
///
/// Phase 0-1: Affiche ferme actuelle (1 seule ferme)
/// Phase 4: Dialog multi-ferme activé quand hasMultipleFarms == true
class FarmManagementSection extends StatelessWidget {
  const FarmManagementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)
                      .translate(AppStrings.farmManagement),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                // Ferme actuelle
                ListTile(
                  leading: const Icon(Icons.agriculture, color: Colors.green),
                  title: Text(
                    AppLocalizations.of(context)
                        .translate(AppStrings.currentFarm),
                  ),
                  subtitle: Text(
                    auth.currentFarmName ?? '-',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                // Bouton changer de ferme (visible seulement si plusieurs fermes)
                if (auth.hasMultipleFarms) ...[
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.swap_horiz, color: Colors.blue),
                    title: Text(
                      AppLocalizations.of(context)
                          .translate(AppStrings.switchFarm),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showFarmSwitchDialog(context, auth),
                  ),
                ] else ...[
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: Colors.grey),
                    title: Text(
                      AppLocalizations.of(context)
                          .translate(AppStrings.farmPhase4Note),
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFarmSwitchDialog(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context).translate(AppStrings.availableFarms),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: auth.farms.map((farm) {
            final isActive = farm.id == auth.currentFarmId;
            return RadioListTile<String>(
              title: Text(farm.name),
              subtitle: Text(farm.location),
              value: farm.id,
              groupValue: auth.currentFarmId,
              selected: isActive,
              onChanged: (value) {
                if (value != null) {
                  auth.switchFarm(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                Text(AppLocalizations.of(context).translate(AppStrings.cancel)),
          ),
        ],
      ),
    );
  }
}
