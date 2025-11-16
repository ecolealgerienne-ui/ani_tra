// lib/migrations/lot_to_movement_migration.dart

import 'package:uuid/uuid.dart';
import '../models/lot.dart';
import '../models/movement.dart';
import '../providers/lot_provider.dart';
import '../providers/movement_provider.dart';

/// Migration utility pour créer les Movement records manquants
/// pour les lots finalisés avant la Phase 3 (Movement enrichment)
///
/// **Contexte** :
/// - Avant Phase 3, les lots de vente/abattage ne créaient pas de Movement records
/// - Phase 3 a introduit la création automatique de movements lors de la finalisation
/// - Cette migration one-time crée les movements manquants pour les lots historiques
///
/// **Usage** :
/// ```dart
/// final migrator = LotToMovementMigration(
///   lotProvider: lotProvider,
///   movementProvider: movementProvider,
/// );
/// final result = await migrator.migrateOrphanedLots(farmId);
/// print('Migrated ${result.migratedCount} lots');
/// ```
class LotToMovementMigration {
  final LotProvider lotProvider;
  final MovementProvider movementProvider;
  final Uuid uuid = const Uuid();

  LotToMovementMigration({
    required this.lotProvider,
    required this.movementProvider,
  });

  /// Résultat de la migration
  class MigrationResult {
    final int totalClosedLots;
    final int lotsWithMovements;
    final int orphanedLots;
    final int migratedCount;
    final int failedCount;
    final List<String> errors;

    MigrationResult({
      required this.totalClosedLots,
      required this.lotsWithMovements,
      required this.orphanedLots,
      required this.migratedCount,
      required this.failedCount,
      required this.errors,
    });

    @override
    String toString() {
      return '''
Migration Result:
- Total closed/archived lots: $totalClosedLots
- Lots with existing movements: $lotsWithMovements
- Orphaned lots (no movements): $orphanedLots
- Successfully migrated: $migratedCount
- Failed: $failedCount
${errors.isNotEmpty ? '- Errors:\n  ${errors.join('\n  ')}' : ''}
''';
    }
  }

  /// Migre tous les lots orphelins (fermés mais sans movements)
  ///
  /// Trouve les lots avec status=closed ou archived qui n'ont pas
  /// de Movement records associés, et crée les movements manquants
  Future<MigrationResult> migrateOrphanedLots(String farmId) async {
    final errors = <String>[];
    int totalClosedLots = 0;
    int lotsWithMovements = 0;
    int orphanedLots = 0;
    int migratedCount = 0;
    int failedCount = 0;

    try {
      // 1. Récupérer tous les lots fermés/archivés
      final closedLots = lotProvider.closedLots;
      final archivedLots = lotProvider.archivedLots;
      final allFinalizedLots = [...closedLots, ...archivedLots];

      totalClosedLots = allFinalizedLots.length;
      print('[Migration] Found $totalClosedLots finalized lots');

      // 2. Pour chaque lot, vérifier s'il a des movements
      for (final lot in allFinalizedLots) {
        try {
          // Ignorer les lots de traitement (ils créent des Treatment, pas Movement)
          if (lot.type == LotType.treatment) {
            continue;
          }

          // Vérifier s'il existe déjà des movements pour ce lot
          final hasMovements = await _hasExistingMovements(lot);

          if (hasMovements) {
            lotsWithMovements++;
            print('[Migration] Lot ${lot.id} (${lot.name}) already has movements');
            continue;
          }

          // Lot orphelin détecté
          orphanedLots++;
          print('[Migration] ⚠️  Orphaned lot detected: ${lot.id} (${lot.name})');

          // 3. Créer les movements manquants
          final success = await _createMovementsForLot(lot, farmId);

          if (success) {
            migratedCount++;
            print('[Migration] ✅ Successfully migrated lot ${lot.id} (${lot.name})');
          } else {
            failedCount++;
            errors.add('Failed to migrate lot ${lot.id} (${lot.name})');
          }
        } catch (e) {
          failedCount++;
          final errorMsg = 'Error migrating lot ${lot.id}: $e';
          errors.add(errorMsg);
          print('[Migration] ❌ $errorMsg');
        }
      }
    } catch (e) {
      final errorMsg = 'Fatal error during migration: $e';
      errors.add(errorMsg);
      print('[Migration] ❌ $errorMsg');
    }

    final result = MigrationResult(
      totalClosedLots: totalClosedLots,
      lotsWithMovements: lotsWithMovements,
      orphanedLots: orphanedLots,
      migratedCount: migratedCount,
      failedCount: failedCount,
      errors: errors,
    );

    print(result.toString());
    return result;
  }

