// lib/services/performance/benchmark_service.dart

import '../../providers/animal_provider.dart';
import '../../providers/movement_provider.dart';
import '../../providers/lot_provider.dart';
import '../../providers/treatment_provider.dart';
import '../../providers/vaccination_provider.dart';
import '../../providers/weight_provider.dart';
import '../../providers/alert_provider.dart';
import '../../repositories/animal_repository.dart';
import '../../repositories/lot_repository.dart';
import '../../models/animal.dart';
import '../../utils/constants.dart';

/// Résultat d'un benchmark individuel
class BenchmarkResult {
  final String name;
  final int durationMs;
  final int targetMs;
  final bool passed;
  final String? error;

  BenchmarkResult({
    required this.name,
    required this.durationMs,
    required this.targetMs,
    required this.passed,
    this.error,
  });

  String get status => passed ? 'PASS' : 'FAIL';
}

/// Service pour exécuter les benchmarks de performance
///
/// Teste les opérations critiques:
/// - Chargement des données (load)
/// - Génération d'alertes
/// - Requêtes de recherche
/// - Opérations batch
class BenchmarkService {
  final AnimalProvider _animalProvider;
  final MovementProvider _movementProvider;
  final LotProvider _lotProvider;
  final TreatmentProvider _treatmentProvider;
  final VaccinationProvider _vaccinationProvider;
  final WeightProvider _weightProvider;
  final AlertProvider _alertProvider;
  final AnimalRepository _animalRepository;
  final LotRepository _lotRepository;

  BenchmarkService({
    required AnimalProvider animalProvider,
    required MovementProvider movementProvider,
    required LotProvider lotProvider,
    required TreatmentProvider treatmentProvider,
    required VaccinationProvider vaccinationProvider,
    required WeightProvider weightProvider,
    required AlertProvider alertProvider,
    required AnimalRepository animalRepository,
    required LotRepository lotRepository,
  })  : _animalProvider = animalProvider,
        _movementProvider = movementProvider,
        _lotProvider = lotProvider,
        _treatmentProvider = treatmentProvider,
        _vaccinationProvider = vaccinationProvider,
        _weightProvider = weightProvider,
        _alertProvider = alertProvider,
        _animalRepository = animalRepository,
        _lotRepository = lotRepository;

  /// Exécute tous les benchmarks et affiche les résultats dans les logs
  Future<List<BenchmarkResult>> runAllBenchmarks(String farmId) async {
    final results = <BenchmarkResult>[];
    final isLightMode = AppConstants.kBenchmarkLightMode;

    print('');
    print('═══════════════════════════════════════');
    print('PERFORMANCE BENCHMARK - ${DateTime.now().toIso8601String().split('T')[0]}');
    print('Mode: ${isLightMode ? "LIGHT (1000 animals)" : "FULL (5000 animals)"}');
    print('═══════════════════════════════════════');
    print('');

    // 1. Load Animals
    results.add(await _benchmarkLoadAnimals(farmId));

    // 2. Load Movements
    results.add(await _benchmarkLoadMovements(farmId));

    // 3. Load Lots
    results.add(await _benchmarkLoadLots(farmId));

    // 4. Load Weights
    results.add(await _benchmarkLoadWeights(farmId));

    // 5. Generate Alerts
    results.add(await _benchmarkGenerateAlerts());

    // 6. Find by EID
    results.add(await _benchmarkFindByEID());

    // 7. Find Lots by Animal
    results.add(await _benchmarkFindLotsByAnimal(farmId));

    // 8. Count Stats
    results.add(await _benchmarkCountStats(farmId));

    // 9. Batch Create
    results.add(await _benchmarkBatchCreate(farmId));

    // Print summary
    _printSummary(results);

    return results;
  }

  /// Benchmark: Charger tous les animaux
  Future<BenchmarkResult> _benchmarkLoadAnimals(String farmId) async {
    return _runBenchmark(
      name: 'Load Animals',
      target: AppConstants.benchmarkTargetLoadAnimals,
      operation: () async {
        await _animalProvider.loadAnimals(farmId);
      },
    );
  }

  /// Benchmark: Charger tous les mouvements
  Future<BenchmarkResult> _benchmarkLoadMovements(String farmId) async {
    return _runBenchmark(
      name: 'Load Movements',
      target: AppConstants.benchmarkTargetLoadMovements,
      operation: () async {
        await _movementProvider.loadMovements(farmId);
      },
    );
  }

  /// Benchmark: Charger tous les lots
  Future<BenchmarkResult> _benchmarkLoadLots(String farmId) async {
    return _runBenchmark(
      name: 'Load Lots',
      target: AppConstants.benchmarkTargetLoadLots,
      operation: () async {
        await _lotProvider.loadLots(farmId);
      },
    );
  }

  /// Benchmark: Charger toutes les pesées
  Future<BenchmarkResult> _benchmarkLoadWeights(String farmId) async {
    return _runBenchmark(
      name: 'Load Weights',
      target: AppConstants.benchmarkTargetLoadWeights,
      operation: () async {
        await _weightProvider.loadWeights(farmId);
      },
    );
  }

