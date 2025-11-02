// lib/models/slaughter_extended.dart

/// Modèle représentant un enregistrement d'abattage
///
/// Contient les informations sur un ou plusieurs animaux abattus,
/// incluant l'abattoir, la date, et les métadonnées associées.
class Slaughter {
  /// Identifiant unique de l'enregistrement d'abattage
  final String id;

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

  /// Indique si l'enregistrement a été synchronisé avec le serveur
  final bool synced;

  /// Date de création de l'enregistrement
  final DateTime createdAt;

  // Champs de synchronisation serveur
  final String? farmId;
  final DateTime? updatedAt;
  final DateTime? lastSyncedAt;
  final String? serverVersion;

  const Slaughter({
    required this.id,
    required this.animalIds,
    this.batchId,
    this.slaughterhouseId,
    this.slaughterhouseName,
    required this.slaughterDate,
    this.notes,
    required this.synced,
    required this.createdAt,
    this.farmId,
    this.updatedAt,
    this.lastSyncedAt,
    this.serverVersion,
  });

  /// Nombre d'animaux dans cet abattage
  int get animalCount => animalIds.length;

  /// Crée une copie avec les champs modifiés
  Slaughter copyWith({
    String? id,
    List<String>? animalIds,
    String? batchId,
    String? slaughterhouseId,
    String? slaughterhouseName,
    DateTime? slaughterDate,
    String? notes,
    bool? synced,
    DateTime? createdAt,
    String? farmId,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    String? serverVersion,
  }) {
    return Slaughter(
      id: id ?? this.id,
      animalIds: animalIds ?? this.animalIds,
      batchId: batchId ?? this.batchId,
      slaughterhouseId: slaughterhouseId ?? this.slaughterhouseId,
      slaughterhouseName: slaughterhouseName ?? this.slaughterhouseName,
      slaughterDate: slaughterDate ?? this.slaughterDate,
      notes: notes ?? this.notes,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      farmId: farmId ?? this.farmId,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
    );
  }

  /// Convertit l'objet en Map pour la sérialisation JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'animalIds': animalIds,
      'batchId': batchId,
      'slaughterhouseId': slaughterhouseId,
      'slaughterhouseName': slaughterhouseName,
      'slaughterDate': slaughterDate.toIso8601String(),
      'notes': notes,
      'synced': synced,
      'createdAt': createdAt.toIso8601String(),
      'farm_id': farmId,
      'updated_at': updatedAt?.toIso8601String(),
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'server_version': serverVersion,
    };
  }

  /// Crée un objet depuis une Map JSON
  factory Slaughter.fromJson(Map<String, dynamic> json) {
    return Slaughter(
      id: json['id'] as String,
      animalIds:
          (json['animalIds'] as List<dynamic>).map((e) => e as String).toList(),
      batchId: json['batchId'] as String?,
      slaughterhouseId: json['slaughterhouseId'] as String?,
      slaughterhouseName: json['slaughterhouseName'] as String?,
      slaughterDate: DateTime.parse(json['slaughterDate'] as String),
      notes: json['notes'] as String?,
      synced: json['synced'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      farmId: json['farm_id'] as String?,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      lastSyncedAt: json['last_synced_at'] != null
          ? DateTime.parse(json['last_synced_at'] as String)
          : null,
      serverVersion: json['server_version'] as String?,
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
