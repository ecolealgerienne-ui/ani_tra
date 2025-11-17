// lib/screens/movement/movement_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/movement_provider.dart';
import '../../providers/animal_provider.dart';
import '../../providers/lot_provider.dart';
import '../../models/movement.dart';
import '../../models/lot.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';
import 'movement_detail_screen.dart';
import 'create_temporary_movement_screen.dart';
import '../lot/lot_detail_screen.dart';

class MovementListScreen extends StatefulWidget {
  const MovementListScreen({super.key});

  @override
  State<MovementListScreen> createState() => _MovementListScreenState();
}

class _MovementListScreenState extends State<MovementListScreen> {
  MovementType? _selectedTypeFilter;
  bool _isGroupedByLot = false; // Toggle entre vue individuelle et regroupée

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate(AppStrings.movements)),
        actions: [
          // Toggle vue individuelle / regroupée
          IconButton(
            icon: Icon(_isGroupedByLot ? Icons.list : Icons.group_work),
            tooltip: _isGroupedByLot
                ? 'Vue individuelle'
                : 'Regrouper par lot',
            onPressed: () {
              setState(() {
                _isGroupedByLot = !_isGroupedByLot;
              });
            },
          ),
          // Bouton de filtrage par type
          PopupMenuButton<MovementType?>(
            icon: const Icon(Icons.filter_list),
            tooltip: l10n.translate(AppStrings.filterByType),
            onSelected: (type) {
              setState(() {
                _selectedTypeFilter = type;
              });
              // Si null (Tous), on efface tous les filtres
              if (type == null) {
                context.read<MovementProvider>().clearFilters();
              } else {
                context.read<MovementProvider>().setTypeFilter(type);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<MovementType?>(
                value: null,
                child: Row(
                  children: [
                    const Icon(Icons.clear_all),
                    const SizedBox(width: AppConstants.spacingSmall),
                    Expanded(child: Text(l10n.translate(AppStrings.all))),
                    if (_selectedTypeFilter == null)
                      const Icon(Icons.check, color: Colors.green),
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
                    Expanded(child: Text(l10n.translate(AppStrings.purchases))),
                    if (_selectedTypeFilter == MovementType.purchase)
                      const Icon(Icons.check, color: Colors.green),
                  ],
                ),
              ),
              PopupMenuItem<MovementType>(
                value: MovementType.sale,
                child: Row(
                  children: [
                    const Icon(Icons.sell, color: Colors.orange),
                    const SizedBox(width: AppConstants.spacingSmall),
                    Expanded(child: Text(l10n.translate(AppStrings.sales))),
                    if (_selectedTypeFilter == MovementType.sale)
                      const Icon(Icons.check, color: Colors.green),
                  ],
                ),
              ),
              PopupMenuItem<MovementType>(
                value: MovementType.death,
                child: Row(
                  children: [
                    const Icon(Icons.dangerous, color: Colors.red),
                    const SizedBox(width: AppConstants.spacingSmall),
                    Expanded(child: Text(l10n.translate(AppStrings.deaths))),
                    if (_selectedTypeFilter == MovementType.death)
                      const Icon(Icons.check, color: Colors.green),
                  ],
                ),
              ),
              PopupMenuItem<MovementType>(
                value: MovementType.slaughter,
                child: Row(
                  children: [
                    const Icon(Icons.content_cut, color: Colors.purple),
                    const SizedBox(width: AppConstants.spacingSmall),
                    Expanded(child: Text(l10n.translate(AppStrings.slaughters))),
                    if (_selectedTypeFilter == MovementType.slaughter)
                      const Icon(Icons.check, color: Colors.green),
                  ],
                ),
              ),
              PopupMenuItem<MovementType>(
                value: MovementType.temporaryOut,
                child: Row(
                  children: [
                    const Icon(Icons.exit_to_app, color: Colors.teal),
                    const SizedBox(width: AppConstants.spacingSmall),
                    Expanded(child: Text(l10n.translate(AppStrings.temporaryOuts))),
                    if (_selectedTypeFilter == MovementType.temporaryOut)
                      const Icon(Icons.check, color: Colors.green),
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
            child: Consumer2<MovementProvider, LotProvider>(
              builder: (context, movementProvider, lotProvider, child) {
                if (movementProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Filtrer pour exclure les naissances (ce ne sont pas de vrais mouvements)
                final movements = movementProvider.filteredMovements
                    .where((m) => m.type != MovementType.birth)
                    .toList();

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

                // Vue conditionnelle: individuelle ou regroupée
                return RefreshIndicator(
                  onRefresh: () => movementProvider.refresh(),
                  child: _isGroupedByLot
                      ? _buildGroupedView(movements, lotProvider, l10n)
                      : _buildIndividualView(movements, l10n),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTemporaryMovementScreen(),
            ),
          );

          if (result != null && mounted) {
            // Rafraîchir la liste des mouvements
            context.read<MovementProvider>().refresh();
          }
        },
        icon: const Icon(Icons.exit_to_app),
        label: Text(l10n.translate(AppStrings.temporaryOuts)),
        backgroundColor: Colors.teal,
      ),
    );
  }

  /// Retourne la couleur associée au type de mouvement
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
      case MovementType.temporaryOut:
        return Colors.teal;
      case MovementType.temporaryReturn:
        return Colors.cyan;
    }
  }

  /// Retourne l'icône associée au type de mouvement
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
      case MovementType.temporaryOut:
        return Icons.exit_to_app;
      case MovementType.temporaryReturn:
        return Icons.keyboard_return;
    }
  }

  /// Retourne le label traduit du type de mouvement
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
      case MovementType.temporaryOut:
        return l10n.translate(AppStrings.temporaryOuts);
      case MovementType.temporaryReturn:
        return l10n.translate(AppStrings.temporaryReturn);
    }
  }

  /// Vue individuelle: Liste des mouvements sans lotId (vraiment individuels)
  Widget _buildIndividualView(List<Movement> movements, AppLocalizations l10n) {
    // Filtrer uniquement les mouvements sans lotId (individuels)
    final individualMovements = movements.where((m) => m.lotId == null).toList();

    if (individualMovements.isEmpty) {
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
              'Les mouvements individuels apparaîtront ici',
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

    return ListView.separated(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      itemCount: individualMovements.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppConstants.spacingSmall),
      itemBuilder: (context, index) {
        final movement = individualMovements[index];
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
    );
  }

  /// Vue regroupée: Mouvements groupés par lot
  Widget _buildGroupedView(
      List<Movement> movements, LotProvider lotProvider, AppLocalizations l10n) {
    // DEBUG: Log movements and lots
    print('🔍 [GroupedView] ========== DEBUG START ==========');
    print('🔍 [GroupedView] Total movements: ${movements.length}');
    print('🔍 [GroupedView] Available lots in provider: ${lotProvider.lots.length}');
    for (final lot in lotProvider.lots) {
      print('🔍 [GroupedView] Lot: ${lot.id} - ${lot.name} (status: ${lot.status})');
    }
    print('🔍 [GroupedView] Movement details:');
    for (final m in movements) {
      print('  - Movement ${m.id}: animalId=${m.animalId}, lotId=${m.lotId ?? "NULL"}, type=${m.type}');
    }

    // Filtrer uniquement les mouvements de lots
    final lotMovements =
        movements.where((m) => m.lotId != null).toList();

    print('🔍 [GroupedView] Movements with lotId: ${lotMovements.length}');

    // Grouper par lotId
    final Map<String, List<Movement>> groupedByLot = {};
    for (final movement in lotMovements) {
      final lotId = movement.lotId!;
      print('🔍 [GroupedView] Found movement with lotId: $lotId');
      if (!groupedByLot.containsKey(lotId)) {
        groupedByLot[lotId] = [];
      }
      groupedByLot[lotId]!.add(movement);
    }

    print('🔍 [GroupedView] Number of lot groups: ${groupedByLot.length}');
    print('🔍 [GroupedView] Lot IDs found: ${groupedByLot.keys.toList()}');
    print('🔍 [GroupedView] ========== DEBUG END ==========');

    return ListView(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      children: [
        // Affichage des lots uniquement (pas de mouvements individuels)
        if (groupedByLot.isNotEmpty) ...[
          Text(
            'Mouvements de lots',
            style: TextStyle(
              fontSize: AppConstants.fontSizeLarge,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          ...groupedByLot.entries.map((entry) {
            final lotId = entry.key;
            final lotMovementsList = entry.value;
            final lot = lotProvider.getLotById(lotId);

            return _LotMovementCard(
              lot: lot,
              lotId: lotId,
              movements: lotMovementsList,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LotDetailScreen(lotId: lotId),
                  ),
                );
              },
            );
          }).toList(),
        ],

        // Message si aucun lot
        if (groupedByLot.isEmpty) ...[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingLarge),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.group_work,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: AppConstants.spacingMedium),
                  Text(
                    'Aucun lot finalisé',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingSmall),
                  Text(
                    'Les mouvements issus de lots finalisés\napparaîtront ici',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeBody,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
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
      case MovementType.temporaryOut:
        return Colors.teal;
      case MovementType.temporaryReturn:
        return Colors.cyan;
    }
  }

  /// Retourne l'icône associée au type de mouvement
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
      case MovementType.temporaryOut:
        return Icons.exit_to_app;
      case MovementType.temporaryReturn:
        return Icons.keyboard_return;
    }
  }

  /// Retourne le label traduit du type de mouvement
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
      case MovementType.temporaryOut:
        return l10n.translate(AppStrings.temporaryOuts);
      case MovementType.temporaryReturn:
        return l10n.translate(AppStrings.temporaryReturn);
    }
  }
}

