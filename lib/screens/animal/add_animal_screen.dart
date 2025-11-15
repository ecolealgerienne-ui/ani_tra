// screens/add_animal_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart';

import '../../models/animal.dart';
import '../../models/movement.dart';
import '../../models/breed.dart';
//import '../../models/scan_result.dart';

import '../../providers/animal_provider.dart';
import '../../providers/breed_provider.dart';
import '../../providers/sync_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/farm_preferences_provider.dart';
import '../../data/animal_config.dart';
//import 'universal_scanner_screen.dart';
import 'animal_finder_screen.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';
//import 'mother_history_screen.dart';

/// Ãƒâ€°cran d'ajout rapide d'un animal
///
/// Permet d'ajouter un animal via un formulaire simplifiÃƒÂ©
/// GÃƒÂ¨re ÃƒÂ  la fois les naissances et les achats
/// CrÃƒÂ©e automatiquement l'animal + le mouvement correspondant
class AddAnimalScreen extends StatefulWidget {
  final String? scannedEID;
  final Animal? editingAnimal;

  const AddAnimalScreen({super.key, this.scannedEID, this.editingAnimal});

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
  String _selectedOrigin = 'Naissance';
  String? _selectedMotherId;
  String? _selectedMotherDisplay;

  // ÉTAPE 5 : Type et Race
  String? _selectedSpeciesId;
  String? _selectedBreedId;

  bool _isLoading = false;
  late bool _isEditMode;

  @override
  void initState() {
    super.initState();

    // Déterminer si on est en mode édition
    _isEditMode = widget.editingAnimal != null;

    // Si on édite un animal, pré-remplir TOUS les champs
    if (_isEditMode && widget.editingAnimal != null) {
      final animal = widget.editingAnimal!;
      _primaryIdController.text = animal.currentEid ?? '';
      _officialNumberController.text = animal.officialNumber ?? '';
      _visualIdController.text = animal.visualId ?? '';
      _selectedBirthDate = animal.birthDate;
      _selectedSex = animal.sex;
      _selectedSpeciesId = animal.speciesId;
      _selectedBreedId = animal.breedId;
      _selectedMotherId = animal.motherId;
      if (animal.motherId != null) {
        final provider = context.read<AnimalProvider>();
        final mother = provider.getAnimalById(animal.motherId!);
        _selectedMotherDisplay = mother?.displayName;
      }
    } else {
      // Mode création : date par défaut = aujourd'hui
      _selectedBirthDate = DateTime.now();
      // Pré-remplir EID si fourni par scan
      if (widget.scannedEID != null) {
        _primaryIdController.text = widget.scannedEID!;
      }
    }

    // ÉTAPE 5 : Charger les valeurs par défaut depuis FarmPreferencesProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final farmPrefs = context.read<FarmPreferencesProvider>();
      if (!_isEditMode) {
        setState(() {
          _selectedSpeciesId = farmPrefs.defaultSpeciesId;
          _selectedBreedId = farmPrefs.defaultBreedId;
        });
      } else {
        if (_selectedSpeciesId == null) {
          setState(() {
            _selectedSpeciesId = farmPrefs.defaultSpeciesId;
          });
        }
        if (_selectedBreedId == null) {
          setState(() {
            _selectedBreedId = farmPrefs.defaultBreedId;
          });
        }
      }
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

  /// GÃƒÂ©nÃƒÂ©rer un ID unique
  String _generateId() => _uuid.v4();

  /// Scanner un animal pour prÃƒÂ©-remplir l'EID
  Future<void> _simulateScan() async {
    final animal = await Navigator.push<Animal>(
      context,
      MaterialPageRoute(
        builder: (context) => AnimalFinderScreen(
          mode: AnimalFinderMode.single,
          title: AppLocalizations.of(context).translate(AppStrings.scanAnimal),
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
          content: Text(AppLocalizations.of(context)
              .translate(AppStrings.idScanned)
              .replaceAll('{name}', animal.displayName)),
          backgroundColor: AppConstants.successGreen,
        ),
      );
    }
  }

  /// SÃƒÂ©lectionner la mÃƒÂ¨re via scan
  Future<void> _scanMother() async {
    final mother = await Navigator.push<Animal>(
      context,
      MaterialPageRoute(
        builder: (context) => AnimalFinderScreen(
          mode: AnimalFinderMode.single,
          title: AppLocalizations.of(context).translate(AppStrings.scanMother),
          allowedStatuses: const [AnimalStatus.alive],
        ),
      ),
    );

    if (mother != null) {
      // VÃƒÂ©rifier que c'est une femelle
      if (mother.sex != AnimalSex.female) {
        if (mounted) {
          _showError(AppLocalizations.of(context)
              .translate(AppStrings.motherMustBeFemale));
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
            content: Text(AppLocalizations.of(context)
                .translate(AppStrings.motherSelected)
                .replaceAll('{name}', mother.displayName)),
            backgroundColor: AppConstants.successGreen,
          ),
        );
      }
    }
  }

