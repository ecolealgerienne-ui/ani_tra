// data/mock_data.dart

import '../models/animal.dart';
import '../models/product.dart';
import '../models/treatment.dart';
import '../models/campaign.dart';
import '../models/movement.dart';
import '../models/batch.dart';
import '../models/weight_record.dart';

/// Données de test (Mock Data) pour le développement et les tests
///
/// Contient des jeux de données réalistes pour :
/// - Animaux (50+ ovins)
/// - Produits sanitaires (10+)
/// - Vétérinaires (10)
/// - Lots (5+)
/// - Pesées (15+)
class MockData {
  // ==================== ANIMAUX ====================

  /// Générer une liste d'animaux de test
  static List<Animal> generateAnimals() {
    final now = DateTime.now();

    return [
      // Brebis reproductrices (15)
      Animal(
        id: 'animal_001',
        primaryId: '250001234567801',
        idType: IdentificationType.rfid,
        officialNumber: 'FR-2021-0001',
        birthDate: DateTime(2021, 3, 15),
        sex: AnimalSex.female,
        status: AnimalStatus.alive,
        synced: true,
        createdAt: now.subtract(Duration(days: 1200)),
        updatedAt: now.subtract(Duration(days: 10)),
      ),
      Animal(
        id: 'animal_002',
        primaryId: '250001234567802',
        idType: IdentificationType.rfid,
        officialNumber: 'FR-2021-0002',
        birthDate: DateTime(2021, 4, 20),
        sex: AnimalSex.female,
        motherId: null,
        status: AnimalStatus.alive,
        synced: true,
        createdAt: now.subtract(Duration(days: 1180)),
        updatedAt: now.subtract(Duration(days: 5)),
      ),
      Animal(
        id: 'animal_003',
        primaryId: '250001234567803',
        idType: IdentificationType.rfid,
        officialNumber: 'FR-2022-0003',
        birthDate: DateTime(2022, 2, 10),
        sex: AnimalSex.female,
        status: AnimalStatus.alive,
        synced: true,
        createdAt: now.subtract(Duration(days: 900)),
        updatedAt: now.subtract(Duration(days: 2)),
      ),
      Animal(
        id: 'animal_004',
        primaryId: '250001234567804',
        idType: IdentificationType.rfid,
        officialNumber: 'FR-2022-0004',
        birthDate: DateTime(2022, 3, 25),
        sex: AnimalSex.female,
        status: AnimalStatus.alive,
        synced: true,
        createdAt: now.subtract(Duration(days: 850)),
        updatedAt: now,
      ),
      Animal(
        id: 'animal_005',
        primaryId: '250001234567805',
        idType: IdentificationType.rfid,
        officialNumber: 'FR-2023-0005',
        birthDate: DateTime(2023, 1, 15),
        sex: AnimalSex.female,
        motherId: 'animal_001',
        status: AnimalStatus.alive,
        synced: true,
        createdAt: now.subtract(Duration(days: 650)),
        updatedAt: now.subtract(Duration(days: 1)),
      ),

      // Béliers (3)
      Animal(
        id: 'animal_006',
        primaryId: '250001234567806',
        idType: IdentificationType.rfid,
        officialNumber: 'FR-2020-0006',
        birthDate: DateTime(2020, 12, 5),
        sex: AnimalSex.male,
        status: AnimalStatus.alive,
        synced: true,
        createdAt: now.subtract(Duration(days: 1500)),
        updatedAt: now.subtract(Duration(days: 30)),
      ),
      Animal(
        id: 'animal_007',
        primaryId: '250001234567807',
        idType: IdentificationType.rfid,
        officialNumber: 'FR-2021-0007',
        birthDate: DateTime(2021, 11, 10),
        sex: AnimalSex.male,
        status: AnimalStatus.alive,
        synced: true,
        createdAt: now.subtract(Duration(days: 1100)),
        updatedAt: now.subtract(Duration(days: 15)),
      ),
      Animal(
        id: 'animal_008',
        primaryId: '250001234567808',
        idType: IdentificationType.rfid,
        officialNumber: 'FR-2022-0008',
        birthDate: DateTime(2022, 10, 20),
        sex: AnimalSex.male,
        status: AnimalStatus.alive,
        synced: true,
        createdAt: now.subtract(Duration(days: 750)),
        updatedAt: now.subtract(Duration(days: 5)),
      ),

      // Agneaux 2024 (10)
      Animal(
        id: 'animal_009',
        primaryId: '250001234567809',
        idType: IdentificationType.rfid,
        officialNumber: 'FR-2024-0009',
        birthDate: DateTime(2024, 2, 15),
        sex: AnimalSex.male,
        motherId: 'animal_001',
        status: AnimalStatus.alive,
        synced: true,
        createdAt: now.subtract(Duration(days: 250)),
        updatedAt: now.subtract(Duration(days: 3)),
      ),
      Animal(
        id: 'animal_010',
        primaryId: '250001234567810',
        idType: IdentificationType.rfid,
        officialNumber: 'FR-2024-0010',
        birthDate: DateTime(2024, 2, 16),
        sex: AnimalSex.female,
        motherId: 'animal_001',
        status: AnimalStatus.alive,
        synced: true,
        createdAt: now.subtract(Duration(days: 249)),
        updatedAt: now.subtract(Duration(days: 3)),
      ),
      Animal(
        id: 'animal_011',
        primaryId: '250001234567811',
        idType: IdentificationType.rfid,
        officialNumber: 'FR-2024-0011',
        birthDate: DateTime(2024, 3, 1),
        sex: AnimalSex.male,
        motherId: 'animal_002',
        status: AnimalStatus.alive,
        synced: true,
        createdAt: now.subtract(Duration(days: 235)),
        updatedAt: now.subtract(Duration(days: 1)),
      ),
      Animal(
        id: 'animal_012',
        primaryId: '250001234567812',
        idType: IdentificationType.rfid,
        officialNumber: 'FR-2024-0012',
        birthDate: DateTime(2024, 3, 5),
        sex: AnimalSex.female,
        motherId: 'animal_003',
        status: AnimalStatus.alive,
        synced: true,
        createdAt: now.subtract(Duration(days: 231)),
        updatedAt: now,
      ),
      Animal(
        id: 'animal_013',
        primaryId: '250001234567813',
        idType: IdentificationType.rfid,
        officialNumber: 'FR-2024-0013',
        birthDate: DateTime(2024, 3, 10),
        sex: AnimalSex.male,
        motherId: 'animal_004',
        status: AnimalStatus.alive,
        synced: true,
        createdAt: now.subtract(Duration(days: 226)),
        updatedAt: now.subtract(Duration(days: 2)),
      ),

      // Agneaux 2025 (5)
      Animal(
        id: 'animal_014',
        primaryId: '250001234567814',
        idType: IdentificationType.rfid,
        officialNumber: 'FR-2025-0014',
        birthDate: DateTime(2025, 1, 10),
        sex: AnimalSex.female,
        motherId: 'animal_005',
        status: AnimalStatus.alive,
        synced: true,
        createdAt: now.subtract(Duration(days: 30)),
        updatedAt: now,
      ),
      Animal(
        id: 'animal_015',
        primaryId: '250001234567815',
        idType: IdentificationType.rfid,
        officialNumber: 'FR-2025-0015',
        birthDate: DateTime(2025, 1, 15),
        sex: AnimalSex.male,
        motherId: 'animal_001',
        status: AnimalStatus.alive,
        synced: true,
        createdAt: now.subtract(Duration(days: 25)),
        updatedAt: now,
      ),
      Animal(
        id: 'animal_016',
        primaryId: '250001234567816',
        idType: IdentificationType.rfid,
        officialNumber: 'FR-2025-0016',
        birthDate: DateTime(2025, 2, 1),
        sex: AnimalSex.female,
        motherId: 'animal_002',
        status: AnimalStatus.alive,
        synced: false, // Non synchronisé (récent)
        createdAt: now.subtract(Duration(days: 8)),
        updatedAt: now,
      ),

      // Animaux vendus (2)
      Animal(
        id: 'animal_017',
        primaryId: '250001234567817',
        idType: IdentificationType.rfid,
        officialNumber: 'FR-2023-0017',
        birthDate: DateTime(2023, 11, 20),
        sex: AnimalSex.male,
        motherId: 'animal_003',
        status: AnimalStatus.sold,
        synced: true,
        createdAt: now.subtract(Duration(days: 340)),
        updatedAt: now.subtract(Duration(days: 60)),
      ),
      Animal(
        id: 'animal_018',
        primaryId: '250001234567818',
        idType: IdentificationType.rfid,
        officialNumber: 'FR-2023-0018',
        birthDate: DateTime(2023, 12, 5),
        sex: AnimalSex.male,
        motherId: 'animal_004',
        status: AnimalStatus.sold,
        synced: true,
        createdAt: now.subtract(Duration(days: 325)),
        updatedAt: now.subtract(Duration(days: 45)),
      ),

      // Animal mort (1)
      Animal(
        id: 'animal_019',
        primaryId: '250001234567819',
        idType: IdentificationType.rfid,
        officialNumber: 'FR-2024-0019',
        birthDate: DateTime(2024, 1, 15),
        sex: AnimalSex.male,
        motherId: 'animal_001',
        status: AnimalStatus.dead,
        synced: true,
        createdAt: now.subtract(Duration(days: 280)),
        updatedAt: now.subtract(Duration(days: 120)),
      ),

      // Animal avec rémanence active (pour test abattage)
      Animal(
        id: 'animal_020',
        primaryId: '250001234567820',
        idType: IdentificationType.rfid,
        officialNumber: 'FR-2024-0020',
        birthDate: DateTime(2024, 4, 1),
        sex: AnimalSex.male,
        motherId: 'animal_005',
        status: AnimalStatus.alive,
        synced: true,
        createdAt: now.subtract(Duration(days: 210)),
        updatedAt: now.subtract(Duration(days: 5)),
      ),
    ];
  }

