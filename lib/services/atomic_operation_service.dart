// lib/services/atomic_operation_service.dart
// Service pour les opérations atomiques (transactions database)
// Garantit l'intégrité des données lors d'opérations multi-entités

import 'package:drift/drift.dart';
import '../drift/database.dart';

/// Service pour les opérations atomiques sur la base de données
///
/// Ce service garantit que les opérations multi-entités sont exécutées
/// de manière atomique (tout ou rien) pour éviter les états incohérents.
///
/// Utilisation:
/// ```dart
/// final atomicService = AtomicOperationService(database);
/// await atomicService.executeBatchSale(...);
/// ```
class AtomicOperationService {
  final AppDatabase _db;

  AtomicOperationService(this._db);

  // ═══════════════════════════════════════════════════════════
  // SALE OPERATIONS
  // ═══════════════════════════════════════════════════════════

  /// Exécute une vente batch de manière atomique
  ///
  /// Cette opération:
  /// 1. Crée un mouvement de vente pour chaque animal
  /// 2. Met à jour le statut de chaque animal à "sold"
  ///
  /// Si une erreur survient, toutes les opérations sont annulées (rollback)
  ///
  /// Retourne le nombre d'animaux vendus avec succès
  Future<int> executeBatchSale({
    required String farmId,
    required List<String> animalIds,
    required DateTime saleDate,
    required String buyerName,
    String? buyerFarmId,
    String? lotId,
    double? pricePerAnimal,
    String? notes,
  }) async {
    return await _db.transaction(() async {
      int processedCount = 0;

      for (final animalId in animalIds) {
        // 1. Créer le mouvement de vente
        final movementId = '${DateTime.now().millisecondsSinceEpoch}_$animalId';

        await _db.movementDao.insertItem(
          MovementsTableCompanion.insert(
            id: movementId,
            farmId: farmId,
            animalId: animalId,
            lotId: Value(lotId),
            type: 'sale',
            status: 'ongoing',
            movementDate: saleDate,
            price: Value(pricePerAnimal),
            buyerName: Value(buyerName),
            buyerFarmId: Value(buyerFarmId),
            notes: Value(notes),
            synced: const Value(false),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        // 2. Mettre à jour le statut de l'animal
        await _db.animalDao.updateItem(
          AnimalsTableCompanion(
            id: Value(animalId),
            status: const Value('sold'),
            updatedAt: Value(DateTime.now()),
          ),
          farmId,
        );

        processedCount++;
      }

      return processedCount;
    });
  }

  /// Exécute une vente individuelle de manière atomique
  Future<void> executeSingleSale({
    required String farmId,
    required String animalId,
    required DateTime saleDate,
    required String buyerName,
    String? buyerFarmId,
    String? lotId,
    double? price,
    String? notes,
  }) async {
    await executeBatchSale(
      farmId: farmId,
      animalIds: [animalId],
      saleDate: saleDate,
      buyerName: buyerName,
      buyerFarmId: buyerFarmId,
      lotId: lotId,
      pricePerAnimal: price,
      notes: notes,
    );
  }

  // ═══════════════════════════════════════════════════════════
  // SLAUGHTER OPERATIONS
  // ═══════════════════════════════════════════════════════════

  /// Exécute un abattage batch de manière atomique
  ///
  /// Cette opération:
  /// 1. Crée un mouvement d'abattage pour chaque animal
  /// 2. Met à jour le statut de chaque animal à "slaughtered"
  ///
  /// Retourne le nombre d'animaux traités avec succès
  Future<int> executeBatchSlaughter({
    required String farmId,
    required List<String> animalIds,
    required DateTime slaughterDate,
    required String slaughterhouseName,
    String? slaughterhouseId,
    String? lotId,
    String? notes,
  }) async {
    return await _db.transaction(() async {
      int processedCount = 0;

      for (final animalId in animalIds) {
        // 1. Créer le mouvement d'abattage
        final movementId = '${DateTime.now().millisecondsSinceEpoch}_$animalId';

        await _db.movementDao.insertItem(
          MovementsTableCompanion.insert(
            id: movementId,
            farmId: farmId,
            animalId: animalId,
            lotId: Value(lotId),
            type: 'slaughter',
            status: 'closed',
            movementDate: slaughterDate,
            slaughterhouseName: Value(slaughterhouseName),
            slaughterhouseId: Value(slaughterhouseId),
            notes: Value(notes),
            synced: const Value(false),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        // 2. Mettre à jour le statut de l'animal
        await _db.animalDao.updateItem(
          AnimalsTableCompanion(
            id: Value(animalId),
            status: const Value('slaughtered'),
            updatedAt: Value(DateTime.now()),
          ),
          farmId,
        );

        processedCount++;
      }

      return processedCount;
    });
  }

  /// Exécute un abattage individuel de manière atomique
  Future<void> executeSingleSlaughter({
    required String farmId,
    required String animalId,
    required DateTime slaughterDate,
    required String slaughterhouseName,
    String? slaughterhouseId,
    String? lotId,
    String? notes,
  }) async {
    await executeBatchSlaughter(
      farmId: farmId,
      animalIds: [animalId],
      slaughterDate: slaughterDate,
      slaughterhouseName: slaughterhouseName,
      slaughterhouseId: slaughterhouseId,
      lotId: lotId,
      notes: notes,
    );
  }

  // ═══════════════════════════════════════════════════════════
  // DEATH OPERATIONS
  // ═══════════════════════════════════════════════════════════

  /// Enregistre la mort d'un animal de manière atomique
  ///
  /// Cette opération:
  /// 1. Crée un mouvement de mort
  /// 2. Met à jour le statut de l'animal à "dead"
  Future<void> executeDeathRegistration({
    required String farmId,
    required String animalId,
    required DateTime deathDate,
    String? notes,
  }) async {
    await _db.transaction(() async {
      // 1. Créer le mouvement de mort
      final movementId = DateTime.now().millisecondsSinceEpoch.toString();

      await _db.movementDao.insertItem(
        MovementsTableCompanion.insert(
          id: movementId,
          farmId: farmId,
          animalId: animalId,
          type: 'death',
          status: 'closed',
          movementDate: deathDate,
          notes: Value(notes),
          synced: const Value(false),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      // 2. Mettre à jour le statut de l'animal
      await _db.animalDao.updateItem(
        AnimalsTableCompanion(
          id: Value(animalId),
          status: const Value('dead'),
          updatedAt: Value(DateTime.now()),
        ),
        farmId,
      );
    });
  }

  // ═══════════════════════════════════════════════════════════
  // PURCHASE/BIRTH OPERATIONS
  // ═══════════════════════════════════════════════════════════

  /// Enregistre un achat d'animal de manière atomique
  ///
  /// Cette opération:
  /// 1. Crée l'animal dans la base de données
  /// 2. Crée le mouvement d'achat associé
  ///
  /// Retourne l'ID de l'animal créé
  Future<String> executePurchaseRegistration({
    required AnimalsTableCompanion animal,
    required String farmId,
    String? fromFarmId,
    double? price,
    String? notes,
  }) async {
    return await _db.transaction(() async {
      final animalId = animal.id.value;

      // 1. Créer l'animal
      await _db.animalDao.insertItem(animal);

      // 2. Créer le mouvement d'achat
      final movementId = DateTime.now().millisecondsSinceEpoch.toString();

      await _db.movementDao.insertItem(
        MovementsTableCompanion.insert(
          id: movementId,
          farmId: farmId,
          animalId: animalId,
          type: 'purchase',
          status: 'closed',
          movementDate: DateTime.now(),
          fromFarmId: Value(fromFarmId),
          price: Value(price),
          notes: Value(notes),
          synced: const Value(false),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      return animalId;
    });
  }

  // ═══════════════════════════════════════════════════════════
  // MEDICAL OPERATIONS
  // ═══════════════════════════════════════════════════════════

  /// Applique un traitement à plusieurs animaux de manière atomique
  ///
  /// Cette opération crée un enregistrement de traitement pour chaque animal
  /// Si une erreur survient, tous les traitements sont annulés
  ///
  /// Retourne le nombre de traitements créés
  Future<int> executeBatchTreatment({
    required String farmId,
    required List<String> animalIds,
    required List<TreatmentsTableCompanion> treatments,
  }) async {
    if (animalIds.length != treatments.length) {
      throw ArgumentError('animalIds and treatments must have the same length');
    }

    return await _db.transaction(() async {
      int processedCount = 0;

      for (int i = 0; i < treatments.length; i++) {
        await _db.treatmentDao.insertItem(treatments[i]);
        processedCount++;
      }

      return processedCount;
    });
  }

  // ═══════════════════════════════════════════════════════════
  // UTILITY METHODS
  // ═══════════════════════════════════════════════════════════

  /// Exécute une opération personnalisée dans une transaction
  ///
  /// Permet d'exécuter n'importe quelle opération de manière atomique
  ///
  /// Exemple:
  /// ```dart
  /// await atomicService.executeInTransaction(() async {
  ///   await dao1.insert(...);
  ///   await dao2.update(...);
  /// });
  /// ```
  Future<T> executeInTransaction<T>(Future<T> Function() operation) async {
    return await _db.transaction(operation);
  }
}
