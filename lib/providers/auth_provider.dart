// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/farm.dart';

/// Provider d'authentification et gestion multi-ferme
///
/// Mode MOCK : currentFarmId est hardcodé
/// À débloquer plus tard quand le backend sera prêt
class AuthProvider extends ChangeNotifier {
  static const String _defaultFarmId = 'farm_default';

  User? _currentUser;
  List<Farm> _farms = [];

  AuthProvider() {
    _initMockUser();
  }

  // ==================== Getters ====================

  User? get currentUser => _currentUser;
  List<Farm> get farms => List.unmodifiable(_farms);

  /// ID de la ferme active (HARDCODÉ en mode mock)
  String get currentFarmId => _defaultFarmId;

  /// Nom d'utilisateur pour affichage UI
  String? get currentUserName => _currentUser?.name;

  /// Nom de la ferme active pour affichage UI
  String? get currentFarmName {
    final farm = _farms.firstWhere(
      (f) => f.id == currentFarmId,
      orElse: () => _farms.first,
    );
    return farm.name;
  }

  bool get isAuthenticated => _currentUser != null;
  bool get hasMultipleFarms => _farms.length > 1;

  // ==================== Mock Init ====================

  void _initMockUser() {
    final now = DateTime.now();
    _currentUser = User(
      id: 'user_mock_001',
      email: 'martin.dupont@example.com',
      name: 'Martin Dupont', // ✅ CORRIGÉ
      phone: '+33600000000',
      farmIds: [_defaultFarmId],
      currentFarmId: _defaultFarmId,
      createdAt: now,
      updatedAt: now,
    );

    _farms = [
      Farm(
        id: _defaultFarmId,
        name: 'Ferme Allier', // ✅ CORRIGÉ
        location: 'Allier, France', // ✅ CORRIGÉ
        ownerId: 'user_mock_001',
        cheptelNumber: 'FR12345',
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  // ==================== Future Methods (placeholders) ====================

  /// À implémenter : Login
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return true;
  }

  /// À implémenter : Logout
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// À implémenter : Switch farm
  Future<void> switchFarm(String farmId) async {
    // TODO: Débloquer quand backend prêt
    await Future.delayed(const Duration(milliseconds: 100));
    notifyListeners();
  }
}