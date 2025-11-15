// lib/models/breeding.dart

import 'package:uuid/uuid.dart';
import 'syncable_entity.dart';

/// Méthode de reproduction
enum BreedingMethod {
  natural, // Saillie naturelle
  artificialInsemination, // Insémination artificielle
}

/// Statut de la reproduction
enum BreedingStatus {
  pending, // En attente de mise-bas
  completed, // Mise-bas effectuée
  failed, // Échec (pas de gestation)
  aborted, // Avortement
}

/// Enregistrement d'une saillie/reproduction
class Breeding implements SyncableEntity {
  @override
  final String id;
  @override
  final String farmId;

  /// ID de la mère
  final String motherId;

  /// ID du père (optionnel)
  final String? fatherId;

  /// Nom/numéro du père (si externe)
  final String? fatherName;

  /// Méthode de reproduction
  final BreedingMethod method;

  /// Date de saillie/IA
  final DateTime breedingDate;

  /// Date de mise-bas prévue (calculée)
  final DateTime expectedBirthDate;

  /// Date de mise-bas réelle (si déjà née)
  final DateTime? actualBirthDate;

  /// Nombre de petits attendus
  final int? expectedOffspringCount;

  /// IDs des petits nés
  final List<String> offspringIds;

  /// Vétérinaire ayant effectué l'IA (si applicable)
  final String? veterinarianId;
  final String? veterinarianName;

  /// Notes additionnelles
  final String? notes;

  /// Statut
  final BreedingStatus status;

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

  Breeding({
    String? id,
    required this.farmId,
    required this.motherId,
    this.fatherId,
    this.fatherName,
    required this.method,
    required this.breedingDate,
    required this.expectedBirthDate,
    this.actualBirthDate,
    this.expectedOffspringCount,
    this.offspringIds = const [],
    this.veterinarianId,
    this.veterinarianName,
    this.notes,
    this.status = BreedingStatus.pending,
    this.synced = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastSyncedAt,
    this.serverVersion,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // === Helpers ===

  /// Jours avant la mise-bas prévue
  int get daysUntilExpectedBirth {
    return expectedBirthDate.difference(DateTime.now()).inDays;
  }

  /// La mise-bas est proche (< 7 jours)
  bool get isBirthSoon {
    return daysUntilExpectedBirth <= 7 && daysUntilExpectedBirth >= 0;
  }

  /// La mise-bas est en retard
  bool get isOverdue {
    return daysUntilExpectedBirth < 0 && actualBirthDate == null;
  }

  /// Nombre réel de petits nés
  int get actualOffspringCount => offspringIds.length;

  /// Durée de gestation (jours)
  int? get gestationDays {
    if (actualBirthDate == null) return null;
    return actualBirthDate!.difference(breedingDate).inDays;
  }

  /// Différence entre date prévue et réelle (jours)
  int? get birthDateVariation {
    if (actualBirthDate == null) return null;
    return actualBirthDate!.difference(expectedBirthDate).inDays;
  }

  /// La reproduction est terminée ?
  bool get isCompleted => status == BreedingStatus.completed;

  /// La reproduction a échoué ?
  bool get hasFailed =>
      status == BreedingStatus.failed || status == BreedingStatus.aborted;

  Breeding copyWith({
    String? fatherId,
    String? fatherName,
    BreedingMethod? method,
    DateTime? breedingDate,
    DateTime? expectedBirthDate,
    DateTime? actualBirthDate,
    int? expectedOffspringCount,
    List<String>? offspringIds,
    String? veterinarianId,
    String? veterinarianName,
    String? notes,
    BreedingStatus? status,
    bool? synced,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    String? serverVersion,
  }) {
    return Breeding(
      id: id,
      farmId: farmId,
      motherId: motherId,
      fatherId: fatherId ?? this.fatherId,
      fatherName: fatherName ?? this.fatherName,
      method: method ?? this.method,
      breedingDate: breedingDate ?? this.breedingDate,
      expectedBirthDate: expectedBirthDate ?? this.expectedBirthDate,
      actualBirthDate: actualBirthDate ?? this.actualBirthDate,
      expectedOffspringCount:
          expectedOffspringCount ?? this.expectedOffspringCount,
      offspringIds: offspringIds ?? this.offspringIds,
      veterinarianId: veterinarianId ?? this.veterinarianId,
      veterinarianName: veterinarianName ?? this.veterinarianName,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      synced: synced ?? this.synced,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
    );
  }

  /// Méthodes de sync
  Breeding markAsSynced({required String serverVersion}) {
    return copyWith(
      synced: true,
      lastSyncedAt: DateTime.now(),
      serverVersion: serverVersion,
    );
  }

  Breeding markAsModified() {
    return copyWith(
      synced: false,
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmId': farmId,
      'motherId': motherId,
      'fatherId': fatherId,
      'fatherName': fatherName,
      'method': method.name,
      'breedingDate': breedingDate.toIso8601String(),
      'expectedBirthDate': expectedBirthDate.toIso8601String(),
      'actualBirthDate': actualBirthDate?.toIso8601String(),
      'expectedOffspringCount': expectedOffspringCount,
      'offspringIds': offspringIds,
      'veterinarianId': veterinarianId,
      'veterinarianName': veterinarianName,
      'notes': notes,
      'status': status.name,
      'synced': synced,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastSyncedAt': lastSyncedAt?.toIso8601String(),
      'serverVersion': serverVersion,
    };
  }

  factory Breeding.fromJson(Map<String, dynamic> json) {
    return Breeding(
      id: json['id'] as String,
      farmId: json['farmId'] as String,
      motherId: json['motherId'] as String,
      fatherId: json['fatherId'] as String?,
      fatherName: json['fatherName'] as String?,
      method: BreedingMethod.values.byName(json['method'] as String),
      breedingDate: DateTime.parse(json['breedingDate'] as String),
      expectedBirthDate: DateTime.parse(json['expectedBirthDate'] as String),
      actualBirthDate: json['actualBirthDate'] != null
          ? DateTime.parse(json['actualBirthDate'] as String)
          : null,
      expectedOffspringCount: json['expectedOffspringCount'] as int?,
      offspringIds: (json['offspringIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      veterinarianId: json['veterinarianId'] as String?,
      veterinarianName: json['veterinarianName'] as String?,
      notes: json['notes'] as String?,
      status: BreedingStatus.values.byName(json['status'] as String),
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
