// lib/data/mocks/mock_vaccination_references.dart

import '../../models/vaccine_reference.dart';
import '../../models/disease_reference.dart';
import '../../models/administration_route.dart';

class MockVaccinationReferences {
  static const String farmId = 'farm_default';

  static List<VaccineReference> generateVaccines() {
    return [
      VaccineReference(
        id: 'vacc_ref_001',
        farmId: farmId,
        name: 'Entérotoxémie Vaccin',
        description: 'Protection contre entérotoxémie types C et D',
        manufacturer: 'Ceva',
      ),
      VaccineReference(
        id: 'vacc_ref_002',
        farmId: farmId,
        name: 'Pasteurellose Vaccin',
        description: 'Prévention pasteurellose respiratoire',
        manufacturer: 'MSD',
      ),
      VaccineReference(
        id: 'vacc_ref_003',
        farmId: farmId,
        name: 'Fièvre Aphteuse Vaccin',
        description: 'Protection contre fièvre aphteuse',
        manufacturer: 'Merial',
      ),
      VaccineReference(
        id: 'vacc_ref_004',
        farmId: farmId,
        name: 'Charbon Bactérien',
        description: 'Vaccin contre le charbon bactérien',
      ),
      VaccineReference(
        id: 'vacc_ref_005',
        farmId: farmId,
        name: 'Clostridiose',
        description: 'Vaccin polyvalent clostridioses',
      ),
      VaccineReference(
        id: 'vacc_ref_006',
        farmId: farmId,
        name: 'Agalaxie Contagieuse',
        description: 'Protection agalaxie contagieuse ovins/caprins',
      ),
      VaccineReference(
        id: 'vacc_ref_007',
        farmId: farmId,
        name: 'Chlamydiose',
        description: 'Prévention avortements chlamydiens',
      ),
      VaccineReference(
        id: 'vacc_ref_008',
        farmId: farmId,
        name: 'Salmonellose',
        description: 'Vaccin contre salmonellose',
      ),
      VaccineReference(
        id: 'vacc_ref_009',
        farmId: farmId,
        name: 'Ecthyma Contagieux',
        description: 'Protection ecthyma contagieux (orf)',
      ),
      VaccineReference(
        id: 'vacc_ref_010',
        farmId: farmId,
        name: 'Piétin',
        description: 'Vaccin contre le piétin',
      ),
      VaccineReference(
        id: 'vacc_ref_011',
        farmId: farmId,
        name: 'IBR Vaccin',
        description: 'Rhinotrachéite infectieuse bovine',
        manufacturer: 'Boehringer',
      ),
      VaccineReference(
        id: 'vacc_ref_012',
        farmId: farmId,
        name: 'BVD Vaccin',
        description: 'Diarrhée virale bovine',
        manufacturer: 'Zoetis',
      ),
      VaccineReference(
        id: 'vacc_ref_013',
        farmId: farmId,
        name: 'Paratuberculose',
        description: 'Protection contre paratuberculose',
      ),
      VaccineReference(
        id: 'vacc_ref_014',
        farmId: farmId,
        name: 'Brucellose',
        description: 'Vaccin brucellose (selon réglementation)',
      ),
      VaccineReference(
        id: 'vacc_ref_015',
        farmId: farmId,
        name: 'Rage Vaccin',
        description: 'Protection contre la rage',
      ),
      VaccineReference(
        id: 'vacc_ref_016',
        farmId: farmId,
        name: 'Autre',
        description: 'Autre vaccin non listé',
      ),
    ];
  }