  /// SÃƒÂ©lectionner la date de naissance
  Future<void> _selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      locale: const Locale('fr', 'FR'),
      helpText:
          AppLocalizations.of(context).translate(AppStrings.birthDateRequired),
      cancelText: AppLocalizations.of(context).translate(AppStrings.cancel),
      confirmText: AppLocalizations.of(context).translate(AppStrings.validate),
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

    // VÃƒÂ©rifications supplÃƒÂ©mentaires

    // Au moins un identifiant requis
    final hasEid = _primaryIdController.text.trim().isNotEmpty;
    final hasOfficialNumber = _officialNumberController.text.trim().isNotEmpty;
    final hasVisualId = _visualIdController.text.trim().isNotEmpty;

    if (!hasEid && !hasOfficialNumber && !hasVisualId) {
      _showError(AppLocalizations.of(context)
          .translate(AppStrings.atLeastOneIdRequiredError));
      return;
    }

    if (_selectedSex == null) {
      _showError(
          AppLocalizations.of(context).translate(AppStrings.selectSexError));
      return;
    }

    if (_selectedBirthDate == null) {
      _showError(AppLocalizations.of(context)
          .translate(AppStrings.selectBirthDateError));
      return;
    }

    // Ã°Å¸â€ â€¢ PART3 - VÃƒÂ©rifier que la mÃƒÂ¨re existe et est valide
    if (_selectedMotherId != null) {
      final animalProvider = context.read<AnimalProvider>();
      final mother = animalProvider.getAnimalById(_selectedMotherId!);

      if (mother == null) {
        _showError(
            AppLocalizations.of(context).translate(AppStrings.motherNotFound),
            isError: true);
        return;
      }

      // Validation PART3
      if (!mother.canBeMother) {
        _showError('Ã¢Å¡Â Ã¯Â¸Â ${mother.cannotBeMotherReason}');
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final animalProvider = context.read<AnimalProvider>();
      final syncProvider = context.read<SyncProvider>();

      // 1. CrÃƒÂ©er ou éditer l'animal
      final animal = _isEditMode
          ? widget.editingAnimal!.copyWith(
              currentEid: _primaryIdController.text.trim().isNotEmpty
                  ? _primaryIdController.text.trim()
                  : null,
              officialNumber: _officialNumberController.text.trim().isNotEmpty
                  ? _officialNumberController.text.trim()
                  : null,
              visualId: _visualIdController.text.trim().isNotEmpty
                  ? _visualIdController.text.trim()
                  : null,
              sex: _selectedSex!,
              birthDate: _selectedBirthDate ?? DateTime.now(),
              motherId: _selectedMotherId,
              speciesId: _selectedSpeciesId,
              breedId: _selectedBreedId,
              updatedAt: DateTime.now(),
            )
          : Animal(
              id: _generateId(),
              currentEid: _primaryIdController.text.trim().isNotEmpty
                  ? _primaryIdController.text.trim()
                  : null,
              sex: _selectedSex!,
              status: AnimalStatus.draft,
              validatedAt: null,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              officialNumber: _officialNumberController.text.trim().isNotEmpty
                  ? _officialNumberController.text.trim()
                  : null,
              birthDate: _selectedBirthDate ?? DateTime.now(),
              motherId: _selectedMotherId,
              speciesId: _selectedSpeciesId,
              breedId: _selectedBreedId,
              visualId: _visualIdController.text.trim().isNotEmpty
                  ? _visualIdController.text.trim()
                  : null,
            );

      // Mode édition : mettre à jour l'animal
      if (_isEditMode) {
        await animalProvider.updateAnimal(animal);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)
                  .translate(AppStrings.animalUpdatedSuccess)),
              backgroundColor: AppConstants.successGreen,
            ),
          );
          Navigator.pop(context);
        }
        return; // Ne pas créer de mouvement en édition
      }

      // Mode création : ajouter l'animal
      animalProvider.addAnimal(animal);

      // 2. CrÃƒÂ©er le mouvement correspondant
      Movement? movement;

      if (_selectedOrigin ==
          AppLocalizations.of(context).translate(AppStrings.birth)) {
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
      } else if (_selectedOrigin ==
          AppLocalizations.of(context).translate(AppStrings.purchase)) {
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
        // Note: Les mouvements sont gÃƒÂ©rÃƒÂ©s via MovementProvider
        // Pour l'instant, on les ignore dans cet ÃƒÂ©cran simplifiÃƒÂ©
        // TODO: Ajouter la gestion des mouvements si nÃƒÂ©cessaire
      }

      // 3. IncrÃƒÂ©menter les donnÃƒÂ©es en attente de sync
      syncProvider.incrementPendingData();

      if (!mounted) return;

      // 4. Message de succÃƒÂ¨s
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)
              .translate(AppStrings.animalSavedSuccess)),
          backgroundColor: AppConstants.successGreen,
          duration: const Duration(seconds: 2),
        ),
      );

      // 5. Retour ÃƒÂ  l'ÃƒÂ©cran prÃƒÂ©cÃƒÂ©dent
      Navigator.pop(context, animal);
    } catch (e) {
      if (!mounted) return;

      _showError(
          AppLocalizations.of(context)
              .translate(AppStrings.errorOccurred)
              .replaceAll('{error}', e.toString()),
          isError: true);
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
        backgroundColor:
            isError ? AppConstants.statusDanger : AppConstants.warningOrange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final birthLabel = AppLocalizations.of(context).translate(AppStrings.birth);
    final purchaseLabel =
        AppLocalizations.of(context).translate(AppStrings.purchase);
    final otherLabel = AppLocalizations.of(context).translate(AppStrings.other);
    final validOrigin = _selectedOrigin.isEmpty ? null : _selectedOrigin;

    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context).translate(AppStrings.addAnimal)),
        backgroundColor: AppConstants.successGreen,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          children: [
            // 📋 BANNIÈRE DRAFT
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingSmall),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                border: Border.all(color: Colors.amber, width: AppConstants.spacingMicro),
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.amber.shade700),
                  const SizedBox(width: AppConstants.spacingExtraSmall),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)
                          .translate(AppStrings.draftModeBanner),
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: Colors.amber.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            _buildSectionHeader(AppLocalizations.of(context)
                .translate(AppStrings.identification)),
            const SizedBox(height: AppConstants.spacingMedium),

            // 1ï¸âƒ£ NUMÃ‰RO OFFICIEL EN PREMIER (avec scan)
            TextFormField(
              controller: _officialNumberController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)
                    .translate(AppStrings.officialNumber),
                hintText: 'FR-2024-123456',
                prefixIcon: const Icon(Icons.numbers),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  tooltip: AppLocalizations.of(context)
                      .translate(AppStrings.scanner),
                  onPressed: _simulateScan,
                ),
              ),
            ),

            const SizedBox(height: AppConstants.spacingMedium),

            // 2ï¸âƒ£ EID (avec scan)
            TextFormField(
              controller: _primaryIdController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)
                    .translate(AppStrings.eidElectronic),
                hintText: 'XX1234567890123',
                prefixIcon: const Icon(Icons.qr_code),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  tooltip: AppLocalizations.of(context)
                      .translate(AppStrings.scanner),
                  onPressed: _simulateScan,
                ),
                helperText: AppLocalizations.of(context)
                    .translate(AppStrings.atLeastOneIdRequired),
              ),
            ),

            const SizedBox(height: AppConstants.spacingMedium),

            // 3ï¸âƒ£ ID VISUEL (SANS scan)
            TextFormField(
              controller: _visualIdController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)
                    .translate(AppStrings.visualIdOptional),
                hintText: AppLocalizations.of(context)
                    .translate(AppStrings.exeIdVisuel),
                prefixIcon: const Icon(Icons.visibility),
                helperText: AppLocalizations.of(context)
                    .translate(AppStrings.toIdentifyEasily),
              ),
            ),

            const SizedBox(height: AppConstants.spacingMediumLarge),
            const SizedBox(height: AppConstants.spacingMediumLarge),

            // === Ãƒâ€°TAPE 5 : Section Type et Race ===
            _buildSectionHeader(AppLocalizations.of(context)
                .translate(AppStrings.typeAndBreed)),
            const SizedBox(height: AppConstants.spacingMedium),

            // Dropdown Type d'animal
            Consumer<SettingsProvider>(
              builder: (context, settingsProvider, child) {
                final locale = settingsProvider.locale;

                return DropdownButtonFormField<String>(
                  initialValue: _selectedSpeciesId,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)
                        .translate(AppStrings.animalType),
                    prefixIcon: Icon(
                      Icons.pets,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  items: AnimalConfig.availableSpecies.map((species) {
                    return DropdownMenuItem(
                      value: species.id,
                      child: Text('${species.icon} ${species.getName(locale)}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSpeciesId = value;
                      // RÃƒÂ©initialiser la race si on change de type
                      if (value != null) {
                        final breeds =
                            context.read<BreedProvider>().getBySpeciesId(value);
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
                      return AppLocalizations.of(context)
                          .translate(AppStrings.animalTypeRequired);
                    }
                    return null;
                  },
                );
              },
            ),

            const SizedBox(height: AppConstants.spacingMedium),

            // Dropdown Race
            Consumer2<BreedProvider, SettingsProvider>(
              builder: (context, breedProvider, settingsProvider, child) {
                // Filtrer les races selon le type sélectionné
                final availableBreeds = _selectedSpeciesId != null
                    ? breedProvider.getBySpeciesId(_selectedSpeciesId!)
                    : <Breed>[];

                final locale = settingsProvider.locale;

                return DropdownButtonFormField<String>(
                  initialValue: _selectedBreedId != null &&
                          availableBreeds.any((b) => b.id == _selectedBreedId)
                      ? _selectedBreedId
                      : null,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)
                        .translate(AppStrings.breedOptional),
                    prefixIcon: Icon(
                      Icons.category,
                      color: Theme.of(context).primaryColor,
                    ),
                    helperText: _selectedSpeciesId == null
                        ? AppLocalizations.of(context)
                            .translate(AppStrings.selectTypeFirst)
                        : null,
                  ),
                  items: availableBreeds.isEmpty
                      ? []
                      : availableBreeds.map((breed) {
                          return DropdownMenuItem(
                            value: breed.id,
                            child: Text(breed.getName(locale)),
                          );
                        }).toList(),
                  onChanged: _selectedSpeciesId == null
                      ? null
                      : (value) {
                          setState(() {
                            _selectedBreedId = value;
                          });
                        },
                );
              },
            ),

            const SizedBox(height: AppConstants.spacingMediumLarge),
            const SizedBox(height: AppConstants.spacingMediumLarge),

            // === Section : Origine ===
            _buildSectionHeader(AppLocalizations.of(context)
                .translate(AppStrings.origin)),
            const SizedBox(height: AppConstants.spacingMedium),

            // Origine
            // Initialiser à null si vide (pour éviter le doublon)
            DropdownButtonFormField<String>(
              initialValue: validOrigin,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)
                    .translate(AppStrings.originRequired),
                prefixIcon: const Icon(Icons.location_on),
              ),
              items: [
                DropdownMenuItem(
                  value: birthLabel,
                  child: Text(birthLabel),
                ),
                DropdownMenuItem(
                  value: purchaseLabel,
                  child: Text(purchaseLabel),
                ),
                DropdownMenuItem(
                  value: otherLabel,
                  child: Text(otherLabel),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedOrigin = value ?? '';
                  // Réinitialiser les champs conditionnels
                  _selectedMotherId = null;
                  _selectedMotherDisplay = null;
                  _provenanceController.clear();
                  _priceController.clear();
                });
              },
            ),

            const SizedBox(height: AppConstants.spacingMedium),

            // Date de naissance
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.cake),
              title: Text(
                  AppLocalizations.of(context).translate(AppStrings.birthDate)),
              subtitle: Text(
                _selectedBirthDate != null
                    ? _formatDate(_selectedBirthDate!)
                    : AppLocalizations.of(context)
                        .translate(AppStrings.notDefined),
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
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),

            const SizedBox(height: AppConstants.spacingMediumLarge),

            // === Section : CaractÃƒÂ©ristiques ===
            _buildSectionHeader(AppLocalizations.of(context)
                .translate(AppStrings.characteristics)),
            const SizedBox(height: AppConstants.spacingMedium),

            // Sexe
            Text(
              AppLocalizations.of(context).translate(AppStrings.sexRequired),
              style: const TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppConstants.spacingExtraSmall),
            RadioGroup<AnimalSex>(
              groupValue: _selectedSex,
              onChanged: (value) {
                setState(() {
                  _selectedSex = value;
                });
              },
              child: Row(
                children: [
                  Expanded(
                    child: RadioListTile<AnimalSex>(
                      title: Text(AppLocalizations.of(context)
                          .translate(AppStrings.male)),
                      value: AnimalSex.male,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        side: BorderSide(
                          color: _selectedSex == AnimalSex.male
                              ? Colors.blue
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingSmall),
                  Expanded(
                    child: RadioListTile<AnimalSex>(
                      title: Text(AppLocalizations.of(context)
                          .translate(AppStrings.female)),
                      value: AnimalSex.female,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
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
            ),

            const SizedBox(height: AppConstants.spacingMedium),

            // Origine
            DropdownButtonFormField<String>(
              initialValue: _selectedOrigin,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)
                    .translate(AppStrings.originRequired),
                prefixIcon: const Icon(Icons.location_on),
              ),
              items: [
                DropdownMenuItem(
                  value:
                      AppLocalizations.of(context).translate(AppStrings.birth),
                  child: Text(
                      AppLocalizations.of(context).translate(AppStrings.birth)),
                ),
                DropdownMenuItem(
                  value: AppLocalizations.of(context)
                      .translate(AppStrings.purchase),
                  child: Text(AppLocalizations.of(context)
                      .translate(AppStrings.purchase)),
                ),
                DropdownMenuItem(
                  value:
                      AppLocalizations.of(context).translate(AppStrings.other),
                  child: Text(
                      AppLocalizations.of(context).translate(AppStrings.other)),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedOrigin = value!;
                  // RÃƒÂ©initialiser les champs conditionnels
                  _selectedMotherId = null;
                  _selectedMotherDisplay = null;
                  _provenanceController.clear();
                  _priceController.clear();
                });
              },
            ),

            const SizedBox(height: AppConstants.spacingMedium),

            // Champs conditionnels selon l'origine
            if (_selectedOrigin ==
                AppLocalizations.of(context).translate(AppStrings.birth)) ...[
              // MÃƒÂ¨re
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.family_restroom),
                title: Text(AppLocalizations.of(context)
                    .translate(AppStrings.motherOptional)),
                subtitle: Text(
                  _selectedMotherDisplay ??
                      AppLocalizations.of(context)
                          .translate(AppStrings.notDefined),
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
                        tooltip: AppLocalizations.of(context)
                            .translate(AppStrings.remove),
                        onPressed: () {
                          setState(() {
                            _selectedMotherId = null;
                            _selectedMotherDisplay = null;
                          });
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.qr_code_scanner),
                      tooltip: AppLocalizations.of(context)
                          .translate(AppStrings.scanner),
                      onPressed: _scanMother,
                    ),
                  ],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ],

            if (_selectedOrigin ==
                AppLocalizations.of(context)
                    .translate(AppStrings.purchase)) ...[
              // Provenance
              TextFormField(
                controller: _provenanceController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)
                      .translate(AppStrings.provenance),
                  hintText: AppLocalizations.of(context)
                      .translate(AppStrings.farmOrBreederName),
                  prefixIcon: const Icon(Icons.place),
                ),
              ),

              const SizedBox(height: AppConstants.spacingMedium),

              // Prix d'achat
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)
                      .translate(AppStrings.purchasePrice),
                  hintText: '0.00',
                  prefixIcon: const Icon(Icons.euro),
                  suffixText: 'Ã¢â€šÂ¬',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),
            ],

            const SizedBox(height: AppConstants.spacingMediumLarge),

            // Notes
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)
                    .translate(AppStrings.notesOptional),
                hintText: AppLocalizations.of(context)
                    .translate(AppStrings.observationsRemarks),
                prefixIcon: const Icon(Icons.note),
              ),
              maxLines: 3,
              maxLength: AppConstants.maxNotesLength,
            ),

            const SizedBox(height: AppConstants.spacingLarge),

            // Boutons d'action
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: Text(AppLocalizations.of(context)
                        .translate(AppStrings.cancel)),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMedium),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveAnimal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.successGreen,
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
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.save, size: AppConstants.iconSizeRegular),
                              const SizedBox(width: AppConstants.spacingExtraSmall),
                              Text(AppLocalizations.of(context)
                                  .translate(AppStrings.save)),
                            ],
                          ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.spacingLarge),
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
        fontSize: AppConstants.fontSizeImportant,
        fontWeight: FontWeight.bold,
        color: AppConstants.successGreen,
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

