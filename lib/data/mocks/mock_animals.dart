// lib/data/mocks/mock_animals.dart

import '../../models/animal.dart';
import '../../models/eid_change.dart';

/// Données de test pour les animaux
class MockAnimals {
  static List<Animal> generateAnimals() {
    final now = DateTime.now();

    return [
      // ==================== BREBIS REPRODUCTRICES (5) ====================
      Animal(
        id: 'animal_001',
        currentEid: '250001234567801',
        officialNumber: 'FR-2021-0001',
        birthDate: DateTime(2021, 3, 15),
        sex: AnimalSex.female,
        status: AnimalStatus.alive,
        speciesId: 'sheep',
        breedId: 'merinos',
        createdAt: now.subtract(const Duration(days: 1200)),
        updatedAt: now.subtract(const Duration(days: 10)),
      ),

      Animal(
        id: 'animal_002',
        currentEid: '250001234567802',
        officialNumber: 'FR-2021-0002',
        birthDate: DateTime(2021, 4, 20),
        sex: AnimalSex.female,
        status: AnimalStatus.alive,
        speciesId: 'sheep',
        breedId: 'suffolk',
        createdAt: now.subtract(const Duration(days: 1180)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),

      Animal(
        id: 'animal_003',
        currentEid: '250001234567803',
        officialNumber: 'FR-2022-0003',
        birthDate: DateTime(2022, 2, 10),
        sex: AnimalSex.female,
        status: AnimalStatus.alive,
        speciesId: 'sheep',
        breedId: 'lacaune',
        // EXEMPLE : Animal avec historique de changement d'EID
        eidHistory: [
          EidChange(
            id: 'eid_change_001',
            oldEid: '250001234567777',
            newEid: '250001234567803',
            changedAt: DateTime(2023, 6, 15, 14, 30),
            reason: EidChangeReason.puceCassee,
            notes: 'Puce cassée trouvée lors du scan de routine',
          ),
        ],
        createdAt: now.subtract(const Duration(days: 900)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),

      Animal(
        id: 'animal_004',
        currentEid: '250001234567804',
        officialNumber: 'FR-2022-0004',
        birthDate: DateTime(2022, 3, 25),
        sex: AnimalSex.female,
        status: AnimalStatus.alive,
        speciesId: 'sheep',
        breedId: 'ile_de_france',
        createdAt: now.subtract(const Duration(days: 850)),
        updatedAt: now,
      ),

      Animal(
        id: 'animal_005',
        currentEid: '250001234567805',
        officialNumber: 'FR-2023-0005',
        birthDate: DateTime(2023, 1, 15),
        sex: AnimalSex.female,
        motherId: 'animal_001',
        status: AnimalStatus.alive,
        speciesId: 'sheep',
        breedId: 'merinos',
        createdAt: now.subtract(const Duration(days: 650)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),

      // ==================== BÉLIERS (3) ====================
      Animal(
        id: 'animal_006',
        currentEid: '250001234567806',
        officialNumber: 'FR-2020-0006',
        birthDate: DateTime(2020, 12, 5),
        sex: AnimalSex.male,
        status: AnimalStatus.alive,
        speciesId: 'sheep',
        breedId: 'merinos',
        createdAt: now.subtract(const Duration(days: 1500)),
        updatedAt: now.subtract(const Duration(days: 30)),
      ),

      Animal(
        id: 'animal_007',
        currentEid: '250001234567807',
        officialNumber: 'FR-2021-0007',
        birthDate: DateTime(2021, 11, 10),
        sex: AnimalSex.male,
        status: AnimalStatus.alive,
        speciesId: 'sheep',
        breedId: 'texel',
        createdAt: now.subtract(const Duration(days: 1100)),
        updatedAt: now.subtract(const Duration(days: 15)),
      ),

      Animal(
        id: 'animal_008',
        currentEid: '250001234567808',
        officialNumber: 'FR-2022-0008',
        birthDate: DateTime(2022, 10, 20),
        sex: AnimalSex.male,
        status: AnimalStatus.alive,
        speciesId: 'sheep',
        breedId: 'suffolk',
        // EXEMPLE : Animal avec plusieurs changements d'EID
        eidHistory: [
          EidChange(
            id: 'eid_change_002',
            oldEid: '250001234567888',
            newEid: '250001234567999',
            changedAt: DateTime(2023, 3, 10, 9, 15),
            reason: EidChangeReason.pucePerdue,
            notes: 'Puce perdue dans le pâturage',
          ),
          EidChange(
            id: 'eid_change_003',
            oldEid: '250001234567999',
            newEid: '250001234567808',
            changedAt: DateTime(2024, 8, 22, 16, 45),
            reason: EidChangeReason.puceDefectueuse,
            notes: 'Puce ne répondait plus au lecteur',
          ),
        ],
        createdAt: now.subtract(const Duration(days: 750)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),

      // ==================== AGNEAUX 2024 (5) ====================
      Animal(
        id: 'animal_009',
        currentEid: '250001234567809',
        officialNumber: 'FR-2024-0009',
        birthDate: DateTime(2024, 2, 10),
        sex: AnimalSex.male,
        motherId: 'animal_001',
        status: AnimalStatus.alive,
        speciesId: 'sheep',
        breedId: 'merinos',
        createdAt: now.subtract(const Duration(days: 260)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),

      Animal(
        id: 'animal_010',
        currentEid: '250001234567810',
        officialNumber: 'FR-2024-0010',
        birthDate: DateTime(2024, 2, 15),
        sex: AnimalSex.female,
        motherId: 'animal_002',
        status: AnimalStatus.alive,
        speciesId: 'sheep',
        breedId: 'suffolk',
        createdAt: now.subtract(const Duration(days: 255)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),

      Animal(
        id: 'animal_011',
        currentEid: '250001234567811',
        officialNumber: 'FR-2024-0011',
        birthDate: DateTime(2024, 3, 1),
        sex: AnimalSex.male,
        motherId: 'animal_003',
        status: AnimalStatus.alive,
        speciesId: 'sheep',
        breedId: 'lacaune',
        createdAt: now.subtract(const Duration(days: 240)),
        updatedAt: now,
      ),

      Animal(
        id: 'animal_012',
        currentEid: '250001234567812',
        officialNumber: 'FR-2024-0012',
        birthDate: DateTime(2024, 3, 20),
        sex: AnimalSex.female,
        motherId: 'animal_004',
        status: AnimalStatus.alive,
        speciesId: 'sheep',
        breedId: 'ile_de_france',
        createdAt: now.subtract(const Duration(days: 220)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),

      Animal(
        id: 'animal_013',
        currentEid: '250001234567813',
        officialNumber: 'FR-2024-0013',
        birthDate: DateTime(2024, 4, 5),
        sex: AnimalSex.male,
        motherId: 'animal_005',
        status: AnimalStatus.alive,
        speciesId: 'sheep',
        breedId: 'merinos',
        createdAt: now.subtract(const Duration(days: 205)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),

      // ==================== BOVINS (3) ====================
      Animal(
        id: 'animal_014',
        currentEid: '250002234567814',
        officialNumber: 'FR-2022-0014',
        birthDate: DateTime(2022, 5, 10),
        sex: AnimalSex.female,
        status: AnimalStatus.alive,
        speciesId: 'cattle',
        breedId: 'charolaise',
        createdAt: now.subtract(const Duration(days: 880)),
        updatedAt: now.subtract(const Duration(days: 7)),
      ),

      Animal(
        id: 'animal_015',
        currentEid: '250002234567815',
        officialNumber: 'FR-2023-0015',
        birthDate: DateTime(2023, 3, 20),
        sex: AnimalSex.male,
        status: AnimalStatus.alive,
        speciesId: 'cattle',
        breedId: 'limousine',
        createdAt: now.subtract(const Duration(days: 590)),
        updatedAt: now.subtract(const Duration(days: 4)),
      ),

      Animal(
        id: 'animal_016',
        currentEid: '250002234567816',
        officialNumber: 'FR-2024-0016',
        birthDate: DateTime(2024, 1, 15),
        sex: AnimalSex.female,
        motherId: 'animal_014',
        status: AnimalStatus.alive,
        speciesId: 'cattle',
        breedId: 'charolaise',
        createdAt: now.subtract(const Duration(days: 285)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),

      // ==================== CAPRINS (2) ====================
      Animal(
        id: 'animal_017',
        currentEid: '250003234567817',
        officialNumber: 'FR-2023-0017',
        birthDate: DateTime(2023, 6, 10),
        sex: AnimalSex.female,
        status: AnimalStatus.alive,
        speciesId: 'goat',
        breedId: 'alpine',
        createdAt: now.subtract(const Duration(days: 505)),
        updatedAt: now.subtract(const Duration(days: 8)),
      ),

      // ==================== ANIMAL VENDU (1) ====================
      Animal(
        id: 'animal_018',
        currentEid: '250001234567818',
        officialNumber: 'FR-2023-0018',
        birthDate: DateTime(2023, 12, 5),
        sex: AnimalSex.male,
        motherId: 'animal_004',
        status: AnimalStatus.sold,
        speciesId: 'sheep',
        breedId: 'suffolk',
        createdAt: now.subtract(const Duration(days: 325)),
        updatedAt: now.subtract(const Duration(days: 45)),
      ),

      // ==================== ANIMAL MORT (1) ====================
      Animal(
        id: 'animal_019',
        currentEid: '250001234567819',
        officialNumber: 'FR-2024-0019',
        birthDate: DateTime(2024, 1, 15),
        sex: AnimalSex.male,
        motherId: 'animal_001',
        status: AnimalStatus.dead,
        speciesId: 'sheep',
        breedId: 'merinos',
        createdAt: now.subtract(const Duration(days: 280)),
        updatedAt: now.subtract(const Duration(days: 120)),
      ),

      // ==================== ANIMAL AVEC RÉMANENCE (1) ====================
      Animal(
        id: 'animal_020',
        currentEid: '250001234567820',
        officialNumber: 'FR-2024-0020',
        birthDate: DateTime(2024, 4, 1),
        sex: AnimalSex.male,
        motherId: 'animal_005',
        status: AnimalStatus.alive,
        speciesId: 'sheep',
        breedId: 'texel',
        createdAt: now.subtract(const Duration(days: 210)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
    ];
  }
}
