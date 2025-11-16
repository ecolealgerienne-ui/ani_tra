// lib/screens/movement/movement_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/movement_provider.dart';
import '../../providers/animal_provider.dart';
import '../../models/movement.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';
import 'movement_detail_screen.dart';

class MovementListScreen extends StatefulWidget {
  const MovementListScreen({super.key});

  @override
  State<MovementListScreen> createState() => _MovementListScreenState();
}

class _MovementListScreenState extends State<MovementListScreen> {
  MovementType? _selectedTypeFilter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate(AppStrings.movements)),
        actions: [
          // Bouton de filtrage par type
          PopupMenuButton<MovementType?>(
            icon: const Icon(Icons.filter_list),
            tooltip: l10n.translate(AppStrings.filterByType),
            onSelected: (type) {
              setState(() {
                _selectedTypeFilter = type;
              });
              context.read<MovementProvider>().setTypeFilter(type);
            },
            itemBuilder: (context) => [
              PopupMenuItem<MovementType?>(
                value: null,
                child: Row(
                  children: [
                    const Icon(Icons.clear_all),
                    const SizedBox(width: AppConstants.spacingSmall),
                    Text(l10n.translate(AppStrings.all)),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<MovementType>(
                value: MovementType.purchase,
                child: Row(
                  children: [
                    const Icon(Icons.shopping_cart, color: Colors.blue),
                    const SizedBox(width: AppConstants.spacingSmall),
                    Text(l10n.translate(AppStrings.purchases)),
                  ],
                ),
              ),
              PopupMenuItem<MovementType>(
                value: MovementType.sale,
                child: Row(
                  children: [
                    const Icon(Icons.sell, color: Colors.orange),
                    const SizedBox(width: AppConstants.spacingSmall),
                    Text(l10n.translate(AppStrings.sales)),
                  ],
                ),
              ),
              PopupMenuItem<MovementType>(
                value: MovementType.death,
                child: Row(
                  children: [
                    const Icon(Icons.dangerous, color: Colors.red),
                    const SizedBox(width: AppConstants.spacingSmall),
                    Text(l10n.translate(AppStrings.deaths)),
                  ],
                ),
              ),
              PopupMenuItem<MovementType>(
                value: MovementType.slaughter,
                child: Row(
                  children: [
                    const Icon(Icons.content_cut, color: Colors.purple),
                    const SizedBox(width: AppConstants.spacingSmall),
                    Text(l10n.translate(AppStrings.slaughters)),
                  ],
                ),
              ),
              PopupMenuItem<MovementType>(
                value: MovementType.temporaryOut,
                child: Row(
                  children: [
                    const Icon(Icons.exit_to_app, color: Colors.teal),
                    const SizedBox(width: AppConstants.spacingSmall),
                    Text(l10n.translate(AppStrings.temporaryOuts)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Bandeau de filtre actif
          if (_selectedTypeFilter != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingMedium,
                vertical: AppConstants.spacingSmall,
              ),
              decoration: BoxDecoration(
                color: _getMovementTypeColor(_selectedTypeFilter!).withValues(alpha: 0.1),
                border: Border(
                  bottom: BorderSide(
                    color: _getMovementTypeColor(_selectedTypeFilter!),
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getMovementTypeIcon(_selectedTypeFilter!),
                    color: _getMovementTypeColor(_selectedTypeFilter!),
                    size: AppConstants.iconSizeRegular,
                  ),
                  const SizedBox(width: AppConstants.spacingSmall),
                  Expanded(
                    child: Text(
                      '${l10n.translate(AppStrings.filter)}: ${_getMovementTypeLabel(context, _selectedTypeFilter!)}',
                      style: TextStyle(
                        color: _getMovementTypeColor(_selectedTypeFilter!),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedTypeFilter = null;
                      });
                      context.read<MovementProvider>().clearFilters();
                    },
                    icon: const Icon(Icons.clear, size: AppConstants.iconSizeXSmall),
                    label: Text(l10n.translate(AppStrings.clear)),
                  ),
                ],
              ),
            ),

          // Liste des mouvements
          Expanded(
            child: Consumer<MovementProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final movements = provider.filteredMovements;

                if (movements.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sync_alt,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: AppConstants.spacingMedium),
                        Text(
                          l10n.translate(AppStrings.noMovements),
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeLarge,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingSmall),
                        Text(
                          l10n.translate(AppStrings.noMovementsSubtitle),
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeBody,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => provider.refresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppConstants.spacingMedium),
                    itemCount: movements.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppConstants.spacingSmall),
                    itemBuilder: (context, index) {
                      final movement = movements[index];
                      return _MovementCard(
                        movement: movement,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MovementDetailScreen(movementId: movement.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Retourne la couleur associée au type de mouvement
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

  /// Retourne l'icône associée au type de mouvement
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

  /// Retourne le label traduit du type de mouvement
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

/// Widget : Carte d'affichage d'un mouvement
class _MovementCard extends StatelessWidget {
  final Movement movement;
  final VoidCallback onTap;

  const _MovementCard({
    required this.movement,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final animal = context.read<AnimalProvider>().getAnimalById(movement.animalId);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
          border: Border.all(
            color: _getMovementTypeColor(movement.type).withValues(alpha: 0.3),
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
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          child: Row(
            children: [
              // Icône du type de mouvement
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getMovementTypeColor(movement.type).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
                ),
                child: Icon(
                  _getMovementTypeIcon(movement.type),
                  color: _getMovementTypeColor(movement.type),
                  size: AppConstants.iconSizeMedium,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),

              // Informations
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type de mouvement
                    Text(
                      _getMovementTypeLabel(context, movement.type),
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeLarge,
                        fontWeight: FontWeight.bold,
                        color: _getMovementTypeColor(movement.type),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingTiny),

                    // Animal
                    Row(
                      children: [
                        const Icon(
                          Icons.pets,
                          size: AppConstants.iconSizeXSmall,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: AppConstants.spacingTiny),
                        Flexible(
                          child: Text(
                            animal?.currentEid ?? animal?.officialNumber ?? movement.animalId,
                            style: const TextStyle(
                              fontSize: AppConstants.fontSizeBody,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingTiny),

                    // Date
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: AppConstants.iconSizeXSmall,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: AppConstants.spacingTiny),
                        Text(
                          DateFormat('dd/MM/yyyy').format(movement.movementDate),
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeSmall,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    // Prix (si disponible)
                    if (movement.price != null) ...[
                      const SizedBox(height: AppConstants.spacingTiny),
                      Row(
                        children: [
                          const Icon(
                            Icons.attach_money,
                            size: AppConstants.iconSizeXSmall,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: AppConstants.spacingTiny),
                          Text(
                            '${movement.price!.toStringAsFixed(2)} ${l10n.translate(AppStrings.currency)}',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeSmall,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Badge de statut de sync
              if (!movement.synced)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.sync,
                    size: AppConstants.iconSizeXSmall,
                    color: Colors.orange,
                  ),
                ),

              const SizedBox(width: AppConstants.spacingSmall),

              // Flèche
              Icon(
                Icons.arrow_forward_ios,
                size: AppConstants.iconSizeXSmall,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Retourne la couleur associée au type de mouvement
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

  /// Retourne l'icône associée au type de mouvement
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

  /// Retourne le label traduit du type de mouvement
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
