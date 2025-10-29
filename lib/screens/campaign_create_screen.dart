// lib/screens/campaign_create_screen.dart
// Artefact 15 : Vétérinaire dans Campagne
// Version : 1.2 - MVP Étendu avec vétérinaire optionnel

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/campaign_provider.dart';
import '../providers/sync_provider.dart';
import '../providers/qr_provider.dart';
import '../models/product.dart';
import '../data/mock_data.dart';
import '../i18n/app_localizations.dart';
import 'campaign_scan_screen.dart';

class CampaignCreateScreen extends StatefulWidget {
  const CampaignCreateScreen({super.key});

  @override
  State<CampaignCreateScreen> createState() => _CampaignCreateScreenState();
}

class _CampaignCreateScreenState extends State<CampaignCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  Product? _selectedProduct;
  DateTime _selectedDate = DateTime.now();

  // ==================== NOUVEAU v1.2 : Vétérinaire ====================
  String? _selectedVetId;
  String? _selectedVetName;
  String? _selectedVetOrg;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // ==================== NOUVEAU v1.2 : Méthodes Vétérinaire ====================

  /// Rechercher un vétérinaire dans la base de données
  void _searchVeterinarian() {
    showDialog(
      context: context,
      builder: (context) => _VeterinarianSearchDialog(
        veterinarians: MockData().mockVeterinarians,
        onSelect: (vet) {
          setState(() {
            _selectedVetId = vet['id'];
            _selectedVetName = vet['name'];
            _selectedVetOrg = vet['org'];
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  /// Scanner le QR Code d'un vétérinaire
  Future<void> _scanVeterinarianQR() async {
    final qrProvider = context.read<QRProvider>();

    // Générer un QR Code mock pour simulation
    final mockQR = qrProvider.generateMockQR('vet');

    // Valider le QR Code (simulation)
    await qrProvider.scanQRCode(mockQR);

    if (qrProvider.validatedUser != null) {
      setState(() {
        _selectedVetId = qrProvider.validatedUser!['id'];
        _selectedVetName = qrProvider.validatedUser!['name'];
        _selectedVetOrg = qrProvider.validatedUser!['org'];
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ ${qrProvider.validatedUser!['name']} validé'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// Retirer le vétérinaire sélectionné
  void _removeVeterinarian() {
    setState(() {
      _selectedVetId = null;
      _selectedVetName = null;
      _selectedVetOrg = null;
    });
  }

  // ==================== Création Campagne (MODIFIÉ v1.2) ====================

  void _createCampaign() {
    if (!_formKey.currentState!.validate() || _selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final campaignProvider = context.read<CampaignProvider>();
    final syncProvider = context.read<SyncProvider>();

    // MODIFIÉ : Inclure veterinarianId et veterinarianName
    final campaign = campaignProvider.createCampaign(
      name: _nameController.text,
      product: _selectedProduct!,
      treatmentDate: _selectedDate,
      veterinarianId: _selectedVetId, // ← NOUVEAU
      veterinarianName: _selectedVetName, // ← NOUVEAU
    );

    // Set as active campaign
    campaignProvider.setActiveCampaign(campaign);

    // Increment pending sync
    syncProvider.incrementPendingData();

    // Navigate to scan screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const CampaignScanScreen(),
      ),
    );
  }

  // ==================== UI Build ====================

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy');
    final withdrawalEnd = _selectedProduct != null
        ? _selectedDate
            .add(Duration(days: _selectedProduct!.withdrawalDaysMeat))
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('new_campaign')),
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
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Définissez la campagne une seule fois, puis scannez tous les animaux traités.',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Campaign Name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.translate('campaign_name'),
                hintText: 'Ex: Vermifuge Automne 2025',
                prefixIcon: const Icon(Icons.label),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nom requis';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Product Selection
            DropdownButtonFormField<Product>(
              value: _selectedProduct,
              decoration: InputDecoration(
                labelText: l10n.translate('select_product'),
                prefixIcon: const Icon(Icons.medication),
              ),
              items: MockData.products.map((product) {
                return DropdownMenuItem(
                  value: product,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${product.withdrawalDaysMeat} jours de rémanence',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProduct = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Produit requis';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Treatment Date
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade400),
              ),
              tileColor: Colors.white,
              leading: const Icon(Icons.calendar_today),
              title: Text(l10n.translate('treatment_date')),
              subtitle: Text(dateFormat.format(_selectedDate)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                  lastDate: DateTime.now().add(const Duration(days: 7)),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
            ),
            const SizedBox(height: 24),

            // ==================== NOUVEAU v1.2 : Section Vétérinaire ====================

            // Titre section
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Icon(Icons.person_outline, color: Colors.grey.shade700),
                  SizedBox(width: 8),
                  Text(
                    'Vétérinaire (optionnel)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),

            // Boutons de sélection
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _searchVeterinarian,
                    icon: Icon(Icons.search),
                    label: Text('Rechercher'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _scanVeterinarianQR,
                    icon: Icon(Icons.qr_code_scanner),
                    label: Text('Scanner QR'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

            // Affichage vétérinaire sélectionné
            if (_selectedVetName != null) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedVetName!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (_selectedVetOrg != null)
                            Text(
                              _selectedVetOrg!,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: _removeVeterinarian,
                      tooltip: 'Retirer',
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // ==================== Fin Section Vétérinaire ====================

            // Withdrawal End Warning
            if (withdrawalEnd != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade300, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber,
                          color: Colors.orange.shade700,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'FIN DE RÉMANENCE',
                            style: TextStyle(
                              color: Colors.orange.shade900,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      dateFormat.format(withdrawalEnd),
                      style: TextStyle(
                        color: Colors.orange.shade900,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Les animaux ne pourront être abattus avant cette date.',
                      style: TextStyle(
                        color: Colors.orange.shade800,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // Create Button
            ElevatedButton.icon(
              onPressed: _createCampaign,
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
}

// ==================== NOUVEAU v1.2 : Dialog Recherche Vétérinaire ====================

class _VeterinarianSearchDialog extends StatefulWidget {
  final List<Map<String, dynamic>> veterinarians;
  final Function(Map<String, dynamic>) onSelect;

  const _VeterinarianSearchDialog({
    required this.veterinarians,
    required this.onSelect,
  });

  @override
  State<_VeterinarianSearchDialog> createState() =>
      __VeterinarianSearchDialogState();
}

class __VeterinarianSearchDialogState extends State<_VeterinarianSearchDialog> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredVets = [];

  @override
  void initState() {
    super.initState();
    _filteredVets = widget.veterinarians;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterVets(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredVets = widget.veterinarians;
      } else {
        _filteredVets = widget.veterinarians
            .where((vet) =>
                vet['name'].toLowerCase().contains(query.toLowerCase()) ||
                vet['org'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rechercher un Vétérinaire'),
      contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 0),
      content: Container(
        width: double.maxFinite,
        constraints: BoxConstraints(maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Champ de recherche
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Nom ou établissement...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onChanged: _filterVets,
              autofocus: true,
            ),
            SizedBox(height: 16),

            // Résultats
            if (_filteredVets.isEmpty)
              Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Aucun vétérinaire trouvé',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredVets.length,
                  itemBuilder: (context, index) {
                    final vet = _filteredVets[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(Icons.person, color: Colors.blue.shade700),
                      ),
                      title: Text(
                        vet['name'],
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(vet['org']),
                          SizedBox(height: 4),
                          Text(
                            vet['license'],
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => widget.onSelect(vet),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Annuler'),
        ),
      ],
    );
  }
}