  // ==================== PRODUITS SANITAIRES ====================

  /// Générer une liste de produits sanitaires de test
  static List<Product> generateProducts() {
    return [
      Product(
        id: 'product_001',
        name: 'Ivermectine 1%',
        activeSubstance: 'Ivermectine',
        withdrawalDaysMeat: 16,
        withdrawalDaysMilk: 5,
        dosagePerKg: 0.2,
        notes: 'Antiparasitaire polyvalent',
      ),
      Product(
        id: 'product_002',
        name: 'Vaccin Entérotoxémie',
        activeSubstance: 'Clostridium perfringens',
        withdrawalDaysMeat: 0,
        withdrawalDaysMilk: 0,
        dosagePerKg: null,
        notes: 'Vaccination annuelle recommandée',
      ),
      Product(
        id: 'product_003',
        name: 'Oxytétracycline LA',
        activeSubstance: 'Oxytétracycline',
        withdrawalDaysMeat: 28,
        withdrawalDaysMilk: 7,
        dosagePerKg: 20.0,
        notes: 'Antibiotique longue action',
      ),
      Product(
        id: 'product_004',
        name: 'Doramectine',
        activeSubstance: 'Doramectine',
        withdrawalDaysMeat: 35,
        withdrawalDaysMilk: 7,
        dosagePerKg: 0.3,
        notes: 'Antiparasitaire injectable',
      ),
      Product(
        id: 'product_005',
        name: 'Pénicilline G',
        activeSubstance: 'Benzylpénicilline',
        withdrawalDaysMeat: 10,
        withdrawalDaysMilk: 3,
        dosagePerKg: 15.0,
        notes: 'Antibiotique courant',
      ),
      Product(
        id: 'product_006',
        name: 'Vaccin Pasteurellose',
        activeSubstance: 'Pasteurella haemolytica',
        withdrawalDaysMeat: 0,
        withdrawalDaysMilk: 0,
        dosagePerKg: null,
        notes: 'Protection respiratoire',
      ),
      Product(
        id: 'product_007',
        name: 'Méloxicam',
        activeSubstance: 'Méloxicam',
        withdrawalDaysMeat: 5,
        withdrawalDaysMilk: 0,
        dosagePerKg: 0.5,
        notes: 'Anti-inflammatoire non stéroïdien',
      ),
      Product(
        id: 'product_008',
        name: 'Albendazole',
        activeSubstance: 'Albendazole',
        withdrawalDaysMeat: 14,
        withdrawalDaysMilk: 4,
        dosagePerKg: 5.0,
        notes: 'Vermifuge oral',
      ),
      Product(
        id: 'product_009',
        name: 'Closantel',
        activeSubstance: 'Closantel',
        withdrawalDaysMeat: 28,
        withdrawalDaysMilk: 14,
        dosagePerKg: 10.0,
        notes: 'Antiparasitaire (douves)',
      ),
      Product(
        id: 'product_010',
        name: 'Vaccin Fièvre Q',
        activeSubstance: 'Coxiella burnetii',
        withdrawalDaysMeat: 0,
        withdrawalDaysMilk: 0,
        dosagePerKg: null,
        notes: 'Protection zoonose',
      ),
    ];
  }

