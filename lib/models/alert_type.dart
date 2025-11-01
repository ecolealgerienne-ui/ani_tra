// lib/models/alert_type.dart

/// Type/Niveau d'alerte selon l'urgence
///
/// Hiérarchie :
/// - URGENT (🚨) : Action immédiate requise, risque légal/sanitaire
/// - IMPORTANT (⚠️) : Action nécessaire sous 7 jours
/// - ROUTINE (📋) : Tâche planifiée, pas d'urgence
enum AlertType {
  /// 🚨 URGENT - Action immédiate requise
  ///
  /// Exemples :
  /// - Délai abattage dépassé (amende)
  /// - Animal sans EID (non-conformité)
  /// - Sync > 14 jours (perte données)
  urgent,

  /// ⚠️ IMPORTANT - Action sous 7 jours
  ///
  /// Exemples :
  /// - Rémanence proche
  /// - Traitement à renouveler
  /// - Sync > 7 jours
  important,

  /// 📋 ROUTINE - Tâche planifiée
  ///
  /// Exemples :
  /// - Pesée hebdomadaire
  /// - Finaliser lot
  /// - Backup mensuel
  routine,
}

/// Extension pour obtenir les propriétés visuelles
extension AlertTypeExtension on AlertType {
  /// Icône selon le type
  String get icon {
    switch (this) {
      case AlertType.urgent:
        return '🚨';
      case AlertType.important:
        return '⚠️';
      case AlertType.routine:
        return '📋';
    }
  }

  /// Label en français
  String get labelFr {
    switch (this) {
      case AlertType.urgent:
        return 'URGENT';
      case AlertType.important:
        return 'Important';
      case AlertType.routine:
        return 'À faire';
    }
  }

  /// Label en anglais
  String get labelEn {
    switch (this) {
      case AlertType.urgent:
        return 'URGENT';
      case AlertType.important:
        return 'Important';
      case AlertType.routine:
        return 'To Do';
    }
  }

  /// Couleur selon le type (hex string)
  String get colorHex {
    switch (this) {
      case AlertType.urgent:
        return '#D32F2F'; // Rouge
      case AlertType.important:
        return '#F57C00'; // Orange
      case AlertType.routine:
        return '#1976D2'; // Bleu
    }
  }

  /// Priorité pour le tri (plus petit = plus urgent)
  int get priority {
    switch (this) {
      case AlertType.urgent:
        return 1;
      case AlertType.important:
        return 2;
      case AlertType.routine:
        return 3;
    }
  }
}
