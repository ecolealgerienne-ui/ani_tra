// lib/screens/birth_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../../providers/animal_provider.dart';
import '../../providers/sync_provider.dart';
import '../../models/animal.dart';
import '../../models/movement.dart';
import '../../i18n/app_localizations.dart';

class BirthScreen extends StatefulWidget {
  const BirthScreen({super.key});

  @override
  State<BirthScreen> createState() => _BirthScreenState();
}

class _BirthScreenState extends State<BirthScreen> {
  Animal? _scannedLamb;
  Animal? _scannedMother;
  bool _isScanning = false;
  String _scanStep = 'lamb'; // 'lamb' or 'mother'
  final _random = Random();

  Future<void> _simulateScan() async {
    setState(() => _isScanning = true);

    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 500));

    final animalProvider = context.read<AnimalProvider>();

    try {
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
        setState(() => _isScanning = false);
        return;
      }

      // Sélectionner un animal aléatoire
      final animal = animals[_random.nextInt(animals.length)];

      if (_scanStep == 'lamb') {
        setState(() {
          _scannedLamb = animal;
          _scanStep = 'mother';
          _isScanning = false;
        });
      } else {
        // Validate mother is female
        if (animal.sex != AnimalSex.female) {
          HapticFeedback.heavyImpact();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Erreur: La mère doit être une femelle'),
                backgroundColor: Colors.red,
              ),
            );
          }
          setState(() => _isScanning = false);
          return;
        }

        setState(() {
          _scannedMother = animal;
          _isScanning = false;
        });
      }

      HapticFeedback.heavyImpact();
    } catch (e) {
      setState(() => _isScanning = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  void _confirmBirth() {
    if (_scannedLamb == null || _scannedMother == null) return;

    final animalProvider = context.read<AnimalProvider>();
    final syncProvider = context.read<SyncProvider>();

    // Update lamb with mother ID
    final updatedLamb = _scannedLamb!.copyWith(motherId: _scannedMother!.id);
    animalProvider.updateAnimal(updatedLamb);

    // Add movement
    final movement = Movement(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      animalId: updatedLamb.id,
      type: MovementType.birth,
      movementDate: updatedLamb.birthDate,
      notes: 'Mère: ${_scannedMother!.officialNumber ?? _scannedMother!.eid}',
      synced: false,
      createdAt: DateTime.now(),
    );

    animalProvider.addMovement(movement);
    syncProvider.incrementPendingData();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Naissance enregistrée avec succès'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  void _reset() {
    setState(() {
      _scannedLamb = null;
      _scannedMother = null;
      _scanStep = 'lamb';
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('record_birth')),
        actions: [
          if (_scannedLamb != null || _scannedMother != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _reset,
              tooltip: 'Recommencer',
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress Indicator
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            child: Row(
              children: [
                _StepIndicator(
                  number: 1,
                  label: l10n.translate('scan_lamb'),
                  isActive: _scanStep == 'lamb',
                  isCompleted: _scannedLamb != null,
                ),
                Expanded(
                  child: Container(
                    height: 2,
                    color: _scannedLamb != null
                        ? Colors.green
                        : Colors.grey.shade300,
                  ),
                ),
                _StepIndicator(
                  number: 2,
                  label: l10n.translate('scan_mother'),
                  isActive: _scanStep == 'mother',
                  isCompleted: _scannedMother != null,
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Lamb Card
                _AnimalCard(
                  title: l10n.translate('lamb_eid'),
                  animal: _scannedLamb,
                  icon: Icons.child_care,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),

                // Mother Card
                _AnimalCard(
                  title: l10n.translate('mother_eid'),
                  animal: _scannedMother,
                  icon: Icons.family_restroom,
                  color: Colors.pink,
                ),
                const SizedBox(height: 24),

                // Scan Button
                if (_scannedMother == null)
                  SizedBox(
                    height: 120,
                    child: ElevatedButton(
                      onPressed: _isScanning ? null : _simulateScan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: _isScanning
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.nfc, size: 48),
                                const SizedBox(height: 8),
                                Text(
                                  _scanStep == 'lamb'
                                      ? l10n.translate('scan_lamb')
                                      : l10n.translate('scan_mother'),
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                    ),
                  ),

                // Confirm Button
                if (_scannedLamb != null && _scannedMother != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green.shade700,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Lien généalogique établi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Agneau → ${_scannedLamb!.officialNumber ?? "N/A"}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Mère → ${_scannedMother!.officialNumber ?? "N/A"}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _confirmBirth,
                      icon: const Icon(Icons.save),
                      label: Text(l10n.translate('confirm_birth')),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int number;
  final String label;
  final bool isActive;
  final bool isCompleted;

  const _StepIndicator({
    required this.number,
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: isCompleted
              ? Colors.green
              : isActive
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade300,
          child: isCompleted
              ? const Icon(Icons.check, color: Colors.white)
              : Text(
                  number.toString(),
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color:
                isActive ? Theme.of(context).colorScheme.primary : Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _AnimalCard extends StatelessWidget {
  final String title;
  final Animal? animal;
  final IconData icon;
  final Color color;

  const _AnimalCard({
    required this.title,
    required this.animal,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (animal != null) ...[
              _InfoRow(
                label: 'N° Officiel',
                value: animal!.officialNumber ?? 'N/A',
              ),
              _InfoRow(
                label: 'EID',
                value: animal!.eid,
              ),
              _InfoRow(
                label: 'Sexe',
                value: animal!.sex == AnimalSex.female ? 'Femelle' : 'Mâle',
              ),
              _InfoRow(
                label: 'Naissance',
                value: dateFormat.format(animal!.birthDate),
              ),
            ] else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'En attente de scan...',
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
