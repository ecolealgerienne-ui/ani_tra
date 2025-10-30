// screens/batch_scan_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../models/batch.dart';
import '../models/animal.dart';
import '../providers/batch_provider.dart';
import '../providers/animal_provider.dart';
import '../providers/sync_provider.dart';
import 'batch_list_screen.dart';

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
    await Future.delayed(const Duration(milliseconds: 300));

    // Obtenir un animal aléatoire de la liste
    final animals = animalProvider.animals;

    if (animals.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Aucun animal disponible dans le troupeau'),
          backgroundColor: Colors.orange,
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

      if (success) {
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
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '⚠️ ${animal.officialNumber ?? animal.eid} déjà scanné',
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
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
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '✅ ${animal.officialNumber ?? animal.eid} ajouté',
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  /// Retirer un animal du lot
  void _removeAnimal(String animalId) {
    final batchProvider = context.read<BatchProvider>();
    final success = batchProvider.removeAnimalFromBatch(animalId);

    if (success) {
      _loadScannedAnimals();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Animal retiré du lot'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  /// Sauvegarder le lot et naviguer vers la liste
  Future<void> _saveBatch() async {
    if (_scannedCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Le lot est vide. Scannez au moins un animal.'),
          backgroundColor: Colors.orange,
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
          '✅ Lot "${widget.batch.name}" sauvegardé ($_scannedCount animaux)',
        ),
        backgroundColor: Colors.green,
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
        title: const Text('Annuler le lot ?'),
        content: Text(
          _scannedCount > 0
              ? 'Le lot contient $_scannedCount animal(aux). '
                  'Voulez-vous vraiment annuler ?'
              : 'Voulez-vous annuler la création du lot ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Non'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Oui, annuler'),
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
    return WillPopScope(
      onWillPop: () async {
        await _cancel();
        return false;
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
              padding: const EdgeInsets.all(24),
              color: Colors.deepPurple.shade50,
              child: Column(
                children: [
                  // Icône + Compteur
                  Container(
                    width: 100,
                    height: 100,
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
                          size: 32,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$_scannedCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _scannedCount == 0
                        ? 'Aucun animal scanné'
                        : '$_scannedCount animal${_scannedCount > 1 ? 'aux' : ''} scanné${_scannedCount > 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 16,
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
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _simulateScan,
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Scanner un animal'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Scannez les animaux un par un',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Liste des animaux scannés
            if (_scannedAnimals.isNotEmpty)
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
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
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Animaux scannés',
                        style: TextStyle(
                          fontSize: 14,
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
                              backgroundColor: Colors.green.shade100,
                              child: Icon(
                                animal.sex == AnimalSex.male
                                    ? Icons.male
                                    : Icons.female,
                                color: animal.sex == AnimalSex.male
                                    ? Colors.blue
                                    : Colors.pink,
                                size: 18,
                              ),
                            ),
                            title: Text(
                              animal.officialNumber ?? animal.eid,
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.close, size: 18),
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _cancel,
                      child: const Text('Annuler'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _saveBatch,
                      icon: const Icon(Icons.save),
                      label: const Text('Sauvegarder'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
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
