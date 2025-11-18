// lib/services/performance/seed_data_service.dart

import 'dart:math';
import 'package:uuid/uuid.dart';
import '../../models/animal.dart';
import '../../models/movement.dart';
import '../../models/lot.dart';
import '../../models/treatment.dart';
import '../../models/vaccination.dart';
import '../../models/weight_record.dart';
import '../../repositories/animal_repository.dart';
import '../../repositories/movement_repository.dart';
import '../../repositories/lot_repository.dart';
import '../../repositories/treatment_repository.dart';
import '../../repositories/vaccination_repository.dart';
import '../../repositories/weight_repository.dart';
import '../../utils/constants.dart';

/// Service pour générer des données de test pour les benchmarks de performance
///
/// Génère des données réalistes pour simuler une grande ferme:
/// - Light mode: 1000 animaux
/// - Full mode: 5000 animaux
class SeedDataService {
  final AnimalRepository _animalRepository;
  final MovementRepository _movementRepository;
  final LotRepository _lotRepository;
  final TreatmentRepository _treatmentRepository;
  final VaccinationRepository _vaccinationRepository;
  final WeightRepository _weightRepository;

  final _uuid = const Uuid();
  final _random = Random();

  SeedDataService({
    required AnimalRepository animalRepository,
    required MovementRepository movementRepository,
    required LotRepository lotRepository,
    required TreatmentRepository treatmentRepository,
    required VaccinationRepository vaccinationRepository,
    required WeightRepository weightRepository,
  })  : _animalRepository = animalRepository,
        _movementRepository = movementRepository,
        _lotRepository = lotRepository,
        _treatmentRepository = treatmentRepository,
        _vaccinationRepository = vaccinationRepository,
        _weightRepository = weightRepository;

  /// Génère toutes les données de test
  ///
  /// Returns: Map avec les compteurs de données générées
  Future<Map<String, int>> generateAllData(String farmId) async {
    final isLightMode = AppConstants.kBenchmarkLightMode;

    final animalCount = isLightMode
        ? AppConstants.benchmarkLightAnimals
        : AppConstants.benchmarkFullAnimals;
    final movementCount = isLightMode
        ? AppConstants.benchmarkLightMovements
        : AppConstants.benchmarkFullMovements;
    final lotCount = isLightMode
        ? AppConstants.benchmarkLightLots
        : AppConstants.benchmarkFullLots;
    final treatmentCount = isLightMode
        ? AppConstants.benchmarkLightTreatments
        : AppConstants.benchmarkFullTreatments;
    final vaccinationCount = isLightMode
        ? AppConstants.benchmarkLightVaccinations
        : AppConstants.benchmarkFullVaccinations;
    final weightCount = isLightMode
        ? AppConstants.benchmarkLightWeights
        : AppConstants.benchmarkFullWeights;

    print('═══════════════════════════════════════');
    print('SEED DATA GENERATION - ${isLightMode ? "LIGHT" : "FULL"} MODE');
    print('═══════════════════════════════════════');

    // 1. Générer les animaux
    print('Generating $animalCount animals...');
    final animalIds = await _generateAnimals(farmId, animalCount);
    print('✓ Animals generated: ${animalIds.length}');

    // 2. Générer les lots
    print('Generating $lotCount lots...');
    final lotIds = await _generateLots(farmId, lotCount, animalIds);
    print('✓ Lots generated: ${lotIds.length}');

    // 3. Générer les mouvements
    print('Generating $movementCount movements...');
    final movementIds =
        await _generateMovements(farmId, movementCount, animalIds);
    print('✓ Movements generated: ${movementIds.length}');

    // 4. Générer les traitements
    print('Generating $treatmentCount treatments...');
    final treatmentIds =
        await _generateTreatments(farmId, treatmentCount, animalIds);
    print('✓ Treatments generated: ${treatmentIds.length}');

    // 5. Générer les vaccinations
    print('Generating $vaccinationCount vaccinations...');
    final vaccinationIds =
        await _generateVaccinations(farmId, vaccinationCount, animalIds);
    print('✓ Vaccinations generated: ${vaccinationIds.length}');

    // 6. Générer les pesées
    print('Generating $weightCount weights...');
    final weightIds = await _generateWeights(farmId, weightCount, animalIds);
    print('✓ Weights generated: ${weightIds.length}');

    print('═══════════════════════════════════════');
    print('SEED DATA COMPLETE');
    print('═══════════════════════════════════════');

    return {
      'animals': animalIds.length,
      'lots': lotIds.length,
      'movements': movementIds.length,
      'treatments': treatmentIds.length,
      'vaccinations': vaccinationIds.length,
      'weights': weightIds.length,
    };
  }

