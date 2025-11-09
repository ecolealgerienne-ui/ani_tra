// lib/repositories/medical_product_repository.dart
import '../drift/database.dart';
import '../models/medical_product.dart';
import 'package:drift/drift.dart' as drift;

class MedicalProductRepository {
  final AppDatabase _db;

  MedicalProductRepository(this._db);

  // 1. Get all products by farmId
  Future<List<MedicalProduct>> getAll(String farmId) async {
    final data = await _db.medicalProductDao.findByFarmId(farmId);
    return data.map((d) => _mapToModel(d)).toList();
  }

  // 2. Get active products
  Future<List<MedicalProduct>> getAllActive(String farmId) async {
    final data = await _db.medicalProductDao.findActiveByFarmId(farmId);
    return data.map((d) => _mapToModel(d)).toList();
  }

  // 3. Get product by ID
  Future<MedicalProduct?> getById(String id, String farmId) async {
    final data = await _db.medicalProductDao.findById(id, farmId);
    if (data == null) return null;
    
    // Security check
    if (data.farmId != farmId) {
      throw Exception('Farm ID mismatch - Security violation');
    }
    
    return _mapToModel(data);
  }

  // 4. Get products by type
  Future<List<MedicalProduct>> getByType(ProductType type, String farmId) async {
    final data = await _db.medicalProductDao.findByType(type.name, farmId);
    return data.map((d) => _mapToModel(d)).toList();
  }

  // 5. Get products by category
  Future<List<MedicalProduct>> getByCategory(String category, String farmId) async {
    final data = await _db.medicalProductDao.findByCategory(category, farmId);
    return data.map((d) => _mapToModel(d)).toList();
  }

  // 6. Get low stock products
  Future<List<MedicalProduct>> getLowStock(String farmId) async {
    final data = await _db.medicalProductDao.findLowStock(farmId);
    return data.map((d) => _mapToModel(d)).toList();
  }

  // 7. Get expiring soon products
  Future<List<MedicalProduct>> getExpiringSoon(String farmId) async {
    final data = await _db.medicalProductDao.findExpiringSoon(farmId);
    return data.map((d) => _mapToModel(d)).toList();
  }

  // 8. Get expired products
  Future<List<MedicalProduct>> getExpired(String farmId) async {
    final data = await _db.medicalProductDao.findExpired(farmId);
    return data.map((d) => _mapToModel(d)).toList();
  }

  // 9. Search by name
  Future<List<MedicalProduct>> search(String query, String farmId) async {
    final data = await _db.medicalProductDao.searchByName(query, farmId);
    return data.map((d) => _mapToModel(d)).toList();
  }

  // 10. Create product
  Future<void> create(MedicalProduct product, String farmId) async {
    final companion = _mapToCompanion(product, farmId);
    await _db.medicalProductDao.insertProduct(companion);
  }

  // 11. Update product
  Future<void> update(MedicalProduct product, String farmId) async {
    // Security check
    final existing = await _db.medicalProductDao.findById(product.id, farmId);
    if (existing == null || existing.farmId != farmId) {
      throw Exception('Product not found or farm mismatch');
    }
    
    final companion = _mapToCompanion(product, farmId);
    await _db.medicalProductDao.updateProduct(companion);
  }

  // 12. Delete product (soft-delete)
  Future<void> delete(String id, String farmId) async {
    await _db.medicalProductDao.softDelete(id, farmId);
  }

  // 13. Count products
  Future<int> count(String farmId) async {
    return await _db.medicalProductDao.countProducts(farmId);
  }

  // 14. Get unsynced products (Phase 2 ready)
  Future<List<MedicalProduct>> getUnsynced(String farmId) async {
    final data = await _db.medicalProductDao.getUnsynced(farmId);
    return data.map((d) => _mapToModel(d)).toList();
  }

  // 15. Update stock
  Future<void> updateStock(String id, String farmId, double newStock) async {
    await _db.medicalProductDao.updateStock(id, farmId, newStock);
  }

  // 16. Toggle active status
  Future<void> toggleActive(String id, String farmId) async {
    await _db.medicalProductDao.toggleActive(id, farmId);
  }

  // === MAPPERS ===

  MedicalProduct _mapToModel(MedicalProductsTableData data) {
    return MedicalProduct(
      id: data.id,
      farmId: data.farmId,
      name: data.name,
      commercialName: data.commercialName,
      category: data.category,
      activeIngredient: data.activeIngredient,
      manufacturer: data.manufacturer,
      form: data.form,
      dosage: data.dosage,
      dosageUnit: data.dosageUnit,
      withdrawalPeriodMeat: data.withdrawalPeriodMeat,
      withdrawalPeriodMilk: data.withdrawalPeriodMilk,
      currentStock: data.currentStock,
      minStock: data.minStock,
      stockUnit: data.stockUnit,
      unitPrice: data.unitPrice,
      currency: data.currency,
      batchNumber: data.batchNumber,
      expiryDate: data.expiryDate,
      storageConditions: data.storageConditions,
      prescription: data.prescription,
      notes: data.notes,
      isActive: data.isActive,
      type: _parseProductType(data.type),
      targetSpecies: _parseTargetSpecies(data.targetSpecies),
      standardCureDays: data.standardCureDays,
      administrationFrequency: data.administrationFrequency,
      dosageFormula: data.dosageFormula,
      vaccinationProtocol: data.vaccinationProtocol,
      reminderDays: _parseReminderDays(data.reminderDays),
      defaultAdministrationRoute: data.defaultAdministrationRoute,
      defaultInjectionSite: data.defaultInjectionSite,
      synced: data.synced,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      lastSyncedAt: data.lastSyncedAt,
      serverVersion: data.serverVersion?.toString(),
    );
  }

