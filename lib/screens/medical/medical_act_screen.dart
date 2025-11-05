// lib/screens/medical/medical_act_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/medical_product.dart';
import '../../models/animal.dart';
import 'package:uuid/uuid.dart';
import '../../models/treatment.dart';
import '../../models/vaccination.dart';
import '../../providers/animal_provider.dart';
import '../../providers/weight_provider.dart';
import '../../providers/reminder_provider.dart';
import '../../providers/vaccination_provider.dart';
import '../../data/mocks/mock_medical_products.dart';

/// Mode de l'acte médical
enum MedicalActMode {
  singleAnimal, // Animal individuel
  batch // Lot d'animaux
}

/// Écran unifié pour traiter un animal (traitement ou vaccination)
class MedicalActScreen extends StatefulWidget {
  final MedicalActMode mode;
  final String? animalId;
  final String? batchId;
  final List<String>? animalIds;

  const MedicalActScreen({
    super.key,
    required this.mode,
    this.animalId,
    this.batchId,
    this.animalIds,
  });

  @override
  State<MedicalActScreen> createState() => _MedicalActScreenState();
}

class _MedicalActScreenState extends State<MedicalActScreen> {
  // État du formulaire
  ProductType _selectedType = ProductType.treatment;
  MedicalProduct? _selectedProduct;
  double? _calculatedDosage;
  final TextEditingController _dosageController = TextEditingController();
  String? _selectedRoute;
  String? _selectedSite;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _notesController = TextEditingController();
  bool _enableReminders = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);

  // Données chargées
  Animal? _animal;
  double? _animalWeight; // Poids de l'animal (depuis WeightProvider)
  List<Animal>? _batchAnimals;
  double? _averageWeight;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _dosageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  /// Charger les données de l'animal ou du lot
  Future<void> _loadData() async {
    final animalProvider = context.read<AnimalProvider>();
    final weightProvider = context.read<WeightProvider>();

    if (widget.mode == MedicalActMode.singleAnimal && widget.animalId != null) {
      _animal = animalProvider.getAnimalById(widget.animalId!);

      // Charger le dernier poids si disponible
      if (_animal != null) {
        final weights = weightProvider.weights
            .where((w) => w.animalId == _animal!.id)
            .toList();
        if (weights.isNotEmpty) {
          weights.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
          _animalWeight = weights.first.weight;
        }
      }
    } else if (widget.mode == MedicalActMode.batch && widget.animalIds != null) {
      _batchAnimals = widget.animalIds!
          .map((id) => animalProvider.getAnimalById(id))
          .whereType<Animal>()
          .toList();

      // Calculer le poids moyen des animaux du lot
      if (_batchAnimals!.isNotEmpty) {
        double totalWeight = 0;
        int countWithWeight = 0;

        for (final animal in _batchAnimals!) {
          final weights = weightProvider.weights
              .where((w) => w.animalId == animal.id)
              .toList();
          if (weights.isNotEmpty) {
            weights.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
            totalWeight += weights.first.weight;
            countWithWeight++;
          }
        }

        if (countWithWeight > 0) {
          _averageWeight = totalWeight / countWithWeight;
        }
      }
    }

    setState(() {});
  }

  /// Obtenir les produits filtrés
  List<MedicalProduct> _getFilteredProducts() {
    final allProducts = MockMedicalProducts.generateProducts();

    // Filtrer par type
    var filtered = allProducts.where((p) => p.type == _selectedType).toList();

    // Filtrer par espèce si animal unitaire
    if (widget.mode == MedicalActMode.singleAnimal && _animal != null && _animal!.speciesId != null) {
      final animalSpecies = _getAnimalSpecies(_animal!.speciesId!);
      if (animalSpecies != null) {
        filtered = filtered
            .where((p) => p.targetSpecies.contains(animalSpecies))
            .toList();
      }
    }

    return filtered;
  }

  /// Convertir l'espèce de l'animal en AnimalSpecies
  AnimalSpecies? _getAnimalSpecies(String speciesId) {
    // speciesId peut être 'sheep', 'cattle', 'goat', etc.
    switch (speciesId.toLowerCase()) {
      case 'sheep':
      case 'ovin':
      case 'mouton':
      case 'brebis':
      case 'agneau':
        return AnimalSpecies.ovin;
      case 'cattle':
      case 'bovin':
      case 'vache':
      case 'taureau':
      case 'veau':
        return AnimalSpecies.bovin;
      case 'goat':
      case 'caprin':
      case 'chèvre':
      case 'chevreau':
        return AnimalSpecies.caprin;
      default:
        return null;
    }
  }

  /// Gérer la sélection d'un produit
  void _onProductSelected(MedicalProduct product) {
    setState(() {
      _selectedProduct = product;
      _selectedRoute = product.defaultAdministrationRoute;
      _selectedSite = product.defaultInjectionSite;

      // Calculer le dosage si animal unitaire avec poids disponible
      if (widget.mode == MedicalActMode.singleAnimal &&
          _animal != null &&
          _animalWeight != null) {
        _calculatedDosage = product.calculateDosage(_animalWeight!);
        // Pré-remplir UNIQUEMENT pour les vaccins
        if (_calculatedDosage != null && product.type == ProductType.vaccine) {
          _dosageController.text = _calculatedDosage!.toStringAsFixed(1);
        }
      }
    });
  }

  /// Sauvegarder l'acte médical
  Future<void> _saveAct() async {
    if (_selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner un produit'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Valider le dosage uniquement pour les animaux individuels
    double dose;
    if (widget.mode == MedicalActMode.singleAnimal) {
      final parsedDose = double.tryParse(_dosageController.text);
      if (parsedDose == null || parsedDose <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez saisir un dosage valide'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      dose = parsedDose;
    } else {
      // Pour les lots, le dosage n'est pas obligatoire, utiliser 0.0 par défaut
      dose = double.tryParse(_dosageController.text) ?? 0.0;
    }

    final uuid = const Uuid();
    final animalProvider = context.read<AnimalProvider>();

    // Sauvegarder selon le type d'acte
    if (_selectedType == ProductType.treatment) {
      // Créer un traitement pour chaque animal concerné
      final targetIds = widget.mode == MedicalActMode.singleAnimal && _animal != null
          ? [_animal!.id]
          : _batchAnimals?.map((a) => a.id).toList() ?? [];

      for (final animalId in targetIds) {
        final treatmentId = uuid.v4();
        final withdrawalEndDate = _selectedDate.add(
          Duration(days: _selectedProduct!.withdrawalPeriodMeat),
        );

        final treatment = Treatment(
          id: treatmentId,
          animalId: animalId,
          productId: _selectedProduct!.id,
          productName: _selectedProduct!.displayName,
          dose: dose,
          treatmentDate: _selectedDate,
          withdrawalEndDate: withdrawalEndDate,
          notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        );

        animalProvider.addTreatment(treatment);

        // Créer des rappels si activés (uniquement pour le premier animal)
        if (_enableReminders &&
            targetIds.first == animalId &&
            _selectedProduct!.standardCureDays != null &&
            _selectedProduct!.standardCureDays! > 1) {
          final reminderProvider = context.read<ReminderProvider>();
          await reminderProvider.createTreatmentReminders(
            treatmentId: treatmentId,
            animalId: animalId,
            productName: _selectedProduct!.displayName,
            startDate: _selectedDate,
            cureDays: _selectedProduct!.standardCureDays!,
            reminderTime: _reminderTime,
          );
        }
      }
    } else {
      // Vaccination
      final vaccinationProvider = context.read<VaccinationProvider>();
      final vaccinationId = uuid.v4();

      final vaccination = Vaccination(
        id: vaccinationId,
        animalId: widget.mode == MedicalActMode.singleAnimal ? _animal?.id : null,
        animalIds: widget.mode == MedicalActMode.batch
            ? _batchAnimals?.map((a) => a.id).toList() ?? []
            : [],
        vaccineName: _selectedProduct!.displayName,
        type: VaccinationType.recommandee,
        disease: _selectedProduct!.category,
        vaccinationDate: _selectedDate,
        batchNumber: _selectedProduct!.batchNumber,
        expiryDate: _selectedProduct!.expiryDate,
        dose: '${dose.toStringAsFixed(1)} ${_selectedProduct!.stockUnit}',
        administrationRoute: _selectedRoute ?? _selectedProduct!.defaultAdministrationRoute ?? 'IM',
        withdrawalPeriodDays: _selectedProduct!.withdrawalPeriodMeat,
        nextDueDate: _selectedProduct!.reminderDays != null && _selectedProduct!.reminderDays!.isNotEmpty
            ? _selectedDate.add(Duration(days: _selectedProduct!.reminderDays!.first))
            : null,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      vaccinationProvider.addVaccination(vaccination);

      // Créer des rappels si activés
      if (_enableReminders &&
          _selectedProduct!.reminderDays != null &&
          _selectedProduct!.reminderDays!.isNotEmpty &&
          widget.mode == MedicalActMode.singleAnimal &&
          _animal != null) {
        final reminderProvider = context.read<ReminderProvider>();
        await reminderProvider.createVaccinationReminders(
          vaccinationId: vaccinationId,
          animalId: _animal!.id,
          productName: _selectedProduct!.displayName,
          administrationDate: _selectedDate,
          reminderDays: _selectedProduct!.reminderDays!,
          reminderTime: _reminderTime,
        );
      }
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _selectedType == ProductType.treatment
                ? 'Traitement enregistré avec succès'
                : 'Vaccination enregistrée avec succès',
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mode == MedicalActMode.singleAnimal
              ? 'Traiter ${_animal?.currentEid ?? _animal?.officialNumber ?? "animal"}'
              : 'Traiter le lot',
        ),
      ),
      body: _animal == null && widget.mode == MedicalActMode.singleAnimal
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sélection du type d'acte
                  _buildTypeSelector(theme),
                  const SizedBox(height: 24),

                  // Informations animal/lot
                  _buildAnimalInfo(theme),
                  const SizedBox(height: 24),

                  // Sélection du produit
                  _buildProductSelector(theme),
                  const SizedBox(height: 24),

                  // Informations produit sélectionné
                  if (_selectedProduct != null) ...[
                    _buildProductInfo(theme),
                    const SizedBox(height: 24),
                  ],

                  // Dosage
                  if (_selectedProduct != null) ...[
                    _buildDosageSection(theme),
                    const SizedBox(height: 24),
                  ],

                  // Voie et site d'administration
                  if (_selectedProduct != null) ...[
                    _buildAdministrationSection(theme),
                    const SizedBox(height: 24),
                  ],

                  // Date
                  _buildDateSection(theme),
                  const SizedBox(height: 24),

                  // Rappels (toujours afficher si produit sélectionné)
                  if (_selectedProduct != null) ...[
                    _buildRemindersSection(theme),
                    const SizedBox(height: 24),
                  ],

                  // Délais d'attente
                  if (_selectedProduct != null) ...[
                    _buildWithdrawalPeriods(theme),
                    const SizedBox(height: 24),
                  ],

                  // Notes
                  _buildNotesSection(theme),
                  const SizedBox(height: 32),

                  // Boutons d'action
                  _buildActionButtons(theme),
                ],
              ),
            ),
    );
  }

  /// Construire le sélecteur de type
  Widget _buildTypeSelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type d\'acte',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SegmentedButton<ProductType>(
          segments: const [
            ButtonSegment(
              value: ProductType.treatment,
              label: Text('Traitement'),
              icon: Icon(Icons.medication),
            ),
            ButtonSegment(
              value: ProductType.vaccine,
              label: Text('Vaccination'),
              icon: Icon(Icons.vaccines),
            ),
          ],
          selected: {_selectedType},
          onSelectionChanged: (Set<ProductType> newSelection) {
            setState(() {
              _selectedType = newSelection.first;
              _selectedProduct = null;
              _dosageController.clear();
            });
          },
        ),
      ],
    );
  }

  /// Construire les informations animal/lot
  Widget _buildAnimalInfo(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.mode == MedicalActMode.singleAnimal && _animal != null) ...[
              Row(
                children: [
                  const Icon(Icons.pets, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Animal: ${_animal!.currentEid ?? _animal!.officialNumber ?? "Sans ID"}',
                    style: theme.textTheme.titleSmall,
                  ),
                ],
              ),
              if (_animalWeight != null) ...[
                const SizedBox(height: 8),
                Text('Poids: ${_animalWeight!.toStringAsFixed(1)} kg'),
              ],
              if (_animal!.speciesId != null) ...[
                const SizedBox(height: 8),
                Text('Espèce: ${_animal!.speciesId}'),
              ],
            ] else if (widget.mode == MedicalActMode.batch &&
                _batchAnimals != null) ...[
              Row(
                children: [
                  const Icon(Icons.group, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Lot: ${_batchAnimals!.length} animaux',
                    style: theme.textTheme.titleSmall,
                  ),
                ],
              ),
              if (_averageWeight != null) ...[
                const SizedBox(height: 8),
                Text('Poids moyen: ${_averageWeight!.toStringAsFixed(1)} kg'),
              ],
            ],
          ],
        ),
      ),
    );
  }

  /// Construire le sélecteur de produit
  Widget _buildProductSelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Produit',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<MedicalProduct>(
          initialValue: _selectedProduct,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Sélectionner un produit',
          ),
          items: _getFilteredProducts().map((product) {
            return DropdownMenuItem(
              value: product,
              child: Text(product.displayName),
            );
          }).toList(),
          onChanged: (product) {
            if (product != null) {
              _onProductSelected(product);
            }
          },
        ),
      ],
    );
  }

  /// Construire les informations du produit
  Widget _buildProductInfo(ThemeData theme) {
    if (_selectedProduct == null) return const SizedBox.shrink();

    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_selectedType == ProductType.treatment) ...[
              if (_selectedProduct!.standardCureDays != null)
                Text('ℹ️ Cure standard: ${_selectedProduct!.standardCureDays} jours'),
              if (_selectedProduct!.administrationFrequency != null) ...[
                const SizedBox(height: 4),
                Text('ℹ️ Administration: ${_selectedProduct!.administrationFrequency}'),
              ],
            ] else if (_selectedType == ProductType.vaccine) ...[
              Text('ℹ️ Protocole: ${_selectedProduct!.vaccinationProtocol ?? "Unique"}'),
              const SizedBox(height: 4),
              Text(_selectedProduct!.getProtocolDescription()),
            ],
          ],
        ),
      ),
    );
  }

  /// Construire la section dosage
  Widget _buildDosageSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dosage',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (widget.mode == MedicalActMode.singleAnimal) ...[
          TextFormField(
            controller: _dosageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              suffixText: _selectedProduct?.stockUnit ?? 'ml',
              helperText: _selectedProduct?.dosageFormula != null
                  ? _calculatedDosage != null
                      ? 'Calculé selon ${_selectedProduct!.dosageFormula} (${_animalWeight?.toStringAsFixed(1) ?? "?"} kg)'
                      : 'Formule: ${_selectedProduct!.dosageFormula} ${_animalWeight == null ? "(Poids non disponible)" : ""}'
                  : 'Saisir le dosage',
            ),
          ),
          if (_calculatedDosage == null && _selectedProduct?.dosageFormula != null && _animalWeight == null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 20, color: Colors.orange.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ajoutez un poids pour calculer automatiquement le dosage',
                      style: TextStyle(fontSize: 12, color: Colors.orange.shade900),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ] else if (widget.mode == MedicalActMode.batch) ...[
          Card(
            color: Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedProduct!.dosageFormula != null)
                    Text('ℹ️ Dosage produit: ${_selectedProduct!.dosageFormula}'),
                  const SizedBox(height: 8),
                  const Text('💡 Calcul indicatif:'),
                  if (_averageWeight != null && _selectedProduct!.dosageFormula != null) ...[
                    const SizedBox(height: 4),
                    Text('   • ${(_averageWeight! * 0.8).toStringAsFixed(0)}kg → ${_selectedProduct!.calculateDosage(_averageWeight! * 0.8)?.toStringAsFixed(1)} ml'),
                    Text('   • ${_averageWeight!.toStringAsFixed(0)}kg → ${_selectedProduct!.calculateDosage(_averageWeight!)?.toStringAsFixed(1)} ml'),
                  ],
                  const SizedBox(height: 8),
                  const Text(
                    '⚠️ Doser individuellement selon poids',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Construire la section administration
  Widget _buildAdministrationSection(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Voie',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedRoute,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: ['IM', 'SC', 'IV', 'ID', 'Orale', 'Topique']
                    .map((route) => DropdownMenuItem(
                          value: route,
                          child: Text(route),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedRoute = value);
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Site',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedSite,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: ['Encolure', 'Cuisse', 'Flanc', 'Arrière-cuisse']
                    .map((site) => DropdownMenuItem(
                          value: site,
                          child: Text(site),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedSite = value);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Construire la section date
  Widget _buildDateSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              setState(() => _selectedDate = date);
            }
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            child: Text(
              '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
            ),
          ),
        ),
      ],
    );
  }

  /// Construire la section rappels
  Widget _buildRemindersSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications_active, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Rappels',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('M\'envoyer des rappels'),
              subtitle: Text(_getReminderDescription()),
              value: _enableReminders,
              onChanged: (value) {
                setState(() => _enableReminders = value);
              },
            ),
            if (_enableReminders) ...[
              const SizedBox(height: 12),
              ListTile(
                title: const Text('Heure des rappels'),
                trailing: TextButton.icon(
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: _reminderTime,
                    );
                    if (time != null) {
                      setState(() => _reminderTime = time);
                    }
                  },
                  icon: const Icon(Icons.access_time),
                  label: Text(
                    '${_reminderTime.hour.toString().padLeft(2, '0')}:${_reminderTime.minute.toString().padLeft(2, '0')}',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Obtenir la description des rappels
  String _getReminderDescription() {
    if (_selectedProduct == null) return 'Configurez vos rappels';

    if (_selectedType == ProductType.treatment) {
      if (_selectedProduct!.standardCureDays != null && _selectedProduct!.standardCureDays! > 1) {
        final days = _selectedProduct!.standardCureDays! - 1;
        return 'J2 à J${_selectedProduct!.standardCureDays} ($days rappels)';
      } else {
        return 'Configurez des rappels personnalisés';
      }
    } else {
      if (_selectedProduct!.reminderDays != null && _selectedProduct!.reminderDays!.isNotEmpty) {
        final days = _selectedProduct!.reminderDays!;
        return '${days.length} rappel(s): ${days.map((d) => "J$d").join(", ")}';
      } else {
        return 'Configurez des rappels de vaccination';
      }
    }
  }

  /// Construire les délais d'attente
  Widget _buildWithdrawalPeriods(ThemeData theme) {
    if (_selectedProduct == null) return const SizedBox.shrink();

    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Délais d\'attente',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Viande: ${_selectedProduct!.withdrawalPeriodMeat} jours'),
            Text('Lait: ${_selectedProduct!.withdrawalPeriodMilk > 0 ? "${_selectedProduct!.withdrawalPeriodMilk} heures" : "0"}'),
          ],
        ),
      ),
    );
  }

  /// Construire la section notes
  Widget _buildNotesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Notes supplémentaires (optionnel)',
          ),
        ),
      ],
    );
  }

  /// Construire les boutons d'action
  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FilledButton(
            onPressed: _saveAct,
            child: const Text('Enregistrer'),
          ),
        ),
      ],
    );
  }
}
