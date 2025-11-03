// lib/mock/mock_vaccines.dart

import '../../models/vaccine_reference.dart';

/// Données de test pour les vaccins de référence
/// Basé sur des vaccins réels disponibles en France
final List<VaccineReference> mockVaccines = [
  // === VACCINS FCO (Fièvre Catarrhale Ovine) ===
  VaccineReference(
    id: 'vaccine-fco-bluevac3',
    farmId: 'mock-farm-001',
    name: 'BLUEVAC 3',
    manufacturer: 'CZV',
    description: 'Vaccin contre la FCO sérotype 3',
    targetSpecies: [VaccineTargetSpecies.bovine],
    targetDiseases: ['FCO-3', 'Fièvre Catarrhale Ovine BTV3'],
    standardDose: '1 ml',
    injectionsRequired: 2,
    injectionIntervalDays: 21,
    administrationRoute: 'IM',
    meatWithdrawalDays: 0,
    milkWithdrawalDays: 0,
    notes: 'Immunité complète 21 jours après 2ème injection',
    isActive: true,
  ),

  VaccineReference(
    id: 'vaccine-fco-bultavo3',
    farmId: 'mock-farm-001',
    name: 'BULTAVO 3',
    manufacturer: 'Boehringer Ingelheim',
    description: 'Vaccin contre la FCO sérotype 3',
    targetSpecies: [VaccineTargetSpecies.ovine],
    targetDiseases: ['FCO-3', 'Fièvre Catarrhale Ovine BTV3'],
    standardDose: '1 ml',
    injectionsRequired: 1,
    administrationRoute: 'SC',
    meatWithdrawalDays: 0,
    milkWithdrawalDays: 0,
    notes: 'Immunité complète 21 jours après injection',
    isActive: true,
  ),

  VaccineReference(
    id: 'vaccine-fco-btvpur48',
    farmId: 'mock-farm-001',
    name: 'BTVPur 4-8',
    manufacturer: 'Boehringer Ingelheim',
    description: 'Vaccin bivalent contre FCO sérotypes 4 et 8',
    targetSpecies: [VaccineTargetSpecies.bovine, VaccineTargetSpecies.ovine],
    targetDiseases: ['FCO-4', 'FCO-8'],
    standardDose: '1 ml',
    injectionsRequired: 2,
    injectionIntervalDays: 21,
    administrationRoute: 'SC',
    meatWithdrawalDays: 0,
    milkWithdrawalDays: 0,
    notes:
        'Immunité complète 21 jours après 2ème injection. Empêche la virémie.',
    isActive: true,
  ),

  VaccineReference(
    id: 'vaccine-fco-bluevac8',
    farmId: 'mock-farm-001',
    name: 'BLUEVAC 8',
    manufacturer: 'CZV',
    description: 'Vaccin contre FCO sérotype 8',
    targetSpecies: [VaccineTargetSpecies.bovine, VaccineTargetSpecies.ovine],
    targetDiseases: ['FCO-8'],
    standardDose: '1 ml',
    injectionsRequired: 2,
    injectionIntervalDays: 21,
    administrationRoute: 'IM',
    meatWithdrawalDays: 0,
    milkWithdrawalDays: 0,
    notes: 'Immunité complète 39 jours après 1ère injection (bovins)',
    isActive: true,
  ),

  VaccineReference(
    id: 'vaccine-fco-syvazul48',
    farmId: 'mock-farm-001',
    name: 'SYVAZUL 4-8',
    manufacturer: 'Syva',
    description: 'Vaccin bivalent contre FCO sérotypes 4 et 8',
    targetSpecies: [VaccineTargetSpecies.ovine], // Réservé aux ovins par l'État
    targetDiseases: ['FCO-4', 'FCO-8'],
    standardDose: '1 ml',
    injectionsRequired: 1,
    administrationRoute: 'SC',
    meatWithdrawalDays: 0,
    milkWithdrawalDays: 0,
    notes: 'Immunité complète 39 jours après injection. Une seule injection.',
    isActive: true,
  ),

  // === VACCINS IBR (Rhinotrachéite Infectieuse Bovine) ===
  VaccineReference(
    id: 'vaccine-ibr-bovilis',
    farmId: 'mock-farm-001',
    name: 'Bovilis IBR Marker Live',
    manufacturer: 'MSD Animal Health',
    description: 'Vaccin vivant atténué contre IBR',
    targetSpecies: [VaccineTargetSpecies.bovine],
    targetDiseases: ['IBR', 'Rhinotrachéite Infectieuse Bovine'],
    standardDose: '2 ml',
    injectionsRequired: 2,
    injectionIntervalDays: 21,
    administrationRoute: 'IM',
    meatWithdrawalDays: 0,
    milkWithdrawalDays: 0,
    notes: 'Rappel tous les 6 mois pour reproductrices',
    isActive: true,
  ),

  // === VACCINS BVD (Diarrhée Virale Bovine) ===
  VaccineReference(
    id: 'vaccine-bvd-bovilis',
    farmId: 'mock-farm-001',
    name: 'Bovilis BVD',
    manufacturer: 'MSD Animal Health',
    description: 'Vaccin contre la BVD',
    targetSpecies: [VaccineTargetSpecies.bovine],
    targetDiseases: ['BVD', 'Diarrhée Virale Bovine'],
    standardDose: '2 ml',
    injectionsRequired: 2,
    injectionIntervalDays: 28,
    administrationRoute: 'IM',
    meatWithdrawalDays: 0,
    milkWithdrawalDays: 0,
    notes: 'Vacciner génisses avant première saillie',
    isActive: true,
  ),

  // === VACCINS CLOSTRIDIES ===
  VaccineReference(
    id: 'vaccine-clostridies-bravoxin',
    farmId: 'mock-farm-001',
    name: 'Bravoxin 10',
    manufacturer: 'Intervet',
    description: 'Vaccin contre les clostridioses (10 valences)',
    targetSpecies: [VaccineTargetSpecies.bovine, VaccineTargetSpecies.ovine],
    targetDiseases: [
      'Entérotoxémie',
      'Charbon symptomatique',
      'Tétanos',
      'Œdème malin'
    ],
    standardDose: '5 ml',
    injectionsRequired: 2,
    injectionIntervalDays: 28,
    administrationRoute: 'SC',
    meatWithdrawalDays: 0,
    milkWithdrawalDays: 0,
    notes: 'Rappel annuel recommandé',
    isActive: true,
  ),

  VaccineReference(
    id: 'vaccine-clostridies-coglavax',
    farmId: 'mock-farm-001',
    name: 'COGLAVAX',
    manufacturer: 'CEVA Phylaxia',
    description: 'Vaccin anti-clostridien 8 valences',
    targetSpecies: [VaccineTargetSpecies.ovine, VaccineTargetSpecies.caprine],
    targetDiseases: ['Entérotoxémie', 'Clostridium perfringens'],
    standardDose: '2 ml',
    injectionsRequired: 2,
    injectionIntervalDays: 21,
    administrationRoute: 'SC',
    meatWithdrawalDays: 0,
    milkWithdrawalDays: 0,
    notes: 'Vaccin de référence pour petits ruminants',
    isActive: true,
  ),

  VaccineReference(
    id: 'vaccine-clostridies-covexin10',
    farmId: 'mock-farm-001',
    name: 'Covexin 10',
    manufacturer: 'Zoetis',
    description: 'Vaccin contre Clostridium perfringens',
    targetSpecies: [
      VaccineTargetSpecies.ovine,
      VaccineTargetSpecies.bovine,
      VaccineTargetSpecies.caprine
    ],
    targetDiseases: ['Entérotoxémie', 'Clostridium perfringens'],
    standardDose: '2 ml',
    injectionsRequired: 2,
    injectionIntervalDays: 28,
    administrationRoute: 'IM',
    meatWithdrawalDays: 0,
    milkWithdrawalDays: 0,
    notes: 'Vacciner 4-6 semaines avant mise à l\'herbe. Rappel annuel.',
    isActive: true,
  ),

  // === VACCINS PASTEURELLOSE ===
  VaccineReference(
    id: 'vaccine-pasteurellose-ovipast',
    farmId: 'mock-farm-001',
    name: 'Ovipast Plus',
    manufacturer: 'Hipra',
    description: 'Vaccin contre la pasteurellose ovine',
    targetSpecies: [VaccineTargetSpecies.ovine],
    targetDiseases: ['Pasteurellose', 'Pasteurella'],
    standardDose: '2 ml',
    injectionsRequired: 2,
    injectionIntervalDays: 21,
    administrationRoute: 'SC',
    meatWithdrawalDays: 0,
    milkWithdrawalDays: 0,
    notes: 'Vaccination avant rentrée en bergerie (septembre-octobre)',
    isActive: true,
  ),

  // === VACCINS PARATUBERCULOSE ===
  VaccineReference(
    id: 'vaccine-paratuberculose-gudair',
    farmId: 'mock-farm-001',
    name: 'GUDAIR',
    manufacturer: 'CZ Vaccines',
    description: 'Vaccin contre la paratuberculose',
    targetSpecies: [VaccineTargetSpecies.ovine, VaccineTargetSpecies.caprine],
    targetDiseases: ['Paratuberculose', 'Maladie de Johne'],
    standardDose: '1 ml',
    injectionsRequired: 1,
    administrationRoute: 'SC',
    meatWithdrawalDays: 0,
    milkWithdrawalDays: 0,
    notes:
        '⚠️ Autorisation DDPP obligatoire. Interactions avec surveillance tuberculose.',
    isActive: true,
  ),

  VaccineReference(
    id: 'vaccine-paratuberculose-silirum',
    farmId: 'mock-farm-001',
    name: 'SILIRUM',
    manufacturer: 'CZ Vaccines',
    description: 'Vaccin contre la paratuberculose bovine',
    targetSpecies: [VaccineTargetSpecies.bovine],
    targetDiseases: ['Paratuberculose', 'Maladie de Johne'],
    standardDose: '1 ml',
    injectionsRequired: 1,
    administrationRoute: 'SC',
    meatWithdrawalDays: 0,
    milkWithdrawalDays: 0,
    notes:
        '⚠️ Autorisation DDPP obligatoire. Interactions avec surveillance tuberculose.',
    isActive: true,
  ),
];

/// Statistiques des vaccins mock
class MockVaccineStats {
  static int get totalVaccines => mockVaccines.length;

  static int get bovineVaccines =>
      mockVaccines.where((v) => v.isCompatibleWith('bovine')).length;

  static int get ovineVaccines =>
      mockVaccines.where((v) => v.isCompatibleWith('ovine')).length;

  static int get caprineVaccines =>
      mockVaccines.where((v) => v.isCompatibleWith('caprine')).length;

  static int get multiSpeciesVaccines =>
      mockVaccines.where((v) => v.targetSpecies.length > 1).length;

  static List<VaccineReference> getVaccinesForSpecies(String species) {
    return mockVaccines.where((v) => v.isCompatibleWith(species)).toList();
  }

  static List<VaccineReference> getVaccinesForDisease(String disease) {
    return mockVaccines
        .where((v) => v.targetDiseases.any(
              (d) => d.toLowerCase().contains(disease.toLowerCase()),
            ))
        .toList();
  }
}
