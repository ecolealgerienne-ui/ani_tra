// lib/models/batch.dart

/// Lot d'animaux pour actions groupées
///
/// Permet de regrouper des animaux pour des opérations de masse comme :
/// - Vente groupée
/// - Abattage groupé
/// - Traitement groupé
/// - Autres actions collectives
class Batch {
  /// Identifiant unique du lot
  final String id;

  /// Nom du lot (ex: "Abattage Novembre 2025")
  final String name;

  /// Objectif du lot
  final BatchPurpose purpose;

  /// Liste des IDs d'animaux dans le lot
  final List<String> animalIds;

  /// Date de création du lot
  final DateTime createdAt;

  /// Date d'utilisation du lot (vente, abattage, etc.)
  final DateTime? usedAt;

  /// Le lot est-il complété (action effectuée) ?
  final bool completed;

  /// État de synchronisation avec le serveur
  final bool synced;

  /// Notes optionnelles
  final String? notes;

  const Batch({
    required this.id,
    required this.name,
    required this.purpose,
    required this.animalIds,
    required this.createdAt,
    this.usedAt,
    this.completed = false,
    this.synced = false,
    this.notes,
  });

  // ==================== Getters de commodité ====================

  /// Nombre d'animaux dans le lot
  int get animalCount => animalIds.length;

  /// Le lot est-il vide ?
  bool get isEmpty => animalIds.isEmpty;

  /// Le lot contient-il des animaux ?
  bool get isNotEmpty => animalIds.isNotEmpty;

  /// Le lot est-il actif (non complété) ?
  bool get isActive => !completed;

  /// Âge du lot en jours
  int get ageInDays => DateTime.now().difference(createdAt).inDays;

  /// Le lot est-il récent (créé il y a moins de 7 jours) ?
  bool get isRecent => ageInDays <= 7;

  /// Date formatée de création
  String get formattedCreatedDate {
    final day = createdAt.day.toString().padLeft(2, '0');
    final month = createdAt.month.toString().padLeft(2, '0');
    final year = createdAt.year;
    return '$day/$month/$year';
  }

  /// Date formatée d'utilisation
  String? get formattedUsedDate {
    if (usedAt == null) return null;
    final day = usedAt!.day.toString().padLeft(2, '0');
    final month = usedAt!.month.toString().padLeft(2, '0');
    final year = usedAt!.year;
    return '$day/$month/$year';
  }

  /// Icône selon l'objectif
  String get purposeIcon {
    switch (purpose) {
      case BatchPurpose.sale:
        return '💰';
      case BatchPurpose.slaughter:
        return '🔪';
      case BatchPurpose.treatment:
        return '💉';
      case BatchPurpose.other:
        return '📦';
    }
  }

  /// Label de l'objectif en français
  String get purposeLabel {
    switch (purpose) {
      case BatchPurpose.sale:
        return 'Vente';
      case BatchPurpose.slaughter:
        return 'Abattage';
      case BatchPurpose.treatment:
        return 'Traitement';
      case BatchPurpose.other:
        return 'Autre';
    }
  }

  /// Couleur associée à l'objectif
  String get purposeColorHex {
    switch (purpose) {
      case BatchPurpose.sale:
        return '#4CAF50'; // Vert
      case BatchPurpose.slaughter:
        return '#F44336'; // Rouge
      case BatchPurpose.treatment:
        return '#2196F3'; // Bleu
      case BatchPurpose.other:
        return '#9E9E9E'; // Gris
    }
  }

  /// Statut du lot en français
  String get statusLabel {
    if (completed) return 'Complété';
    if (isEmpty) return 'Vide';
    return 'En cours';
  }

  /// Icône du statut
  String get statusIcon {
    if (completed) return '✅';
    if (isEmpty) return '📭';
    return '⏳';
  }

  // ==================== Méthodes ====================

  /// Vérifier si un animal est dans le lot
  bool containsAnimal(String animalId) {
    return animalIds.contains(animalId);
  }

  /// Créer une copie avec modifications
  Batch copyWith({
    String? id,
    String? name,
    BatchPurpose? purpose,
    List<String>? animalIds,
    DateTime? createdAt,
    DateTime? usedAt,
    bool? completed,
    bool? synced,
    String? notes,
  }) {
    return Batch(
      id: id ?? this.id,
      name: name ?? this.name,
      purpose: purpose ?? this.purpose,
      animalIds: animalIds ?? this.animalIds,
      createdAt: createdAt ?? this.createdAt,
      usedAt: usedAt ?? this.usedAt,
      completed: completed ?? this.completed,
      synced: synced ?? this.synced,
      notes: notes ?? this.notes,
    );
  }

  /// Marquer comme complété
  Batch markAsCompleted() {
    return copyWith(
      completed: true,
      usedAt: DateTime.now(),
      synced: false,
    );
  }

  /// Marquer comme synchronisé
  Batch markAsSynced() {
    return copyWith(synced: true);
  }

  /// Ajouter un animal au lot
  Batch addAnimal(String animalId) {
    if (containsAnimal(animalId)) {
      return this; // Déjà présent, pas de modification
    }

    return copyWith(
      animalIds: [...animalIds, animalId],
      synced: false,
    );
  }

