// lib/drift/daos/medical_product_dao.dart
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/medical_products_table.dart';

part 'medical_product_dao.g.dart';

@DriftAccessor(tables: [MedicalProductsTable])
class MedicalProductDao extends DatabaseAccessor<AppDatabase>
    with _$MedicalProductDaoMixin {
  MedicalProductDao(super.db);

  // 1. Find by farmId (excluding soft-deleted)
  Future<List<MedicalProductsTableData>> findByFarmId(String farmId) {
    return (select(medicalProductsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  // 2. Find active products by farmId
  Future<List<MedicalProductsTableData>> findActiveByFarmId(String farmId) {
    return (select(medicalProductsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.isActive.equals(true))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  // 3. Find by ID (with farmId security)
  Future<MedicalProductsTableData?> findById(String id, String farmId) {
    return (select(medicalProductsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  // 4. Find by type (treatment or vaccine)
  Future<List<MedicalProductsTableData>> findByType(
      String type, String farmId) {
    return (select(medicalProductsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.type.equals(type))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  // 5. Find by category
  Future<List<MedicalProductsTableData>> findByCategory(
      String category, String farmId) {
    return (select(medicalProductsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.category.equals(category))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  // 6. Find low stock products
  Future<List<MedicalProductsTableData>> findLowStock(String farmId) {
    return (select(medicalProductsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where(
              (t) => const CustomExpression<bool>('current_stock <= min_stock'))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  // 7. Find expiring soon products (expiry_date <= 30 days from now)
  Future<List<MedicalProductsTableData>> findExpiringSoon(String farmId) {
    final thirtyDaysFromNow = DateTime.now().add(const Duration(days: 30));
    return (select(medicalProductsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.expiryDate.isSmallerOrEqualValue(thirtyDaysFromNow))
          ..where((t) => t.expiryDate.isBiggerOrEqualValue(DateTime.now()))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.expiryDate)]))
        .get();
  }

  // 8. Find expired products
  Future<List<MedicalProductsTableData>> findExpired(String farmId) {
    return (select(medicalProductsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.expiryDate.isSmallerThanValue(DateTime.now()))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.expiryDate)]))
        .get();
  }

  // 9. Search by name
  Future<List<MedicalProductsTableData>> searchByName(
      String query, String farmId) {
    final lowerQuery = '%${query.toLowerCase()}%';
    return (select(medicalProductsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) =>
              t.name.lower().like(lowerQuery) |
              t.commercialName.lower().like(lowerQuery))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  // 10. Insert product
  Future<int> insertProduct(MedicalProductsTableCompanion product) {
    return into(medicalProductsTable).insert(product);
  }

  // 11. Update product
  Future<bool> updateProduct(MedicalProductsTableCompanion product) {
    return update(medicalProductsTable).replace(product);
  }

  // 12. Soft-delete product
  Future<int> softDelete(String id, String farmId) {
    return (update(medicalProductsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(MedicalProductsTableCompanion(
      deletedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // 13. Count products
  Future<int> countProducts(String farmId) {
    final query = selectOnly(medicalProductsTable)
      ..addColumns([medicalProductsTable.id.count()])
      ..where(medicalProductsTable.farmId.equals(farmId))
      ..where(medicalProductsTable.deletedAt.isNull());

    return query
        .map((row) => row.read(medicalProductsTable.id.count())!)
        .getSingle();
  }

  // 14. Get unsynced products (Phase 2 ready)
  Future<List<MedicalProductsTableData>> getUnsynced(String farmId) {
    return (select(medicalProductsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.synced.equals(false))
          ..where((t) => t.deletedAt.isNull()))
        .get();
  }

  // 15. Mark as synced (Phase 2 ready)
  Future<int> markSynced(String id, String farmId) {
    return (update(medicalProductsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(MedicalProductsTableCompanion(
      synced: const Value(true),
      lastSyncedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // 16. Update stock
  Future<int> updateStock(String id, String farmId, double newStock) {
    return (update(medicalProductsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(MedicalProductsTableCompanion(
      currentStock: Value(newStock),
      updatedAt: Value(DateTime.now()),
      synced: const Value(false),
    ));
  }

  // 17. Toggle active status
  Future<int> toggleActive(String id, String farmId) async {
    final product = await findById(id, farmId);
    if (product == null) return 0;

    return (update(medicalProductsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(MedicalProductsTableCompanion(
      isActive: Value(!product.isActive),
      updatedAt: Value(DateTime.now()),
      synced: const Value(false),
    ));
  }
}
