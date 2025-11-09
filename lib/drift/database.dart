// lib/drift/database.dart
// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// ═══════════════════════════════════════════════════════════
// IMPORTS - TABLES
// ═══════════════════════════════════════════════════════════
// Standalone Tables (no FK dependencies)
import 'tables/farms_table.dart';

// Main Entity Tables
import 'tables/animals_table.dart';

// Transaction Tables (depend on main entities)
// import 'tables/treatments_table.dart';
// import 'tables/vaccinations_table.dart';
// import 'tables/weights_table.dart';
// import 'tables/movements_table.dart';

// Referential Tables
import 'tables/species_table.dart';
import 'tables/breeds_table.dart';
import 'tables/medical_products_table.dart';
import 'tables/vaccines_table.dart';
import 'tables/veterinarians_table.dart';

// Complex Tables
// import 'tables/batches_table.dart';
// import 'tables/lots_table.dart';
// import 'tables/campaigns_table.dart';

// Sync Table (Phase 2)
// import 'tables/sync_queue_table.dart';

// ═══════════════════════════════════════════════════════════
// IMPORTS - DAOs
// ═══════════════════════════════════════════════════════════
// Standalone DAOs
import 'daos/farm_dao.dart';

// Main Entity DAOs
import 'daos/animal_dao.dart';

// Transaction DAOs
// import 'daos/treatment_dao.dart';
// import 'daos/vaccination_dao.dart';
// import 'daos/weight_dao.dart';
// import 'daos/movement_dao.dart';

// Referential DAOs
import 'daos/species_dao.dart';
import 'daos/breed_dao.dart';
import 'daos/medical_product_dao.dart';
import 'daos/vaccine_dao.dart';
import 'daos/veterinarian_dao.dart';

// Complex DAOs
// import 'daos/batch_dao.dart';
// import 'daos/lot_dao.dart';
// import 'daos/campaign_dao.dart';

// Sync DAO (Phase 2)
// import 'daos/sync_queue_dao.dart';

// ═══════════════════════════════════════════════════════════
// GENERATED FILE
// ═══════════════════════════════════════════════════════════
part 'database.g.dart';