  /// Vérifie si un lot a déjà des Movement records
  ///
  /// Recherche des movements dont l'animalId est dans lot.animalIds
  /// et dont la date correspond approximativement à la date du lot
  Future<bool> _hasExistingMovements(Lot lot) async {
    if (lot.animalIds.isEmpty) return false;

    // Prendre le premier animal du lot comme échantillon
    final sampleAnimalId = lot.animalIds.first;

    // Récupérer tous les movements de cet animal
    final movements =
        await movementProvider.getMovementsByAnimalId(sampleAnimalId);

    if (movements.isEmpty) return false;

    // Vérifier s'il existe un movement correspondant au type du lot
    // avec une date proche de completedAt
    for (final movement in movements) {
      final isMatchingType = _isMatchingMovementType(lot.type, movement.type);
      if (!isMatchingType) continue;

      // Vérifier la date (tolérance de 1 jour)
      if (lot.completedAt != null) {
        final daysDiff =
            movement.movementDate.difference(lot.completedAt!).inDays.abs();
        if (daysDiff <= 1) {
          return true; // Movement trouvé !
        }
      }
    }

    return false;
  }

  /// Vérifie si le type de movement correspond au type de lot
  bool _isMatchingMovementType(LotType? lotType, MovementType movementType) {
    if (lotType == null) return false;

    switch (lotType) {
      case LotType.sale:
        return movementType == MovementType.sale;
      case LotType.slaughter:
        return movementType == MovementType.slaughter;
      case LotType.treatment:
        return false; // Les traitements ne créent pas de Movement
    }
  }

  /// Crée les Movement records pour un lot orphelin
  Future<bool> _createMovementsForLot(Lot lot, String farmId) async {
    try {
      List<Movement> movements = [];

      // Générer les movements selon le type
      switch (lot.type) {
        case LotType.sale:
          movements = _createSaleMovements(lot, farmId);
          break;
        case LotType.slaughter:
          movements = _createSlaughterMovements(lot, farmId);
          break;
        case LotType.treatment:
        case null:
          print(
              '[Migration] ⚠️  Cannot create movements for lot type: ${lot.type}');
          return false;
      }

      // Sauvegarder chaque movement
      for (final movement in movements) {
        await movementProvider.createMovement(movement);
      }

      print('[Migration] Created ${movements.length} movements for lot ${lot.id}');
      return true;
    } catch (e) {
      print('[Migration] ❌ Failed to create movements for lot ${lot.id}: $e');
      return false;
    }
  }

  /// Crée les movements de vente à partir d'un lot
  ///
  /// Utilise les champs deprecated de Lot pour construire les Movement
  /// avec les nouveaux champs structurés
  List<Movement> _createSaleMovements(Lot lot, String farmId) {
    // Détermine le type d'acheteur
    String? buyerType;
    // ignore: deprecated_member_use
    if (lot.buyerFarmId != null && lot.buyerFarmId!.isNotEmpty) {
      buyerType = 'farm';
      // ignore: deprecated_member_use
    } else if (lot.buyerName != null && lot.buyerName!.isNotEmpty) {
      buyerType = 'individual';
    }

    return lot.animalIds.map((animalId) {
      return Movement(
        id: uuid.v4(),
        farmId: farmId,
        animalId: animalId,
        type: MovementType.sale,
        // ignore: deprecated_member_use
        movementDate: lot.saleDate ?? lot.completedAt ?? DateTime.now(),
        // ignore: deprecated_member_use
        toFarmId: lot.buyerFarmId,
        // ignore: deprecated_member_use
        price: lot.pricePerAnimal,
        // Phase 3: Utilise les champs structurés
        // ignore: deprecated_member_use
        buyerName: lot.buyerName,
        // ignore: deprecated_member_use
        buyerFarmId: lot.buyerFarmId,
        buyerType: buyerType,
        notes: lot.notes,
        synced: false,
        createdAt: lot.completedAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }).toList();
  }

  /// Crée les movements d'abattage à partir d'un lot
  ///
  /// Utilise les champs deprecated de Lot pour construire les Movement
  /// avec les nouveaux champs structurés
  List<Movement> _createSlaughterMovements(Lot lot, String farmId) {
    return lot.animalIds.map((animalId) {
      return Movement(
        id: uuid.v4(),
        farmId: farmId,
        animalId: animalId,
        type: MovementType.slaughter,
        // ignore: deprecated_member_use
        movementDate: lot.slaughterDate ?? lot.completedAt ?? DateTime.now(),
        // Phase 3: Utilise les champs structurés
        // ignore: deprecated_member_use
        slaughterhouseName: lot.slaughterhouseName,
        // ignore: deprecated_member_use
        slaughterhouseId: lot.slaughterhouseId,
        notes: lot.notes,
        synced: false,
        createdAt: lot.completedAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }).toList();
  }
}
