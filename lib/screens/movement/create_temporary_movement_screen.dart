// lib/screens/movement/create_temporary_movement_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/movement_provider.dart';
import '../../providers/sync_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/animal.dart';
import '../../models/movement.dart';
import '../../i18n/app_localizations.dart';
import '../../utils/constants.dart';
import '../animal/animal_detail_screen.dart';
import '../animal/animal_finder_screen.dart';

class CreateTemporaryMovementScreen extends StatefulWidget {
  const CreateTemporaryMovementScreen({super.key});

  @override
  State<CreateTemporaryMovementScreen> createState() =>
      _CreateTemporaryMovementScreenState();
}

class _CreateTemporaryMovementScreenState
    extends State<CreateTemporaryMovementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _destinationController = TextEditingController();
  final _notesController = TextEditingController();

  Animal? _selectedAnimal;
  DateTime? _selectedDepartureDate;

  @override
  void dispose() {
    _destinationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _scanAnimal() async {
    final result = await Navigator.push<Animal>(
      context,
      MaterialPageRoute(
        builder: (context) => const AnimalFinderScreen(
          mode: AnimalFinderMode.single,
          title: 'Scanner l\'animal',
          allowedStatuses: [AnimalStatus.alive],
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _selectedAnimal = result;
      });
    }
  }

  Future<void> _selectDepartureDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now().add(const Duration(days: 7)),
      locale: const Locale('fr', 'FR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDepartureDate = picked;
      });
    }
  }

  void _showError(String message, {bool isError = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.orange,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _saveMovement() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedAnimal == null) {
      _showError('Veuillez scanner un animal');
      return;
    }

    if (_selectedDepartureDate == null) {
      _showError('Veuillez sélectionner une date de départ');
      return;
    }

    try {
      final authProvider = context.read<AuthProvider>();
      final movementProvider = context.read<MovementProvider>();
      final syncProvider = context.read<SyncProvider>();

      final movement = Movement(
        id: _generateId(),
        farmId: authProvider.currentFarmId,
        animalId: _selectedAnimal!.id,
        type: MovementType.temporaryOut,
        movementDate: _selectedDepartureDate!,
        toFarmId: _destinationController.text.trim().isNotEmpty
            ? _destinationController.text.trim()
            : null,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
        synced: false,
        createdAt: DateTime.now(),
      );

      await movementProvider.addMovement(movement);
      syncProvider.incrementPendingData();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sortie temporaire enregistrée'),
          backgroundColor: AppConstants.successGreen,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context, movement);
    } catch (e) {
      _showError('Erreur lors de l\'enregistrement: $e');
    }
  }

  String _generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'mov_${timestamp}_$random';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sortie temporaire'),
        actions: [
          TextButton(
            onPressed: _saveMovement,
            child: const Text(
              'Enregistrer',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section Animal
              _buildSectionCard(
                title: 'Animal',
                icon: Icons.pets,
                color: Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_selectedAnimal != null) ...[
                      _buildSelectedAnimalCard(),
                      const SizedBox(height: AppConstants.spacingSmall),
                    ],
                    ElevatedButton.icon(
                      onPressed: _scanAnimal,
                      icon: const Icon(Icons.qr_code_scanner),
                      label: Text(_selectedAnimal == null
                          ? 'Scanner l\'animal'
                          : 'Scanner un autre animal'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.spacingMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppConstants.spacingMedium),

              // Section Date de départ
              _buildSectionCard(
                title: 'Date de départ',
                icon: Icons.calendar_today,
                color: Colors.teal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_selectedDepartureDate != null)
                      Container(
                        padding: const EdgeInsets.all(AppConstants.spacingSmall),
                        decoration: BoxDecoration(
                          color: Colors.teal.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.event, color: Colors.teal),
                            const SizedBox(width: AppConstants.spacingSmall),
                            Text(
                              DateFormat('dd MMMM yyyy', 'fr')
                                  .format(_selectedDepartureDate!),
                              style: const TextStyle(
                                fontSize: AppConstants.fontSizeLarge,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: AppConstants.spacingSmall),
                    ElevatedButton.icon(
                      onPressed: _selectDepartureDate,
                      icon: const Icon(Icons.calendar_month),
                      label: Text(_selectedDepartureDate == null
                          ? 'Sélectionner la date'
                          : 'Modifier la date'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.spacingMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppConstants.spacingMedium),

              // Section Destination
              _buildSectionCard(
                title: 'Destination (optionnel)',
                icon: Icons.location_on,
                color: Colors.orange,
                child: TextFormField(
                  controller: _destinationController,
                  decoration: const InputDecoration(
                    labelText: 'Lieu de destination',
                    hintText: 'Ex: Pâturage montagne, Ferme voisine...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.place),
                  ),
                  maxLines: 1,
                ),
              ),

              const SizedBox(height: AppConstants.spacingMedium),

              // Section Notes
              _buildSectionCard(
                title: 'Notes (optionnel)',
                icon: Icons.note,
                color: Colors.grey,
                child: TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    hintText: 'Ex: Transhumance saisonnière, Prêt temporaire...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.edit_note),
                  ),
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingSmall),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppConstants.badgeBorderRadius),
                topRight: Radius.circular(AppConstants.badgeBorderRadius),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: AppConstants.iconSizeSmall),
                const SizedBox(width: AppConstants.spacingSmall),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          // Contenu
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMedium),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedAnimalCard() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnimalDetailScreen(preloadedAnimal: _selectedAnimal!),
          ),
        );
      },
      borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingSmall),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
          border: Border.all(
            color: Colors.blue.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
              ),
              child: const Icon(
                Icons.pets,
                color: Colors.blue,
                size: AppConstants.iconSizeMedium,
              ),
            ),
            const SizedBox(width: AppConstants.spacingSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedAnimal!.currentEid ??
                        _selectedAnimal!.officialNumber ??
                        _selectedAnimal!.id,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_selectedAnimal!.currentEid != null &&
                      _selectedAnimal!.officialNumber != null)
                    Text(
                      _selectedAnimal!.officialNumber!,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: AppConstants.iconSizeXSmall),
          ],
        ),
      ),
    );
  }
}
