// lib/models/medical_product.dart
class MedicalProduct {
  final String id;
  final String name;
  final String? commercialName;
  final String category; // antibiotique, anti-inflammatoire, vaccin, etc.
  final String? activeIngredient;
  final String? manufacturer;
  final String? form; // injectable, oral, topique, etc.
  final double? dosage;
  final String? dosageUnit;

  // Délais d'attente
  final int withdrawalPeriodMeat; // en jours
  final int withdrawalPeriodMilk; // en jours

  // Stock
  final double currentStock;
  final double minStock;
  final String stockUnit; // ml, comprimés, doses, etc.

  // Prix
  final double? unitPrice;
  final String? currency;

  // Informations complémentaires
  final String? batchNumber;
  final DateTime? expiryDate;
  final String? storageConditions;
  final String? prescription; // Ordonnance requise
  final String? notes;

  // Métadonnées
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  MedicalProduct({
    required this.id,
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
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  // Copie avec modification
  MedicalProduct copyWith({
    String? id,
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
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return MedicalProduct(
      id: id ?? this.id,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  // Conversion JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory MedicalProduct.fromJson(Map<String, dynamic> json) {
    return MedicalProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      commercialName: json['commercialName'] as String?,
      category: json['category'] as String,
      activeIngredient: json['activeIngredient'] as String?,
      manufacturer: json['manufacturer'] as String?,
      form: json['form'] as String?,
      // ✅ robustesse: accepter int ou double
      dosage: (json['dosage'] as num?)?.toDouble(),
      dosageUnit: json['dosageUnit'] as String?,
      withdrawalPeriodMeat: json['withdrawalPeriodMeat'] as int,
      withdrawalPeriodMilk: json['withdrawalPeriodMilk'] as int,
      currentStock: (json['currentStock'] as num).toDouble(),
      minStock: (json['minStock'] as num).toDouble(),
      stockUnit: json['stockUnit'] as String,
      // ✅ robustesse: accepter int ou double
      unitPrice: (json['unitPrice'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      batchNumber: json['batchNumber'] as String?,
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'] as String)
          : null,
      storageConditions: json['storageConditions'] as String?,
      prescription: json['prescription'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  // Vérifications
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
}