/// Widget : Carte d'affichage d'un lot avec ses mouvements
class _LotMovementCard extends StatelessWidget {
  final Lot? lot;
  final String lotId;
  final List<Movement> movements;
  final VoidCallback onTap;

  const _LotMovementCard({
    required this.lot,
    required this.lotId,
    required this.movements,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final movementStatus = movements.isNotEmpty ? movements.first.status : null;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Nom du lot + type
              Row(
                children: [
                  Icon(
                    _getTypeIcon(lot?.type),
                    color: _getTypeColor(lot?.type),
                    size: AppConstants.iconSizeLarge,
                  ),
                  const SizedBox(width: AppConstants.spacingSmall),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lot?.name ?? 'Lot inconnu',
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeLarge,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (lot?.type != null)
                          Text(
                            lot!.type!.label,
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeBody,
                              color: _getTypeColor(lot?.type),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Badge statut
                  if (movementStatus != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingSmall,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(movementStatus).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
                      ),
                      child: Text(
                        movementStatus.name,
                        style: TextStyle(
                          color: _getStatusColor(movementStatus),
                          fontSize: AppConstants.fontSizeSmall,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingMedium),

              // Infos: nombre d'animaux + prix total
              Row(
                children: [
                  Icon(
                    Icons.pets,
                    size: AppConstants.iconSizeRegular,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: AppConstants.spacingSmall),
                  Text(
                    '${movements.length} animaux',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeBody,
                      color: Colors.grey[700],
                    ),
                  ),
                  if (lot?.priceTotal != null) ...[
                    const SizedBox(width: AppConstants.spacingMedium),
                    Icon(
                      Icons.euro,
                      size: AppConstants.iconSizeRegular,
                      color: Colors.green[700],
                    ),
                    const SizedBox(width: AppConstants.spacingSmall),
                    Text(
                      '${lot!.priceTotal!.toStringAsFixed(2)}€',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeBody,
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),

              // Date
              if (lot?.completedAt != null) ...[
                const SizedBox(height: AppConstants.spacingSmall),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: AppConstants.iconSizeSmall,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: AppConstants.spacingSmall),
                    Text(
                      DateFormat('dd/MM/yyyy').format(lot!.completedAt!),
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(LotType? type) {
    if (type == null) return Icons.help_outline;
    switch (type) {
      case LotType.treatment:
        return Icons.medical_services;
      case LotType.purchase:
        return Icons.shopping_cart;
      case LotType.sale:
        return Icons.sell;
      case LotType.slaughter:
        return Icons.content_cut;
    }
  }

  Color _getTypeColor(LotType? type) {
    if (type == null) return Colors.grey;
    switch (type) {
      case LotType.treatment:
        return AppConstants.primaryBlue;
      case LotType.purchase:
        return Colors.blue;
      case LotType.sale:
        return AppConstants.successGreen;
      case LotType.slaughter:
        return Colors.purple;
    }
  }

  Color _getStatusColor(MovementStatus status) {
    switch (status) {
      case MovementStatus.ongoing:
        return Colors.orange;
      case MovementStatus.closed:
        return Colors.green;
      case MovementStatus.archived:
        return Colors.grey;
    }
  }
}
