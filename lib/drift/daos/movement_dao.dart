// lib/drift/daos/movement_dao.dart

import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/movements_table.dart';

part 'movement_dao.g.dart';

/// DAO pour la gestion des mouvements d'animaux
/// 
/// Gère les opérations CRUD sur les mouvements avec:
/// - Filtrage par farmId (multi-tenancy)
/// - Filtrage par animal
/// - Filtrage par type de mouvement
/// - Soft-delete (audit trail)
/// - Support de synchronisation (Phase 2)
@DriftAccessor(tables: [MovementsTable])
class MovementDao extends DatabaseAccessor<AppDatabase> with _$MovementDaoMixin {
  MovementDao(super.db);

  // === REQUIRED METHODS ===

  /// Récupère tous les mouvements d'une ferme (non supprimés)
  /// 
  /// Filtre par:
  /// - farmId (multi-tenancy)
  /// - deletedAt IS NULL (soft-delete)
  /// Tri par date décroissante (plus récents d'abord)
  Future<List<MovementsTableData>> findByFarmId(String farmId) {
    return (select(movementsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.movementDate, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Récupère un mouvement par ID avec vérification farmId
  /// 
  /// Security: Vérifie que le mouvement appartient bien à la ferme
  Future<MovementsTableData?> findById(String id, String farmId) {
    return (select(movementsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Insère un nouveau mouvement
  Future<int> insertItem(MovementsTableCompanion item) {
    return into(movementsTable).insert(item);
  }

  /// Met à jour un mouvement existant
  /// 
  /// IMPORTANT: Requiert farmId pour la sécurité multi-tenancy
  Future<int> updateItem(MovementsTableCompanion item, String farmId) {
    return (update(movementsTable)
          ..where((t) => t.id.equals(item.id.value))
          ..where((t) => t.farmId.equals(farmId)))
        .write(item);
  }

  /// Soft-delete d'un mouvement
  /// 
  /// Ne supprime pas physiquement, marque comme supprimé
  /// pour garder l'audit trail et la traçabilité
  Future<int> softDelete(String id, String farmId) {
    return (update(movementsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(MovementsTableCompanion(
      deletedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // === SYNC METHODS (Phase 2 ready) ===

  /// Récupère les mouvements non synchronisés
  Future<List<MovementsTableData>> getUnsynced(String farmId) {
    return (select(movementsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.synced.equals(false))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  /// Marque un mouvement comme synchronisé
  Future<int> markSynced(String id, String farmId, int serverVersion) {
    return (update(movementsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(MovementsTableCompanion(
      synced: const Value(true),
      lastSyncedAt: Value(DateTime.now()),
      serverVersion: Value(serverVersion),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // === BUSINESS QUERIES ===

  /// Récupère les mouvements d'un animal
  /// 
  /// Tri chronologique décroissant (plus récents d'abord)
  Future<List<MovementsTableData>> findByAnimalId(
    String farmId,
    String animalId,
  ) {
    return (select(movementsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.animalId.equals(animalId))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.movementDate, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Récupère les mouvements par type
  Future<List<MovementsTableData>> findByType(
    String farmId,
    String type,
  ) {
    return (select(movementsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.type.equals(type))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.movementDate, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Récupère les mouvements dans une période
  Future<List<MovementsTableData>> findByDateRange(
    String farmId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return (select(movementsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.movementDate.isBiggerOrEqualValue(startDate))
          ..where((t) => t.movementDate.isSmallerOrEqualValue(endDate))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.movementDate, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Récupère les mouvements d'un type dans une période
  Future<List<MovementsTableData>> findByTypeAndDateRange(
    String farmId,
    String type,
    DateTime startDate,
    DateTime endDate,
  ) {
    return (select(movementsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.type.equals(type))
          ..where((t) => t.movementDate.isBiggerOrEqualValue(startDate))
          ..where((t) => t.movementDate.isSmallerOrEqualValue(endDate))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.movementDate, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Récupère les naissances (births)
  Future<List<MovementsTableData>> findBirths(String farmId) {
    return findByType(farmId, 'birth');
  }

  /// Récupère les achats (purchases)
  Future<List<MovementsTableData>> findPurchases(String farmId) {
    return findByType(farmId, 'purchase');
  }

  /// Récupère les ventes (sales)
  Future<List<MovementsTableData>> findSales(String farmId) {
    return findByType(farmId, 'sale');
  }

  /// Récupère les décès (deaths)
  Future<List<MovementsTableData>> findDeaths(String farmId) {
    return findByType(farmId, 'death');
  }

  /// Récupère les abattages (slaughters)
  Future<List<MovementsTableData>> findSlaughters(String farmId) {
    return findByType(farmId, 'slaughter');
  }

  /// Compte les mouvements par type
  Future<int> countByType(String farmId, String type) async {
    final result = await (selectOnly(movementsTable)
          ..addColumns([movementsTable.id.count()])
          ..where(movementsTable.farmId.equals(farmId))
          ..where(movementsTable.type.equals(type))
          ..where(movementsTable.deletedAt.isNull()))
        .getSingle();
    return result.read(movementsTable.id.count()) ?? 0;
  }

  /// Compte les mouvements d'un animal
  Future<int> countByAnimalId(String farmId, String animalId) async {
    final result = await (selectOnly(movementsTable)
          ..addColumns([movementsTable.id.count()])
          ..where(movementsTable.farmId.equals(farmId))
          ..where(movementsTable.animalId.equals(animalId))
          ..where(movementsTable.deletedAt.isNull()))
        .getSingle();
    return result.read(movementsTable.id.count()) ?? 0;
  }

  /// Calcule le total des ventes sur une période
  Future<double> calculateTotalSalesAmount(
    String farmId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final result = await (selectOnly(movementsTable)
          ..addColumns([movementsTable.price.sum()])
          ..where(movementsTable.farmId.equals(farmId))
          ..where(movementsTable.type.equals('sale'))
          ..where(movementsTable.movementDate.isBiggerOrEqualValue(startDate))
          ..where(movementsTable.movementDate.isSmallerOrEqualValue(endDate))
          ..where(movementsTable.deletedAt.isNull()))
        .getSingle();
    return result.read(movementsTable.price.sum()) ?? 0.0;
  }

  /// Calcule le total des achats sur une période
  Future<double> calculateTotalPurchasesAmount(
    String farmId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final result = await (selectOnly(movementsTable)
          ..addColumns([movementsTable.price.sum()])
          ..where(movementsTable.farmId.equals(farmId))
          ..where(movementsTable.type.equals('purchase'))
          ..where(movementsTable.movementDate.isBiggerOrEqualValue(startDate))
          ..where(movementsTable.movementDate.isSmallerOrEqualValue(endDate))
          ..where(movementsTable.deletedAt.isNull()))
        .getSingle();
    return result.read(movementsTable.price.sum()) ?? 0.0;
  }

  // === PHASE 2: STRUCTURED SALE/SLAUGHTER QUERIES ===

  /// Récupère les ventes par nom d'acheteur
  ///
  /// Utilise les nouveaux champs structurés (buyerName)
  /// Recherche insensible à la casse
  Future<List<MovementsTableData>> findSalesByBuyer(
    String farmId,
    String buyerName,
  ) {
    return (select(movementsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.type.equals('sale'))
          ..where((t) => t.buyerName.like('%$buyerName%'))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.movementDate, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Récupère les ventes à une ferme spécifique
  ///
  /// Filtre par buyerFarmId (ventes B2B entre fermes)
  Future<List<MovementsTableData>> findSalesByBuyerFarmId(
    String farmId,
    String buyerFarmId,
  ) {
    return (select(movementsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.type.equals('sale'))
          ..where((t) => t.buyerFarmId.equals(buyerFarmId))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.movementDate, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Récupère les abattages par établissement
  ///
  /// Filtre par slaughterhouseId pour traçabilité
  Future<List<MovementsTableData>> findSlaughtersByFacility(
    String farmId,
    String slaughterhouseId,
  ) {
    return (select(movementsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.type.equals('slaughter'))
          ..where((t) => t.slaughterhouseId.equals(slaughterhouseId))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.movementDate, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Calcule le total des ventes à un acheteur sur une période
  ///
  /// Agrégation par buyerFarmId pour reporting B2B
  Future<double> calculateTotalSalesByBuyer(
    String farmId,
    String buyerFarmId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final result = await (selectOnly(movementsTable)
          ..addColumns([movementsTable.price.sum()])
          ..where(movementsTable.farmId.equals(farmId))
          ..where(movementsTable.type.equals('sale'))
          ..where(movementsTable.buyerFarmId.equals(buyerFarmId))
          ..where(movementsTable.movementDate.isBiggerOrEqualValue(startDate))
          ..where(movementsTable.movementDate.isSmallerOrEqualValue(endDate))
          ..where(movementsTable.deletedAt.isNull()))
        .getSingle();
    return result.read(movementsTable.price.sum()) ?? 0.0;
  }

  // === PHASE 2: TEMPORARY MOVEMENT QUERIES ===

  /// Récupère les mouvements temporaires actifs (non retournés)
  ///
  /// Filtre:
  /// - type = 'temporaryOut'
  /// - relatedMovementId IS NULL (pas encore de retour)
  /// Tri par date de retour prévue (les plus urgents d'abord)
  Future<List<MovementsTableData>> findActiveTemporaryMovements(
    String farmId,
  ) {
    return (select(movementsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.type.equals('temporaryOut'))
          ..where((t) => t.relatedMovementId.isNull())
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.expectedReturnDate, mode: OrderingMode.asc),
          ]))
        .get();
  }

  /// Récupère les mouvements temporaires en retard
  ///
  /// Filtre:
  /// - type = 'temporaryOut'
  /// - relatedMovementId IS NULL (pas encore retourné)
  /// - expectedReturnDate < NOW (en retard)
  /// Tri par urgence (plus ancien retard d'abord)
  Future<List<MovementsTableData>> findOverdueTemporaryMovements(
    String farmId,
  ) {
    final now = DateTime.now();
    return (select(movementsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.type.equals('temporaryOut'))
          ..where((t) => t.relatedMovementId.isNull())
          ..where((t) => t.expectedReturnDate.isSmallerThanValue(now))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.expectedReturnDate, mode: OrderingMode.asc),
          ]))
        .get();
  }

  /// Récupère les mouvements temporaires par type (loan, transhumance, etc.)
  ///
  /// Permet de filtrer par sous-type de mouvement temporaire
  Future<List<MovementsTableData>> findTemporaryMovementsByType(
    String farmId,
    String temporaryMovementType,
  ) {
    return (select(movementsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.type.equals('temporaryOut'))
          ..where((t) => t.temporaryMovementType.equals(temporaryMovementType))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.movementDate, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Compte les mouvements temporaires actifs
  Future<int> countActiveTemporaryMovements(String farmId) async {
    final result = await (selectOnly(movementsTable)
          ..addColumns([movementsTable.id.count()])
          ..where(movementsTable.farmId.equals(farmId))
          ..where(movementsTable.type.equals('temporaryOut'))
          ..where(movementsTable.relatedMovementId.isNull())
          ..where(movementsTable.deletedAt.isNull()))
        .getSingle();
    return result.read(movementsTable.id.count()) ?? 0;
  }

  /// Compte les mouvements temporaires en retard
  Future<int> countOverdueTemporaryMovements(String farmId) async {
    final now = DateTime.now();
    final result = await (selectOnly(movementsTable)
          ..addColumns([movementsTable.id.count()])
          ..where(movementsTable.farmId.equals(farmId))
          ..where(movementsTable.type.equals('temporaryOut'))
          ..where(movementsTable.relatedMovementId.isNull())
          ..where(movementsTable.expectedReturnDate.isSmallerThanValue(now))
          ..where(movementsTable.deletedAt.isNull()))
        .getSingle();
    return result.read(movementsTable.id.count()) ?? 0;
  }
}
