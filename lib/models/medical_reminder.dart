// lib/models/medical_reminder.dart

/// Type de rappel médical
enum ReminderType {
  treatment,    // Rappel pour un traitement
  vaccination   // Rappel pour une vaccination
}

/// Statut d'un rappel
enum ReminderStatus {
  pending,     // En attente
  completed,   // Complété
  cancelled    // Annulé
}

/// Rappel médical pour les traitements et vaccinations
class MedicalReminder {
  /// Identifiant unique du rappel
  final String id;

  /// ID de l'acte médical (traitement ou vaccination)
  final String medicalActId;

  /// Type de rappel
  final ReminderType type;

  /// Date du rappel
  final DateTime reminderDate;

  /// Heure de la notification
  final DateTime reminderTime;

  /// ID de l'animal concerné
  final String animalId;

  /// Nom du produit
  final String productName;

  /// Numéro du jour (ex: J2, J3, etc.)
  final int dayNumber;

  /// Nombre total de jours (ex: cure de 5 jours)
  final int totalDays;

  /// Statut du rappel
  final ReminderStatus status;

  /// Date de complétion (si complété)
  final DateTime? completedAt;

  /// Date de création
  final DateTime createdAt;

  MedicalReminder({
    required this.id,
    required this.medicalActId,
    required this.type,
    required this.reminderDate,
    required this.reminderTime,
    required this.animalId,
    required this.productName,
    required this.dayNumber,
    required this.totalDays,
    this.status = ReminderStatus.pending,
    this.completedAt,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // ==================== Getters ====================

  /// Vérifier si le rappel est en attente
  bool get isPending => status == ReminderStatus.pending;

  /// Vérifier si le rappel est complété
  bool get isCompleted => status == ReminderStatus.completed;

  /// Vérifier si le rappel est annulé
  bool get isCancelled => status == ReminderStatus.cancelled;

  /// Vérifier si le rappel est passé
  bool get isPast => reminderDate.isBefore(DateTime.now());

  /// Vérifier si le rappel est aujourd'hui
  bool get isToday {
    final now = DateTime.now();
    return reminderDate.year == now.year &&
        reminderDate.month == now.month &&
        reminderDate.day == now.day;
  }

  /// Obtenir le libellé du jour (ex: "J2/5")
  String get dayLabel => 'J$dayNumber/$totalDays';

  // ==================== Méthodes ====================

  /// Copie avec modifications
  MedicalReminder copyWith({
    String? id,
    String? medicalActId,
    ReminderType? type,
    DateTime? reminderDate,
    DateTime? reminderTime,
    String? animalId,
    String? productName,
    int? dayNumber,
    int? totalDays,
    ReminderStatus? status,
    DateTime? completedAt,
    DateTime? createdAt,
  }) {
    return MedicalReminder(
      id: id ?? this.id,
      medicalActId: medicalActId ?? this.medicalActId,
      type: type ?? this.type,
      reminderDate: reminderDate ?? this.reminderDate,
      reminderTime: reminderTime ?? this.reminderTime,
      animalId: animalId ?? this.animalId,
      productName: productName ?? this.productName,
      dayNumber: dayNumber ?? this.dayNumber,
      totalDays: totalDays ?? this.totalDays,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Marquer comme complété
  MedicalReminder markAsCompleted() {
    return copyWith(
      status: ReminderStatus.completed,
      completedAt: DateTime.now(),
    );
  }

  /// Marquer comme annulé
  MedicalReminder markAsCancelled() {
    return copyWith(
      status: ReminderStatus.cancelled,
    );
  }

  // ==================== Sérialisation ====================

  /// Convertir en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicalActId': medicalActId,
      'type': type.name,
      'reminderDate': reminderDate.toIso8601String(),
      'reminderTime': reminderTime.toIso8601String(),
      'animalId': animalId,
      'productName': productName,
      'dayNumber': dayNumber,
      'totalDays': totalDays,
      'status': status.name,
      'completedAt': completedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Créer depuis JSON
  factory MedicalReminder.fromJson(Map<String, dynamic> json) {
    return MedicalReminder(
      id: json['id'] as String,
      medicalActId: json['medicalActId'] as String? ?? json['medical_act_id'] as String,
      type: ReminderType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ReminderType.treatment,
      ),
      reminderDate: DateTime.parse(json['reminderDate'] ?? json['reminder_date'] as String),
      reminderTime: DateTime.parse(json['reminderTime'] ?? json['reminder_time'] as String),
      animalId: json['animalId'] as String? ?? json['animal_id'] as String,
      productName: json['productName'] as String? ?? json['product_name'] as String,
      dayNumber: json['dayNumber'] as int? ?? json['day_number'] as int,
      totalDays: json['totalDays'] as int? ?? json['total_days'] as int,
      status: json['status'] != null
          ? ReminderStatus.values.firstWhere(
              (e) => e.name == json['status'],
              orElse: () => ReminderStatus.pending,
            )
          : ReminderStatus.pending,
      completedAt: json['completedAt'] != null || json['completed_at'] != null
          ? DateTime.parse(json['completedAt'] ?? json['completed_at'] as String)
          : null,
      createdAt: json['createdAt'] != null || json['created_at'] != null
          ? DateTime.parse(json['createdAt'] ?? json['created_at'] as String)
          : DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'MedicalReminder(id: $id, productName: $productName, '
        'dayLabel: $dayLabel, status: ${status.name})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MedicalReminder && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
