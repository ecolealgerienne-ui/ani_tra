// lib/core/database/database_initializer.dart
import 'package:drift/drift.dart';
import 'package:animal_trace/drift/database.dart';
import 'package:animal_trace/models/animal.dart';

class DatabaseInitializer {
  static const String _tag = '🗄️ DatabaseInitializer';

  static Future<AppDatabase> initialize() async {
    try {
      final db = AppDatabase();

      await db.customStatement('SELECT 1');

      await _seedTestData(db);

      return db;
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> _seedTestData(AppDatabase db) async {
    try {
      // Vérifier si Farm existe déjà
      final existingFarm = await db.farmDao.findById('farm_default');
      if (existingFarm != null) {
        return;
      }

      final now = DateTime.now();

      // ════════════════════════════════════════════════════════════
      // DONNÉES DE BASE
      // ════════════════════════════════════════════════════════════

      // Farms
      try {
        await db.farmDao.insertFarm(FarmsTableCompanion.insert(
          id: 'farm_default',
          name: 'Bergerie des Collines',
          location: 'Haute-Savoie, France',
          ownerId: 'owner_001',
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      try {
        await db.farmDao.insertFarm(FarmsTableCompanion.insert(
          id: 'farm_002',
          name: 'Élevage du Midi',
          location: 'Aveyron, France',
          ownerId: 'owner_002',
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      try {
        await db.farmDao.insertFarm(FarmsTableCompanion.insert(
          id: 'farm_003',
          name: 'Ferme Bio Roussillon',
          location: 'Pyrénées-Orientales, France',
          ownerId: 'owner_003',
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      // Species
      try {
        await db.speciesDao.insertSpecies(SpeciesTableCompanion.insert(
          id: 'sheep',
          nameFr: 'Ovin',
          nameEn: 'Sheep',
          nameAr: 'خروف',
          icon: '🐑',
          displayOrder: const Value(1),
        ));
        await db.speciesDao.insertSpecies(SpeciesTableCompanion.insert(
          id: 'cattle',
          nameFr: 'Bovin',
          nameEn: 'Cattle',
          nameAr: 'بقرة',
          icon: '🐄',
          displayOrder: const Value(2),
        ));
        await db.speciesDao.insertSpecies(SpeciesTableCompanion.insert(
          id: 'goat',
          nameFr: 'Caprin',
          nameEn: 'Goat',
          nameAr: 'ماعز',
          icon: '🐐',
          displayOrder: const Value(3),
        ));
      } catch (e) {
        // Silent fail
      }

      // Breeds
      try {
        final breeds = [
          ('merinos', 'sheep', 'Mérinos', 'Merino', 'ميرينوس', 1),
          ('suffolk', 'sheep', 'Suffolk', 'Suffolk', 'سوفولك', 2),
          ('lacaune', 'sheep', 'Lacaune', 'Lacaune', 'لاكاون', 3),
          ('holstein', 'cattle', 'Holstein', 'Holstein', 'هولشتاين', 1),
          ('charolais', 'cattle', 'Charolaise', 'Charolais', 'شارولي', 2),
          ('limousin', 'cattle', 'Limousine', 'Limousin', 'ليموزين', 3),
          ('alpine', 'goat', 'Alpine', 'Alpine', 'ألبيني', 1),
          ('saanen', 'goat', 'Saanen', 'Saanen', 'سانين', 2),
          ('angora', 'goat', 'Angora', 'Angora', 'أنجورا', 3),
        ];

        for (var breed in breeds) {
          await db.breedDao.insertBreed(BreedsTableCompanion.insert(
            id: breed.$1,
            speciesId: breed.$2,
            nameFr: breed.$3,
            nameEn: breed.$4,
            nameAr: breed.$5,
            displayOrder: Value(breed.$6),
          ));
        }
      } catch (e) {
        // Silent fail
      }

      // ════════════════════════════════════════════════════════════
      // DONNÉES SIMPLIFIÉES (champs réels uniquement)
      // ════════════════════════════════════════════════════════════

      // Veterinarians (utilise firstName, lastName)
      try {
        await db.veterinarianDao.insertItem(VeterinariansTableCompanion.insert(
          id: 'vet_001',
          farmId: 'farm_default',
          firstName: 'Jean',
          lastName: 'Dupont',
          licenseNumber: 'VET-2024-001',
          specialties: '["Ovins","Bovins"]',
          phone: '06 12 34 56 78',
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      // Medical Products (utilise currentStock, stockUnit)
      try {
        await db.medicalProductDao
            .insertProduct(MedicalProductsTableCompanion.insert(
          id: 'prod_001',
          farmId: 'farm_default',
          name: 'Amoxicilline 500mg',
          category: 'treatment',
          withdrawalPeriodMeat: 7,
          withdrawalPeriodMilk: 3,
          currentStock: 100.0,
          minStock: 10.0,
          stockUnit: 'ml',
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      // Animals
      try {
        await db.animalDao.insertItem(AnimalsTableCompanion.insert(
          id: 'anim_001',
          farmId: 'farm_default',
          currentEid: const Value('FR123456789'),
          birthDate: now.subtract(const Duration(days: 365)),
          sex: AnimalSex.female.name,
          status: AnimalStatus.alive.name,
          speciesId: const Value('sheep'),
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      try {
        await db.animalDao.insertItem(AnimalsTableCompanion.insert(
          id: 'anim_002',
          farmId: 'farm_default',
          currentEid: const Value('FR987654321'),
          birthDate: now.subtract(const Duration(days: 450)),
          sex: AnimalSex.male.name,
          status: AnimalStatus.dead.name,
          speciesId: const Value('sheep'),
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      try {
        await db.animalDao.insertItem(AnimalsTableCompanion.insert(
          id: 'anim_003',
          farmId: 'farm_default',
          currentEid: const Value('FR555444333'),
          birthDate: now.subtract(const Duration(days: 200)),
          sex: AnimalSex.male.name,
          status: AnimalStatus.slaughtered.name,
          speciesId: const Value('sheep'),
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      try {
        await db.animalDao.insertItem(AnimalsTableCompanion.insert(
          id: 'anim_004',
          farmId: 'farm_default',
          currentEid: const Value('FR111222333'),
          birthDate: now.subtract(const Duration(days: 300)),
          sex: AnimalSex.female.name,
          status: AnimalStatus.alive.name,
          speciesId: const Value('sheep'),
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      try {
        await db.animalDao.insertItem(AnimalsTableCompanion.insert(
          id: 'anim_005',
          farmId: 'farm_default',
          currentEid: const Value('FR666777888'),
          birthDate: now.subtract(const Duration(days: 250)),
          sex: AnimalSex.male.name,
          status: AnimalStatus.sold.name,
          speciesId: const Value('sheep'),
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      // Animaux supplémentaires pour les lots
      try {
        await db.animalDao.insertItem(AnimalsTableCompanion.insert(
          id: 'anim_006',
          farmId: 'farm_default',
          currentEid: const Value('FR222333444'),
          birthDate: now.subtract(const Duration(days: 400)),
          sex: AnimalSex.female.name,
          status: AnimalStatus.alive.name,
          speciesId: const Value('sheep'),
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      try {
        await db.animalDao.insertItem(AnimalsTableCompanion.insert(
          id: 'anim_007',
          farmId: 'farm_default',
          currentEid: const Value('FR333444555'),
          birthDate: now.subtract(const Duration(days: 380)),
          sex: AnimalSex.male.name,
          status: AnimalStatus.alive.name,
          speciesId: const Value('sheep'),
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      try {
        await db.animalDao.insertItem(AnimalsTableCompanion.insert(
          id: 'anim_008',
          farmId: 'farm_default',
          currentEid: const Value('FR444555666'),
          birthDate: now.subtract(const Duration(days: 350)),
          sex: AnimalSex.female.name,
          status: AnimalStatus.alive.name,
          speciesId: const Value('sheep'),
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      try {
        await db.animalDao.insertItem(AnimalsTableCompanion.insert(
          id: 'anim_009',
          farmId: 'farm_default',
          currentEid: const Value('FR555666777'),
          birthDate: now.subtract(const Duration(days: 320)),
          sex: AnimalSex.male.name,
          status: AnimalStatus.alive.name,
          speciesId: const Value('sheep'),
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      try {
        await db.animalDao.insertItem(AnimalsTableCompanion.insert(
          id: 'anim_010',
          farmId: 'farm_default',
          currentEid: const Value('FR666777888'),
          birthDate: now.subtract(const Duration(days: 290)),
          sex: AnimalSex.female.name,
          status: AnimalStatus.alive.name,
          speciesId: const Value('sheep'),
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      try {
        await db.animalDao.insertItem(AnimalsTableCompanion.insert(
          id: 'anim_011',
          farmId: 'farm_default',
          currentEid: const Value('FR777888999'),
          birthDate: now.subtract(const Duration(days: 260)),
          sex: AnimalSex.male.name,
          status: AnimalStatus.alive.name,
          speciesId: const Value('sheep'),
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      try {
        await db.animalDao.insertItem(AnimalsTableCompanion.insert(
          id: 'anim_012',
          farmId: 'farm_default',
          currentEid: const Value('FR888999000'),
          birthDate: now.subtract(const Duration(days: 230)),
          sex: AnimalSex.female.name,
          status: AnimalStatus.alive.name,
          speciesId: const Value('sheep'),
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      try {
        await db.animalDao.insertItem(AnimalsTableCompanion.insert(
          id: 'anim_013',
          farmId: 'farm_default',
          currentEid: const Value('FR999000111'),
          birthDate: now.subtract(const Duration(days: 200)),
          sex: AnimalSex.male.name,
          status: AnimalStatus.alive.name,
          speciesId: const Value('sheep'),
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      try {
        await db.animalDao.insertItem(AnimalsTableCompanion.insert(
          id: 'anim_014',
          farmId: 'farm_default',
          currentEid: const Value('FR000111222'),
          birthDate: now.subtract(const Duration(days: 170)),
          sex: AnimalSex.female.name,
          status: AnimalStatus.alive.name,
          speciesId: const Value('sheep'),
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      try {
        await db.animalDao.insertItem(AnimalsTableCompanion.insert(
          id: 'anim_015',
          farmId: 'farm_default',
          currentEid: const Value('FR111222333'),
          birthDate: now.subtract(const Duration(days: 140)),
          sex: AnimalSex.male.name,
          status: AnimalStatus.alive.name,
          speciesId: const Value('sheep'),
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      // Treatments (utilise dose)
      try {
        await db.treatmentDao.insertItem(TreatmentsTableCompanion.insert(
          id: 'treat_001',
          farmId: 'farm_default',
          animalId: 'anim_001',
          productId: 'prod_001',
          productName: 'Amoxicilline 500mg',
          treatmentDate: now,
          dose: 10.0,
          withdrawalEndDate: now.add(const Duration(days: 7)),
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      // Vaccinations (utilise animalIds, dose, type, disease, administrationRoute, withdrawalPeriodDays)
      try {
        await db.vaccinationDao.insertItem(VaccinationsTableCompanion.insert(
          id: 'vacc_001',
          farmId: 'farm_default',
          animalIds: '["anim_001"]',
          vaccineName: 'Vaccin Ectima',
          type: 'obligatoire',
          disease: 'Ectima Contagieux',
          vaccinationDate: now,
          dose: '1 ml',
          administrationRoute: 'intramusculaire',
          withdrawalPeriodDays: 0,
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      // Weights (utilise recordedAt, source)
      try {
        await db.weightDao.insertItem(WeightsTableCompanion.insert(
          id: 'weight_001',
          farmId: 'farm_default',
          animalId: 'anim_001',
          recordedAt: now,
          weight: 45.5,
          source: 'scale',
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      // Movements (utilise type, movementDate, fromFarmId, toFarmId)
      // ==================== ACHATS (LOT) ====================
      try {
        await db.movementDao.insertItem(MovementsTableCompanion.insert(
          id: 'mov_001',
          farmId: 'farm_default',
          animalId: 'batch_001',
          movementDate: now.subtract(const Duration(days: 180)),
          type: 'purchase',
          fromFarmId: const Value('farm_supplier_01'),
          price: const Value(1250.00),
          notes: const Value('Achat lot de 3 agneaux pour traitement'),
          synced: const Value(true),
          createdAt: now.subtract(const Duration(days: 180)),
          updatedAt: now.subtract(const Duration(days: 180)),
        ));
      } catch (e) {
        // Silent fail
      }

      // ==================== VENTES ====================
      try {
        // Vente individuelle
        await db.movementDao.insertItem(MovementsTableCompanion.insert(
          id: 'mov_002',
          farmId: 'farm_default',
          animalId: 'anim_005',
          movementDate: now.subtract(const Duration(days: 45)),
          type: 'sale',
          toFarmId: const Value('farm_buyer_01'),
          price: const Value(285.00),
          notes: const Value('Vente marché local - mâle adulte'),
          synced: const Value(true),
          createdAt: now.subtract(const Duration(days: 45)),
          updatedAt: now.subtract(const Duration(days: 45)),
        ));
      } catch (e) {
        // Silent fail
      }

      try {
        // Vente lot
        await db.movementDao.insertItem(MovementsTableCompanion.insert(
          id: 'mov_003',
          farmId: 'farm_default',
          animalId: 'batch_002',
          movementDate: now.subtract(const Duration(days: 30)),
          type: 'sale',
          toFarmId: const Value('farm_buyer_02'),
          price: const Value(1850.00),
          notes: const Value('Vente lot de 5 moutons engraissés au marché'),
          synced: const Value(false),
          createdAt: now.subtract(const Duration(days: 30)),
          updatedAt: now.subtract(const Duration(days: 30)),
        ));
      } catch (e) {
        // Silent fail
      }

      // ==================== MORT (INDIVIDUEL) ====================
      try {
        await db.movementDao.insertItem(MovementsTableCompanion.insert(
          id: 'mov_004',
          farmId: 'farm_default',
          animalId: 'anim_002',
          movementDate: now.subtract(const Duration(days: 90)),
          type: 'death',
          notes: const Value('Maladie respiratoire - traitement tardif'),
          synced: const Value(true),
          createdAt: now.subtract(const Duration(days: 90)),
          updatedAt: now.subtract(const Duration(days: 90)),
        ));
      } catch (e) {
        // Silent fail
      }

      // ==================== ABATTAGE ====================
      try {
        // Abattage individuel
        await db.movementDao.insertItem(MovementsTableCompanion.insert(
          id: 'mov_005',
          farmId: 'farm_default',
          animalId: 'anim_003',
          movementDate: now.subtract(const Duration(days: 15)),
          type: 'slaughter',
          toFarmId: const Value('slaughterhouse_001'),
          notes: const Value('Abattoir municipal - mouton Aïd'),
          synced: const Value(false),
          createdAt: now.subtract(const Duration(days: 15)),
          updatedAt: now.subtract(const Duration(days: 15)),
        ));
      } catch (e) {
        // Silent fail
      }

      try {
        // Abattage lot
        await db.movementDao.insertItem(MovementsTableCompanion.insert(
          id: 'mov_006',
          farmId: 'farm_default',
          animalId: 'batch_003',
          movementDate: now.subtract(const Duration(days: 7)),
          type: 'slaughter',
          toFarmId: const Value('slaughterhouse_001'),
          notes: const Value('Lot de 3 agneaux pour abattage Aïd'),
          synced: const Value(false),
          createdAt: now.subtract(const Duration(days: 7)),
          updatedAt: now.subtract(const Duration(days: 7)),
        ));
      } catch (e) {
        // Silent fail
      }

      // ==================== SORTIE TEMPORAIRE (INDIVIDUEL) ====================
      try {
        await db.movementDao.insertItem(MovementsTableCompanion.insert(
          id: 'mov_007',
          farmId: 'farm_default',
          animalId: 'anim_004',
          movementDate: now.subtract(const Duration(days: 3)),
          type: 'temporaryOut',
          toFarmId: const Value('farm_pasture_01'),
          notes: const Value('Transhumance saisonnière - pâturage montagne'),
          synced: const Value(false),
          createdAt: now.subtract(const Duration(days: 3)),
          updatedAt: now.subtract(const Duration(days: 3)),
        ));
      } catch (e) {
        // Silent fail
      }

      // Batches (utilise animalIdsJson, purpose)
      try {
        await db.batchDao.insertBatch(BatchesTableCompanion.insert(
          id: 'batch_001',
          farmId: 'farm_default',
          purpose: 'treatment',
          name: 'Traitement Antiparasitaire',
          animalIdsJson: '["anim_001", "anim_006", "anim_007"]',
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      try {
        await db.batchDao.insertBatch(BatchesTableCompanion.insert(
          id: 'batch_002',
          farmId: 'farm_default',
          purpose: 'sale',
          name: 'Lot vente marché',
          animalIdsJson: '["anim_008", "anim_009", "anim_010", "anim_011", "anim_012"]',
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      try {
        await db.batchDao.insertBatch(BatchesTableCompanion.insert(
          id: 'batch_003',
          farmId: 'farm_default',
          purpose: 'slaughter',
          name: 'Lot abattage Aïd',
          animalIdsJson: '["anim_013", "anim_014", "anim_015"]',
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      // Lots - PHASE 1: ADD status field
      try {
        await db.lotDao.insertLot(LotsTableCompanion.insert(
          id: 'lot_001',
          farmId: 'farm_default',
          name: 'Lot de traitement #1',
          animalIdsJson: '["anim_001"]',
          status: const Value('open'), // PHASE 1: ADD
          completed: const Value(false),
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      // ════════════════════════════════════════════════════════════
      // ALERT CONFIGURATIONS (Phase 1B) ✅ NEW
      // ════════════════════════════════════════════════════════════

      try {
        // Remanence Alert Config
        await db.alertConfigurationDao
            .insertItem(AlertConfigurationsTableCompanion.insert(
          id: 'config_remanence_1',
          farmId: 'farm_default',
          evaluationType: 'remanence',
          type: 'important',
          category: 'remanence',
          titleKey: 'alertRemanenceTitle',
          messageKey: 'alertRemanenceMsg',
          severity: 2,
          iconName: 'pill',
          colorHex: '#F57C00',
          enabled: const Value(true),
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));

        // Weighing Alert Config
        await db.alertConfigurationDao
            .insertItem(AlertConfigurationsTableCompanion.insert(
          id: 'config_weighing_1',
          farmId: 'farm_default',
          evaluationType: 'weighing',
          type: 'routine',
          category: 'weighing',
          titleKey: 'alertWeighingTitle',
          messageKey: 'alertWeighingMsg',
          severity: 1,
          iconName: 'scale',
          colorHex: '#1976D2',
          enabled: const Value(true),
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));

        // Vaccination Alert Config
        await db.alertConfigurationDao
            .insertItem(AlertConfigurationsTableCompanion.insert(
          id: 'config_vaccination_1',
          farmId: 'farm_default',
          evaluationType: 'vaccination',
          type: 'important',
          category: 'treatment',
          titleKey: 'alertVaccinationTitle',
          messageKey: 'alertVaccinationMsg',
          severity: 2,
          iconName: 'syringe',
          colorHex: '#D32F2F',
          enabled: const Value(true),
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));

        // Identification Alert Config
        await db.alertConfigurationDao
            .insertItem(AlertConfigurationsTableCompanion.insert(
          id: 'config_identification_1',
          farmId: 'farm_default',
          evaluationType: 'identification',
          type: 'urgent',
          category: 'identification',
          titleKey: 'alertIdentificationTitle',
          messageKey: 'alertIdentificationMsg',
          severity: 3,
          iconName: 'tag',
          colorHex: '#E53935',
          enabled: const Value(true),
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));

        // Sync Required Alert Config
        await db.alertConfigurationDao
            .insertItem(AlertConfigurationsTableCompanion.insert(
          id: 'config_sync_1',
          farmId: 'farm_default',
          evaluationType: 'syncRequired',
          type: 'routine',
          category: 'sync',
          titleKey: 'alertSyncTitle',
          messageKey: 'alertSyncMsg',
          severity: 1,
          iconName: 'cloud_upload',
          colorHex: '#0288D1',
          enabled: const Value(true),
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));

        // Treatment Renewal Alert Config
        await db.alertConfigurationDao
            .insertItem(AlertConfigurationsTableCompanion.insert(
          id: 'config_treatment_renewal_1',
          farmId: 'farm_default',
          evaluationType: 'treatmentRenewal',
          type: 'routine',
          category: 'treatment',
          titleKey: 'alertTreatmentRenewalTitle',
          messageKey: 'alertTreatmentRenewalMsg',
          severity: 1,
          iconName: 'medication',
          colorHex: '#0097A7',
          enabled: const Value(true),
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));

        // Batch to Finalize Alert Config
        await db.alertConfigurationDao
            .insertItem(AlertConfigurationsTableCompanion.insert(
          id: 'config_batch_finalize_1',
          farmId: 'farm_default',
          evaluationType: 'batchToFinalize',
          type: 'routine',
          category: 'batch',
          titleKey: 'alertBatchFinalizeTitle',
          messageKey: 'alertBatchFinalizeMsg',
          severity: 1,
          iconName: 'check_circle',
          colorHex: '#388E3C',
          enabled: const Value(true),
          synced: const Value(false),
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      // ════════════════════════════════════════════════════════════
      // DONNÉES GÉNÉRÉES (30 animaux supplémentaires)
      // ════════════════════════════════════════════════════════════

      try {
        final farms = ['farm_default', 'farm_002', 'farm_003'];
        final breeds = ['merinos', 'suffolk', 'lacaune'];

        for (int i = 1; i <= 30; i++) {
          final farmIdx = i <= 15 ? 0 : (i <= 24 ? 1 : 2);
          final birth = now.subtract(Duration(days: 30 + (i * 30)));
          final sex = i % 3 == 0 ? AnimalSex.male : AnimalSex.female;

          await db.animalDao.insertItem(AnimalsTableCompanion.insert(
            id: 'gen_${i.toString().padLeft(3, '0')}',
            farmId: farms[farmIdx],
            currentEid: Value(
                'FR${now.millisecondsSinceEpoch}${i.toString().padLeft(3, '0')}'),
            birthDate: birth,
            sex: sex.name,
            status: AnimalStatus.alive.name,
            speciesId: const Value('sheep'),
            breedId: Value(breeds[i % 3]),
            synced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ));
        }
      } catch (e) {
        // Silent fail
      }
    } catch (e) {
      // Silent fail
    }
  }
}
