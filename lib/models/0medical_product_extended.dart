// lib/models/medical_product_extended.dart
import 'syncable_entity.dart';

class MedicalProductExtended implements SyncableEntity {
  @override
  final String id;
  @override
  final String farmId;

  final String name;
  final String? commercialName;
  final String category;
  final String? activeIngredient;
  final String? manufacturer;
  final String? form;
  final double? dosage;
  final String? dosageUnit;
  final int withdrawalPeriodMeat;
  final int withdrawalPeriodMilk;
  final double currentStock;
  final double minStock;
  final String stockUnit;
  final double? unitPrice;
  final String? currency;
  final String? batchNumber;
  final DateTime? expiryDate;
  final String? storageConditions;
  final String? prescription;
  final String? notes;
  final bool isActive;

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

  MedicalProductExtended({
    required this.id,
    required this.farmId,
    required this.name,
    this.commercialName,
    required this.category,
    this.activeIngredient,
    this.manufacturer,
    this.form,
    this.dosage,
    this.dosageUnit,
    required this.withdrawalPeriodMeat,
    required this.withdrawalPeriodMilk,
    required this.currentStock,
    required this.minStock,
    required this.stockUnit,
    this.unitPrice,
    this.currency,
    this.batchNumber,
    this.expiryDate,
    this.storageConditions,
    this.prescription,
    this.notes,
    this.isActive = true,
    this.synced = false,
    required this.createdAt,
    DateTime? updatedAt,
    this.lastSyncedAt,
    this.serverVersion,
  }) : updatedAt = updatedAt ?? createdAt;

  bool get isLowStock => currentStock <= minStock;
  bool get isExpired =>
      expiryDate != null && expiryDate!.isBefore(DateTime.now());
  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    final daysUntilExpiry = expiryDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 30 && daysUntilExpiry > 0;
  }

  String get displayName => commercialName ?? name;
  int get maxWithdrawalPeriod => withdrawalPeriodMeat > withdrawalPeriodMilk
      ? withdrawalPeriodMeat
      : withdrawalPeriodMilk;

  MedicalProductExtended copyWith({
    String? farmId,
    String? name,
    String? commercialName,
    String? category,
    String? activeIngredient,
    String? manufacturer,
    String? form,
    double? dosage,
    String? dosageUnit,
    int? withdrawalPeriodMeat,
    int? withdrawalPeriodMilk,
    double? currentStock,
    double? minStock,
    String? stockUnit,
    double? unitPrice,
    String? currency,
    String? batchNumber,
    DateTime? expiryDate,
    String? storageConditions,
    String? prescription,
    String? notes,
    bool? isActive,
    bool? synced,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    String? serverVersion,
  }) {
    return MedicalProductExtended(
      id: id,
      farmId: farmId ?? this.farmId,
      name: name ?? this.name,
      commercialName: commercialName ?? this.commercialName,
      category: category ?? this.category,
      activeIngredient: activeIngredient ?? this.activeIngredient,
      manufacturer: manufacturer ?? this.manufacturer,
      form: form ?? this.form,
      dosage: dosage ?? this.dosage,
      dosageUnit: dosageUnit ?? this.dosageUnit,
      withdrawalPeriodMeat: withdrawalPeriodMeat ?? this.withdrawalPeriodMeat,
      withdrawalPeriodMilk: withdrawalPeriodMilk ?? this.withdrawalPeriodMilk,
      currentStock: currentStock ?? this.currentStock,
      minStock: minStock ?? this.minStock,
      stockUnit: stockUnit ?? this.stockUnit,
      unitPrice: unitPrice ?? this.unitPrice,
      currency: currency ?? this.currency,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      storageConditions: storageConditions ?? this.storageConditions,
      prescription: prescription ?? this.prescription,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      synced: synced ?? this.synced,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
    );
  }

  MedicalProductExtended markAsSynced({required String serverVersion}) {
    return copyWith(
      synced: true,
      lastSyncedAt: DateTime.now(),
      serverVersion: serverVersion,
    );
  }

  MedicalProductExtended markAsModified() {
    return copyWith(synced: false, updatedAt: DateTime.now());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmId': farmId,
      'name': name,
      'commercialName': commercialName,
      'category': category,
      'activeIngredient': activeIngredient,
      'manufacturer': manufacturer,
      'form': form,
      'dosage': dosage,
      'dosageUnit': dosageUnit,
      'withdrawalPeriodMeat': withdrawalPeriodMeat,
      'withdrawalPeriodMilk': withdrawalPeriodMilk,
      'currentStock': currentStock,
      'minStock': minStock,
      'stockUnit': stockUnit,
      'unitPrice': unitPrice,
      'currency': currency,
      'batchNumber': batchNumber,
      'expiryDate': expiryDate?.toIso8601String(),
      'storageConditions': storageConditions,
      'prescription': prescription,
      'notes': notes,
      'isActive': isActive,
      'synced': synced,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastSyncedAt': lastSyncedAt?.toIso8601String(),
      'serverVersion': serverVersion,
    };
  }

  factory MedicalProductExtended.fromJson(Map<String, dynamic> json) {
    return MedicalProductExtended(
      id: json['id'] as String,
      farmId: json['farmId'] as String,
      name: json['name'] as String,
      commercialName: json['commercialName'] as String?,
      category: json['category'] as String,
      activeIngredient: json['activeIngredient'] as String?,
      manufacturer: json['manufacturer'] as String?,
      form: json['form'] as String?,
      dosage: (json['dosage'] as num?)?.toDouble(),
      dosageUnit: json['dosageUnit'] as String?,
      withdrawalPeriodMeat: json['withdrawalPeriodMeat'] as int,
      withdrawalPeriodMilk: json['withdrawalPeriodMilk'] as int,
      currentStock: (json['currentStock'] as num).toDouble(),
      minStock: (json['minStock'] as num).toDouble(),
      stockUnit: json['stockUnit'] as String,
      unitPrice: (json['unitPrice'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      batchNumber: json['batchNumber'] as String?,
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'] as String)
          : null,
      storageConditions: json['storageConditions'] as String?,
      prescription: json['prescription'] as String?,
      notes: json['notes'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      synced: json['synced'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastSyncedAt: json['lastSyncedAt'] != null
          ? DateTime.parse(json['lastSyncedAt'] as String)
          : null,
      serverVersion: json['serverVersion'] as String?,
    );
  }
}
