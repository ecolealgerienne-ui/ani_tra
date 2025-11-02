// lib/models/movement_extended.dart
import 'package:uuid/uuid.dart';

enum MovementType { birth, purchase, sale, death, slaughter }

class Movement {
  final String id;
  final String animalId;
  final MovementType type;
  final DateTime movementDate;
  final String? fromFarmId;
  final String? toFarmId;
  final double? price;
  final String? notes;
  final String? buyerQrSignature;
  final bool synced;
  final DateTime createdAt;

  // Champs de synchronisation serveur
  final String? farmId;
  final DateTime? updatedAt;
  final DateTime? lastSyncedAt;
  final String? serverVersion;

  Movement({
    String? id,
    required this.animalId,
    required this.type,
    required this.movementDate,
    this.fromFarmId,
    this.toFarmId,
    this.price,
    this.notes,
    this.buyerQrSignature,
    this.synced = false,
    DateTime? createdAt,
    this.farmId,
    this.updatedAt,
    this.lastSyncedAt,
    this.serverVersion,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Movement copyWith({
    bool? synced,
    String? farmId,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    String? serverVersion,
  }) {
    return Movement(
      id: id,
      animalId: animalId,
      type: type,
      movementDate: movementDate,
      fromFarmId: fromFarmId,
      toFarmId: toFarmId,
      price: price,
      notes: notes,
      buyerQrSignature: buyerQrSignature,
      synced: synced ?? this.synced,
      createdAt: createdAt,
      farmId: farmId ?? this.farmId,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'animal_id': animalId,
      'type': type.name,
      'movement_date': movementDate.toIso8601String(),
      'from_farm_id': fromFarmId,
      'to_farm_id': toFarmId,
      'price': price,
      'notes': notes,
      'buyer_qr_signature': buyerQrSignature,
      'synced': synced,
      'created_at': createdAt.toIso8601String(),
      'farm_id': farmId,
      'updated_at': updatedAt?.toIso8601String(),
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'server_version': serverVersion,
    };
  }

  factory Movement.fromJson(Map<String, dynamic> json) {
    return Movement(
      id: json['id'],
      animalId: json['animal_id'],
      type: MovementType.values.firstWhere((e) => e.name == json['type']),
      movementDate: DateTime.parse(json['movement_date']),
      fromFarmId: json['from_farm_id'],
      toFarmId: json['to_farm_id'],
      price: json['price']?.toDouble(),
      notes: json['notes'],
      buyerQrSignature: json['buyer_qr_signature'],
      synced: json['synced'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
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
}