// ═══════════════════════════════════════════════════════════
// DATABASE DEFINITION
// ═══════════════════════════════════════════════════════════
@DriftDatabase(
  tables: [
    // ────────────────────────────────────────────────────────
    // STANDALONE TABLES (no FK dependencies)
    // ────────────────────────────────────────────────────────
    FarmsTable,

    // ────────────────────────────────────────────────────────
    // MAIN ENTITY TABLES
    // ────────────────────────────────────────────────────────
    AnimalsTable,

    // ────────────────────────────────────────────────────────
    // TRANSACTION TABLES (depend on main entities)
    // ────────────────────────────────────────────────────────
    // TreatmentsTable,
    // VaccinationsTable,
    // WeightsTable,
    // MovementsTable,

    // ────────────────────────────────────────────────────────
    // REFERENTIAL TABLES
    // ────────────────────────────────────────────────────────
    SpeciesTable,
    BreedsTable,
    MedicalProductsTable,
    VaccinesTable,
    VeterinariansTable,

    // ────────────────────────────────────────────────────────
    // COMPLEX TABLES
    // ────────────────────────────────────────────────────────
    // BatchesTable,
    // LotsTable,
    // CampaignsTable,

    // ────────────────────────────────────────────────────────
    // SYNC TABLE (Phase 2)
    // ────────────────────────────────────────────────────────
    // SyncQueueTable,
  ],
  daos: [
    // ────────────────────────────────────────────────────────
    // STANDALONE DAOs
    // ────────────────────────────────────────────────────────
    FarmDao,

    // ────────────────────────────────────────────────────────
    // MAIN ENTITY DAOs
    // ────────────────────────────────────────────────────────
    AnimalDao,

    // ────────────────────────────────────────────────────────
    // TRANSACTION DAOs
    // ────────────────────────────────────────────────────────
    // TreatmentDao,
    // VaccinationDao,
    // WeightDao,
    // MovementDao,

    // ────────────────────────────────────────────────────────
    // REFERENTIAL DAOs
    // ────────────────────────────────────────────────────────
    SpeciesDao,
    BreedDao,
    MedicalProductDao,
    VaccineDao,
    VeterinarianDao,

    // ────────────────────────────────────────────────────────
    // COMPLEX DAOs
    // ────────────────────────────────────────────────────────
    // BatchDao,
    // LotDao,
    // CampaignDao,

    // ────────────────────────────────────────────────────────
    // SYNC DAO (Phase 2)
    // ────────────────────────────────────────────────────────
    // SyncQueueDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ═══════════════════════════════════════════════════════════
  // MIGRATION STRATEGY
  // ═══════════════════════════════════════════════════════════
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          // Create all tables
          await m.createAll();

          // Enable foreign keys
          await customStatement('PRAGMA foreign_keys = ON;');

          // ───────────────────────────────────────────────────
          // INDEXES - STANDALONE TABLES
          // ───────────────────────────────────────────────────
          await _createFarmsIndexes();

          // ───────────────────────────────────────────────────
          // INDEXES - MAIN ENTITY TABLES
          // ───────────────────────────────────────────────────
          await _createAnimalsIndexes();

          // ───────────────────────────────────────────────────
          // INDEXES - TRANSACTION TABLES
          // ───────────────────────────────────────────────────
          // await _createTreatmentsIndexes();
          // await _createVaccinationsIndexes();
          // await _createWeightsIndexes();
          // await _createMovementsIndexes();

          // ───────────────────────────────────────────────────
          // INDEXES - REFERENTIAL TABLES
          // ───────────────────────────────────────────────────
          await _createSpeciesIndexes();
          await _createBreedsIndexes();
          await _createMedicalProductsIndexes();
          await _createVaccinesIndexes();
          await _createVeterinariansIndexes();

          // ───────────────────────────────────────────────────
          // INDEXES - COMPLEX TABLES
          // ───────────────────────────────────────────────────
          // await _createBatchesIndexes();
          // await _createLotsIndexes();
          // await _createCampaignsIndexes();

          // ───────────────────────────────────────────────────
          // INDEXES - SYNC TABLE (Phase 2)
          // ───────────────────────────────────────────────────
          // await _createSyncQueueIndexes();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Migrations futures ici
          // Exemple:
          // if (from < 2) {
          //   await m.addColumn(animalsTable, animalsTable.newColumn);
          // }
        },
      );

  // ═══════════════════════════════════════════════════════════
  // INDEX CREATION METHODS
  // ═══════════════════════════════════════════════════════════

  // ───────────────────────────────────────────────────────────
  // FARMS INDEXES
  // ───────────────────────────────────────────────────────────
  Future<void> _createFarmsIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_farms_cheptel_number ON farms(cheptel_number)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_farms_owner_id ON farms(owner_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_farms_group_id ON farms(group_id)',
    );
  }

  // ───────────────────────────────────────────────────────────
  // ANIMALS INDEXES
  // ───────────────────────────────────────────────────────────
  Future<void> _createAnimalsIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_animals_farm_id ON animals(farm_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_animals_current_eid ON animals(current_eid)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_animals_species_id ON animals(species_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_animals_status ON animals(status)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_animals_breed_id ON animals(breed_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_animals_mother_id ON animals(mother_id)',
    );
  }

  // ───────────────────────────────────────────────────────
  // SPECIES INDEXES
  // ───────────────────────────────────────────────────────
  Future<void> _createSpeciesIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_species_display_order ON species(display_order)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_species_name_fr ON species(name_fr)',
    );
  }

  // ───────────────────────────────────────────────────────
  // BREEDS INDEXES
  // ───────────────────────────────────────────────────────
  Future<void> _createBreedsIndexes() async {
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_breeds_species_id ON breeds(species_id)');
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_breeds_display_order ON breeds(display_order)');
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_breeds_is_active ON breeds(is_active)');
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_breeds_name_fr ON breeds(name_fr)');
  }

  // ───────────────────────────────────────────────────────
  // MEDICAL_PRODUCTS INDEXES
  // ───────────────────────────────────────────────────────
  Future<void> _createMedicalProductsIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_medical_products_farm_id ON medical_products(farm_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_medical_products_type ON medical_products(type)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_medical_products_category ON medical_products(category)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_medical_products_is_active ON medical_products(is_active)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_medical_products_expiry_date ON medical_products(expiry_date)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_medical_products_name ON medical_products(name)',
    );
  }

  /// Crée les indexes pour la table vaccines
  ///
  /// Indexes optimisés pour:
  /// - Filtrage par farmId (multi-tenancy)
  /// - Recherche par nom (autocomplete)
  /// - Filtrage par état actif (isActive)
  Future<void> _createVaccinesIndexes() async {
    // Index principal: farmId (queries fréquentes par ferme)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vaccines_farm_id '
      'ON vaccines(farm_id);',
    );

    // Index: name (recherche/autocomplete)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vaccines_name '
      'ON vaccines(name);',
    );

    // Index: isActive (filtrage vaccins actifs)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vaccines_is_active '
      'ON vaccines(is_active);',
    );

    // Index composite: farmId + isActive (query la plus fréquente)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vaccines_farm_active '
      'ON vaccines(farm_id, is_active);',
    );

    // Index composite: farmId + name (recherche par nom dans une ferme)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vaccines_farm_name '
      'ON vaccines(farm_id, name);',
    );
  }

  /// Crée les indexes pour la table veterinarians
  ///
  /// Indexes optimisés pour:
  /// - Filtrage par farmId (multi-tenancy)
  /// - Tri par nom (lastName, firstName)
  /// - Filtrage vétérinaire par défaut (isDefault)
  /// - Filtrage vétérinaires préférés (isPreferred)
  /// - Filtrage service d'urgence (emergencyService)
  Future<void> _createVeterinariansIndexes() async {
    // Index principal: farmId (queries fréquentes par ferme)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_veterinarians_farm_id '
      'ON veterinarians(farm_id);',
    );

    // Index: lastName (tri alphabétique)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_veterinarians_last_name '
      'ON veterinarians(last_name);',
    );

    // Index: isDefault (récupération vétérinaire par défaut)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_veterinarians_is_default '
      'ON veterinarians(is_default);',
    );

    // Index: isPreferred (récupération vétérinaires préférés)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_veterinarians_is_preferred '
      'ON veterinarians(is_preferred);',
    );

    // Index: emergencyService (récupération vétérinaires urgence)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_veterinarians_emergency_service '
      'ON veterinarians(emergency_service);',
    );

    // Index composite: farmId + isActive (vétérinaires actifs d'une ferme)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_veterinarians_farm_active '
      'ON veterinarians(farm_id, is_active);',
    );

    // Index composite: farmId + lastName + firstName (recherche/tri par nom dans une ferme)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_veterinarians_farm_name '
      'ON veterinarians(farm_id, last_name, first_name);',
    );

    // Index composite: farmId + isDefault (vétérinaire par défaut d'une ferme)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_veterinarians_farm_default '
      'ON veterinarians(farm_id, is_default);',
    );
  }

  // ───────────────────────────────────────────────────────────
  // TREATMENTS INDEXES (example for future)
  // ───────────────────────────────────────────────────────────
  // Future<void> _createTreatmentsIndexes() async {
  //   await customStatement(
  //     'CREATE INDEX IF NOT EXISTS idx_treatments_farm_id ON treatments(farm_id)',
  //   );
  //   await customStatement(
  //     'CREATE INDEX IF NOT EXISTS idx_treatments_animal_id ON treatments(animal_id)',
  //   );
  //   await customStatement(
  //     'CREATE INDEX IF NOT EXISTS idx_treatments_start_date ON treatments(start_date)',
  //   );
  //   await customStatement(
  //     'CREATE INDEX IF NOT EXISTS idx_treatments_product_id ON treatments(product_id)',
  //   );
  // }

  // ═══════════════════════════════════════════════════════════
  // DAO GETTERS
  // ═══════════════════════════════════════════════════════════

  // ───────────────────────────────────────────────────────────
  // STANDALONE DAOs
  // ───────────────────────────────────────────────────────────
  @override
  FarmDao get farmDao => FarmDao(this);

  // ───────────────────────────────────────────────────────────
  // MAIN ENTITY DAOs
  // ───────────────────────────────────────────────────────────
  @override
  AnimalDao get animalDao => AnimalDao(this);

  // ───────────────────────────────────────────────────────────
  // TRANSACTION DAOs
  // ───────────────────────────────────────────────────────────
  // TreatmentDao get treatmentDao => TreatmentDao(this);
  // VaccinationDao get vaccinationDao => VaccinationDao(this);
  // WeightDao get weightDao => WeightDao(this);
  // MovementDao get movementDao => MovementDao(this);

  // ───────────────────────────────────────────────────────────
  // REFERENTIAL DAOs
  // ───────────────────────────────────────────────────────────
  @override
  SpeciesDao get speciesDao => SpeciesDao(this);
  @override
  BreedDao get breedDao => BreedDao(this);
  @override
  MedicalProductDao get medicalProductDao => MedicalProductDao(this);
  @override
  VaccineDao get vaccineDao => VaccineDao(this);
  @override
  VeterinarianDao get veterinarianDao => VeterinarianDao(this);

  // ───────────────────────────────────────────────────────────
  // COMPLEX DAOs
  // ───────────────────────────────────────────────────────────
  // BatchDao get batchDao => BatchDao(this);
  // LotDao get lotDao => LotDao(this);
  // CampaignDao get campaignDao => CampaignDao(this);

  // ───────────────────────────────────────────────────────────
  // SYNC DAO (Phase 2)
  // ───────────────────────────────────────────────────────────
  // SyncQueueDao get syncQueueDao => SyncQueueDao(this);
}

// ═══════════════════════════════════════════════════════════
// DATABASE CONNECTION
// ═══════════════════════════════════════════════════════════
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'animal_trace.db'));
    return NativeDatabase(file);
  });
}
