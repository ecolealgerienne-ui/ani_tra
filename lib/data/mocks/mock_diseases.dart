// lib/mock/mock_diseases.dart

import '../../models/disease_reference.dart';

final List<DiseaseReference> mockDiseases = [
  // === MALADIES VIRALES ===
  DiseaseReference(
    id: 'disease-fco',
    farmId: 'mock-farm-001',
    name: 'Fièvre Catarrhale Ovine (FCO)',
    scientificName: 'Bluetongue virus (BTV)',
    description:
        'Maladie virale transmise par moucherons piqueurs (culicoïdes)',
    targetSpecies: [
      DiseaseTargetSpecies.bovine,
      DiseaseTargetSpecies.ovine,
      DiseaseTargetSpecies.caprine
    ],
    symptoms: 'Fièvre, boiteries, œdèmes, lésions buccales, mortalité variable',
    treatment: 'Symptomatique uniquement. Vaccination préventive recommandée.',
    isContagious: true,
    requiresVeterinaryIntervention: true,
    isActive: true,
  ),

  DiseaseReference(
    id: 'disease-ibr',
    farmId: 'mock-farm-001',
    name: 'Rhinotrachéite Infectieuse Bovine (IBR)',
    scientificName: 'Bovine herpesvirus 1 (BoHV-1)',
    description: 'Maladie respiratoire virale des bovins',
    targetSpecies: [DiseaseTargetSpecies.bovine],
    symptoms: 'Jetage nasal, toux, fièvre, troubles respiratoires, avortements',
    treatment: 'Vaccination. Antibiotiques pour complications bactériennes.',
    isContagious: true,
    requiresVeterinaryIntervention: true,
    isActive: true,
  ),

  DiseaseReference(
    id: 'disease-bvd',
    farmId: 'mock-farm-001',
    name: 'Diarrhée Virale Bovine (BVD)',
    scientificName: 'Bovine Viral Diarrhea virus (BVDV)',
    description: 'Maladie virale causant troubles reproducteurs et immunité',
    targetSpecies: [DiseaseTargetSpecies.bovine],
    symptoms: 'Diarrhée, fièvre, troubles reproducteurs, immunodépression, IPI',
    treatment: 'Vaccination préventive. Dépistage et élimination des IPI.',
    isContagious: true,
    requiresVeterinaryIntervention: true,
    isActive: true,
  ),

  DiseaseReference(
    id: 'disease-mhe',
    farmId: 'mock-farm-001',
    name: 'Maladie Hémorragique Épizootique (MHE)',
    scientificName: 'Epizootic Hemorrhagic Disease virus (EHDV)',
    description: 'Maladie virale proche de la FCO',
    targetSpecies: [DiseaseTargetSpecies.bovine],
    symptoms: 'Hémorragies, fièvre, œdèmes, boiteries',
    treatment: 'Symptomatique. Vaccination préventive.',
    isContagious: true,
    requiresVeterinaryIntervention: true,
    isActive: true,
  ),

  // === MALADIES BACTÉRIENNES ===
  DiseaseReference(
    id: 'disease-enterotoxemie',
    farmId: 'mock-farm-001',
    name: 'Entérotoxémie',
    scientificName: 'Clostridium perfringens',
    description: 'Maladie bactérienne causée par toxines clostridiennes',
    targetSpecies: [
      DiseaseTargetSpecies.ovine,
      DiseaseTargetSpecies.bovine,
      DiseaseTargetSpecies.caprine
    ],
    symptoms: 'Mort subite, diarrhée, douleurs abdominales, convulsions',
    treatment: 'Vaccination préventive essentielle. Traitement difficile.',
    isContagious: false,
    requiresVeterinaryIntervention: true,
    isActive: true,
  ),

  DiseaseReference(
    id: 'disease-pasteurellose',
    farmId: 'mock-farm-001',
    name: 'Pasteurellose',
    scientificName: 'Pasteurella multocida',
    description: 'Infection respiratoire bactérienne',
    targetSpecies: [
      DiseaseTargetSpecies.ovine,
      DiseaseTargetSpecies.bovine,
      DiseaseTargetSpecies.caprine
    ],
    symptoms: 'Pneumonie, jetage, toux, fièvre, difficultés respiratoires',
    treatment: 'Antibiotiques, vaccination préventive recommandée',
    isContagious: true,
    requiresVeterinaryIntervention: true,
    isActive: true,
  ),

  DiseaseReference(
    id: 'disease-paratuberculose',
    farmId: 'mock-farm-001',
    name: 'Paratuberculose (Maladie de Johne)',
    scientificName: 'Mycobacterium avium paratuberculosis',
    description: 'Infection chronique de l\'intestin',
    targetSpecies: [
      DiseaseTargetSpecies.bovine,
      DiseaseTargetSpecies.ovine,
      DiseaseTargetSpecies.caprine
    ],
    symptoms: 'Diarrhée chronique, amaigrissement, perte production laitière',
    treatment:
        'Pas de traitement curatif. Vaccination et gestion sanitaire du troupeau.',
    isContagious: true,
    requiresVeterinaryIntervention: true,
    isActive: true,
  ),

  DiseaseReference(
    id: 'disease-charbon-symptomatique',
    farmId: 'mock-farm-001',
    name: 'Charbon Symptomatique',
    scientificName: 'Clostridium chauvoei',
    description: 'Maladie clostridienne à évolution rapide',
    targetSpecies: [DiseaseTargetSpecies.bovine, DiseaseTargetSpecies.ovine],
    symptoms: 'Boiterie soudaine, tuméfaction musculaire, mort rapide',
    treatment: 'Vaccination préventive essentielle',
    isContagious: false,
    requiresVeterinaryIntervention: true,
    isActive: true,
  ),

  DiseaseReference(
    id: 'disease-tetanos',
    farmId: 'mock-farm-001',
    name: 'Tétanos',
    scientificName: 'Clostridium tetani',
    description: 'Maladie bactérienne neurotoxique',
    targetSpecies: [
      DiseaseTargetSpecies.bovine,
      DiseaseTargetSpecies.ovine,
      DiseaseTargetSpecies.caprine
    ],
    symptoms: 'Rigidité musculaire, contractures, hypersensibilité',
    treatment: 'Vaccination préventive. Pronostic réservé si atteint.',
    isContagious: false,
    requiresVeterinaryIntervention: true,
    isActive: true,
  ),

  // === MALADIES PARASITAIRES ===
  DiseaseReference(
    id: 'disease-strongyloses',
    farmId: 'mock-farm-001',
    name: 'Strongyloses gastro-intestinales',
    scientificName: 'Haemonchus, Ostertagia, Trichostrongylus',
    description: 'Parasitisme digestif par strongles',
    targetSpecies: [
      DiseaseTargetSpecies.ovine,
      DiseaseTargetSpecies.bovine,
      DiseaseTargetSpecies.caprine
    ],
    symptoms: 'Diarrhée, anémie, amaigrissement, baisse de production',
    treatment: 'Vermifugation stratégique, gestion pâturage',
    isContagious: true,
    requiresVeterinaryIntervention: false,
    isActive: true,
  ),

  DiseaseReference(
    id: 'disease-fasciolose',
    farmId: 'mock-farm-001',
    name: 'Fasciolose (Grande Douve)',
    scientificName: 'Fasciola hepatica',
    description: 'Parasitose hépatique',
    targetSpecies: [
      DiseaseTargetSpecies.ovine,
      DiseaseTargetSpecies.bovine,
      DiseaseTargetSpecies.caprine
    ],
    symptoms: 'Anémie, amaigrissement, œdème, troubles hépatiques',
    treatment: 'Antiparasitaires spécifiques, drainage des zones humides',
    isContagious: true,
    requiresVeterinaryIntervention: false,
    isActive: true,
  ),

  DiseaseReference(
    id: 'disease-coccidiose',
    farmId: 'mock-farm-001',
    name: 'Coccidiose',
    scientificName: 'Eimeria spp.',
    description: 'Parasitose intestinale des jeunes',
    targetSpecies: [
      DiseaseTargetSpecies.ovine,
      DiseaseTargetSpecies.bovine,
      DiseaseTargetSpecies.caprine
    ],
    symptoms: 'Diarrhée hémorragique, déshydratation, retard croissance',
    treatment: 'Anticoccidiens, réhydratation, hygiène',
    isContagious: true,
    requiresVeterinaryIntervention: false,
    isActive: true,
  ),

  // === AUTRES MALADIES ===
  DiseaseReference(
    id: 'disease-meteorisation',
    farmId: 'mock-farm-001',
    name: 'Météorisation',
    description: 'Gonflement du rumen par fermentation excessive',
    targetSpecies: [
      DiseaseTargetSpecies.bovine,
      DiseaseTargetSpecies.ovine,
      DiseaseTargetSpecies.caprine
    ],
    symptoms: 'Gonflement abdomen gauche, détresse respiratoire',
    treatment: 'Urgence vétérinaire. Ponction rumen si sévère.',
    isContagious: false,
    requiresVeterinaryIntervention: true,
    isActive: true,
  ),

  DiseaseReference(
    id: 'disease-mammite',
    farmId: 'mock-farm-001',
    name: 'Mammite',
    description: 'Inflammation de la mamelle',
    targetSpecies: [
      DiseaseTargetSpecies.bovine,
      DiseaseTargetSpecies.ovine,
      DiseaseTargetSpecies.caprine
    ],
    symptoms: 'Mamelle chaude, dure, lait modifié, fièvre possible',
    treatment: 'Antibiotiques, anti-inflammatoires, traite fréquente',
    isContagious: true,
    requiresVeterinaryIntervention: true,
    isActive: true,
  ),

  DiseaseReference(
    id: 'disease-acidose',
    farmId: 'mock-farm-001',
    name: 'Acidose ruminale',
    description: 'Déséquilibre pH ruminal',
    targetSpecies: [
      DiseaseTargetSpecies.bovine,
      DiseaseTargetSpecies.ovine,
      DiseaseTargetSpecies.caprine
    ],
    symptoms: 'Inappétence, diarrhée, boiteries, baisse production',
    treatment: 'Réajustement ration, tampons ruminaux',
    isContagious: false,
    requiresVeterinaryIntervention: false,
    isActive: true,
  ),
];

class MockDiseaseStats {
  static int get totalDiseases => mockDiseases.length;

  static int get bovineDiseases =>
      mockDiseases.where((d) => d.isCompatibleWith('bovine')).length;

  static int get ovineDiseases =>
      mockDiseases.where((d) => d.isCompatibleWith('ovine')).length;

  static int get caprineDiseases =>
      mockDiseases.where((d) => d.isCompatibleWith('caprine')).length;

  static int get contagiousDiseases =>
      mockDiseases.where((d) => d.isContagious).length;

  static int get requiresVet =>
      mockDiseases.where((d) => d.requiresVeterinaryIntervention).length;
}
