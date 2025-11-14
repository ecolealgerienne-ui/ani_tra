// lib/models/alert_configuration.dart

/// Enum des types d'évaluation d'alertes
/// Chaque type a sa logique spécifique de vérification
enum AlertEvaluationType {
  remanence,        // Délai abattage (rémanence)
  weighing,         // Pesée manquante
  vaccination,      // Vaccination due
  identification,   // EID manquant
  syncRequired,     // Sync en retard
  treatmentRenewal, // Traitement à renouveler
  batchToFinalize,  // Lot à finaliser
}

extension AlertEvaluationTypeExtension on AlertEvaluationType {
  String toStringValue() => toString().split('.').last;
  
  static AlertEvaluationType fromString(String value) {
    return AlertEvaluationType.values.firstWhere(
      (e) => e.toStringValue() == value,
      orElse: () => AlertEvaluationType.remanence,
    );
  }
}

/// Configuration d'alerte stockée en BD
/// Utilisée par AlertProvider pour générer les instances Alert dynamiquement
class AlertConfiguration {
  final String id;
  final String farmId;
  final AlertEvaluationType evaluationType;
  final String type;           // 'urgent', 'important', 'routine'
  final String category;       // AlertCategory enum
  final String titleKey;       // AppStrings key (ex: alertRemanenceTitle)
  final String messageKey;     // AppStrings key (ex: alertRemanenceMsg)
  final int severity;          // 1, 2, 3
  final String iconName;       // Emoji ou icon name
  final String colorHex;       // Hex color (#D32F2F)
  final bool enabled;          // Toggleable by user
  
  // Sync fields (Phase 2)
  final bool synced;
  final DateTime? lastSyncedAt;
  final String? serverVersion;
  
  // Soft-delete
  final DateTime? deletedAt;
  
  // Timestamps
  final DateTime createdAt;
  final DateTime updatedAt;

  const AlertConfiguration({
    required this.id,
    required this.farmId,
    required this.evaluationType,
    required this.type,
    required this.category,
    required this.titleKey,
    required this.messageKey,
    required this.severity,
    required this.iconName,
    required this.colorHex,
    required this.enabled,
    this.synced = false,
    this.lastSyncedAt,
    this.serverVersion,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Retorna una copia con valores opcionales reemplazados
  AlertConfiguration copyWith({
    String? id,
    String? farmId,
    AlertEvaluationType? evaluationType,
    String? type,
    String? category,
    String? titleKey,
    String? messageKey,
    int? severity,
    String? iconName,
    String? colorHex,
    bool? enabled,
    bool? synced,
    DateTime? lastSyncedAt,
    String? serverVersion,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AlertConfiguration(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      evaluationType: evaluationType ?? this.evaluationType,
      type: type ?? this.type,
      category: category ?? this.category,
      titleKey: titleKey ?? this.titleKey,
      messageKey: messageKey ?? this.messageKey,
      severity: severity ?? this.severity,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      enabled: enabled ?? this.enabled,
      synced: synced ?? this.synced,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'AlertConfiguration(id: $id, evaluationType: $evaluationType, enabled: $enabled)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlertConfiguration &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          farmId == other.farmId;

  @override
  int get hashCode => id.hashCode ^ farmId.hashCode;
}
