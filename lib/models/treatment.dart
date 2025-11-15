// lib/models/treatment.dart

import 'syncable_entity.dart';

class Treatment implements SyncableEntity {
  // === Identification ===
  @override
  final String id;
  @override
  final String farmId;

  // === Données métier ===
  final String animalId;
  final String productId;
  final String productName;
  final double dose;
  final DateTime treatmentDate;
  final DateTime withdrawalEndDate;
  final String? notes;

  // === Informations additionnelles ===
  final String? veterinarianId;
  final String? veterinarianName;
  final String? campaignId;

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

  Treatment({
    required this.id,
    this.farmId = 'farm_default', // Valeur par défaut pour compatibilité mock
    required this.animalId,
    required this.productId,
    required this.productName,
    required this.dose,
    required this.treatmentDate,
    required this.withdrawalEndDate,
    this.notes,
    this.veterinarianId,
    this.veterinarianName,
    this.campaignId,
    this.synced = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastSyncedAt,
    this.serverVersion,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // === Getters ===

  /// Indique si la période de retrait est encore active (non terminée).
  bool get isWithdrawalActive => DateTime.now().isBefore(withdrawalEndDate);

  /// Nombre de jours restant avant la fin de retrait (0 si terminé).
  int get daysUntilWithdrawalEnd {
    final diff = withdrawalEndDate.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }

  // === Méthodes CRUD ===

  Treatment copyWith({
    String? farmId,
    String? animalId,
    String? productId,
    String? productName,
    double? dose,
    DateTime? treatmentDate,
    DateTime? withdrawalEndDate,
    String? notes,
    String? veterinarianId,
    String? veterinarianName,
    String? campaignId,
    bool? synced,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    String? serverVersion,
  }) {
    return Treatment(
      id: id,
      farmId: farmId ?? this.farmId,
      animalId: animalId ?? this.animalId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      dose: dose ?? this.dose,
      treatmentDate: treatmentDate ?? this.treatmentDate,
      withdrawalEndDate: withdrawalEndDate ?? this.withdrawalEndDate,
      notes: notes ?? this.notes,
      veterinarianId: veterinarianId ?? this.veterinarianId,
      veterinarianName: veterinarianName ?? this.veterinarianName,
      campaignId: campaignId ?? this.campaignId,
      synced: synced ?? this.synced,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
    );
  }

  // === Méthodes de sync ===

  Treatment markAsSynced({required String serverVersion}) {
    return copyWith(
      synced: true,
      lastSyncedAt: DateTime.now(),
      serverVersion: serverVersion,
    );
  }

  Treatment markAsModified() {
    return copyWith(
      synced: false,
      updatedAt: DateTime.now(),
    );
  }

  // === JSON Serialization (SNAKE_CASE) ===

  Map<String, dynamic> toJson() => {
        'id': id,
        'farm_id': farmId,
        'animal_id': animalId,
        'product_id': productId,
        'product_name': productName,
        'dose': dose,
        'treatment_date': treatmentDate.toIso8601String(),
        'withdrawal_end_date': withdrawalEndDate.toIso8601String(),
        'notes': notes,
        'veterinarian_id': veterinarianId,
        'veterinarian_name': veterinarianName,
        'campaign_id': campaignId,
        'synced': synced,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'last_synced_at': lastSyncedAt?.toIso8601String(),
        'server_version': serverVersion,
      };

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      id: json['id'] as String,
      farmId: json['farm_id'] as String? ?? 'farm_default',
      animalId: json['animal_id'] as String,
      productId: json['product_id'] as String,
      productName: json['product_name'] as String,
      dose: (json['dose'] as num).toDouble(),
      treatmentDate: DateTime.parse(json['treatment_date'] as String),
      withdrawalEndDate: DateTime.parse(json['withdrawal_end_date'] as String),
      notes: json['notes'] as String?,
      veterinarianId: json['veterinarian_id'] as String?,
      veterinarianName: json['veterinarian_name'] as String?,
      campaignId: json['campaign_id'] as String?,
      synced: json['synced'] as bool? ?? false,
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

  @override
  String toString() =>
      'Treatment(id: $id, animalId: $animalId, productId: $productId, productName: $productName, dose: $dose)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Treatment &&
        other.id == id &&
        other.animalId == animalId &&
        other.productId == productId &&
        other.productName == productName &&
        other.dose == dose &&
        other.treatmentDate == treatmentDate &&
        other.withdrawalEndDate == withdrawalEndDate &&
        other.notes == notes &&
        other.veterinarianId == veterinarianId &&
        other.veterinarianName == veterinarianName &&
        other.campaignId == campaignId &&
        other.synced == synced &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        animalId,
        productId,
        productName,
        dose,
        treatmentDate,
        withdrawalEndDate,
        notes,
        veterinarianId,
        veterinarianName,
        campaignId,
        synced,
        createdAt,
      );
}
