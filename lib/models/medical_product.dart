// lib/models/medical_product.dart
import 'syncable_entity.dart';

// ==================== Enums ====================

/// Type de produit médical
enum ProductType {
  treatment,  // Traitement
  vaccine     // Vaccination
}

/// Espèces animales
enum AnimalSpecies {
  ovin,   // Ovins (moutons, brebis)
  bovin,  // Bovins (vaches, taureaux)
  caprin  // Caprins (chèvres)
}

/// Produit médical pour le traitement des animaux
class MedicalProduct implements SyncableEntity {
  /// Identifiant unique du produit
  @override
  final String id;

  /// ID de la ferme (multi-tenancy)
  @override
  final String farmId;

  /// Nom du produit
  final String name;

  /// Nom commercial
  final String? commercialName;

  /// Catégorie (antibiotique, anti-inflammatoire, vaccin, etc.)
  final String category;

  /// Principe actif
  final String? activeIngredient;

  /// Fabricant
  final String? manufacturer;

  /// Forme (injectable, oral, topique, etc.)
  final String? form;

  /// Dosage
  final double? dosage;

  /// Unité de dosage
  final String? dosageUnit;

  // ==================== Délais d'attente ====================

  /// Délai d'attente viande (en jours)
  final int withdrawalPeriodMeat;

  /// Délai d'attente lait (en jours)
  final int withdrawalPeriodMilk;

  // ==================== Stock ====================

  /// Stock actuel
  final double currentStock;

  /// Stock minimum
  final double minStock;

  /// Unité de stock (ml, comprimés, doses, etc.)
  final String stockUnit;

  // ==================== Prix ====================

  /// Prix unitaire
  final double? unitPrice;

  /// Devise
  final String? currency;

  // ==================== Informations complémentaires ====================

  /// Numéro de lot
  final String? batchNumber;

  /// Date de péremption
  final DateTime? expiryDate;

  /// Conditions de stockage
  final String? storageConditions;

  /// Ordonnance requise
  final String? prescription;

  /// Notes
  final String? notes;

  /// Produit actif
  final bool isActive;

  // ==================== Nouveaux champs (Unification Traitement/Vaccination) ====================

  /// Type de produit (traitement ou vaccin)
  final ProductType type;

  /// Espèces cibles
  final List<AnimalSpecies> targetSpecies;

  // --- Pour TRAITEMENTS ---

  /// Durée cure standard (en jours) selon AMM
  /// Ex: 5 pour Amoxicilline
  final int? standardCureDays;

  /// Fréquence d'administration
  /// Ex: "1x/jour", "2x/jour", "Unique"
  final String? administrationFrequency;

  /// Formule de calcul dosage
  /// Ex: "1ml/10kg", "2ml/animal", "0.5ml/kg"
  final String? dosageFormula;

  // --- Pour VACCINS ---

  /// Protocole vaccinal
  /// Ex: "J0+J21+Annuel", "Unique", "J0+J28+6mois"
  final String? vaccinationProtocol;

  /// Jours des rappels
  /// Ex: [21, 365] pour J0+J21+Annuel
  final List<int>? reminderDays;

  /// Voie d'administration par défaut
  /// Ex: "IM", "SC", "ID", "Orale"
  final String? defaultAdministrationRoute;

  /// Site d'injection par défaut
  /// Ex: "Encolure", "Cuisse", "Arrière-cuisse"
  final String? defaultInjectionSite;

  // ==================== Champs SyncableEntity ====================

  /// État de synchronisation
  @override
  final bool synced;

  /// Date de création
  @override
  final DateTime createdAt;

  /// Date de dernière modification
  @override
  final DateTime updatedAt;

  /// Date de dernière synchronisation
  @override
  final DateTime? lastSyncedAt;

  /// Version serveur
  @override
  final String? serverVersion;

  // ==================== Constructeur ====================

