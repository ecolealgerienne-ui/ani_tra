// screens/batch_create_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/batch.dart';
import '../../providers/batch_provider.dart';
import 'old_batch_scan_screen.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';

/// Écran de création de lot
///
/// Permet de définir :
/// - Nom du lot
/// - Objectif (vente, abattage, traitement, autre)
///
/// Puis navigue vers BatchScanScreen pour scanner les animaux
class BatchCreateScreen extends StatefulWidget {
  const BatchCreateScreen({super.key});

  @override
  State<BatchCreateScreen> createState() => _BatchCreateScreenState();
}

class _BatchCreateScreenState extends State<BatchCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  BatchPurpose _selectedPurpose = BatchPurpose.sale;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Démarrer le scan (créer le lot et naviguer)
  void _startScan() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final batchProvider = context.read<BatchProvider>();

    // Créer le lot
    final batch = batchProvider.createBatch(
      _nameController.text.trim(),
      _selectedPurpose,
    );

    // Naviguer vers l'écran de scan
    Future<void> startScan() async {
      final resolvedBatch = await batch;
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BatchScanScreen(batch: resolvedBatch),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context).translate(AppStrings.prepareBatch)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.batchCreatePadding),
          children: [
            // Illustration
            Center(
              child: Container(
                width: AppConstants.batchCreateIconSize,
                height: AppConstants.batchCreateIconSize,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.inventory,
                  size: AppConstants.batchCreateIconInnerSize,
                  color: Colors.deepPurple.shade400,
                ),
              ),
            ),

            const SizedBox(height: AppConstants.batchCreateSpacingLarge),

            // Description
            Text(
              AppLocalizations.of(context)
                  .translate(AppStrings.batchDescription),
              style: TextStyle(
                fontSize: AppConstants.batchCreateDescriptionSize,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppConstants.batchCreateSpacingLarge),

            // Nom du lot
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)
                    .translate(AppStrings.batchName),
                hintText: AppLocalizations.of(context)
                    .translate(AppStrings.batchNameHint),
                prefixIcon: const Icon(Icons.label),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppLocalizations.of(context)
                      .translate(AppStrings.batchNameRequired);
                }
                if (value.trim().length < AppConstants.batchNameMinLength) {
                  return AppLocalizations.of(context)
                      .translate(AppStrings.minCharacters);
                }
                return null;
              },
            ),

            const SizedBox(height: AppConstants.batchCreateSpacingMedium),

            // Objectif
            Text(
              AppLocalizations.of(context).translate(AppStrings.batchPurpose),
              style: const TextStyle(
                fontSize: AppConstants.batchCreateTitleSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppConstants.batchCreateSpacingSmall),

            // Grille de sélection
            GridView.count(
              crossAxisCount: AppConstants.batchCreateGridColumns,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppConstants.batchCreateSpacingSmall,
              crossAxisSpacing: AppConstants.batchCreateSpacingSmall,
              childAspectRatio: AppConstants.batchCreateGridAspectRatio,
              children: [
                _PurposeCard(
                  purpose: BatchPurpose.sale,
                  icon: Icons.sell,
                  label:
                      AppLocalizations.of(context).translate(AppStrings.sale),
                  color: AppConstants.statusSuccess,
                  isSelected: _selectedPurpose == BatchPurpose.sale,
                  onTap: () {
                    setState(() {
                      _selectedPurpose = BatchPurpose.sale;
                    });
                  },
                ),
                _PurposeCard(
                  purpose: BatchPurpose.slaughter,
                  icon: Icons.factory,
                  label: AppLocalizations.of(context)
                      .translate(AppStrings.slaughter),
                  color: AppConstants.statusDanger,
                  isSelected: _selectedPurpose == BatchPurpose.slaughter,
                  onTap: () {
                    setState(() {
                      _selectedPurpose = BatchPurpose.slaughter;
                    });
                  },
                ),
                _PurposeCard(
                  purpose: BatchPurpose.treatment,
                  icon: Icons.medical_services,
                  label: AppLocalizations.of(context)
                      .translate(AppStrings.treatment),
                  color: AppConstants.statusInfo,
                  isSelected: _selectedPurpose == BatchPurpose.treatment,
                  onTap: () {
                    setState(() {
                      _selectedPurpose = BatchPurpose.treatment;
                    });
                  },
                ),
                _PurposeCard(
                  purpose: BatchPurpose.other,
                  icon: Icons.category,
                  label:
                      AppLocalizations.of(context).translate(AppStrings.other),
                  color: Colors.grey,
                  isSelected: _selectedPurpose == BatchPurpose.other,
                  onTap: () {
                    setState(() {
                      _selectedPurpose = BatchPurpose.other;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: AppConstants.batchCreateSpacingLarge),

            // Bouton de démarrage
            ElevatedButton.icon(
              onPressed: _startScan,
              icon: const Icon(Icons.qr_code_scanner),
              label: Text(
                  AppLocalizations.of(context).translate(AppStrings.startScan)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.batchCreateButtonPadding),
                minimumSize: const Size(
                    double.infinity, AppConstants.batchCreateButtonHeight),
              ),
            ),

            const SizedBox(height: AppConstants.batchCreateSpacingMedium),

            // Bouton annuler
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                  AppLocalizations.of(context).translate(AppStrings.cancel)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget : Carte de sélection d'objectif
class _PurposeCard extends StatelessWidget {
  final BatchPurpose purpose;
  final IconData icon;
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _PurposeCard({
    required this.purpose,
    required this.icon,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.batchCreateCardRadius),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: AppConstants.batchCreateCardAlpha)
              : Colors.white,
          borderRadius:
              BorderRadius.circular(AppConstants.batchCreateCardRadius),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected
                ? AppConstants.batchCreateCardBorderSelected
                : AppConstants.batchCreateCardBorderNormal,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(
                        alpha: AppConstants.batchCreateCardShadowAlpha),
                    blurRadius: AppConstants.batchCreateCardShadowBlur,
                    offset: const Offset(
                        0, AppConstants.batchCreateCardShadowOffset),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey.shade600,
              size: AppConstants.batchCreateCardIconSize,
            ),
            const SizedBox(height: AppConstants.batchCreateCardSpacing),
            Text(
              label,
              style: TextStyle(
                fontSize: AppConstants.batchCreateCardTextSize,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.grey.shade700,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(
                    top: AppConstants.batchCreateCardCheckMargin),
                child: Icon(
                  Icons.check_circle,
                  color: color,
                  size: AppConstants.batchCreateCardCheckSize,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
