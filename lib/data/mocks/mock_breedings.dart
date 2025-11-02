// lib/mock/mock_breedings.dart

import '../../models/breeding.dart';

/// Données de test pour les reproductions
final List<Breeding> mockBreedings = [
  // === Reproductions terminées avec succès ===
  Breeding(
    id: 'breed-001',
    farmId: 'mock-farm-001',
    motherId: 'animal-002', // Marguerite
    fatherId: null, // Taureau externe
    fatherName: 'Limousin Elite #FR5678',
    method: BreedingMethod.artificialInsemination,
    breedingDate: DateTime.now().subtract(const Duration(days: 290)),
    expectedBirthDate: DateTime.now().subtract(const Duration(days: 10)),
    actualBirthDate: DateTime.now().subtract(const Duration(days: 8)),
    expectedOffspringCount: 1,
    offspringIds: ['animal-025'], // Veau né
    veterinarianId: 'vet-002',
    veterinarianName: 'Dr. Sophie Laurent',
    notes: 'IA réussie - Veau mâle en bonne santé (45kg)',
    status: BreedingStatus.completed,
    createdAt: DateTime.now().subtract(const Duration(days: 295)),
    updatedAt: DateTime.now().subtract(const Duration(days: 8)),
  ),

  Breeding(
    id: 'breed-002',
    farmId: 'mock-farm-001',
    motherId: 'animal-001', // Belle
    fatherId: null,
    fatherName: 'Holstein Canada #HOL1234',
    method: BreedingMethod.artificialInsemination,
    breedingDate: DateTime.now().subtract(const Duration(days: 310)),
    expectedBirthDate: DateTime.now().subtract(const Duration(days: 30)),
    actualBirthDate: DateTime.now().subtract(const Duration(days: 28)),
    expectedOffspringCount: 1,
    offspringIds: ['animal-026'], // Veau né
    veterinarianId: 'vet-001',
    veterinarianName: 'Dr. Martin Dubois',
    notes: 'IA Holstein - Veau femelle (42kg)',
    status: BreedingStatus.completed,
    createdAt: DateTime.now().subtract(const Duration(days: 315)),
    updatedAt: DateTime.now().subtract(const Duration(days: 28)),
  ),

  Breeding(
    id: 'breed-003',
    farmId: 'mock-farm-001',
    motherId: 'animal-005', // Duchesse
    fatherId: 'animal-015', // Taureau de la ferme
    method: BreedingMethod.natural,
    breedingDate: DateTime.now().subtract(const Duration(days: 330)),
    expectedBirthDate: DateTime.now().subtract(const Duration(days: 50)),
    actualBirthDate: DateTime.now().subtract(const Duration(days: 47)),
    expectedOffspringCount: 1,
    offspringIds: ['animal-027'],
    notes: 'Saillie naturelle - Veau mâle vigoureux (48kg)',
    status: BreedingStatus.completed,
    createdAt: DateTime.now().subtract(const Duration(days: 335)),
    updatedAt: DateTime.now().subtract(const Duration(days: 47)),
  ),

  // === Reproductions en attente - À venir ===
  Breeding(
    id: 'breed-004',
    farmId: 'mock-farm-001',
    motherId: 'animal-003', // Blanchette
    fatherId: null,
    fatherName: 'Charolais Premium #CH9876',
    method: BreedingMethod.artificialInsemination,
    breedingDate: DateTime.now().subtract(const Duration(days: 215)),
    expectedBirthDate: DateTime.now().add(const Duration(days: 65)),
    expectedOffspringCount: 1,
    veterinarianId: 'vet-001',
    veterinarianName: 'Dr. Martin Dubois',
    notes: 'IA Charolais - Gestation confirmée par échographie',
    status: BreedingStatus.pending,
    createdAt: DateTime.now().subtract(const Duration(days: 220)),
  ),

  Breeding(
    id: 'breed-005',
    farmId: 'mock-farm-001',
    motherId: 'animal-006', // Noisette
    fatherId: null,
    fatherName: 'Blonde d\'Aquitaine #BA4567',
    method: BreedingMethod.artificialInsemination,
    breedingDate: DateTime.now().subtract(const Duration(days: 180)),
    expectedBirthDate: DateTime.now().add(const Duration(days: 100)),
    expectedOffspringCount: 1,
    veterinarianId: 'vet-002',
    veterinarianName: 'Dr. Sophie Laurent',
    notes: 'IA Blonde - Confirmation gestation à J60',
    status: BreedingStatus.pending,
    createdAt: DateTime.now().subtract(const Duration(days: 185)),
  ),

  // === Mise-bas imminente (< 7 jours) ===
  Breeding(
    id: 'breed-006',
    farmId: 'mock-farm-001',
    motherId: 'animal-004', // Caramel
    fatherId: 'animal-015',
    method: BreedingMethod.natural,
    breedingDate: DateTime.now().subtract(const Duration(days: 275)),
    expectedBirthDate: DateTime.now().add(const Duration(days: 5)),
    expectedOffspringCount: 1,
    notes: '⚠️ Mise-bas prévue dans 5 jours - Surveiller',
    status: BreedingStatus.pending,
    createdAt: DateTime.now().subtract(const Duration(days: 280)),
  ),

  Breeding(
    id: 'breed-007',
    farmId: 'mock-farm-001',
    motherId: 'animal-007', // Perle
    fatherId: null,
    fatherName: 'Limousin Elite #FR5678',
    method: BreedingMethod.artificialInsemination,
    breedingDate: DateTime.now().subtract(const Duration(days: 277)),
    expectedBirthDate: DateTime.now().add(const Duration(days: 3)),
    expectedOffspringCount: 1,
    veterinarianId: 'vet-002',
    veterinarianName: 'Dr. Sophie Laurent',
    notes: '🔔 Mise-bas dans 3 jours - Boxe préparé',
    status: BreedingStatus.pending,
    createdAt: DateTime.now().subtract(const Duration(days: 282)),
  ),

  // === En retard ===
  Breeding(
    id: 'breed-008',
    farmId: 'mock-farm-001',
    motherId: 'animal-008', // Étoile
    fatherId: null,
    fatherName: 'Holstein Canada #HOL1234',
    method: BreedingMethod.artificialInsemination,
    breedingDate: DateTime.now().subtract(const Duration(days: 285)),
    expectedBirthDate: DateTime.now().subtract(const Duration(days: 5)),
    expectedOffspringCount: 1,
    veterinarianId: 'vet-001',
    veterinarianName: 'Dr. Martin Dubois',
    notes: '⚠️ EN RETARD de 5 jours - Surveillance rapprochée',
    status: BreedingStatus.pending,
    createdAt: DateTime.now().subtract(const Duration(days: 290)),
  ),

  // === Échecs ===
  Breeding(
    id: 'breed-009',
    farmId: 'mock-farm-001',
    motherId: 'animal-009', // Câline
    fatherId: null,
    fatherName: 'Charolais Premium #CH9876',
    method: BreedingMethod.artificialInsemination,
    breedingDate: DateTime.now().subtract(const Duration(days: 90)),
    expectedBirthDate: DateTime.now().add(const Duration(days: 190)),
    veterinarianId: 'vet-001',
    veterinarianName: 'Dr. Martin Dubois',
    notes: '❌ Échec - Pas de gestation détectée à J60',
    status: BreedingStatus.failed,
    createdAt: DateTime.now().subtract(const Duration(days: 95)),
    updatedAt: DateTime.now().subtract(const Duration(days: 30)),
  ),

  // === Avortement ===
  Breeding(
    id: 'breed-010',
    farmId: 'mock-farm-001',
    motherId: 'animal-010', // Rosalie
    fatherId: 'animal-015',
    method: BreedingMethod.natural,
    breedingDate: DateTime.now().subtract(const Duration(days: 200)),
    expectedBirthDate: DateTime.now().add(const Duration(days: 80)),
    actualBirthDate: DateTime.now().subtract(const Duration(days: 15)),
    veterinarianId: 'vet-002',
    veterinarianName: 'Dr. Sophie Laurent',
    notes: '⚠️ Avortement à 6 mois - Cause: Infection BVD suspectée',
    status: BreedingStatus.aborted,
    createdAt: DateTime.now().subtract(const Duration(days: 205)),
    updatedAt: DateTime.now().subtract(const Duration(days: 15)),
  ),

  // === Reproductions planifiées récemment ===
  Breeding(
    id: 'breed-011',
    farmId: 'mock-farm-001',
    motherId: 'animal-011', // Fleur
    fatherId: null,
    fatherName: 'Limousin Elite #FR5678',
    method: BreedingMethod.artificialInsemination,
    breedingDate: DateTime.now().subtract(const Duration(days: 45)),
    expectedBirthDate: DateTime.now().add(const Duration(days: 235)),
    expectedOffspringCount: 1,
    veterinarianId: 'vet-001',
    veterinarianName: 'Dr. Martin Dubois',
    notes: 'IA récente - Confirmation gestation prévue J60',
    status: BreedingStatus.pending,
    createdAt: DateTime.now().subtract(const Duration(days: 50)),
  ),

  Breeding(
    id: 'breed-012',
    farmId: 'mock-farm-001',
    motherId: 'animal-012', // Clochette
    fatherId: null,
    fatherName: 'Blonde d\'Aquitaine #BA4567',
    method: BreedingMethod.artificialInsemination,
    breedingDate: DateTime.now().subtract(const Duration(days: 30)),
    expectedBirthDate: DateTime.now().add(const Duration(days: 250)),
    expectedOffspringCount: 1,
    veterinarianId: 'vet-002',
    veterinarianName: 'Dr. Sophie Laurent',
    notes: 'IA très récente',
    status: BreedingStatus.pending,
    createdAt: DateTime.now().subtract(const Duration(days: 32)),
  ),

  // === Gestation multiple (rare mais possible) ===
  Breeding(
    id: 'breed-013',
    farmId: 'mock-farm-001',
    motherId: 'animal-013', // Princesse
    fatherId: 'animal-015',
    method: BreedingMethod.natural,
    breedingDate: DateTime.now().subtract(const Duration(days: 355)),
    expectedBirthDate: DateTime.now().subtract(const Duration(days: 75)),
    actualBirthDate: DateTime.now().subtract(const Duration(days: 73)),
    expectedOffspringCount: 1,
    offspringIds: ['animal-028', 'animal-029'], // Jumeaux !
    notes: '🎉 JUMEAUX - Rare ! 2 mâles en bonne santé (40kg et 38kg)',
    status: BreedingStatus.completed,
    createdAt: DateTime.now().subtract(const Duration(days: 360)),
    updatedAt: DateTime.now().subtract(const Duration(days: 73)),
  ),
];

