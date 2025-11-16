// lib/screens/movement/movement_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/movement_provider.dart';
import '../../providers/animal_provider.dart';
import '../../providers/batch_provider.dart';
import '../../models/movement.dart';
import '../../models/animal.dart';
import '../../models/batch.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';
import '../animal/animal_detail_screen.dart';
import 'return_animal_form_screen.dart';

class MovementDetailScreen extends StatelessWidget {
  final String movementId;

  const MovementDetailScreen({
    super.key,
    required this.movementId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final movementProvider = context.watch<MovementProvider>();
    final movement = movementProvider.getMovementById(movementId);

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

    // Déterminer s'il s'agit d'un lot ou d'un animal individuel
    final isBatch = movement.animalId.startsWith('batch_');
    final animalProvider = context.watch<AnimalProvider>();
    final batchProvider = context.watch<BatchProvider>();
    final animal = !isBatch ? animalProvider.getAnimalById(movement.animalId) : null;
    final batch = isBatch ? batchProvider.getBatchById(movement.animalId) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate(AppStrings.movementDetails)),
        actions: movement.type == MovementType.temporaryOut && !movement.isCompleted
            ? [
                IconButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReturnAnimalFormScreen(
                          movement: movement,
                        ),
                      ),
                    );
                    // Rafraîchir les données si le retour a été enregistré
                    if (result == true) {
                      movementProvider.refresh();
                    }
                  },
                  icon: const Icon(Icons.home_filled),
                  tooltip: 'Retour à la ferme',
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // En-tête avec type de mouvement
            _MovementTypeHeader(movement: movement),

            const SizedBox(height: AppConstants.spacingMediumLarge),

            // Section Animal ou Lot
            _SectionCard(
              title: isBatch
                  ? l10n.translate(AppStrings.batch)
                  : l10n.translate(AppStrings.animal),
              icon: isBatch ? Icons.workspaces : Icons.pets,
              color: Colors.blue,
              child: isBatch
                  ? (batch != null
                      ? _BatchInfoSection(batch: batch)
                      : _UnknownBatchSection(batchId: movement.animalId))
                  : (animal != null
                      ? _AnimalInfoSection(animal: animal)
                      : _UnknownAnimalSection(animalId: movement.animalId)),
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

            // Section Retour (si mouvement temporaire complété)
            if (movement.type == MovementType.temporaryOut && movement.isCompleted) ...[
              const SizedBox(height: AppConstants.spacingMedium),
              _SectionCard(
                title: 'Retour à la ferme',
                icon: Icons.home,
                color: Colors.green,
                child: _ReturnInfoSection(movement: movement),
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
          // Badge de statut pour les mouvements temporaires
          if (movement.type == MovementType.temporaryOut) ...[
            const SizedBox(height: AppConstants.spacingSmall),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: movement.isCompleted
                    ? Colors.white.withValues(alpha: 0.3)
                    : Colors.orange.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: Text(
                movement.isCompleted ? 'Complété' : 'En cours',
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeSmall,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getMovementTypeColor(MovementType type) {
    switch (type) {
      case MovementType.purchase:
        return Colors.blue;
      case MovementType.sale:
        return Colors.orange;
      case MovementType.death:
        return Colors.red;
      case MovementType.slaughter:
        return Colors.purple;
      case MovementType.temporaryOut:
        return Colors.teal;
    }
  }

  IconData _getMovementTypeIcon(MovementType type) {
    switch (type) {
      case MovementType.purchase:
        return Icons.shopping_cart;
      case MovementType.sale:
        return Icons.sell;
      case MovementType.death:
        return Icons.dangerous;
      case MovementType.slaughter:
        return Icons.content_cut;
      case MovementType.temporaryOut:
        return Icons.exit_to_app;
    }
  }

  String _getMovementTypeLabel(BuildContext context, MovementType type) {
    final l10n = AppLocalizations.of(context);
    switch (type) {
      case MovementType.purchase:
        return l10n.translate(AppStrings.purchase);
      case MovementType.sale:
        return l10n.translate(AppStrings.sale);
      case MovementType.death:
        return l10n.translate(AppStrings.death);
      case MovementType.slaughter:
        return l10n.translate(AppStrings.slaughter);
      case MovementType.temporaryOut:
        return l10n.translate(AppStrings.temporaryOut);
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

/// Widget : Section pour afficher les informations d'un lot
class _BatchInfoSection extends StatelessWidget {
  final Batch batch;

  const _BatchInfoSection({required this.batch});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingSmall),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
        border: Border.all(
          color: Colors.blue.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.workspaces,
                color: Colors.blue,
                size: AppConstants.iconSizeMedium,
              ),
              const SizedBox(width: AppConstants.spacingSmall),
              Expanded(
                child: Text(
                  batch.name,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSmall),
          Text(
            'Objectif: ${batch.purpose}',
            style: TextStyle(
              fontSize: AppConstants.fontSizeBody,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget : Section pour lot inconnu
class _UnknownBatchSection extends StatelessWidget {
  final String batchId;

  const _UnknownBatchSection({required this.batchId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
            size: AppConstants.iconSizeMedium,
          ),
          const SizedBox(width: AppConstants.spacingSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lot introuvable',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingTiny),
                Text(
                  'ID: $batchId',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: Colors.grey[600],
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

/// Widget : Section d'informations de retour
class _ReturnInfoSection extends StatelessWidget {
  final Movement movement;

  const _ReturnInfoSection({required this.movement});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(
          icon: Icons.event,
          label: 'Date de retour',
          value: movement.returnDate != null
              ? DateFormat('dd/MM/yyyy').format(movement.returnDate!)
              : 'N/A',
        ),
        if (movement.returnNotes != null && movement.returnNotes!.isNotEmpty) ...[
          const SizedBox(height: AppConstants.spacingSmall),
          const Divider(),
          const SizedBox(height: AppConstants.spacingSmall),
          _InfoRow(
            icon: Icons.notes,
            label: 'Notes de retour',
            value: movement.returnNotes!,
            maxLines: null,
          ),
        ],
      ],
    );
  }
}
