// lib/models/slaughter.dart
import 'syncable_entity.dart';

/// Modèle représentant un enregistrement d'abattage
///
/// Contient les informations sur un ou plusieurs animaux abattus,
/// incluant l'abattoir, la date, et les métadonnées associées.
class Slaughter implements SyncableEntity {
  /// Identifiant unique de l'enregistrement d'abattage
  @override
  final String id;

  /// ID de la ferme (multi-tenancy)
  @override
  final String farmId;

  /// Liste des identifiants des animaux abattus
  final List<String> animalIds;

  /// Identifiant du lot (si abattage groupé depuis un lot)
  final String? batchId;

  /// Identifiant de l'abattoir
  final String? slaughterhouseId;

  /// Nom de l'abattoir
  final String? slaughterhouseName;

  /// Date de l'abattage
  final DateTime slaughterDate;

  /// Notes ou observations
  final String? notes;

  // ==================== Champs SyncableEntity ====================

  /// Indique si l'enregistrement a été synchronisé avec le serveur
  @override
  final bool synced;

  /// Date de création de l'enregistrement
  @override
  final DateTime createdAt;

  /// Date de dernière modification
  @override
  final DateTime updatedAt;

  /// Date de dernière synchronisation
  @override
  final DateTime? lastSyncedAt;

  /// Version serveur
  @override
  final String? serverVersion;

  // ==================== Constructeur ====================

  Slaughter({
    required this.id,
    this.farmId = 'mock-farm-001', // Valeur par défaut pour compatibilité mock
    required this.animalIds,
    this.batchId,
    this.slaughterhouseId,
    this.slaughterhouseName,
    required this.slaughterDate,
    this.notes,
    this.synced = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastSyncedAt,
    this.serverVersion,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? createdAt ?? DateTime.now();

  // ==================== Getters ====================

  /// Nombre d'animaux dans cet abattage
  int get animalCount => animalIds.length;

  /// L'abattage concerne-t-il un lot ?
  bool get isFromBatch => batchId != null;

  /// Un abattoir est-il renseigné ?
  bool get hasSlaughterhouse =>
      slaughterhouseId != null || slaughterhouseName != null;

  // ==================== Méthodes ====================

  /// Crée une copie avec les champs modifiés
  Slaughter copyWith({
    String? id,
    String? farmId,
    List<String>? animalIds,
    String? batchId,
    String? slaughterhouseId,
    String? slaughterhouseName,
    DateTime? slaughterDate,
    String? notes,
    bool? synced,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    String? serverVersion,
  }) {
    return Slaughter(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      animalIds: animalIds ?? this.animalIds,
      batchId: batchId ?? this.batchId,
      slaughterhouseId: slaughterhouseId ?? this.slaughterhouseId,
      slaughterhouseName: slaughterhouseName ?? this.slaughterhouseName,
      slaughterDate: slaughterDate ?? this.slaughterDate,
      notes: notes ?? this.notes,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
    );
  }

  /// Marquer comme synchronisé avec le serveur
  Slaughter markAsSynced({required String serverVersion}) {
    return copyWith(
      synced: true,
      lastSyncedAt: DateTime.now(),
      serverVersion: serverVersion,
    );
  }

  /// Marquer comme modifié (à synchroniser)
  Slaughter markAsModified() {
    return copyWith(
      synced: false,
      updatedAt: DateTime.now(),
    );
  }

  // ==================== Sérialisation ====================

  /// Convertit l'objet en Map pour la sérialisation JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmId': farmId,
      'animalIds': animalIds,
      'batchId': batchId,
      'slaughterhouseId': slaughterhouseId,
      'slaughterhouseName': slaughterhouseName,
      'slaughterDate': slaughterDate.toIso8601String(),
      'notes': notes,
      'synced': synced,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastSyncedAt': lastSyncedAt?.toIso8601String(),
      'serverVersion': serverVersion,
    };
  }

  /// Crée un objet depuis une Map JSON
  factory Slaughter.fromJson(Map<String, dynamic> json) {
    return Slaughter(
      id: json['id'] as String,
      farmId: json['farmId'] as String? ??
          json['farm_id'] as String? ??
          'mock-farm-001',
      animalIds: (json['animalIds'] ?? json['animal_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      batchId: json['batchId'] as String? ?? json['batch_id'] as String?,
      slaughterhouseId: json['slaughterhouseId'] as String? ??
          json['slaughterhouse_id'] as String?,
      slaughterhouseName: json['slaughterhouseName'] as String? ??
          json['slaughterhouse_name'] as String?,
      slaughterDate: DateTime.parse(
          json['slaughterDate'] ?? json['slaughter_date'] as String),
      notes: json['notes'] as String?,
      synced: json['synced'] as bool? ?? false,
      createdAt:
          DateTime.parse(json['createdAt'] ?? json['created_at'] as String),
      updatedAt: json['updatedAt'] != null || json['updated_at'] != null
          ? DateTime.parse(json['updatedAt'] ?? json['updated_at'] as String)
          : DateTime.now(),
      lastSyncedAt:
          json['lastSyncedAt'] != null || json['last_synced_at'] != null
              ? DateTime.parse(
                  json['lastSyncedAt'] ?? json['last_synced_at'] as String)
              : null,
      serverVersion:
          json['serverVersion'] as String? ?? json['server_version'] as String?,
    );
  }

  @override
  String toString() {
    return 'Slaughter(id: $id, animalCount: $animalCount, '
        'slaughterDate: $slaughterDate, synced: $synced)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Slaughter &&
        other.id == id &&
        other.slaughterDate == slaughterDate;
  }

  @override
  int get hashCode => id.hashCode ^ slaughterDate.hashCode;
}
