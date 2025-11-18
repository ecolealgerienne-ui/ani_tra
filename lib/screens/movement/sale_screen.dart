// lib/screens/movement/sale_screen.dart
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

class SaleScreen extends StatefulWidget {
  final String? lotId;
  final List<String>? animalIds;
  final int animalCount;
  final Animal? animal;

  const SaleScreen({
    super.key,
    this.lotId,
    this.animalIds,
    required this.animalCount,
    this.animal,
  });

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _buyerNameController = TextEditingController();
  final _buyerFarmIdController = TextEditingController();
  final _pricePerAnimalController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _saleDate = DateTime.now();
  bool _isConfirming = false;

  @override
  void dispose() {
    _buyerNameController.dispose();
    _buyerFarmIdController.dispose();
    _pricePerAnimalController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _confirmSale() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isConfirming = true);

    final animalProvider = context.read<AnimalProvider>();
    final syncProvider = context.read<SyncProvider>();
    final atomicService = context.read<AtomicOperationService>();

    try {
      // Parse price if provided
      double? price;
      if (_pricePerAnimalController.text.isNotEmpty) {
        price = double.tryParse(_pricePerAnimalController.text);
      }

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

      // TRANSACTION ATOMIQUE: Exécuter la vente batch
      // Si une erreur survient, toutes les opérations sont annulées (rollback)
      final processedCount = await atomicService.executeBatchSale(
        farmId: farmId,
        animalIds: animalIdsToProcess,
        saleDate: _saleDate,
        buyerName: _buyerNameController.text,
        buyerFarmId: _buyerFarmIdController.text.isNotEmpty
            ? _buyerFarmIdController.text
            : null,
        lotId: widget.lotId,
        pricePerAnimal: price,
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
              AppLocalizations.of(context).translate(AppStrings.saleRecorded)),
          backgroundColor: Colors.green,
        ),
      );

      // Return true to indicate successful sale
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
        title:
            Text(AppLocalizations.of(context).translate(AppStrings.recordSale)),
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
                          .translate(AppStrings.animalsForSale),
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

            // Acheteur
            TextFormField(
              controller: _buyerNameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)
                    .translate(AppStrings.buyerName),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? AppLocalizations.of(context)
                      .translate(AppStrings.buyerNameRequired)
                  : null,
            ),
            const SizedBox(height: AppConstants.spacingMedium),

            // N° Exploitation
            TextField(
              controller: _buyerFarmIdController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)
                    .translate(AppStrings.buyerFarmId),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.badge),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMedium),

            // Prix par animal (optionnel)
            TextFormField(
              controller: _pricePerAnimalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)
                    .translate(AppStrings.pricePerAnimal),
                hintText: '(${AppLocalizations.of(context).translate(AppStrings.optional).toLowerCase()})',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.euro),
              ),
              validator: (value) {
                // Le prix est optionnel - accepter un champ vide
                if (value == null || value.isEmpty) {
                  return null;
                }
                // Si rempli, vérifier que c'est un nombre positif
                final price = double.tryParse(value);
                if (price == null || price <= 0) {
                  return AppLocalizations.of(context)
                      .translate(AppStrings.invalidPrice);
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.spacingMedium),

            // Date vente
            ListTile(
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusSmall),
                side: BorderSide(color: Colors.grey.shade400),
              ),
              leading: const Icon(Icons.calendar_today),
              title: Text(
                  AppLocalizations.of(context).translate(AppStrings.saleDate)),
              subtitle: Text(dateFormat.format(_saleDate)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _saleDate,
                  firstDate: DateTime.now()
                      .subtract(const Duration(days: AppConstants.maxPastDays)),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => _saleDate = date);
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
            onPressed: _isConfirming ? null : _confirmSale,
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
                        .translate(AppStrings.confirmSale),
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
