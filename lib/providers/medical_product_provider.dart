// lib/providers/medical_product_provider.dart
import 'package:flutter/foundation.dart';
import '../models/medical_product.dart';
import 'auth_provider.dart';

class MedicalProductProvider with ChangeNotifier {
  final AuthProvider _authProvider;

  MedicalProductProvider(this._authProvider);

  final List<MedicalProduct> _allMedicalProducts = [];

  List<MedicalProduct> get products => List.unmodifiable(_allMedicalProducts);

  // Filtres
  List<MedicalProduct> get activeProducts =>
      _allMedicalProducts.where((p) => p.isActive).toList();

  List<MedicalProduct> get lowStockProducts =>
      _allMedicalProducts.where((p) => p.isLowStock && p.isActive).toList();

  List<MedicalProduct> get expiredProducts =>
      _allMedicalProducts.where((p) => p.isExpired && p.isActive).toList();

  List<MedicalProduct> get expiringSoonProducts =>
      _allMedicalProducts.where((p) => p.isExpiringSoon && p.isActive).toList();

  // Statistiques (clés internes — pas de texte UI ici)
  Map<String, int> get stats {
    return {
      'total': _allMedicalProducts.where((p) => p.isActive).length,
      'lowStock': lowStockProducts.length,
      'expired': expiredProducts.length,
      'expiringSoon': expiringSoonProducts.length,
    };
  }

  // Catégories
  List<String> get categories {
    return _allMedicalProducts
        .where((p) => p.isActive)
        .map((p) => p.category)
        .toSet()
        .toList()
      ..sort();
  }

  // CRUD Operations
  MedicalProduct? getProductById(String id) {
    try {
      return _allMedicalProducts.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  List<MedicalProduct> getProductsByCategory(String category) {
    return _allMedicalProducts
        .where((p) => p.category == category && p.isActive)
        .toList();
  }

  List<MedicalProduct> searchProducts(String query) {
    final lowerQuery = query.toLowerCase();
    return _allMedicalProducts.where((p) {
      return p.isActive &&
          (p.name.toLowerCase().contains(lowerQuery) ||
              (p.commercialName?.toLowerCase().contains(lowerQuery) ?? false) ||
              (p.activeIngredient?.toLowerCase().contains(lowerQuery) ??
                  false) ||
              p.category.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  void addProduct(MedicalProduct product) {
    final productWithFarm =
        product.copyWith(farmId: _authProvider.currentFarmId);
    _allMedicalProducts.add(productWithFarm);
    notifyListeners();
  }

  void updateProduct(MedicalProduct product) {
    final index = _allMedicalProducts.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _allMedicalProducts[index] = product.copyWith(updatedAt: DateTime.now());
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    final index = _allMedicalProducts.indexWhere((p) => p.id == id);
    if (index != -1) {
      _allMedicalProducts[index] = _allMedicalProducts[index].copyWith(
        isActive: false,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  // Gestion du stock
  void updateStock(String id, double quantity, {bool isAddition = true}) {
    final index = _allMedicalProducts.indexWhere((p) => p.id == id);
    if (index != -1) {
      final currentStock = _allMedicalProducts[index].currentStock;
      final newStock =
          isAddition ? currentStock + quantity : currentStock - quantity;

      _allMedicalProducts[index] = _allMedicalProducts[index].copyWith(
        currentStock: newStock < 0 ? 0 : newStock,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void adjustStock(String id, double newStock) {
    final index = _allMedicalProducts.indexWhere((p) => p.id == id);
    if (index != -1) {
      _allMedicalProducts[index] = _allMedicalProducts[index].copyWith(
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
