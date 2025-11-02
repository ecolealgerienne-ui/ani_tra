// lib/mock/mock_vaccinations.dart

import '../../models/vaccination.dart';

/// Données de test pour les vaccinations
final List<Vaccination> mockVaccinations = [
  // === Vaccinations administrées ===
  Vaccination(
    id: 'vacc-001',
    farmId: 'mock-farm-001',
    animalId: 'animal-001', // Belle (vache laitière)
    productId: 'med-001',
    productName: 'Bovilis IBR Marker Live',
    administrationDate: DateTime.now().subtract(const Duration(days: 45)),
    nextDueDate: DateTime.now().add(const Duration(days: 320)),
    batchNumber: 'LOT2024-IBR-443',
    dosage: 2.0,
    dosageUnit: 'ml',
    administrationRoute: 'IM',
    injectionSite: 'Encolure gauche',
    veterinarianId: 'vet-001',
    veterinarianName: 'Dr. Martin Dubois',
    administeredBy: 'Jean Dupont',
    status: VaccinationStatus.administered,
    notes: 'Vaccination annuelle IBR - Aucune réaction',
    createdAt: DateTime.now().subtract(const Duration(days: 50)),
    updatedAt: DateTime.now().subtract(const Duration(days: 45)),
  ),

  Vaccination(
    id: 'vacc-002',
    farmId: 'mock-farm-001',
    animalId: 'animal-001',
    productId: 'med-002',
    productName: 'Bravoxin 10',
    administrationDate: DateTime.now().subtract(const Duration(days: 60)),
    nextDueDate: DateTime.now().add(const Duration(days: 305)),
    batchNumber: 'LOT2024-BRV-881',
    dosage: 5.0,
    dosageUnit: 'ml',
    administrationRoute: 'SC',
    injectionSite: 'Flanc droit',
    veterinarianId: 'vet-001',
    veterinarianName: 'Dr. Martin Dubois',
    administeredBy: 'Jean Dupont',
    status: VaccinationStatus.administered,
    notes: 'Vaccination clostridies - RAS',
    createdAt: DateTime.now().subtract(const Duration(days: 65)),
    updatedAt: DateTime.now().subtract(const Duration(days: 60)),
  ),

  Vaccination(
    id: 'vacc-003',
    farmId: 'mock-farm-001',
    animalId: 'animal-002', // Marguerite
    productId: 'med-001',
    productName: 'Bovilis IBR Marker Live',
    administrationDate: DateTime.now().subtract(const Duration(days: 30)),
    nextDueDate: DateTime.now().add(const Duration(days: 335)),
    batchNumber: 'LOT2024-IBR-443',
    dosage: 2.0,
    dosageUnit: 'ml',
    administrationRoute: 'IM',
    injectionSite: 'Encolure droite',
    veterinarianId: 'vet-001',
    veterinarianName: 'Dr. Martin Dubois',
    administeredBy: 'Jean Dupont',
    status: VaccinationStatus.administered,
    adverseReaction: 'Légère réaction locale - œdème 2cm disparu en 48h',
    notes: 'Vaccination IBR - Surveiller réaction',
    createdAt: DateTime.now().subtract(const Duration(days: 35)),
    updatedAt: DateTime.now().subtract(const Duration(days: 30)),
  ),

  Vaccination(
    id: 'vacc-004',
    farmId: 'mock-farm-001',
    animalId: 'animal-005', // Duchesse
    productId: 'med-003',
    productName: 'Bovilis BVD',
    administrationDate: DateTime.now().subtract(const Duration(days: 90)),
    nextDueDate: DateTime.now().add(const Duration(days: 275)),
    batchNumber: 'LOT2024-BVD-223',
    dosage: 2.0,
    dosageUnit: 'ml',
    administrationRoute: 'IM',
    injectionSite: 'Cuisse gauche',
    veterinarianId: 'vet-002',
    veterinarianName: 'Dr. Sophie Laurent',
    administeredBy: 'Marie Martin',
    status: VaccinationStatus.administered,
    notes: 'Vaccination BVD génisse - RAS',
    createdAt: DateTime.now().subtract(const Duration(days: 95)),
    updatedAt: DateTime.now().subtract(const Duration(days: 90)),
  ),

  // === Vaccinations planifiées ===
  Vaccination(
    id: 'vacc-005',
    farmId: 'mock-farm-001',
    animalId: 'animal-003', // Blanchette
    productId: 'med-001',
    productName: 'Bovilis IBR Marker Live',
    administrationDate: DateTime.now().add(const Duration(days: 7)),
    batchNumber: 'LOT2024-IBR-443',
    dosage: 2.0,
    dosageUnit: 'ml',
    veterinarianId: 'vet-001',
    veterinarianName: 'Dr. Martin Dubois',
    status: VaccinationStatus.planned,
    notes: 'Vaccination IBR à planifier',
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
  ),

  Vaccination(
    id: 'vacc-006',
    farmId: 'mock-farm-001',
    animalId: 'animal-004', // Caramel
    productId: 'med-002',
    productName: 'Bravoxin 10',
    administrationDate: DateTime.now().add(const Duration(days: 14)),
    dosage: 5.0,
    dosageUnit: 'ml',
    veterinarianId: 'vet-001',
    veterinarianName: 'Dr. Martin Dubois',
    status: VaccinationStatus.planned,
    notes: 'Rappel clostridies',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),

  // === Vaccinations en retard ===
  Vaccination(
    id: 'vacc-007',
    farmId: 'mock-farm-001',
    animalId: 'animal-006', // Noisette
    productId: 'med-001',
    productName: 'Bovilis IBR Marker Live',
    administrationDate: DateTime.now().subtract(const Duration(days: 3)),
    veterinarianId: 'vet-001',
    veterinarianName: 'Dr. Martin Dubois',
    status: VaccinationStatus.planned,
    notes: '⚠️ RETARD - Prévoir rapidement',
    createdAt: DateTime.now().subtract(const Duration(days: 15)),
  ),

  Vaccination(
    id: 'vacc-008',
    farmId: 'mock-farm-001',
    animalId: 'animal-007', // Perle
    productId: 'med-002',
    productName: 'Bravoxin 10',
    administrationDate: DateTime.now().subtract(const Duration(days: 8)),
    veterinarianId: 'vet-002',
    veterinarianName: 'Dr. Sophie Laurent',
    status: VaccinationStatus.planned,
    notes: '⚠️ EN RETARD depuis 8 jours',
    createdAt: DateTime.now().subtract(const Duration(days: 20)),
  ),

  // === Rappels à venir (dans 30 jours) ===
  Vaccination(
    id: 'vacc-009',
    farmId: 'mock-farm-001',
    animalId: 'animal-008', // Étoile
    productId: 'med-001',
    productName: 'Bovilis IBR Marker Live',
    administrationDate: DateTime.now().add(const Duration(days: 21)),
    nextDueDate: DateTime.now().add(const Duration(days: 386)),
    veterinarianId: 'vet-001',
    veterinarianName: 'Dr. Martin Dubois',
    status: VaccinationStatus.planned,
    notes: 'Rappel annuel IBR',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),

  Vaccination(
    id: 'vacc-010',
    farmId: 'mock-farm-001',
    animalId: 'animal-009', // Câline
    productId: 'med-003',
    productName: 'Bovilis BVD',
    administrationDate: DateTime.now().add(const Duration(days: 28)),
    veterinarianId: 'vet-002',
    veterinarianName: 'Dr. Sophie Laurent',
    status: VaccinationStatus.planned,
    notes: 'Première vaccination BVD génisse',
    createdAt: DateTime.now(),
  ),

  // === Vaccination annulée ===
  Vaccination(
    id: 'vacc-011',
    farmId: 'mock-farm-001',
    animalId: 'animal-010',
    productId: 'med-002',
    productName: 'Bravoxin 10',
    administrationDate: DateTime.now().subtract(const Duration(days: 15)),
    veterinarianId: 'vet-001',
    veterinarianName: 'Dr. Martin Dubois',
    status: VaccinationStatus.cancelled,
    notes: 'Annulée - Animal malade (fièvre)',
    createdAt: DateTime.now().subtract(const Duration(days: 20)),
    updatedAt: DateTime.now().subtract(const Duration(days: 15)),
  ),
];

/// Statistiques des vaccinations mock
class MockVaccinationStats {
  static int get totalVaccinations => mockVaccinations.length;

  static int get administered => mockVaccinations
      .where((v) => v.status == VaccinationStatus.administered)
      .length;

  static int get planned => mockVaccinations
      .where((v) => v.status == VaccinationStatus.planned)
      .length;

  static int get overdue => mockVaccinations.where((v) => v.isOverdue).length;

  static int get withAdverseReactions =>
      mockVaccinations.where((v) => v.adverseReaction != null).length;

  static double get complianceRate {
    if (totalVaccinations == 0) return 0.0;
    return (administered / totalVaccinations * 100);
  }
}
