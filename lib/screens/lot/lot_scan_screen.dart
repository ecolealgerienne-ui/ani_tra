// lib/screens/lot_scan_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../../providers/lot_provider.dart';
import '../../providers/animal_provider.dart';
import '../../models/animal.dart';
import '../../i18n/app_localizations.dart';

class LotScanScreen extends StatefulWidget {
  final String lotId;

  const LotScanScreen({
    super.key,
    required this.lotId,
  });

  @override
  State<LotScanScreen> createState() => _LotScanScreenState();
}

class _LotScanScreenState extends State<LotScanScreen> {
  bool _isScanning = false;
  String? _lastScanResult;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    // Définir le lot comme actif
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lotProvider = context.read<LotProvider>();
      final lot = lotProvider.getLotById(widget.lotId);
      if (lot != null) {
        lotProvider.setActiveLot(lot);
      }
    });
  }

  Future<void> _simulateScan() async {
    final lotProvider = context.read<LotProvider>();
    final animalProvider = context.read<AnimalProvider>();

    final lot = lotProvider.getLotById(widget.lotId);
    if (lot == null || lot.completed) return;

    setState(() {
      _isScanning = true;
      _lastScanResult = null;
    });

    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final animals = animalProvider.animals;

      if (animals.isEmpty) {
        if (!mounted) return;
        setState(() {
          _lastScanResult = 'error';
          _isScanning = false;
        });
        return;
      }

      // Sélectionner un animal aléatoire
      final animal = animals[_random.nextInt(animals.length)];

      // Vérifier si déjà scanné
      final isDuplicate = lotProvider.isAnimalInActiveLot(animal.id);

      if (isDuplicate) {
        // Doublon
        HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 100));
        HapticFeedback.heavyImpact();

        setState(() {
          _lastScanResult = 'duplicate';
          _isScanning = false;
        });
      } else {
        // Succès
        lotProvider.addAnimalToActiveLot(animal.id);
        HapticFeedback.heavyImpact();

        setState(() {
          _lastScanResult = 'success';
          _isScanning = false;
        });
      }
    } catch (e) {
      setState(() {
        _lastScanResult = 'error';
        _isScanning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lotProvider = context.watch<LotProvider>();
    final animalProvider = context.watch<AnimalProvider>();
    final lot = lotProvider.getLotById(widget.lotId);
    final l10n = AppLocalizations.of(context);

    if (lot == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Erreur')),
        body: const Center(child: Text('Lot introuvable')),
      );
    }

    if (lot.completed) {
      return Scaffold(
        appBar: AppBar(title: Text(lot.name)),
        body: const Center(child: Text('Le lot est terminé')),
      );
    }

    // Récupérer les animaux
    final animals = <Animal>[];
    for (final animalId in lot.animalIds) {
      final animal = animalProvider.getAnimalById(animalId);
      if (animal != null) animals.add(animal);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(lot.name),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${lot.animalCount} animaux',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Bouton Scanner
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              height: 200,
              child: ElevatedButton(
                onPressed: _isScanning ? null : _simulateScan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: _isScanning
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 16),
                          Text(
                            'Scan en cours...',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.nfc, size: 80),
                          const SizedBox(height: 16),
                          Text(
                            l10n.translate('scan_animal'),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),

          // Feedback du scan
          if (_lastScanResult != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getScanResultColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getScanResultColor(),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getScanResultIcon(),
                      color: _getScanResultColor(),
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _getScanResultMessage(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _getScanResultColor(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 24),

          // Liste des animaux scannés
          Expanded(
            child: animals.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.pets_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun animal scanné',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Appuyez sur le bouton pour scanner',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Animaux scannés (${animals.length})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: animals.length,
                          itemBuilder: (context, index) {
                            final animal = animals[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: animal.sex == AnimalSex.male
                                      ? Colors.blue.withValues(alpha: 0.2)
                                      : Colors.pink.withValues(alpha: 0.2),
                                  child: Icon(
                                    animal.sex == AnimalSex.male
                                        ? Icons.male
                                        : Icons.female,
                                    color: animal.sex == AnimalSex.male
                                        ? Colors.blue
                                        : Colors.pink,
                                  ),
                                ),
                                title: Text(animal.displayName),
                                subtitle: Text(animal.displayName),
                                trailing: IconButton(
                                  icon: const Icon(Icons.remove_circle,
                                      color: Colors.red),
                                  onPressed: () {
                                    lotProvider
                                        .removeAnimalFromActiveLot(animal.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Animal retiré'),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
      bottomNavigationBar: animals.isNotEmpty
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Terminer le scan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Color _getScanResultColor() {
    switch (_lastScanResult) {
      case 'success':
        return Colors.green;
      case 'duplicate':
        return Colors.orange;
      case 'error':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getScanResultIcon() {
    switch (_lastScanResult) {
      case 'success':
        return Icons.check_circle;
      case 'duplicate':
        return Icons.warning;
      case 'error':
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  String _getScanResultMessage() {
    switch (_lastScanResult) {
      case 'success':
        return 'Animal ajouté !';
      case 'duplicate':
        return 'Déjà scanné !';
      case 'error':
        return 'Erreur de scan';
      default:
        return '';
    }
  }
}
