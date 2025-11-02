// screens/weight_record_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../../models/animal.dart';
import '../../models/weight_record.dart';
import '../../providers/animal_provider.dart';
import '../../providers/weight_provider.dart';
import '../../providers/sync_provider.dart';

/// Écran d'enregistrement d'une nouvelle pesée
///
/// Permet de :
/// - Scanner un animal (ou le sélectionner)
/// - Saisir le poids
/// - Choisir la source de mesure
/// - Ajouter des notes
class WeightRecordScreen extends StatefulWidget {
  final Animal? preselectedAnimal;

  const WeightRecordScreen({
    super.key,
    this.preselectedAnimal,
  });

  @override
  State<WeightRecordScreen> createState() => _WeightRecordScreenState();
}

class _WeightRecordScreenState extends State<WeightRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();
  final _random = Random();

  Animal? _selectedAnimal;
  WeightSource _selectedSource = WeightSource.manual;
  DateTime _selectedDate = DateTime.now();
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _selectedAnimal = widget.preselectedAnimal;
  }

  @override
  void dispose() {
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  /// Simuler le scan d'un animal
  Future<void> _scanAnimal() async {
    setState(() => _isScanning = true);

    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 500));

    final animalProvider = context.read<AnimalProvider>();

    try {
      // Obtenir la liste des animaux vivants
      final animals = animalProvider.animals
          .where((a) => a.status == AnimalStatus.alive)
          .toList();

      if (animals.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aucun animal disponible'),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() => _isScanning = false);
        return;
      }

      // Sélectionner un animal aléatoire
      final animal = animals[_random.nextInt(animals.length)];

      setState(() {
        _selectedAnimal = animal;
        _isScanning = false;
      });

      HapticFeedback.heavyImpact();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('✅ Animal scanné: ${animal.officialNumber ?? animal.eid}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      setState(() => _isScanning = false);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Erreur lors du scan'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Sauvegarder la pesée
  Future<void> _saveWeight() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedAnimal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Veuillez scanner un animal'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final weight = double.parse(_weightController.text.trim());

    final weightProvider = context.read<WeightProvider>();
    final syncProvider = context.read<SyncProvider>();

    // Créer l'enregistrement
    final record = WeightRecord(
      id: 'weight_${DateTime.now().millisecondsSinceEpoch}',
      animalId: _selectedAnimal!.id,
      weight: weight,
      recordedAt: _selectedDate,
      source: _selectedSource,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      synced: false,
      createdAt: DateTime.now(),
    );

    // Ajouter au provider
    weightProvider.addWeight(record);
    syncProvider.incrementPendingData();

    // Feedback et retour
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Pesée enregistrée: ${weight.toStringAsFixed(1)} kg'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  /// Choisir la date
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle Pesée'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Étape 1: Scanner l'animal
            _buildSectionTitle('1. Animal', Icons.pets),
            const SizedBox(height: 12),

            if (_selectedAnimal == null)
              SizedBox(
                height: 100,
                child: ElevatedButton(
                  onPressed: _isScanning ? null : _scanAnimal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: _isScanning
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.qr_code_scanner, size: 36),
                            SizedBox(height: 8),
                            Text('Scanner l\'animal',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                ),
              )
            else
              Card(
                color: Colors.green.shade50,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _selectedAnimal!.sex == AnimalSex.male
                        ? Colors.blue.shade100
                        : Colors.pink.shade100,
                    child: Icon(
                      _selectedAnimal!.sex == AnimalSex.male
                          ? Icons.male
                          : Icons.female,
                      color: _selectedAnimal!.sex == AnimalSex.male
                          ? Colors.blue
                          : Colors.pink,
                    ),
                  ),
                  title: Text(
                    _selectedAnimal!.officialNumber ?? 'Sans numéro',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_selectedAnimal!.eid),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _selectedAnimal = null;
                      });
                    },
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Étape 2: Poids
            _buildSectionTitle('2. Poids', Icons.monitor_weight),
            const SizedBox(height: 12),

            TextFormField(
              controller: _weightController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Poids (kg) *',
                hintText: '45.5',
                prefixIcon: Icon(Icons.monitor_weight),
                suffixText: 'kg',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Le poids est requis';
                }
                final weight = double.tryParse(value.trim());
                if (weight == null) {
                  return 'Poids invalide';
                }
                if (weight <= 0 || weight > 300) {
                  return 'Le poids doit être entre 0 et 300 kg';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Étape 3: Source de mesure
            _buildSectionTitle('3. Source de mesure', Icons.source),
            const SizedBox(height: 12),

            ...WeightSource.values.map((source) {
              return RadioListTile<WeightSource>(
                value: source,
                groupValue: _selectedSource,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedSource = value;
                    });
                  }
                },
                title: Row(
                  children: [
                    Text(source.icon),
                    const SizedBox(width: 8),
                    Text(source.frenchName),
                  ],
                ),
                subtitle: Text(
                  'Fiabilité: ${(source.reliability * 100).toInt()}%',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              );
            }).toList(),

            const SizedBox(height: 24),

            // Étape 4: Date
            _buildSectionTitle('4. Date de pesée', Icons.calendar_today),
            const SizedBox(height: 12),

            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Date de pesée'),
              subtitle: Text(_formatDate(_selectedDate)),
              trailing: const Icon(Icons.edit),
              onTap: _selectDate,
              tileColor: Colors.grey.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),

            const SizedBox(height: 24),

            // Étape 5: Notes (optionnel)
            _buildSectionTitle('5. Notes (optionnel)', Icons.notes),
            const SizedBox(height: 12),

            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Ex: Animal en bonne santé, pesée après tonte...',
                prefixIcon: Icon(Icons.notes),
              ),
            ),

            const SizedBox(height: 32),

            // Bouton de sauvegarde
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _saveWeight,
                icon: const Icon(Icons.save),
                label: const Text('Enregistrer la Pesée'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Bouton annuler
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget: Titre de section
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.deepPurple),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ],
    );
  }

  /// Formater une date
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
