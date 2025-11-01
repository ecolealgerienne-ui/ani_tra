// lib/screens/lot_finalize_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/lot_provider.dart';
import '../providers/animal_provider.dart';
import '../providers/sync_provider.dart';
import '../models/lot.dart';
import '../models/product.dart';
import '../models/animal.dart';
import '../i18n/app_localizations.dart';
import '../models/veterinarian.dart';
import '../data/mock_data.dart';

class LotFinalizeScreen extends StatefulWidget {
  final String lotId;

  const LotFinalizeScreen({
    super.key,
    required this.lotId,
  });

  @override
  State<LotFinalizeScreen> createState() => _LotFinalizeScreenState();
}

class _LotFinalizeScreenState extends State<LotFinalizeScreen> {
  LotType? _selectedType;
  final _formKey = GlobalKey<FormState>();

  // Traitement
  Product? _selectedProduct;
  DateTime _treatmentDate = DateTime.now();

  // Vétérinaire (v1.2)
  String? _selectedVetId;
  String? _selectedVetName;
  String? _selectedVetOrg;

  // Vente
  final _buyerNameController = TextEditingController();
  final _buyerFarmIdController = TextEditingController();
  final _pricePerAnimalController = TextEditingController();
  DateTime _saleDate = DateTime.now();

  // Abattage
  final _slaughterhouseNameController = TextEditingController();
  final _slaughterhouseIdController = TextEditingController();
  DateTime _slaughterDate = DateTime.now();

  // Notes
  final _notesController = TextEditingController();

  // ==================== Méthodes Vétérinaire ====================

