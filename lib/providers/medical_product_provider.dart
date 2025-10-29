// lib/providers/medical_product_provider.dart
import 'package:flutter/foundation.dart';
import '../models/medical_product.dart';

class MedicalProductProvider with ChangeNotifier {
  final List<MedicalProduct> _products = [];

  List<MedicalProduct> get products => List.unmodifiable(_products);

  // Filtres
  List<MedicalProduct> get activeProducts =>
      _products.where((p) => p.isActive).toList();

  List<MedicalProduct> get lowStockProducts =>
      _products.where((p) => p.isLowStock && p.isActive).toList();

  List<MedicalProduct> get expiredProducts =>
      _products.where((p) => p.isExpired && p.isActive).toList();

  List<MedicalProduct> get expiringSoonProducts =>
      _products.where((p) => p.isExpiringSoon && p.isActive).toList();

  // Statistiques
  Map<String, int> get stats {
    return {
      'total': _products.where((p) => p.isActive).length,
      'lowStock': lowStockProducts.length,
      'expired': expiredProducts.length,
      'expiringSoon': expiringSoonProducts.length,
    };
  }

  // Catégories
  List<String> get categories {
    return _products
        .where((p) => p.isActive)
        .map((p) => p.category)
        .toSet()
        .toList()
      ..sort();
  }

  MedicalProductProvider() {
    _loadMockData();
  }

  // Charger des données de démonstration
  void _loadMockData() {
    _products.addAll([
      MedicalProduct(
        id: '1',
        name: 'AMOXICILLINE',
        commercialName: 'Clamoxyl',
        category: 'Antibiotique',
        activeIngredient: 'Amoxicilline trihydrate',
        manufacturer: 'Zoetis',
        form: 'Injectable',
        dosage: 150.0,
        dosageUnit: 'mg/ml',
        withdrawalPeriodMeat: 14,
        withdrawalPeriodMilk: 3,
        currentStock: 25.0,
        minStock: 10.0,
        stockUnit: 'ml',
        unitPrice: 12.50,
        currency: 'EUR',
        batchNumber: 'LOT2024-A123',
        expiryDate: DateTime(2025, 12, 31),
        storageConditions: 'Conserver entre 2°C et 8°C',
        prescription: 'Ordonnance vétérinaire requise',
        notes: 'Agiter avant emploi',
        createdAt: DateTime(2024, 1, 15),
        updatedAt: DateTime(2024, 10, 20),
      ),
      MedicalProduct(
        id: '2',
        name: 'MELOXICAM',
        commercialName: 'Metacam',
        category: 'Anti-inflammatoire',
        activeIngredient: 'Meloxicam',
        manufacturer: 'Boehringer Ingelheim',
        form: 'Injectable',
        dosage: 20.0,
        dosageUnit: 'mg/ml',
        withdrawalPeriodMeat: 15,
        withdrawalPeriodMilk: 5,
        currentStock: 8.0,
        minStock: 10.0,
        stockUnit: 'ml',
        unitPrice: 18.00,
        currency: 'EUR',
        batchNumber: 'LOT2024-M456',
        expiryDate: DateTime(2025, 6, 30),
        storageConditions: 'Conserver à température ambiante',
        prescription: 'Ordonnance vétérinaire requise',
        notes: 'AINS - utiliser avec précaution',
        createdAt: DateTime(2024, 2, 10),
      ),
      MedicalProduct(
        id: '3',
        name: 'IVERMECTINE',
        commercialName: 'Ivomec',
        category: 'Antiparasitaire',
        activeIngredient: 'Ivermectine',
        manufacturer: 'Merial',
        form: 'Injectable',
        dosage: 10.0,
        dosageUnit: 'mg/ml',
        withdrawalPeriodMeat: 28,
        withdrawalPeriodMilk: 0,
        currentStock: 45.0,
        minStock: 20.0,
        stockUnit: 'ml',
        unitPrice: 8.75,
        currency: 'EUR',
        batchNumber: 'LOT2024-I789',
        expiryDate: DateTime(2026, 3, 31),
        storageConditions: 'Protéger de la lumière',
        prescription: 'Ordonnance vétérinaire requise',
        notes: 'Efficace contre les parasites internes et externes',
        createdAt: DateTime(2024, 3, 5),
      ),
      MedicalProduct(
        id: '4',
        name: 'VACCIN ENTÉROTOXÉMIE',
        commercialName: 'Covexin',
        category: 'Vaccin',
        activeIngredient: 'Toxoïdes clostridiens',
        manufacturer: 'MSD',
        form: 'Injectable',
        dosage: 2.0,
        dosageUnit: 'ml/dose',
        withdrawalPeriodMeat: 0,
        withdrawalPeriodMilk: 0,
        currentStock: 30.0,
        minStock: 15.0,
        stockUnit: 'doses',
        unitPrice: 3.50,
        currency: 'EUR',
        batchNumber: 'LOT2024-V321',
        expiryDate: DateTime(2025, 11, 15),
        storageConditions: 'Conserver entre 2°C et 8°C - Ne pas congeler',
        prescription: 'Ordonnance vétérinaire requise',
        notes: 'Vaccin polyvalent - 2 injections à 4 semaines d\'intervalle',
        createdAt: DateTime(2024, 4, 1),
      ),
      MedicalProduct(
        id: '5',
        name: 'OXYTÉTRACYCLINE',
        commercialName: 'Terramycine',
        category: 'Antibiotique',
        activeIngredient: 'Oxytétracycline',
        manufacturer: 'Pfizer',
        form: 'Injectable',
        dosage: 200.0,
        dosageUnit: 'mg/ml',
        withdrawalPeriodMeat: 21,
        withdrawalPeriodMilk: 7,
        currentStock: 3.0,
        minStock: 10.0,
        stockUnit: 'ml',
        unitPrice: 15.00,
        currency: 'EUR',
        batchNumber: 'LOT2024-O654',
        expiryDate: DateTime(2025, 2, 28),
        storageConditions: 'Conserver à l\'abri de la lumière',
        prescription: 'Ordonnance vétérinaire requise',
        notes: 'Large spectre - surveiller le délai d\'attente',
        createdAt: DateTime(2024, 5, 12),
      ),
      MedicalProduct(
        id: '6',
        name: 'DEXAMÉTHASONE',
        commercialName: 'Dexadreson',
        category: 'Corticoïde',
        activeIngredient: 'Dexaméthasone',
        manufacturer: 'Intervet',
        form: 'Injectable',
        dosage: 2.0,
        dosageUnit: 'mg/ml',
        withdrawalPeriodMeat: 8,
        withdrawalPeriodMilk: 2,
        currentStock: 15.0,
        minStock: 5.0,
        stockUnit: 'ml',
        unitPrice: 9.50,
        currency: 'EUR',
        batchNumber: 'LOT2024-D987',
        expiryDate: DateTime(2024, 11, 30),
        storageConditions: 'Conserver à température ambiante',
        prescription: 'Ordonnance vétérinaire requise',
        notes: 'Anti-inflammatoire puissant - utilisation limitée',
        createdAt: DateTime(2024, 6, 8),
      ),
    ]);
    notifyListeners();
  }

