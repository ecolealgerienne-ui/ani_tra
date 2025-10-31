// lib/models/lot.dart
// Modèle Lot unifié (Traitement/Vente/Abattage)
// Version : 2.0

import 'package:uuid/uuid.dart';

const uuid = Uuid();

/// Type de lot
enum LotType {
  treatment, // Traitement sanitaire (ancienne campagne)
  sale, // Vente d'animaux
  slaughter, // Abattage
}

extension LotTypeExt on LotType {
  String get label {
    switch (this) {
      case LotType.treatment:
        return 'Traitement';
      case LotType.sale:
        return 'Vente';
      case LotType.slaughter:
        return 'Abattage';
    }
  }

  String get icon {
    switch (this) {
      case LotType.treatment:
        return '💊';
      case LotType.sale:
        return '💰';
      case LotType.slaughter:
        return '🏭';
    }
  }
}

/// Modèle Lot
class Lot {
  final String id;
  final String name;

  // Type du lot (null = non défini, à définir lors de la finalisation)
  final LotType? type;

  // Animaux du lot
  final List<String> animalIds;

  // Statut
  final bool completed; // false = ouvert, true = fermé
  final bool synced;

  // Dates
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt; // Date de fermeture

  // ==================== DONNÉES TRAITEMENT ====================
  final String? productId;
  final String? productName;
  final DateTime? treatmentDate;
  final DateTime? withdrawalEndDate;
  final String? veterinarianId;
  final String? veterinarianName;

  // ==================== DONNÉES VENTE ====================
  final String? buyerName;
  final String? buyerFarmId;
  final double? totalPrice;
  final double? pricePerAnimal;
  final DateTime? saleDate;

  // ==================== DONNÉES ABATTAGE ====================
  final String? slaughterhouseName;
  final String? slaughterhouseId;
  final DateTime? slaughterDate;

  // ==================== NOTES ====================
  final String? notes;

  Lot({
    required this.id,
    required this.name,
    this.type,
    this.animalIds = const [],
    this.completed = false,
    this.synced = false,
    required this.createdAt,
    this.updatedAt,
    this.completedAt,
    // Traitement
    this.productId,
    this.productName,
    this.treatmentDate,
    this.withdrawalEndDate,
    this.veterinarianId,
    this.veterinarianName,
    // Vente
    this.buyerName,
    this.buyerFarmId,
    this.totalPrice,
    this.pricePerAnimal,
    this.saleDate,
    // Abattage
    this.slaughterhouseName,
    this.slaughterhouseId,
    this.slaughterDate,
    // Notes
    this.notes,
  });

  /// Nombre d'animaux
  int get animalCount => animalIds.length;

  /// Est-ce un lot ouvert (modifiable)
  bool get isOpen => !completed;

  /// Est-ce un lot fermé (non modifiable)
  bool get isClosed => completed;

  /// Copier avec modifications
  Lot copyWith({
    String? id,
    String? name,
    LotType? type,
    bool clearType = false,
    List<String>? animalIds,
    bool? completed,
    bool? synced,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    bool clearCompletedAt = false,
    // Traitement
    String? productId,
    String? productName,
    DateTime? treatmentDate,
    DateTime? withdrawalEndDate,
    String? veterinarianId,
    String? veterinarianName,
    // Vente
    String? buyerName,
    String? buyerFarmId,
    double? totalPrice,
    double? pricePerAnimal,
    DateTime? saleDate,
    // Abattage
    String? slaughterhouseName,
    String? slaughterhouseId,
    DateTime? slaughterDate,
    // Notes
    String? notes,
  }) {
    return Lot(
      id: id ?? this.id,
      name: name ?? this.name,
      type: clearType ? null : (type ?? this.type),
      animalIds: animalIds ?? this.animalIds,
      completed: completed ?? this.completed,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
      // Traitement
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      treatmentDate: treatmentDate ?? this.treatmentDate,
      withdrawalEndDate: withdrawalEndDate ?? this.withdrawalEndDate,
      veterinarianId: veterinarianId ?? this.veterinarianId,
      veterinarianName: veterinarianName ?? this.veterinarianName,
      // Vente
      buyerName: buyerName ?? this.buyerName,
      buyerFarmId: buyerFarmId ?? this.buyerFarmId,
      totalPrice: totalPrice ?? this.totalPrice,
      pricePerAnimal: pricePerAnimal ?? this.pricePerAnimal,
      saleDate: saleDate ?? this.saleDate,
      // Abattage
      slaughterhouseName: slaughterhouseName ?? this.slaughterhouseName,
      slaughterhouseId: slaughterhouseId ?? this.slaughterhouseId,
      slaughterDate: slaughterDate ?? this.slaughterDate,
      // Notes
      notes: notes ?? this.notes,
    );
  }

  /// JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type?.name,
      'animalIds': animalIds,
      'completed': completed,
      'synced': synced,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      // Traitement
      'productId': productId,
      'productName': productName,
      'treatmentDate': treatmentDate?.toIso8601String(),
      'withdrawalEndDate': withdrawalEndDate?.toIso8601String(),
      'veterinarianId': veterinarianId,
      'veterinarianName': veterinarianName,
      // Vente
      'buyerName': buyerName,
      'buyerFarmId': buyerFarmId,
      'totalPrice': totalPrice,
      'pricePerAnimal': pricePerAnimal,
      'saleDate': saleDate?.toIso8601String(),
      // Abattage
      'slaughterhouseName': slaughterhouseName,
      'slaughterhouseId': slaughterhouseId,
      'slaughterDate': slaughterDate?.toIso8601String(),
      // Notes
      'notes': notes,
    };
  }

  /// From JSON
  factory Lot.fromJson(Map<String, dynamic> json) {
    return Lot(
      id: json['id'],
      name: json['name'],
      type: json['type'] != null
          ? LotType.values.firstWhere((e) => e.name == json['type'])
          : null,
      animalIds: List<String>.from(json['animalIds'] ?? []),
      completed: json['completed'] ?? false,
      synced: json['synced'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      // Traitement
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
      // Vente
      buyerName: json['buyerName'],
      buyerFarmId: json['buyerFarmId'],
      totalPrice: json['totalPrice']?.toDouble(),
      pricePerAnimal: json['pricePerAnimal']?.toDouble(),
      saleDate:
          json['saleDate'] != null ? DateTime.parse(json['saleDate']) : null,
      // Abattage
      slaughterhouseName: json['slaughterhouseName'],
      slaughterhouseId: json['slaughterhouseId'],
      slaughterDate: json['slaughterDate'] != null
          ? DateTime.parse(json['slaughterDate'])
          : null,
      // Notes
      notes: json['notes'],
    );
  }

  @override
  String toString() {
    return 'Lot(id: $id, name: $name, type: ${type?.label ?? "Non défini"}, '
        'animalCount: $animalCount, completed: $completed)';
  }
}