  void _searchVeterinarian() {
    showDialog(
      context: context,
      builder: (context) => _VeterinarianSearchDialog(
        veterinarians: MockData.veterinarians,
        onSelect: (vet) {
          setState(() {
            _selectedVetId = vet.id;
            _selectedVetName = vet.fullName;
            _selectedVetOrg = vet.clinic ?? 'Non spécifié';
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _scanVeterinarianQR() async {
    final vets = MockData.veterinarians;
    if (vets.isEmpty) return;

    final selectedVet = vets.first;

    setState(() {
      _selectedVetId = selectedVet.id;
      _selectedVetName = selectedVet.fullName;
      _selectedVetOrg = selectedVet.clinic ?? 'Non spécifié';
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ ${selectedVet.fullName} validé'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _removeVeterinarian() {
    setState(() {
      _selectedVetId = null;
      _selectedVetName = null;
      _selectedVetOrg = null;
    });
  }

  @override
  void dispose() {
    _buyerNameController.dispose();
    _buyerFarmIdController.dispose();
    _pricePerAnimalController.dispose();
    _slaughterhouseNameController.dispose();
    _slaughterhouseIdController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _finalize() {
    if (_selectedType == null) return;
    if (!_formKey.currentState!.validate()) return;

    final lotProvider = context.read<LotProvider>();
    final animalProvider = context.read<AnimalProvider>();
    final syncProvider = context.read<SyncProvider>();

    final lot = lotProvider.getLotById(widget.lotId);
    if (lot == null) return;

    bool success = false;

    switch (_selectedType!) {
      case LotType.treatment:
        if (_selectedProduct == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Veuillez sélectionner un produit'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final withdrawalEnd = _treatmentDate.add(
          Duration(days: _selectedProduct!.withdrawalDaysMeat),
        );

        success = lotProvider.finalizeLot(
          widget.lotId,
          type: LotType.treatment,
          productId: _selectedProduct!.id,
          productName: _selectedProduct!.name,
          treatmentDate: _treatmentDate,
          withdrawalEndDate: withdrawalEnd,
          veterinarianId: _selectedVetId,
          veterinarianName: _selectedVetName,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
        );

        if (success) {
          // Créer les traitements individuels
          final treatments = lotProvider.expandLotToTreatments(
            lotProvider.getLotById(widget.lotId)!,
          );
          for (final treatment in treatments) {
            animalProvider.addTreatment(treatment);
          }
          syncProvider.addPendingData(treatments.length + 1);
        }
        break;

      case LotType.sale:
        final pricePerAnimal = double.tryParse(_pricePerAnimalController.text);
        if (pricePerAnimal == null || pricePerAnimal <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Prix invalide'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final totalPrice = pricePerAnimal * lot.animalCount;

        success = lotProvider.finalizeLot(
          widget.lotId,
          type: LotType.sale,
          buyerName: _buyerNameController.text,
          buyerFarmId: _buyerFarmIdController.text.isEmpty
              ? null
              : _buyerFarmIdController.text,
          pricePerAnimal: pricePerAnimal,
          totalPrice: totalPrice,
          saleDate: _saleDate,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
        );

        if (success) {
          // Créer les mouvements de vente
          final movements = lotProvider.expandLotToSaleMovements(
            lotProvider.getLotById(widget.lotId)!,
          );
          for (final movement in movements) {
            animalProvider.addMovement(movement);
            // Mettre à jour le statut de l'animal
            animalProvider.updateAnimalStatus(
                movement.animalId, AnimalStatus.sold);
          }
          syncProvider.addPendingData(movements.length + 1);
        }
        break;

      case LotType.slaughter:
        success = lotProvider.finalizeLot(
          widget.lotId,
          type: LotType.slaughter,
          slaughterhouseName: _slaughterhouseNameController.text,
          slaughterhouseId: _slaughterhouseIdController.text.isEmpty
              ? null
              : _slaughterhouseIdController.text,
          slaughterDate: _slaughterDate,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
        );

        if (success) {
          // Créer les mouvements d'abattage
          final movements = lotProvider.expandLotToSlaughterMovements(
            lotProvider.getLotById(widget.lotId)!,
          );
          for (final movement in movements) {
            animalProvider.addMovement(movement);
            // Mettre à jour le statut de l'animal
            animalProvider.updateAnimalStatus(
                movement.animalId, AnimalStatus.slaughtered);
          }
          syncProvider.addPendingData(movements.length + 1);
        }
        break;
    }

    if (success) {
      Navigator.pop(context);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).translate('lot_finalized'),
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lotProvider = context.watch<LotProvider>();
    final animalProvider = context.watch<AnimalProvider>();
    final lot = lotProvider.getLotById(widget.lotId);

    if (lot == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Erreur')),
        body: const Center(child: Text('Lot introuvable')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('finalize_lot')),
      ),
      body: _selectedType == null
          ? _buildTypeSelection(context, lot)
          : _buildForm(context, lot, animalProvider),
    );
  }

  Widget _buildTypeSelection(BuildContext context, Lot lot) {
    final l10n = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          l10n.translate('choose_lot_type'),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          '${lot.animalCount} animaux',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // Traitement
        _buildTypeCard(
          icon: '💊',
          title: l10n.translate('treatment_lot'),
          subtitle: 'Traitement sanitaire groupé',
          color: Colors.blue,
          onTap: () {
            setState(() => _selectedType = LotType.treatment);
          },
        ),
        const SizedBox(height: 16),

        // Vente
        _buildTypeCard(
          icon: '💰',
          title: l10n.translate('sale_lot'),
          subtitle: 'Vente d\'animaux',
          color: Colors.green,
          onTap: () {
            setState(() => _selectedType = LotType.sale);
          },
        ),
        const SizedBox(height: 16),

        // Abattage
        _buildTypeCard(
          icon: '🏭',
          title: l10n.translate('slaughter_lot'),
          subtitle: 'Préparation pour abattoir',
          color: Colors.grey,
          onTap: () {
            setState(() => _selectedType = LotType.slaughter);
          },
        ),
      ],
    );
  }

  Widget _buildTypeCard({
    required String icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 32)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(
      BuildContext context, Lot lot, AnimalProvider animalProvider) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getTypeColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(_selectedType!.icon, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedType!.label,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _getTypeColor(),
                        ),
                      ),
                      Text(
                        '${lot.animalCount} animaux',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() => _selectedType = null);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Formulaire selon type
          if (_selectedType == LotType.treatment)
            _buildTreatmentForm(animalProvider),
          if (_selectedType == LotType.sale) _buildSaleForm(),
          if (_selectedType == LotType.slaughter) _buildSlaughterForm(),

          const SizedBox(height: 24),

          // Notes
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Notes (optionnel)',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 24),

          // Bouton Finaliser
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _finalize,
              icon: const Icon(Icons.check_circle),
              label: const Text('Finaliser le lot'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentForm(AnimalProvider animalProvider) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final products = animalProvider.products;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Produit
        DropdownButtonFormField<Product>(
          value: _selectedProduct,
          decoration: const InputDecoration(
            labelText: 'Produit *',
            border: OutlineInputBorder(),
          ),
          items: products.map((product) {
            return DropdownMenuItem(
              value: product,
              child: Text(product.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedProduct = value);
          },
          validator: (value) =>
              value == null ? 'Veuillez sélectionner un produit' : null,
        ),
        const SizedBox(height: 16),

        // Date traitement
        ListTile(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade400),
          ),
          leading: const Icon(Icons.calendar_today),
          title: const Text('Date du traitement'),
          subtitle: Text(dateFormat.format(_treatmentDate)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _treatmentDate,
              firstDate: DateTime.now().subtract(const Duration(days: 7)),
              lastDate: DateTime.now().add(const Duration(days: 30)),
            );
            if (date != null) {
              setState(() => _treatmentDate = date);
            }
          },
        ),
        const SizedBox(height: 16),

        // ==================== Section Vétérinaire ====================
        Row(
          children: [
            Icon(Icons.medical_services, color: Colors.blue.shade700),
            const SizedBox(width: 8),
            Text(
              'Vétérinaire prescripteur (optionnel)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Si aucun vétérinaire sélectionné
        if (_selectedVetId == null) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.person_search,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 12),
                Text(
                  'Aucun vétérinaire sélectionné',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _searchVeterinarian,
                        icon: const Icon(Icons.search),
                        label: const Text('Rechercher'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _scanVeterinarianQR,
                        icon: const Icon(Icons.qr_code_scanner),
                        label: const Text('Scanner QR'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],

        // Si vétérinaire sélectionné
        if (_selectedVetId != null) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade300, width: 2),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green.shade100,
                  radius: 24,
                  child: Icon(
                    Icons.verified_user,
                    color: Colors.green.shade700,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedVetName ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedVetOrg ?? '',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _removeVeterinarian,
                  icon: const Icon(Icons.close, color: Colors.red),
                  tooltip: 'Retirer',
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),

        // Info rémanence
        if (_selectedProduct != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.orange.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Rémanence: ${_selectedProduct!.withdrawalDaysMeat} jours\n'
                    'Fin: ${dateFormat.format(_treatmentDate.add(Duration(days: _selectedProduct!.withdrawalDaysMeat)))}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.orange.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSaleForm() {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Acheteur
        TextFormField(
          controller: _buyerNameController,
          decoration: const InputDecoration(
            labelText: 'Nom de l\'acheteur *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? 'Champ obligatoire' : null,
        ),
        const SizedBox(height: 16),

        // N° Exploitation
        TextField(
          controller: _buyerFarmIdController,
          decoration: const InputDecoration(
            labelText: 'N° Exploitation (optionnel)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.badge),
          ),
        ),
        const SizedBox(height: 16),

        // Prix par animal
        TextFormField(
          controller: _pricePerAnimalController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Prix par animal (€) *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.euro),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Champ obligatoire';
            final price = double.tryParse(value);
            if (price == null || price <= 0) return 'Prix invalide';
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Date vente
        ListTile(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade400),
          ),
          leading: const Icon(Icons.calendar_today),
          title: const Text('Date de vente'),
          subtitle: Text(dateFormat.format(_saleDate)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _saleDate,
              firstDate: DateTime.now().subtract(const Duration(days: 30)),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              setState(() => _saleDate = date);
            }
          },
        ),
      ],
    );
  }

  Widget _buildSlaughterForm() {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Abattoir
        TextFormField(
          controller: _slaughterhouseNameController,
          decoration: const InputDecoration(
            labelText: 'Nom de l\'abattoir *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.factory),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? 'Champ obligatoire' : null,
        ),
        const SizedBox(height: 16),

        // N° Abattoir
        TextField(
          controller: _slaughterhouseIdController,
          decoration: const InputDecoration(
            labelText: 'N° Abattoir (optionnel)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.badge),
          ),
        ),
        const SizedBox(height: 16),

        // Date abattage
        ListTile(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade400),
          ),
          leading: const Icon(Icons.calendar_today),
          title: const Text('Date d\'abattage'),
          subtitle: Text(dateFormat.format(_slaughterDate)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _slaughterDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 60)),
            );
            if (date != null) {
              setState(() => _slaughterDate = date);
            }
          },
        ),
      ],
    );
  }

