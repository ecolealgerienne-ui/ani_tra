// lib/screens/movement/movement_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/movement_provider.dart';
import '../../providers/animal_provider.dart';
import '../../models/movement.dart';
import '../../models/animal.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';
import '../animal/animal_detail_screen.dart';

class MovementDetailScreen extends StatefulWidget {
  final String movementId;

  const MovementDetailScreen({
    super.key,
    required this.movementId,
  });

  @override
  State<MovementDetailScreen> createState() => _MovementDetailScreenState();
}

class _MovementDetailScreenState extends State<MovementDetailScreen> {
  bool _isRecordingReturn = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final movementProvider = context.watch<MovementProvider>();
    final movement = movementProvider.getMovementById(widget.movementId);

    if (movement == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.translate(AppStrings.movementDetails)),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: AppConstants.spacingMedium),
              Text(
                l10n.translate(AppStrings.movementNotFound),
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeLarge,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final animalProvider = context.watch<AnimalProvider>();
    final animal = animalProvider.getAnimalById(movement.animalId);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate(AppStrings.movementDetails)),
        // TODO: Ajouter bouton d'édition si nécessaire
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.edit),
        //     onPressed: () {
        //       // Navigation vers écran d'édition
        //     },
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // En-tête avec type de mouvement
            _MovementTypeHeader(movement: movement),

            const SizedBox(height: AppConstants.spacingMediumLarge),

            // Section Animal
            _SectionCard(
              title: l10n.translate(AppStrings.animal),
              icon: Icons.pets,
              color: Colors.blue,
              child: animal != null
                  ? _AnimalInfoSection(animal: animal)
                  : _UnknownAnimalSection(animalId: movement.animalId),
            ),

            const SizedBox(height: AppConstants.spacingMedium),

            // Section Informations générales
            _SectionCard(
              title: l10n.translate(AppStrings.generalInfo),
              icon: Icons.info_outline,
              color: Colors.grey,
              child: _GeneralInfoSection(movement: movement),
            ),

            // Section Prix (si disponible)
            if (movement.price != null) ...[
              const SizedBox(height: AppConstants.spacingMedium),
              _SectionCard(
                title: l10n.translate(AppStrings.financialInfo),
                icon: Icons.attach_money,
                color: Colors.green,
                child: _FinancialInfoSection(movement: movement),
              ),
            ],

            // Section Notes (si disponible)
            if (movement.notes != null && movement.notes!.isNotEmpty) ...[
              const SizedBox(height: AppConstants.spacingMedium),
              _SectionCard(
                title: l10n.translate(AppStrings.notes),
                icon: Icons.note,
                color: Colors.orange,
                child: _NotesSection(notes: movement.notes!),
              ),
            ],

            // Section Synchronisation
            const SizedBox(height: AppConstants.spacingMedium),
            _SectionCard(
              title: l10n.translate(AppStrings.syncInfo),
              icon: Icons.sync,
              color: movement.synced ? Colors.green : Colors.orange,
              child: _SyncInfoSection(movement: movement),
            ),

            const SizedBox(height: AppConstants.spacingLarge),

            // Bouton "Enregistrer le retour" (si mouvement temporaire non retourné)
            if (movement.isTemporaryOut && !movement.isReturned) ...[
              ElevatedButton.icon(
                onPressed: _isRecordingReturn ? null : () => _recordReturn(context, movement),
                icon: _isRecordingReturn
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.keyboard_return),
                label: Text(_isRecordingReturn ? 'Enregistrement...' : 'Enregistrer le retour'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.spacingMedium,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingMedium),
            ],

            // Bouton "Valider le mouvement" (pour ventes et achats en cours)
            if ((movement.isSale || movement.type == MovementType.purchase) &&
                movement.status == MovementStatus.ongoing) ...[
              ElevatedButton.icon(
                onPressed: () => _validateMovement(context, movement),
                icon: const Icon(Icons.check_circle),
                label: const Text('Valider le mouvement'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.spacingMedium,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingMedium),
            ],

            // Bouton retour (optionnel, car déjà présent dans l'AppBar)
            // Mais peut être utile pour une meilleure UX
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: Text(l10n.translate(AppStrings.back)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.spacingMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Enregistre le retour d'un mouvement temporaire
  Future<void> _recordReturn(BuildContext context, Movement outMovement) async {
    final l10n = AppLocalizations.of(context);

    // Ouvrir le dialog pour saisir la date et les notes
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _ReturnDateDialog(
        outMovement: outMovement,
      ),
    );

    if (result == null) return; // Utilisateur a annulé

    setState(() => _isRecordingReturn = true);

    try {
      final movementProvider = context.read<MovementProvider>();
      final animalProvider = context.read<AnimalProvider>();

      final DateTime returnDate = result['returnDate'];
      final String? notes = result['notes'];

      // Créer le mouvement de retour
      final returnMovement = Movement(
        farmId: outMovement.farmId,
        animalId: outMovement.animalId,
        type: MovementType.temporaryReturn,
        movementDate: returnDate,
        fromFarmId: outMovement.toFarmId,
        toFarmId: outMovement.fromFarmId,
        notes: notes ?? 'Retour du mouvement temporaire du ${DateFormat('dd/MM/yyyy').format(outMovement.movementDate)}',
        relatedMovementId: outMovement.id,
      );

      // Sauvegarder le mouvement de retour
      await movementProvider.addMovement(returnMovement);

      // Mettre à jour le mouvement sortant avec le lien vers le retour ET le statut "closed"
      final updatedOutMovement = outMovement.copyWith(
        relatedMovementId: returnMovement.id,
        status: MovementStatus.closed,
      );
      await movementProvider.updateMovement(updatedOutMovement);

      // Mettre à jour le statut de l'animal (retour à "alive")
      final animal = animalProvider.getAnimalById(outMovement.animalId);
      if (animal != null) {
        final updatedAnimal = animal.copyWith(status: AnimalStatus.alive);
        await animalProvider.updateAnimal(updatedAnimal);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Retour enregistré avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRecordingReturn = false);
      }
    }
  }

  /// Valide un mouvement (passe de ongoing à closed)
  Future<void> _validateMovement(BuildContext context, Movement movement) async {
    // Demander confirmation
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la validation'),
        content: Text(
          movement.isSale
              ? 'Confirmer la validation de cette vente ?\nLe mouvement sera marqué comme clos et ne pourra plus être modifié facilement.'
              : 'Confirmer la validation de cet achat ?\nLe mouvement sera marqué comme clos et ne pourra plus être modifié facilement.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Valider'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final movementProvider = context.read<MovementProvider>();

      // Mettre à jour le statut du mouvement
      final updatedMovement = movement.copyWith(
        status: MovementStatus.closed,
      );
      await movementProvider.updateMovement(updatedMovement);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Mouvement validé avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// Widget : En-tête avec le type de mouvement
class _MovementTypeHeader extends StatelessWidget {
  final Movement movement;

  const _MovementTypeHeader({required this.movement});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMediumLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getMovementTypeColor(movement.type),
            _getMovementTypeColor(movement.type).withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
        boxShadow: [
          BoxShadow(
            color: _getMovementTypeColor(movement.type).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            _getMovementTypeIcon(movement.type),
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: AppConstants.spacingSmall),
          Text(
            _getMovementTypeLabel(context, movement.type),
            style: const TextStyle(
              fontSize: AppConstants.fontSizeExtraLarge,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppConstants.spacingTiny),
          Text(
            DateFormat('dd MMMM yyyy', 'fr').format(movement.movementDate),
            style: TextStyle(
              fontSize: AppConstants.fontSizeBody,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Color _getMovementTypeColor(MovementType type) {
    switch (type) {
      case MovementType.birth:
        return Colors.green;
      case MovementType.purchase:
        return Colors.blue;
      case MovementType.sale:
        return Colors.orange;
      case MovementType.death:
        return Colors.red;
      case MovementType.slaughter:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getMovementTypeIcon(MovementType type) {
    switch (type) {
      case MovementType.birth:
        return Icons.child_care;
      case MovementType.purchase:
        return Icons.shopping_cart;
      case MovementType.sale:
        return Icons.sell;
      case MovementType.death:
        return Icons.dangerous;
      case MovementType.slaughter:
        return Icons.content_cut;
      default:
        return Icons.sync_alt;
    }
  }

  String _getMovementTypeLabel(BuildContext context, MovementType type) {
    final l10n = AppLocalizations.of(context);
    switch (type) {
      case MovementType.birth:
        return l10n.translate(AppStrings.birth);
      case MovementType.purchase:
        return l10n.translate(AppStrings.purchase);
      case MovementType.sale:
        return l10n.translate(AppStrings.sale);
      case MovementType.death:
        return l10n.translate(AppStrings.death);
      case MovementType.slaughter:
        return l10n.translate(AppStrings.slaughter);
      default:
        return 'Mouvement';
    }
  }
}

/// Widget : Carte de section
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête de section
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMedium),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppConstants.badgeBorderRadius),
                topRight: Radius.circular(AppConstants.badgeBorderRadius),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: AppConstants.iconSizeRegular),
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
}

/// Widget : Section d'informations sur l'animal
class _AnimalInfoSection extends StatelessWidget {
  final Animal animal;

  const _AnimalInfoSection({required this.animal});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnimalDetailScreen(preloadedAnimal: animal),
          ),
        );
      },
      borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingSmall),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
          border: Border.all(
            color: Colors.blue.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    animal.currentEid ?? animal.officialNumber ?? animal.id,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (animal.officialNumber != null)
                    Text(
                      '${l10n.translate(AppStrings.officialNumber)}: ${animal.officialNumber}',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: Colors.grey[600],
                      ),
                    ),
                  Text(
                    '${l10n.translate(AppStrings.status)}: ${_getStatusLabel(context, animal.status)}',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeSmall,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: AppConstants.iconSizeXSmall,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusLabel(BuildContext context, AnimalStatus status) {
    final l10n = AppLocalizations.of(context);
    switch (status) {
      case AnimalStatus.draft:
        return l10n.translate(AppStrings.draft);
      case AnimalStatus.alive:
        return l10n.translate(AppStrings.aliveStatus);
      case AnimalStatus.sold:
        return l10n.translate(AppStrings.soldStatus);
      case AnimalStatus.dead:
        return l10n.translate(AppStrings.deadStatus);
      case AnimalStatus.slaughtered:
        return l10n.translate(AppStrings.slaughteredStatus);
      case AnimalStatus.onTemporaryMovement:
        return l10n.translate(AppStrings.onTemporaryMovement);
    }
  }
}

/// Widget : Section pour animal inconnu
class _UnknownAnimalSection extends StatelessWidget {
  final String animalId;

  const _UnknownAnimalSection({required this.animalId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingSmall),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Colors.red),
          const SizedBox(width: AppConstants.spacingSmall),
          Expanded(
            child: Text(
              '${l10n.translate(AppStrings.animalNotFound)}\nID: $animalId',
              style: const TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget : Section d'informations générales
class _GeneralInfoSection extends StatelessWidget {
  final Movement movement;

  const _GeneralInfoSection({required this.movement});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(
          label: l10n.translate(AppStrings.date),
          value: DateFormat('dd/MM/yyyy HH:mm').format(movement.movementDate),
          icon: Icons.calendar_today,
        ),
        if (movement.fromFarmId != null) ...[
          const Divider(),
          _InfoRow(
            label: l10n.translate(AppStrings.fromFarm),
            value: movement.fromFarmId!,
            icon: Icons.source,
          ),
        ],
        if (movement.toFarmId != null) ...[
          const Divider(),
          _InfoRow(
            label: l10n.translate(AppStrings.toFarm),
            value: movement.toFarmId!,
            icon: Icons.place,
          ),
        ],
      ],
    );
  }
}

/// Widget : Section d'informations financières
class _FinancialInfoSection extends StatelessWidget {
  final Movement movement;

  const _FinancialInfoSection({required this.movement});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return _InfoRow(
      label: l10n.translate(AppStrings.price),
      value: '${movement.price!.toStringAsFixed(2)} ${l10n.translate(AppStrings.currency)}',
      icon: Icons.attach_money,
      valueStyle: const TextStyle(
        fontSize: AppConstants.fontSizeImportant,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
  }
}

/// Widget : Section de notes
class _NotesSection extends StatelessWidget {
  final String notes;

  const _NotesSection({required this.notes});

  @override
  Widget build(BuildContext context) {
    return Text(
      notes,
      style: const TextStyle(
        fontSize: AppConstants.fontSizeBody,
        height: 1.5,
      ),
    );
  }
}

/// Widget : Section d'informations de synchronisation
class _SyncInfoSection extends StatelessWidget {
  final Movement movement;

  const _SyncInfoSection({required this.movement});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(
          label: l10n.translate(AppStrings.syncStatus),
          value: movement.synced
              ? l10n.translate(AppStrings.synced)
              : l10n.translate(AppStrings.notSynced),
          icon: movement.synced ? Icons.check_circle : Icons.sync,
          valueColor: movement.synced ? Colors.green : Colors.orange,
        ),
        const Divider(),
        _InfoRow(
          label: l10n.translate(AppStrings.createdAt),
          value: DateFormat('dd/MM/yyyy HH:mm').format(movement.createdAt),
          icon: Icons.add_circle_outline,
        ),
        const Divider(),
        _InfoRow(
          label: l10n.translate(AppStrings.updatedAt),
          value: DateFormat('dd/MM/yyyy HH:mm').format(movement.updatedAt),
          icon: Icons.update,
        ),
        if (movement.lastSyncedAt != null) ...[
          const Divider(),
          _InfoRow(
            label: l10n.translate(AppStrings.lastSyncedAt),
            value: DateFormat('dd/MM/yyyy HH:mm').format(movement.lastSyncedAt!),
            icon: Icons.cloud_done,
          ),
        ],
      ],
    );
  }
}

