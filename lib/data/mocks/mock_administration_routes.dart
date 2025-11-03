// lib/mock/mock_administration_routes.dart

import '../../models/administration_route.dart';

final List<AdministrationRoute> mockAdministrationRoutes = [
  // === VOIES PARENTÉRALES (INJECTIONS) ===
  AdministrationRoute(
    id: 'route-im',
    farmId: 'mock-farm-001',
    code: 'IM',
    description: 'Intramusculaire',
    targetSpecies: [], // Toutes espèces
    isActive: true,
  ),

  AdministrationRoute(
    id: 'route-sc',
    farmId: 'mock-farm-001',
    code: 'SC',
    description: 'Sous-cutanée',
    targetSpecies: [], // Toutes espèces
    isActive: true,
  ),

  AdministrationRoute(
    id: 'route-id',
    farmId: 'mock-farm-001',
    code: 'ID',
    description: 'Intradermique',
    targetSpecies: [], // Toutes espèces
    isActive: true,
  ),

  AdministrationRoute(
    id: 'route-iv',
    farmId: 'mock-farm-001',
    code: 'IV',
    description: 'Intraveineuse',
    targetSpecies: [], // Toutes espèces
    isActive: true,
  ),

  AdministrationRoute(
    id: 'route-ip',
    farmId: 'mock-farm-001',
    code: 'IP',
    description: 'Intrapéritonéale',
    targetSpecies: [], // Toutes espèces
    isActive: true,
  ),

  // === VOIES LOCALES ===
  AdministrationRoute(
    id: 'route-topique',
    farmId: 'mock-farm-001',
    code: 'TOPIQUE',
    description: 'Application locale/cutanée',
    targetSpecies: [], // Toutes espèces
    isActive: true,
  ),

  AdministrationRoute(
    id: 'route-oculaire',
    farmId: 'mock-farm-001',
    code: 'OCULAIRE',
    description: 'Application oculaire',
    targetSpecies: [], // Toutes espèces
    isActive: true,
  ),

  AdministrationRoute(
    id: 'route-auriculaire',
    farmId: 'mock-farm-001',
    code: 'AURICULAIRE',
    description: 'Application auriculaire',
    targetSpecies: [], // Toutes espèces
    isActive: true,
  ),

  // === VOIES DIGESTIVES ===
  AdministrationRoute(
    id: 'route-orale',
    farmId: 'mock-farm-001',
    code: 'PO',
    description: 'Per os (orale)',
    targetSpecies: [], // Toutes espèces
    isActive: true,
  ),

  AdministrationRoute(
    id: 'route-ruminale',
    farmId: 'mock-farm-001',
    code: 'RUMINALE',
    description: 'Intraruminale',
    targetSpecies: ['bovine', 'ovine', 'caprine'], // Ruminants uniquement
    isActive: true,
  ),

  // === VOIES RESPIRATOIRES ===
  AdministrationRoute(
    id: 'route-intranasale',
    farmId: 'mock-farm-001',
    code: 'IN',
    description: 'Intranasale',
    targetSpecies: [], // Toutes espèces
    isActive: true,
  ),

  AdministrationRoute(
    id: 'route-inhalation',
    farmId: 'mock-farm-001',
    code: 'INHAL',
    description: 'Inhalation/Aérosol',
    targetSpecies: [], // Toutes espèces
    isActive: true,
  ),

  // === VOIES GÉNITALES ===
  AdministrationRoute(
    id: 'route-intrauterine',
    farmId: 'mock-farm-001',
    code: 'IU',
    description: 'Intra-utérine',
    targetSpecies: [], // Toutes espèces
    isActive: true,
  ),

  AdministrationRoute(
    id: 'route-intravaginale',
    farmId: 'mock-farm-001',
    code: 'IVAG',
    description: 'Intravaginale',
    targetSpecies: [], // Toutes espèces
    isActive: true,
  ),

  // === VOIES MAMMAIRES ===
  AdministrationRoute(
    id: 'route-intramammaire',
    farmId: 'mock-farm-001',
    code: 'IMAM',
    description: 'Intramammaire',
    targetSpecies: ['bovine', 'ovine', 'caprine'], // Ruminants laitiers
    isActive: true,
  ),

  // === AUTRES VOIES ===
  AdministrationRoute(
    id: 'route-pour-on',
    farmId: 'mock-farm-001',
    code: 'POUR-ON',
    description: 'Pour-on (application dorsale)',
    targetSpecies: [], // Toutes espèces
    isActive: true,
  ),

  AdministrationRoute(
    id: 'route-spot-on',
    farmId: 'mock-farm-001',
    code: 'SPOT-ON',
    description: 'Spot-on (application ponctuelle)',
    targetSpecies: [], // Toutes espèces
    isActive: true,
  ),

  AdministrationRoute(
    id: 'route-bolus',
    farmId: 'mock-farm-001',
    code: 'BOLUS',
    description: 'Bolus intraruminal',
    targetSpecies: ['bovine', 'ovine', 'caprine'], // Ruminants uniquement
    isActive: true,
  ),
];

class MockAdministrationRouteStats {
  static int get totalRoutes => mockAdministrationRoutes.length;

  static int get allSpeciesRoutes =>
      mockAdministrationRoutes.where((r) => r.targetSpecies.isEmpty).length;

  static int get ruminantOnlyRoutes =>
      mockAdministrationRoutes.where((r) => r.targetSpecies.isNotEmpty).length;

  static List<AdministrationRoute> getRoutesForSpecies(String species) {
    return mockAdministrationRoutes
        .where((r) => r.isCompatibleWith(species))
        .toList();
  }

  static List<AdministrationRoute> getInjectableRoutes() {
    return mockAdministrationRoutes
        .where((r) =>
            r.code == 'IM' ||
            r.code == 'SC' ||
            r.code == 'ID' ||
            r.code == 'IV' ||
            r.code == 'IP')
        .toList();
  }
}
