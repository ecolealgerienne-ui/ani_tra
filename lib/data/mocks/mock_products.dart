// lib/data/mocks/mock_products.dart

import '../../models/product.dart';

/// Données de test pour les produits sanitaires
class MockProducts {
  static List<Product> generateProducts() {
    return [
      Product(
        id: 'product_001',
        name: 'Ivermectine 1%',
        activeSubstance: 'Ivermectine',
        withdrawalDaysMeat: 16,
        withdrawalDaysMilk: 5,
        dosagePerKg: 0.2,
      
        farmId: 'farm_default',),
      Product(
        id: 'product_002',
        name: 'Vaccin Entérotoxémie',
        activeSubstance: 'Clostridium perfringens',
        withdrawalDaysMeat: 0,
        withdrawalDaysMilk: 0,
        dosagePerKg: 2.0,
      
        farmId: 'farm_default',),
      Product(
        id: 'product_003',
        name: 'Oxytétracycline LA',
        activeSubstance: 'Oxytétracycline',
        withdrawalDaysMeat: 28,
        withdrawalDaysMilk: 7,
        dosagePerKg: 20.0,
      
        farmId: 'farm_default',),
      Product(
        id: 'product_004',
        name: 'Doramectine',
        activeSubstance: 'Doramectine',
        withdrawalDaysMeat: 35,
        withdrawalDaysMilk: 7,
        dosagePerKg: 0.3,
      
        farmId: 'farm_default',),
      Product(
        id: 'product_005',
        name: 'Pénicilline G',
        activeSubstance: 'Benzylpénicilline',
        withdrawalDaysMeat: 10,
        withdrawalDaysMilk: 3,
        dosagePerKg: 15.0,
      
        farmId: 'farm_default',),
      Product(
        id: 'product_006',
        name: 'Vaccin Pasteurellose',
        activeSubstance: 'Pasteurella haemolytica',
        withdrawalDaysMeat: 0,
        withdrawalDaysMilk: 0,
        dosagePerKg: 2.0,
      
        farmId: 'farm_default',),
      Product(
        id: 'product_007',
        name: 'Méloxicam',
        activeSubstance: 'Méloxicam',
        withdrawalDaysMeat: 5,
        withdrawalDaysMilk: 0,
        dosagePerKg: 0.5,
      
        farmId: 'farm_default',),
      Product(
        id: 'product_008',
        name: 'Albendazole',
        activeSubstance: 'Albendazole',
        withdrawalDaysMeat: 14,
        withdrawalDaysMilk: 4,
        dosagePerKg: 5.0,
      
        farmId: 'farm_default',),
      Product(
        id: 'product_009',
        name: 'Closantel',
        activeSubstance: 'Closantel',
        withdrawalDaysMeat: 28,
        withdrawalDaysMilk: 14,
        dosagePerKg: 10.0,
      
        farmId: 'farm_default',),
      Product(
        id: 'product_010',
        name: 'Vaccin Fièvre Q',
        activeSubstance: 'Coxiella burnetii',
        withdrawalDaysMeat: 0,
        withdrawalDaysMilk: 0,
        dosagePerKg: 2.0,
      
        farmId: 'farm_default',),
    ];
  }
}
