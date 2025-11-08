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
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';

class DeathScreen extends StatefulWidget {
  final Animal? animal;

  const DeathScreen({super.key, this.animal});

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
  void initState() {
    super.initState();
    // Si un animal est passé en paramètre, l'utiliser directement
    if (widget.animal != null) {
      _scannedAnimal = widget.animal;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _simulateScan() async {
    setState(() => _isScanning = true);

    HapticFeedback.mediumImpact();
    await Future.delayed(AppConstants.longAnimation);

    final animalProvider = context.read<AnimalProvider>();

    try {
      // Obtenir la liste des animaux vivants (non décédés)
      final animals = animalProvider.animals
          .where((a) => a.status != AnimalStatus.dead)
          .toList();

      if (animals.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)
                .translate(AppStrings.noAnimalsAvailable)),
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
    final animal = _scannedAnimal ?? widget.animal;
    if (animal == null) return;

    final animalProvider = context.read<AnimalProvider>();
    final syncProvider = context.read<SyncProvider>();

    // Create death movement
    final movement = Movement(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      animalId: animal.id,
      type: MovementType.death,
      movementDate: _deathDate,
      notes: _notesController.text.isEmpty
          ? AppLocalizations.of(context).translate(AppStrings.causeNotSpecified)
          : _notesController.text,
      createdAt: DateTime.now(),
    );

    animalProvider.addMovement(movement);

    // Mettre à jour le statut de l'animal à "mort"
    final updatedAnimal = animal.copyWith(status: AnimalStatus.dead);
    animalProvider.updateAnimal(updatedAnimal);

    syncProvider.incrementPendingData();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            AppLocalizations.of(context).translate(AppStrings.deathRecorded)),
        backgroundColor: Colors.grey,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context).translate(AppStrings.recordDeath)),
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
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)
                        .translate(AppStrings.irreversibleWarning),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Scan Animal
          if (_scannedAnimal == null && widget.animal == null)
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
                              AppLocalizations.of(context)
                                  .translate(AppStrings.scanAnimal),
                              style: const TextStyle(fontSize: 18)),
                        ],
                      ),
              ),
            )
          else if (_scannedAnimal != null || widget.animal != null) ...[
            Builder(builder: (context) {
              final animal = _scannedAnimal ?? widget.animal;
              return Card(
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
                                  animal!.officialNumber ??
                                      AppConstants.notAvailable,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(animal.displayName),
                              ],
                            ),
                          ),
                          if (widget.animal == null)
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
                          '${AppLocalizations.of(context).translate(AppStrings.sex)}: ${animal.sex == AnimalSex.female ? AppLocalizations.of(context).translate(AppStrings.female) : AppLocalizations.of(context).translate(AppStrings.male)}'),
                      Text(
                          '${AppLocalizations.of(context).translate(AppStrings.age)}: ${animal.ageInMonths} ${AppLocalizations.of(context).translate(AppStrings.months)}'),
                      Text(
                          '${AppLocalizations.of(context).translate(AppStrings.birthDate)}: ${dateFormat.format(animal.birthDate)}'),
                    ],
                  ),
                ),
              );
            }),
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
              title:
                  Text(AppLocalizations.of(context).translate(AppStrings.date)),
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
                labelText: AppLocalizations.of(context)
                    .translate(AppStrings.deathCause),
                hintText: AppLocalizations.of(context)
                    .translate(AppStrings.deathCauseHint),
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
                label: Text(AppLocalizations.of(context)
                    .translate(AppStrings.confirmDeath)),
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
