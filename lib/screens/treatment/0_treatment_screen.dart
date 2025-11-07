// lib/screens/treatment_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../models/product.dart';
import '../../models/treatment.dart';
import '../../models/veterinarian.dart';
import '../../providers/animal_provider.dart';
import '../../providers/sync_provider.dart';
import '../../data/mock_data.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';

class TreatmentScreen extends StatefulWidget {
  final String? animalId;
  final List<String>? animalIds;
  final String? batchId;
  final String? batchName;

  const TreatmentScreen({
    super.key,
    this.animalId,
    this.animalIds,
    this.batchId,
    this.batchName,
  }) : assert(
          animalId != null || animalIds != null,
          'animalId ou animalIds doit être fourni',
        );

  @override
  State<TreatmentScreen> createState() => _TreatmentScreenState();
}

class _TreatmentScreenState extends State<TreatmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _doseController = TextEditingController();
  final _notesController = TextEditingController();
  final _uuid = const Uuid();

  Product? _selectedProduct;
  DateTime _treatmentDate = DateTime.now();

  String? _selectedVetId;
  String? _selectedVetName;
  String? _selectedVetOrg;

  bool _isSaving = false;

  @override
  void dispose() {
    _doseController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  List<String> get _targetAnimalIds {
    if (widget.animalIds != null) {
      return widget.animalIds!;
    }
    return [widget.animalId!];
  }

  int get _animalCount => _targetAnimalIds.length;

  String get _title {
    if (widget.batchName != null) {
      return 'Traitement - ${widget.batchName}';
    }
    if (_animalCount == 1) {
      return 'Ajouter un soin';
    }
    return 'Traitement pour $_animalCount animaux';
  }

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

  Future<void> _saveTreatment() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context).translate(AppStrings.selectProduct)),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final animalProvider = context.read<AnimalProvider>();
    final syncProvider = context.read<SyncProvider>();

    final dose = double.parse(_doseController.text);
    final notes = _notesController.text.trim();

    for (final animalId in _targetAnimalIds) {
      final treatment = Treatment(
        id: _uuid.v4(),
        animalId: animalId,
        productId: _selectedProduct!.id,
        productName: _selectedProduct!.name,
        dose: dose,
        treatmentDate: _treatmentDate,
        withdrawalEndDate: _treatmentDate.add(
          Duration(days: _selectedProduct!.withdrawalDaysMeat),
        ),
        notes: notes.isEmpty ? null : notes,
        veterinarianId: _selectedVetId,
        veterinarianName: _selectedVetName,
        synced: false,
        createdAt: DateTime.now(),
      );

      animalProvider.addTreatment(treatment);
      syncProvider.incrementPendingData();
    }

    if (!mounted) return;

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _animalCount == 1
              ? '✅ Soin ajouté'
              : '✅ $_animalCount ${AppLocalizations.of(context).translate(AppStrings.added)}',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final animalProvider = context.watch<AnimalProvider>();
    final products = animalProvider.products;
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: [
          if (!_isSaving)
            TextButton.icon(
              onPressed: _saveTreatment,
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text(
                'Enregistrer',
                style: TextStyle(color: Colors.white),
              ),
            ),
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildContextBanner(context),
              const SizedBox(height: 24),
              _buildProductField(context, products),
              const SizedBox(height: 16),
              _buildDoseField(context),
              const SizedBox(height: 16),
              _buildDateField(context, dateFormat),
              const SizedBox(height: 24),
              _buildVeterinarianSection(context),
              const SizedBox(height: 24),
              _buildNotesField(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContextBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(
            _animalCount == 1 ? Icons.pets : Icons.groups,
            color: Colors.blue.shade700,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _animalCount == 1
                      ? 'Traitement individuel'
                      : 'Traitement groupé',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _animalCount == 1
                      ? '1 animal concerné'
                      : '$_animalCount animaux concernés',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductField(BuildContext context, List<Product> products) {
    return DropdownButtonFormField<Product>(
      initialValue: _selectedProduct,
      decoration: InputDecoration(
        labelText: 'Produit médical *',
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.medication),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      items: products.map((product) {
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
                'Délai: ${product.withdrawalDaysMeat}j viande',
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
        setState(() => _selectedProduct = value);
      },
      validator: (value) => value == null
          ? AppLocalizations.of(context).translate(AppStrings.selectProduct)
          : null,
    );
  }

  Widget _buildDoseField(BuildContext context) {
    return TextFormField(
      controller: _doseController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText:
            '${AppLocalizations.of(context).translate(AppStrings.dose)} *',
        hintText: 'Ex: 2.5',
        suffixText: 'ml',
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.science),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer une dose';
        }
        if (double.tryParse(value) == null) {
          return 'Dose invalide';
        }
        return null;
      },
    );
  }

  Widget _buildDateField(BuildContext context, DateFormat dateFormat) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _treatmentDate,
          firstDate: DateTime.now().subtract(const Duration(days: 30)),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          setState(() => _treatmentDate = date);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date du traitement',
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.calendar_today),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateFormat.format(_treatmentDate),
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _buildVeterinarianSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.medical_services, color: Colors.blue.shade700),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context).translate(AppStrings.veterinarian),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                AppLocalizations.of(context).translate(AppStrings.optional),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
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
                  AppLocalizations.of(context)
                      .translate(AppStrings.noVeterinarianSelected),
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
                        label: Text(AppLocalizations.of(context)
                            .translate(AppStrings.search)),
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
                        label: Text(AppLocalizations.of(context)
                            .translate(AppStrings.scanQr)),
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
      ],
    );
  }

  Widget _buildNotesField(BuildContext context) {
    return TextFormField(
      controller: _notesController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText:
            '${AppLocalizations.of(context).translate(AppStrings.notes)} (${AppLocalizations.of(context).translate(AppStrings.optional)})',
        hintText: 'Observations, symptômes, posologie...',
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
        prefixIcon: const Padding(
          padding: EdgeInsets.only(bottom: 60),
          child: Icon(Icons.notes),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}

class _VeterinarianSearchDialog extends StatefulWidget {
  final List<Veterinarian> veterinarians;
  final Function(Veterinarian) onSelect;

  const _VeterinarianSearchDialog({
    required this.veterinarians,
    required this.onSelect,
  });

  @override
  State<_VeterinarianSearchDialog> createState() =>
      _VeterinarianSearchDialogState();
}

class _VeterinarianSearchDialogState extends State<_VeterinarianSearchDialog> {
  final _searchController = TextEditingController();
  List<Veterinarian> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = widget.veterinarians;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterVets(String query) {
    setState(() {
      if (query.isEmpty) {
        _filtered = widget.veterinarians;
      } else {
        _filtered = widget.veterinarians
            .where((v) =>
                v.fullName.toLowerCase().contains(query.toLowerCase()) ||
                (v.clinic?.toLowerCase().contains(query.toLowerCase()) ??
                    false))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)
          .translate(AppStrings.searchVeterinarian)),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context).translate(AppStrings.search),
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: _filterVets,
            ),
            const SizedBox(height: 16),
            Flexible(
              child: _filtered.isEmpty
                  ? Center(
                      child: Text(AppLocalizations.of(context)
                          .translate(AppStrings.noVeterinarianFound)))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final vet = _filtered[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(vet.fullName[0]),
                          ),
                          title: Text(vet.fullName),
                          subtitle: Text(vet.clinic ?? 'Non spécifié'),
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
          child:
              Text(AppLocalizations.of(context).translate(AppStrings.cancel)),
        ),
      ],
    );
  }
}