  Color _getTypeColor() {
    switch (_selectedType) {
      case LotType.treatment:
        return Colors.blue;
      case LotType.sale:
        return Colors.green;
      case LotType.slaughter:
        return Colors.grey;
      case null:
        return Colors.orange;
    }
  }
}

// ==================== Dialog Recherche Vétérinaire ====================

class _VeterinarianSearchDialog extends StatefulWidget {
  final List<Veterinarian> veterinarians;
  final Function(Veterinarian) onSelect;

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
  List<Veterinarian> _filteredVets = [];

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
                vet.fullName.toLowerCase().contains(query.toLowerCase()) ||
                (vet.clinic?.toLowerCase().contains(query.toLowerCase()) ??
                    false))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rechercher un Vétérinaire'),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      content: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Champ de recherche
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Nom ou établissement...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onChanged: _filterVets,
              autofocus: true,
            ),
            const SizedBox(height: 16),

            // Résultats
            if (_filteredVets.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Aucun vétérinaire trouvé',
                      style: TextStyle(color: Colors.grey),
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
                        vet.fullName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(vet.clinic ?? 'Non spécifié'),
                          const SizedBox(height: 4),
                          Text(
                            vet.licenseNumber,
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
          child: const Text('Annuler'),
        ),
      ],
    );
  }
}