/// Widget : Ligne d'information
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final TextStyle? valueStyle;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueStyle,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingTiny),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: AppConstants.iconSizeXSmall,
            color: Colors.grey[600],
          ),
          const SizedBox(width: AppConstants.spacingSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: AppConstants.spacingMicro),
                Text(
                  value,
                  style: valueStyle ??
                      TextStyle(
                        fontSize: AppConstants.fontSizeBody,
                        fontWeight: FontWeight.w600,
                        color: valueColor,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Dialog pour saisir la date de retour et les notes
class _ReturnDateDialog extends StatefulWidget {
  final Movement outMovement;

  const _ReturnDateDialog({required this.outMovement});

  @override
  State<_ReturnDateDialog> createState() => _ReturnDateDialogState();
}

class _ReturnDateDialogState extends State<_ReturnDateDialog> {
  late DateTime _returnDate;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _returnDate = DateTime.now();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _returnDate,
      firstDate: widget.outMovement.movementDate,
      lastDate: DateTime.now().add(const Duration(days: 1)),
      locale: const Locale('fr', 'FR'),
    );
    if (picked != null) {
      setState(() => _returnDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: const Text('Enregistrer le retour'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date de retour
            Text(
              'Date de retour *',
              style: TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            InkWell(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.all(AppConstants.spacingMedium),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 20),
                    const SizedBox(width: AppConstants.spacingSmall),
                    Text(
                      DateFormat('dd/MM/yyyy').format(_returnDate),
                      style: const TextStyle(fontSize: AppConstants.fontSizeBody),
                    ),
                    const Spacer(),
                    Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppConstants.spacingMediumLarge),

            // Notes (optionnel)
            Text(
              'Notes (optionnel)',
              style: TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            TextField(
              controller: _notesController,
              maxLines: 3,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Ex: Animal en bonne santé, aucun problème constaté',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
                ),
                contentPadding: const EdgeInsets.all(AppConstants.spacingMedium),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.translate(AppStrings.cancel)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'returnDate': _returnDate,
              'notes': _notesController.text.trim().isEmpty
                  ? null
                  : _notesController.text.trim(),
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
          child: const Text('Valider'),
        ),
      ],
    );
  }
}
