// lib/models/eid_change.dart

import 'package:flutter/material.dart';
import '../i18n/app_localizations.dart';
import '../i18n/app_strings.dart';

/// Historique d'un changement d'EID (Electronic IDentification)
///
/// Enregistre chaque fois qu'une puce RFID est remplacée sur un animal.
/// Permet la traçabilité complète des changements de puces.
class EidChange {
  final String id;
  final String oldEid;
  final String newEid;
  final DateTime changedAt;
  final String reason;
  final String? notes;

  const EidChange({
    required this.id,
    required this.oldEid,
    required this.newEid,
    required this.changedAt,
    required this.reason,
    this.notes,
  });

  /// Créer une copie avec modifications
  EidChange copyWith({
    String? id,
    String? oldEid,
    String? newEid,
    DateTime? changedAt,
    String? reason,
    String? notes,
  }) {
    return EidChange(
      id: id ?? this.id,
      oldEid: oldEid ?? this.oldEid,
      newEid: newEid ?? this.newEid,
      changedAt: changedAt ?? this.changedAt,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
    );
  }

  /// Convertir en Map (pour base de données)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'old_eid': oldEid,
      'new_eid': newEid,
      'changed_at': changedAt.toIso8601String(),
      'reason': reason,
      'notes': notes,
    };
  }

  /// Créer depuis Map (depuis base de données)
  factory EidChange.fromMap(Map<String, dynamic> map) {
    return EidChange(
      id: map['id'] as String,
      oldEid: map['old_eid'] as String,
      newEid: map['new_eid'] as String,
      changedAt: DateTime.parse(map['changed_at'] as String),
      reason: map['reason'] as String,
      notes: map['notes'] as String?,
    );
  }

  /// Convertir en JSON (pour API)
  Map<String, dynamic> toJson() => toMap();

  /// Créer depuis JSON (depuis API)
  factory EidChange.fromJson(Map<String, dynamic> json) =>
      EidChange.fromMap(json);

  @override
  String toString() {
    return 'EidChange(oldEid: $oldEid, newEid: $newEid, reason: $reason, changedAt: $changedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EidChange &&
        other.id == id &&
        other.oldEid == oldEid &&
        other.newEid == newEid &&
        other.changedAt == changedAt &&
        other.reason == reason &&
        other.notes == notes;
  }

  @override
  int get hashCode {
    return Object.hash(id, oldEid, newEid, changedAt, reason, notes);
  }
}

/// Raisons prédéfinies pour le changement d'EID
class EidChangeReason {
  static const String pucePerdue = 'puce_perdue';
  static const String puceCassee = 'puce_cassee';
  static const String puceDefectueuse = 'puce_defectueuse';
  static const String erreurSaisie = 'erreur_saisie';
  static const String remplacement = 'remplacement';
  static const String autre = 'autre';

  static const List<String> all = [
    pucePerdue,
    puceCassee,
    puceDefectueuse,
    erreurSaisie,
    remplacement,
    autre,
  ];

  static String getLabel(String reason, BuildContext context) {
    switch (reason) {
      case pucePerdue:
        return AppLocalizations.of(context).translate(AppStrings.chipLost);
      case puceCassee:
        return AppLocalizations.of(context).translate(AppStrings.chipBroken);
      case puceDefectueuse:
        return AppLocalizations.of(context).translate(AppStrings.chipDefective);
      case erreurSaisie:
        return AppLocalizations.of(context).translate(AppStrings.entryError);
      case remplacement:
        return AppLocalizations.of(context).translate(AppStrings.replacement);
      case autre:
        return AppLocalizations.of(context).translate(AppStrings.otherReason);
      default:
        return reason;
    }
  }
}
