// lib/screens/lot_finalize_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:intl/intl.dart';

import '../../providers/lot_provider.dart';
import '../../providers/animal_provider.dart';
import '../../providers/sync_provider.dart';
import '../../models/lot.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';
//import '../../models/product.dart';
import '../../models/animal.dart';
//import '../../models/veterinarian.dart';
import '../medical/medical_act_screen.dart';
import '../movement/sale_screen.dart';
import '../movement/slaughter_screen.dart';

class LotFinalizeScreen extends StatefulWidget {
  final String lotId;

  const LotFinalizeScreen({
    super.key,
    required this.lotId,
  });

  @override
  State<LotFinalizeScreen> createState() => _LotFinalizeScreenState();
}

class _LotFinalizeScreenState extends State<LotFinalizeScreen> {
  // Vente
  final _buyerNameController = TextEditingController();
  final _buyerFarmIdController = TextEditingController();
  final _pricePerAnimalController = TextEditingController();
  final DateTime _saleDate = DateTime.now();

  // Abattage
  final _slaughterhouseNameController = TextEditingController();
  final _slaughterhouseIdController = TextEditingController();
  final DateTime _slaughterDate = DateTime.now();

  // Notes
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _buyerNameController.dispose();
    _buyerFarmIdController.dispose();
    _pricePerAnimalController.dispose();
    _slaughterhouseNameController.dispose();
    _slaughterhouseIdController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lotProvider = context.watch<LotProvider>();
    final lot = lotProvider.getLotById(widget.lotId);

