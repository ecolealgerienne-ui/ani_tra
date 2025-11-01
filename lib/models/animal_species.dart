// lib/models/animal_species.dart

/// Type/espèce d'animal d'élevage
///
/// Représente les différents types d'animaux gérés dans l'application.
/// Utilisé pour catégoriser et filtrer les animaux.
class AnimalSpecies {
  /// Identifiant unique du type
  final String id;

  /// Nom en français
  final String nameFr;

  /// Nom en anglais
  final String nameEn;

  /// Nom en arabe
  final String nameAr;

  /// Icône représentant le type
  final String icon;

  /// Ordre d'affichage
  final int displayOrder;

  const AnimalSpecies({
    required this.id,
    required this.nameFr,
    required this.nameEn,
    required this.nameAr,
    required this.icon,
    this.displayOrder = 0,
  });

  /// Obtenir le nom selon la locale
  String getName(String locale) {
    switch (locale) {
      case 'fr':
        return nameFr;
      case 'en':
        return nameEn;
      case 'ar':
        return nameAr;
      default:
        return nameFr;
    }
  }

  // ==================== CONVERSIONS ====================

  /// Convertir en Map (pour SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name_fr': nameFr,
      'name_en': nameEn,
      'name_ar': nameAr,
      'icon': icon,
      'display_order': displayOrder,
    };
  }

  /// Créer depuis Map (depuis SQLite)
  factory AnimalSpecies.fromMap(Map<String, dynamic> map) {
    return AnimalSpecies(
      id: map['id'] as String,
      nameFr: map['name_fr'] as String,
      nameEn: map['name_en'] as String,
      nameAr: map['name_ar'] as String,
      icon: map['icon'] as String,
      displayOrder: map['display_order'] as int? ?? 0,
    );
  }

  /// Convertir en JSON (pour API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_fr': nameFr,
      'name_en': nameEn,
      'name_ar': nameAr,
      'icon': icon,
      'display_order': displayOrder,
    };
  }

  /// Créer depuis JSON (depuis API)
  factory AnimalSpecies.fromJson(Map<String, dynamic> json) {
    return AnimalSpecies(
      id: json['id'] as String,
      nameFr: json['name_fr'] as String,
      nameEn: json['name_en'] as String,
      nameAr: json['name_ar'] as String,
      icon: json['icon'] as String,
      displayOrder: json['display_order'] as int? ?? 0,
    );
  }

  @override
  String toString() => 'AnimalSpecies(id: $id, nameFr: $nameFr)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnimalSpecies && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  /// Créer une copie avec modifications
  AnimalSpecies copyWith({
    String? id,
    String? nameFr,
    String? nameEn,
    String? nameAr,
    String? icon,
    int? displayOrder,
  }) {
    return AnimalSpecies(
      id: id ?? this.id,
      nameFr: nameFr ?? this.nameFr,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      icon: icon ?? this.icon,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }
}

// ==================== TYPES PRÉDÉFINIS ====================

/// Types d'animaux couramment utilisés
class CommonAnimalSpecies {
  /// Bovin (vache, taureau)
  static const cattle = AnimalSpecies(
    id: 'cattle',
    nameFr: 'Bovin',
    nameEn: 'Cattle',
    nameAr: 'أبقار',
    icon: '🐄',
    displayOrder: 1,
  );

  /// Ovin (mouton, brebis)
  static const sheep = AnimalSpecies(
    id: 'sheep',
    nameFr: 'Ovin',
    nameEn: 'Sheep',
    nameAr: 'أغنام',
    icon: '🐑',
    displayOrder: 2,
  );

  /// Caprin (chèvre, bouc)
  static const goat = AnimalSpecies(
    id: 'goat',
    nameFr: 'Caprin',
    nameEn: 'Goat',
    nameAr: 'ماعز',
    icon: '🐐',
    displayOrder: 3,
  );

  /// Liste de tous les types prédéfinis
  static const List<AnimalSpecies> all = [
    cattle,
    sheep,
    goat,
  ];

  /// Obtenir un type par ID
  static AnimalSpecies? getById(String id) {
    try {
      return all.firstWhere((species) => species.id == id);
    } catch (e) {
      return null;
    }
  }
}
