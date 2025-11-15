// lib/providers/settings_provider.dart

import 'package:flutter/foundation.dart';
import '../models/farm_settings.dart';

/// Provider de gestion des paramètres de l'application
///
/// Gère les préférences utilisateur, notamment :
/// - Type et race d'animal par défaut
/// - Langue de l'application
/// - Thème (clair/sombre)
/// - Notifications
///
/// ÉTAPE 4 : Permet de configurer les valeurs par défaut pour l'ajout d'animaux
class SettingsProvider extends ChangeNotifier {
  FarmSettings _settings = FarmSettings.defaultSettings();

  /// Paramètres actuels
  FarmSettings get settings => _settings;

  /// Type d'animal par défaut
  String get defaultSpeciesId => _settings.defaultSpeciesId;

  /// Race par défaut
  String? get defaultBreedId => _settings.defaultBreedId;

  /// Nom de l'exploitation
  String? get farmName => _settings.farmName;

  /// Langue de l'application
  String get locale => _settings.locale;

  /// Thème sombre activé
  bool get darkMode => _settings.darkMode;

  /// Notifications activées
  bool get notificationsEnabled => _settings.notificationsEnabled;

  // ==================== INITIALISATION ====================

  /// Initialiser avec les paramètres par défaut
  void initializeWithDefaults() {
    _settings = FarmSettings.defaultSettings();
    notifyListeners();
  }

  /// Charger les paramètres (depuis SharedPreferences ou API)
  Future<void> loadSettings() async {
    // TODO: Charger depuis SharedPreferences
    // final prefs = await SharedPreferences.getInstance();
    // final json = prefs.getString('farm_settings');
    // if (json != null) {
    //   _settings = FarmSettings.fromJson(jsonDecode(json));
    //   notifyListeners();
    // }
  }

  /// Sauvegarder les paramètres (dans SharedPreferences)
  Future<void> saveSettings() async {
    // TODO: Sauvegarder dans SharedPreferences
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('farm_settings', jsonEncode(_settings.toJson()));

  }

  // ==================== MODIFICATION DES PARAMÈTRES ====================

  /// Définir les valeurs par défaut pour le type et la race
  void setDefaultAnimalType({
    required String speciesId,
    String? breedId,
  }) {
    _settings = _settings.copyWith(
      defaultSpeciesId: speciesId,
      defaultBreedId: breedId,
    );
    notifyListeners();
    saveSettings();
  }

  /// Définir le type d'animal par défaut
  void setDefaultSpecies(String speciesId) {
    _settings = _settings.copyWith(defaultSpeciesId: speciesId);
    notifyListeners();
    saveSettings();
  }

  /// Définir la race par défaut
  void setDefaultBreed(String? breedId) {
    _settings = _settings.copyWith(defaultBreedId: breedId);
    notifyListeners();
    saveSettings();
  }

  /// Définir le nom de l'exploitation
  void setFarmName(String? name) {
    _settings = _settings.copyWith(farmName: name);
    notifyListeners();
    saveSettings();
  }

  /// Changer la langue
  void setLocale(String locale) {
    _settings = _settings.copyWith(locale: locale);
    notifyListeners();
    saveSettings();
  }

  /// Activer/désactiver le thème sombre
  void setDarkMode(bool enabled) {
    _settings = _settings.copyWith(darkMode: enabled);
    notifyListeners();
    saveSettings();
  }

  /// Activer/désactiver les notifications
  void setNotifications(bool enabled) {
    _settings = _settings.copyWith(notificationsEnabled: enabled);
    notifyListeners();
    saveSettings();
  }

  /// Mettre à jour tous les paramètres
  void updateSettings(FarmSettings newSettings) {
    _settings = newSettings;
    notifyListeners();
    saveSettings();
  }

  /// Réinitialiser aux valeurs par défaut
  void resetToDefaults() {
    _settings = FarmSettings.defaultSettings();
    notifyListeners();
    saveSettings();
  }

  // ==================== UTILITAIRES ====================

  /// Vérifier si les paramètres sont configurés (pas les valeurs par défaut)
  bool get isConfigured {
    return _settings.farmName != null && _settings.farmName!.isNotEmpty;
  }

  /// Obtenir un résumé des paramètres
  String getSummary() {
    return '''
Exploitation: ${_settings.farmName ?? 'Non défini'}
Type par défaut: ${_settings.defaultSpeciesId}
Race par défaut: ${_settings.defaultBreedId ?? 'Non définie'}
Langue: ${_settings.locale}
Mode sombre: ${_settings.darkMode ? 'Activé' : 'Désactivé'}
Notifications: ${_settings.notificationsEnabled ? 'Activées' : 'Désactivées'}
''';
  }
}