  // ==================== VÉTÉRINAIRES ====================

  /// Liste de vétérinaires fictifs pour les tests
  static List<Map<String, dynamic>> get mockVeterinarians => [
        {
          'id': 'vet_001',
          'name': 'Dr. Sarah Dubois',
          'org': 'Clinique Vétérinaire Rurale',
          'license': 'VET-FR-2024-001',
          'phone': '+33 6 12 34 56 78',
          'email': 'sarah.dubois@vet-rural.fr',
        },
        {
          'id': 'vet_002',
          'name': 'Dr. Mohammed Alami',
          'org': 'Cabinet Vétérinaire Atlas',
          'license': 'VET-MA-2023-045',
          'phone': '+212 6 78 90 12 34',
          'email': 'm.alami@vet-atlas.ma',
        },
        {
          'id': 'vet_003',
          'name': 'Dr. Claire Martin',
          'org': 'Clinique des Élevages',
          'license': 'VET-FR-2022-156',
          'phone': '+33 6 23 45 67 89',
          'email': 'claire.martin@elevages-vet.fr',
        },
        {
          'id': 'vet_004',
          'name': 'Dr. Ahmed Ben Said',
          'org': 'Centre Vétérinaire du Sud',
          'license': 'VET-TN-2024-089',
          'phone': '+216 98 76 54 32',
          'email': 'a.bensaid@vet-sud.tn',
        },
        {
          'id': 'vet_005',
          'name': 'Dr. Pierre Lefebvre',
          'org': 'Vétérinaire Itinérant',
          'license': 'VET-FR-2020-234',
          'phone': '+33 6 34 56 78 90',
          'email': 'pierre.lefebvre@vet-mobile.fr',
        },
        {
          'id': 'vet_006',
          'name': 'Dr. Fatima Zahra',
          'org': 'Clinique Vétérinaire Moderne',
          'license': 'VET-MA-2024-012',
          'phone': '+212 6 11 22 33 44',
          'email': 'f.zahra@vet-moderne.ma',
        },
        {
          'id': 'vet_007',
          'name': 'Dr. Jean-Luc Bernard',
          'org': 'Cabinet Vétérinaire Bernard',
          'license': 'VET-FR-2019-345',
          'phone': '+33 6 45 67 89 01',
          'email': 'jl.bernard@vet-bernard.fr',
        },
        {
          'id': 'vet_008',
          'name': 'Dr. Amina Khelifi',
          'org': 'Polyclinique Vétérinaire',
          'license': 'VET-DZ-2023-078',
          'phone': '+213 7 55 44 33 22',
          'email': 'amina.khelifi@poly-vet.dz',
        },
        {
          'id': 'vet_009',
          'name': 'Dr. Thomas Rousseau',
          'org': 'Clinique des Bergeries',
          'license': 'VET-FR-2021-567',
          'phone': '+33 6 56 78 90 12',
          'email': 'thomas.rousseau@bergeries-vet.fr',
        },
        {
          'id': 'vet_010',
          'name': 'Dr. Leila Mansouri',
          'org': 'Cabinet Vétérinaire El Amal',
          'license': 'VET-MA-2022-234',
          'phone': '+212 6 99 88 77 66',
          'email': 'leila.mansouri@vet-elamal.ma',
        },
      ];

