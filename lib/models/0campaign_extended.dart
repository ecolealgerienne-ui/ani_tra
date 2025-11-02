// lib/models/campaign_extended.dart
import 'package:uuid/uuid.dart';
import 'syncable_entity.dart';

class CampaignExtended implements SyncableEntity {
  @override
  final String id;
  @override
  final String farmId;

  final String name;
  final String productId;
  final String productName;
  final DateTime campaignDate;
  final DateTime withdrawalEndDate;
  final String? veterinarianId;
  final String? veterinarianName;
  final List<String> animalIds;
  final bool completed;

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

  CampaignExtended({
    String? id,
    required this.farmId,
    required this.name,
    required this.productId,
    required this.productName,
    required this.campaignDate,
    required this.withdrawalEndDate,
    this.veterinarianId,
    this.veterinarianName,
    this.animalIds = const [],
    this.completed = false,
    this.synced = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastSyncedAt,
    this.serverVersion,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? createdAt ?? DateTime.now();

  int get animalCount => animalIds.length;

  CampaignExtended copyWith({
    String? farmId,
    String? name,
    String? productId,
    String? productName,
    DateTime? campaignDate,
    DateTime? withdrawalEndDate,
    String? veterinarianId,
    String? veterinarianName,
    List<String>? animalIds,
    bool? completed,
    bool? synced,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    String? serverVersion,
  }) {
    return CampaignExtended(
      id: id,
      farmId: farmId ?? this.farmId,
      name: name ?? this.name,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      campaignDate: campaignDate ?? this.campaignDate,
      withdrawalEndDate: withdrawalEndDate ?? this.withdrawalEndDate,
      veterinarianId: veterinarianId ?? this.veterinarianId,
      veterinarianName: veterinarianName ?? this.veterinarianName,
      animalIds: animalIds ?? this.animalIds,
      completed: completed ?? this.completed,
      synced: synced ?? this.synced,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
    );
  }

  CampaignExtended markAsSynced({required String serverVersion}) {
    return copyWith(
      synced: true,
      lastSyncedAt: DateTime.now(),
      serverVersion: serverVersion,
    );
  }

  CampaignExtended markAsModified() {
    return copyWith(synced: false, updatedAt: DateTime.now());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmId': farmId,
      'name': name,
      'productId': productId,
      'productName': productName,
      'campaignDate': campaignDate.toIso8601String(),
      'withdrawalEndDate': withdrawalEndDate.toIso8601String(),
      'veterinarianId': veterinarianId,
      'veterinarianName': veterinarianName,
      'animalIds': animalIds,
      'completed': completed,
      'synced': synced,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastSyncedAt': lastSyncedAt?.toIso8601String(),
      'serverVersion': serverVersion,
    };
  }

  factory CampaignExtended.fromJson(Map<String, dynamic> json) {
    return CampaignExtended(
      id: json['id'],
      farmId: json['farmId'] as String,
      name: json['name'],
      productId: json['productId'],
      productName: json['productName'],
      campaignDate: DateTime.parse(json['campaignDate']),
      withdrawalEndDate: DateTime.parse(json['withdrawalEndDate']),
      veterinarianId: json['veterinarianId'],
      veterinarianName: json['veterinarianName'],
      animalIds: List<String>.from(json['animalIds'] ?? []),
      completed: json['completed'] ?? false,
      synced: json['synced'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      lastSyncedAt: json['lastSyncedAt'] != null
          ? DateTime.parse(json['lastSyncedAt'])
          : null,
      serverVersion: json['serverVersion'] as String?,
    );
  }
}
