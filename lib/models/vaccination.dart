// lib/models/vaccination.dart

import 'package:uuid/uuid.dart';
import 'syncable_entity.dart';

/// Statut d'une vaccination
enum VaccinationStatus {
  planned, // Planifiée
  administered, // Administrée
  overdue, // En retard
  cancelled, // Annulée
}

/// Enregistrement d'une vaccination
class Vaccination implements SyncableEntity {
  // === Identification ===
  @override
  final String id;
  @override
  final String farmId;

  /// ID de l'animal vacciné
  final String animalId;

  /// ID du produit vaccinal utilisé
  final String productId;

  /// Nom du produit (pour affichage rapide)
  final String productName;

  // === Dates ===
  /// Date d'administration (réelle ou planifiée)
  final DateTime administrationDate;

  /// Date du prochain rappel
  final DateTime? nextDueDate;

  // === Détails administration ===
  /// Numéro de lot du vaccin
  final String? batchNumber;

  /// Dosage administré
  final double? dosage;

  /// Unité de dosage
  final String? dosageUnit;

  /// Voie d'administration (SC, IM, ID, etc.)
  final String? administrationRoute;

  /// Site d'injection (encolure, cuisse, etc.)
  final String? injectionSite;

  // === Acteurs ===
  /// ID du vétérinaire (si applicable)
  final String? veterinarianId;

  /// Nom du vétérinaire
  final String? veterinarianName;

  /// Personne ayant administré
  final String? administeredBy;

  // === Traçabilité ===
  /// Statut de la vaccination
  final VaccinationStatus status;

  /// Notes additionnelles
  final String? notes;

  /// Réaction adverse observée
  final String? adverseReaction;

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

  Vaccination({
    String? id,
    required this.farmId,
    required this.animalId,
    required this.productId,
    required this.productName,
    required this.administrationDate,
    this.nextDueDate,
    this.batchNumber,
    this.dosage,
    this.dosageUnit,
    this.administrationRoute,
    this.injectionSite,
    this.veterinarianId,
    this.veterinarianName,
    this.administeredBy,
    this.status = VaccinationStatus.planned,
    this.notes,
    this.adverseReaction,
    this.synced = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastSyncedAt,
    this.serverVersion,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // === Helpers ===

  /// La vaccination est en retard ?
  bool get isOverdue {
    if (status != VaccinationStatus.planned) return false;
    return administrationDate.isBefore(DateTime.now());
  }

  /// Jours avant/après la date prévue
  int get daysUntilDue {
    return administrationDate.difference(DateTime.now()).inDays;
  }

  /// Le rappel est bientôt dû ?
  bool get isReminderDue {
    if (nextDueDate == null) return false;
    final daysUntil = nextDueDate!.difference(DateTime.now()).inDays;
    return daysUntil <= 30 && daysUntil >= 0;
  }

  /// Vaccin déjà administré ?
  bool get isAdministered => status == VaccinationStatus.administered;

  // === Méthodes CRUD ===

  Vaccination copyWith({
    String? animalId,
    String? productId,
    String? productName,
    DateTime? administrationDate,
    DateTime? nextDueDate,
    String? batchNumber,
    double? dosage,
    String? dosageUnit,
    String? administrationRoute,
    String? injectionSite,
    String? veterinarianId,
    String? veterinarianName,
    String? administeredBy,
    VaccinationStatus? status,
    String? notes,
    String? adverseReaction,
    bool? synced,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    String? serverVersion,
  }) {
    return Vaccination(
      id: id,
      farmId: farmId,
      animalId: animalId ?? this.animalId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      administrationDate: administrationDate ?? this.administrationDate,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      batchNumber: batchNumber ?? this.batchNumber,
      dosage: dosage ?? this.dosage,
      dosageUnit: dosageUnit ?? this.dosageUnit,
      administrationRoute: administrationRoute ?? this.administrationRoute,
      injectionSite: injectionSite ?? this.injectionSite,
      veterinarianId: veterinarianId ?? this.veterinarianId,
      veterinarianName: veterinarianName ?? this.veterinarianName,
      administeredBy: administeredBy ?? this.administeredBy,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      adverseReaction: adverseReaction ?? this.adverseReaction,
      synced: synced ?? this.synced,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
    );
  }

  // === Méthodes de sync ===

  Vaccination markAsSynced({required String serverVersion}) {
    return copyWith(
      synced: true,
      lastSyncedAt: DateTime.now(),
      serverVersion: serverVersion,
    );
  }

  Vaccination markAsModified() {
    return copyWith(
      synced: false,
      updatedAt: DateTime.now(),
    );
  }

  // === JSON Serialization ===

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmId': farmId,
      'animalId': animalId,
      'productId': productId,
      'productName': productName,
      'administrationDate': administrationDate.toIso8601String(),
      'nextDueDate': nextDueDate?.toIso8601String(),
      'batchNumber': batchNumber,
      'dosage': dosage,
      'dosageUnit': dosageUnit,
      'administrationRoute': administrationRoute,
      'injectionSite': injectionSite,
      'veterinarianId': veterinarianId,
      'veterinarianName': veterinarianName,
      'administeredBy': administeredBy,
      'status': status.name,
      'notes': notes,
      'adverseReaction': adverseReaction,
      'synced': synced,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastSyncedAt': lastSyncedAt?.toIso8601String(),
      'serverVersion': serverVersion,
    };
  }

  factory Vaccination.fromJson(Map<String, dynamic> json) {
    return Vaccination(
      id: json['id'] as String,
      farmId: json['farmId'] as String,
      animalId: json['animalId'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      administrationDate: DateTime.parse(json['administrationDate'] as String),
      nextDueDate: json['nextDueDate'] != null
          ? DateTime.parse(json['nextDueDate'] as String)
          : null,
      batchNumber: json['batchNumber'] as String?,
      dosage: (json['dosage'] as num?)?.toDouble(),
      dosageUnit: json['dosageUnit'] as String?,
      administrationRoute: json['administrationRoute'] as String?,
      injectionSite: json['injectionSite'] as String?,
      veterinarianId: json['veterinarianId'] as String?,
      veterinarianName: json['veterinarianName'] as String?,
      administeredBy: json['administeredBy'] as String?,
      status: VaccinationStatus.values.byName(json['status'] as String),
      notes: json['notes'] as String?,
      adverseReaction: json['adverseReaction'] as String?,
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
