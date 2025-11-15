// lib/models/movement.dart

import 'package:uuid/uuid.dart';
import 'syncable_entity.dart';

enum MovementType { birth, purchase, sale, death, slaughter }

class Movement implements SyncableEntity {
  // === Identification ===
  @override
  final String id;
  @override
  final String farmId;

  // === Données métier ===
  final String animalId;
  final MovementType type;
  final DateTime movementDate;
  final String? fromFarmId;
  final String? toFarmId;
  final double? price;
  final String? notes;
  final String? buyerQrSignature;

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

  Movement({
    String? id,
    this.farmId = 'mock-farm-001', // Valeur par défaut pour compatibilité mock
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
    DateTime? updatedAt,
    this.lastSyncedAt,
    this.serverVersion,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // === Méthodes CRUD ===

  Movement copyWith({
    String? farmId,
    String? animalId,
    MovementType? type,
    DateTime? movementDate,
    String? fromFarmId,
    String? toFarmId,
    double? price,
    String? notes,
    String? buyerQrSignature,
    bool? synced,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    String? serverVersion,
  }) {
    return Movement(
      id: id,
      farmId: farmId ?? this.farmId,
      animalId: animalId ?? this.animalId,
      type: type ?? this.type,
      movementDate: movementDate ?? this.movementDate,
      fromFarmId: fromFarmId ?? this.fromFarmId,
      toFarmId: toFarmId ?? this.toFarmId,
      price: price ?? this.price,
      notes: notes ?? this.notes,
      buyerQrSignature: buyerQrSignature ?? this.buyerQrSignature,
      synced: synced ?? this.synced,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
    );
  }

  // === Méthodes de sync ===

  Movement markAsSynced({required String serverVersion}) {
    return copyWith(
      synced: true,
      lastSyncedAt: DateTime.now(),
      serverVersion: serverVersion,
    );
  }

  Movement markAsModified() {
    return copyWith(
      synced: false,
      updatedAt: DateTime.now(),
    );
  }

  // === JSON Serialization (SNAKE_CASE) ===

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farm_id': farmId,
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
      'updated_at': updatedAt.toIso8601String(),
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'server_version': serverVersion,
    };
  }

  factory Movement.fromJson(Map<String, dynamic> json) {
    return Movement(
      id: json['id'],
      farmId: json['farm_id'] as String? ?? 'mock-farm-001',
      animalId: json['animal_id'],
      type: MovementType.values.firstWhere((e) => e.name == json['type']),
      movementDate: DateTime.parse(json['movement_date']),
      fromFarmId: json['from_farm_id'],
      toFarmId: json['to_farm_id'],
      price: json['price']?.toDouble(),
      notes: json['notes'],
      buyerQrSignature: json['buyer_qr_signature'],
      synced: json['synced'] ?? false,
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
}