  MedicalProduct({
    required this.id,
    this.farmId = 'mock-farm-001', // Valeur par défaut pour compatibilité mock
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
    // Nouveaux champs
    this.type = ProductType.treatment,
    this.targetSpecies = const [],
    this.standardCureDays,
    this.administrationFrequency,
    this.dosageFormula,
    this.vaccinationProtocol,
    this.reminderDays,
    this.defaultAdministrationRoute,
    this.defaultInjectionSite,
    // SyncableEntity
    this.synced = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastSyncedAt,
    this.serverVersion,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? createdAt ?? DateTime.now();

  // ==================== Getters ====================

  /// Vérifier si le stock est bas
  bool get isLowStock => currentStock <= minStock;

  /// Vérifier si le produit est périmé
  bool get isExpired =>
      expiryDate != null && expiryDate!.isBefore(DateTime.now());

  /// Vérifier si le produit arrive à péremption (≤ 30 jours)
  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    final daysUntilExpiry = expiryDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 30 && daysUntilExpiry > 0;
  }

  /// Nom à afficher (commercial ou générique)
  String get displayName => commercialName ?? name;

  /// Délai d'attente maximum
  int get maxWithdrawalPeriod => withdrawalPeriodMeat > withdrawalPeriodMilk
      ? withdrawalPeriodMeat
      : withdrawalPeriodMilk;

  // ==================== Méthodes ====================

  /// Calculer le dosage selon le poids de l'animal
  double? calculateDosage(double animalWeightKg) {
    if (dosageFormula == null) return null;

    // Parser la formule
    if (dosageFormula!.contains('/kg')) {
      // Ex: "1ml/10kg" → 0.1 ml/kg
      // Ex: "0.2ml/kg" → 0.2 ml/kg
      final parts = dosageFormula!.split('/');
      if (parts.length >= 2) {
        final amountStr = parts[0].replaceAll(RegExp(r'[^0-9.]'), '');
        final weightStr = parts[1].replaceAll(RegExp(r'[^0-9.]'), '');

        final amount = double.tryParse(amountStr);
        final weight = double.tryParse(weightStr);

        if (amount != null && weight != null && weight > 0) {
          return (amount / weight) * animalWeightKg;
        }
      }
    } else if (dosageFormula!.contains('/animal')) {
      // Ex: "2ml/animal" → dose fixe
      final amountStr = dosageFormula!.replaceAll(RegExp(r'[^0-9.]'), '');
      return double.tryParse(amountStr);
    }

    return null;
  }

  /// Obtenir le texte du protocole vaccinal
  String getProtocolDescription() {
    if (vaccinationProtocol == null) return 'Injection unique';

    switch (vaccinationProtocol) {
      case 'J0+J21+Annuel':
        return 'Primo-vaccination (J0), Rappel 21 jours, Rappel annuel';
      case 'J0+J28+6mois':
        return 'Primo-vaccination (J0), Rappel 28 jours, Rappel 6 mois';
      case 'Unique':
        return 'Injection unique, pas de rappel';
      default:
        return vaccinationProtocol!;
    }
  }

  /// Vérifier si compatible avec l'espèce
  bool isCompatibleWithSpecies(AnimalSpecies species) {
    return targetSpecies.contains(species);
  }

  /// Copie avec modifications
  MedicalProduct copyWith({
    String? id,
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
    ProductType? type,
    List<AnimalSpecies>? targetSpecies,
    int? standardCureDays,
    String? administrationFrequency,
    String? dosageFormula,
    String? vaccinationProtocol,
    List<int>? reminderDays,
    String? defaultAdministrationRoute,
    String? defaultInjectionSite,
    bool? synced,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    String? serverVersion,
  }) {
    return MedicalProduct(
      id: id ?? this.id,
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
      type: type ?? this.type,
      targetSpecies: targetSpecies ?? this.targetSpecies,
      standardCureDays: standardCureDays ?? this.standardCureDays,
      administrationFrequency: administrationFrequency ?? this.administrationFrequency,
      dosageFormula: dosageFormula ?? this.dosageFormula,
      vaccinationProtocol: vaccinationProtocol ?? this.vaccinationProtocol,
      reminderDays: reminderDays ?? this.reminderDays,
      defaultAdministrationRoute: defaultAdministrationRoute ?? this.defaultAdministrationRoute,
      defaultInjectionSite: defaultInjectionSite ?? this.defaultInjectionSite,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
    );
  }

  /// Marquer comme synchronisé avec le serveur
  MedicalProduct markAsSynced({required String serverVersion}) {
    return copyWith(
      synced: true,
      lastSyncedAt: DateTime.now(),
      serverVersion: serverVersion,
    );
  }

  /// Marquer comme modifié (à synchroniser)
  MedicalProduct markAsModified() {
    return copyWith(
      synced: false,
      updatedAt: DateTime.now(),
    );
  }

  // ==================== Sérialisation ====================

  /// Convertir en JSON
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
      'type': type.name,
      'targetSpecies': targetSpecies.map((e) => e.name).toList(),
      'standardCureDays': standardCureDays,
      'administrationFrequency': administrationFrequency,
      'dosageFormula': dosageFormula,
      'vaccinationProtocol': vaccinationProtocol,
      'reminderDays': reminderDays,
      'defaultAdministrationRoute': defaultAdministrationRoute,
      'defaultInjectionSite': defaultInjectionSite,
      'synced': synced,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastSyncedAt': lastSyncedAt?.toIso8601String(),
      'serverVersion': serverVersion,
    };
  }

  /// Créer depuis JSON
  factory MedicalProduct.fromJson(Map<String, dynamic> json) {
    return MedicalProduct(
      id: json['id'] as String,
      farmId: json['farmId'] as String? ??
          json['farm_id'] as String? ??
          'mock-farm-001',
      name: json['name'] as String,
      commercialName: json['commercialName'] as String? ??
          json['commercial_name'] as String?,
      category: json['category'] as String,
      activeIngredient: json['activeIngredient'] as String? ??
          json['active_ingredient'] as String?,
      manufacturer: json['manufacturer'] as String?,
      form: json['form'] as String?,
      dosage: (json['dosage'] as num?)?.toDouble(),
      dosageUnit:
          json['dosageUnit'] as String? ?? json['dosage_unit'] as String?,
      withdrawalPeriodMeat: json['withdrawalPeriodMeat'] as int? ??
          json['withdrawal_period_meat'] as int,
      withdrawalPeriodMilk: json['withdrawalPeriodMilk'] as int? ??
          json['withdrawal_period_milk'] as int,
      currentStock:
          (json['currentStock'] ?? json['current_stock'] as num).toDouble(),
      minStock: (json['minStock'] ?? json['min_stock'] as num).toDouble(),
      stockUnit: json['stockUnit'] as String? ?? json['stock_unit'] as String,
      unitPrice: (json['unitPrice'] ?? json['unit_price'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      batchNumber:
          json['batchNumber'] as String? ?? json['batch_number'] as String?,
      expiryDate: json['expiryDate'] != null || json['expiry_date'] != null
          ? DateTime.parse(json['expiryDate'] ?? json['expiry_date'] as String)
          : null,
      storageConditions: json['storageConditions'] as String? ??
          json['storage_conditions'] as String?,
      prescription: json['prescription'] as String?,
      notes: json['notes'] as String?,
      isActive: json['isActive'] as bool? ?? json['is_active'] as bool? ?? true,
      type: json['type'] != null
          ? ProductType.values.firstWhere(
              (e) => e.name == json['type'],
              orElse: () => ProductType.treatment,
            )
          : ProductType.treatment,
      targetSpecies: json['targetSpecies'] != null || json['target_species'] != null
          ? (json['targetSpecies'] ?? json['target_species'] as List)
              .map((e) => AnimalSpecies.values.firstWhere(
                  (s) => s.name == e,
                  orElse: () => AnimalSpecies.ovin,
                ))
              .toList()
          : [],
      standardCureDays: json['standardCureDays'] as int? ?? json['standard_cure_days'] as int?,
      administrationFrequency: json['administrationFrequency'] as String? ?? json['administration_frequency'] as String?,
      dosageFormula: json['dosageFormula'] as String? ?? json['dosage_formula'] as String?,
      vaccinationProtocol: json['vaccinationProtocol'] as String? ?? json['vaccination_protocol'] as String?,
      reminderDays: json['reminderDays'] != null || json['reminder_days'] != null
          ? (json['reminderDays'] ?? json['reminder_days'] as List?)?.map((e) => e as int).toList()
          : null,
      defaultAdministrationRoute: json['defaultAdministrationRoute'] as String? ?? json['default_administration_route'] as String?,
      defaultInjectionSite: json['defaultInjectionSite'] as String? ?? json['default_injection_site'] as String?,
      synced: json['synced'] as bool? ?? false,
      createdAt:
          DateTime.parse(json['createdAt'] ?? json['created_at'] as String),
      updatedAt: json['updatedAt'] != null || json['updated_at'] != null
          ? DateTime.parse(json['updatedAt'] ?? json['updated_at'] as String)
          : DateTime.now(),
      lastSyncedAt:
          json['lastSyncedAt'] != null || json['last_synced_at'] != null
              ? DateTime.parse(
                  json['lastSyncedAt'] ?? json['last_synced_at'] as String)
              : null,
      serverVersion:
          json['serverVersion'] as String? ?? json['server_version'] as String?,
    );
  }

  @override
  String toString() {
    return 'MedicalProduct(id: $id, name: $displayName, category: $category, '
        'stock: $currentStock $stockUnit, synced: $synced)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MedicalProduct && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
