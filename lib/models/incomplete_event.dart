// lib/models/incomplete_event.dart

/// Type d'événement incomplet
enum IncompleteEventType {
  /// Animal ajouté mais données incomplètes
  animal,

  /// Traitement en brouillon
  treatment,

  /// Naissance non finalisée
  birth,

  /// Pesée non validée
  weighing,

  /// Mouvement non finalisé
  movement,

  /// Lot en création
  batch,

  /// Mort non déclarée complètement
  death,

  /// Autre événement
  other,
}

/// Extension pour les propriétés visuelles
extension IncompleteEventTypeExtension on IncompleteEventType {
  /// Icône selon le type
  String get icon {
    switch (this) {
      case IncompleteEventType.animal:
        return '🐑';
      case IncompleteEventType.treatment:
        return '💉';
      case IncompleteEventType.birth:
        return '👶';
      case IncompleteEventType.weighing:
        return '⚖️';
      case IncompleteEventType.movement:
        return '🚚';
      case IncompleteEventType.batch:
        return '📦';
      case IncompleteEventType.death:
        return '💀';
      case IncompleteEventType.other:
        return '📋';
    }
  }

  /// Label en français
  String get labelFr {
    switch (this) {
      case IncompleteEventType.animal:
        return 'Animal';
      case IncompleteEventType.treatment:
        return 'Traitement';
      case IncompleteEventType.birth:
        return 'Naissance';
      case IncompleteEventType.weighing:
        return 'Pesée';
      case IncompleteEventType.movement:
        return 'Mouvement';
      case IncompleteEventType.batch:
        return 'Lot';
      case IncompleteEventType.death:
        return 'Mortalité';
      case IncompleteEventType.other:
        return 'Événement';
    }
  }
}

/// Événement non finalisé dans le registre
///
/// Représente une action commencée mais pas terminée par l'éleveur.
/// Après 3 jours, génère une alerte de type "Registre à mettre à jour".
class IncompleteEvent {
  /// Identifiant unique de l'événement
  final String id;

  /// Type d'événement
  final IncompleteEventType type;

  /// Date de création de l'événement
  final DateTime createdAt;

  /// Dernière modification
  final DateTime? updatedAt;

  /// ID de l'entité concernée
  final String? entityId;

  /// Nom/description de l'entité
  final String entityName;

  /// Ce qui manque pour finaliser (liste de champs)
  final List<String> missingFields;

  /// État de complétion (0.0 à 1.0)
  final double completionRate;

  /// Notes éventuelles
  final String? notes;

  IncompleteEvent({
    required this.id,
    required this.type,
    required this.createdAt,
    this.updatedAt,
    this.entityId,
    required this.entityName,
    required this.missingFields,
    required this.completionRate,
    this.notes,
  });

  /// Nombre de jours depuis la création
  int get daysOld {
    final diff = DateTime.now().difference(createdAt);
    return diff.inDays;
  }

  /// Événement nécessite une alerte (> 3 jours)
  bool get needsAlert {
    return daysOld >= 3;
  }

  /// Événement est ancien (> 7 jours)
  bool get isOld {
    return daysOld >= 7;
  }

  /// Message descriptif des champs manquants
  String get missingFieldsMessage {
    if (missingFields.isEmpty) return 'Aucun champ manquant';
    if (missingFields.length == 1) return missingFields.first;
    if (missingFields.length == 2) {
      return '${missingFields[0]} et ${missingFields[1]}';
    }
    return '${missingFields.length} champs manquants';
  }

  /// Constructeur : Animal incomplet
  factory IncompleteEvent.animal({
    required String animalId,
    required String animalName,
    required List<String> missingFields,
    required double completionRate,
    DateTime? createdAt,
  }) {
    return IncompleteEvent(
      id: 'incomplete_animal_$animalId',
      type: IncompleteEventType.animal,
      createdAt: createdAt ?? DateTime.now(),
      entityId: animalId,
      entityName: animalName,
      missingFields: missingFields,
      completionRate: completionRate,
    );
  }

  /// Constructeur : Traitement incomplet
  factory IncompleteEvent.treatment({
    required String treatmentId,
    required String animalName,
    required List<String> missingFields,
    DateTime? createdAt,
  }) {
    return IncompleteEvent(
      id: 'incomplete_treatment_$treatmentId',
      type: IncompleteEventType.treatment,
      createdAt: createdAt ?? DateTime.now(),
      entityId: treatmentId,
      entityName: animalName,
      missingFields: missingFields,
      completionRate: 1.0 - (missingFields.length / 5), // Estimation
    );
  }

  /// Constructeur : Naissance incomplète
  factory IncompleteEvent.birth({
    required String birthId,
    required String animalName,
    required List<String> missingFields,
    DateTime? createdAt,
  }) {
    return IncompleteEvent(
      id: 'incomplete_birth_$birthId',
      type: IncompleteEventType.birth,
      createdAt: createdAt ?? DateTime.now(),
      entityId: birthId,
      entityName: animalName,
      missingFields: missingFields,
      completionRate: 1.0 - (missingFields.length / 4),
    );
  }

  /// Copie avec modifications
  IncompleteEvent copyWith({
    String? id,
    IncompleteEventType? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? entityId,
    String? entityName,
    List<String>? missingFields,
    double? completionRate,
    String? notes,
  }) {
    return IncompleteEvent(
      id: id ?? this.id,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      entityId: entityId ?? this.entityId,
      entityName: entityName ?? this.entityName,
      missingFields: missingFields ?? this.missingFields,
      completionRate: completionRate ?? this.completionRate,
      notes: notes ?? this.notes,
    );
  }

  /// Conversion en Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'entityId': entityId,
      'entityName': entityName,
      'missingFields': missingFields,
      'completionRate': completionRate,
      'notes': notes,
    };
  }

  /// Création depuis Map
  factory IncompleteEvent.fromJson(Map<String, dynamic> json) {
    return IncompleteEvent(
      id: json['id'],
      type:
          IncompleteEventType.values.firstWhere((e) => e.name == json['type']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      entityId: json['entityId'],
      entityName: json['entityName'],
      missingFields: List<String>.from(json['missingFields']),
      completionRate: json['completionRate'],
      notes: json['notes'],
    );
  }

  @override
  String toString() {
    return 'IncompleteEvent(${type.labelFr}: $entityName, ${(completionRate * 100).toInt()}% complété)';
  }
}
