// lib/models/vaccination.dart

import 'package:uuid/uuid.dart';
import 'syncable_entity.dart';

/// Type de vaccination
enum VaccinationType {
  obligatoire, // Vaccination obligatoire
  recommandee, // Vaccination recommandée
  optionnelle, // Vaccination optionnelle

  /// ⚠️ IMPORTANT : Les labels FR sont hardcodés ici car VaccinationPriority
  /// est un ENUM sans accès au BuildContext.
  ///
  /// La traduction se fera au niveau Provider/UI qui a accès au context.
}

extension VaccinationTypeExtension on VaccinationType {
  String get label {
    switch (this) {
      case VaccinationType.obligatoire:
        return 'Obligatoire';
      case VaccinationType.recommandee:
        return 'Recommandée';
      case VaccinationType.optionnelle:
        return 'Optionnelle';
    }
  }
}

class Vaccination implements SyncableEntity {
  // === Identification ===
  @override
  final String id;
  @override
  final String farmId;

  // === Animal(aux) concerné(s) ===
  final String? animalId;
  final List<String> animalIds;

  // === Protocole ===
  final String? protocolId;
  final String vaccineName;
  final VaccinationType type;
  final String disease;

  // === Administration ===
  final DateTime vaccinationDate;
  final String? batchNumber;
  final DateTime? expiryDate;
  final String dose;
  final String administrationRoute;

  // === Acteurs ===
  final String? veterinarianId;
  final String? veterinarianName;

  // === Rappel ===
  final DateTime? nextDueDate;

  // === Délai d'attente ===
  final int withdrawalPeriodDays;

  // === Notes ===
  final String? notes;

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
    this.farmId = 'farm_default',
    this.animalId,
    this.animalIds = const [],
    this.protocolId,
    required this.vaccineName,
    required this.type,
    required this.disease,
    required this.vaccinationDate,
    this.batchNumber,
    this.expiryDate,
    required this.dose,
    required this.administrationRoute,
    this.veterinarianId,
    this.veterinarianName,
    this.nextDueDate,
    this.withdrawalPeriodDays = 0,
    this.notes,
    this.synced = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastSyncedAt,
    this.serverVersion,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now() {
    assert(
      (animalId != null && animalIds.isEmpty) ||
          (animalId == null && animalIds.isNotEmpty),
      'Vaccination must have either animalId or animalIds',
    );
  }

  // === Getters ===

  bool get isGroupVaccination => animalIds.isNotEmpty;
  int get animalCount => isGroupVaccination ? animalIds.length : 1;

  bool get isReminderDue {
    if (nextDueDate == null) return false;
    final daysUntil = nextDueDate!.difference(DateTime.now()).inDays;
    return daysUntil <= 30 &&
        daysUntil >= -999; // Rappel dans 30 jours ou en retard
  }

  int? get daysUntilReminder {
    if (nextDueDate == null) return null;
    return nextDueDate!.difference(DateTime.now()).inDays;
  }

  bool get isInWithdrawalPeriod {
    if (withdrawalPeriodDays == 0) return false;
    final endDate = vaccinationDate.add(Duration(days: withdrawalPeriodDays));
    return DateTime.now().isBefore(endDate);
  }

  int get daysRemainingInWithdrawal {
    if (withdrawalPeriodDays == 0) return 0;
    final endDate = vaccinationDate.add(Duration(days: withdrawalPeriodDays));
    final remaining = endDate.difference(DateTime.now()).inDays;
    return remaining > 0 ? remaining : 0;
  }

  // === CRUD ===

  Vaccination copyWith({
    String? farmId,
    String? animalId,
    List<String>? animalIds,
    String? protocolId,
    String? vaccineName,
    VaccinationType? type,
    String? disease,
    DateTime? vaccinationDate,
    String? batchNumber,
    DateTime? expiryDate,
    String? dose,
    String? administrationRoute,
    String? veterinarianId,
    String? veterinarianName,
    DateTime? nextDueDate,
    int? withdrawalPeriodDays,
    String? notes,
    bool? synced,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    String? serverVersion,
  }) {
    return Vaccination(
      id: id,
      farmId: farmId ?? this.farmId,
      animalId: animalId ?? this.animalId,
      animalIds: animalIds ?? this.animalIds,
      protocolId: protocolId ?? this.protocolId,
      vaccineName: vaccineName ?? this.vaccineName,
      type: type ?? this.type,
      disease: disease ?? this.disease,
      vaccinationDate: vaccinationDate ?? this.vaccinationDate,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      dose: dose ?? this.dose,
      administrationRoute: administrationRoute ?? this.administrationRoute,
      veterinarianId: veterinarianId ?? this.veterinarianId,
      veterinarianName: veterinarianName ?? this.veterinarianName,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      withdrawalPeriodDays: withdrawalPeriodDays ?? this.withdrawalPeriodDays,
      notes: notes ?? this.notes,
      synced: synced ?? this.synced,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
    );
  }

  // === Sync ===

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

  // === JSON ===

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farm_id': farmId,
      'animal_id': animalId,
      'animal_ids': animalIds,
      'protocol_id': protocolId,
      'vaccine_name': vaccineName,
      'type': type.name,
      'disease': disease,
      'vaccination_date': vaccinationDate.toIso8601String(),
      'batch_number': batchNumber,
      'expiry_date': expiryDate?.toIso8601String(),
      'dose': dose,
      'administration_route': administrationRoute,
      'veterinarian_id': veterinarianId,
      'veterinarian_name': veterinarianName,
      'next_due_date': nextDueDate?.toIso8601String(),
      'withdrawal_period_days': withdrawalPeriodDays,
      'notes': notes,
      'synced': synced,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'server_version': serverVersion,
    };
  }

  factory Vaccination.fromJson(Map<String, dynamic> json) {
    return Vaccination(
      id: json['id'] as String,
      farmId: json['farm_id'] as String? ?? 'farm_default',
      animalId: json['animal_id'] as String?,
      animalIds: (json['animal_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      protocolId: json['protocol_id'] as String?,
      vaccineName: json['vaccine_name'] as String,
      type: VaccinationType.values.byName(json['type'] as String),
      disease: json['disease'] as String,
      vaccinationDate: DateTime.parse(json['vaccination_date'] as String),
      batchNumber: json['batch_number'] as String?,
      expiryDate: json['expiry_date'] != null
          ? DateTime.parse(json['expiry_date'] as String)
          : null,
      dose: json['dose'] as String,
      administrationRoute: json['administration_route'] as String,
      veterinarianId: json['veterinarian_id'] as String?,
      veterinarianName: json['veterinarian_name'] as String?,
      nextDueDate: json['next_due_date'] != null
          ? DateTime.parse(json['next_due_date'] as String)
          : null,
      withdrawalPeriodDays: json['withdrawal_period_days'] as int? ?? 0,
      notes: json['notes'] as String?,
      synced: json['synced'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastSyncedAt: json['last_synced_at'] != null
          ? DateTime.parse(json['last_synced_at'] as String)
          : null,
      serverVersion: json['server_version'] as String?,
    );
  }

  @override
  String toString() =>
      'Vaccination(id: $id, vaccineName: $vaccineName, disease: $disease, animalCount: $animalCount)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Vaccination &&
        other.id == id &&
        other.vaccineName == vaccineName &&
        other.disease == disease &&
        other.vaccinationDate == vaccinationDate;
  }

  @override
  int get hashCode => Object.hash(id, vaccineName, disease, vaccinationDate);
}
