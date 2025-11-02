// lib/models/lot_extended.dart
import 'package:uuid/uuid.dart';
import 'syncable_entity.dart';

enum LotType { treatment, sale, slaughter }

class LotExtended implements SyncableEntity {
  @override
  final String id;
  @override
  final String farmId;

  final String name;
  final LotType? type;
  final List<String> animalIds;
  final bool completed;
  final DateTime? completedAt;

  // Traitement
  final String? productId;
  final String? productName;
  final DateTime? treatmentDate;
  final DateTime? withdrawalEndDate;
  final String? veterinarianId;
  final String? veterinarianName;

  // Vente
  final String? buyerName;
  final String? buyerFarmId;
  final double? totalPrice;
  final double? pricePerAnimal;
  final DateTime? saleDate;

  // Abattage
  final String? slaughterhouseName;
  final String? slaughterhouseId;
  final DateTime? slaughterDate;

  final String? notes;

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

  LotExtended({
    String? id,
    required this.farmId,
    required this.name,
    this.type,
    this.animalIds = const [],
    this.completed = false,
    this.completedAt,
    this.productId,
    this.productName,
    this.treatmentDate,
    this.withdrawalEndDate,
    this.veterinarianId,
    this.veterinarianName,
    this.buyerName,
    this.buyerFarmId,
    this.totalPrice,
    this.pricePerAnimal,
    this.saleDate,
    this.slaughterhouseName,
    this.slaughterhouseId,
    this.slaughterDate,
    this.notes,
    this.synced = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastSyncedAt,
    this.serverVersion,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? createdAt ?? DateTime.now();

  int get animalCount => animalIds.length;
  bool get isOpen => !completed;
  bool get isClosed => completed;

  LotExtended copyWith({
    String? farmId,
    String? name,
    LotType? type,
    bool clearType = false,
    List<String>? animalIds,
    bool? completed,
    DateTime? completedAt,
    bool clearCompletedAt = false,
    String? productId,
    String? productName,
    DateTime? treatmentDate,
    DateTime? withdrawalEndDate,
    String? veterinarianId,
    String? veterinarianName,
    String? buyerName,
    String? buyerFarmId,
    double? totalPrice,
    double? pricePerAnimal,
    DateTime? saleDate,
    String? slaughterhouseName,
    String? slaughterhouseId,
    DateTime? slaughterDate,
    String? notes,
    bool? synced,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    String? serverVersion,
  }) {
    return LotExtended(
      id: id,
      farmId: farmId ?? this.farmId,
      name: name ?? this.name,
      type: clearType ? null : (type ?? this.type),
      animalIds: animalIds ?? this.animalIds,
      completed: completed ?? this.completed,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      treatmentDate: treatmentDate ?? this.treatmentDate,
      withdrawalEndDate: withdrawalEndDate ?? this.withdrawalEndDate,
      veterinarianId: veterinarianId ?? this.veterinarianId,
      veterinarianName: veterinarianName ?? this.veterinarianName,
      buyerName: buyerName ?? this.buyerName,
      buyerFarmId: buyerFarmId ?? this.buyerFarmId,
      totalPrice: totalPrice ?? this.totalPrice,
      pricePerAnimal: pricePerAnimal ?? this.pricePerAnimal,
      saleDate: saleDate ?? this.saleDate,
      slaughterhouseName: slaughterhouseName ?? this.slaughterhouseName,
      slaughterhouseId: slaughterhouseId ?? this.slaughterhouseId,
      slaughterDate: slaughterDate ?? this.slaughterDate,
      notes: notes ?? this.notes,
      synced: synced ?? this.synced,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
    );
  }

  LotExtended markAsSynced({required String serverVersion}) {
    return copyWith(
      synced: true,
      lastSyncedAt: DateTime.now(),
      serverVersion: serverVersion,
    );
  }

  LotExtended markAsModified() {
    return copyWith(synced: false, updatedAt: DateTime.now());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmId': farmId,
      'name': name,
      'type': type?.name,
      'animalIds': animalIds,
      'completed': completed,
      'completedAt': completedAt?.toIso8601String(),
      'productId': productId,
      'productName': productName,
      'treatmentDate': treatmentDate?.toIso8601String(),
      'withdrawalEndDate': withdrawalEndDate?.toIso8601String(),
      'veterinarianId': veterinarianId,
      'veterinarianName': veterinarianName,
      'buyerName': buyerName,
      'buyerFarmId': buyerFarmId,
      'totalPrice': totalPrice,
      'pricePerAnimal': pricePerAnimal,
      'saleDate': saleDate?.toIso8601String(),
      'slaughterhouseName': slaughterhouseName,
      'slaughterhouseId': slaughterhouseId,
      'slaughterDate': slaughterDate?.toIso8601String(),
      'notes': notes,
      'synced': synced,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastSyncedAt': lastSyncedAt?.toIso8601String(),
      'serverVersion': serverVersion,
    };
  }

  factory LotExtended.fromJson(Map<String, dynamic> json) {
    return LotExtended(
      id: json['id'],
      farmId: json['farmId'] as String,
      name: json['name'],
      type: json['type'] != null
          ? LotType.values.firstWhere((e) => e.name == json['type'])
          : null,
      animalIds: List<String>.from(json['animalIds'] ?? []),
      completed: json['completed'] ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      productId: json['productId'],
      productName: json['productName'],
      treatmentDate: json['treatmentDate'] != null
          ? DateTime.parse(json['treatmentDate'])
          : null,
      withdrawalEndDate: json['withdrawalEndDate'] != null
          ? DateTime.parse(json['withdrawalEndDate'])
          : null,
      veterinarianId: json['veterinarianId'],
      veterinarianName: json['veterinarianName'],
      buyerName: json['buyerName'],
      buyerFarmId: json['buyerFarmId'],
      totalPrice: json['totalPrice']?.toDouble(),
      pricePerAnimal: json['pricePerAnimal']?.toDouble(),
      saleDate:
          json['saleDate'] != null ? DateTime.parse(json['saleDate']) : null,
      slaughterhouseName: json['slaughterhouseName'],
      slaughterhouseId: json['slaughterhouseId'],
      slaughterDate: json['slaughterDate'] != null
          ? DateTime.parse(json['slaughterDate'])
          : null,
      notes: json['notes'],
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
