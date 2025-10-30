// data/mock_data.dart

import '../models/animal.dart';
import '../models/product.dart';
import '../models/treatment.dart';
import '../models/campaign.dart';
import '../models/movement.dart';
import '../models/batch.dart';
import '../models/weight_record.dart';
import '../models/veterinarian.dart';

/// Données de test (Mock Data) pour le développement et les tests
///
/// Contient des jeux de données réalistes pour :
/// - Animaux (44+ ovins)
/// - Produits sanitaires (10+)
/// - Vétérinaires (5)
/// - Lots (5+)
/// - Pesées (17+)
/// - Traitements (5+)
/// - Campagnes (4+)
/// - Mouvements (5+)
class MockData {
  // ==================== ANIMAUX ====================

  /// Générer une liste d'animaux de test
  static List<Animal> generateAnimals() {
    final now = DateTime.now();

    return [
      // Brebis reproductrices (15)
      Animal(
        id: 'animal_001',
        eid: '250001234567801',
        officialNumber: 'FR-2021-0001',
        birthDate: DateTime(2021, 3, 15),
        sex: AnimalSex.female,
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 1200)),
        updatedAt: now.subtract(const Duration(days: 10)),
      ),
      Animal(
        id: 'animal_002',
        eid: '250001234567802',
        officialNumber: 'FR-2021-0002',
        birthDate: DateTime(2021, 4, 20),
        sex: AnimalSex.female,
        motherId: null,
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 1180)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      Animal(
        id: 'animal_003',
        eid: '250001234567803',
        officialNumber: 'FR-2022-0003',
        birthDate: DateTime(2022, 2, 10),
        sex: AnimalSex.female,
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 900)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      Animal(
        id: 'animal_004',
        eid: '250001234567804',
        officialNumber: 'FR-2022-0004',
        birthDate: DateTime(2022, 3, 25),
        sex: AnimalSex.female,
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 850)),
        updatedAt: now,
      ),
      Animal(
        id: 'animal_005',
        eid: '250001234567805',
        officialNumber: 'FR-2023-0005',
        birthDate: DateTime(2023, 1, 15),
        sex: AnimalSex.female,
        motherId: 'animal_001',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 650)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),

      // Béliers (3)
      Animal(
        id: 'animal_006',
        eid: '250001234567806',
        officialNumber: 'FR-2020-0006',
        birthDate: DateTime(2020, 12, 5),
        sex: AnimalSex.male,
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 1500)),
        updatedAt: now.subtract(const Duration(days: 30)),
      ),
      Animal(
        id: 'animal_007',
        eid: '250001234567807',
        officialNumber: 'FR-2021-0007',
        birthDate: DateTime(2021, 11, 10),
        sex: AnimalSex.male,
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 1100)),
        updatedAt: now.subtract(const Duration(days: 15)),
      ),
      Animal(
        id: 'animal_008',
        eid: '250001234567808',
        officialNumber: 'FR-2022-0008',
        birthDate: DateTime(2022, 10, 20),
        sex: AnimalSex.male,
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 750)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),

      // Agneaux 2024 (10)
      Animal(
        id: 'animal_009',
        eid: '250001234567809',
        officialNumber: 'FR-2024-0009',
        birthDate: DateTime(2024, 2, 15),
        sex: AnimalSex.male,
        motherId: 'animal_001',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 250)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      Animal(
        id: 'animal_010',
        eid: '250001234567810',
        officialNumber: 'FR-2024-0010',
        birthDate: DateTime(2024, 2, 16),
        sex: AnimalSex.female,
        motherId: 'animal_001',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 249)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      Animal(
        id: 'animal_011',
        eid: '250001234567811',
        officialNumber: 'FR-2024-0011',
        birthDate: DateTime(2024, 3, 1),
        sex: AnimalSex.male,
        motherId: 'animal_002',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 235)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      Animal(
        id: 'animal_012',
        eid: '250001234567812',
        officialNumber: 'FR-2024-0012',
        birthDate: DateTime(2024, 3, 5),
        sex: AnimalSex.female,
        motherId: 'animal_003',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 231)),
        updatedAt: now,
      ),
      Animal(
        id: 'animal_013',
        eid: '250001234567813',
        officialNumber: 'FR-2024-0013',
        birthDate: DateTime(2024, 3, 10),
        sex: AnimalSex.male,
        motherId: 'animal_004',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 226)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),

      // Agneaux 2025 (5)
      Animal(
        id: 'animal_014',
        eid: '250001234567814',
        officialNumber: 'FR-2025-0014',
        birthDate: DateTime(2025, 1, 10),
        sex: AnimalSex.female,
        motherId: 'animal_005',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
      Animal(
        id: 'animal_015',
        eid: '250001234567815',
        officialNumber: 'FR-2025-0015',
        birthDate: DateTime(2025, 1, 15),
        sex: AnimalSex.male,
        motherId: 'animal_001',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now,
      ),
      Animal(
        id: 'animal_016',
        eid: '250001234567816',
        officialNumber: 'FR-2025-0016',
        birthDate: DateTime(2025, 2, 1),
        sex: AnimalSex.female,
        motherId: 'animal_002',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 8)),
        updatedAt: now,
      ),

      // Animaux vendus (2)
      Animal(
        id: 'animal_017',
        eid: '250001234567817',
        officialNumber: 'FR-2023-0017',
        birthDate: DateTime(2023, 11, 20),
        sex: AnimalSex.male,
        motherId: 'animal_003',
        status: AnimalStatus.sold,
        createdAt: now.subtract(const Duration(days: 340)),
        updatedAt: now.subtract(const Duration(days: 60)),
      ),
      Animal(
        id: 'animal_018',
        eid: '250001234567818',
        officialNumber: 'FR-2023-0018',
        birthDate: DateTime(2023, 12, 5),
        sex: AnimalSex.male,
        motherId: 'animal_004',
        status: AnimalStatus.sold,
        createdAt: now.subtract(const Duration(days: 325)),
        updatedAt: now.subtract(const Duration(days: 45)),
      ),

      // Animal mort (1)
      Animal(
        id: 'animal_019',
        eid: '250001234567819',
        officialNumber: 'FR-2024-0019',
        birthDate: DateTime(2024, 1, 10),
        sex: AnimalSex.male,
        motherId: 'animal_002',
        status: AnimalStatus.dead,
        createdAt: now.subtract(const Duration(days: 290)),
        updatedAt: now.subtract(const Duration(days: 120)),
      ),

      // Brebis supplémentaires (10 de plus pour avoir 20 brebis)
      Animal(
        id: 'animal_020',
        eid: '250001234567820',
        officialNumber: 'FR-2022-0020',
        birthDate: DateTime(2022, 5, 12),
        sex: AnimalSex.female,
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 820)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      Animal(
        id: 'animal_021',
        eid: '250001234567821',
        officialNumber: 'FR-2022-0021',
        birthDate: DateTime(2022, 6, 8),
        sex: AnimalSex.female,
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 793)),
        updatedAt: now.subtract(const Duration(days: 7)),
      ),
      Animal(
        id: 'animal_022',
        eid: '250001234567822',
        officialNumber: 'FR-2023-0022',
        birthDate: DateTime(2023, 2, 20),
        sex: AnimalSex.female,
        motherId: 'animal_001',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 615)),
        updatedAt: now.subtract(const Duration(days: 12)),
      ),
      Animal(
        id: 'animal_023',
        eid: '250001234567823',
        officialNumber: 'FR-2023-0023',
        birthDate: DateTime(2023, 3, 5),
        sex: AnimalSex.female,
        motherId: 'animal_002',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 602)),
        updatedAt: now.subtract(const Duration(days: 4)),
      ),
      Animal(
        id: 'animal_024',
        eid: '250001234567824',
        officialNumber: 'FR-2023-0024',
        birthDate: DateTime(2023, 4, 18),
        sex: AnimalSex.female,
        motherId: 'animal_003',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 558)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      Animal(
        id: 'animal_025',
        eid: '250001234567825',
        officialNumber: 'FR-2023-0025',
        birthDate: DateTime(2023, 5, 22),
        sex: AnimalSex.female,
        motherId: 'animal_004',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 524)),
        updatedAt: now,
      ),
      Animal(
        id: 'animal_026',
        eid: '250001234567826',
        officialNumber: 'FR-2023-0026',
        birthDate: DateTime(2023, 6, 10),
        sex: AnimalSex.female,
        motherId: 'animal_005',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 505)),
        updatedAt: now.subtract(const Duration(days: 8)),
      ),
      Animal(
        id: 'animal_027',
        eid: '250001234567827',
        officialNumber: 'FR-2023-0027',
        birthDate: DateTime(2023, 7, 3),
        sex: AnimalSex.female,
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 482)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      Animal(
        id: 'animal_028',
        eid: '250001234567828',
        officialNumber: 'FR-2023-0028',
        birthDate: DateTime(2023, 8, 15),
        sex: AnimalSex.female,
        motherId: 'animal_020',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 439)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      Animal(
        id: 'animal_029',
        eid: '250001234567829',
        officialNumber: 'FR-2023-0029',
        birthDate: DateTime(2023, 9, 20),
        sex: AnimalSex.female,
        motherId: 'animal_021',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 403)),
        updatedAt: now.subtract(const Duration(days: 6)),
      ),

      // Agneaux 2024 supplémentaires (15 de plus)
      Animal(
        id: 'animal_030',
        eid: '250001234567830',
        officialNumber: 'FR-2024-0030',
        birthDate: DateTime(2024, 3, 15),
        sex: AnimalSex.male,
        motherId: 'animal_020',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 221)),
        updatedAt: now.subtract(const Duration(days: 4)),
      ),
      Animal(
        id: 'animal_031',
        eid: '250001234567831',
        officialNumber: 'FR-2024-0031',
        birthDate: DateTime(2024, 3, 18),
        sex: AnimalSex.female,
        motherId: 'animal_021',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 218)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      Animal(
        id: 'animal_032',
        eid: '250001234567832',
        officialNumber: 'FR-2024-0032',
        birthDate: DateTime(2024, 3, 22),
        sex: AnimalSex.male,
        motherId: 'animal_022',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 214)),
        updatedAt: now,
      ),
      Animal(
        id: 'animal_033',
        eid: '250001234567833',
        officialNumber: 'FR-2024-0033',
        birthDate: DateTime(2024, 4, 1),
        sex: AnimalSex.female,
        motherId: 'animal_023',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 204)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      Animal(
        id: 'animal_034',
        eid: '250001234567834',
        officialNumber: 'FR-2024-0034',
        birthDate: DateTime(2024, 4, 5),
        sex: AnimalSex.male,
        motherId: 'animal_024',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 200)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      Animal(
        id: 'animal_035',
        eid: '250001234567835',
        officialNumber: 'FR-2024-0035',
        birthDate: DateTime(2024, 4, 10),
        sex: AnimalSex.female,
        motherId: 'animal_025',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 195)),
        updatedAt: now,
      ),
      Animal(
        id: 'animal_036',
        eid: '250001234567836',
        officialNumber: 'FR-2024-0036',
        birthDate: DateTime(2024, 4, 15),
        sex: AnimalSex.male,
        motherId: 'animal_026',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 190)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      Animal(
        id: 'animal_037',
        eid: '250001234567837',
        officialNumber: 'FR-2024-0037',
        birthDate: DateTime(2024, 4, 20),
        sex: AnimalSex.female,
        motherId: 'animal_027',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 185)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      Animal(
        id: 'animal_038',
        eid: '250001234567838',
        officialNumber: 'FR-2024-0038',
        birthDate: DateTime(2024, 4, 25),
        sex: AnimalSex.male,
        motherId: 'animal_028',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 180)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      Animal(
        id: 'animal_039',
        eid: '250001234567839',
        officialNumber: 'FR-2024-0039',
        birthDate: DateTime(2024, 5, 1),
        sex: AnimalSex.female,
        motherId: 'animal_029',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 174)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      Animal(
        id: 'animal_040',
        eid: '250001234567840',
        officialNumber: 'FR-2024-0040',
        birthDate: DateTime(2024, 5, 5),
        sex: AnimalSex.male,
        motherId: 'animal_001',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 170)),
        updatedAt: now,
      ),
      Animal(
        id: 'animal_041',
        eid: '250001234567841',
        officialNumber: 'FR-2024-0041',
        birthDate: DateTime(2024, 5, 10),
        sex: AnimalSex.female,
        motherId: 'animal_002',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 165)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      Animal(
        id: 'animal_042',
        eid: '250001234567842',
        officialNumber: 'FR-2024-0042',
        birthDate: DateTime(2024, 5, 15),
        sex: AnimalSex.male,
        motherId: 'animal_003',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 160)),
        updatedAt: now.subtract(const Duration(days: 4)),
      ),
      Animal(
        id: 'animal_043',
        eid: '250001234567843',
        officialNumber: 'FR-2024-0043',
        birthDate: DateTime(2024, 5, 20),
        sex: AnimalSex.female,
        motherId: 'animal_004',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 155)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      Animal(
        id: 'animal_044',
        eid: '250001234567844',
        officialNumber: 'FR-2024-0044',
        birthDate: DateTime(2024, 5, 25),
        sex: AnimalSex.male,
        motherId: 'animal_005',
        status: AnimalStatus.alive,
        createdAt: now.subtract(const Duration(days: 150)),
        updatedAt: now,
      ),
    ];
  }

  // ==================== PRODUITS ====================

  /// Générer des produits sanitaires de test (version simple)
  static List<Product> generateProducts() {
    return [
      // Antiparasitaires
      Product(
        id: 'product_001',
        name: 'Ivermectine 1%',
        activeSubstance: 'Ivermectine',
        withdrawalDaysMeat: 16,
        withdrawalDaysMilk: 5,
        dosagePerKg: 0.2,
      ),
      Product(
        id: 'product_008',
        name: 'Albendazole',
        activeSubstance: 'Albendazole',
        withdrawalDaysMeat: 14,
        withdrawalDaysMilk: 4,
        dosagePerKg: 5.0,
      ),

      // Vaccins
      Product(
        id: 'product_002',
        name: 'Vaccin Entérotoxémie',
        activeSubstance: 'Toxoïde',
        withdrawalDaysMeat: 0,
        withdrawalDaysMilk: 0,
        dosagePerKg: 2.0,
      ),
      Product(
        id: 'product_003',
        name: 'Vaccin Pasteurellose',
        activeSubstance: 'Vaccin inactivé',
        withdrawalDaysMeat: 0,
        withdrawalDaysMilk: 0,
        dosagePerKg: 2.0,
      ),

      // Antibiotiques
      Product(
        id: 'product_004',
        name: 'Amoxicilline LA',
        activeSubstance: 'Amoxicilline',
        withdrawalDaysMeat: 28,
        withdrawalDaysMilk: 3,
        dosagePerKg: 15.0,
      ),
      Product(
        id: 'product_005',
        name: 'Oxytétracycline',
        activeSubstance: 'Oxytétracycline',
        withdrawalDaysMeat: 21,
        withdrawalDaysMilk: 4,
        dosagePerKg: 20.0,
      ),

      // Anti-inflammatoires
      Product(
        id: 'product_006',
        name: 'Méloxicam',
        activeSubstance: 'Méloxicam',
        withdrawalDaysMeat: 5,
        withdrawalDaysMilk: 0,
        dosagePerKg: 0.5,
      ),

      // Vitamines
      Product(
        id: 'product_007',
        name: 'Complexe Vitaminé ADE',
        activeSubstance: 'Vitamines A, D, E',
        withdrawalDaysMeat: 0,
        withdrawalDaysMilk: 0,
        dosagePerKg: 1.0,
      ),

      // Autres
      Product(
        id: 'product_009',
        name: 'Solution Antiseptique',
        activeSubstance: 'Chlorhexidine',
        withdrawalDaysMeat: 0,
        withdrawalDaysMilk: 0,
        dosagePerKg: 0.0,
      ),
      Product(
        id: 'product_010',
        name: 'Poudre Cicatrisante',
        activeSubstance: 'Sulfate de cuivre',
        withdrawalDaysMeat: 0,
        withdrawalDaysMilk: 0,
        dosagePerKg: 0.0,
      ),
    ];
  }

  // ==================== PESÉES ====================

  /// Générer des pesées de test
  static List<WeightRecord> generateWeightRecords() {
    final now = DateTime.now();

    return [
      // Brebis animal_001 - suivi long terme
      WeightRecord(
        id: 'weight_001',
        animalId: 'animal_001',
        weight: 52.3,
        recordedAt: now.subtract(const Duration(days: 365)),
        source: WeightSource.scale,
        synced: true,
        createdAt: now.subtract(const Duration(days: 365)),
      ),
      WeightRecord(
        id: 'weight_002',
        animalId: 'animal_001',
        weight: 58.7,
        recordedAt: now.subtract(const Duration(days: 180)),
        source: WeightSource.scale,
        synced: true,
        createdAt: now.subtract(const Duration(days: 180)),
      ),
      WeightRecord(
        id: 'weight_003',
        animalId: 'animal_001',
        weight: 61.2,
        recordedAt: now.subtract(const Duration(days: 30)),
        source: WeightSource.manual,
        synced: false,
        createdAt: now.subtract(const Duration(days: 30)),
      ),

      // Agneau animal_009 - courbe de croissance
      WeightRecord(
        id: 'weight_004',
        animalId: 'animal_009',
        weight: 4.5,
        recordedAt: now.subtract(const Duration(days: 250)),
        source: WeightSource.veterinary,
        notes: 'Naissance',
        synced: true,
        createdAt: now.subtract(const Duration(days: 250)),
      ),
      WeightRecord(
        id: 'weight_005',
        animalId: 'animal_009',
        weight: 12.8,
        recordedAt: now.subtract(const Duration(days: 220)),
        source: WeightSource.manual,
        synced: true,
        createdAt: now.subtract(const Duration(days: 220)),
      ),
      WeightRecord(
        id: 'weight_006',
        animalId: 'animal_009',
        weight: 22.5,
        recordedAt: now.subtract(const Duration(days: 180)),
        source: WeightSource.scale,
        synced: true,
        createdAt: now.subtract(const Duration(days: 180)),
      ),
      WeightRecord(
        id: 'weight_007',
        animalId: 'animal_009',
        weight: 32.1,
        recordedAt: now.subtract(const Duration(days: 120)),
        source: WeightSource.scale,
        synced: true,
        createdAt: now.subtract(const Duration(days: 120)),
      ),
      WeightRecord(
        id: 'weight_008',
        animalId: 'animal_009',
        weight: 38.9,
        recordedAt: now.subtract(const Duration(days: 60)),
        source: WeightSource.scale,
        synced: true,
        createdAt: now.subtract(const Duration(days: 60)),
      ),
      WeightRecord(
        id: 'weight_009',
        animalId: 'animal_009',
        weight: 42.3,
        recordedAt: now.subtract(const Duration(days: 20)),
        source: WeightSource.manual,
        synced: false,
        createdAt: now.subtract(const Duration(days: 20)),
      ),

      // Agneau animal_014 - récent
      WeightRecord(
        id: 'weight_011',
        animalId: 'animal_014',
        weight: 4.2,
        recordedAt: now.subtract(const Duration(days: 30)),
        source: WeightSource.veterinary,
        notes: 'Naissance',
        synced: true,
        createdAt: now.subtract(const Duration(days: 30)),
      ),
      WeightRecord(
        id: 'weight_012',
        animalId: 'animal_014',
        weight: 8.7,
        recordedAt: now.subtract(const Duration(days: 5)),
        source: WeightSource.manual,
        notes: 'Bonne croissance',
        synced: false,
        createdAt: now.subtract(const Duration(days: 5)),
      ),

      // Bélier animal_006
      WeightRecord(
        id: 'weight_013',
        animalId: 'animal_006',
        weight: 85.5,
        recordedAt: now.subtract(const Duration(days: 90)),
        source: WeightSource.scale,
        synced: true,
        createdAt: now.subtract(const Duration(days: 90)),
      ),
      WeightRecord(
        id: 'weight_014',
        animalId: 'animal_006',
        weight: 88.2,
        recordedAt: now.subtract(const Duration(days: 15)),
        source: WeightSource.scale,
        synced: false,
        createdAt: now.subtract(const Duration(days: 15)),
      ),

      // Agneau animal_010
      WeightRecord(
        id: 'weight_015',
        animalId: 'animal_010',
        weight: 11.8,
        recordedAt: now.subtract(const Duration(days: 200)),
        source: WeightSource.manual,
        synced: true,
        createdAt: now.subtract(const Duration(days: 200)),
      ),
      WeightRecord(
        id: 'weight_016',
        animalId: 'animal_010',
        weight: 24.5,
        recordedAt: now.subtract(const Duration(days: 100)),
        source: WeightSource.scale,
        synced: true,
        createdAt: now.subtract(const Duration(days: 100)),
      ),
      WeightRecord(
        id: 'weight_017',
        animalId: 'animal_010',
        weight: 35.2,
        recordedAt: now.subtract(const Duration(days: 20)),
        source: WeightSource.estimated,
        notes: 'Estimation visuelle',
        synced: false,
        createdAt: now.subtract(const Duration(days: 20)),
      ),
    ];
  }

  // ==================== TRAITEMENTS (avec rémanence active) ====================

  /// Générer des traitements de test (certains avec rémanence active)
  static List<Treatment> generateTreatments() {
    final now = DateTime.now();

    return [
      // Traitement avec rémanence ACTIVE (animal_020)
      Treatment(
        id: 'treatment_001',
        animalId: 'animal_020',
        productId: 'product_001',
        productName: 'Ivermectine 1%',
        dose: 0.2,
        treatmentDate: now.subtract(const Duration(days: 5)),
        withdrawalEndDate:
            now.add(const Duration(days: 11)), // 16j - 5j = 11j restants
        veterinarianId: 'vet_001',
        veterinarianName: 'Dr. Sarah Dubois',
        campaignId: 'campaign_003',
        synced: true,
        createdAt: now.subtract(const Duration(days: 5)),
      ),

      // Traitement sans rémanence (vaccin)
      Treatment(
        id: 'treatment_002',
        animalId: 'animal_001',
        productId: 'product_002',
        productName: 'Vaccin Entérotoxémie',
        dose: 2.0,
        treatmentDate: now.subtract(const Duration(days: 180)),
        withdrawalEndDate: now.subtract(const Duration(days: 180)),
        veterinarianId: 'vet_003',
        veterinarianName: 'Dr. Claire Martin',
        campaignId: 'campaign_001',
        synced: true,
        createdAt: now.subtract(const Duration(days: 180)),
      ),

      // Traitement avec rémanence INACTIVE (passée)
      Treatment(
        id: 'treatment_003',
        animalId: 'animal_009',
        productId: 'product_008',
        productName: 'Albendazole',
        dose: 5.0,
        treatmentDate: now.subtract(const Duration(days: 60)),
        withdrawalEndDate: now.subtract(const Duration(days: 46)), // 14j passés
        veterinarianId: 'vet_001',
        veterinarianName: 'Dr. Sarah Dubois',
        campaignId: 'campaign_001',
        synced: true,
        createdAt: now.subtract(const Duration(days: 60)),
      ),

      // Traitement antibiotique récent
      Treatment(
        id: 'treatment_004',
        animalId: 'animal_014',
        productId: 'product_004',
        productName: 'Amoxicilline LA',
        dose: 15.0,
        treatmentDate: now.subtract(const Duration(days: 10)),
        withdrawalEndDate:
            now.add(const Duration(days: 18)), // 28j - 10j = 18j restants
        veterinarianId: 'vet_002',
        veterinarianName: 'Dr. Mohammed Alami',
        synced: true,
        createdAt: now.subtract(const Duration(days: 10)),
      ),

      // Traitement anti-inflammatoire
      Treatment(
        id: 'treatment_005',
        animalId: 'animal_006',
        productId: 'product_006',
        productName: 'Méloxicam',
        dose: 0.5,
        treatmentDate: now.subtract(const Duration(days: 3)),
        withdrawalEndDate:
            now.add(const Duration(days: 2)), // 5j - 3j = 2j restants
        veterinarianId: 'vet_001',
        veterinarianName: 'Dr. Sarah Dubois',
        synced: false,
        createdAt: now.subtract(const Duration(days: 3)),
      ),
    ];
  }

  // ==================== VÉTÉRINAIRES ====================

  /// Générer des vétérinaires de test
  static List<Veterinarian> generateVeterinarians() {
    final now = DateTime.now();

    return [
      Veterinarian(
        id: 'vet_001',
        firstName: 'Sarah',
        lastName: 'Dubois',
        title: 'Dr.',
        licenseNumber: 'VET-FR-2024-001',
        specialties: ['Ovins', 'Bovins'],
        clinic: 'Clinique Vétérinaire Rurale',
        phone: '+33612345678',
        mobile: '+33612345678',
        email: 'sarah.dubois@vet-rurale.fr',
        address: '12 Route de la Ferme',
        city: 'Sceaux',
        postalCode: '92330',
        country: 'France',
        isAvailable: true,
        emergencyService: true,
        workingHours: 'Lun-Ven: 8h-18h, Sam: 9h-12h',
        consultationFee: 65.0,
        emergencyFee: 120.0,
        currency: 'EUR',
        notes: 'Spécialiste en élevage ovin, très réactive',
        isPreferred: true,
        rating: 5,
        totalInterventions: 142,
        lastInterventionDate: now.subtract(const Duration(days: 5)),
        createdAt: now.subtract(const Duration(days: 730)),
        updatedAt: now.subtract(const Duration(days: 5)),
        isActive: true,
      ),
      Veterinarian(
        id: 'vet_002',
        firstName: 'Mohammed',
        lastName: 'Alami',
        title: 'Dr.',
        licenseNumber: 'VET-MA-2024-045',
        specialties: ['Petits ruminants', 'Reproduction'],
        clinic: 'Cabinet Vétérinaire Atlas',
        phone: '+33687654321',
        mobile: '+33687654321',
        email: 'm.alami@vet-atlas.fr',
        address: '45 Avenue des Champs',
        city: 'Paris',
        postalCode: '75015',
        country: 'France',
        isAvailable: true,
        emergencyService: false,
        workingHours: 'Lun-Ven: 9h-17h',
        consultationFee: 70.0,
        currency: 'EUR',
        notes: 'Expert en reproduction ovine',
        isPreferred: true,
        rating: 5,
        totalInterventions: 89,
        lastInterventionDate: now.subtract(const Duration(days: 15)),
        createdAt: now.subtract(const Duration(days: 600)),
        updatedAt: now.subtract(const Duration(days: 15)),
        isActive: true,
      ),
      Veterinarian(
        id: 'vet_003',
        firstName: 'Claire',
        lastName: 'Martin',
        title: 'Dr.',
        licenseNumber: 'VET-FR-2024-089',
        specialties: ['Médecine générale', 'Vaccination'],
        clinic: 'Clinique des Élevages',
        phone: '+33698765432',
        email: 'c.martin@clinique-elevages.fr',
        address: '78 Rue du Village',
        city: 'Versailles',
        postalCode: '78000',
        country: 'France',
        isAvailable: true,
        emergencyService: false,
        workingHours: 'Mar-Sam: 8h30-17h30',
        consultationFee: 60.0,
        currency: 'EUR',
        notes: 'Expérimentée en prophylaxie',
        isPreferred: false,
        rating: 4,
        totalInterventions: 56,
        lastInterventionDate: now.subtract(const Duration(days: 30)),
        createdAt: now.subtract(const Duration(days: 500)),
        updatedAt: now.subtract(const Duration(days: 30)),
        isActive: true,
      ),
      Veterinarian(
        id: 'vet_004',
        firstName: 'Fatima',
        lastName: 'Zahra',
        title: 'Dr.',
        licenseNumber: 'VET-MA-2024-112',
        specialties: ['Parasitologie', 'Nutrition'],
        clinic: 'Centre Vétérinaire Régional',
        phone: '+33612987654',
        mobile: '+33612987654',
        email: 'f.zahra@cvr.fr',
        address: '23 Boulevard du Progrès',
        city: 'Boulogne-Billancourt',
        postalCode: '92100',
        country: 'France',
        isAvailable: true,
        emergencyService: true,
        workingHours: '24h/24, 7j/7',
        consultationFee: 75.0,
        emergencyFee: 150.0,
        currency: 'EUR',
        notes: 'Service d\'urgence disponible',
        isPreferred: false,
        rating: 5,
        totalInterventions: 103,
        lastInterventionDate: now.subtract(const Duration(days: 8)),
        createdAt: now.subtract(const Duration(days: 450)),
        updatedAt: now.subtract(const Duration(days: 8)),
        isActive: true,
      ),
      Veterinarian(
        id: 'vet_005',
        firstName: 'Pierre',
        lastName: 'Lefebvre',
        title: 'Dr.',
        licenseNumber: 'VET-FR-2024-156',
        specialties: ['Chirurgie', 'Urgences'],
        clinic: 'Vétérinaire Itinérant',
        phone: '+33623456789',
        mobile: '+33623456789',
        email: 'p.lefebvre@vet-mobile.fr',
        city: 'Paris',
        country: 'France',
        isAvailable: true,
        emergencyService: true,
        workingHours: 'Sur rendez-vous',
        consultationFee: 80.0,
        emergencyFee: 160.0,
        currency: 'EUR',
        notes: 'Déplacements à domicile uniquement',
        isPreferred: false,
        rating: 4,
        totalInterventions: 34,
        lastInterventionDate: now.subtract(const Duration(days: 60)),
        createdAt: now.subtract(const Duration(days: 365)),
        updatedAt: now.subtract(const Duration(days: 60)),
        isActive: true,
      ),
    ];
  }

  // ==================== LOTS ====================

  /// Générer des lots de test
  static List<Batch> generateBatches() {
    final now = DateTime.now();

    return [
      Batch(
        id: 'batch_001',
        name: 'Vente Agneaux Novembre 2024',
        purpose: BatchPurpose.sale,
        animalIds: [
          'animal_009',
          'animal_010',
          'animal_011',
          'animal_012',
          'animal_013',
        ],
        createdAt: now.subtract(const Duration(days: 30)),
        completed: false,
        synced: true,
        notes: 'Lot préparé pour vente au marché',
      ),
      Batch(
        id: 'batch_002',
        name: 'Abattage Décembre 2024',
        purpose: BatchPurpose.slaughter,
        animalIds: [
          'animal_030',
          'animal_031',
          'animal_032',
        ],
        createdAt: now.subtract(const Duration(days: 15)),
        completed: false,
        synced: true,
        notes: 'Lot pour abattage fin d\'année',
      ),
      Batch(
        id: 'batch_003',
        name: 'Traitement vermifuge Octobre',
        purpose: BatchPurpose.treatment,
        animalIds: [
          'animal_001',
          'animal_002',
          'animal_003',
          'animal_004',
          'animal_005',
          'animal_020',
          'animal_021',
        ],
        createdAt: now.subtract(const Duration(days: 60)),
        usedAt: now.subtract(const Duration(days: 58)),
        completed: true,
        synced: true,
        notes: 'Vermifugation collective réussie',
      ),
      Batch(
        id: 'batch_004',
        name: 'Vente béliers reproducteurs',
        purpose: BatchPurpose.sale,
        animalIds: [
          'animal_006',
          'animal_007',
        ],
        createdAt: now.subtract(const Duration(days: 90)),
        usedAt: now.subtract(const Duration(days: 80)),
        completed: true,
        synced: true,
        notes: 'Vente réalisée avec succès',
      ),
      Batch(
        id: 'batch_005',
        name: 'Divers - Lot temporaire',
        purpose: BatchPurpose.other,
        animalIds: [
          'animal_014',
          'animal_015',
          'animal_016',
        ],
        createdAt: now.subtract(const Duration(days: 5)),
        completed: false,
        synced: false,
        notes: 'Lot temporaire pour suivi spécifique',
      ),
    ];
  }

  // ==================== CAMPAGNES ====================

  /// Générer des campagnes de test
  static List<Campaign> generateCampaigns() {
    final now = DateTime.now();

    return [
      Campaign(
        id: 'campaign_001',
        name: 'Vermifugation Printemps 2024',
        productId: 'product_008',
        productName: 'Albendazole',
        campaignDate: DateTime(2024, 3, 15),
        withdrawalEndDate: DateTime(2024, 3, 29), // 14 jours après
        veterinarianId: 'vet_001',
        veterinarianName: 'Dr. Sarah Dubois',
        animalIds: [
          'animal_001',
          'animal_002',
          'animal_003',
          'animal_004',
          'animal_005',
          'animal_006',
          'animal_007',
          'animal_008',
        ],
        completed: true,
        synced: true,
        createdAt: now.subtract(const Duration(days: 240)),
      ),
      Campaign(
        id: 'campaign_002',
        name: 'Vaccination Agneaux 2024',
        productId: 'product_002',
        productName: 'Vaccin Entérotoxémie',
        campaignDate: DateTime(2024, 4, 10),
        withdrawalEndDate: DateTime(2024, 4, 10), // Pas de délai pour vaccin
        veterinarianId: 'vet_003',
        veterinarianName: 'Dr. Claire Martin',
        animalIds: [
          'animal_009',
          'animal_010',
          'animal_011',
          'animal_012',
          'animal_013',
        ],
        completed: true,
        synced: true,
        createdAt: now.subtract(const Duration(days: 200)),
      ),
      Campaign(
        id: 'campaign_003',
        name: 'Traitement Parasitaire Octobre',
        productId: 'product_001',
        productName: 'Ivermectine 1%',
        campaignDate: now.subtract(const Duration(days: 30)),
        withdrawalEndDate:
            now.subtract(const Duration(days: 14)), // 16 jours après
        veterinarianId: 'vet_001',
        veterinarianName: 'Dr. Sarah Dubois',
        animalIds: [
          'animal_020',
          'animal_021',
          'animal_022',
          'animal_023',
          'animal_024',
        ],
        completed: true,
        synced: true,
        createdAt: now.subtract(const Duration(days: 32)),
      ),
      Campaign(
        id: 'campaign_004',
        name: 'Vaccination Pasteurellose 2025',
        productId: 'product_003',
        productName: 'Vaccin Pasteurellose',
        campaignDate: now.add(const Duration(days: 15)),
        withdrawalEndDate: now.add(const Duration(days: 15)), // Pas de délai
        veterinarianId: 'vet_002',
        veterinarianName: 'Dr. Mohammed Alami',
        animalIds: [
          'animal_014',
          'animal_015',
          'animal_016',
        ],
        completed: false,
        synced: false,
        createdAt: now.subtract(const Duration(days: 5)),
      ),
    ];
  }

  // ==================== MOUVEMENTS ====================

  /// Générer des mouvements de test
  static List<Movement> generateMovements() {
    final now = DateTime.now();

    return [
      // Naissances
      Movement(
        id: 'movement_001',
        type: MovementType.birth,
        animalId: 'animal_009',
        movementDate: DateTime(2024, 2, 15),
        synced: true,
        createdAt: now.subtract(const Duration(days: 250)),
      ),
      Movement(
        id: 'movement_002',
        type: MovementType.birth,
        animalId: 'animal_010',
        movementDate: DateTime(2024, 2, 16),
        synced: true,
        createdAt: now.subtract(const Duration(days: 249)),
      ),

      // Ventes
      Movement(
        id: 'movement_003',
        type: MovementType.sale,
        animalId: 'animal_017',
        movementDate: now.subtract(const Duration(days: 60)),
        price: 85.50,
        synced: true,
        createdAt: now.subtract(const Duration(days: 60)),
      ),
      Movement(
        id: 'movement_004',
        type: MovementType.sale,
        animalId: 'animal_018',
        movementDate: now.subtract(const Duration(days: 45)),
        price: 92.00,
        synced: true,
        createdAt: now.subtract(const Duration(days: 45)),
      ),

      // Mort
      Movement(
        id: 'movement_005',
        type: MovementType.death,
        animalId: 'animal_019',
        movementDate: now.subtract(const Duration(days: 120)),
        notes: 'Maladie',
        synced: true,
        createdAt: now.subtract(const Duration(days: 120)),
      ),
    ];
  }
}