  static List<DiseaseReference> generateDiseases() {
    return [
      DiseaseReference(
        id: 'disease_001',
        farmId: farmId,
        name: 'Entérotoxémie',
        description: 'Maladie clostridiose types C et D',
        scientificName: 'Clostridium perfringens',
      ),
      DiseaseReference(
        id: 'disease_002',
        farmId: farmId,
        name: 'Pasteurellose',
        description: 'Infection respiratoire bactérienne',
        scientificName: 'Pasteurella multocida',
      ),
      DiseaseReference(
        id: 'disease_003',
        farmId: farmId,
        name: 'Fièvre Aphteuse',
        description: 'Maladie virale contagieuse',
        scientificName: 'Aphthovirus',
      ),
      DiseaseReference(
        id: 'disease_004',
        farmId: farmId,
        name: 'Charbon Bactérien',
        description: 'Maladie bactérienne aiguë',
        scientificName: 'Bacillus anthracis',
      ),
      DiseaseReference(
        id: 'disease_005',
        farmId: farmId,
        name: 'Clostridiose',
        description: 'Groupe maladies clostridies',
      ),
      DiseaseReference(
        id: 'disease_006',
        farmId: farmId,
        name: 'Agalaxie Contagieuse',
        description: 'Infection mammaire mycoplasmes',
        scientificName: 'Mycoplasma agalactiae',
      ),
      DiseaseReference(
        id: 'disease_007',
        farmId: farmId,
        name: 'Chlamydiose',
        description: 'Avortements enzootiques',
        scientificName: 'Chlamydia abortus',
      ),
      DiseaseReference(
        id: 'disease_008',
        farmId: farmId,
        name: 'Salmonellose',
        description: 'Infection salmonelles',
        scientificName: 'Salmonella spp.',
      ),
      DiseaseReference(
        id: 'disease_009',
        farmId: farmId,
        name: 'Ecthyma Contagieux',
        description: 'Dermatite pustuleuse contagieuse',
        scientificName: 'Parapoxvirus ovis',
      ),
      DiseaseReference(
        id: 'disease_010',
        farmId: farmId,
        name: 'Piétin',
        description: 'Dermatite interdigitale',
        scientificName: 'Dichelobacter nodosus',
      ),
      DiseaseReference(
        id: 'disease_011',
        farmId: farmId,
        name: 'IBR',
        description: 'Rhinotrachéite infectieuse bovine',
        scientificName: 'BoHV-1',
      ),
      DiseaseReference(
        id: 'disease_012',
        farmId: farmId,
        name: 'BVD',
        description: 'Diarrhée virale bovine',
        scientificName: 'Pestivirus',
      ),
      DiseaseReference(
        id: 'disease_013',
        farmId: farmId,
        name: 'Paratuberculose',
        description: 'Entérite chronique',
        scientificName: 'Mycobacterium avium paratuberculosis',
      ),
      DiseaseReference(
        id: 'disease_014',
        farmId: farmId,
        name: 'Brucellose',
        description: 'Maladie abortive réglementée',
        scientificName: 'Brucella melitensis',
      ),
      DiseaseReference(
        id: 'disease_015',
        farmId: farmId,
        name: 'Rage',
        description: 'Encéphalite virale mortelle',
        scientificName: 'Lyssavirus',
      ),
      DiseaseReference(
        id: 'disease_016',
        farmId: farmId,
        name: 'Autre',
        description: 'Autre maladie non listée',
      ),
    ];
  }

  static List<AdministrationRoute> generateRoutes() {
    return [
      AdministrationRoute(
        id: 'route_001',
        farmId: farmId,
        code: 'IM',
        description: 'Intramusculaire',
      ),
      AdministrationRoute(
        id: 'route_002',
        farmId: farmId,
        code: 'SC',
        description: 'Sous-cutanée',
      ),
      AdministrationRoute(
        id: 'route_003',
        farmId: farmId,
        code: 'ID',
        description: 'Intradermique',
      ),
      AdministrationRoute(
        id: 'route_004',
        farmId: farmId,
        code: 'IV',
        description: 'Intraveineuse',
      ),
      AdministrationRoute(
        id: 'route_005',
        farmId: farmId,
        code: 'PO',
        description: 'Per os (orale)',
      ),
      AdministrationRoute(
        id: 'route_006',
        farmId: farmId,
        code: 'IN',
        description: 'Intranasale',
      ),
      AdministrationRoute(
        id: 'route_007',
        farmId: farmId,
        code: 'Autre',
        description: 'Autre voie',
      ),
    ];
  }
}
