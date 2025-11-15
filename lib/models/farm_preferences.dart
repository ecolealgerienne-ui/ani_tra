// lib/models/farm_preferences.dart
import 'syncable_entity.dart';

/// Préférences spécifiques à une ferme
///
/// Stocke les paramètres par défaut pour une ferme donnée :
/// - Vétérinaire par défaut
/// - Type d'animal par défaut (species)
/// - Race par défaut
class FarmPreferences implements SyncableEntity {
  // ═══════════════════════════════════════════════════════════
  // IDENTIFICATION
  // ═══════════════════════════════════════════════════════════

  @override
  final String id;

  @override
  final String farmId; // FK → Farms

  // ═══════════════════════════════════════════════════════════
  // PREFERENCES
  // ═══════════════════════════════════════════════════════════

  /// Vétérinaire par défaut pour cette ferme (nullable)
  final String? defaultVeterinarianId; // FK → Veterinarians

  /// Type d'animal par défaut (Ex: 'sheep', 'cattle', 'goat')
  final String defaultSpeciesId;

  /// Race par défaut (Ex: 'merinos', 'charolaise', nullable)
  final String? defaultBreedId;

  // ═══════════════════════════════════════════════════════════
  // SYNC FIELDS (Phase 2)
  // ═══════════════════════════════════════════════════════════

  @override
  final bool synced;

  @override
  final DateTime? lastSyncedAt;

  @override
  final String? serverVersion;

  // ═══════════════════════════════════════════════════════════
  // SOFT-DELETE & AUDIT
  // ═══════════════════════════════════════════════════════════

  /// Soft-delete timestamp (null = active)
  final DateTime? deletedAt;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  // ═══════════════════════════════════════════════════════════
  // CONSTRUCTOR
  // ═══════════════════════════════════════════════════════════

  const FarmPreferences({
    required this.id,
    required this.farmId,
    this.defaultVeterinarianId,
    required this.defaultSpeciesId,
    this.defaultBreedId,
    this.synced = false,
    this.lastSyncedAt,
    this.serverVersion,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // ═══════════════════════════════════════════════════════════
  // GETTERS
  // ═══════════════════════════════════════════════════════════

  /// Préférence active (non supprimée)
  bool get isActive => deletedAt == null;

  /// A un vétérinaire par défaut défini
  bool get hasDefaultVeterinarian =>
      defaultVeterinarianId != null && defaultVeterinarianId!.isNotEmpty;

  /// A une race par défaut définie
  bool get hasDefaultBreed =>
      defaultBreedId != null && defaultBreedId!.isNotEmpty;

  // ═══════════════════════════════════════════════════════════
  // METHODS
  // ═══════════════════════════════════════════════════════════

  /// Créer une copie avec modifications
  FarmPreferences copyWith({
    String? id,
    String? farmId,
    String? defaultVeterinarianId,
    String? defaultSpeciesId,
    String? defaultBreedId,
    bool? synced,
    DateTime? lastSyncedAt,
    String? serverVersion,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FarmPreferences(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      defaultVeterinarianId:
          defaultVeterinarianId ?? this.defaultVeterinarianId,
      defaultSpeciesId: defaultSpeciesId ?? this.defaultSpeciesId,
      defaultBreedId: defaultBreedId ?? this.defaultBreedId,
      synced: synced ?? this.synced,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // SYNC METHODS
  // ═══════════════════════════════════════════════════════════

  /// Marquer comme synchronisé
  FarmPreferences markAsSynced({required String serverVersion}) {
    return copyWith(
      synced: true,
      lastSyncedAt: DateTime.now(),
      serverVersion: serverVersion,
    );
  }

  /// Marquer comme modifié (non synchronisé)
  FarmPreferences markAsModified() {
    return copyWith(
      synced: false,
      updatedAt: DateTime.now(),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // JSON SERIALIZATION
  // ═══════════════════════════════════════════════════════════

  Map<String, dynamic> toJson() => {
        'id': id,
        'farm_id': farmId,
        'default_veterinarian_id': defaultVeterinarianId,
        'default_species_id': defaultSpeciesId,
        'default_breed_id': defaultBreedId,
        'synced': synced,
        'last_synced_at': lastSyncedAt?.toIso8601String(),
        'server_version': serverVersion,
        'deleted_at': deletedAt?.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory FarmPreferences.fromJson(Map<String, dynamic> json) =>
      FarmPreferences(
        id: json['id'] as String,
        farmId: json['farm_id'] as String,
        defaultVeterinarianId: json['default_veterinarian_id'] as String?,
        defaultSpeciesId: json['default_species_id'] as String,
        defaultBreedId: json['default_breed_id'] as String?,
        synced: json['synced'] as bool? ?? false,
        lastSyncedAt: json['last_synced_at'] != null
            ? DateTime.parse(json['last_synced_at'] as String)
            : null,
        serverVersion: json['server_version'] as String?,
        deletedAt: json['deleted_at'] != null
            ? DateTime.parse(json['deleted_at'] as String)
            : null,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
      );

  @override
  String toString() => 'FarmPreferences('
      'id: $id, '
      'farmId: $farmId, '
      'defaultVetId: $defaultVeterinarianId, '
      'defaultSpecies: $defaultSpeciesId, '
      'defaultBreed: $defaultBreedId'
      ')';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FarmPreferences &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          farmId == other.farmId;

  @override
  int get hashCode => id.hashCode ^ farmId.hashCode;
}
