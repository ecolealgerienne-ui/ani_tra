// lib/models/disease_reference.dart

import 'package:uuid/uuid.dart';
import 'syncable_entity.dart';

/// Référence de maladie avec espèces cibles
class DiseaseReference implements SyncableEntity {
  // === SyncableEntity implementation ===
  @override
  final String id;
  @override
  final String farmId;
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

  // === DiseaseReference fields ===
  final String name;
  final String? description;
  final String? scientificName;
  final List<String> targetSpecies;
  final String? symptoms;
  final String? treatment;
  final bool isContagious;
  final bool requiresVeterinaryIntervention;
  final bool isActive;

  DiseaseReference({
    String? id,
    required this.farmId,
    required this.name,
    this.description,
    this.scientificName,
    this.targetSpecies = const [],
    this.symptoms,
    this.treatment,
    this.isContagious = false,
    this.requiresVeterinaryIntervention = false,
    this.isActive = true,
    this.synced = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastSyncedAt,
    this.serverVersion,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  bool isCompatibleWith(String species) {
    if (targetSpecies.isEmpty) return true;
    return targetSpecies.any((s) => s.toLowerCase() == species.toLowerCase());
  }

  String get displayName {
    if (targetSpecies.isEmpty) return name;
    return '$name (${targetSpecies.join(", ")})';
  }

  DiseaseReference copyWith({
    String? id,
    String? farmId,
    String? name,
    String? description,
    String? scientificName,
    List<String>? targetSpecies,
    String? symptoms,
    String? treatment,
    bool? isContagious,
    bool? requiresVeterinaryIntervention,
    bool? isActive,
    bool? synced,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    String? serverVersion,
  }) {
    return DiseaseReference(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      name: name ?? this.name,
      description: description ?? this.description,
      scientificName: scientificName ?? this.scientificName,
      targetSpecies: targetSpecies ?? this.targetSpecies,
      symptoms: symptoms ?? this.symptoms,
      treatment: treatment ?? this.treatment,
      isContagious: isContagious ?? this.isContagious,
      requiresVeterinaryIntervention:
          requiresVeterinaryIntervention ?? this.requiresVeterinaryIntervention,
      isActive: isActive ?? this.isActive,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmId': farmId,
      'name': name,
      'description': description,
      'scientificName': scientificName,
      'targetSpecies': targetSpecies,
      'symptoms': symptoms,
      'treatment': treatment,
      'isContagious': isContagious,
      'requiresVeterinaryIntervention': requiresVeterinaryIntervention,
      'isActive': isActive,
      'synced': synced,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastSyncedAt': lastSyncedAt?.toIso8601String(),
      'serverVersion': serverVersion,
    };
  }

  factory DiseaseReference.fromJson(Map<String, dynamic> json) {
    return DiseaseReference(
      id: json['id'] as String?,
      farmId: json['farmId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      scientificName: json['scientificName'] as String?,
      targetSpecies: (json['targetSpecies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      symptoms: json['symptoms'] as String?,
      treatment: json['treatment'] as String?,
      isContagious: json['isContagious'] as bool? ?? false,
      requiresVeterinaryIntervention:
          json['requiresVeterinaryIntervention'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      synced: json['synced'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      lastSyncedAt: json['lastSyncedAt'] != null
          ? DateTime.parse(json['lastSyncedAt'] as String)
          : null,
      serverVersion: json['serverVersion'] as String?,
    );
  }
}

class DiseaseTargetSpecies {
  static const String ovine = 'ovine';
  static const String bovine = 'bovine';
  static const String caprine = 'caprine';
  static const List<String> all = [ovine, bovine, caprine];
}