  /// Benchmark: Générer toutes les alertes
  Future<BenchmarkResult> _benchmarkGenerateAlerts() async {
    return _runBenchmark(
      name: 'Generate Alerts',
      target: AppConstants.benchmarkTargetGenerateAlerts,
      operation: () async {
        await _alertProvider.refresh();
      },
    );
  }

  /// Benchmark: Rechercher par EID (10 appels)
  Future<BenchmarkResult> _benchmarkFindByEID() async {
    return _runBenchmark(
      name: 'Find by EID (10x)',
      target: AppConstants.benchmarkTargetFindByEID,
      operation: () async {
        final animals = _animalProvider.animals;
        if (animals.isEmpty) return;

        // Faire 10 recherches
        for (int i = 0; i < 10; i++) {
          final randomIndex = i % animals.length;
          final eid = animals[randomIndex].currentEid;
          if (eid != null) {
            _animalProvider.findByEIDOrNumber(eid);
          }
        }
      },
    );
  }

  /// Benchmark: Trouver les lots d'un animal (10 appels)
  Future<BenchmarkResult> _benchmarkFindLotsByAnimal(String farmId) async {
    return _runBenchmark(
      name: 'Find Lots by Animal (10x)',
      target: AppConstants.benchmarkTargetFindLotsByAnimal,
      operation: () async {
        final animals = _animalProvider.animals;
        if (animals.isEmpty) return;

        // Faire 10 recherches
        for (int i = 0; i < 10; i++) {
          final randomIndex = i % animals.length;
          final animalId = animals[randomIndex].id;
          await _lotRepository.findByAnimalId(animalId, farmId);
        }
      },
    );
  }

  /// Benchmark: Calculer les statistiques (compteurs)
  Future<BenchmarkResult> _benchmarkCountStats(String farmId) async {
    return _runBenchmark(
      name: 'Count Stats',
      target: AppConstants.benchmarkTargetCountStats,
      operation: () async {
        // Simuler les stats affichées sur Home
        _animalProvider.animals
            .where((a) => a.status == AnimalStatus.alive)
            .length;
        _alertProvider.urgentAlertCount;
        await _lotRepository.countOpenByFarm(farmId);
      },
    );
  }

  /// Benchmark: Créer 100 animaux en batch
  Future<BenchmarkResult> _benchmarkBatchCreate(String farmId) async {
    return _runBenchmark(
      name: 'Batch Create (100 animals)',
      target: AppConstants.benchmarkTargetBatchCreate,
      operation: () async {
        final animals = <Animal>[];
        for (int i = 0; i < 100; i++) {
          animals.add(Animal(
            farmId: farmId,
            currentEid: 'BENCH_${DateTime.now().millisecondsSinceEpoch}_$i',
            birthDate: DateTime.now().subtract(const Duration(days: 100)),
            sex: AnimalSex.male,
            status: AnimalStatus.alive,
            validatedAt: DateTime.now(),
            speciesId: 'sheep',
            breedId: 'merinos',
          ));
        }

        // Créer en batch
        for (final animal in animals) {
          await _animalRepository.create(animal, farmId);
        }

        // Cleanup: supprimer les animaux créés
        for (final animal in animals) {
          await _animalRepository.delete(animal.id, farmId);
        }
      },
    );
  }

  /// Exécute un benchmark et retourne le résultat
  Future<BenchmarkResult> _runBenchmark({
    required String name,
    required int target,
    required Future<void> Function() operation,
  }) async {
    final stopwatch = Stopwatch()..start();
    String? error;

    try {
      await operation();
    } catch (e) {
      error = e.toString();
    }

    stopwatch.stop();
    final durationMs = stopwatch.elapsedMilliseconds;
    final passed = error == null && durationMs <= target;

    final result = BenchmarkResult(
      name: name,
      durationMs: durationMs,
      targetMs: target,
      passed: passed,
      error: error,
    );

    // Print result immediately
    _printResult(result);

    return result;
  }

  /// Affiche le résultat d'un benchmark
  void _printResult(BenchmarkResult result) {
    final status = result.passed ? '[PASS]' : '[FAIL]';
    final timing = '${result.durationMs}ms (target: <${result.targetMs}ms)';

    if (result.error != null) {
      print('$status ${result.name}: ERROR - ${result.error}');
    } else {
      print('$status ${result.name}: $timing');
    }
  }

  /// Affiche le résumé des benchmarks
  void _printSummary(List<BenchmarkResult> results) {
    final passed = results.where((r) => r.passed).length;
    final total = results.length;
    final allPassed = passed == total;

    print('');
    print('═══════════════════════════════════════');
    print('SUMMARY: $passed/$total tests passed');
    print('Status: ${allPassed ? "ALL PASS" : "SOME FAILED"}');
    print('═══════════════════════════════════════');

    if (!allPassed) {
      print('');
      print('Failed tests:');
      for (final result in results.where((r) => !r.passed)) {
        print('  - ${result.name}: ${result.durationMs}ms > ${result.targetMs}ms');
      }
    }

    print('');
  }
}