  /// Retirer un animal du lot
  Batch removeAnimal(String animalId) {
    if (!containsAnimal(animalId)) {
      return this; // Pas présent, pas de modification
    }

    return copyWith(
      animalIds: animalIds.where((id) => id != animalId).toList(),
      synced: false,
    );
  }

  /// Ajouter plusieurs animaux au lot
  Batch addAnimals(List<String> newAnimalIds) {
    final updatedIds = [...animalIds];

    for (final id in newAnimalIds) {
      if (!updatedIds.contains(id)) {
        updatedIds.add(id);
      }
    }

    return copyWith(
      animalIds: updatedIds,
      synced: false,
    );
  }

  /// Retirer plusieurs animaux du lot
  Batch removeAnimals(List<String> animalIdsToRemove) {
    return copyWith(
      animalIds:
          animalIds.where((id) => !animalIdsToRemove.contains(id)).toList(),
      synced: false,
    );
  }

  /// Vider le lot (retirer tous les animaux)
  Batch clear() {
    return copyWith(
      animalIds: [],
      synced: false,
    );
  }

  // ==================== Sérialisation ====================

  /// Convertir en Map (pour base de données SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'purpose': purpose.toString().split('.').last,
      'animalIds': animalIds.join(','), // Liste séparée par virgules
      'createdAt': createdAt.toIso8601String(),
      'usedAt': usedAt?.toIso8601String(),
      'completed': completed ? 1 : 0,
      'synced': synced ? 1 : 0,
      'notes': notes,
    };
  }

  /// Créer depuis Map (depuis base de données SQLite)
  factory Batch.fromMap(Map<String, dynamic> map) {
    return Batch(
      id: map['id'] as String,
      name: map['name'] as String,
      purpose: BatchPurpose.values.firstWhere(
        (e) => e.toString().split('.').last == map['purpose'],
        orElse: () => BatchPurpose.other,
      ),
      animalIds: (map['animalIds'] as String).isNotEmpty
          ? (map['animalIds'] as String).split(',')
          : [],
      createdAt: DateTime.parse(map['createdAt'] as String),
      usedAt: map['usedAt'] != null
          ? DateTime.parse(map['usedAt'] as String)
          : null,
      completed: (map['completed'] as int) == 1,
      synced: (map['synced'] as int) == 1,
      notes: map['notes'] as String?,
    );
  }

  /// Convertir en JSON (pour API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'purpose': purpose.toString().split('.').last,
      'animal_ids': animalIds,
      'created_at': createdAt.toIso8601String(),
      'used_at': usedAt?.toIso8601String(),
      'completed': completed,
      'synced': synced,
      'notes': notes,
    };
  }

  /// Créer depuis JSON (depuis API)
  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      id: json['id'] as String,
      name: json['name'] as String,
      purpose: BatchPurpose.values.firstWhere(
        (e) => e.toString().split('.').last == json['purpose'],
        orElse: () => BatchPurpose.other,
      ),
      animalIds: (json['animal_ids'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      usedAt: json['used_at'] != null
          ? DateTime.parse(json['used_at'] as String)
          : null,
      completed: json['completed'] as bool? ?? false,
      synced: json['synced'] as bool? ?? false,
      notes: json['notes'] as String?,
    );
  }

  @override
  String toString() {
    return 'Batch(id: $id, name: $name, purpose: $purposeLabel, '
        'animals: $animalCount, completed: $completed, synced: $synced)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Batch && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Objectif d'un lot d'animaux
enum BatchPurpose {
  /// Vente groupée
  sale,

  /// Abattage groupé
  slaughter,

  /// Traitement groupé (vaccin, vermifuge, etc.)
  treatment,

  /// Autre objectif
  other,
}

/// Extensions pour BatchPurpose
extension BatchPurposeExtension on BatchPurpose {
  /// Nom en français
  String get frenchName {
    switch (this) {
      case BatchPurpose.sale:
        return 'Vente';
      case BatchPurpose.slaughter:
        return 'Abattage';
      case BatchPurpose.treatment:
        return 'Traitement';
      case BatchPurpose.other:
        return 'Autre';
    }
  }

  /// Icône
  String get icon {
    switch (this) {
      case BatchPurpose.sale:
        return '💰';
      case BatchPurpose.slaughter:
        return '🔪';
      case BatchPurpose.treatment:
        return '💉';
      case BatchPurpose.other:
        return '📦';
    }
  }

  /// Couleur hexadécimale
  String get colorHex {
    switch (this) {
      case BatchPurpose.sale:
        return '#4CAF50';
      case BatchPurpose.slaughter:
        return '#F44336';
      case BatchPurpose.treatment:
        return '#2196F3';
      case BatchPurpose.other:
        return '#9E9E9E';
    }
  }

  /// Description
  String get description {
    switch (this) {
      case BatchPurpose.sale:
        return 'Regrouper des animaux pour une vente groupée';
      case BatchPurpose.slaughter:
        return 'Regrouper des animaux pour un abattage groupé';
      case BatchPurpose.treatment:
        return 'Regrouper des animaux pour un traitement collectif';
      case BatchPurpose.other:
        return 'Regrouper des animaux pour une autre action';
    }
  }
}
