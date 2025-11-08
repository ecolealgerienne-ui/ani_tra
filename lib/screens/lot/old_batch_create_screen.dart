// screens/batch_create_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/batch.dart';
import '../../providers/batch_provider.dart';
import 'old_batch_scan_screen.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';

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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BatchScanScreen(batch: batch),
      ),
    );
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
          padding: const EdgeInsets.all(16),
          children: [
            // Illustration
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.inventory,
                  size: 60,
                  color: Colors.deepPurple.shade400,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Description
            Text(
              AppLocalizations.of(context).translate(AppStrings.batchDescription),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

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
                if (value.trim().length < 3) {
                  return AppLocalizations.of(context)
                      .translate(AppStrings.minCharacters);
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Objectif
            Text(
              AppLocalizations.of(context).translate(AppStrings.batchPurpose),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),

            // Grille de sélection
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.8,
              children: [
                _PurposeCard(
                  purpose: BatchPurpose.sale,
                  icon: Icons.sell,
                  label:
                      AppLocalizations.of(context).translate(AppStrings.sale),
                  color: Colors.green,
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
                  color: Colors.red,
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
                  color: Colors.blue,
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

            const SizedBox(height: 32),

            // Bouton de démarrage
            ElevatedButton.icon(
              onPressed: _startScan,
              icon: const Icon(Icons.qr_code_scanner),
              label: Text(
                  AppLocalizations.of(context).translate(AppStrings.startScan)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),

            const SizedBox(height: 16),

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
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
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
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.grey.shade700,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                child: Icon(
                  Icons.check_circle,
                  color: color,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
