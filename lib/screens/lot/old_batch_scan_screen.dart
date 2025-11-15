// screens/batch_scan_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../../models/batch.dart';
import '../../models/animal.dart';
import '../../providers/batch_provider.dart';
import '../../providers/animal_provider.dart';
import '../../providers/sync_provider.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';
import 'old_batch_list_screen.dart';

/// Écran de scan d'animaux pour un lot
///
/// Permet de scanner plusieurs animaux et les ajouter au lot
/// Détecte les doublons et fournit un feedback immédiat
class BatchScanScreen extends StatefulWidget {
  final Batch batch;

  const BatchScanScreen({
    super.key,
    required this.batch,
  });

  @override
  State<BatchScanScreen> createState() => _BatchScanScreenState();
}

class _BatchScanScreenState extends State<BatchScanScreen> {
  int _scannedCount = 0;
  List<Animal> _scannedAnimals = [];
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _loadScannedAnimals();
  }

  /// Charger les animaux déjà scannés
  void _loadScannedAnimals() {
    final animalProvider = context.read<AnimalProvider>();
    final batchProvider = context.read<BatchProvider>();

    final batch = batchProvider.getBatchById(widget.batch.id);
    if (batch == null) return;

    final animals = <Animal>[];
    for (final animalId in batch.animalIds) {
      final animal = animalProvider.getAnimalById(animalId);
      if (animal != null) {
        animals.add(animal);
      }
    }

    setState(() {
      _scannedAnimals = animals;
      _scannedCount = animals.length;
    });
  }

  /// Simuler le scan d'un animal
  Future<void> _simulateScan() async {
    final animalProvider = context.read<AnimalProvider>();
    final batchProvider = context.read<BatchProvider>();

    // Simuler un délai de scan
    await Future.delayed(
        const Duration(milliseconds: AppConstants.batchScanDelay));

    // Obtenir un animal aléatoire de la liste
    final animals = animalProvider.animals;

    if (animals.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)
              .translate(AppStrings.noAnimalsAvailableBatch)),
          backgroundColor: AppConstants.statusWarning,
        ),
      );
      return;
    }

    // Sélectionner un animal aléatoire
    final animal = animals[_random.nextInt(animals.length)];

    // Vérifier doublon
    final isDuplicate = batchProvider.isAnimalInActiveBatch(animal.id);

    if (isDuplicate) {
      // Doublon détecté
      _showDuplicateFeedback(animal);
    } else {
      // Nouvel animal
      final success = batchProvider.addAnimalToBatch(animal.id);

      if (await success) {
        _showSuccessFeedback(animal);
        _loadScannedAnimals();
      }
    }
  }

  /// Feedback visuel/sonore pour doublon
  void _showDuplicateFeedback(Animal animal) {
    // TODO: Ajouter son d'erreur (bip-bip-bip)
    // TODO: Ajouter vibration pattern [0, 100, 100, 100]

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white),
            const SizedBox(width: AppConstants.batchScanFeedbackSpacing),
            Expanded(
              child: Text(
                AppLocalizations.of(context)
                    .translate(AppStrings.animalDuplicate)
                    .replaceFirst('{}', animal.displayName),
              ),
            ),
          ],
        ),
        backgroundColor: AppConstants.statusWarning,
        duration:
            const Duration(seconds: AppConstants.batchScanDuplicateDuration),
      ),
    );
  }

  /// Feedback visuel/sonore pour succès
  void _showSuccessFeedback(Animal animal) {
    // TODO: Ajouter son de succès (bip simple)
    // TODO: Ajouter vibration courte (200ms)

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: AppConstants.batchScanFeedbackSpacing),
            Expanded(
              child: Text(
                AppLocalizations.of(context)
                    .translate(AppStrings.animalAdded)
                    .replaceAll('{name}', animal.displayName),
              ),
            ),
          ],
        ),
        backgroundColor: AppConstants.statusSuccess,
        duration:
            const Duration(seconds: AppConstants.batchScanSuccessDuration),
      ),
    );
  }

  /// Retirer un animal du lot
  Future<void> _removeAnimal(String animalId) async {
    final batchProvider = context.read<BatchProvider>();
    final success = await batchProvider.removeAnimalFromBatch(animalId);

    if (!mounted) return;

    if (success) {
      _loadScannedAnimals();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context).translate(AppStrings.animalRemoved)),
          duration:
              const Duration(seconds: AppConstants.batchScanSuccessDuration),
        ),
      );
    }
  }

  /// Sauvegarder le lot et naviguer vers la liste
  Future<void> _saveBatch() async {
    if (_scannedCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context).translate(AppStrings.batchEmpty)),
          backgroundColor: AppConstants.statusWarning,
        ),
      );
      return;
    }

    final batchProvider = context.read<BatchProvider>();
    final syncProvider = context.read<SyncProvider>();

    // Compléter le lot
    batchProvider.completeBatch(widget.batch.id);
    batchProvider.clearActiveBatch();

    // Incrémenter données en attente
    syncProvider.incrementPendingData();

    if (!mounted) return;

    // Feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)
              .translate(AppStrings.batchSaved)
              .replaceAll('{name}', widget.batch.name)
              .replaceAll('{count}', '$_scannedCount'),
        ),
        backgroundColor: AppConstants.statusSuccess,
      ),
    );

    // Naviguer vers la liste des lots
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const BatchListScreen(),
      ),
    );
  }

  /// Annuler et retourner
  Future<void> _cancel() async {
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)
            .translate(AppStrings.cancelBatchTitle)),
        content: Text(
          _scannedCount > 0
              ? AppLocalizations.of(context)
                  .translate(AppStrings.cancelBatchMessage)
                  .replaceAll('{count}', '$_scannedCount')
              : AppLocalizations.of(context)
                  .translate(AppStrings.cancelBatchEmpty),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)
                .translate(AppStrings.continueScanning)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppConstants.statusDanger,
            ),
            child: Text(
                AppLocalizations.of(context).translate(AppStrings.cancelBatch)),
          ),
        ],
      ),
    );

    if (shouldCancel == true) {
      final batchProvider = context.read<BatchProvider>();

      // Supprimer le lot
      batchProvider.deleteBatch(widget.batch.id);
      batchProvider.clearActiveBatch();

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (!didPop) {
          await _cancel();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.batch.name),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _cancel,
          ),
        ),
        body: Column(
          children: [
            // Header avec compteur
            Container(
              padding:
                  const EdgeInsets.all(AppConstants.batchScanHeaderPadding),
              color: Colors.deepPurple.shade50,
              child: Column(
                children: [
                  // Icône + Compteur
                  Container(
                    width: AppConstants.batchScanCounterSize,
                    height: AppConstants.batchScanCounterSize,
                    decoration: const BoxDecoration(
                      color: Colors.deepPurple,
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.inventory,
                          color: Colors.white,
                          size: AppConstants.batchScanCounterIconSize,
                        ),
                        const SizedBox(
                            height: AppConstants.batchScanCounterSpacing),
                        Text(
                          '$_scannedCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: AppConstants.batchScanCounterTextSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.batchScanHeaderSpacing),
                  Text(
                    _scannedCount == 0
                        ? AppLocalizations.of(context)
                            .translate(AppStrings.noAnimalScanned)
                        : AppLocalizations.of(context)
                            .translate(AppStrings.animalsScannedCount)
                            .replaceAll('{count}', '$_scannedCount')
                            .replaceAll(
                                '{plural}', _scannedCount > 1 ? 'aux' : '')
                            .replaceAll('{pluralScanned}',
                                _scannedCount > 1 ? 's' : ''),
                    style: TextStyle(
                      fontSize: AppConstants.batchScanHeaderTextSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),

            // Zone de scan
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      size: AppConstants.batchScanZoneIconSize,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: AppConstants.batchScanZoneSpacing),
                    ElevatedButton.icon(
                      onPressed: _simulateScan,
                      icon: const Icon(Icons.qr_code_scanner),
                      label: Text(AppLocalizations.of(context)
                          .translate(AppStrings.scanOneAnimal)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.batchScanButtonPaddingH,
                          vertical: AppConstants.batchScanButtonPaddingV,
                        ),
                      ),
                    ),
                    const SizedBox(
                        height: AppConstants.batchScanZoneSpacingSmall),
                    Text(
                      AppLocalizations.of(context)
                          .translate(AppStrings.scanAnimalsOneByOne),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: AppConstants.batchScanZoneHintSize,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Liste des animaux scannés
            if (_scannedAnimals.isNotEmpty)
              Container(
                constraints: const BoxConstraints(
                    maxHeight: AppConstants.batchScanListMaxHeight),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(
                          AppConstants.batchScanListPadding),
                      child: Text(
                        AppLocalizations.of(context)
                            .translate(AppStrings.scannedAnimals),
                        style: TextStyle(
                          fontSize: AppConstants.batchScanListTitleSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _scannedAnimals.length,
                        itemBuilder: (context, index) {
                          final animal = _scannedAnimals[index];
                          return ListTile(
                            dense: true,
                            leading: CircleAvatar(
                              backgroundColor: AppConstants.statusSuccess
                                  .withValues(alpha: 0.1),
                              child: Icon(
                                animal.sex == AnimalSex.male
                                    ? Icons.male
                                    : Icons.female,
                                color: animal.sex == AnimalSex.male
                                    ? AppConstants.statusInfo
                                    : Colors.pink,
                                size: AppConstants.batchScanListIconSize,
                              ),
                            ),
                            title: Text(
                              animal.displayName,
                              style: const TextStyle(
                                  fontSize: AppConstants.batchScanListTextSize),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.close,
                                  size: AppConstants.batchScanListIconSize),
                              onPressed: () => _removeAnimal(animal.id),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

            // Boutons d'action
            Container(
              padding:
                  const EdgeInsets.all(AppConstants.batchScanActionPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                        alpha: AppConstants.batchScanActionShadowAlpha),
                    blurRadius: AppConstants.batchScanActionShadowBlur,
                    offset: const Offset(
                        0, AppConstants.batchScanActionShadowOffset),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _cancel,
                      child: Text(AppLocalizations.of(context)
                          .translate(AppStrings.cancel)),
                    ),
                  ),
                  const SizedBox(width: AppConstants.batchScanActionSpacing),
                  Expanded(
                    flex: AppConstants.batchScanSaveButtonFlex,
                    child: ElevatedButton.icon(
                      onPressed: _saveBatch,
                      icon: const Icon(Icons.save),
                      label: Text(AppLocalizations.of(context)
                          .translate(AppStrings.save)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.statusSuccess,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
