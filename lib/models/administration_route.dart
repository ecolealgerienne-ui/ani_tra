// lib/models/administration_route.dart

import 'package:uuid/uuid.dart';
import 'syncable_entity.dart';

/// Route d'administration de médicaments/vaccins
class AdministrationRoute implements SyncableEntity {
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

  // === AdministrationRoute fields ===
  final String code;
  final String description;
  final List<String> targetSpecies;
  final bool isActive;

  AdministrationRoute({
    String? id,
    required this.farmId,
    required this.code,
    required this.description,
    this.targetSpecies = const [],
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

  String get displayName => '$code - $description';

  AdministrationRoute copyWith({
    String? id,
    String? farmId,
    String? code,
    String? description,
    List<String>? targetSpecies,
    bool? isActive,
    bool? synced,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    String? serverVersion,
  }) {
    return AdministrationRoute(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      code: code ?? this.code,
      description: description ?? this.description,
      targetSpecies: targetSpecies ?? this.targetSpecies,
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
      'code': code,
      'description': description,
      'targetSpecies': targetSpecies,
      'isActive': isActive,
      'synced': synced,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastSyncedAt': lastSyncedAt?.toIso8601String(),
      'serverVersion': serverVersion,
    };
  }

  factory AdministrationRoute.fromJson(Map<String, dynamic> json) {
    return AdministrationRoute(
      id: json['id'] as String?,
      farmId: json['farmId'] as String,
      code: json['code'] as String,
      description: json['description'] as String,
      targetSpecies: (json['targetSpecies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
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
