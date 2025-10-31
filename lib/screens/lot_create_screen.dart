// lib/screens/lot_create_screen.dart
// Phase 2 : Création de lot unifié
// Adapté depuis campaign_create_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/lot_provider.dart';
import '../providers/sync_provider.dart';
import '../i18n/app_localizations.dart';
import 'lot_scan_screen.dart';

class LotCreateScreen extends StatefulWidget {
  const LotCreateScreen({super.key});

  @override
  State<LotCreateScreen> createState() => _LotCreateScreenState();
}

class _LotCreateScreenState extends State<LotCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _createLot() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final lotProvider = context.read<LotProvider>();
    final syncProvider = context.read<SyncProvider>();

    // Créer le lot (sans type pour l'instant)
    final lot = lotProvider.createLot(
      name: _nameController.text,
    );

    // Set as active lot
    lotProvider.setActiveLot(lot);

    // Increment pending sync
    syncProvider.incrementPendingData();

    // Navigate to scan screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LotScanScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('create_lot')),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Info Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.purple.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Créez un lot, scannez les animaux, puis choisissez son type lors de la finalisation.',
                      style: TextStyle(
                        color: Colors.purple.shade900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Lot Name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.translate('lot_name'),
                hintText: 'Ex: Sélection Brebis Novembre',
                prefixIcon: const Icon(Icons.inventory),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nom requis';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Avantages du système de lots
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline,
                          color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Pourquoi créer un lot ?',
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildAdvantageItem(
                    '✓ Scannez une fois pour plusieurs actions',
                  ),
                  _buildAdvantageItem(
                    '✓ Choisissez le type plus tard (vente, abattage, traitement)',
                  ),
                  _buildAdvantageItem(
                    '✓ Dupliquez facilement pour actions récurrentes',
                  ),
                  _buildAdvantageItem(
                    '✓ Gardez un historique complet',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Create Button
            ElevatedButton.icon(
              onPressed: _createLot,
              icon: const Icon(Icons.qr_code_scanner),
              label: Text(l10n.translate('start_scanning')),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvantageItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blue.shade800,
          fontSize: 13,
        ),
      ),
    );
  }
}
