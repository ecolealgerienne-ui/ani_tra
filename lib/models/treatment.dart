import 'package:uuid/uuid.dart';

class Treatment {
  final String id;
  final String animalId;
  final String productId;
  final String productName;
  final double dose;
  final DateTime treatmentDate;
  final DateTime withdrawalEndDate;
  final String? veterinarianId;
  final String? campaignId;
  final bool synced;
  final DateTime createdAt;

  Treatment({
    String? id,
    required this.animalId,
    required this.productId,
    required this.productName,
    required this.dose,
    required this.treatmentDate,
    required this.withdrawalEndDate,
    this.veterinarianId,
    this.campaignId,
    this.synced = false,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Treatment copyWith({
    bool? synced,
  }) {
    return Treatment(
      id: id,
      animalId: animalId,
      productId: productId,
      productName: productName,
      dose: dose,
      treatmentDate: treatmentDate,
      withdrawalEndDate: withdrawalEndDate,
      veterinarianId: veterinarianId,
      campaignId: campaignId,
      synced: synced ?? this.synced,
      createdAt: createdAt,
    );
  }

  bool get isWithdrawalActive => DateTime.now().isBefore(withdrawalEndDate);

  int get daysUntilWithdrawalEnd =>
      withdrawalEndDate.difference(DateTime.now()).inDays;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'animal_id': animalId,
      'product_id': productId,
      'product_name': productName,
      'dose': dose,
      'treatment_date': treatmentDate.toIso8601String(),
      'withdrawal_end_date': withdrawalEndDate.toIso8601String(),
      'veterinarian_id': veterinarianId,
      'campaign_id': campaignId,
      'synced': synced,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      id: json['id'],
      animalId: json['animal_id'],
      productId: json['product_id'],
      productName: json['product_name'],
      dose: json['dose'].toDouble(),
      treatmentDate: DateTime.parse(json['treatment_date']),
      withdrawalEndDate: DateTime.parse(json['withdrawal_end_date']),
      veterinarianId: json['veterinarian_id'],
      campaignId: json['campaign_id'],
      synced: json['synced'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