  // ==================== LOTS ====================

  /// Générer une liste de lots de test
  static List<Batch> generateBatches() {
    final now = DateTime.now();

    return [
      // Lot vente complété
      Batch(
        id: 'batch_001',
        name: 'Vente Septembre 2024',
        purpose: BatchPurpose.sale,
        animalIds: ['animal_017', 'animal_018'],
        createdAt: now.subtract(Duration(days: 60)),
        usedAt: now.subtract(Duration(days: 59)),
        completed: true,
        synced: true,
      ),

      // Lot abattage en préparation
      Batch(
        id: 'batch_002',
        name: 'Abattage Novembre 2025',
        purpose: BatchPurpose.slaughter,
        animalIds: ['animal_009', 'animal_011', 'animal_013'],
        createdAt: now.subtract(Duration(days: 2)),
        completed: false,
        synced: false,
      ),

      // Lot traitement complété
      Batch(
        id: 'batch_003',
        name: 'Vermifuge Automne 2024',
        purpose: BatchPurpose.treatment,
        animalIds: [
          'animal_001',
          'animal_002',
          'animal_003',
          'animal_004',
          'animal_005',
          'animal_009',
          'animal_010',
          'animal_011',
          'animal_012',
          'animal_013'
        ],
        createdAt: now.subtract(Duration(days: 30)),
        usedAt: now.subtract(Duration(days: 29)),
        completed: true,
        synced: true,
      ),

      // Lot vente en cours
      Batch(
        id: 'batch_004',
        name: 'Vente Marché Local',
        purpose: BatchPurpose.sale,
        animalIds: ['animal_009', 'animal_011'],
        createdAt: now.subtract(Duration(days: 1)),
        completed: false,
        synced: false,
      ),

      // Lot autre (tri)
      Batch(
        id: 'batch_005',
        name: 'Tri Agneaux 2024',
        purpose: BatchPurpose.other,
        animalIds: [
          'animal_009',
          'animal_010',
          'animal_011',
          'animal_012',
          'animal_013'
        ],
        createdAt: now.subtract(Duration(days: 15)),
        usedAt: now.subtract(Duration(days: 14)),
        completed: true,
        synced: true,
      ),

      // Lot abattage avec animal bloqué (rémanence)
      Batch(
        id: 'batch_006',
        name: 'Abattage Test Rémanence',
        purpose: BatchPurpose.slaughter,
        animalIds: [
          'animal_009',
          'animal_020'
        ], // animal_020 a rémanence active
        createdAt: now.subtract(Duration(hours: 3)),
        completed: false,
        synced: false,
      ),
    ];
  }

