// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/farm.dart';

/// Provider d'authentification et gestion multi-ferme
///
/// Mode MOCK : utilisateur et fermes hardcodés
/// Phase 1: SharedPreferences pour persister la ferme sélectionnée
/// Phase 2: Backend integration pour auth réelle
class AuthProvider extends ChangeNotifier {
  static const String _defaultFarmId = 'farm_default';
  static const String _prefKeySelectedFarmId = 'selected_farm_id';

  User? _currentUser;
  List<Farm> _farms = [];
  String _selectedFarmId = _defaultFarmId;

  AuthProvider() {
    _initMockUser();
    _loadSelectedFarmId();
  }

  // ==================== Getters ====================

  User? get currentUser => _currentUser;
  List<Farm> get farms => List.unmodifiable(_farms);

  /// ID de la ferme actuellement sélectionnée
  /// Persiste via SharedPreferences entre les sessions
  String get currentFarmId => _selectedFarmId;

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

  // ==================== SharedPreferences ====================

  /// Charge l'ID de la ferme sélectionnée depuis SharedPreferences
  /// Appelé à l'initialisation du provider
  Future<void> _loadSelectedFarmId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedFarmId = prefs.getString(_prefKeySelectedFarmId);

      if (savedFarmId != null && savedFarmId.isNotEmpty) {
        // Vérifier que la ferme existe dans la liste
        final farmExists = _farms.any((f) => f.id == savedFarmId);
        if (farmExists) {
          _selectedFarmId = savedFarmId;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('⚠️ Error loading selected farm ID: $e');
      // En cas d'erreur, on garde _defaultFarmId
    }
  }

  /// Sauvegarde l'ID de la ferme sélectionnée dans SharedPreferences
  Future<void> _saveSelectedFarmId(String farmId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKeySelectedFarmId, farmId);
    } catch (e) {
      debugPrint('⚠️ Error saving selected farm ID: $e');
    }
  }

  // ==================== Farm Selection ====================

  /// Change la ferme actuellement sélectionnée
  /// Persiste le choix via SharedPreferences
  /// Notifie tous les listeners (providers dépendants)
  Future<void> switchFarm(String farmId) async {
    // Vérifier que la ferme existe
    final farmExists = _farms.any((f) => f.id == farmId);
    if (!farmExists) {
      throw Exception('Farm with ID $farmId not found');
    }

    // Mettre à jour l'état
    _selectedFarmId = farmId;

    // Persister le choix
    await _saveSelectedFarmId(farmId);

    // Notifier les listeners (tous les providers qui écoutent)
    notifyListeners();

    debugPrint('✅ Switched to farm: $farmId');
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
}
