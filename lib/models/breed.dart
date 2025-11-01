// lib/models/breed.dart

/// Race d'animal
///
/// Représente une race spécifique d'un type d'animal.
/// Chaque race est associée à un type d'animal (species).
class Breed {
  /// Identifiant unique de la race
  final String id;

  /// Identifiant du type d'animal (species)
  final String speciesId;

  /// Nom en français
  final String nameFr;

  /// Nom en anglais
  final String nameEn;

  /// Nom en arabe
  final String nameAr;

  /// Description optionnelle
  final String? description;

  /// Ordre d'affichage
  final int displayOrder;

  /// Race active/disponible
  final bool isActive;

  const Breed({
    required this.id,
    required this.speciesId,
    required this.nameFr,
    required this.nameEn,
    required this.nameAr,
    this.description,
    this.displayOrder = 0,
    this.isActive = true,
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
      'species_id': speciesId,
      'name_fr': nameFr,
      'name_en': nameEn,
      'name_ar': nameAr,
      'description': description,
      'display_order': displayOrder,
      'is_active': isActive ? 1 : 0,
    };
  }

  /// Créer depuis Map (depuis SQLite)
  factory Breed.fromMap(Map<String, dynamic> map) {
    return Breed(
      id: map['id'] as String,
      speciesId: map['species_id'] as String,
      nameFr: map['name_fr'] as String,
      nameEn: map['name_en'] as String,
      nameAr: map['name_ar'] as String,
      description: map['description'] as String?,
      displayOrder: map['display_order'] as int? ?? 0,
      isActive: (map['is_active'] as int?) == 1,
    );
  }

  /// Convertir en JSON (pour API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'species_id': speciesId,
      'name_fr': nameFr,
      'name_en': nameEn,
      'name_ar': nameAr,
      'description': description,
      'display_order': displayOrder,
      'is_active': isActive,
    };
  }

  /// Créer depuis JSON (depuis API)
  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
      id: json['id'] as String,
      speciesId: json['species_id'] as String,
      nameFr: json['name_fr'] as String,
      nameEn: json['name_en'] as String,
      nameAr: json['name_ar'] as String,
      description: json['description'] as String?,
      displayOrder: json['display_order'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  @override
  String toString() => 'Breed(id: $id, nameFr: $nameFr, speciesId: $speciesId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Breed && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  /// Créer une copie avec modifications
  Breed copyWith({
    String? id,
    String? speciesId,
    String? nameFr,
    String? nameEn,
    String? nameAr,
    String? description,
    int? displayOrder,
    bool? isActive,
  }) {
    return Breed(
      id: id ?? this.id,
      speciesId: speciesId ?? this.speciesId,
      nameFr: nameFr ?? this.nameFr,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      displayOrder: displayOrder ?? this.displayOrder,
      isActive: isActive ?? this.isActive,
    );
  }
}