  MedicalProductsTableCompanion _mapToCompanion(MedicalProduct product, String farmId) {
    return MedicalProductsTableCompanion(
      id: drift.Value(product.id),
      farmId: drift.Value(farmId),
      name: drift.Value(product.name),
      commercialName: product.commercialName != null 
        ? drift.Value(product.commercialName!) 
        : const drift.Value.absent(),
      category: drift.Value(product.category),
      activeIngredient: product.activeIngredient != null 
        ? drift.Value(product.activeIngredient!) 
        : const drift.Value.absent(),
      manufacturer: product.manufacturer != null 
        ? drift.Value(product.manufacturer!) 
        : const drift.Value.absent(),
      form: product.form != null 
        ? drift.Value(product.form!) 
        : const drift.Value.absent(),
      dosage: product.dosage != null 
        ? drift.Value(product.dosage!) 
        : const drift.Value.absent(),
      dosageUnit: product.dosageUnit != null 
        ? drift.Value(product.dosageUnit!) 
        : const drift.Value.absent(),
      withdrawalPeriodMeat: drift.Value(product.withdrawalPeriodMeat),
      withdrawalPeriodMilk: drift.Value(product.withdrawalPeriodMilk),
      currentStock: drift.Value(product.currentStock),
      minStock: drift.Value(product.minStock),
      stockUnit: drift.Value(product.stockUnit),
      unitPrice: product.unitPrice != null 
        ? drift.Value(product.unitPrice!) 
        : const drift.Value.absent(),
      currency: product.currency != null 
        ? drift.Value(product.currency!) 
        : const drift.Value.absent(),
      batchNumber: product.batchNumber != null 
        ? drift.Value(product.batchNumber!) 
        : const drift.Value.absent(),
      expiryDate: product.expiryDate != null 
        ? drift.Value(product.expiryDate!) 
        : const drift.Value.absent(),
      storageConditions: product.storageConditions != null 
        ? drift.Value(product.storageConditions!) 
        : const drift.Value.absent(),
      prescription: product.prescription != null 
        ? drift.Value(product.prescription!) 
        : const drift.Value.absent(),
      notes: product.notes != null 
        ? drift.Value(product.notes!) 
        : const drift.Value.absent(),
      isActive: drift.Value(product.isActive),
      type: drift.Value(product.type.name),
      targetSpecies: drift.Value(_serializeTargetSpecies(product.targetSpecies)),
      standardCureDays: product.standardCureDays != null 
        ? drift.Value(product.standardCureDays!) 
        : const drift.Value.absent(),
      administrationFrequency: product.administrationFrequency != null 
        ? drift.Value(product.administrationFrequency!) 
        : const drift.Value.absent(),
      dosageFormula: product.dosageFormula != null 
        ? drift.Value(product.dosageFormula!) 
        : const drift.Value.absent(),
      vaccinationProtocol: product.vaccinationProtocol != null 
        ? drift.Value(product.vaccinationProtocol!) 
        : const drift.Value.absent(),
      reminderDays: product.reminderDays != null 
        ? drift.Value(_serializeReminderDays(product.reminderDays!)) 
        : const drift.Value.absent(),
      defaultAdministrationRoute: product.defaultAdministrationRoute != null 
        ? drift.Value(product.defaultAdministrationRoute!) 
        : const drift.Value.absent(),
      defaultInjectionSite: product.defaultInjectionSite != null 
        ? drift.Value(product.defaultInjectionSite!) 
        : const drift.Value.absent(),
      synced: drift.Value(product.synced),
      lastSyncedAt: product.lastSyncedAt != null 
        ? drift.Value(product.lastSyncedAt!) 
        : const drift.Value.absent(),
      serverVersion: product.serverVersion != null 
        ? drift.Value(int.tryParse(product.serverVersion!) ?? 0) 
        : const drift.Value.absent(),
      deletedAt: const drift.Value.absent(),
      createdAt: drift.Value(product.createdAt),
      updatedAt: drift.Value(product.updatedAt),
    );
  }

  // === CONVERSION HELPERS ===

  // Parse ProductType from String
  ProductType _parseProductType(String value) {
    return ProductType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ProductType.treatment,
    );
  }

  // Parse targetSpecies from comma-separated String
  List<AnimalSpecies> _parseTargetSpecies(String value) {
    if (value.isEmpty) return [];
    return value.split(',').map((s) {
      return AnimalSpecies.values.firstWhere(
        (e) => e.name == s.trim(),
        orElse: () => AnimalSpecies.ovin,
      );
    }).toList();
  }

  // Serialize targetSpecies to comma-separated String
  String _serializeTargetSpecies(List<AnimalSpecies> species) {
    return species.map((s) => s.name).join(',');
  }

  // Parse reminderDays from comma-separated String
  List<int>? _parseReminderDays(String? value) {
    if (value == null || value.isEmpty) return null;
    return value.split(',').map((s) => int.parse(s.trim())).toList();
  }

  // Serialize reminderDays to comma-separated String
  String _serializeReminderDays(List<int> days) {
    return days.map((d) => d.toString()).join(',');
  }
}
