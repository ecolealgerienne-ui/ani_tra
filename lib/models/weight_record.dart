// lib/models/weight_record.dart

/// Enregistrement de pesée d'un animal
///
/// Stocke les données de pesée pour le suivi de croissance et de performance
class WeightRecord {
  /// Identifiant unique de la pesée
  final String id;

  /// ID de l'animal pesé
  final String animalId;

  /// Poids en kilogrammes
  final double weight;

  /// Date et heure de la pesée
  final DateTime recordedAt;

  /// Source de la pesée (balance, estimation, etc.)
  final WeightSource source;

  /// Notes optionnelles sur la pesée
  final String? notes;

  /// État de synchronisation avec le serveur
  final bool synced;

  /// Date de création de l'enregistrement
  final DateTime createdAt;

  /// Date de dernière modification
  final DateTime? updatedAt;

  const WeightRecord({
    required this.id,
    required this.animalId,
    required this.weight,
    required this.recordedAt,
    this.source = WeightSource.manual,
    this.notes,
    this.synced = false,
    required this.createdAt,
    this.updatedAt,
  });

  // ==================== Getters de commodité ====================

  /// Poids formaté avec unité
  String get formattedWeight => '${weight.toStringAsFixed(1)} kg';

  /// Date formatée
  String get formattedDate {
    final day = recordedAt.day.toString().padLeft(2, '0');
    final month = recordedAt.month.toString().padLeft(2, '0');
    final year = recordedAt.year;
    return '$day/$month/$year';
  }

  /// Date et heure formatées
  String get formattedDateTime {
    final hour = recordedAt.hour.toString().padLeft(2, '0');
    final minute = recordedAt.minute.toString().padLeft(2, '0');
    return '$formattedDate $hour:$minute';
  }

  /// Icône selon la source
  String get sourceIcon {
    switch (source) {
      case WeightSource.scale:
        return '⚖️';
      case WeightSource.manual:
        return '✍️';
      case WeightSource.estimated:
        return '📊';
      case WeightSource.veterinary:
        return '🏥';
    }
  }

  /// Label de la source en français
  String get sourceLabel {
    switch (source) {
      case WeightSource.scale:
        return 'Balance';
      case WeightSource.manual:
        return 'Manuel';
      case WeightSource.estimated:
        return 'Estimé';
      case WeightSource.veterinary:
        return 'Vétérinaire';
    }
  }

  /// La pesée est-elle récente (moins de 7 jours) ?
  bool get isRecent {
    final daysAgo = DateTime.now().difference(recordedAt).inDays;
    return daysAgo <= 7;
  }

  /// La pesée date d'aujourd'hui ?
  bool get isToday {
    final now = DateTime.now();
    return recordedAt.year == now.year &&
        recordedAt.month == now.month &&
        recordedAt.day == now.day;
  }

  // ==================== Méthodes ====================

  /// Créer une copie avec modifications
  WeightRecord copyWith({
    String? id,
    String? animalId,
    double? weight,
    DateTime? recordedAt,
    WeightSource? source,
    String? notes,
    bool? synced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WeightRecord(
      id: id ?? this.id,
      animalId: animalId ?? this.animalId,
      weight: weight ?? this.weight,
      recordedAt: recordedAt ?? this.recordedAt,
      source: source ?? this.source,
      notes: notes ?? this.notes,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Marquer comme synchronisé
  WeightRecord markAsSynced() {
    return copyWith(synced: true, updatedAt: DateTime.now());
  }

  /// Convertir en Map (pour base de données)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'animalId': animalId,
      'weight': weight,
      'recordedAt': recordedAt.toIso8601String(),
      'source': source.toString().split('.').last,
      'notes': notes,
      'synced': synced ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Créer depuis Map (depuis base de données)
  factory WeightRecord.fromMap(Map<String, dynamic> map) {
    return WeightRecord(
      id: map['id'] as String,
      animalId: map['animalId'] as String,
      weight: (map['weight'] as num).toDouble(),
      recordedAt: DateTime.parse(map['recordedAt'] as String),
      source: WeightSource.values.firstWhere(
        (e) => e.toString().split('.').last == map['source'],
        orElse: () => WeightSource.manual,
      ),
      notes: map['notes'] as String?,
      synced: (map['synced'] as int) == 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  /// Convertir en JSON (pour API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'animal_id': animalId,
      'weight': weight,
      'recorded_at': recordedAt.toIso8601String(),
      'source': source.toString().split('.').last,
      'notes': notes,
      'synced': synced,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Créer depuis JSON (depuis API)
  factory WeightRecord.fromJson(Map<String, dynamic> json) {
    return WeightRecord(
      id: json['id'] as String,
      animalId: json['animal_id'] as String,
      weight: (json['weight'] as num).toDouble(),
      recordedAt: DateTime.parse(json['recorded_at'] as String),
      source: WeightSource.values.firstWhere(
        (e) => e.toString().split('.').last == json['source'],
        orElse: () => WeightSource.manual,
      ),
      notes: json['notes'] as String?,
      synced: json['synced'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  @override
  String toString() {
    return 'WeightRecord(id: $id, animal: $animalId, weight: ${formattedWeight}, '
        'date: $formattedDate, source: $sourceLabel, synced: $synced)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeightRecord && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Source de la mesure de poids
enum WeightSource {
  /// Pesée avec balance électronique
  scale,

  /// Saisie manuelle
  manual,

  /// Estimation visuelle
  estimated,

  /// Pesée vétérinaire
  veterinary,
}

/// Extensions pour WeightSource
extension WeightSourceExtension on WeightSource {
  /// Nom en français
  String get frenchName {
    switch (this) {
      case WeightSource.scale:
        return 'Balance';
      case WeightSource.manual:
        return 'Manuel';
      case WeightSource.estimated:
        return 'Estimé';
      case WeightSource.veterinary:
        return 'Vétérinaire';
    }
  }

  /// Icône
  String get icon {
    switch (this) {
      case WeightSource.scale:
        return '⚖️';
      case WeightSource.manual:
        return '✍️';
      case WeightSource.estimated:
        return '📊';
      case WeightSource.veterinary:
        return '🏥';
    }
  }

  /// Fiabilité (de 0 à 1)
  double get reliability {
    switch (this) {
      case WeightSource.scale:
        return 1.0;
      case WeightSource.veterinary:
        return 0.95;
      case WeightSource.manual:
        return 0.8;
      case WeightSource.estimated:
        return 0.6;
    }
  }
}
