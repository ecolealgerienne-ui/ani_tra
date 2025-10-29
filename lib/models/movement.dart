import 'package:uuid/uuid.dart';

enum MovementType { birth, purchase, sale, death }

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
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Movement copyWith({
    bool? synced,
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
    );
  }
}
