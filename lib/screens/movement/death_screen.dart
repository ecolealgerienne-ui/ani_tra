// lib/screens/death_screen.dart
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

class DeathScreen extends StatefulWidget {
  const DeathScreen({super.key});

  @override
  State<DeathScreen> createState() => _DeathScreenState();
}

class _DeathScreenState extends State<DeathScreen> {
  Animal? _scannedAnimal;
  final _notesController = TextEditingController();
  DateTime _deathDate = DateTime.now();
  bool _isScanning = false;
  final _random = Random();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _simulateScan() async {
    setState(() => _isScanning = true);

    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 500));

    final animalProvider = context.read<AnimalProvider>();

    try {
      // Obtenir la liste des animaux vivants (non décédés)
      final animals = animalProvider.animals
          .where((a) => a.status != AnimalStatus.dead)
          .toList();

      if (animals.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aucun animal disponible à scanner'),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() => _isScanning = false);
        return;
      }

      // Sélectionner un animal aléatoire
      final animal = animals[_random.nextInt(animals.length)];

      setState(() {
        _scannedAnimal = animal;
        _isScanning = false;
      });

      HapticFeedback.heavyImpact();
    } catch (e) {
      setState(() => _isScanning = false);
    }
  }

  void _confirmDeath() {
    if (_scannedAnimal == null) return;

    final animalProvider = context.read<AnimalProvider>();
    final syncProvider = context.read<SyncProvider>();

    // Create death movement
    final movement = Movement(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      animalId: _scannedAnimal!.id,
      type: MovementType.death,
      movementDate: _deathDate,
      notes: _notesController.text.isEmpty
          ? 'Cause non spécifiée'
          : _notesController.text,
      createdAt: DateTime.now(),
    );

    animalProvider.addMovement(movement);
    syncProvider.incrementPendingData();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mortalité enregistrée'),
        backgroundColor: Colors.grey,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('record_death')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Warning Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.red.shade700),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Action irréversible. L\'animal sera marqué comme décédé.',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Scan Animal
          if (_scannedAnimal == null)
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
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.nfc, size: 48),
                          SizedBox(height: 8),
                          Text('Scanner Animal',
                              style: TextStyle(fontSize: 18)),
                        ],
                      ),
              ),
            )
          else ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.pets, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _scannedAnimal!.officialNumber ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(_scannedAnimal!.displayName),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() => _scannedAnimal = null);
                          },
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Text(
                        'Sexe: ${_scannedAnimal!.sex == AnimalSex.female ? "Femelle" : "Mâle"}'),
                    Text('Âge: ${_scannedAnimal!.ageInMonths} mois'),
                    Text(
                        'Naissance: ${dateFormat.format(_scannedAnimal!.birthDate)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Death Date
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade400),
              ),
              tileColor: Colors.white,
              leading: const Icon(Icons.calendar_today),
              title: Text(l10n.translate('date')),
              subtitle: Text(dateFormat.format(_deathDate)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _deathDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => _deathDate = date);
                }
              },
            ),
            const SizedBox(height: 16),

            // Notes/Cause
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.translate('death_cause'),
                hintText: 'Ex: Maladie, Accident, Prédateur...',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _confirmDeath,
                icon: const Icon(Icons.delete_forever),
                label: Text(l10n.translate('confirm_death')),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.grey.shade700,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
