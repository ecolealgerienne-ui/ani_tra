// lib/models/campaign.dart
// Artefact 15 : Model Campaign étendu avec vétérinaire
// Version : 1.2

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Campaign {
  final String id;
  final String name;
  final String productId;
  final String productName;
  final DateTime campaignDate;
  final DateTime withdrawalEndDate;

  // ==================== NOUVEAU v1.2 : Vétérinaire ====================
  final String? veterinarianId; // ID du vétérinaire (optionnel)
  final String? veterinarianName; // Nom du vétérinaire (optionnel)

  final List<String> animalIds; // Liste des EIDs scannés
  final bool completed;
  final bool synced;
  final DateTime createdAt;

  Campaign({
    required this.id,
    required this.name,
    required this.productId,
    required this.productName,
    required this.campaignDate,
    required this.withdrawalEndDate,
    this.veterinarianId, // ← NOUVEAU
    this.veterinarianName, // ← NOUVEAU
    this.animalIds = const [],
    this.completed = false,
    this.synced = false,
    required this.createdAt,
  });

  /// Nombre d'animaux dans la campagne
  int get animalCount => animalIds.length;

  /// Copier avec modifications
  Campaign copyWith({
    String? id,
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
    DateTime? createdAt,
  }) {
    return Campaign(
      id: id ?? this.id,
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
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Conversion vers JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'productId': productId,
      'productName': productName,
      'campaignDate': campaignDate.toIso8601String(),
      'withdrawalEndDate': withdrawalEndDate.toIso8601String(),
      'veterinarianId': veterinarianId, // ← NOUVEAU
      'veterinarianName': veterinarianName, // ← NOUVEAU
      'animalIds': animalIds,
      'completed': completed,
      'synced': synced,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Création depuis JSON
  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'],
      name: json['name'],
      productId: json['productId'],
      productName: json['productName'],
      campaignDate: DateTime.parse(json['campaignDate']),
      withdrawalEndDate: DateTime.parse(json['withdrawalEndDate']),
      veterinarianId: json['veterinarianId'], // ← NOUVEAU
      veterinarianName: json['veterinarianName'], // ← NOUVEAU
      animalIds: List<String>.from(json['animalIds'] ?? []),
      completed: json['completed'] ?? false,
      synced: json['synced'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  @override
  String toString() {
    return 'Campaign(id: $id, name: $name, productName: $productName, '
        'animalCount: $animalCount, veterinarianName: $veterinarianName, '
        'completed: $completed, synced: $synced)';
  }
}