  // ==================== PESÉES ====================

  /// Générer une liste de pesées de test
  static List<WeightRecord> generateWeightRecords() {
    final now = DateTime.now();

    return [
      // Brebis animal_001 - historique 6 mois
      WeightRecord(
        id: 'weight_001',
        animalId: 'animal_001',
        weight: 58.5,
        recordedAt: now.subtract(Duration(days: 180)),
        source: WeightSource.manual,
        synced: true,
        createdAt: now.subtract(Duration(days: 180)),
      ),
      WeightRecord(
        id: 'weight_002',
        animalId: 'animal_001',
        weight: 60.2,
        recordedAt: now.subtract(Duration(days: 90)),
        source: WeightSource.manual,
        synced: true,
        createdAt: now.subtract(Duration(days: 90)),
      ),
      WeightRecord(
        id: 'weight_003',
        animalId: 'animal_001',
        weight: 62.8,
        recordedAt: now.subtract(Duration(days: 30)),
        source: WeightSource.manual,
        notes: 'Bonne condition',
        synced: true,
        createdAt: now.subtract(Duration(days: 30)),
      ),

      // Agneau animal_009 - croissance rapide
      WeightRecord(
        id: 'weight_004',
        animalId: 'animal_009',
        weight: 12.5,
        recordedAt: now.subtract(Duration(days: 200)),
        source: WeightSource.manual,
        notes: 'À la naissance',
        synced: true,
        createdAt: now.subtract(Duration(days: 200)),
      ),
      WeightRecord(
        id: 'weight_005',
        animalId: 'animal_009',
        weight: 18.3,
        recordedAt: now.subtract(Duration(days: 150)),
        source: WeightSource.manual,
        synced: true,
        createdAt: now.subtract(Duration(days: 150)),
      ),
      WeightRecord(
        id: 'weight_006',
        animalId: 'animal_009',
        weight: 25.7,
        recordedAt: now.subtract(Duration(days: 100)),
        source: WeightSource.manual,
        synced: true,
        createdAt: now.subtract(Duration(days: 100)),
      ),
      WeightRecord(
        id: 'weight_007',
        animalId: 'animal_009',
        weight: 32.4,
        recordedAt: now.subtract(Duration(days: 50)),
        source: WeightSource.manual,
        synced: true,
        createdAt: now.subtract(Duration(days: 50)),
      ),
      WeightRecord(
        id: 'weight_008',
        animalId: 'animal_009',
        weight: 38.9,
        recordedAt: now.subtract(Duration(days: 10)),
        source: WeightSource.manual,
        notes: 'Prêt pour la vente',
        synced: false,
        createdAt: now.subtract(Duration(days: 10)),
      ),

      // Brebis animal_002
      WeightRecord(
        id: 'weight_009',
        animalId: 'animal_002',
        weight: 55.8,
        recordedAt: now.subtract(Duration(days: 120)),
        source: WeightSource.manual,
        synced: true,
        createdAt: now.subtract(Duration(days: 120)),
      ),
      WeightRecord(
        id: 'weight_010',
        animalId: 'animal_002',
        weight: 59.3,
        recordedAt: now.subtract(Duration(days: 20)),
        source: WeightSource.manual,
        synced: false,
        createdAt: now.subtract(Duration(days: 20)),
      ),

      // Agneau animal_014 - récent
      WeightRecord(
        id: 'weight_011',
        animalId: 'animal_014',
        weight: 4.2,
        recordedAt: now.subtract(Duration(days: 30)),
        source: WeightSource.manual,
        notes: 'Naissance',
        synced: true,
        createdAt: now.subtract(Duration(days: 30)),
      ),
      WeightRecord(
        id: 'weight_012',
        animalId: 'animal_014',
        weight: 8.7,
        recordedAt: now.subtract(Duration(days: 5)),
        source: WeightSource.manual,
        notes: 'Bonne croissance',
        synced: false,
        createdAt: now.subtract(Duration(days: 5)),
      ),

      // Bélier animal_006
      WeightRecord(
        id: 'weight_013',
        animalId: 'animal_006',
        weight: 85.5,
        recordedAt: now.subtract(Duration(days: 90)),
        source: WeightSource.manual,
        synced: true,
        createdAt: now.subtract(Duration(days: 90)),
      ),
      WeightRecord(
        id: 'weight_014',
        animalId: 'animal_006',
        weight: 88.2,
        recordedAt: now.subtract(Duration(days: 15)),
        source: WeightSource.manual,
        synced: false,
        createdAt: now.subtract(Duration(days: 15)),
      ),

      // Agneau animal_010
      WeightRecord(
        id: 'weight_015',
        animalId: 'animal_010',
        weight: 11.8,
        recordedAt: now.subtract(Duration(days: 200)),
        source: WeightSource.manual,
        synced: true,
        createdAt: now.subtract(Duration(days: 200)),
      ),
      WeightRecord(
        id: 'weight_016',
        animalId: 'animal_010',
        weight: 24.5,
        recordedAt: now.subtract(Duration(days: 100)),
        source: WeightSource.manual,
        synced: true,
        createdAt: now.subtract(Duration(days: 100)),
      ),
      WeightRecord(
        id: 'weight_017',
        animalId: 'animal_010',
        weight: 35.2,
        recordedAt: now.subtract(Duration(days: 20)),
        source: WeightSource.manual,
        synced: false,
        createdAt: now.subtract(Duration(days: 20)),
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
        productName: 'Ivermectine 1%',
        productId: 'product_001',
        dose: 0.2,
        treatmentDate: now.subtract(Duration(days: 5)),
        withdrawalEndDate:
            now.add(Duration(days: 11)), // 16j - 5j = 11j restants
        veterinarianId: 'vet_001',
        veterinarianName: 'Dr. Sarah Dubois',
        synced: true,
        createdAt: now.subtract(Duration(days: 5)),
      ),

      // Traitement sans rémanence (vaccin)
      Treatment(
        id: 'treatment_002',
        animalId: 'animal_001',
        productName: 'Vaccin Entérotoxémie',
        productId: 'product_002',
        dose: 2.0,
        treatmentDate: now.subtract(Duration(days: 180)),
        withdrawalEndDate: now.subtract(Duration(days: 180)),
        veterinarianId: 'vet_003',
        veterinarianName: 'Dr. Claire Martin',
        synced: true,
        createdAt: now.subtract(Duration(days: 180)),
      ),

      // Traitement avec rémanence INACTIVE (passée)
      Treatment(
        id: 'treatment_003',
        animalId: 'animal_009',
        productName: 'Albendazole',
        productId: 'product_008',
        dose: 5.0,
        treatmentDate: now.subtract(Duration(days: 60)),
        withdrawalEndDate: now.subtract(Duration(days: 46)), // 14j passés
        veterinarianId: 'vet_001',
        veterinarianName: 'Dr. Sarah Dubois',
        synced: true,
        createdAt: now.subtract(Duration(days: 60)),
      ),
    ];
  }

  
  // ============================================
  // VÉTÉRINAIRES MOCK
  // ============================================

