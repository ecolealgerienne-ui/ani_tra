// lib/screens/lot_finalize_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/lot_provider.dart';
import '../../providers/animal_provider.dart';
import '../../providers/sync_provider.dart';
import '../../models/lot.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../models/product.dart';
import '../../models/animal.dart';
import '../../models/veterinarian.dart';
import '../../data/mock_data.dart';
import '../medical/medical_act_screen.dart';

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
  final DateTime _treatmentDate = DateTime.now();

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
            _selectedVetOrg = vet.clinic ??
                AppLocalizations.of(context).translate(AppStrings.notSpecified);
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
      _selectedVetOrg = selectedVet.clinic ??
          AppLocalizations.of(context).translate(AppStrings.notSpecified);
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)
            .translate(AppStrings.vetValidated)
            .replaceAll('{name}', selectedVet.fullName)),
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

  void _finalize() async {
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
        // Naviguer vers medical_act_screen pour le traitement du lot
        if (!mounted) return;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MedicalActScreen(
              mode: MedicalActMode.batch,
              animalIds: lot.animalIds,
              lotId: widget.lotId,
            ),
          ),
        );

        // Après retour de medical_act_screen, finaliser le lot
        if (!mounted) return;
        success = lotProvider.finalizeLot(
          widget.lotId,
          type: LotType.treatment,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
        );

        if (success) {
          syncProvider.incrementPendingData();
        }
        break;

      case LotType.sale:
        final pricePerAnimal = double.tryParse(_pricePerAnimalController.text);
        if (pricePerAnimal == null || pricePerAnimal <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)
                  .translate(AppStrings.invalidPrice)),
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
            AppLocalizations.of(context).translate(AppStrings.lotFinalized),
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lotProvider = context.watch<LotProvider>();
    final animalProvider = context.watch<AnimalProvider>();
    final lot = lotProvider.getLotById(widget.lotId);

    if (lot == null) {
      return Scaffold(
        appBar: AppBar(
            title:
                Text(AppLocalizations.of(context).translate(AppStrings.error))),
        body: Center(
            child: Text(AppLocalizations.of(context)
                .translate(AppStrings.lotNotFound))),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context).translate(AppStrings.finalizeLot)),
      ),
      body: _selectedType == null
          ? _buildTypeSelection(context, lot)
          : _buildForm(context, lot, animalProvider),
    );
  }

  Widget _buildTypeSelection(BuildContext context, Lot lot) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          AppLocalizations.of(context).translate(AppStrings.chooseLotType),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          '${lot.animalCount} ${AppLocalizations.of(context).translate('animals')}',
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
          title:
              AppLocalizations.of(context).translate(AppStrings.treatmentLot),
          subtitle: 'Traitement sanitaire groupé',
          color: Colors.blue,
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MedicalActScreen(
                  mode: MedicalActMode.batch,
                  batchId: lot.id,
                  animalIds: lot.animalIds,
                  lotId: widget.lotId,
                ),
              ),
            );

            // Après retour de medical_act_screen, finaliser le lot
            if (!mounted) return;
            final lotProvider = context.read<LotProvider>();
            final syncProvider = context.read<SyncProvider>();

            final success = lotProvider.finalizeLot(
              widget.lotId,
              type: LotType.treatment,
              notes:
                  _notesController.text.isEmpty ? null : _notesController.text,
            );

            if (success) {
              syncProvider.incrementPendingData();
              if (mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)
                          .translate(AppStrings.lotFinalized),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            }
          },
        ),
        const SizedBox(height: 16),

        // Vente
        _buildTypeCard(
          icon: '💰',
          title: AppLocalizations.of(context).translate(AppStrings.saleLot),
          subtitle:
              AppLocalizations.of(context).translate(AppStrings.saleAnimals),
          color: Colors.green,
          onTap: () {
            setState(() => _selectedType = LotType.sale);
          },
        ),
        const SizedBox(height: 16),

        // Abattage
        _buildTypeCard(
          icon: '🏭',
          title:
              AppLocalizations.of(context).translate(AppStrings.slaughterLot),
          subtitle: AppLocalizations.of(context)
              .translate(AppStrings.slaughterPreparation),
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
                  color: color.withValues(alpha: 0.1),
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
              color: _getTypeColor().withValues(alpha: 0.1),
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
                        '${lot.animalCount} ${AppLocalizations.of(context).translate(AppStrings.animals)}',
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
            _buildTreatmentButton(context),
          if (_selectedType == LotType.sale) _buildSaleForm(),
          if (_selectedType == LotType.slaughter) _buildSlaughterForm(),

          const SizedBox(height: 24),

          // Notes
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)
                  .translate(AppStrings.notesOptional),
              border: const OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 24),

          // Bouton Finaliser
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _finalize,
              icon: const Icon(Icons.check_circle),
              label: Text(AppLocalizations.of(context)
                  .translate(AppStrings.finalizeLot)),
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

  /// Bouton pour naviguer vers l'écran de traitement unifié
  Widget _buildTreatmentButton(BuildContext context) {
    final lotProvider = context.read<LotProvider>();
    final lot = lotProvider.getLotById(widget.lotId);
    if (lot == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
                  AppLocalizations.of(context)
                      .translate(AppStrings.treatmentWillApplyToAnimals),
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MedicalActScreen(
                  mode: MedicalActMode.batch,
                  batchId: lot.id,
                  animalIds: lot.animalIds,
                ),
              ),
            );
          },
          icon: const Icon(Icons.medical_services, size: 24),
          label: const Text(
            'Traiter le lot',
            style: TextStyle(fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
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
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate('buyerName'),
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.person),
          ),
          validator: (value) => value == null || value.isEmpty
              ? AppLocalizations.of(context).translate('buyerNameRequired')
              : null,
        ),
        const SizedBox(height: 16),

        // N° Exploitation
        TextField(
          controller: _buyerFarmIdController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate('buyerFarmId'),
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.badge),
          ),
        ),
        const SizedBox(height: 16),

        // Prix par animal
        TextFormField(
          controller: _pricePerAnimalController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate('pricePerAnimal'),
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.euro),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context).translate('requiredField');
            }
            final price = double.tryParse(value);
            if (price == null || price <= 0) {
              return AppLocalizations.of(context).translate('invalidPrice');
            }
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
          title: Text(AppLocalizations.of(context).translate('saleDate')),
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
          decoration: InputDecoration(
            labelText:
                AppLocalizations.of(context).translate('slaughterhouseName'),
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.factory),
          ),
          validator: (value) => value == null || value.isEmpty
              ? AppLocalizations.of(context).translate('requiredField')
              : null,
        ),
        const SizedBox(height: 16),

        // N° Abattoir
        TextField(
          controller: _slaughterhouseIdController,
          decoration: InputDecoration(
            labelText:
                AppLocalizations.of(context).translate('slaughterhouseId'),
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.badge),
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
          title: Text(AppLocalizations.of(context).translate('dateSlaughter')),
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
      title: Text(AppLocalizations.of(context).translate('searchVeterinarian')),
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
                hintText: AppLocalizations.of(context)
                    .translate('nameOrEstablishment'),
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
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    const Icon(Icons.search_off, size: 48, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)
                          .translate('noVeterinarianFound'),
                      style: const TextStyle(color: Colors.grey),
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
                          Text(vet.clinic ??
                              AppLocalizations.of(context)
                                  .translate('notSpecified')),
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
          child: Text(AppLocalizations.of(context).translate('cancel')),
        ),
      ],
    );
  }
}
