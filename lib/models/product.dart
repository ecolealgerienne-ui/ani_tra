// lib/models/product.dart

import 'syncable_entity.dart';

class Product implements SyncableEntity {
  // === Identification ===
  @override
  final String id;
  @override
  final String farmId;

  // === Données métier ===
  final String name;
  final String activeSubstance;
  final int withdrawalDaysMeat;
  final int? withdrawalDaysMilk;
  final double dosagePerKg;

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

  Product({
    required this.id,
    this.farmId = 'farm_default', // Valeur par défaut pour compatibilité mock
    required this.name,
    required this.activeSubstance,
    required this.withdrawalDaysMeat,
    this.withdrawalDaysMilk,
    required this.dosagePerKg,
    this.synced = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastSyncedAt,
    this.serverVersion,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Product copyWith({
    String? farmId,
    String? name,
    String? activeSubstance,
    int? withdrawalDaysMeat,
    int? withdrawalDaysMilk,
    double? dosagePerKg,
    bool? synced,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    String? serverVersion,
  }) {
    return Product(
      id: id,
      farmId: farmId ?? this.farmId,
      name: name ?? this.name,
      activeSubstance: activeSubstance ?? this.activeSubstance,
      withdrawalDaysMeat: withdrawalDaysMeat ?? this.withdrawalDaysMeat,
      withdrawalDaysMilk: withdrawalDaysMilk ?? this.withdrawalDaysMilk,
      dosagePerKg: dosagePerKg ?? this.dosagePerKg,
      synced: synced ?? this.synced,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
    );
  }

  // === Méthodes de sync ===

  Product markAsSynced({required String serverVersion}) {
    return copyWith(
      synced: true,
      lastSyncedAt: DateTime.now(),
      serverVersion: serverVersion,
    );
  }

  Product markAsModified() {
    return copyWith(
      synced: false,
      updatedAt: DateTime.now(),
    );
  }

  // === JSON Serialization (SNAKE_CASE pour compatibilité) ===

  Map<String, dynamic> toJson() => {
        'id': id,
        'farm_id': farmId,
        'name': name,
        'active_substance': activeSubstance,
        'withdrawal_days_meat': withdrawalDaysMeat,
        'withdrawal_days_milk': withdrawalDaysMilk,
        'dosage_per_kg': dosagePerKg,
        'synced': synced,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'last_synced_at': lastSyncedAt?.toIso8601String(),
        'server_version': serverVersion,
      };

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      farmId: json['farm_id'] as String? ?? 'farm_default',
      name: json['name'] as String,
      activeSubstance: json['active_substance'] as String,
      withdrawalDaysMeat: json['withdrawal_days_meat'] as int,
      withdrawalDaysMilk: json['withdrawal_days_milk'] as int?,
      dosagePerKg: (json['dosage_per_kg'] as num).toDouble(),
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

  // === Equals & HashCode ===

  @override
  String toString() => 'Product(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.activeSubstance == activeSubstance &&
        other.withdrawalDaysMeat == withdrawalDaysMeat &&
        other.withdrawalDaysMilk == withdrawalDaysMilk &&
        other.dosagePerKg == dosagePerKg;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        activeSubstance,
        withdrawalDaysMeat,
        withdrawalDaysMilk,
        dosagePerKg,
      );
}
