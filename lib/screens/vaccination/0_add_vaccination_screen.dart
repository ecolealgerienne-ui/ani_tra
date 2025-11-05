// lib/screens/vaccination/add_vaccination_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/vaccination_provider.dart';
import '../../providers/animal_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/vaccination_reference_provider.dart';
import '../../models/vaccination.dart';
import '../../models/vaccination_protocol.dart';
import '../../models/vaccine_reference.dart';
import '../../models/disease_reference.dart';
import '../../models/administration_route.dart';
import '../../models/animal.dart';
import '../animal/animal_finder_screen.dart';

class AddVaccinationScreen extends StatefulWidget {
  final String? preselectedAnimalId;

  const AddVaccinationScreen({
    super.key,
    this.preselectedAnimalId,
  });

  @override
  State<AddVaccinationScreen> createState() => _AddVaccinationScreenState();
}

class _AddVaccinationScreenState extends State<AddVaccinationScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isGroupVaccination = false;
  String? _selectedAnimalId;
  List<String> _selectedAnimalIds = [];
  VaccinationProtocol? _selectedProtocol;
  VaccinationType _type = VaccinationType.recommandee;

  VaccineReference? _selectedVaccine;
  DiseaseReference? _selectedDisease;
  AdministrationRoute? _selectedRoute;

  final _vaccineNameCustomController = TextEditingController();
  final _diseaseCustomController = TextEditingController();
  final _administrationRouteCustomController = TextEditingController();
  final _doseController = TextEditingController();
  final _batchNumberController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _vaccinationDate = DateTime.now();
  DateTime? _nextDueDate;
  DateTime? _expiryDate;
  int _withdrawalPeriodDays = 0;
  String? _veterinarianId;
  String? _veterinarianName;

  @override
  void initState() {
    super.initState();
    if (widget.preselectedAnimalId != null) {
      _selectedAnimalId = widget.preselectedAnimalId;
    }
  }

  @override
  void dispose() {
    _vaccineNameCustomController.dispose();
    _diseaseCustomController.dispose();
    _administrationRouteCustomController.dispose();
    _doseController.dispose();
    _batchNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _applyProtocol(VaccinationProtocol protocol) {
    final refProvider = context.read<VaccinationReferenceProvider>();

    setState(() {
      _selectedProtocol = protocol;

      // Chercher le vaccin dans les références
      _selectedVaccine =
          refProvider.getVaccineByName(protocol.recommendedVaccine);
      if (_selectedVaccine == null) {
        // Si pas trouvé, utiliser "Autre"
        _selectedVaccine = refProvider.getVaccineByName('Autre');
        _vaccineNameCustomController.text = protocol.recommendedVaccine;
      } else {
        _vaccineNameCustomController.clear();
      }

      // Chercher la maladie dans les références
      _selectedDisease = refProvider.getDiseaseByName(protocol.disease);
      if (_selectedDisease == null) {
        _selectedDisease = refProvider.getDiseaseByName('Autre');
        _diseaseCustomController.text = protocol.disease;
      } else {
        _diseaseCustomController.clear();
      }

      _doseController.text = protocol.standardDose;

      // Chercher la voie dans les références
      _selectedRoute = refProvider.getRouteByCode(protocol.administrationRoute);
      if (_selectedRoute == null) {
        _selectedRoute = refProvider.getRouteByCode('Autre');
        _administrationRouteCustomController.text =
            protocol.administrationRoute;
      } else {
        _administrationRouteCustomController.clear();
      }

      _type = protocol.type;
      _withdrawalPeriodDays = protocol.withdrawalPeriodDays;
      _nextDueDate = protocol.calculateNextDueDate(_vaccinationDate);
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (!_isGroupVaccination && _selectedAnimalId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner un animal'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_isGroupVaccination && _selectedAnimalIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner au moins un animal'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final String vaccineName = _selectedVaccine?.name == 'Autre'
        ? _vaccineNameCustomController.text
        : _selectedVaccine?.name ?? '';

    final String disease = _selectedDisease?.name == 'Autre'
        ? _diseaseCustomController.text
        : _selectedDisease?.name ?? '';

    final String administrationRoute = _selectedRoute?.code == 'Autre'
        ? _administrationRouteCustomController.text
        : _selectedRoute?.code ?? '';

    final vaccination = Vaccination(
      farmId: authProvider.currentFarmId,
      animalId: _isGroupVaccination ? null : _selectedAnimalId,
      animalIds: _isGroupVaccination ? _selectedAnimalIds : [],
      protocolId: _selectedProtocol?.id,
      vaccineName: vaccineName,
      type: _type,
      disease: disease,
      vaccinationDate: _vaccinationDate,
      batchNumber: _batchNumberController.text.isEmpty
          ? null
          : _batchNumberController.text,
      expiryDate: _expiryDate,
      dose: _doseController.text,
      administrationRoute: administrationRoute,
      veterinarianId: _veterinarianId,
      veterinarianName: _veterinarianName,
      nextDueDate: _nextDueDate,
      withdrawalPeriodDays: _withdrawalPeriodDays,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    context.read<VaccinationProvider>().addVaccination(vaccination);

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isGroupVaccination
              ? 'Vaccination enregistrée pour ${_selectedAnimalIds.length} animaux'
              : 'Vaccination enregistrée',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle Vaccination'),
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text(
              'ENREGISTRER',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTypeSection(),
            const SizedBox(height: 16),
            _buildAnimalSection(),
            const SizedBox(height: 16),
            _buildProtocolSection(),
            const SizedBox(height: 16),
            _buildVaccineInfoSection(),
            const SizedBox(height: 16),
            _buildDatesSection(),
            const SizedBox(height: 16),
            _buildAdditionalInfoSection(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Type de vaccination',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // Switch "Vaccination de groupe" seulement si pas d'animal présélectionné
            if (widget.preselectedAnimalId == null) ...[
              SwitchListTile(
                title: const Text('Vaccination de groupe'),
                value: _isGroupVaccination,
                onChanged: (value) {
                  setState(() {
                    _isGroupVaccination = value;
                    if (value) {
                      _selectedAnimalId = null;
                    } else {
                      _selectedAnimalIds = [];
                    }
                  });
                },
              ),
              const Divider(),
            ],
            RadioListTile<VaccinationType>(
              title: const Text('Obligatoire'),
              value: VaccinationType.obligatoire,
              groupValue: _type,
              onChanged: (value) => setState(() => _type = value!),
            ),
            RadioListTile<VaccinationType>(
              title: const Text('Recommandée'),
              value: VaccinationType.recommandee,
              groupValue: _type,
              onChanged: (value) => setState(() => _type = value!),
            ),
            RadioListTile<VaccinationType>(
              title: const Text('Optionnelle'),
              value: VaccinationType.optionnelle,
              groupValue: _type,
              onChanged: (value) => setState(() => _type = value!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimalSection() {
    final animalProvider = context.read<AnimalProvider>();

    // Si animal présélectionné, afficher juste son nom
    if (widget.preselectedAnimalId != null) {
      final animal = animalProvider.getAnimalById(_selectedAnimalId!);

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Animal',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.pets, color: Colors.green.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        animal?.displayName ?? 'Animal introuvable',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _scanSingleAnimal,
                      icon: const Icon(Icons.qr_code_scanner, size: 20),
                      label: const Text('Changer'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Sinon, afficher le bouton de scan selon le mode
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isGroupVaccination
                  ? 'Animaux (${_selectedAnimalIds.length})'
                  : 'Animal',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Champ de recherche avec bouton scan intégré
            TextField(
              decoration: InputDecoration(
                labelText: _isGroupVaccination
                    ? 'Animaux sélectionnés'
                    : 'Animal sélectionné',
                hintText: 'Aucun animal sélectionné',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  color: Colors.green,
                  onPressed: _isGroupVaccination
                      ? _scanMultipleAnimals
                      : _scanSingleAnimal,
                  tooltip: _isGroupVaccination
                      ? 'Scanner les animaux'
                      : 'Scanner un animal',
                ),
                border: const OutlineInputBorder(),
              ),
              readOnly: true,
              controller: TextEditingController(
                text: _getSelectionSummary(animalProvider),
              ),
            ),

            // Liste des animaux sélectionnés (si mode groupe)
            if (_isGroupVaccination && _selectedAnimalIds.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedAnimalIds.map((animalId) {
                  final animal = animalProvider.getAnimalById(animalId);
                  return Chip(
                    label: Text(animal?.displayName ?? 'Inconnu'),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () {
                      setState(() {
                        _selectedAnimalIds.remove(animalId);
                      });
                    },
                  );
                }).toList(),
              ),
            ],

            // Animal sélectionné (si mode single)
            if (!_isGroupVaccination && _selectedAnimalId != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.pets, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        animalProvider
                                .getAnimalById(_selectedAnimalId!)
                                ?.displayName ??
                            'Inconnu',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () {
                        setState(() {
                          _selectedAnimalId = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Résumé de la sélection pour le TextField
  String _getSelectionSummary(AnimalProvider provider) {
    if (_isGroupVaccination) {
      if (_selectedAnimalIds.isEmpty) return '';
      return '${_selectedAnimalIds.length} animaux sélectionnés';
    } else {
      if (_selectedAnimalId == null) return '';
      final animal = provider.getAnimalById(_selectedAnimalId!);
      return animal?.displayName ?? 'Inconnu';
    }
  }

  /// Scanner un animal (mode single)
  Future<void> _scanSingleAnimal() async {
    final animal = await Navigator.push<Animal>(
      context,
      MaterialPageRoute(
        builder: (context) => const AnimalFinderScreen(
          mode: AnimalFinderMode.single,
          title: 'Scanner l\'animal à vacciner',
          allowedStatuses: [AnimalStatus.alive],
        ),
      ),
    );

    if (animal != null && mounted) {
      setState(() {
        _selectedAnimalId = animal.id;
        _isGroupVaccination = false;
      });
    }
  }

  /// Scanner plusieurs animaux (mode multiple)
  Future<void> _scanMultipleAnimals() async {
    final animals = await Navigator.push<List<Animal>>(
      context,
      MaterialPageRoute(
        builder: (context) => AnimalFinderScreen(
          mode: AnimalFinderMode.multiple,
          title: 'Scanner les animaux à vacciner',
          allowedStatuses: const [AnimalStatus.alive],
          initialSelection: _selectedAnimalIds
              .map((id) {
                return context.read<AnimalProvider>().getAnimalById(id);
              })
              .whereType<Animal>()
              .toList(),
        ),
      ),
    );

    if (animals != null && mounted) {
      setState(() {
        _selectedAnimalIds = animals.map((a) => a.id).toList();
      });
    }
  }

  Widget _buildProtocolSection() {
    final protocols = VaccinationProtocols.getAllProtocols();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Protocole (optionnel)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<VaccinationProtocol>(
              value: _selectedProtocol,
              decoration: const InputDecoration(
                labelText: 'Choisir un protocole',
                border: OutlineInputBorder(),
              ),
              items: protocols.map((protocol) {
                return DropdownMenuItem(
                  value: protocol,
                  child: Text('${protocol.name} (${protocol.disease})'),
                );
              }).toList(),
              onChanged: (protocol) {
                if (protocol != null) {
                  _applyProtocol(protocol);
                }
              },
            ),
            if (_selectedProtocol != null) ...[
              const SizedBox(height: 8),
              Text(
                _selectedProtocol!.description,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVaccineInfoSection() {
    final refProvider = context.watch<VaccinationReferenceProvider>();
    final vaccines = refProvider.vaccines;
    final diseases = refProvider.diseases;
    final routes = refProvider.routes;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informations vaccin',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Nom vaccin - Dropdown
            DropdownButtonFormField<VaccineReference>(
              value: _selectedVaccine,
              decoration: const InputDecoration(
                labelText: 'Nom du vaccin *',
                border: OutlineInputBorder(),
              ),
              items: vaccines.map((vaccine) {
                return DropdownMenuItem(
                  value: vaccine,
                  child: Text(vaccine.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedVaccine = value;
                  if (value?.name != 'Autre') {
                    _vaccineNameCustomController.clear();
                  }
                });
              },
              validator: (value) {
                if (value == null) return 'Champ requis';
                if (value.name == 'Autre' &&
                    _vaccineNameCustomController.text.isEmpty) {
                  return 'Veuillez préciser';
                }
                return null;
              },
            ),

            // Champ custom si "Autre" sélectionné
            if (_selectedVaccine?.name == 'Autre') ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _vaccineNameCustomController,
                decoration: const InputDecoration(
                  labelText: 'Précisez le nom *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (_selectedVaccine?.name == 'Autre' &&
                      (value == null || value.isEmpty)) {
                    return 'Champ requis';
                  }
                  return null;
                },
              ),
            ],

            const SizedBox(height: 12),

            // Maladie - Dropdown
            DropdownButtonFormField<DiseaseReference>(
              value: _selectedDisease,
              decoration: const InputDecoration(
                labelText: 'Maladie *',
                border: OutlineInputBorder(),
              ),
              items: diseases.map((disease) {
                return DropdownMenuItem(
                  value: disease,
                  child: Text(disease.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDisease = value;
                  if (value?.name != 'Autre') {
                    _diseaseCustomController.clear();
                  }
                });
              },
              validator: (value) {
                if (value == null) return 'Champ requis';
                if (value.name == 'Autre' &&
                    _diseaseCustomController.text.isEmpty) {
                  return 'Veuillez préciser';
                }
                return null;
              },
            ),

            // Champ custom si "Autre" sélectionné
            if (_selectedDisease?.name == 'Autre') ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _diseaseCustomController,
                decoration: const InputDecoration(
                  labelText: 'Précisez la maladie *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (_selectedDisease?.name == 'Autre' &&
                      (value == null || value.isEmpty)) {
                    return 'Champ requis';
                  }
                  return null;
                },
              ),
            ],

            const SizedBox(height: 12),

            // Dose
            TextFormField(
              controller: _doseController,
              decoration: const InputDecoration(
                labelText: 'Dose *',
                border: OutlineInputBorder(),
                hintText: 'Ex: 2 ml',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Champ requis';
                }
                return null;
              },
            ),

            const SizedBox(height: 12),

            // Voie administration - Dropdown
            DropdownButtonFormField<AdministrationRoute>(
              value: _selectedRoute,
              decoration: const InputDecoration(
                labelText: 'Voie d\'administration *',
                border: OutlineInputBorder(),
              ),
              items: routes.map((route) {
                return DropdownMenuItem(
                  value: route,
                  child: Text(route.displayName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRoute = value;
                  if (value?.code != 'Autre') {
                    _administrationRouteCustomController.clear();
                  }
                });
              },
              validator: (value) {
                if (value == null) return 'Champ requis';
                if (value.code == 'Autre' &&
                    _administrationRouteCustomController.text.isEmpty) {
                  return 'Veuillez préciser';
                }
                return null;
              },
            ),

            // Champ custom si "Autre" sélectionné
            if (_selectedRoute?.code == 'Autre') ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _administrationRouteCustomController,
                decoration: const InputDecoration(
                  labelText: 'Précisez la voie *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (_selectedRoute?.code == 'Autre' &&
                      (value == null || value.isEmpty)) {
                    return 'Champ requis';
                  }
                  return null;
                },
              ),
            ],

            const SizedBox(height: 12),

            // N° de lot
            TextFormField(
              controller: _batchNumberController,
              decoration: const InputDecoration(
                labelText: 'N° de lot',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dates',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('Date vaccination *'),
              subtitle: Text(_formatDate(_vaccinationDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _vaccinationDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _vaccinationDate = date;
                    if (_selectedProtocol != null) {
                      _nextDueDate =
                          _selectedProtocol!.calculateNextDueDate(date);
                    }
                  });
                }
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Date rappel'),
              subtitle: Text(_nextDueDate != null
                  ? _formatDate(_nextDueDate!)
                  : 'Non défini'),
              trailing: _nextDueDate != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _nextDueDate = null),
                    )
                  : const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _nextDueDate ??
                      DateTime.now().add(const Duration(days: 365)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 3650)),
                );
                if (date != null) {
                  setState(() => _nextDueDate = date);
                }
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Date expiration vaccin'),
              subtitle: Text(_expiryDate != null
                  ? _formatDate(_expiryDate!)
                  : 'Non défini'),
              trailing: _expiryDate != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _expiryDate = null),
                    )
                  : const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _expiryDate ??
                      DateTime.now().add(const Duration(days: 365)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 3650)),
                );
                if (date != null) {
                  setState(() => _expiryDate = date);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informations complémentaires',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: _withdrawalPeriodDays.toString(),
              decoration: const InputDecoration(
                labelText: 'Délai d\'attente (jours)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _withdrawalPeriodDays = int.tryParse(value) ?? 0;
                });
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Vétérinaire',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _veterinarianName = value,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
