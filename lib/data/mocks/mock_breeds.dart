// lib/data/mocks/mock_breeds.dart

import '../../models/breed.dart';

/// Données de test pour les races d'animaux
///
/// Contient les races les plus courantes pour chaque type d'animal.
/// Cette liste est paramétrable et peut être facilement modifiée.
class MockBreeds {
  // ==================== RACES BOVINES ====================

  static const List<Breed> cattleBreeds = [
    Breed(
      id: 'charolaise',
      speciesId: 'cattle',
      nameFr: 'Charolaise',
      nameEn: 'Charolais',
      nameAr: 'شارولي',
      description: 'Race française de grande taille, excellente pour la viande',
      displayOrder: 1,
    ),
    Breed(
      id: 'limousine',
      speciesId: 'cattle',
      nameFr: 'Limousine',
      nameEn: 'Limousin',
      nameAr: 'ليموزين',
      description: 'Race française rustique, viande de qualité',
      displayOrder: 2,
    ),
    Breed(
      id: 'holstein',
      speciesId: 'cattle',
      nameFr: 'Holstein',
      nameEn: 'Holstein',
      nameAr: 'هولشتاين',
      description: 'Race laitière, production élevée',
      displayOrder: 3,
    ),
    Breed(
      id: 'montbeliarde',
      speciesId: 'cattle',
      nameFr: 'Montbéliarde',
      nameEn: 'Montbéliarde',
      nameAr: 'مونبيليارد',
      description: 'Race mixte lait et viande',
      displayOrder: 4,
    ),
    Breed(
      id: 'blonde_aquitaine',
      speciesId: 'cattle',
      nameFr: 'Blonde d\'Aquitaine',
      nameEn: 'Blonde d\'Aquitaine',
      nameAr: 'بلوند داكيتين',
      description: 'Race à viande, croissance rapide',
      displayOrder: 5,
    ),
    Breed(
      id: 'aubrac',
      speciesId: 'cattle',
      nameFr: 'Aubrac',
      nameEn: 'Aubrac',
      nameAr: 'أوبراك',
      description: 'Race rustique de montagne',
      displayOrder: 6,
    ),
    Breed(
      id: 'salers',
      speciesId: 'cattle',
      nameFr: 'Salers',
      nameEn: 'Salers',
      nameAr: 'سالير',
      description: 'Race allaitante rustique',
      displayOrder: 7,
    ),
    Breed(
      id: 'normande',
      speciesId: 'cattle',
      nameFr: 'Normande',
      nameEn: 'Normande',
      nameAr: 'نورماندي',
      description: 'Race mixte, bonne laitière',
      displayOrder: 8,
    ),
    Breed(
      id: 'simmental',
      speciesId: 'cattle',
      nameFr: 'Simmental',
      nameEn: 'Simmental',
      nameAr: 'سيمنتال',
      description: 'Race suisse polyvalente',
      displayOrder: 9,
    ),
    Breed(
      id: 'angus',
      speciesId: 'cattle',
      nameFr: 'Angus',
      nameEn: 'Angus',
      nameAr: 'أنغوس',
      description: 'Race écossaise, viande marbrée',
      displayOrder: 10,
    ),
  ];

  // ==================== RACES OVINES ====================

  static const List<Breed> sheepBreeds = [
    Breed(
      id: 'merinos',
      speciesId: 'sheep',
      nameFr: 'Mérinos',
      nameEn: 'Merino',
      nameAr: 'ميرينو',
      description: 'Laine fine de grande qualité',
      displayOrder: 1,
    ),
    Breed(
      id: 'suffolk',
      speciesId: 'sheep',
      nameFr: 'Suffolk',
      nameEn: 'Suffolk',
      nameAr: 'سوفولك',
      description: 'Race anglaise, bonne conformation',
      displayOrder: 2,
    ),
    Breed(
      id: 'lacaune',
      speciesId: 'sheep',
      nameFr: 'Lacaune',
      nameEn: 'Lacaune',
      nameAr: 'لاكون',
      description: 'Race française laitière, Roquefort',
      displayOrder: 3,
    ),
    Breed(
      id: 'ile_de_france',
      speciesId: 'sheep',
      nameFr: 'Ile-de-France',
      nameEn: 'Ile-de-France',
      nameAr: 'إيل دو فرانس',
      description: 'Race française polyvalente',
      displayOrder: 4,
    ),
    Breed(
      id: 'texel',
      speciesId: 'sheep',
      nameFr: 'Texel',
      nameEn: 'Texel',
      nameAr: 'تيكسل',
      description: 'Race néerlandaise, viande maigre',
      displayOrder: 5,
    ),
    Breed(
      id: 'berrichon',
      speciesId: 'sheep',
      nameFr: 'Berrichon du Cher',
      nameEn: 'Berrichon du Cher',
      nameAr: 'بيريشون دو شير',
      description: 'Race française précoce',
      displayOrder: 6,
    ),
    Breed(
      id: 'ouled_djellal',
      speciesId: 'sheep',
      nameFr: 'Ouled Djellal',
      nameEn: 'Ouled Djellal',
      nameAr: 'أولاد جلال',
      description: 'Race algérienne rustique, bonne viande',
      displayOrder: 7,
    ),
    Breed(
      id: 'rembi',
      speciesId: 'sheep',
      nameFr: 'Rembi',
      nameEn: 'Rembi',
      nameAr: 'الرمبي',
      description: 'Race algérienne, laine et viande',
      displayOrder: 8,
    ),
    Breed(
      id: 'dorper',
      speciesId: 'sheep',
      nameFr: 'Dorper',
      nameEn: 'Dorper',
      nameAr: 'دوربر',
      description: 'Race sud-africaine sans laine',
      displayOrder: 9,
    ),
    Breed(
      id: 'hampshire',
      speciesId: 'sheep',
      nameFr: 'Hampshire',
      nameEn: 'Hampshire',
      nameAr: 'هامبشاير',
      description: 'Race anglaise, bonne viande',
      displayOrder: 10,
    ),
  ];