    if (lot == null) {
      return Scaffold(
        appBar: AppBar(
            title:
                Text(AppLocalizations.of(context).translate(AppStrings.error))),
        body: Center(
            child: Text(AppLocalizations.of(context)
                .translate(AppStrings.lotNotFound))),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context).translate(AppStrings.finalizeLot)),
      ),
      body: _buildTypeSelection(context, lot),
    );
  }

  Widget _buildTypeSelection(BuildContext context, Lot lot) {
    // Calculer le nombre d'animaux ACTIFS
    final animalProvider = context.read<AnimalProvider>();
    final lotProvider = context.read<LotProvider>();
    final activeAnimalCount =
        lotProvider.getActiveAnimalCount(lot.id, animalProvider.animals);

    // Filtrer les IDs d'animaux ACTIFS
    final activeAnimalIds = lot.animalIds.where((id) {
      final animal = animalProvider.getAnimalById(id);
      return animal?.status == AnimalStatus.alive;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      children: [
        Text(
          AppLocalizations.of(context).translate(AppStrings.chooseLotType),
          style: const TextStyle(
            fontSize: AppConstants.fontSizeLargeTitle,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConstants.spacingSmall),
        Text(
          '$activeAnimalCount} ${AppLocalizations.of(context).translate(AppStrings.animals)}',
          style: TextStyle(
            fontSize: AppConstants.fontSizeBody,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConstants.spacingLarge),

        // Traitement
        _buildTypeCard(
          icon: '💊',
          title:
              AppLocalizations.of(context).translate(AppStrings.treatmentLot),
          subtitle: AppLocalizations.of(context)
              .translate(AppStrings.groupedHealthTreatment),
          color: AppConstants.primaryBlue,
          onTap: () async {
            /// Capturer le retour de MedicalActScreen (Map avec productName et productType)
            final validationResult = await Navigator.push<Map<String, dynamic>?>(
              context,
              MaterialPageRoute(
                builder: (_) => MedicalActScreen(
                  mode: MedicalActMode.batch,
                  batchId: lot.id,
                  animalIds: activeAnimalIds,
                  lotId: widget.lotId,
                ),
              ),
            );

            /// ✅ Vérifier que l'acte médical a été VALIDÉ (pas annulé)
            if (validationResult == null || validationResult['success'] != true) {
              // L'utilisateur a annulé ou il y a eu une erreur
              return;
            }

            // Après retour de medical_act_screen validé, finaliser le lot
            if (!mounted) return;
            final lotProvider = context.read<LotProvider>();
            final syncProvider = context.read<SyncProvider>();

            // Récupérer le nom et type du produit
            final productName = validationResult['productName'] as String?;
            final productType = validationResult['productType'] as String?;

            final success = await lotProvider.finalizeLot(
              widget.lotId,
              type: LotType.treatment,
              productName: productName,
              notes: productType != null
                  ? '[$productType]${_notesController.text.isEmpty ? '' : ' ${_notesController.text}'}'
                  : (_notesController.text.isEmpty ? null : _notesController.text),
            );

            if (success) {
              syncProvider.incrementPendingData();
              if (mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)
                          .translate(AppStrings.lotFinalized),
                    ),
                    backgroundColor: AppConstants.successGreen,
                  ),
                );
              }
            }
          },
        ),
        const SizedBox(height: AppConstants.spacingMedium),

        // Vente
        _buildTypeCard(
          icon: '💰',
          title: AppLocalizations.of(context).translate(AppStrings.saleLot),
          subtitle:
              AppLocalizations.of(context).translate(AppStrings.saleAnimals),
          color: AppConstants.successGreen,
          onTap: () async {
            /// Naviguer vers SaleScreen
            final validationResult = await Navigator.push<bool?>(
              context,
              MaterialPageRoute(
                builder: (_) => SaleScreen(
                  lotId: widget.lotId,
                  animalIds: lot.animalIds,
                  animalCount: activeAnimalCount,
                ),
              ),
            );

            /// Vérifier que la vente a été validée (pas annulée)
            if (validationResult != true) {
              // L'utilisateur a annulé ou il y a eu une erreur
              return;
            }

            // Après retour de sale_screen validé, finaliser le lot
            if (!mounted) return;
            final lotProvider = context.read<LotProvider>();
            final syncProvider = context.read<SyncProvider>();

            // Prix optionnel - accepter null ou vide
            final pricePerAnimal = _pricePerAnimalController.text.isEmpty
                ? null
                : double.tryParse(_pricePerAnimalController.text);

            // Si prix fourni, il doit être > 0
            if (pricePerAnimal != null && pricePerAnimal <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)
                      .translate(AppStrings.invalidPrice)),
                  backgroundColor: AppConstants.statusDanger,
                ),
              );
              return;
            }

            // Les données de vente (acheteur, prix, date) sont stockées dans Movement
            // et ont déjà été créées par SaleScreen
            final success = await lotProvider.finalizeLot(
              widget.lotId,
              type: LotType.sale,
              notes:
                  _notesController.text.isEmpty ? null : _notesController.text,
            );

            if (success) {
              // Les mouvements ont déjà été créés par SaleScreen
              syncProvider.incrementPendingData();

              if (mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)
                          .translate(AppStrings.lotFinalized),
                    ),
                    backgroundColor: AppConstants.successGreen,
                  ),
                );
              }
            }
          },
        ),
        const SizedBox(height: AppConstants.spacingMedium),

        // Abattage
        _buildTypeCard(
          icon: '🏭',
          title:
              AppLocalizations.of(context).translate(AppStrings.slaughterLot),
          subtitle: AppLocalizations.of(context)
              .translate(AppStrings.slaughterPreparation),
          color: AppConstants.statusGrey,
          onTap: () async {
            /// Naviguer vers SlaughterScreen
            final validationResult = await Navigator.push<bool?>(
              context,
              MaterialPageRoute(
                builder: (_) => SlaughterScreen(
                  lotId: widget.lotId,
                  animalIds: lot.animalIds,
                  animalCount: activeAnimalCount,
                ),
              ),
            );

            /// Vérifier que l'abattage a été validé (pas annulé)
            if (validationResult != true) {
              // L'utilisateur a annulé ou il y a eu une erreur
              return;
            }

            // Après retour de slaughter_screen validé, finaliser le lot
            if (!mounted) return;
            final lotProvider = context.read<LotProvider>();
            final syncProvider = context.read<SyncProvider>();

            // Les données d'abattage (abattoir, date) sont stockées dans Movement
            // et ont déjà été créées par SlaughterScreen
            final success = await lotProvider.finalizeLot(
              widget.lotId,
              type: LotType.slaughter,
              notes:
                  _notesController.text.isEmpty ? null : _notesController.text,
            );

            if (success) {
              // Les mouvements ont déjà été créés par SlaughterScreen
              syncProvider.incrementPendingData();

              if (mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)
                          .translate(AppStrings.lotFinalized),
                    ),
                    backgroundColor: AppConstants.successGreen,
                  ),
                );
              }
            }
          },
        ),
      ],
    );
  }

  Widget _buildTypeCard({
    required String icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingLarge),
          child: Row(
            children: [
              Container(
                width: AppConstants.typeCardIconSize,
                height: AppConstants.typeCardIconSize,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: AppConstants.opacityLight),
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadiusMedium),
                ),
                child: Center(
                  child: Text(icon,
                      style: const TextStyle(
                          fontSize: AppConstants.typeCardIconFontSize)),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeImportant,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingTiny),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeSubtitle,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
