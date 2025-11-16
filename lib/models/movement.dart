// lib/models/movement.dart

import 'package:uuid/uuid.dart';
import 'syncable_entity.dart';

enum MovementType {
  birth,
  purchase,
  sale,
  death,
  slaughter,
  temporaryOut, // Départ temporaire (prêt, transhumance, etc.)
  temporaryReturn // Retour de mouvement temporaire
}

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

  // === Sale/Slaughter Structured Data ===
  final String? buyerName;
  final String? buyerFarmId;
  final String? buyerType; // 'individual', 'farm', 'trader', 'cooperative'
  final String? slaughterhouseName;
  final String? slaughterhouseId;

  // === Temporary Movements ===
  final bool isTemporary;
  final String? temporaryMovementType; // 'loan', 'transhumance', 'boarding', etc.
  final DateTime? expectedReturnDate;
  final String? relatedMovementId; // Lien bidirectionnel (out ↔ return)

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
    this.farmId = 'farm_default', // Valeur par défaut pour compatibilité mock
    required this.animalId,
    required this.type,
    required this.movementDate,
    this.fromFarmId,
    this.toFarmId,
    this.price,
    this.notes,
    this.buyerQrSignature,
    // Sale/Slaughter Structured Data
    this.buyerName,
    this.buyerFarmId,
    this.buyerType,
    this.slaughterhouseName,
    this.slaughterhouseId,
    // Temporary Movements
    this.isTemporary = false,
    this.temporaryMovementType,
    this.expectedReturnDate,
    this.relatedMovementId,
    // Synchronisation
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
    // Sale/Slaughter
    String? buyerName,
    String? buyerFarmId,
    String? buyerType,
    String? slaughterhouseName,
    String? slaughterhouseId,
    // Temporary Movements
    bool? isTemporary,
    String? temporaryMovementType,
    DateTime? expectedReturnDate,
    String? relatedMovementId,
    // Sync
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
      // Sale/Slaughter
      buyerName: buyerName ?? this.buyerName,
      buyerFarmId: buyerFarmId ?? this.buyerFarmId,
      buyerType: buyerType ?? this.buyerType,
      slaughterhouseName: slaughterhouseName ?? this.slaughterhouseName,
      slaughterhouseId: slaughterhouseId ?? this.slaughterhouseId,
      // Temporary Movements
      isTemporary: isTemporary ?? this.isTemporary,
      temporaryMovementType:
          temporaryMovementType ?? this.temporaryMovementType,
      expectedReturnDate: expectedReturnDate ?? this.expectedReturnDate,
      relatedMovementId: relatedMovementId ?? this.relatedMovementId,
      // Sync
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

  // === Helper Methods ===

  bool get isSale => type == MovementType.sale;
  bool get isSlaughter => type == MovementType.slaughter;
  bool get isTemporaryOut => type == MovementType.temporaryOut;
  bool get isTemporaryReturn => type == MovementType.temporaryReturn;

  /// Vérifie si le mouvement temporaire est en retard
  bool get isOverdue =>
      isTemporary &&
      expectedReturnDate != null &&
      DateTime.now().isAfter(expectedReturnDate!);

  /// Vérifie si le mouvement temporaire a été retourné
  bool get isReturned => isTemporaryOut && relatedMovementId != null;

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
      // Sale/Slaughter
      'buyer_name': buyerName,
      'buyer_farm_id': buyerFarmId,
      'buyer_type': buyerType,
      'slaughterhouse_name': slaughterhouseName,
      'slaughterhouse_id': slaughterhouseId,
      // Temporary Movements
      'is_temporary': isTemporary,
      'temporary_movement_type': temporaryMovementType,
      'expected_return_date': expectedReturnDate?.toIso8601String(),
      'related_movement_id': relatedMovementId,
      // Sync
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
      farmId: json['farm_id'] as String? ?? 'farm_default',
      animalId: json['animal_id'],
      type: MovementType.values.firstWhere((e) => e.name == json['type']),
      movementDate: DateTime.parse(json['movement_date']),
      fromFarmId: json['from_farm_id'],
      toFarmId: json['to_farm_id'],
      price: json['price']?.toDouble(),
      notes: json['notes'],
      buyerQrSignature: json['buyer_qr_signature'],
      // Sale/Slaughter
      buyerName: json['buyer_name'],
      buyerFarmId: json['buyer_farm_id'],
      buyerType: json['buyer_type'],
      slaughterhouseName: json['slaughterhouse_name'],
      slaughterhouseId: json['slaughterhouse_id'],
      // Temporary Movements
      isTemporary: json['is_temporary'] ?? false,
      temporaryMovementType: json['temporary_movement_type'],
      expectedReturnDate: json['expected_return_date'] != null
          ? DateTime.parse(json['expected_return_date'] as String)
          : null,
      relatedMovementId: json['related_movement_id'],
      // Sync
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