/// Statistiques des reproductions mock
class MockBreedingStats {
  static int get totalBreedings => mockBreedings.length;

  static int get pending =>
      mockBreedings.where((b) => b.status == BreedingStatus.pending).length;

  static int get completed =>
      mockBreedings.where((b) => b.status == BreedingStatus.completed).length;

  static int get failed =>
      mockBreedings.where((b) => b.status == BreedingStatus.failed).length;

  static int get aborted =>
      mockBreedings.where((b) => b.status == BreedingStatus.aborted).length;

  static int get overdue => mockBreedings.where((b) => b.isOverdue).length;

  static int get birthSoon => mockBreedings.where((b) => b.isBirthSoon).length;

  static double get successRate {
    if (totalBreedings == 0) return 0.0;
    return (completed / totalBreedings * 100);
  }

  static int get naturalBreedings =>
      mockBreedings.where((b) => b.method == BreedingMethod.natural).length;

  static int get artificialInseminations => mockBreedings
      .where((b) => b.method == BreedingMethod.artificialInsemination)
      .length;

  static int get totalOffspring {
    return mockBreedings.fold<int>(
      0,
      (sum, b) => sum + b.actualOffspringCount,
    );
  }

  static double get averageOffspringPerBirth {
    final completedBreedings =
        mockBreedings.where((b) => b.status == BreedingStatus.completed);
    if (completedBreedings.isEmpty) return 0.0;
    return totalOffspring / completedBreedings.length;
  }
}
