// lib/screens/movement/slaughter_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';
import '../../models/animal.dart';
import '../../models/movement.dart';
import '../../providers/animal_provider.dart';
import '../../providers/movement_provider.dart';
import '../../providers/sync_provider.dart';

class SlaughterScreen extends StatefulWidget {
  final String? lotId;
  final List<String>? animalIds;
  final int animalCount;
  final Animal? animal;

  const SlaughterScreen({
    super.key,
    this.lotId,
    this.animalIds,
    required this.animalCount,
    this.animal,
  });

  @override
  State<SlaughterScreen> createState() => _SlaughterScreenState();
}

class _SlaughterScreenState extends State<SlaughterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _slaughterhouseNameController = TextEditingController();
  final _slaughterhouseIdController = TextEditingController();
  DateTime _slaughterDate = DateTime.now();
  bool _isConfirming = false;

  @override
  void dispose() {
    _slaughterhouseNameController.dispose();
    _slaughterhouseIdController.dispose();
    super.dispose();
  }

  Future<void> _confirmSlaughter() async {
    if (!_formKey.currentState!.validate()) return;

    final animal = widget.animal;
    if (animal == null) return;

    setState(() => _isConfirming = true);

    final animalProvider = context.read<AnimalProvider>();
    final movementProvider = context.read<MovementProvider>();
    final syncProvider = context.read<SyncProvider>();

    try {
      // Build notes with slaughterhouse info
      final notesText = 'Abattoir: ${_slaughterhouseNameController.text}${_slaughterhouseIdController.text.isNotEmpty ? ' (N°${_slaughterhouseIdController.text})' : ''}';

      // Create slaughter movement
      final movement = Movement(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        animalId: animal.id,
        type: MovementType.slaughter,
        movementDate: _slaughterDate,
        notes: notesText,
        createdAt: DateTime.now(),
      );

      await movementProvider.addMovement(movement);

      // Update animal status to slaughtered
      final updatedAnimal = animal.copyWith(status: AnimalStatus.slaughtered);
      await animalProvider.updateAnimal(updatedAnimal);

      syncProvider.incrementPendingData();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context).translate(AppStrings.slaughterRecorded)),
          backgroundColor: Colors.orange,
        ),
      );

      // Return after update is complete
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      setState(() => _isConfirming = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).translate(AppStrings.error),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context).translate(AppStrings.recordSlaughter)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          children: [
            // Résumé du lot
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)
                          .translate(AppStrings.animalsToSlaughter),
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeSubtitle,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingSmall),
                    Text(
                      '${widget.animalCount} ${AppLocalizations.of(context).translate(AppStrings.animals)}',
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeImportant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingLarge),

            // Abattoir
            TextFormField(
              controller: _slaughterhouseNameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)
                    .translate(AppStrings.slaughterhouseName),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.factory),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? AppLocalizations.of(context)
                      .translate(AppStrings.fieldRequired)
                  : null,
            ),
            const SizedBox(height: AppConstants.spacingMedium),

            // N° Abattoir
            TextField(
              controller: _slaughterhouseIdController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)
                    .translate(AppStrings.slaughterhouseId),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.badge),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMedium),

            // Date abattage
            ListTile(
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusSmall),
                side: BorderSide(color: Colors.grey.shade400),
              ),
              leading: const Icon(Icons.calendar_today),
              title: Text(AppLocalizations.of(context)
                  .translate(AppStrings.dateSlaughter)),
              subtitle: Text(dateFormat.format(_slaughterDate)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _slaughterDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now()
                      .add(const Duration(days: AppConstants.maxFutureDays)),
                );
                if (date != null) {
                  setState(() => _slaughterDate = date);
                }
              },
            ),

            const SizedBox(height: AppConstants.spacingLarge),

            // Action Buttons (Cancel + Confirm)
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  /// Construire les boutons d'action (Annuler + Confirmer)
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child:
                Text(AppLocalizations.of(context).translate(AppStrings.cancel)),
          ),
        ),
        const SizedBox(width: AppConstants.spacingMedium),
        Expanded(
          child: FilledButton(
            onPressed: _isConfirming ? null : _confirmSlaughter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isConfirming)
                  const SizedBox(
                    width: AppConstants.spacingMedium,
                    height: AppConstants.spacingMedium,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else
                  const Icon(Icons.check, size: AppConstants.iconSizeRegular),
                const SizedBox(width: AppConstants.spacingExtraSmall),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)
                        .translate(AppStrings.confirmSlaughter),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
