// lib/providers/medical_product_provider.dart

import 'package:flutter/foundation.dart';
import '../models/medical_product.dart';
import '../repositories/medical_product_repository.dart';
import 'auth_provider.dart';

/// MedicalProductProvider - Gestion des produits médicaux
class MedicalProductProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  final MedicalProductRepository _repository;
  String _currentFarmId;

  // Données principales (cache local)
  final List<MedicalProduct> _allProducts = [];

  // Loading state
  bool _isLoading = false;

  MedicalProductProvider(this._authProvider, this._repository)
      : _currentFarmId = _authProvider.currentFarmId {
    _authProvider.addListener(_onFarmChanged);
    _loadProductsFromRepository();
  }

  void _onFarmChanged() {
    if (_currentFarmId != _authProvider.currentFarmId) {
      _currentFarmId = _authProvider.currentFarmId;
      _loadProductsFromRepository();
    }
  }

  // ==================== Getters ====================

  List<MedicalProduct> get products => List.unmodifiable(
      _allProducts.where((p) => p.farmId == _authProvider.currentFarmId));

  List<MedicalProduct> get activeProducts => List.unmodifiable(
      _allProducts.where((p) =>
          p.farmId == _authProvider.currentFarmId &&
          p.isActive));

  bool get isLoading => _isLoading;

  // ==================== Repository Loading ====================

  Future<void> _loadProductsFromRepository() async {
    if (_currentFarmId.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final farmProducts = await _repository.getAll(_currentFarmId);
      _allProducts.removeWhere((p) => p.farmId == _currentFarmId);
      _allProducts.addAll(farmProducts);
    } catch (e) {
      debugPrint('❌ Error loading products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await _loadProductsFromRepository();
  }

  // ==================== Filtres ====================

  /// Obtenir les produits par type (treatment, vaccine)
  List<MedicalProduct> getProductsByType(ProductType type) {
    return products.where((p) => p.type == type && p.isActive).toList();
  }

  /// Obtenir les produits par catégorie
  List<MedicalProduct> getProductsByCategory(String category) {
    return products.where((p) => p.category == category && p.isActive).toList();
  }

  /// Rechercher un produit par ID
  MedicalProduct? getProductById(String id) {
    try {
      return _allProducts.firstWhere(
        (p) => p.id == id && p.farmId == _authProvider.currentFarmId,
      );
    } catch (e) {
      return null;
    }
  }

  /// Obtenir les produits en stock faible
  Future<List<MedicalProduct>> getLowStockProducts() async {
    return await _repository.getLowStock(_authProvider.currentFarmId);
  }

  /// Obtenir les produits expirant bientôt
  Future<List<MedicalProduct>> getExpiringSoonProducts() async {
    return await _repository.getExpiringSoon(_authProvider.currentFarmId);
  }

  // ==================== CRUD ====================

  Future<void> addProduct(MedicalProduct product) async {
    final productWithFarm =
        product.copyWith(farmId: _authProvider.currentFarmId);

    try {
      await _repository.create(productWithFarm, _authProvider.currentFarmId);
      _allProducts.add(productWithFarm);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error adding product: $e');
      rethrow;
    }
  }

  Future<void> updateProduct(MedicalProduct updated) async {
    try {
      await _repository.update(updated, _authProvider.currentFarmId);

      final index = _allProducts.indexWhere((p) => p.id == updated.id);
      if (index != -1) {
        _allProducts[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error updating product: $e');
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _repository.delete(id, _authProvider.currentFarmId);
      _allProducts.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error deleting product: $e');
      rethrow;
    }
  }

  Future<void> updateStock(String id, double newStock) async {
    try {
      await _repository.updateStock(id, _authProvider.currentFarmId, newStock);

      final index = _allProducts.indexWhere((p) => p.id == id);
      if (index != -1) {
        _allProducts[index] =
            _allProducts[index].copyWith(currentStock: newStock);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error updating stock: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onFarmChanged);
    super.dispose();
  }
}
