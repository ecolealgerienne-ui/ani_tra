// lib/screens/movement/slaughter_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';
import '../../models/animal.dart';
import '../../providers/animal_provider.dart';
import '../../providers/sync_provider.dart';
import '../../services/atomic_operation_service.dart';

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
  final _notesController = TextEditingController();
  DateTime _slaughterDate = DateTime.now();
  bool _isConfirming = false;

  @override
  void dispose() {
    _slaughterhouseNameController.dispose();
    _slaughterhouseIdController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _confirmSlaughter() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isConfirming = true);

    final animalProvider = context.read<AnimalProvider>();
    final syncProvider = context.read<SyncProvider>();
    final atomicService = context.read<AtomicOperationService>();

    try {
      // Utiliser les notes saisies par l'utilisateur
      final notesText = _notesController.text.isNotEmpty ? _notesController.text : null;

      // Récupérer le farmId depuis le premier animal disponible
      String? farmId;
      List<String> animalIdsToProcess = [];

      // Cas 1 : Un seul animal passé directement
      if (widget.animal != null) {
        farmId = widget.animal!.farmId;
        animalIdsToProcess = [widget.animal!.id];
      }
      // Cas 2 : Plusieurs animaux depuis un lot
      else if (widget.animalIds != null && widget.animalIds!.isNotEmpty) {
        // Filtrer les IDs valides et récupérer le farmId
        for (final animalId in widget.animalIds!) {
          final animal = animalProvider.getAnimalById(animalId);
          if (animal != null) {
            farmId ??= animal.farmId;
            animalIdsToProcess.add(animalId);
          }
        }
      }

      if (animalIdsToProcess.isEmpty || farmId == null) {
        // Aucun animal à traiter
        if (!mounted) return;
        setState(() => _isConfirming = false);
        return;
      }

      // TRANSACTION ATOMIQUE: Exécuter l'abattage batch
      // Si une erreur survient, toutes les opérations sont annulées (rollback)
      final processedCount = await atomicService.executeBatchSlaughter(
        farmId: farmId,
        animalIds: animalIdsToProcess,
        slaughterDate: _slaughterDate,
        slaughterhouseName: _slaughterhouseNameController.text,
        slaughterhouseId: _slaughterhouseIdController.text.isNotEmpty
            ? _slaughterhouseIdController.text
            : null,
        lotId: widget.lotId,
        notes: notesText,
      );

      // Incrémenter le compteur de sync pour chaque animal traité
      for (int i = 0; i < processedCount; i++) {
        syncProvider.incrementPendingData();
      }

      // Rafraîchir les providers pour refléter les changements
      await animalProvider.refresh(forceRefresh: true);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context).translate(AppStrings.slaughterRecorded)),
          backgroundColor: Colors.orange,
        ),
      );

      // Return true to indicate successful slaughter recording
      Navigator.pop(context, true);
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
            const SizedBox(height: AppConstants.spacingMedium),

            // Notes (optionnel)
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)
                    .translate(AppStrings.notes),
                hintText: '(${AppLocalizations.of(context).translate(AppStrings.optional).toLowerCase()})',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.note),
                alignLabelWithHint: true,
              ),
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
