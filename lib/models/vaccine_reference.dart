// lib/models/vaccine_reference.dart

import 'package:uuid/uuid.dart';
import 'syncable_entity.dart';

/// Référence de vaccin avec espèces cibles
class VaccineReference implements SyncableEntity {
  // === SyncableEntity implementation ===
  @override
  final String id;
  @override
  final String farmId;
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

  // === VaccineReference fields ===
  /// Nom du vaccin
  final String name;

  /// Description du vaccin
  final String? description;

  /// Fabricant du vaccin
  final String? manufacturer;

  /// Espèces cibles (ovine, bovine, caprine)
  /// Peut contenir plusieurs espèces si le vaccin est multi-espèces
  final List<String> targetSpecies;

  /// Maladies ciblées par le vaccin
  final List<String> targetDiseases;

  /// Dosage standard (peut varier selon l'espèce)
  final String? standardDose;

  /// Nombre d'injections requises pour primo-vaccination
  final int? injectionsRequired;

  /// Intervalle entre injections (en jours)
  final int? injectionIntervalDays;

  /// Délai d'attente viande (jours)
  final int meatWithdrawalDays;

  /// Délai d'attente lait (jours)
  final int milkWithdrawalDays;

  /// Voie d'administration (IM, SC, ID, etc.)
  final String? administrationRoute;

  /// Notes spécifiques au vaccin
  final String? notes;

  /// Le vaccin est-il actif/disponible ?
  final bool isActive;

  VaccineReference({
    String? id,
    required this.farmId,
    required this.name,
    this.description,
    this.manufacturer,
    this.targetSpecies = const [],
    this.targetDiseases = const [],
    this.standardDose,
    this.injectionsRequired,
    this.injectionIntervalDays,
    this.meatWithdrawalDays = 0,
    this.milkWithdrawalDays = 0,
    this.administrationRoute,
    this.notes,
    this.isActive = true,
    this.synced = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastSyncedAt,
    this.serverVersion,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Vérifie si le vaccin est compatible avec une espèce donnée
  bool isCompatibleWith(String species) {
    if (targetSpecies.isEmpty) return true; // Si vide, compatible avec tout
    return targetSpecies.any(
      (s) => s.toLowerCase() == species.toLowerCase(),
    );
  }

  /// Obtient le nom d'affichage avec espèces
  String get displayName {
    if (targetSpecies.isEmpty) return name;
    return '$name (${targetSpecies.join(", ")})';
  }

  /// Obtient le nom complet avec fabricant
  String get fullName {
    if (manufacturer == null) return name;
    return '$name - $manufacturer';
  }

  /// Obtient le protocole de vaccination en texte
  String get protocolSummary {
    if (injectionsRequired == null) return 'Protocole non défini';
    if (injectionsRequired == 1) return '1 injection';
    if (injectionIntervalDays == null) {
      return '$injectionsRequired injections';
    }
    return '$injectionsRequired injections à $injectionIntervalDays jours d\'intervalle';
  }

  VaccineReference copyWith({
    String? id,
    String? farmId,
    String? name,
    String? description,
    String? manufacturer,
    List<String>? targetSpecies,
    List<String>? targetDiseases,
    String? standardDose,
    int? injectionsRequired,
    int? injectionIntervalDays,
    int? meatWithdrawalDays,
    int? milkWithdrawalDays,
    String? administrationRoute,
    String? notes,
    bool? isActive,
    bool? synced,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    String? serverVersion,
  }) {
    return VaccineReference(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      name: name ?? this.name,
      description: description ?? this.description,
      manufacturer: manufacturer ?? this.manufacturer,
      targetSpecies: targetSpecies ?? this.targetSpecies,
      targetDiseases: targetDiseases ?? this.targetDiseases,
      standardDose: standardDose ?? this.standardDose,
      injectionsRequired: injectionsRequired ?? this.injectionsRequired,
      injectionIntervalDays:
          injectionIntervalDays ?? this.injectionIntervalDays,
      meatWithdrawalDays: meatWithdrawalDays ?? this.meatWithdrawalDays,
      milkWithdrawalDays: milkWithdrawalDays ?? this.milkWithdrawalDays,
      administrationRoute: administrationRoute ?? this.administrationRoute,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmId': farmId,
      'name': name,
      'description': description,
      'manufacturer': manufacturer,
      'targetSpecies': targetSpecies,
      'targetDiseases': targetDiseases,
      'standardDose': standardDose,
      'injectionsRequired': injectionsRequired,
      'injectionIntervalDays': injectionIntervalDays,
      'meatWithdrawalDays': meatWithdrawalDays,
      'milkWithdrawalDays': milkWithdrawalDays,
      'administrationRoute': administrationRoute,
      'notes': notes,
      'isActive': isActive,
      'synced': synced,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastSyncedAt': lastSyncedAt?.toIso8601String(),
      'serverVersion': serverVersion,
    };
  }

  factory VaccineReference.fromJson(Map<String, dynamic> json) {
    return VaccineReference(
      id: json['id'] as String?,
      farmId: json['farmId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      manufacturer: json['manufacturer'] as String?,
      targetSpecies: (json['targetSpecies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      targetDiseases: (json['targetDiseases'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      standardDose: json['standardDose'] as String?,
      injectionsRequired: json['injectionsRequired'] as int?,
      injectionIntervalDays: json['injectionIntervalDays'] as int?,
      meatWithdrawalDays: json['meatWithdrawalDays'] as int? ?? 0,
      milkWithdrawalDays: json['milkWithdrawalDays'] as int? ?? 0,
      administrationRoute: json['administrationRoute'] as String?,
      notes: json['notes'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      synced: json['synced'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      lastSyncedAt: json['lastSyncedAt'] != null
          ? DateTime.parse(json['lastSyncedAt'] as String)
          : null,
      serverVersion: json['serverVersion'] as String?,
    );
  }
}

/// Constantes pour les espèces
class VaccineTargetSpecies {
  static const String ovine = 'ovine';
  static const String bovine = 'bovine';
  static const String caprine = 'caprine';

  static const List<String> all = [ovine, bovine, caprine];

  static String getLabel(String species) {
    switch (species.toLowerCase()) {
      case 'ovine':
        return 'Ovin';
      case 'bovine':
        return 'Bovin';
      case 'caprine':
        return 'Caprin';
      default:
        return species;
    }
  }
}