  // ==================== RACES CAPRINES ====================

  static const List<Breed> goatBreeds = [
    Breed(
      id: 'alpine',
      speciesId: 'goat',
      nameFr: 'Alpine',
      nameEn: 'Alpine',
      nameAr: 'ألبين',
      description: 'Race française laitière',
      displayOrder: 1,
    ),
    Breed(
      id: 'saanen',
      speciesId: 'goat',
      nameFr: 'Saanen',
      nameEn: 'Saanen',
      nameAr: 'سانين',
      description: 'Race suisse, grande productrice de lait',
      displayOrder: 2,
    ),
    Breed(
      id: 'anglo_nubienne',
      speciesId: 'goat',
      nameFr: 'Anglo-Nubienne',
      nameEn: 'Anglo-Nubian',
      nameAr: 'أنجلو نوبيان',
      description: 'Race mixte, lait riche en matières grasses',
      displayOrder: 3,
    ),
    Breed(
      id: 'poitevine',
      speciesId: 'goat',
      nameFr: 'Poitevine',
      nameEn: 'Poitevine',
      nameAr: 'بواتفين',
      description: 'Race française laitière',
      displayOrder: 4,
    ),
    Breed(
      id: 'chevre_rove',
      speciesId: 'goat',
      nameFr: 'Chèvre de Rove',
      nameEn: 'Rove Goat',
      nameAr: 'ماعز روف',
      description: 'Race française rustique, broutard',
      displayOrder: 5,
    ),
    Breed(
      id: 'chevre_malte',
      speciesId: 'goat',
      nameFr: 'Chèvre de Malte',
      nameEn: 'Maltese Goat',
      nameAr: 'ماعز مالطي',
      description: 'Race méditerranéenne',
      displayOrder: 6,
    ),
    Breed(
      id: 'chevre_arabe',
      speciesId: 'goat',
      nameFr: 'Chèvre Arabe',
      nameEn: 'Arabian Goat',
      nameAr: 'ماعز عربي',
      description: 'Race locale rustique',
      displayOrder: 7,
    ),
    Breed(
      id: 'toggenburg',
      speciesId: 'goat',
      nameFr: 'Toggenburg',
      nameEn: 'Toggenburg',
      nameAr: 'توغنبورغ',
      description: 'Race suisse laitière',
      displayOrder: 8,
    ),
  ];

  // ==================== MÉTHODES UTILITAIRES ====================

  /// Obtenir toutes les races
  static List<Breed> getAllBreeds() {
    return [
      ...cattleBreeds,
      ...sheepBreeds,
      ...goatBreeds,
    ];
  }

  /// Obtenir les races par type d'animal
  static List<Breed> getBreedsBySpecies(String speciesId) {
    switch (speciesId) {
      case 'cattle':
        return cattleBreeds;
      case 'sheep':
        return sheepBreeds;
      case 'goat':
        return goatBreeds;
      default:
        return [];
    }
  }

  /// Obtenir une race par ID
  static Breed? getBreedById(String breedId) {
    try {
      return getAllBreeds().firstWhere((breed) => breed.id == breedId);
    } catch (e) {
      return null;
    }
  }

  /// Vérifier si une race existe
  static bool breedExists(String breedId) {
    return getAllBreeds().any((breed) => breed.id == breedId);
  }
}
