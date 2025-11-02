// lib/models/product_extended.dart
import 'syncable_entity.dart';

class ProductExtended implements SyncableEntity {
  @override
  final String id;
  @override
  final String farmId;

  final String name;
  final String activeSubstance;
  final int withdrawalDaysMeat;
  final int? withdrawalDaysMilk;
  final double dosagePerKg;

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

  const ProductExtended({
    required this.id,
    required this.farmId,
    required this.name,
    required this.activeSubstance,
    required this.withdrawalDaysMeat,
    this.withdrawalDaysMilk,
    required this.dosagePerKg,
    this.synced = false,
    required this.createdAt,
    required this.updatedAt,
    this.lastSyncedAt,
    this.serverVersion,
  });

  ProductExtended copyWith({
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
    return ProductExtended(
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

  ProductExtended markAsSynced({required String serverVersion}) {
    return copyWith(
      synced: true,
      lastSyncedAt: DateTime.now(),
      serverVersion: serverVersion,
    );
  }

  ProductExtended markAsModified() {
    return copyWith(synced: false, updatedAt: DateTime.now());
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'farmId': farmId,
        'name': name,
        'activeSubstance': activeSubstance,
        'withdrawalDaysMeat': withdrawalDaysMeat,
        'withdrawalDaysMilk': withdrawalDaysMilk,
        'dosagePerKg': dosagePerKg,
        'synced': synced,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'lastSyncedAt': lastSyncedAt?.toIso8601String(),
        'serverVersion': serverVersion,
      };

  factory ProductExtended.fromJson(Map<String, dynamic> json) {
    return ProductExtended(
      id: json['id'] as String,
      farmId: json['farmId'] as String,
      name: json['name'] as String,
      activeSubstance: json['activeSubstance'] as String,
      withdrawalDaysMeat: json['withdrawalDaysMeat'] as int,
      withdrawalDaysMilk: json['withdrawalDaysMilk'] as int?,
      dosagePerKg: (json['dosagePerKg'] as num).toDouble(),
      synced: json['synced'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastSyncedAt: json['lastSyncedAt'] != null
          ? DateTime.parse(json['lastSyncedAt'] as String)
          : null,
      serverVersion: json['serverVersion'] as String?,
    );
  }
}
