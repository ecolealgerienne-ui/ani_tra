// lib/providers/alert_configuration_provider.dart
import 'package:flutter/foundation.dart';
import '../models/alert_configuration.dart';
import '../repositories/alert_configuration_repository.dart';
import 'auth_provider.dart';

/// AlertConfigurationProvider - Phase 1 Farm Settings
/// Gère les configurations d'alertes spécifiques à chaque ferme
/// Écoute les changements de ferme via AuthProvider
class AlertConfigurationProvider with ChangeNotifier {
  final AuthProvider _authProvider;
  final AlertConfigurationRepository _repository;
  String _currentFarmId;

  // Données principales (cache local)
  final List<AlertConfiguration> _allConfigurations = [];

  // Loading state
  bool _isLoading = false;

  AlertConfigurationProvider(this._authProvider, this._repository)
      : _currentFarmId = _authProvider.currentFarmId {
    _authProvider.addListener(_onFarmChanged);
    _loadConfigurationsFromRepository();
  }

  void _onFarmChanged() {
    if (_currentFarmId != _authProvider.currentFarmId) {
      _currentFarmId = _authProvider.currentFarmId;
      _loadConfigurationsFromRepository();
    }
  }

  // ==================== Getters ====================

  /// Toutes les configurations de la ferme actuelle (non supprimées)
  List<AlertConfiguration> get configurations => List.unmodifiable(
      _allConfigurations.where((c) => c.farmId == _authProvider.currentFarmId));

  /// Configurations activées uniquement
  List<AlertConfiguration> get enabledConfigurations =>
      configurations.where((c) => c.enabled).toList();

  /// Configurations par sévérité
  List<AlertConfiguration> getBySeverity(int severity) =>
      configurations.where((c) => c.severity == severity && c.enabled).toList();

  /// Configurations par catégorie
  List<AlertConfiguration> getByCategory(String category) =>
      configurations.where((c) => c.category == category && c.enabled).toList();

  /// Configuration par type d'évaluation
  AlertConfiguration? getByEvaluationType(AlertEvaluationType evaluationType) {
    try {
      return configurations.firstWhere(
        (c) => c.evaluationType == evaluationType,
      );
    } catch (e) {
      return null;
    }
  }

  bool get isLoading => _isLoading;

  // ==================== Repository Loading ====================

  Future<void> _loadConfigurationsFromRepository() async {
    if (_currentFarmId.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final farmConfigs = await _repository.getAll(_currentFarmId);
      _allConfigurations.removeWhere((c) => c.farmId == _currentFarmId);
      _allConfigurations.addAll(farmConfigs);
    } catch (e) {
      debugPrint('❌ Error loading alert configurations from repository: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==================== CRUD ====================

  Future<void> addConfiguration(AlertConfiguration configuration) async {
    final configWithFarm =
        configuration.copyWith(farmId: _authProvider.currentFarmId);

    try {
      final created =
          await _repository.create(configWithFarm, _authProvider.currentFarmId);
      _allConfigurations.add(created);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error adding alert configuration: $e');
      rethrow;
    }
  }

  Future<void> updateConfiguration(AlertConfiguration configuration) async {
    try {
      await _repository.update(configuration, _authProvider.currentFarmId);

      final index =
          _allConfigurations.indexWhere((c) => c.id == configuration.id);
      if (index != -1) {
        _allConfigurations[index] =
            configuration.copyWith(updatedAt: DateTime.now());
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error updating alert configuration: $e');
      rethrow;
    }
  }

  Future<void> deleteConfiguration(String id) async {
    try {
      await _repository.delete(id, _authProvider.currentFarmId);

      // Retirer du cache local
      _allConfigurations.removeWhere((c) => c.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error deleting alert configuration: $e');
      rethrow;
    }
  }

  // ==================== Toggle Enable/Disable ====================

  /// Bascule l'activation/désactivation d'une configuration
  /// Permet au farmer de désactiver des alertes sans les supprimer
  Future<void> toggleEnabled(String id, bool newState) async {
    try {
      await _repository.toggleEnabled(id, _authProvider.currentFarmId, newState);

      final index = _allConfigurations.indexWhere((c) => c.id == id);
      if (index != -1) {
        _allConfigurations[index] = _allConfigurations[index].copyWith(
          enabled: newState,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error toggling alert configuration: $e');
      rethrow;
    }
  }

  /// Active toutes les configurations de la ferme
  Future<void> enableAll() async {
    try {
      for (final config in configurations.where((c) => !c.enabled)) {
        await toggleEnabled(config.id, true);
      }
    } catch (e) {
      debugPrint('❌ Error enabling all configurations: $e');
      rethrow;
    }
  }

  /// Désactive toutes les configurations de la ferme
  Future<void> disableAll() async {
    try {
      for (final config in configurations.where((c) => c.enabled)) {
        await toggleEnabled(config.id, false);
      }
    } catch (e) {
      debugPrint('❌ Error disabling all configurations: $e');
      rethrow;
    }
  }

  // ==================== Query Methods ====================

  AlertConfiguration? getConfigurationById(String id) {
    try {
      return configurations.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  // ==================== Statistics ====================

  Map<String, dynamic> get stats {
    final enabled = enabledConfigurations;
    return {
      'total': configurations.length,
      'enabled': enabled.length,
      'disabled': configurations.length - enabled.length,
      'critical': getBySeverity(3).length,
      'important': getBySeverity(2).length,
      'routine': getBySeverity(1).length,
    };
  }

  // ==================== Initialization ====================

  /// Initialise les configurations par défaut pour une nouvelle ferme
  /// Appelé lors de la première configuration d'une ferme
  Future<void> initializeDefaultConfigurations() async {
    // NOTE: Implémentation des configurations par défaut
    // À définir selon les besoins métier (rémanence, vaccination, etc.)
    // Pour l'instant, on laisse vide - sera implémenté en Phase 1B
    debugPrint(
        '⚠️ Initialize default alert configurations not yet implemented');
  }

  // ==================== Refresh ====================

  Future<void> refresh() async {
    await _loadConfigurationsFromRepository();
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onFarmChanged);
    super.dispose();
  }
}
