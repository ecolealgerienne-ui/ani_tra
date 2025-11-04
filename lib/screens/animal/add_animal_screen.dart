// screens/add_animal_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/animal.dart';
import '../../models/movement.dart';
import '../../models/scan_result.dart';

import '../../providers/animal_provider.dart';
import '../../providers/sync_provider.dart';
import '../../providers/settings_provider.dart';
import '../../data/animal_config.dart';
import 'universal_scanner_screen.dart';
import 'animal_finder_screen.dart';
import 'mother_history_screen.dart';

/// Écran d'ajout rapide d'un animal
///
/// Permet d'ajouter un animal via un formulaire simplifié
/// Gère à la fois les naissances et les achats
/// Crée automatiquement l'animal + le mouvement correspondant
class AddAnimalScreen extends StatefulWidget {
  final String? scannedEID;

  const AddAnimalScreen({super.key, this.scannedEID});

  @override
  State<AddAnimalScreen> createState() => _AddAnimalScreenState();
}

class _AddAnimalScreenState extends State<AddAnimalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  // Controllers
  final _primaryIdController = TextEditingController();
  final _officialNumberController = TextEditingController();
  final _visualIdController = TextEditingController();
  final _provenanceController = TextEditingController();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();

  // État du formulaire
  DateTime? _selectedBirthDate;
  AnimalSex? _selectedSex;
  String _selectedOrigin = 'Naissance'; // Naissance / Achat / Autre
  String? _selectedMotherId;
  String? _selectedMotherDisplay;

  // ÉTAPE 5 : Type et Race
  String? _selectedSpeciesId;
  String? _selectedBreedId;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Date par défaut : aujourd'hui
    _selectedBirthDate = DateTime.now();
    // Pré-remplir EID si fourni
    if (widget.scannedEID != null) {
      _primaryIdController.text = widget.scannedEID!;
    }

    // ÉTAPE 5 : Charger les valeurs par défaut du SettingsProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = context.read<SettingsProvider>();
      setState(() {
        _selectedSpeciesId = settings.defaultSpeciesId;
        _selectedBreedId = settings.defaultBreedId;
      });
    });
  }

  @override
  void dispose() {
    _primaryIdController.dispose();
    _officialNumberController.dispose();
    _visualIdController.dispose();
    _provenanceController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  /// Générer un ID unique
  String _generateId() => _uuid.v4();

  /// Scanner un animal pour pré-remplir l'EID
  Future<void> _simulateScan() async {
    final animal = await Navigator.push<Animal>(
      context,
      MaterialPageRoute(
        builder: (context) => const AnimalFinderScreen(
          mode: AnimalFinderMode.single,
          title: 'Scanner l\'animal',
        ),
      ),
    );

    if (animal != null && mounted) {
      setState(() {
        if (animal.currentEid != null) {
          _primaryIdController.text = animal.currentEid!;
        }
        if (animal.officialNumber != null) {
          _officialNumberController.text = animal.officialNumber!;
        }
        if (animal.visualId != null) {
          _visualIdController.text = animal.visualId!;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Identification scannée: ${animal.displayName}'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  /// Sélectionner la mère via scan
  Future<void> _scanMother() async {
    final mother = await Navigator.push<Animal>(
      context,
      MaterialPageRoute(
        builder: (context) => const AnimalFinderScreen(
          mode: AnimalFinderMode.single,
          title: 'Scanner la mère',
          allowedStatuses: [AnimalStatus.alive],
        ),
      ),
    );

    if (mother != null) {
      // Vérifier que c'est une femelle
      if (mother.sex != AnimalSex.female) {
        if (mounted) {
          _showError('⚠️ La mère doit être une femelle');
        }
        return;
      }

      setState(() {
        _selectedMotherId = mother.id;
        _selectedMotherDisplay = mother.displayName;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Mère sélectionnée: ${mother.displayName}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  /// Sélectionner la date de naissance
  Future<void> _selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      locale: const Locale('fr', 'FR'),
      helpText: 'Date de naissance',
      cancelText: 'Annuler',
      confirmText: 'Valider',
    );

    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  /// Valider et sauvegarder l'animal
  Future<void> _saveAnimal() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Vérifications supplémentaires

    // Au moins un identifiant requis
    final hasEid = _primaryIdController.text.trim().isNotEmpty;
    final hasOfficialNumber = _officialNumberController.text.trim().isNotEmpty;
    final hasVisualId = _visualIdController.text.trim().isNotEmpty;

    if (!hasEid && !hasOfficialNumber && !hasVisualId) {
      _showError(
          '⚠️ Au moins un identifiant requis (EID, N° officiel ou ID visuel)');
      return;
    }

    if (_selectedSex == null) {
      _showError('⚠️ Veuillez sélectionner le sexe');
      return;
    }

    if (_selectedBirthDate == null) {
      _showError('⚠️ Veuillez sélectionner la date de naissance');
      return;
    }

    // 🆕 PART3 - Vérifier que la mère existe et est valide
    if (_selectedMotherId != null) {
      final animalProvider = context.read<AnimalProvider>();
      final mother = animalProvider.getAnimalById(_selectedMotherId!);

      if (mother == null) {
        _showError('⚠️ Mère introuvable', isError: true);
        return;
      }

      // Validation PART3
      if (!mother.canBeMother) {
        _showError('⚠️ ${mother.cannotBeMotherReason}');
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final animalProvider = context.read<AnimalProvider>();
      final syncProvider = context.read<SyncProvider>();

      // 1. Créer l'animal
      final animal = Animal(
        id: _generateId(),
        currentEid: _primaryIdController.text.trim().isNotEmpty
            ? _primaryIdController.text.trim()
            : null,
        sex: _selectedSex!,
        status: AnimalStatus.alive,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        officialNumber: _officialNumberController.text.trim().isNotEmpty
            ? _officialNumberController.text.trim()
            : null,
        birthDate: _selectedBirthDate ?? DateTime.now(),
        motherId: _selectedMotherId,
        // ÉTAPE 5 : Ajouter type et race
        speciesId: _selectedSpeciesId,
        breedId: _selectedBreedId,
        visualId: _visualIdController.text.trim().isNotEmpty
            ? _visualIdController.text.trim()
            : null,
      );

      animalProvider.addAnimal(animal);

      // 2. Créer le mouvement correspondant
      Movement? movement;

      if (_selectedOrigin == 'Naissance') {
        movement = Movement(
          id: _generateId(),
          type: MovementType.birth,
          animalId: animal.id,
          movementDate: _selectedBirthDate!,
          notes: _notesController.text.trim().isNotEmpty
              ? _notesController.text.trim()
              : null,
          synced: false,
          createdAt: DateTime.now(),
        );
      } else if (_selectedOrigin == 'Achat') {
        movement = Movement(
          id: _generateId(),
          type: MovementType.purchase,
          animalId: animal.id,
          movementDate: DateTime.now(),
          fromFarmId: _provenanceController.text.trim().isNotEmpty
              ? _provenanceController.text.trim()
              : null,
          price: _priceController.text.trim().isNotEmpty
              ? double.tryParse(_priceController.text.trim())
              : null,
          notes: _notesController.text.trim().isNotEmpty
              ? _notesController.text.trim()
              : null,
          synced: false,
          createdAt: DateTime.now(),
        );
      }

      if (movement != null) {
        // Note: Les mouvements sont gérés via MovementProvider
        // Pour l'instant, on les ignore dans cet écran simplifié
        // TODO: Ajouter la gestion des mouvements si nécessaire
      }

      // 3. Incrémenter les données en attente de sync
      syncProvider.incrementPendingData();

      if (!mounted) return;

      // 4. Message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Animal enregistré avec succès'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // 5. Retour à l'écran précédent
      Navigator.pop(context, animal);
    } catch (e) {
      if (!mounted) return;

      _showError('❌ Erreur: ${e.toString()}', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Afficher un message d'erreur
  void _showError(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un animal'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // === Section : Identification ===
            _buildSectionHeader('📋 Identification'),
            const SizedBox(height: 16),

            // EID / Numéro principal
            TextFormField(
              controller: _primaryIdController,
              decoration: InputDecoration(
                labelText: 'EID (Numéro électronique)',
                hintText: 'FR1234567890123',
                prefixIcon: const Icon(Icons.qr_code),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  tooltip: 'Scanner',
                  onPressed: _simulateScan,
                ),
                helperText:
                    'Au moins un identifiant requis (EID, N° officiel ou ID visuel)',
              ),
            ),

            const SizedBox(height: 16),

            // Numéro officiel
            TextFormField(
              controller: _officialNumberController,
              decoration: const InputDecoration(
                labelText: 'Numéro officiel (optionnel)',
                hintText: 'Ex: 123456',
                prefixIcon: Icon(Icons.numbers),
              ),
            ),

            const SizedBox(height: 16),

            // ID visuel
            TextFormField(
              controller: _visualIdController,
              decoration: const InputDecoration(
                labelText: 'ID visuel (optionnel)',
                hintText: 'Rouge-42, Tache-Blanche...',
                prefixIcon: Icon(Icons.visibility),
                helperText: 'Pour identifier facilement l\'animal',
              ),
            ),

            const SizedBox(height: 24),

            // === ÉTAPE 5 : Section Type et Race ===
            _buildSectionHeader('🐑 Type et Race'),
            const SizedBox(height: 16),

            // Dropdown Type d'animal
            DropdownButtonFormField<String>(
              value: _selectedSpeciesId,
              decoration: InputDecoration(
                labelText: 'Type d\'animal *',
                prefixIcon: Icon(
                  Icons.pets,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              items: AnimalConfig.availableSpecies.map((species) {
                return DropdownMenuItem(
                  value: species.id,
                  child: Text('${species.icon} ${species.nameFr}'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSpeciesId = value;
                  // Réinitialiser la race si on change de type
                  if (value != null) {
                    final breeds = AnimalConfig.getBreedsBySpecies(value);
                    if (breeds.isNotEmpty &&
                        (breeds.every((b) => b.id != _selectedBreedId))) {
                      _selectedBreedId = breeds.first.id;
                    }
                  } else {
                    _selectedBreedId = null;
                  }
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Type d\'animal obligatoire';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Dropdown Race
            DropdownButtonFormField<String>(
              value: _selectedBreedId,
              decoration: InputDecoration(
                labelText: 'Race (optionnelle)',
                prefixIcon: Icon(
                  Icons.category,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              items: _selectedSpeciesId != null
                  ? [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('-- Aucune race --'),
                      ),
                      ...AnimalConfig.getBreedsBySpecies(_selectedSpeciesId!)
                          .map((breed) {
                        return DropdownMenuItem(
                          value: breed.id,
                          child: Text(breed.nameFr),
                        );
                      }),
                    ]
                  : [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Sélectionnez d\'abord un type'),
                      ),
                    ],
              onChanged: _selectedSpeciesId != null
                  ? (value) {
                      setState(() {
                        _selectedBreedId = value;
                      });
                    }
                  : null,
            ),

            const SizedBox(height: 16),

            // Date de naissance
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.cake),
              title: const Text('Date de naissance *'),
              subtitle: Text(
                _selectedBirthDate != null
                    ? _formatDate(_selectedBirthDate!)
                    : 'Non définie',
                style: TextStyle(
                  color:
                      _selectedBirthDate != null ? Colors.black87 : Colors.grey,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _selectBirthDate,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),

            const SizedBox(height: 24),

            // === Section : Caractéristiques ===
            _buildSectionHeader('🐄 Caractéristiques'),
            const SizedBox(height: 16),

            // Sexe
            const Text(
              'Sexe *',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<AnimalSex>(
                    title: const Text('Mâle'),
                    value: AnimalSex.male,
                    groupValue: _selectedSex,
                    onChanged: (value) {
                      setState(() {
                        _selectedSex = value;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: _selectedSex == AnimalSex.male
                            ? Colors.blue
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RadioListTile<AnimalSex>(
                    title: const Text('Femelle'),
                    value: AnimalSex.female,
                    groupValue: _selectedSex,
                    onChanged: (value) {
                      setState(() {
                        _selectedSex = value;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: _selectedSex == AnimalSex.female
                            ? Colors.pink
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Origine
            DropdownButtonFormField<String>(
              value: _selectedOrigin,
              decoration: const InputDecoration(
                labelText: 'Origine *',
                prefixIcon: Icon(Icons.location_on),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Naissance',
                  child: Text('Naissance'),
                ),
                DropdownMenuItem(
                  value: 'Achat',
                  child: Text('Achat'),
                ),
                DropdownMenuItem(
                  value: 'Autre',
                  child: Text('Autre'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedOrigin = value!;
                  // Réinitialiser les champs conditionnels
                  _selectedMotherId = null;
                  _selectedMotherDisplay = null;
                  _provenanceController.clear();
                  _priceController.clear();
                });
              },
            ),

            const SizedBox(height: 16),

            // Champs conditionnels selon l'origine
            if (_selectedOrigin == 'Naissance') ...[
              // Mère
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.family_restroom),
                title: const Text('Mère (optionnel)'),
                subtitle: Text(
                  _selectedMotherDisplay ?? 'Non définie',
                  style: TextStyle(
                    color: _selectedMotherDisplay != null
                        ? Colors.black87
                        : Colors.grey,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_selectedMotherId != null)
                      IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: 'Retirer',
                        onPressed: () {
                          setState(() {
                            _selectedMotherId = null;
                            _selectedMotherDisplay = null;
                          });
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.qr_code_scanner),
                      tooltip: 'Scanner',
                      onPressed: _scanMother,
                    ),
                  ],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ],

            if (_selectedOrigin == 'Achat') ...[
              // Provenance
              TextFormField(
                controller: _provenanceController,
                decoration: const InputDecoration(
                  labelText: 'Provenance',
                  hintText: 'Nom de la ferme ou éleveur',
                  prefixIcon: Icon(Icons.place),
                ),
              ),

              const SizedBox(height: 16),

              // Prix d'achat
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Prix d\'achat',
                  hintText: '0.00',
                  prefixIcon: Icon(Icons.euro),
                  suffixText: '€',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),
            ],

            const SizedBox(height: 24),

            // Notes
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optionnel)',
                hintText: 'Observations, remarques...',
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 3,
              maxLength: 500,
            ),

            const SizedBox(height: 32),

            // Boutons d'action
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveAnimal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save, size: 20),
                              SizedBox(width: 8),
                              Text('Enregistrer'),
                            ],
                          ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// Widget : Header de section
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
  }

  /// Formater une date en DD/MM/YYYY
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

/// Widget de dialogue pour scanner la mère
class _ScanMotherDialog extends StatefulWidget {
  final Function(String motherId, String motherDisplay) onMotherSelected;

  const _ScanMotherDialog({
    required this.onMotherSelected,
  });

  @override
  State<_ScanMotherDialog> createState() => _ScanMotherDialogState();
}

class _ScanMotherDialogState extends State<_ScanMotherDialog> {
  final _eidController = TextEditingController();
  Animal? _scannedMother;
  bool _isScanning = false;
  String? _errorMessage;

  @override
  void dispose() {
    _eidController.dispose();
    super.dispose();
  }

  /// Simuler le scan d'une mère
  void _simulateScan() {
    setState(() {
      _isScanning = true;
      _errorMessage = null;
      _scannedMother = null;
    });

    // Simulation d'un délai de scan
    Future.delayed(const Duration(milliseconds: 500), () {
      final animalProvider = context.read<AnimalProvider>();

      // Chercher une femelle dans le troupeau
      final females = animalProvider.animals
          .where((a) =>
              a.sex == AnimalSex.female && a.status == AnimalStatus.alive)
          .toList();

      if (females.isEmpty) {
        setState(() {
          _isScanning = false;
          _errorMessage = 'Aucune femelle disponible dans le troupeau';
        });
        return;
      }

      // Prendre une femelle aléatoirement pour simuler
      final mockMother = (females..shuffle()).first;

      setState(() {
        _isScanning = false;
        _scannedMother = mockMother;
        _eidController.text = mockMother.eid ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.qr_code_scanner, color: Colors.green),
          SizedBox(width: 8),
          Text('Scanner la mère'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Champ EID
            TextField(
              controller: _eidController,
              decoration: const InputDecoration(
                labelText: 'EID de la mère',
                hintText: 'FRxxxxxxxxxxxx',
                prefixIcon: Icon(Icons.tag),
                border: OutlineInputBorder(),
              ),
              enabled: !_isScanning,
              readOnly: true,
            ),

            const SizedBox(height: 16),

            // Bouton Scanner
            ElevatedButton.icon(
              onPressed: _isScanning ? null : _simulateScan,
              icon: _isScanning
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.qr_code_scanner),
              label: Text(_isScanning ? 'Scan en cours...' : 'Scanner'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),

            // Message d'erreur
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning,
                        color: Colors.orange.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.orange.shade900,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Informations de la mère scannée
            if (_scannedMother != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: Colors.green.shade700, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Mère détectée',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_scannedMother!.eid != null)
                      Text(
                        'EID: ${_scannedMother!.eid}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    if (_scannedMother!.officialNumber != null)
                      Text(
                        'N° officiel: ${_scannedMother!.officialNumber}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    if (_scannedMother!.visualId != null)
                      Text(
                        'ID visuel: ${_scannedMother!.visualId}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    Text(
                      'Âge: ${_scannedMother!.ageInMonths} mois',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _scannedMother == null
              ? null
              : () {
                  widget.onMotherSelected(
                    _scannedMother!.id,
                    _scannedMother!.officialNumber ??
                        _scannedMother!.eid ??
                        _scannedMother!.visualId ??
                        'Animal ${_scannedMother!.id.substring(0, 8)}',
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '✅ Mère ajoutée: ${_scannedMother!.officialNumber ?? _scannedMother!.eid ?? _scannedMother!.visualId ?? 'Animal ${_scannedMother!.id.substring(0, 8)}'}',
                      ),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: const Text('Ajouter'),
        ),
      ],
    );
  }
}

/// Widget de dialogue pour scanner l'EID de l'animal
class _ScanEIDDialog extends StatefulWidget {
  final Function(String eid) onEIDScanned;

  const _ScanEIDDialog({
    required this.onEIDScanned,
  });

  @override
  State<_ScanEIDDialog> createState() => _ScanEIDDialogState();
}

class _ScanEIDDialogState extends State<_ScanEIDDialog> {
  final _eidController = TextEditingController();
  String? _scannedEID;
  bool _isScanning = false;

  @override
  void dispose() {
    _eidController.dispose();
    super.dispose();
  }

  /// Simuler le scan d'un EID
  void _simulateScan() {
    setState(() {
      _isScanning = true;
      _scannedEID = null;
    });

    // Simulation d'un délai de scan
    Future.delayed(const Duration(milliseconds: 800), () {
      // Génération d'un EID simulé au format FR + 13 chiffres
      final random = DateTime.now().millisecondsSinceEpoch % 10000000000000;
      final mockEid = 'FR${random.toString().padLeft(13, '0')}';

      setState(() {
        _isScanning = false;
        _scannedEID = mockEid;
        _eidController.text = mockEid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.qr_code_scanner, color: Colors.blue),
          SizedBox(width: 8),
          Text('Scanner l\'EID'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Placez le lecteur RFID près de l\'animal pour scanner son EID électronique.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 16),

            // Champ EID
            TextField(
              controller: _eidController,
              decoration: const InputDecoration(
                labelText: 'EID détecté',
                hintText: 'FR1234567890123',
                prefixIcon: Icon(Icons.tag),
                border: OutlineInputBorder(),
              ),
              enabled: !_isScanning,
              readOnly: true,
            ),

            const SizedBox(height: 16),

            // Bouton Scanner
            ElevatedButton.icon(
              onPressed: _isScanning ? null : _simulateScan,
              icon: _isScanning
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.qr_code_scanner),
              label: Text(_isScanning ? 'Scan en cours...' : 'Scanner'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),

            // Résultat du scan
            if (_scannedEID != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: Colors.green.shade700, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'EID détecté avec succès',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _scannedEID!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'monospace',
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatEID(_scannedEID!),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _scannedEID == null
              ? null
              : () {
                  widget.onEIDScanned(_scannedEID!);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('✅ EID scanné: $_scannedEID'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: const Text('Ajouter'),
        ),
      ],
    );
  }

  /// Formater l'EID en groupes de 3 chiffres
  String _formatEID(String eid) {
    if (eid.length == 15) {
      return '${eid.substring(0, 3)} ${eid.substring(3, 6)} ${eid.substring(6, 9)} ${eid.substring(9, 12)} ${eid.substring(12)}';
    }
    return eid;
  }
}
