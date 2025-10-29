// screens/add_animal_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/animal.dart';
import '../models/movement.dart';
import '../providers/animal_provider.dart';
import '../providers/sync_provider.dart';

/// Écran d'ajout rapide d'un animal
///
/// Permet d'ajouter un animal via un formulaire simplifié
/// Gère à la fois les naissances et les achats
/// Crée automatiquement l'animal + le mouvement correspondant
class AddAnimalScreen extends StatefulWidget {
  const AddAnimalScreen({super.key});

  @override
  State<AddAnimalScreen> createState() => _AddAnimalScreenState();
}

class _AddAnimalScreenState extends State<AddAnimalScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _eidController = TextEditingController();
  final _officialNumberController = TextEditingController();
  final _provenanceController = TextEditingController();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();

  // État du formulaire
  DateTime? _selectedBirthDate;
  AnimalSex? _selectedSex;
  String _selectedOrigin = 'Naissance'; // Naissance / Achat / Autre
  String? _selectedMotherId;
  String? _selectedMotherDisplay;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Date par défaut : aujourd'hui
    _selectedBirthDate = DateTime.now();
  }

  @override
  void dispose() {
    _eidController.dispose();
    _officialNumberController.dispose();
    _provenanceController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  /// Simuler le scan d'un EID
  void _simulateScan() {
    final animalProvider = context.read<AnimalProvider>();
    final mockAnimal = animalProvider.simulateScan();

    setState(() {
      _eidController.text = mockAnimal.eid;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ EID scanné: ${mockAnimal.eid}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  /// Sélectionner la mère via scan (simulation)
  void _scanMother() {
    final animalProvider = context.read<AnimalProvider>();
    final mockMother = animalProvider.simulateScan();

    // Vérifier que c'est une femelle
    if (mockMother.sex != AnimalSex.female) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ La mère doit être une femelle'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _selectedMotherId = mockMother.id;
      _selectedMotherDisplay = mockMother.officialNumber ?? mockMother.eid;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Mère: $_selectedMotherDisplay'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
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
    if (_selectedSex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Veuillez sélectionner le sexe'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedBirthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Veuillez sélectionner la date de naissance'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Vérifier que la mère existe si fournie
    if (_selectedMotherId != null) {
      final animalProvider = context.read<AnimalProvider>();
      final mother = animalProvider.getAnimalById(_selectedMotherId!);

      if (mother == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ Mère introuvable'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (mother.sex != AnimalSex.female) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ La mère doit être une femelle'),
            backgroundColor: Colors.orange,
          ),
        );
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
        primaryId: _eidController.text.trim(),
        idType: IdentificationType.rfid,
        officialNumber: _officialNumberController.text.trim().isNotEmpty
            ? _officialNumberController.text.trim()
            : null,
        birthDate: _selectedBirthDate,
        sex: _selectedSex!,
        motherId: _selectedMotherId,
        status: AnimalStatus.alive,
        synced: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
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
        animalProvider.addMovement(movement);
      }

      // 3. Incrémenter les données en attente de sync
      syncProvider.incrementPendingData();

      // 4. Feedback et retour
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ Animal ${animal.officialNumber ?? animal.eid} ajouté avec succès',
            ),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Générer un ID unique
  String _generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'animal_${timestamp}_$random';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un Animal'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Section Identification
            _buildSectionHeader('Identification'),
            const SizedBox(height: 16),

            // EID
            TextFormField(
              controller: _eidController,
              decoration: InputDecoration(
                labelText: 'EID (15 chiffres) *',
                hintText: '250001234567890',
                prefixIcon: const Icon(Icons.tag),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  tooltip: 'Scanner',
                  onPressed: _simulateScan,
                ),
              ),
              keyboardType: TextInputType.number,
              maxLength: 15,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'EID requis';
                }
                if (value.trim().length != 15) {
                  return 'EID doit contenir exactement 15 chiffres';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // N° Officiel
            TextFormField(
              controller: _officialNumberController,
              decoration: const InputDecoration(
                labelText: 'N° Officiel',
                hintText: 'FR-2025-0001',
                prefixIcon: Icon(Icons.numbers),
              ),
            ),

            const SizedBox(height: 24),

            // Section Informations de Base
            _buildSectionHeader('Informations de Base'),
            const SizedBox(height: 16),

            // Date de naissance
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
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
              trailing: const Icon(Icons.chevron_right),
              onTap: _selectBirthDate,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),

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
