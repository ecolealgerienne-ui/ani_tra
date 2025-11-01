// lib/models/farm_settings.dart

/// Paramètres de l'exploitation agricole
///
/// Stocke les préférences de l'utilisateur pour l'application,
/// notamment les valeurs par défaut pour l'ajout d'animaux.
class FarmSettings {
  /// Nom de l'exploitation (optionnel)
  final String? farmName;

  /// Type d'animal par défaut (species)
  /// Exemple : 'sheep', 'cattle', 'goat'
  final String defaultSpeciesId;

  /// Race par défaut (breed)
  /// Exemple : 'merinos', 'charolaise', 'alpine'
  final String? defaultBreedId;

  /// Langue de l'application
  final String locale;

  /// Thème sombre activé
  final bool darkMode;

  /// Notifications activées
  final bool notificationsEnabled;

  /// Date de création des paramètres
  final DateTime createdAt;

  /// Date de dernière modification
  final DateTime updatedAt;

  const FarmSettings({
    this.farmName,
    this.defaultSpeciesId = 'sheep',
    this.defaultBreedId = 'merinos',
    this.locale = 'fr',
    this.darkMode = false,
    this.notificationsEnabled = true,
    required this.createdAt,
    required this.updatedAt,
  });

  // ==================== GETTERS ====================

  /// Vérifier si un type par défaut est configuré
  bool get hasDefaultSpecies => defaultSpeciesId.isNotEmpty;

  /// Vérifier si une race par défaut est configurée
  bool get hasDefaultBreed =>
      defaultBreedId != null && defaultBreedId!.isNotEmpty;

  // ==================== CONVERSIONS ====================

  /// Créer une copie avec modifications
  FarmSettings copyWith({
    String? farmName,
    String? defaultSpeciesId,
    String? defaultBreedId,
    String? locale,
    bool? darkMode,
    bool? notificationsEnabled,
    DateTime? updatedAt,
  }) {
    return FarmSettings(
      farmName: farmName ?? this.farmName,
      defaultSpeciesId: defaultSpeciesId ?? this.defaultSpeciesId,
      defaultBreedId: defaultBreedId ?? this.defaultBreedId,
      locale: locale ?? this.locale,
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Convertir en Map (pour SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'farm_name': farmName,
      'default_species_id': defaultSpeciesId,
      'default_breed_id': defaultBreedId,
      'locale': locale,
      'dark_mode': darkMode ? 1 : 0,
      'notifications_enabled': notificationsEnabled ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Créer depuis Map (depuis SharedPreferences)
  factory FarmSettings.fromMap(Map<String, dynamic> map) {
    return FarmSettings(
      farmName: map['farm_name'] as String?,
      defaultSpeciesId: map['default_species_id'] as String? ?? 'sheep',
      defaultBreedId: map['default_breed_id'] as String?,
      locale: map['locale'] as String? ?? 'fr',
      darkMode: (map['dark_mode'] as int?) == 1,
      notificationsEnabled: (map['notifications_enabled'] as int?) != 0,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : DateTime.now(),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : DateTime.now(),
    );
  }

  /// Convertir en JSON (pour API)
  Map<String, dynamic> toJson() {
    return {
      'farm_name': farmName,
      'default_species_id': defaultSpeciesId,
      'default_breed_id': defaultBreedId,
      'locale': locale,
      'dark_mode': darkMode,
      'notifications_enabled': notificationsEnabled,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Créer depuis JSON (depuis API)
  factory FarmSettings.fromJson(Map<String, dynamic> json) {
    return FarmSettings(
      farmName: json['farm_name'] as String?,
      defaultSpeciesId: json['default_species_id'] as String? ?? 'sheep',
      defaultBreedId: json['default_breed_id'] as String?,
      locale: json['locale'] as String? ?? 'fr',
      darkMode: json['dark_mode'] as bool? ?? false,
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'FarmSettings('
        'farmName: $farmName, '
        'defaultSpecies: $defaultSpeciesId, '
        'defaultBreed: $defaultBreedId, '
        'locale: $locale'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FarmSettings &&
        other.farmName == farmName &&
        other.defaultSpeciesId == defaultSpeciesId &&
        other.defaultBreedId == defaultBreedId &&
        other.locale == locale &&
        other.darkMode == darkMode &&
        other.notificationsEnabled == notificationsEnabled;
  }

  @override
  int get hashCode {
    return Object.hash(
      farmName,
      defaultSpeciesId,
      defaultBreedId,
      locale,
      darkMode,
      notificationsEnabled,
    );
  }

  // ==================== FACTORY CONSTRUCTORS ====================

  /// Paramètres par défaut (Ovin - Mérinos)
  factory FarmSettings.defaultSettings() {
    final now = DateTime.now();
    return FarmSettings(
      defaultSpeciesId: 'sheep',
      defaultBreedId: 'merinos',
      locale: 'fr',
      createdAt: now,
      updatedAt: now,
    );
  }
}