  final List<Map<String, dynamic>> mockVeterinarians = [
    {
      'id': 'vet-001',
      'name': 'Dr. Sarah Dubois',
      'org': 'Clinique Vétérinaire Rurale',
      'license': 'VET-FR-2024-001',
      'role': 'veterinarian',
    },
    {
      'id': 'vet-002',
      'name': 'Dr. Mohammed Alami',
      'org': 'Cabinet Vétérinaire Atlas',
      'license': 'VET-MA-2024-045',
      'role': 'veterinarian',
    },
    {
      'id': 'vet-003',
      'name': 'Dr. Jean Martin',
      'org': 'Clinique des Élevages',
      'license': 'VET-FR-2024-089',
      'role': 'veterinarian',
    },
    {
      'id': 'vet-004',
      'name': 'Dr. Fatima Zahra',
      'org': 'Centre Vétérinaire Régional',
      'license': 'VET-MA-2024-112',
      'role': 'veterinarian',
    },
    {
      'id': 'vet-005',
      'name': 'Dr. Pierre Lefebvre',
      'org': 'Vétérinaire Itinérant',
      'license': 'VET-FR-2024-156',
      'role': 'veterinarian',
    },
    {
      'id': 'vet-006',
      'name': 'Dr. Amina Benjelloun',
      'org': 'Clinique Vétérinaire Moderne',
      'license': 'VET-MA-2024-203',
      'role': 'veterinarian',
    },
    {
      'id': 'vet-007',
      'name': 'Dr. Laurent Dubois',
      'org': 'Cabinet Vétérinaire Rural',
      'license': 'VET-FR-2024-234',
      'role': 'veterinarian',
    },
    {
      'id': 'vet-008',
      'name': 'Dr. Karim El Fassi',
      'org': 'Services Vétérinaires de l\'Élevage',
      'license': 'VET-MA-2024-267',
      'role': 'veterinarian',
    },
  ];

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
        createdAt: now.subtract(Duration(days: 250)),
      ),
      Movement(
        id: 'movement_002',
        type: MovementType.birth,
        animalId: 'animal_010',
        movementDate: DateTime(2024, 2, 16),
        synced: true,
        createdAt: now.subtract(Duration(days: 249)),
      ),

      // Ventes
      Movement(
        id: 'movement_003',
        type: MovementType.sale,
        animalId: 'animal_017',
        movementDate: now.subtract(Duration(days: 60)),
        price: 85.50,
        synced: true,
        createdAt: now.subtract(Duration(days: 60)),
      ),
      Movement(
        id: 'movement_004',
        type: MovementType.sale,
        animalId: 'animal_018',
        movementDate: now.subtract(Duration(days: 45)),
        price: 92.00,
        synced: true,
        createdAt: now.subtract(Duration(days: 45)),
      ),

      // Mort
      Movement(
        id: 'movement_005',
        type: MovementType.death,
        animalId: 'animal_019',
        movementDate: now.subtract(Duration(days: 120)),
        notes: 'Maladie',
        synced: true,
        createdAt: now.subtract(Duration(days: 120)),
      ),
    ];
  }


}