  /// Génère des animaux de test
  Future<List<String>> _generateAnimals(String farmId, int count) async {
    final animalIds = <String>[];
    final species = ['sheep', 'cattle', 'goat'];
    final breeds = {
      'sheep': ['merinos', 'suffolk', 'dorper'],
      'cattle': ['charolaise', 'limousine', 'angus'],
      'goat': ['alpine', 'saanen', 'boer'],
    };

    for (int i = 0; i < count; i++) {
      final id = _uuid.v4();
      final speciesId = species[_random.nextInt(species.length)];
      final breedList = breeds[speciesId]!;
      final breedId = breedList[_random.nextInt(breedList.length)];

      final animal = Animal(
        id: id,
        farmId: farmId,
        currentEid: 'EID_${i.toString().padLeft(6, '0')}',
        officialNumber: 'FR${_random.nextInt(999999999).toString().padLeft(9, '0')}',
        birthDate: DateTime.now().subtract(Duration(days: _random.nextInt(1825) + 30)),
        sex: _random.nextBool() ? AnimalSex.male : AnimalSex.female,
        status: AnimalStatus.alive,
        validatedAt: DateTime.now().subtract(Duration(days: _random.nextInt(365))),
        speciesId: speciesId,
        breedId: breedId,
        visualId: 'V${i.toString().padLeft(4, '0')}',
        synced: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _animalRepository.create(animal, farmId);
      animalIds.add(id);

      // Progress log every 100 animals
      if ((i + 1) % 100 == 0) {
        print('  Animals: ${i + 1}/$count');
      }
    }

    return animalIds;
  }

  /// Génère des lots de test
  Future<List<String>> _generateLots(
    String farmId,
    int count,
    List<String> animalIds,
  ) async {
    final lotIds = <String>[];
    final lotTypes = LotType.values;

    for (int i = 0; i < count; i++) {
      final id = _uuid.v4();
      final type = lotTypes[_random.nextInt(lotTypes.length)];

      // Assigner 5-20 animaux par lot
      final lotAnimalCount = _random.nextInt(16) + 5;
      final lotAnimalIds = <String>[];
      for (int j = 0; j < lotAnimalCount && j < animalIds.length; j++) {
        final randomIndex = _random.nextInt(animalIds.length);
        if (!lotAnimalIds.contains(animalIds[randomIndex])) {
          lotAnimalIds.add(animalIds[randomIndex]);
        }
      }

      final lot = Lot(
        id: id,
        farmId: farmId,
        name: 'Lot ${type.name} #${i + 1}',
        type: type,
        animalIds: lotAnimalIds,
        status: _random.nextInt(10) < 8 ? LotStatus.open : LotStatus.closed,
        completed: false,
        synced: false,
        createdAt: DateTime.now().subtract(Duration(days: _random.nextInt(365))),
        updatedAt: DateTime.now(),
      );

      await _lotRepository.create(lot, farmId);
      lotIds.add(id);

      // Progress log every 50 lots
      if ((i + 1) % 50 == 0) {
        print('  Lots: ${i + 1}/$count');
      }
    }

    return lotIds;
  }

  /// Génère des mouvements de test
  Future<List<String>> _generateMovements(
    String farmId,
    int count,
    List<String> animalIds,
  ) async {
    final movementIds = <String>[];
    final movementTypes = [
      MovementType.birth,
      MovementType.purchase,
      MovementType.sale,
      MovementType.death,
    ];

    for (int i = 0; i < count; i++) {
      final id = _uuid.v4();
      final animalId = animalIds[_random.nextInt(animalIds.length)];
      final type = movementTypes[_random.nextInt(movementTypes.length)];

      final movement = Movement(
        id: id,
        farmId: farmId,
        animalId: animalId,
        type: type,
        movementDate: DateTime.now().subtract(Duration(days: _random.nextInt(365))),
        price: type == MovementType.sale || type == MovementType.purchase
            ? (_random.nextDouble() * 500 + 100)
            : null,
        notes: 'Benchmark movement #${i + 1}',
        synced: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _movementRepository.create(movement, farmId);
      movementIds.add(id);

      // Progress log every 500 movements
      if ((i + 1) % 500 == 0) {
        print('  Movements: ${i + 1}/$count');
      }
    }

    return movementIds;
  }

  /// Génère des traitements de test
  Future<List<String>> _generateTreatments(
    String farmId,
    int count,
    List<String> animalIds,
  ) async {
    final treatmentIds = <String>[];
    final products = [
      ('prod_ivermectine', 'Ivermectine'),
      ('prod_oxytetracycline', 'Oxytétracycline'),
      ('prod_penicilline', 'Pénicilline'),
      ('prod_flunixine', 'Flunixine'),
      ('prod_dexamethasone', 'Dexaméthasone'),
    ];

    for (int i = 0; i < count; i++) {
      final id = _uuid.v4();
      final animalId = animalIds[_random.nextInt(animalIds.length)];
      final product = products[_random.nextInt(products.length)];
      final treatmentDate =
          DateTime.now().subtract(Duration(days: _random.nextInt(90)));
      final withdrawalDays = _random.nextInt(21) + 7;

      final treatment = Treatment(
        id: id,
        farmId: farmId,
        animalId: animalId,
        productId: product.$1,
        productName: product.$2,
        dose: (_random.nextInt(10) + 1).toDouble(),
        treatmentDate: treatmentDate,
        withdrawalEndDate: treatmentDate.add(Duration(days: withdrawalDays)),
        veterinarianName: 'Dr. Benchmark #${_random.nextInt(10)}',
        notes: 'Benchmark treatment #${i + 1}',
        synced: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _treatmentRepository.create(treatment, farmId);
      treatmentIds.add(id);

      // Progress log every 200 treatments
      if ((i + 1) % 200 == 0) {
        print('  Treatments: ${i + 1}/$count');
      }
    }

    return treatmentIds;
  }

  /// Génère des vaccinations de test
  Future<List<String>> _generateVaccinations(
    String farmId,
    int count,
    List<String> animalIds,
  ) async {
    final vaccinationIds = <String>[];
    final vaccines = [
      ('Fièvre aphteuse', 'Fièvre aphteuse'),
      ('Charbon bactéridien', 'Charbon'),
      ('Entérotoxémie', 'Entérotoxémie'),
      ('Pasteurellose', 'Pasteurellose'),
      ('Rage', 'Rage'),
    ];
    final routes = ['IM', 'SC', 'IV'];
    final types = VaccinationType.values;

    for (int i = 0; i < count; i++) {
      final id = _uuid.v4();
      final animalId = animalIds[_random.nextInt(animalIds.length)];
      final vaccine = vaccines[_random.nextInt(vaccines.length)];
      final vaccinationDate =
          DateTime.now().subtract(Duration(days: _random.nextInt(180)));

      final vaccination = Vaccination(
        id: id,
        farmId: farmId,
        animalId: animalId,
        vaccineName: vaccine.$1,
        disease: vaccine.$2,
        type: types[_random.nextInt(types.length)],
        dose: '${_random.nextInt(5) + 1} ml',
        administrationRoute: routes[_random.nextInt(routes.length)],
        vaccinationDate: vaccinationDate,
        nextDueDate: vaccinationDate.add(Duration(days: _random.nextInt(180) + 90)),
        veterinarianName: 'Dr. Vaccine #${_random.nextInt(10)}',
        batchNumber: 'BATCH${_random.nextInt(999999).toString().padLeft(6, '0')}',
        notes: 'Benchmark vaccination #${i + 1}',
        synced: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _vaccinationRepository.create(vaccination, farmId);
      vaccinationIds.add(id);

      // Progress log every 200 vaccinations
      if ((i + 1) % 200 == 0) {
        print('  Vaccinations: ${i + 1}/$count');
      }
    }

    return vaccinationIds;
  }

  /// Génère des pesées de test
  Future<List<String>> _generateWeights(
    String farmId,
    int count,
    List<String> animalIds,
  ) async {
    final weightIds = <String>[];

    for (int i = 0; i < count; i++) {
      final id = _uuid.v4();
      final animalId = animalIds[_random.nextInt(animalIds.length)];

      final weightRecord = WeightRecord(
        id: id,
        farmId: farmId,
        animalId: animalId,
        weight: _random.nextDouble() * 150 + 20, // 20-170 kg
        recordedAt: DateTime.now().subtract(Duration(days: _random.nextInt(365))),
        source: WeightSource.manual,
        notes: 'Benchmark weight #${i + 1}',
        synced: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _weightRepository.create(weightRecord, farmId);
      weightIds.add(id);

      // Progress log every 1000 weights
      if ((i + 1) % 1000 == 0) {
        print('  Weights: ${i + 1}/$count');
      }
    }

    return weightIds;
  }
}
