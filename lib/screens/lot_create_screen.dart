// lib/screens/lot_create_screen.dart
// Écran de création de lot avec choix du type (Purpose)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/batch_provider.dart';
import '../providers/sync_provider.dart';
import '../models/batch.dart';
import '../i18n/app_localizations.dart';
import 'batch_scan_screen.dart';

class LotCreateScreen extends StatefulWidget {
  const LotCreateScreen({super.key});

  @override
  State<LotCreateScreen> createState() => _LotCreateScreenState();
}

class _LotCreateScreenState extends State<LotCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  BatchPurpose _selectedPurpose = BatchPurpose.other;

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

    final batchProvider = context.read<BatchProvider>();
    final syncProvider = context.read<SyncProvider>();

    // Créer le lot avec le type sélectionné
    final batch = batchProvider.createBatch(
      _nameController.text,
      _selectedPurpose,
    );

    // Increment pending sync
    syncProvider.incrementPendingData();

    // Navigate to scan screen avec le batch créé
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BatchScanScreen(batch: batch),
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
                      'Créez un lot et scannez vos animaux pour des actions groupées.',
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

            // Type de lot
            Text(
              'Type de lot',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            _buildPurposeCard(
              purpose: BatchPurpose.treatment,
              icon: Icons.medical_services,
              title: 'Traitement',
              description: 'Vaccinations, vermifuges, soins groupés',
              color: Colors.blue,
            ),
            const SizedBox(height: 12),

            _buildPurposeCard(
              purpose: BatchPurpose.sale,
              icon: Icons.attach_money,
              title: 'Vente',
              description: 'Vente groupée d\'animaux',
              color: Colors.green,
            ),
            const SizedBox(height: 12),

            _buildPurposeCard(
              purpose: BatchPurpose.slaughter,
              icon: Icons.restaurant,
              title: 'Abattage',
              description: 'Abattage groupé avec vérification rémanence',
              color: Colors.red,
            ),
            const SizedBox(height: 12),

            _buildPurposeCard(
              purpose: BatchPurpose.other,
              icon: Icons.more_horiz,
              title: 'Autre',
              description: 'Tri, sélection, déplacement, etc.',
              color: Colors.grey,
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

  Widget _buildPurposeCard({
    required BatchPurpose purpose,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    final isSelected = _selectedPurpose == purpose;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPurpose = purpose;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isSelected ? color : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: color, size: 28)
            else
              Icon(Icons.circle_outlined,
                  color: Colors.grey.shade400, size: 28),
          ],
        ),
      ),
    );
  }
}
