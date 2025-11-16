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
import 'tables/farm_preferences_table.dart';

// Main Entity Tables
import 'tables/animals_table.dart';
import 'tables/breedings_table.dart';
import 'tables/documents_table.dart';

// Transaction Tables (depend on main entities)
import 'tables/treatments_table.dart';
import 'tables/vaccinations_table.dart';
import 'tables/weights_table.dart';
import 'tables/movements_table.dart';

// Referential Tables
import 'tables/species_table.dart';
import 'tables/breeds_table.dart';
import 'tables/medical_products_table.dart';
import 'tables/vaccines_table.dart';
import 'tables/veterinarians_table.dart';

// Complex Tables
import 'tables/batches_table.dart';
import 'tables/lots_table.dart';
import 'tables/campaigns_table.dart';

// Alert Configuration Table (Phase 1B)
import 'tables/alert_configurations_table.dart';

// Sync Table (Phase 2)
// import 'tables/sync_queue_table.dart';

// ═══════════════════════════════════════════════════════════
// IMPORTS - DAOs
// ═══════════════════════════════════════════════════════════
// Standalone DAOs
import 'daos/farm_dao.dart';
import 'daos/farm_preferences_dao.dart';

// Main Entity DAOs
import 'daos/animal_dao.dart';
import 'daos/breeding_dao.dart';
import 'daos/document_dao.dart';

// Transaction DAOs
import 'daos/treatment_dao.dart';
import 'daos/vaccination_dao.dart';
import 'daos/weight_dao.dart';
import 'daos/movement_dao.dart';

// Referential DAOs
import 'daos/species_dao.dart';
import 'daos/breed_dao.dart';
import 'daos/medical_product_dao.dart';
import 'daos/vaccine_dao.dart';
import 'daos/veterinarian_dao.dart';

