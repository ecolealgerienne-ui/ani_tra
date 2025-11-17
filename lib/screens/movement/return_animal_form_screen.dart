// lib/screens/movement/return_animal_form_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/movement_provider.dart';
import '../../providers/animal_provider.dart';
import '../../providers/sync_provider.dart';
import '../../models/movement.dart';

class ReturnAnimalFormScreen extends StatefulWidget {
  final Movement movement;

  const ReturnAnimalFormScreen({
    super.key,
    required this.movement,
  });

  @override
  State<ReturnAnimalFormScreen> createState() => _ReturnAnimalFormScreenState();
}

class _ReturnAnimalFormScreenState extends State<ReturnAnimalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  DateTime? _selectedReturnDate;

  @override
  void initState() {
    super.initState();
    // Date de retour par défaut = aujourd'hui
    _selectedReturnDate = DateTime.now();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectReturnDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedReturnDate ?? DateTime.now(),
      firstDate: widget.movement.movementDate, // Ne peut pas être avant la date de départ
      lastDate: DateTime.now().add(const Duration(days: 1)), // Pas dans le futur
      helpText: 'Sélectionner la date de retour',
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedReturnDate = picked;
      });
    }
  }

  Future<void> _saveReturn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedReturnDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une date de retour'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final movementProvider = context.read<MovementProvider>();
      final syncProvider = context.read<SyncProvider>();

      // Mettre à jour le mouvement avec les informations de retour
      final updatedMovement = widget.movement.copyWith(
        returnDate: _selectedReturnDate,
        returnNotes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      await movementProvider.updateMovement(updatedMovement);

      syncProvider.incrementPendingData();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Retour enregistré avec succès'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true); // Retourner true pour indiquer le succès
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'enregistrement: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final animal = context.read<AnimalProvider>().getAnimalById(widget.movement.animalId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Retour à la ferme'),
        actions: [
          TextButton(
            onPressed: _saveReturn,
            child: const Text(
              'Enregistrer',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Information sur l'animal
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Animal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (animal != null) ...[
                        Text('EID: ${animal.currentEid ?? 'N/A'}'),
                        if (animal.officialNumber != null)
                          Text('N° Officiel: ${animal.officialNumber}'),
                        if (animal.visualId != null)
                          Text('N° Visuel: ${animal.visualId}'),
                      ] else
                        Text('Animal ID: ${widget.movement.animalId}'),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),
                      Text(
                        'Date de départ: ${DateFormat('dd/MM/yyyy').format(widget.movement.movementDate)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Date de retour
              const Text(
                'Date de retour *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectReturnDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedReturnDate != null
                            ? DateFormat('dd/MM/yyyy').format(_selectedReturnDate!)
                            : 'Sélectionner une date',
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedReturnDate != null
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Notes de retour
              const Text(
                'Notes de retour',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'État de santé, observations, etc.',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Bouton d'enregistrement
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveReturn,
                  icon: const Icon(Icons.save),
                  label: const Text('Enregistrer le retour'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