/// Widget de dialogue pour scanner la mÃƒÂ¨re
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

  /// Simuler le scan d'une mÃƒÂ¨re
  void _simulateScan() {
    setState(() {
      _isScanning = true;
      _errorMessage = null;
      _scannedMother = null;
    });

    // Simulation d'un dÃƒÂ©lai de scan
    Future.delayed(AppConstants.longAnimation, () {
      final animalProvider = context.read<AnimalProvider>();

      // Chercher une femelle dans le troupeau
      final females = animalProvider.animals
          .where((a) =>
              a.sex == AnimalSex.female && a.status == AnimalStatus.alive)
          .toList();

      if (females.isEmpty) {
        setState(() {
          _isScanning = false;
          _errorMessage = AppLocalizations.of(context)
              .translate(AppStrings.noFemaleAvailable);
        });
        return;
      }

      // Prendre une femelle alÃƒÂ©atoirement pour simuler
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
      title: Row(
        children: [
          const Icon(Icons.qr_code_scanner, color: AppConstants.successGreen),
          const SizedBox(width: AppConstants.spacingExtraSmall),
          Text(AppLocalizations.of(context).translate(AppStrings.scanMother)),
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
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)
                    .translate(AppStrings.eidOfMother),
                hintText: 'FRxxxxxxxxxxxx',
                prefixIcon: const Icon(Icons.tag),
                border: const OutlineInputBorder(),
              ),
              enabled: !_isScanning,
              readOnly: true,
            ),

            const SizedBox(height: AppConstants.spacingMedium),

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
              label: Text(_isScanning
                  ? AppLocalizations.of(context)
                      .translate(AppStrings.scanningInProgress)
                  : AppLocalizations.of(context).translate(AppStrings.scanner)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.successGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingSmall),
              ),
            ),

            // Message d'erreur
            if (_errorMessage != null) ...[
              const SizedBox(height: AppConstants.spacingSmall),
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingSmall),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning,
                        color: Colors.orange.shade700, size: AppConstants.iconSizeRegular),
                    const SizedBox(width: AppConstants.spacingExtraSmall),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.orange.shade900,
                          fontSize: AppConstants.fontSizeSubtitle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Informations de la mÃƒÂ¨re scannÃƒÂ©e
            if (_scannedMother != null) ...[
              const SizedBox(height: AppConstants.spacingMedium),
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingSmall),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: Colors.green.shade700, size: AppConstants.iconSizeRegular),
                        const SizedBox(width: AppConstants.spacingExtraSmall),
                        Text(
                          AppLocalizations.of(context)
                              .translate(AppStrings.motherDetected),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppConstants.fontSizeBody,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingExtraSmall),
                    if (_scannedMother!.eid != null)
                      Text(
                        'EID: ${_scannedMother!.eid}',
                        style: const TextStyle(fontSize: AppConstants.fontSizeSubtitle),
                      ),
                    if (_scannedMother!.officialNumber != null)
                      Text(
                        '${AppLocalizations.of(context).translate(AppStrings.officialNumber)}: ${_scannedMother!.officialNumber}',
                        style: const TextStyle(fontSize: AppConstants.fontSizeSubtitle),
                      ),
                    if (_scannedMother!.visualId != null)
                      Text(
                        '${AppLocalizations.of(context).translate(AppStrings.visualId)}: ${_scannedMother!.visualId}',
                        style: const TextStyle(fontSize: AppConstants.fontSizeSubtitle),
                      ),
                    Text(
                      '${AppLocalizations.of(context).translate(AppStrings.age)}: ${_scannedMother!.ageInMonths} ${AppLocalizations.of(context).translate(AppStrings.months)}',
                      style: const TextStyle(fontSize: AppConstants.fontSizeSubtitle),
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
          child:
              Text(AppLocalizations.of(context).translate(AppStrings.cancel)),
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
                        AppLocalizations.of(context)
                            .translate(AppStrings.motherAdded)
                            .replaceAll(
                                '{name}',
                                _scannedMother!.officialNumber ??
                                    _scannedMother!.eid ??
                                    _scannedMother!.visualId ??
                                    'Animal ${_scannedMother!.id.substring(0, 8)}'),
                      ),
                      backgroundColor: AppConstants.successGreen,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.successGreen,
            foregroundColor: Colors.white,
          ),
          child: Text(AppLocalizations.of(context).translate(AppStrings.add)),
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

    // Simulation d'un dÃƒÂ©lai de scan
    Future.delayed(const Duration(milliseconds: 800), () {
      // GÃƒÂ©nÃƒÂ©ration d'un EID simulÃƒÂ© au format FR + 13 chiffres
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
      title: Row(
        children: [
          const Icon(Icons.qr_code_scanner, color: Colors.blue),
          const SizedBox(width: AppConstants.spacingExtraSmall),
          Text(AppLocalizations.of(context).translate(AppStrings.scanAnimal)),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context).translate(AppStrings.placeRfidNear),
              style: const TextStyle(
                fontSize: AppConstants.fontSizeSubtitle,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: AppConstants.spacingMedium),

            // Champ EID
            TextField(
              controller: _eidController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)
                    .translate(AppStrings.eidDetected),
                hintText: 'XX1234567890123',
                prefixIcon: const Icon(Icons.tag),
                border: const OutlineInputBorder(),
              ),
              enabled: !_isScanning,
              readOnly: true,
            ),

            const SizedBox(height: AppConstants.spacingMedium),

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
              label: Text(_isScanning
                  ? AppLocalizations.of(context)
                      .translate(AppStrings.scanningInProgress)
                  : AppLocalizations.of(context).translate(AppStrings.scanner)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingSmall),
              ),
            ),

            // RÃƒÂ©sultat du scan
            if (_scannedEID != null) ...[
              const SizedBox(height: AppConstants.spacingMedium),
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingSmall),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: Colors.green.shade700, size: AppConstants.iconSizeRegular),
                        const SizedBox(width: AppConstants.spacingExtraSmall),
                        Text(
                          AppLocalizations.of(context)
                              .translate(AppStrings.eidDetectedSuccess),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppConstants.fontSizeBody,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingExtraSmall),
                    Text(
                      _scannedEID!,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'monospace',
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingTiny),
                    Text(
                      _formatEID(_scannedEID!),
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeSubtitle,
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
          child:
              Text(AppLocalizations.of(context).translate(AppStrings.cancel)),
        ),
        ElevatedButton(
          onPressed: _scannedEID == null
              ? null
              : () {
                  widget.onEIDScanned(_scannedEID!);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)
                          .translate(AppStrings.eidScanned)
                          .replaceAll('{eid}', _scannedEID!)),
                      backgroundColor: AppConstants.successGreen,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: Text(AppLocalizations.of(context).translate(AppStrings.add)),
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