// Complex DAOs
import 'daos/batch_dao.dart';
import 'daos/lot_dao.dart';
import 'daos/campaign_dao.dart';
// Alert Configuration DAO (Phase 1B)
import 'daos/alert_configuration_dao.dart';

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
    FarmPreferencesTable,

    // ────────────────────────────────────────────────────────
    // MAIN ENTITY TABLES
    // ────────────────────────────────────────────────────────
    AnimalsTable,
    BreedingsTable,
    DocumentsTable,

    // ────────────────────────────────────────────────────────
    // TRANSACTION TABLES (depend on main entities)
    // ────────────────────────────────────────────────────────
    TreatmentsTable,
    VaccinationsTable,
    WeightsTable,
    MovementsTable,

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
    BatchesTable,
    LotsTable,
    CampaignsTable,

    // Alert Configuration (Phase 1B)
    AlertConfigurationsTable,

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
    FarmPreferencesDao,

    // ────────────────────────────────────────────────────────
    // MAIN ENTITY DAOs
    // ────────────────────────────────────────────────────────
    AnimalDao,
    BreedingDao,
    DocumentDao,

    // ────────────────────────────────────────────────────────
    // TRANSACTION DAOs
    // ────────────────────────────────────────────────────────
    TreatmentDao,
    VaccinationDao,
    WeightDao,
    MovementDao,

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
    BatchDao,
    LotDao,
    CampaignDao,

    // Alert Configuration (Phase 1B)
    AlertConfigurationDao,

    // ────────────────────────────────────────────────────────
    // SYNC DAO (Phase 2)
    // ────────────────────────────────────────────────────────
    // SyncQueueDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

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
          await _createFarmPreferencesIndexes();

          // ───────────────────────────────────────────────────
          // INDEXES - MAIN ENTITY TABLES
          // ───────────────────────────────────────────────────
          await _createAnimalsIndexes();
          await _createBreedingsIndexes();
          await _createDocumentsIndexes();

          // ───────────────────────────────────────────────────
          // INDEXES - TRANSACTION TABLES
          // ───────────────────────────────────────────────────
          await _createTreatmentsIndexes();
          await _createVaccinationsIndexes();
          await _createWeightsIndexes();
          await _createMovementsIndexes();

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
          await _createBatchesIndexes();
          await _createLotsIndexes();
          await _createCampaignsIndexes();

          // ───────────────────────────────────────────────────
          // INDEXES - ALERT CONFIGURATION (Phase 1B)
          // ───────────────────────────────────────────────────
          await _createAlertConfigurationsIndexes();

          // ───────────────────────────────────────────────────
          // INDEXES - SYNC TABLE (Phase 2)
          // ───────────────────────────────────────────────────
          // await _createSyncQueueIndexes();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // ───────────────────────────────────────────────────
          // MIGRATION v1 → v2: Add UNIQUE constraints on animals table
          // ───────────────────────────────────────────────────
          if (from < 2) {
            await _migrateToV2AddUniqueConstraints();
          }

          // ───────────────────────────────────────────────────────
          // MIGRATION v2 → v3: Add return fields to movements table
          // ───────────────────────────────────────────────────────
          if (from < 3) {
            await _migrateToV3AddReturnFields();
          }
        },
      );
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
  // FARM PREFERENCES INDEXES
  // ───────────────────────────────────────────────────────────
  Future<void> _createFarmPreferencesIndexes() async {
    // Index principal: farmId (queries fréquentes par ferme)
    // Unique constraint déjà défini dans la table (une préférence par ferme)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_farm_preferences_farm_id '
      'ON farm_preferences(farm_id);',
    );

    // Index: deletedAt (soft-delete)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_farm_preferences_deleted_at '
      'ON farm_preferences(deleted_at);',
    );

    // Index composite: farmId + synced (Phase 2 sync queries)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_farm_preferences_synced '
      'ON farm_preferences(farm_id, synced);',
    );

    // Index: createdAt (tri chronologique)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_farm_preferences_created '
      'ON farm_preferences(created_at);',
    );
  }

  // ───────────────────────────────────────────────────────────
  // ANIMALS INDEXES
  // ───────────────────────────────────────────────────────────
  Future<void> _createAnimalsIndexes() async {
    // Index 1: Recherches par ferme (TRÈS FRÉQUENT)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_animals_farm_id ON animals(farm_id)',
    );

    // Index 2: Recherches par EID
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_animals_current_eid ON animals(current_eid)',
    );

    // Index 3: Filtrage par espèce
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_animals_species_id ON animals(species_id)',
    );

    // Index 4: Filtrage par statut
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_animals_status ON animals(status)',
    );

    // Index 5: Filtrage par race
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_animals_breed_id ON animals(breed_id)',
    );

    // Index 6: Recherches par mère
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_animals_mother_id ON animals(mother_id)',
    );

    // Index 7: Soft-delete check
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_animals_deleted_at ON animals(deleted_at)',
    );

    // Index composite 1: farm + status (filtrage courant)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_animals_farm_status ON animals(farm_id, status)',
    );

    // Index composite 2: farm + created_at DESC (pagination/listing)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_animals_farm_created_desc ON animals(farm_id, created_at DESC)',
    );

    // Index composite 3: farm + EID (recherche courante)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_animals_farm_eid ON animals(farm_id, current_eid)',
    );

    // Index composite 4: farm + status + validated_at (DRAFT system)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_animals_draft_alerts ON animals(farm_id, status, validated_at)',
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
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_breedings_deleted_at ON breedings(deleted_at);');
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
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_medical_products_deleted_at ON medical_products(deleted_at);');
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
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_vaccines_deleted_at ON vaccines(deleted_at);');
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
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_veterinarians_deleted_at ON veterinarians(deleted_at);');
  }

  /// Crée les indexes pour la table treatments
  ///
  /// Indexes optimisés pour:
  /// - Filtrage par farmId (multi-tenancy)
  /// - Filtrage par animal (historique médical)
  /// - Filtrage par produit (usage produits)
  /// - Filtrage par campagne
  /// - Recherche par date de traitement
  /// - Filtrage délai d'attente actif
  Future<void> _createTreatmentsIndexes() async {
    // Index principal: farmId (queries fréquentes par ferme)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_treatments_farm_id '
      'ON treatments(farm_id);',
    );

    // Index: animalId (historique médical par animal)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_treatments_animal_id '
      'ON treatments(animal_id);',
    );

    // Index: productId (usage des produits)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_treatments_product_id '
      'ON treatments(product_id);',
    );

    // Index: campaignId (traitements d'une campagne)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_treatments_campaign_id '
      'ON treatments(campaign_id);',
    );

    // Index: treatmentDate (recherche par date)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_treatments_treatment_date '
      'ON treatments(treatment_date);',
    );

    // Index: withdrawalEndDate (délais d'attente actifs)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_treatments_withdrawal_end_date '
      'ON treatments(withdrawal_end_date);',
    );

    // Index composite: farmId + animalId (query très fréquente)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_treatments_farm_animal '
      'ON treatments(farm_id, animal_id);',
    );

    // Index composite: farmId + treatmentDate (listing chronologique)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_treatments_farm_date '
      'ON treatments(farm_id, treatment_date);',
    );

    // Index composite: farmId + withdrawalEndDate (délais actifs par ferme)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_treatments_farm_withdrawal '
      'ON treatments(farm_id, withdrawal_end_date);',
    );
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_treatments_deleted_at ON treatments(deleted_at);');
  }

  /// Crée les indexes pour la table vaccinations
  ///
  /// Indexes optimisés pour:
  /// - Filtrage par farmId (multi-tenancy)
  /// - Filtrage par animal (historique vaccinal)
  /// - Filtrage par type de vaccination
  /// - Filtrage par maladie
  /// - Recherche par date de vaccination
  /// - Filtrage rappels à venir/en retard
  Future<void> _createVaccinationsIndexes() async {
    // Index principal: farmId (queries fréquentes par ferme)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vaccinations_farm_id '
      'ON vaccinations(farm_id);',
    );

    // Index: animalId (historique vaccinal par animal)
    // Note: animalId est nullable (vaccination de groupe)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vaccinations_animal_id '
      'ON vaccinations(animal_id);',
    );

    // Index: type (filtrage par type: obligatoire, recommandee, optionnelle)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vaccinations_type '
      'ON vaccinations(type);',
    );

    // Index: disease (recherche par maladie ciblée)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vaccinations_disease '
      'ON vaccinations(disease);',
    );

    // Index: vaccinationDate (recherche par date)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vaccinations_vaccination_date '
      'ON vaccinations(vaccination_date);',
    );

    // Index: nextDueDate (rappels à venir/en retard)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vaccinations_next_due_date '
      'ON vaccinations(next_due_date);',
    );

    // Index composite: farmId + animalId (query très fréquente)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vaccinations_farm_animal '
      'ON vaccinations(farm_id, animal_id);',
    );

    // Index composite: farmId + type (filtrage type par ferme)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vaccinations_farm_type '
      'ON vaccinations(farm_id, type);',
    );

    // Index composite: farmId + vaccinationDate (listing chronologique)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vaccinations_farm_date '
      'ON vaccinations(farm_id, vaccination_date);',
    );

    // Index composite: farmId + nextDueDate (rappels par ferme)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vaccinations_farm_reminder '
      'ON vaccinations(farm_id, next_due_date);',
    );
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_vaccinations_deleted_at ON vaccinations(deleted_at);');
  }

  /// Crée les indexes pour la table weights
  ///
  /// Indexes optimisés pour:
  /// - Filtrage par farmId (multi-tenancy)
  /// - Filtrage par animal (historique de croissance)
  /// - Recherche par date de pesée
  /// - Filtrage par source (balance, estimation, etc.)
  Future<void> _createWeightsIndexes() async {
    // Index principal: farmId (queries fréquentes par ferme)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_weights_farm_id '
      'ON weights(farm_id);',
    );

    // Index: animalId (historique de croissance par animal)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_weights_animal_id '
      'ON weights(animal_id);',
    );

    // Index: recordedAt (recherche par date)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_weights_recorded_at '
      'ON weights(recorded_at);',
    );

    // Index: source (filtrage par source de pesée)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_weights_source '
      'ON weights(source);',
    );

    // Index composite: farmId + animalId (query très fréquente)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_weights_farm_animal '
      'ON weights(farm_id, animal_id);',
    );

    // Index composite: farmId + recordedAt (listing chronologique)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_weights_farm_date '
      'ON weights(farm_id, recorded_at);',
    );

    // Index composite: animalId + recordedAt (historique animal)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_weights_animal_date '
      'ON weights(animal_id, recorded_at);',
    );

    // Index composite: farmId + animalId + recordedAt DESC (historique poids optimisé)
    // Pour la fonctionnalité Weight History: récupération des 10 derniers poids
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_weights_history '
      'ON weights(farm_id, animal_id, recorded_at DESC);',
    );
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_weights_deleted_at ON weights(deleted_at);');
  }

  /// Crée les indexes pour la table movements
  ///
  /// Indexes optimisés pour:
  /// - Filtrage par farmId (multi-tenancy)
  /// - Filtrage par animal (historique des mouvements)
  /// - Filtrage par type (births, sales, deaths, etc.)
  /// - Recherche par date de mouvement
  /// - Traçabilité fermes origine/destination
  Future<void> _createMovementsIndexes() async {
    // Index principal: farmId (queries fréquentes par ferme)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_movements_farm_id '
      'ON movements(farm_id);',
    );

    // Index: animalId (historique des mouvements par animal)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_movements_animal_id '
      'ON movements(animal_id);',
    );

    // Index: type (filtrage par type: birth, sale, death, etc.)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_movements_type '
      'ON movements(type);',
    );

    // Index: movementDate (recherche par date)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_movements_movement_date '
      'ON movements(movement_date);',
    );

    // Index: fromFarmId (traçabilité origine)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_movements_from_farm_id '
      'ON movements(from_farm_id);',
    );

    // Index: toFarmId (traçabilité destination)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_movements_to_farm_id '
      'ON movements(to_farm_id);',
    );

    // Index composite: farmId + animalId (query très fréquente)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_movements_farm_animal '
      'ON movements(farm_id, animal_id);',
    );

    // Index composite: farmId + type (filtrage type par ferme)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_movements_farm_type '
      'ON movements(farm_id, type);',
    );

    // Index composite: farmId + movementDate (listing chronologique)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_movements_farm_date '
      'ON movements(farm_id, movement_date);',
    );

    // Index composite: farmId + type + movementDate (stats par type/période)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_movements_farm_type_date '
      'ON movements(farm_id, type, movement_date);',
    );
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_movements_deleted_at ON movements(deleted_at);');
  }

  /// Créer les indexes pour la table batches
  Future<void> _createBatchesIndexes() async {
    // Index sur farm_id (multi-tenancy - CRITIQUE)
    await customStatement(
        'CREATE INDEX idx_batches_farm_id ON batches(farm_id);');

    // Index sur completed (filtrage actifs/complétés)
    await customStatement(
        'CREATE INDEX idx_batches_completed ON batches(completed);');

    // Index sur purpose (filtrage par objectif)
    await customStatement(
        'CREATE INDEX idx_batches_purpose ON batches(purpose);');

    // Index sur created_at (tri chronologique)
    await customStatement(
        'CREATE INDEX idx_batches_created_at ON batches(created_at);');

    // Index composite farm_id + completed (query la plus fréquente)
    await customStatement(
        'CREATE INDEX idx_batches_farm_completed ON batches(farm_id, completed);');
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_batches_deleted_at ON batches(deleted_at);');
  }

  /// Créer les indexes pour la table lots
  Future<void> _createLotsIndexes() async {
    // Index sur farm_id (multi-tenancy - CRITIQUE)
    await customStatement('CREATE INDEX idx_lots_farm_id ON lots(farm_id);');

    // Index sur completed (filtrage ouverts/complétés)
    await customStatement(
        'CREATE INDEX idx_lots_completed ON lots(completed);');

    // Index sur type (filtrage par type de lot)
    await customStatement('CREATE INDEX idx_lots_type ON lots(type);');

    // Index sur created_at (tri chronologique)
    await customStatement(
        'CREATE INDEX idx_lots_created_at ON lots(created_at);');

    // Index composite farm_id + completed (query la plus fréquente)
    await customStatement(
        'CREATE INDEX idx_lots_farm_completed ON lots(farm_id, completed);');

    // Index composite farm_id + type (filtrage par type)
    await customStatement(
        'CREATE INDEX idx_lots_farm_type ON lots(farm_id, type);');

    // Index sur product_id (recherche lots par produit)
    await customStatement(
        'CREATE INDEX idx_lots_product_id ON lots(product_id);');

    // Index sur veterinarian_id (recherche lots par vétérinaire)
    await customStatement(
        'CREATE INDEX idx_lots_veterinarian_id ON lots(veterinarian_id);');

    // Index sur withdrawal_end_date (alertes rémanence)
    await customStatement(
        'CREATE INDEX idx_lots_withdrawal_end_date ON lots(withdrawal_end_date);');
    // PHASE 1: REMOVED - deleted_at column doesn't exist in lots table
    // await customStatement(
    //     'CREATE INDEX IF NOT EXISTS idx_lots_deleted_at ON lots(deleted_at);');
  }

  /// Créer les indexes pour la table campaigns
  Future<void> _createCampaignsIndexes() async {
    // Index sur farm_id (multi-tenancy - CRITIQUE)
    await customStatement(
        'CREATE INDEX idx_campaigns_farm_id ON campaigns(farm_id);');

    // Index sur completed (filtrage actives/complétées)
    await customStatement(
        'CREATE INDEX idx_campaigns_completed ON campaigns(completed);');

    // Index sur campaign_date (tri chronologique)
    await customStatement(
        'CREATE INDEX idx_campaigns_campaign_date ON campaigns(campaign_date);');

    // Index composite farm_id + completed (query la plus fréquente)
    await customStatement(
        'CREATE INDEX idx_campaigns_farm_completed ON campaigns(farm_id, completed);');

    // Index sur product_id (recherche campagnes par produit)
    await customStatement(
        'CREATE INDEX idx_campaigns_product_id ON campaigns(product_id);');

    // Index sur veterinarian_id (recherche campagnes par vétérinaire)
    await customStatement(
        'CREATE INDEX idx_campaigns_veterinarian_id ON campaigns(veterinarian_id);');

    // Index sur withdrawal_end_date (alertes rémanence)
    await customStatement(
        'CREATE INDEX idx_campaigns_withdrawal_end_date ON campaigns(withdrawal_end_date);');
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_campaigns_deleted_at ON campaigns(deleted_at);');
  }

  /// Créer les indexes pour la table breedings
  ///
  /// Indexes optimisés pour:
  /// - Filtrage par farmId (multi-tenancy)
  /// - Recherche par mère (motherId)
  /// - Recherche par père (fatherId)
  /// - Filtrage par statut (pending, completed, failed, aborted)
  /// - Filtrage par méthode (natural, artificialInsemination)
  /// - Recherche par date de saillie (breedingDate)
  /// - Recherche par date de mise-bas prévue (expectedBirthDate)
  /// - Recherche par date de mise-bas réelle (actualBirthDate)
  /// - Recherche par vétérinaire (pour IA)
  Future<void> _createBreedingsIndexes() async {
    // Index principal: farmId (queries fréquentes par ferme)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_breedings_farm_id '
      'ON breedings(farm_id);',
    );

    // Index: motherId (historique reproductions par mère)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_breedings_mother_id '
      'ON breedings(mother_id);',
    );

    // Index: fatherId (historique reproductions par père)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_breedings_father_id '
      'ON breedings(father_id);',
    );

    // Index: status (filtrage par statut)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_breedings_status '
      'ON breedings(status);',
    );

    // Index: method (filtrage par méthode)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_breedings_method '
      'ON breedings(method);',
    );

    // Index: breedingDate (recherche par date de saillie)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_breedings_breeding_date '
      'ON breedings(breeding_date);',
    );

    // Index: expectedBirthDate (reproductions à surveiller)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_breedings_expected_birth_date '
      'ON breedings(expected_birth_date);',
    );

    // Index: actualBirthDate (historique mises-bas)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_breedings_actual_birth_date '
      'ON breedings(actual_birth_date);',
    );

    // Index: veterinarianId (IA par vétérinaire)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_breedings_veterinarian_id '
      'ON breedings(veterinarian_id);',
    );

    // Index composite: farmId + motherId (query très fréquente)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_breedings_farm_mother '
      'ON breedings(farm_id, mother_id);',
    );

    // Index composite: farmId + status (filtrage statut par ferme)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_breedings_farm_status '
      'ON breedings(farm_id, status);',
    );

    // Index composite: farmId + expectedBirthDate (surveillance mises-bas)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_breedings_farm_expected_date '
      'ON breedings(farm_id, expected_birth_date);',
    );

    // Index composite: farmId + status + expectedBirthDate (pending births)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_breedings_farm_status_date '
      'ON breedings(farm_id, status, expected_birth_date);',
    );

    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_breedings_deleted_at ON breedings(deleted_at);');
  }

  /// Créer les indexes pour la table documents
  ///
  /// Indexes optimisés pour:
  /// - Filtrage par farmId (multi-tenancy)
  /// - Filtrage par animal (animalId nullable)
  /// - Filtrage par type de document
  /// - Recherche par nom de fichier
  /// - Filtrage par date d'upload
  /// - Filtrage par date d'expiration
  /// - Recherche par uploadedBy
  Future<void> _createDocumentsIndexes() async {
    // Index principal: farmId (queries fréquentes par ferme)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_documents_farm_id '
      'ON documents(farm_id);',
    );

    // Index: animalId (documents par animal)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_documents_animal_id '
      'ON documents(animal_id);',
    );

    // Index: type (filtrage par type)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_documents_type '
      'ON documents(type);',
    );

    // Index: fileName (recherche par nom)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_documents_file_name '
      'ON documents(file_name);',
    );

    // Index: uploadDate (tri chronologique uploads)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_documents_upload_date '
      'ON documents(upload_date);',
    );

    // Index: expiryDate (documents expirant bientôt)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_documents_expiry_date '
      'ON documents(expiry_date);',
    );

    // Index: uploadedBy (documents par utilisateur)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_documents_uploaded_by '
      'ON documents(uploaded_by);',
    );

    // Index composite: farmId + animalId (query très fréquente)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_documents_farm_animal '
      'ON documents(farm_id, animal_id);',
    );

    // Index composite: farmId + type (filtrage type par ferme)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_documents_farm_type '
      'ON documents(farm_id, type);',
    );

    // Index composite: farmId + expiryDate (alertes expirations)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_documents_farm_expiry '
      'ON documents(farm_id, expiry_date);',
    );

    // Index composite: farmId + uploadDate (listing chronologique)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_documents_farm_upload '
      'ON documents(farm_id, upload_date);',
    );
    await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_documents_deleted_at ON documents(deleted_at);');
  }

  // ───────────────────────────────────────────────────────────
  // ALERT CONFIGURATIONS INDEXES
  // ───────────────────────────────────────────────────────────
  Future<void> _createAlertConfigurationsIndexes() async {
    // Index principal: farmId (queries fréquentes par ferme)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_alert_config_farmid '
      'ON alert_configurations_table(farm_id);',
    );

    // Index: enabled (configurations actives uniquement)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_alert_config_enabled '
      'ON alert_configurations_table(enabled);',
    );

    // Index composite: farmId + evaluationType (lookup principal)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_alert_config_evaluation '
      'ON alert_configurations_table(farm_id, evaluation_type);',
    );

    // Index: createdAt (tri chronologique)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_alert_config_created '
      'ON alert_configurations_table(created_at);',
    );

    // Index composite: farmId + synced (Phase 2 sync queries)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_alert_config_synced '
      'ON alert_configurations_table(farm_id, synced);',
    );

    // Index: deletedAt (soft-delete)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_alert_config_deleted_at '
      'ON alert_configurations_table(deleted_at);',
    );
  }

  // ═══════════════════════════════════════════════════════════
  // MIGRATION HELPERS
  // ═══════════════════════════════════════════════════════════

  /// Migration v1 → v2: Ajouter des contraintes UNIQUE sur EID et officialNumber
  ///
  /// Cette migration recrée la table animals avec les contraintes UNIQUE :
  /// - UNIQUE(farm_id, current_eid) - Un EID unique par ferme
  /// - UNIQUE(farm_id, official_number) - Un numéro officiel unique par ferme
  ///
  /// ⚠️ Important: Cette migration échouera si des doublons existent déjà
  Future<void> _migrateToV2AddUniqueConstraints() async {
    // Étape 1: Vérifier s'il y a des doublons d'EID
    final eidDuplicates = await customSelect(
      '''
      SELECT farm_id, current_eid, COUNT(*) as count
      FROM animals
      WHERE current_eid IS NOT NULL AND deleted_at IS NULL
      GROUP BY farm_id, current_eid
      HAVING count > 1
      ''',
    ).get();

    if (eidDuplicates.isNotEmpty) {
      final duplicateEids = eidDuplicates
          .map((row) => '${row.data['farm_id']}: ${row.data['current_eid']}')
          .join(', ');
      throw Exception(
        'Migration échouée: Des doublons d\'EID existent dans la base de données. '
        'Veuillez les corriger avant de migrer. Doublons trouvés: $duplicateEids',
      );
    }

    // Étape 2: Vérifier s'il y a des doublons de numéros officiels
    final officialNumberDuplicates = await customSelect(
      '''
      SELECT farm_id, official_number, COUNT(*) as count
      FROM animals
      WHERE official_number IS NOT NULL AND deleted_at IS NULL
      GROUP BY farm_id, official_number
      HAVING count > 1
      ''',
    ).get();

    if (officialNumberDuplicates.isNotEmpty) {
      final duplicateNumbers = officialNumberDuplicates
          .map((row) => '${row.data['farm_id']}: ${row.data['official_number']}')
          .join(', ');
      throw Exception(
        'Migration échouée: Des doublons de numéros officiels existent dans la base de données. '
        'Veuillez les corriger avant de migrer. Doublons trouvés: $duplicateNumbers',
      );
    }

    // Étape 3: Pas de doublons - Procéder à la migration
    // Désactiver temporairement les contraintes de clés étrangères
    await customStatement('PRAGMA foreign_keys = OFF;');

    // Étape 4: Renommer l'ancienne table
    await customStatement('ALTER TABLE animals RENAME TO animals_old;');

    // Étape 5: Créer la nouvelle table avec les contraintes UNIQUE
    await customStatement('''
      CREATE TABLE animals (
        id TEXT NOT NULL PRIMARY KEY,
        farm_id TEXT NOT NULL,
        current_eid TEXT,
        official_number TEXT,
        visual_id TEXT,
        eid_history TEXT,
        birth_date INTEGER NOT NULL,
        sex TEXT NOT NULL,
        mother_id TEXT,
        status TEXT NOT NULL,
        validated_at INTEGER,
        species_id TEXT,
        breed_id TEXT,
        photo_url TEXT,
        days INTEGER,
        synced INTEGER NOT NULL DEFAULT 0,
        last_synced_at INTEGER,
        server_version TEXT,
        deleted_at INTEGER,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        FOREIGN KEY (farm_id) REFERENCES farms(id) ON DELETE CASCADE,
        UNIQUE(farm_id, current_eid),
        UNIQUE(farm_id, official_number)
      );
    ''');

    // Étape 6: Copier les données de l'ancienne table vers la nouvelle
    await customStatement('''
      INSERT INTO animals
      SELECT * FROM animals_old;
    ''');

    // Étape 7: Supprimer l'ancienne table
    await customStatement('DROP TABLE animals_old;');

    // Étape 8: Recréer les indexes
    await _createAnimalsIndexes();

    // Étape 9: Réactiver les contraintes de clés étrangères
    await customStatement('PRAGMA foreign_keys = ON;');
  }

  /// Migration v2 → v3: Ajouter les champs de retour à la table movements
  ///
  /// Cette migration ajoute deux nouveaux champs à la table movements :
  /// - return_date: Date de retour pour les mouvements temporaires
  /// - return_notes: Notes sur le retour de l'animal
  Future<void> _migrateToV3AddReturnFields() async {
    await customStatement(
      'ALTER TABLE movements ADD COLUMN return_date INTEGER;',
    );
    await customStatement(
      'ALTER TABLE movements ADD COLUMN return_notes TEXT;',
    );
  }

  // ═══════════════════════════════════════════════════════════
  // DAO GETTERS
  // ═══════════════════════════════════════════════════════════

  // ───────────────────────────────────────────────────────────
  // STANDALONE DAOs
  // ───────────────────────────────────────────────────────────
  @override
  FarmDao get farmDao => FarmDao(this);
  @override
  FarmPreferencesDao get farmPreferencesDao => FarmPreferencesDao(this);

  // ───────────────────────────────────────────────────────────
  // MAIN ENTITY DAOs
  // ───────────────────────────────────────────────────────────
  @override
  AnimalDao get animalDao => AnimalDao(this);
  @override
  BreedingDao get breedingDao => BreedingDao(this);
  @override
  DocumentDao get documentDao => DocumentDao(this);

  // ───────────────────────────────────────────────────────────
  // TRANSACTION DAOs
  // ───────────────────────────────────────────────────────────
  @override
  TreatmentDao get treatmentDao => TreatmentDao(this);
  @override
  VaccinationDao get vaccinationDao => VaccinationDao(this);
  @override
  WeightDao get weightDao => WeightDao(this);
  @override
  MovementDao get movementDao => MovementDao(this);

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
  @override
  BatchDao get batchDao => BatchDao(this);
  @override
  LotDao get lotDao => LotDao(this);
  @override
  CampaignDao get campaignDao => CampaignDao(this);

  // ───────────────────────────────────────────────────────────
  // ALERT CONFIGURATION DAO (Phase 1B)
  // ───────────────────────────────────────────────────────────
  @override
  AlertConfigurationDao get alertConfigurationDao =>
      AlertConfigurationDao(this);

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
