// lib/models/alert.dart

import 'package:flutter/material.dart';
import 'alert_type.dart';
import 'alert_category.dart';
import '../i18n/app_localizations.dart';

/// Modèle d'alerte métier
///
/// Représente une alerte/tâche à réaliser par l'éleveur.
/// Hiérarchisée par type (urgent/important/routine) et catégorie métier.
///
/// Phase 2: Support titleKey + messageKey + messageParams pour I18N config-driven
class Alert {
  /// Identifiant unique de l'alerte
  final String id;

  /// Type d'alerte (urgent/important/routine)
  final AlertType type;

  /// Catégorie métier
  final AlertCategory category;

  /// Titre court de l'alerte
  final String title;

  /// Message détaillé
  final String message;

  /// Phase 2: Clé I18N pour le titre (replaces hardcoded title)
  /// Ex: AppStrings.alertRemanenceTitle
  String? titleKey;

  /// Phase 2: Clé I18N pour le message (replaces hardcoded message)
  /// Ex: AppStrings.alertRemanenceMsg
  String? messageKey;

  /// Phase 2: Paramètres pour interpolation du message
  /// Ex: {'animalName': 'BR-001', 'daysRemaining': '3'}
  Map<String, dynamic>? messageParams;

  /// ID de l'entité concernée (animal, lot, traitement...)
  /// Permet de naviguer vers le détail
  final String? entityId;

  /// Type d'entité concernée
  final String? entityType;

  /// Nom d'affichage de l'entité (ex: "BR-001", "Lot Vente")
  final String? entityName;

  /// Date de création de l'alerte
  final DateTime createdAt;

  /// Date d'échéance (si applicable)
  final DateTime? dueDate;

  /// Nombre de jours restants (si dueDate définie)
  int? get daysRemaining {
    if (dueDate == null) return null;
    final diff = dueDate!.difference(DateTime.now()).inDays;
    return diff;
  }

