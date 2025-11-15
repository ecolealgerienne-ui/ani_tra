// lib/models/weight_record.dart

import 'package:flutter/material.dart';
import 'syncable_entity.dart';
import '../i18n/app_localizations.dart';
import '../i18n/app_strings.dart';

/// Enregistrement de pesée d'un animal
///
/// Stocke les données de pesée pour le suivi de croissance et de performance
class WeightRecord implements SyncableEntity {
  // === Identification ===
  @override
  final String id;
  @override
  final String farmId;

  // === Données métier ===
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

  // === Synchronisation ===
  @override
  final bool synced;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? lastSyncedAt;
  @override
  final String? serverVersion;

  WeightRecord({
    required this.id,
    this.farmId = 'mock-farm-001', // Valeur par défaut pour compatibilité mock
    required this.animalId,
    required this.weight,
    required this.recordedAt,
    this.source = WeightSource.manual,
    this.notes,
    this.synced = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastSyncedAt,
    this.serverVersion,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

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
        return '✏️';
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
    String? farmId,
    String? animalId,
    double? weight,
    DateTime? recordedAt,
    WeightSource? source,
    String? notes,
    bool? synced,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    String? serverVersion,
  }) {
    return WeightRecord(
      id: id,
      farmId: farmId ?? this.farmId,
      animalId: animalId ?? this.animalId,
      weight: weight ?? this.weight,
      recordedAt: recordedAt ?? this.recordedAt,
      source: source ?? this.source,
      notes: notes ?? this.notes,
      synced: synced ?? this.synced,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
    );
  }

  // === Méthodes de sync ===

  WeightRecord markAsSynced({required String serverVersion}) {
    return copyWith(
      synced: true,
      lastSyncedAt: DateTime.now(),
      serverVersion: serverVersion,
    );
  }

  WeightRecord markAsModified() {
    return copyWith(
      synced: false,
      updatedAt: DateTime.now(),
    );
  }

  /// Convertir en Map (pour base de données)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'farm_id': farmId,
      'animalId': animalId,
      'weight': weight,
      'recordedAt': recordedAt.toIso8601String(),
      'source': source.toString().split('.').last,
      'notes': notes,
      'synced': synced ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'server_version': serverVersion,
    };
  }

  /// Créer depuis Map (depuis base de données)
  factory WeightRecord.fromMap(Map<String, dynamic> map) {
    return WeightRecord(
      id: map['id'] as String,
      farmId: map['farm_id'] as String? ?? 'mock-farm-001',
      animalId: map['animalId'] as String,
      weight: (map['weight'] as num).toDouble(),
      recordedAt: DateTime.parse(map['recordedAt'] as String),
      source: WeightSource.values.firstWhere(
        (e) => e.toString().split('.').last == map['source'],
        orElse: () => WeightSource.manual,
      ),
      notes: map['notes'] as String?,
      synced: (map['synced'] as int) == 1,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      lastSyncedAt: map['last_synced_at'] != null
          ? DateTime.parse(map['last_synced_at'] as String)
          : null,
      serverVersion: map['server_version'] as String?,
    );
  }

  /// Convertir en JSON (pour API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farm_id': farmId,
      'animal_id': animalId,
      'weight': weight,
      'recorded_at': recordedAt.toIso8601String(),
      'source': source.toString().split('.').last,
      'notes': notes,
      'synced': synced,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'server_version': serverVersion,
    };
  }

  /// Créer depuis JSON (depuis API)
  factory WeightRecord.fromJson(Map<String, dynamic> json) {
    return WeightRecord(
      id: json['id'] as String,
      farmId: json['farm_id'] as String? ?? 'mock-farm-001',
      animalId: json['animal_id'] as String,
      weight: (json['weight'] as num).toDouble(),
      recordedAt: DateTime.parse(json['recorded_at'] as String),
      source: WeightSource.values.firstWhere(
        (e) => e.toString().split('.').last == json['source'],
        orElse: () => WeightSource.manual,
      ),
      notes: json['notes'] as String?,
      synced: json['synced'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
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
    return 'WeightRecord(id: $id, animal: $animalId, weight: $formattedWeight, '
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
  /// Nom localisé (i18n)
  String getLocalizedName(BuildContext context) {
    switch (this) {
      case WeightSource.scale:
        return AppLocalizations.of(context).translate(AppStrings.weightSourceScale);
      case WeightSource.manual:
        return AppLocalizations.of(context).translate(AppStrings.weightSourceManual);
      case WeightSource.estimated:
        return AppLocalizations.of(context).translate(AppStrings.weightSourceEstimated);
      case WeightSource.veterinary:
        return AppLocalizations.of(context).translate(AppStrings.weightSourceVeterinary);
    }
  }

  /// Icône
  String get icon {
    switch (this) {
      case WeightSource.scale:
        return '⚖️';
      case WeightSource.manual:
        return '✏️';
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