  // CRUD Operations
  MedicalProduct? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  List<MedicalProduct> getProductsByCategory(String category) {
    return _products
        .where((p) => p.category == category && p.isActive)
        .toList();
  }

  List<MedicalProduct> searchProducts(String query) {
    final lowerQuery = query.toLowerCase();
    return _products.where((p) {
      return p.isActive &&
          (p.name.toLowerCase().contains(lowerQuery) ||
              (p.commercialName?.toLowerCase().contains(lowerQuery) ?? false) ||
              (p.activeIngredient?.toLowerCase().contains(lowerQuery) ??
                  false) ||
              p.category.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  void addProduct(MedicalProduct product) {
    _products.add(product);
    notifyListeners();
  }

  void updateProduct(MedicalProduct product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product.copyWith(updatedAt: DateTime.now());
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    final index = _products.indexWhere((p) => p.id == id);
    if (index != -1) {
      _products[index] = _products[index].copyWith(
        isActive: false,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  // Gestion du stock
  void updateStock(String id, double quantity, {bool isAddition = true}) {
    final index = _products.indexWhere((p) => p.id == id);
    if (index != -1) {
      final currentStock = _products[index].currentStock;
      final newStock =
          isAddition ? currentStock + quantity : currentStock - quantity;

      _products[index] = _products[index].copyWith(
        currentStock: newStock < 0 ? 0 : newStock,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void adjustStock(String id, double newStock) {
    final index = _products.indexWhere((p) => p.id == id);
    if (index != -1) {
      _products[index] = _products[index].copyWith(
        currentStock: newStock,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  // Alertes
  bool hasAlerts() {
    return lowStockProducts.isNotEmpty ||
        expiredProducts.isNotEmpty ||
        expiringSoonProducts.isNotEmpty;
  }

  int getTotalAlerts() {
    return lowStockProducts.length +
        expiredProducts.length +
        expiringSoonProducts.length;
  }
}