  /// Alerte est en retard
  bool get isOverdue {
    if (dueDate == null) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  /// Action recommandée (texte du bouton)
  final String? actionLabel;

  /// Compteur (ex: "3 animaux", "5 pesées")
  final int? count;

  /// 🆕 Liste des IDs d'animaux concernés (pour alertes multiples)
  /// Permet de filtrer la liste d'animaux ou de naviguer vers chacun
  final List<String>? animalIds;

  Alert({
    required this.id,
    required this.type,
    required this.category,
    required this.title,
    required this.message,
    this.entityId,
    this.entityType,
    this.entityName,
    DateTime? createdAt,
    this.dueDate,
    this.actionLabel,
    this.count,
    this.animalIds,
    this.titleKey,
    this.messageKey,
    this.messageParams,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Constructeur : Alerte de rémanence
  ///
  /// ⚠️ IMPORTANT : Ce constructeur crée des messages HARDCODÉS
  /// qui seront traduits au niveau UI (AlertProvider)
  factory Alert.remanence({
    required String animalId,
    required String animalName,
    required int daysRemaining,
    required String treatmentName,
  }) {
    final type = daysRemaining <= 0
        ? AlertType.urgent
        : daysRemaining <= 3
            ? AlertType.important
            : AlertType.routine;

    // Messages hardcodés pour l'instant
    // Traduction faite au niveau Provider/UI
    return Alert(
      id: 'remanence_$animalId',
      type: type,
      category: AlertCategory.remanence,
      title:
          daysRemaining <= 0 ? 'Délai abattage dépassé' : 'Rémanence en cours',
      message: daysRemaining <= 0
          ? '$animalName : Délai dépassé pour $treatmentName'
          : '$animalName : $daysRemaining jour(s) avant abattage ($treatmentName)',
      entityId: animalId,
      entityType: 'animal',
      entityName: animalName,
      dueDate: DateTime.now().add(Duration(days: daysRemaining)),
      actionLabel: 'Voir l\'animal',
      animalIds: [animalId],
    );
  }

  /// Constructeur : Alerte d'identification manquante
  factory Alert.missingIdentification({
    required String animalId,
    required String animalName,
    required int ageInDays,
  }) {
    return Alert(
      id: 'identification_$animalId',
      type: ageInDays > 180 ? AlertType.urgent : AlertType.important,
      category: AlertCategory.identification,
      title: 'EID manquant',
      message: '$animalName (${ageInDays}j) : Identification obligatoire',
      entityId: animalId,
      entityType: 'animal',
      entityName: animalName,
      actionLabel: 'Ajouter EID',
      animalIds: [animalId],
    );
  }

  /// Constructeur : Événement incomplet
  factory Alert.incompleteEvent({
    required String eventId,
    required String eventType,
    required String description,
    required int daysOld,
  }) {
    return Alert(
      id: 'incomplete_$eventId',
      type: daysOld > 7 ? AlertType.important : AlertType.routine,
      category: AlertCategory.registre,
      title: 'Événement à finaliser',
      message: '$eventType : $description (il y a ${daysOld}j)',
      entityId: eventId,
      entityType: eventType.toLowerCase(),
      actionLabel: 'Compléter',
    );
  }

  /// Constructeur : Synchronisation requise
  factory Alert.syncRequired({
    required int daysSinceLastSync,
    required int pendingItems,
  }) {
    final type = daysSinceLastSync > 14
        ? AlertType.urgent
        : daysSinceLastSync > 7
            ? AlertType.important
            : AlertType.routine;

    return Alert(
      id: 'sync_required',
      type: type,
      category: AlertCategory.sync,
      title: daysSinceLastSync > 14
          ? 'Synchronisation critique'
          : 'Synchronisation requise',
      message:
          'Dernière sync il y a ${daysSinceLastSync}j • $pendingItems élément(s) en attente',
      actionLabel: 'Synchroniser',
      count: pendingItems,
    );
  }

  /// Constructeur : Pesée requise
  factory Alert.weighingRequired({
    required List<String> animalIds,
    required String reason,
  }) {
    return Alert(
      id: 'weighing_${DateTime.now().millisecondsSinceEpoch}',
      type: AlertType.routine,
      category: AlertCategory.weighing,
      title: 'Pesée recommandée',
      message: '$reason : ${animalIds.length} animal(aux) à peser',
      actionLabel: 'Voir les animaux',
      count: animalIds.length,
      animalIds: animalIds,
    );
  }

  /// Constructeur : Traitement à renouveler
  factory Alert.treatmentRenewal({
    required String treatmentId,
    required String animalId,
    required String animalName,
    required String treatmentName,
    required DateTime dueDate,
  }) {
    final daysRemaining = dueDate.difference(DateTime.now()).inDays;

    return Alert(
      id: 'treatment_renewal_$treatmentId',
      type: daysRemaining <= 1 ? AlertType.important : AlertType.routine,
      category: AlertCategory.treatment,
      title: 'Traitement à renouveler',
      message: '$animalName : $treatmentName (dans ${daysRemaining}j)',
      entityId: animalId,
      entityType: 'animal',
      entityName: animalName,
      dueDate: dueDate,
      actionLabel: 'Renouveler',
      animalIds: [animalId],
    );
  }

  /// Constructeur : Lot à finaliser
  factory Alert.batchToFinalize({
    required String batchId,
    required String batchName,
    required int animalCount,
    List<String>? animalIds,
  }) {
    return Alert(
      id: 'batch_finalize_$batchId',
      type: AlertType.routine,
      category: AlertCategory.batch,
      title: 'Lot à finaliser',
      message: '$batchName : $animalCount animal(aux)',
      entityId: batchId,
      entityType: 'batch',
      entityName: batchName,
      actionLabel: 'Finaliser',
      count: animalCount,
      animalIds: animalIds,
    );
  }

  /// 🆕 PART3 - Constructeur : Mère non déclarée
  factory Alert.missingMother({
    required String animalId,
    required String animalName,
  }) {
    return Alert(
      id: 'missing_mother_$animalId',
      type: AlertType.important,
      category: AlertCategory.registre,
      title: 'Mère non déclarée',
      message: '$animalName : Animal né dans l\'élevage sans mère',
      entityId: animalId,
      entityType: 'animal',
      entityName: animalName,
      actionLabel: 'Déclarer la mère',
      animalIds: [animalId],
    );
  }

  /// 🆕 PART3 - Constructeur : Mère invalide
  factory Alert.invalidMother({
    required String animalId,
    required String animalName,
    required String reason,
  }) {
    return Alert(
      id: 'invalid_mother_$animalId',
      type: AlertType.urgent,
      category: AlertCategory.registre,
      title: 'Mère invalide',
      message: '$animalName : $reason',
      entityId: animalId,
      entityType: 'animal',
      entityName: animalName,
      actionLabel: 'Corriger',
      animalIds: [animalId],
    );
  }

  /// Constructeur : Animaux en brouillon
  factory Alert.draftsPending({
    required int draftCount,
    required List<String> draftIds,
    required AlertType type,
  }) {
    return Alert(
      id: 'drafts_pending',
      type: type,
      category: AlertCategory.registre,
      title: '📋 Brouillons en attente',
      message: '$draftCount animal(aux) à valider',
      actionLabel: 'Valider brouillons',
      count: draftCount,
      animalIds: draftIds,
    );
  }

  /// Copie avec modifications
  Alert copyWith({
    String? id,
    AlertType? type,
    AlertCategory? category,
    String? title,
    String? message,
    String? entityId,
    String? entityType,
    String? entityName,
    DateTime? createdAt,
    DateTime? dueDate,
    String? actionLabel,
    int? count,
    String? titleKey,
    String? messageKey,
    Map<String, dynamic>? messageParams,
  }) {
    return Alert(
      id: id ?? this.id,
      type: type ?? this.type,
      category: category ?? this.category,
      title: title ?? this.title,
      message: message ?? this.message,
      entityId: entityId ?? this.entityId,
      entityType: entityType ?? this.entityType,
      entityName: entityName ?? this.entityName,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      actionLabel: actionLabel ?? this.actionLabel,
      count: count ?? this.count,
      titleKey: titleKey ?? this.titleKey,
      messageKey: messageKey ?? this.messageKey,
      messageParams: messageParams ?? this.messageParams,
    );
  }

  /// Phase 2: Obtenir le titre traduit avec I18N
  /// Utilise titleKey si présent (config-driven), sinon title hardcodé
  String getTitle(BuildContext context) {
    if (titleKey != null && titleKey!.isNotEmpty) {
      try {
        return AppLocalizations.of(context).translate(titleKey!);
      } catch (e) {
        return title; // Fallback
      }
    }
    return title;
  }

  /// Phase 2: Obtenir le message traduit avec I18N
  /// Utilise messageKey si présent (config-driven), puis interpole messageParams
  String getMessage(BuildContext context) {
    String message = this.message;

    if (messageKey != null && messageKey!.isNotEmpty) {
      try {
        message = AppLocalizations.of(context).translate(messageKey!);
      } catch (e) {
        // Fallback sur message hardcodé
        message = this.message;
      }
    }

    // Interpoler les params
    if (messageParams != null && messageParams!.isNotEmpty) {
      messageParams!.forEach((key, value) {
        message = message.replaceAll('{$key}', value.toString());
      });
    }

    return message;
  }

  /// Conversion en Map (pour persistance)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'category': category.name,
      'title': title,
      'message': message,
      'titleKey': titleKey,
      'messageKey': messageKey,
      'messageParams': messageParams,
      'entityId': entityId,
      'entityType': entityType,
      'entityName': entityName,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'actionLabel': actionLabel,
      'count': count,
    };
  }

  /// Création depuis Map
  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'],
      type: AlertType.values.firstWhere((e) => e.name == json['type']),
      category:
          AlertCategory.values.firstWhere((e) => e.name == json['category']),
      title: json['title'],
      message: json['message'],
      titleKey: json['titleKey'],
      messageKey: json['messageKey'],
      messageParams: json['messageParams'] != null
          ? Map<String, dynamic>.from(json['messageParams'])
          : null,
      entityId: json['entityId'],
      entityType: json['entityType'],
      entityName: json['entityName'],
      createdAt: DateTime.parse(json['createdAt']),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      actionLabel: json['actionLabel'],
      count: json['count'],
    );
  }

  @override
  String toString() {
    return 'Alert(${type.labelFr} - ${category.labelFr}: $title)';
  }
}
