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
        print('$_tag Test data already seeded, skipping...');
        return;
      }

      print('$_tag 🌱 Seeding comprehensive test data...');
      final now = DateTime.now();

      // ════════════════════════════════════════════════════════════
      // DONNÉES DE BASE
      // ════════════════════════════════════════════════════════════

      print('$_tag   📍 Creating farms...');
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

        await db.farmDao.insertFarm(FarmsTableCompanion.insert(
          id: 'farm_002',
          name: 'Élevage du Midi',
          location: 'Aveyron, France',
          ownerId: 'owner_002',
          createdAt: now,
          updatedAt: now,
        ));

        await db.farmDao.insertFarm(FarmsTableCompanion.insert(
          id: 'farm_003',
          name: 'Ferme Bio Roussillon',
          location: 'Pyrénées-Orientales, France',
          ownerId: 'owner_003',
          createdAt: now,
          updatedAt: now,
        ));

        await db.farmDao.insertFarm(FarmsTableCompanion.insert(
          id: 'farm_slaughterhouse',
          name: 'Abattoir de Montagne',
          location: 'Isère, France',
          ownerId: 'owner_slaughter',
          createdAt: now,
          updatedAt: now,
        ));
      } catch (e) {
        // Silent fail
      }

      print('$_tag   🐑 Creating species...');
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

      print('$_tag   🧬 Creating breeds...');
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
      // VETERINARIANS (Varied)
      // ════════════════════════════════════════════════════════════

      print('$_tag   🩺 Creating veterinarians...');
      try {
        final vets = [
          (
            'vet_001',
            'farm_default',
            'Jean',
            'Dupont',
            'VET-2024-001',
            '["Ovins","Bovins"]',
            '06 12 34 56 78'
          ),
          (
            'vet_002',
            'farm_default',
            'Marie',
            'Martin',
            'VET-2024-002',
            '["Caprins","Ovins"]',
            '06 98 76 54 32'
          ),
          (
            'vet_003',
            'farm_002',
            'Pierre',
            'Durand',
            'VET-2024-003',
            '["Bovins","Équins"]',
            '06 11 22 33 44'
          ),
        ];

        for (var vet in vets) {
          await db.veterinarianDao.insertItem(VeterinariansTableCompanion.insert(
            id: vet.$1,
            farmId: vet.$2,
            firstName: vet.$3,
            lastName: vet.$4,
            licenseNumber: vet.$5,
            specialties: vet.$6,
            phone: vet.$7,
            synced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ));
        }
      } catch (e) {
        // Silent fail
      }

      // ════════════════════════════════════════════════════════════
      // MEDICAL PRODUCTS (Varied)
      // ════════════════════════════════════════════════════════════

      print('$_tag   💊 Creating medical products...');
      try {
        final products = [
          (
            'prod_001',
            'farm_default',
            'Amoxicilline 500mg',
            'treatment',
            7,
            3,
            100.0,
            10.0,
            'ml'
          ),
          (
            'prod_002',
            'farm_default',
            'Ivermectine',
            'treatment',
            14,
            7,
            50.0,
            5.0,
            'ml'
          ),
          (
            'prod_003',
            'farm_default',
            'Vaccin Entérotoxémie',
            'vaccination',
            0,
            0,
            30.0,
            5.0,
            'doses'
          ),
          (
            'prod_004',
            'farm_default',
            'Anti-inflammatoire',
            'treatment',
            21,
            14,
            25.0,
            5.0,
            'ml'
          ),
          (
            'prod_005',
            'farm_default',
            'Complément Vitaminé',
            'supplement',
            0,
            0,
            200.0,
            20.0,
            'ml'
          ),
        ];

        for (var product in products) {
          await db.medicalProductDao
              .insertProduct(MedicalProductsTableCompanion.insert(
            id: product.$1,
            farmId: product.$2,
            name: product.$3,
            category: product.$4,
            withdrawalPeriodMeat: product.$5,
            withdrawalPeriodMilk: product.$6,
            currentStock: product.$7,
            minStock: product.$8,
            stockUnit: product.$9,
            synced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ));
        }
      } catch (e) {
        // Silent fail
      }

      // ════════════════════════════════════════════════════════════
      // ANIMALS (Comprehensive Variety)
      // ════════════════════════════════════════════════════════════

      print('$_tag   🐏 Creating comprehensive animal dataset...');
      try {
        // 1. NEWBORNS (moins de 30 jours) - 5 animaux
        for (int i = 1; i <= 5; i++) {
          await db.animalDao.insertItem(AnimalsTableCompanion.insert(
            id: 'newborn_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            currentEid: Value('FR001NB${i.toString().padLeft(5, '0')}'),
            birthDate: now.subtract(Duration(days: i * 5)),
            sex: i % 2 == 0 ? AnimalSex.male.name : AnimalSex.female.name,
            status: AnimalStatus.alive.name,
            speciesId: const Value('sheep'),
            breedId: Value(i % 2 == 0 ? 'merinos' : 'suffolk'),
            synced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ));
        }

        // 2. YOUNG (30-365 jours) - 10 animaux
        for (int i = 1; i <= 10; i++) {
          await db.animalDao.insertItem(AnimalsTableCompanion.insert(
            id: 'young_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            currentEid: Value('FR002YG${i.toString().padLeft(5, '0')}'),
            birthDate: now.subtract(Duration(days: 30 + (i * 30))),
            sex: i % 3 == 0 ? AnimalSex.male.name : AnimalSex.female.name,
            status: AnimalStatus.alive.name,
            speciesId: const Value('sheep'),
            breedId: Value(['merinos', 'suffolk', 'lacaune'][i % 3]),
            synced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ));
        }

        // 3. ADULTS (1-5 ans) - 15 animaux
        for (int i = 1; i <= 15; i++) {
          await db.animalDao.insertItem(AnimalsTableCompanion.insert(
            id: 'adult_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            currentEid: Value('FR003AD${i.toString().padLeft(5, '0')}'),
            birthDate: now.subtract(Duration(days: 365 + (i * 100))),
            sex: i % 2 == 0 ? AnimalSex.female.name : AnimalSex.male.name,
            status: AnimalStatus.alive.name,
            speciesId: const Value('sheep'),
            breedId: Value(['merinos', 'suffolk', 'lacaune'][i % 3]),
            synced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ));
        }

        // 4. ELDERLY (5+ ans) - 5 animaux
        for (int i = 1; i <= 5; i++) {
          await db.animalDao.insertItem(AnimalsTableCompanion.insert(
            id: 'elderly_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            currentEid: Value('FR004EL${i.toString().padLeft(5, '0')}'),
            birthDate: now.subtract(Duration(days: 1825 + (i * 200))),
            sex: AnimalSex.female.name,
            status: AnimalStatus.alive.name,
            speciesId: const Value('sheep'),
            breedId: const Value('merinos'),
            synced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ));
        }

        // 5. ANIMALS WITHOUT EID (test identification alerts) - 3 animaux
        for (int i = 1; i <= 3; i++) {
          await db.animalDao.insertItem(AnimalsTableCompanion.insert(
            id: 'no_eid_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            currentEid: const Value.absent(), // Pas d'EID
            birthDate: now.subtract(Duration(days: 60 + (i * 30))),
            sex: AnimalSex.female.name,
            status: AnimalStatus.alive.name,
            speciesId: const Value('sheep'),
            breedId: const Value('suffolk'),
            synced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ));
        }

        // 6. ANIMALS ON TEMPORARY MOVEMENT (prêt/transhumance) - 4 animaux
        for (int i = 1; i <= 4; i++) {
          await db.animalDao.insertItem(AnimalsTableCompanion.insert(
            id: 'temp_mov_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default', // Propriétaire
            currentLocationFarmId:
                Value(['farm_002', 'farm_003'][i % 2]), // Localisation actuelle
            currentEid: Value('FR005TM${i.toString().padLeft(5, '0')}'),
            birthDate: now.subtract(Duration(days: 400 + (i * 50))),
            sex: i % 2 == 0 ? AnimalSex.male.name : AnimalSex.female.name,
            status: AnimalStatus.onTemporaryMovement.name,
            speciesId: const Value('sheep'),
            breedId: const Value('lacaune'),
            synced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ));
        }

        // 7. DRAFT ANIMALS (brouillons non validés) - 3 animaux
        for (int i = 1; i <= 3; i++) {
          await db.animalDao.insertItem(AnimalsTableCompanion.insert(
            id: 'draft_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            currentEid: Value('FR006DR${i.toString().padLeft(5, '0')}'),
            birthDate: now.subtract(const Duration(days: 10)),
            sex: AnimalSex.female.name,
            status: AnimalStatus.draft.name,
            speciesId: const Value('sheep'),
            breedId: const Value('merinos'),
            synced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ));
        }

        // 8. SOLD ANIMALS (vendus) - 5 animaux
        for (int i = 1; i <= 5; i++) {
          await db.animalDao.insertItem(AnimalsTableCompanion.insert(
            id: 'sold_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            currentEid: Value('FR007SL${i.toString().padLeft(5, '0')}'),
            birthDate: now.subtract(Duration(days: 600 + (i * 50))),
            sex: AnimalSex.male.name,
            status: AnimalStatus.sold.name,
            speciesId: const Value('sheep'),
            breedId: const Value('suffolk'),
            synced: const Value(false),
            createdAt: now.subtract(const Duration(days: 30)),
            updatedAt: now.subtract(const Duration(days: 30)),
          ));
        }

        // 9. SLAUGHTERED ANIMALS (abattus) - 3 animaux
        for (int i = 1; i <= 3; i++) {
          await db.animalDao.insertItem(AnimalsTableCompanion.insert(
            id: 'slaughtered_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            currentEid: Value('FR008SL${i.toString().padLeft(5, '0')}'),
            birthDate: now.subtract(Duration(days: 800 + (i * 100))),
            sex: AnimalSex.male.name,
            status: AnimalStatus.slaughtered.name,
            speciesId: const Value('sheep'),
            breedId: const Value('merinos'),
            synced: const Value(false),
            createdAt: now.subtract(const Duration(days: 60)),
            updatedAt: now.subtract(const Duration(days: 60)),
          ));
        }

        // 10. DEAD ANIMALS (morts naturellement) - 2 animaux
        for (int i = 1; i <= 2; i++) {
          await db.animalDao.insertItem(AnimalsTableCompanion.insert(
            id: 'dead_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            currentEid: Value('FR009DD${i.toString().padLeft(5, '0')}'),
            birthDate: now.subtract(const Duration(days: 300)),
            sex: AnimalSex.female.name,
            status: AnimalStatus.dead.name,
            speciesId: const Value('sheep'),
            breedId: const Value('lacaune'),
            synced: const Value(false),
            createdAt: now.subtract(const Duration(days: 90)),
            updatedAt: now.subtract(const Duration(days: 90)),
          ));
        }

        // 11. CATTLE (bovins) - 5 animaux
        for (int i = 1; i <= 5; i++) {
          await db.animalDao.insertItem(AnimalsTableCompanion.insert(
            id: 'cattle_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_002',
            currentEid: Value('FR010CT${i.toString().padLeft(5, '0')}'),
            birthDate: now.subtract(Duration(days: 500 + (i * 100))),
            sex: i % 2 == 0 ? AnimalSex.female.name : AnimalSex.male.name,
            status: AnimalStatus.alive.name,
            speciesId: const Value('cattle'),
            breedId: Value(['holstein', 'charolais', 'limousin'][i % 3]),
            synced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ));
        }

        // 12. GOATS (caprins) - 5 animaux
        for (int i = 1; i <= 5; i++) {
          await db.animalDao.insertItem(AnimalsTableCompanion.insert(
            id: 'goat_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_003',
            currentEid: Value('FR011GT${i.toString().padLeft(5, '0')}'),
            birthDate: now.subtract(Duration(days: 300 + (i * 80))),
            sex: i % 2 == 0 ? AnimalSex.female.name : AnimalSex.male.name,
            status: AnimalStatus.alive.name,
            speciesId: const Value('goat'),
            breedId: Value(['alpine', 'saanen', 'angora'][i % 3]),
            synced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ));
        }

        print(
            '$_tag   ✅ Created ${5 + 10 + 15 + 5 + 3 + 4 + 3 + 5 + 3 + 2 + 5 + 5} comprehensive animals');
      } catch (e) {
        print('$_tag   ❌ Error creating animals: $e');
      }

      // ════════════════════════════════════════════════════════════
      // MOVEMENTS (All Types with Enriched Data)
      // ════════════════════════════════════════════════════════════

      print('$_tag   🚛 Creating comprehensive movements...');
      try {
        // 1. BIRTH MOVEMENTS (naissances) - 10 mouvements
        for (int i = 1; i <= 10; i++) {
          await db.movementDao.insertItem(MovementsTableCompanion.insert(
            id: 'mov_birth_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            animalId: 'newborn_${i <= 5 ? i.toString().padLeft(3, '0') : 'young_${(i - 5).toString().padLeft(3, '0')}'}',
            movementDate: now.subtract(Duration(days: i * 5)),
            type: 'birth',
            synced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ));
        }

        // 2. PURCHASE MOVEMENTS (achats) - 5 mouvements
        for (int i = 1; i <= 5; i++) {
          await db.movementDao.insertItem(MovementsTableCompanion.insert(
            id: 'mov_purchase_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            animalId: 'adult_${i.toString().padLeft(3, '0')}',
            movementDate: now.subtract(Duration(days: 365 + (i * 50))),
            type: 'purchase',
            fromFarmId: const Value('farm_002'),
            price: Value(150.0 + (i * 20)),
            notes: Value('Achat lors de la foire agricole'),
            synced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ));
        }

        // 3. SALE MOVEMENTS (ventes avec données structurées) - 5 mouvements
        for (int i = 1; i <= 5; i++) {
          await db.movementDao.insertItem(MovementsTableCompanion.insert(
            id: 'mov_sale_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            animalId: 'sold_${i.toString().padLeft(3, '0')}',
            movementDate: now.subtract(const Duration(days: 30)),
            type: 'sale',
            toFarmId: Value(i % 2 == 0 ? 'farm_002' : null),
            price: Value(200.0 + (i * 25)),
            // Phase 3: Données structurées pour ventes
            buyerName: Value(
                i % 2 == 0 ? null : ['M. Dubois', 'Mme Lefebvre', 'M. Rousseau'][i % 3]),
            buyerFarmId: Value(i % 2 == 0 ? 'farm_002' : null),
            buyerType: Value(i % 2 == 0 ? 'farm' : 'individual'),
            notes: Value('Vente directe'),
            synced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ));
        }

        // 4. SLAUGHTER MOVEMENTS (abattages avec données structurées) - 3 mouvements
        for (int i = 1; i <= 3; i++) {
          await db.movementDao.insertItem(MovementsTableCompanion.insert(
            id: 'mov_slaughter_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            animalId: 'slaughtered_${i.toString().padLeft(3, '0')}',
            movementDate: now.subtract(const Duration(days: 60)),
            type: 'slaughter',
            // Phase 3: Données structurées pour abattages
            slaughterhouseName: const Value('Abattoir de Montagne'),
            slaughterhouseId: const Value('farm_slaughterhouse'),
            notes: Value('Abattage conforme bio'),
            synced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ));
        }

        // 5. TEMPORARY OUT (prêt, transhumance) - 6 mouvements
        final tempTypes = [
          ('loan', 'Prêt pour reproduction'),
          ('transhumance', 'Transhumance estivale'),
          ('boarding', 'Pension temporaire'),
        ];

        for (int i = 1; i <= 4; i++) {
          final typeIdx = i % 3;
          await db.movementDao.insertItem(MovementsTableCompanion.insert(
            id: 'mov_temp_out_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            animalId: 'temp_mov_${i.toString().padLeft(3, '0')}',
            movementDate: now.subtract(Duration(days: 20 + (i * 10))),
            type: 'temporaryOut',
            toFarmId: Value(['farm_002', 'farm_003'][i % 2]),
            // Phase 3: Données mouvements temporaires
            isTemporary: const Value(true),
            temporaryMovementType: Value(tempTypes[typeIdx].$1),
            expectedReturnDate:
                Value(now.add(Duration(days: i <= 2 ? (30 - i * 15) : -(i * 5)))),
            notes: Value(tempTypes[typeIdx].$2),
            synced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ));
        }

        // 6. TEMPORARY RETURN (retours) - 2 mouvements (les 2 premiers sont revenus)
        for (int i = 1; i <= 2; i++) {
          await db.movementDao.insertItem(MovementsTableCompanion.insert(
            id: 'mov_temp_return_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            animalId: 'temp_mov_${i.toString().padLeft(3, '0')}',
            movementDate: now.subtract(Duration(days: 5 + i)),
            type: 'temporaryReturn',
            fromFarmId: Value(['farm_002', 'farm_003'][i % 2]),
            // Phase 3: Lien bidirectionnel
            isTemporary: const Value(true),
            temporaryMovementType: const Value('return'),
            relatedMovementId:
                Value('mov_temp_out_${i.toString().padLeft(3, '0')}'),
            notes: const Value('Retour de mouvement temporaire'),
            synced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ));
        }

        // 7. DEATH MOVEMENTS (morts naturelles) - 2 mouvements
        for (int i = 1; i <= 2; i++) {
          await db.movementDao.insertItem(MovementsTableCompanion.insert(
            id: 'mov_death_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            animalId: 'dead_${i.toString().padLeft(3, '0')}',
            movementDate: now.subtract(const Duration(days: 90)),
            type: 'death',
            notes: Value(i == 1 ? 'Mort naturelle - vieillesse' : 'Accident'),
            synced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ));
        }

        print('$_tag   ✅ Created ${10 + 5 + 5 + 3 + 4 + 2 + 2} comprehensive movements');
      } catch (e) {
        print('$_tag   ❌ Error creating movements: $e');
      }

      // ════════════════════════════════════════════════════════════
      // LOTS (Open, Closed, Archived for Migration Testing)
      // ════════════════════════════════════════════════════════════

      print('$_tag   📦 Creating varied lots...');
      try {
        // 1. OPEN LOTS (actifs) - 3 lots
        await db.lotDao.insertLot(LotsTableCompanion.insert(
          id: 'lot_open_treatment_001',
          farmId: 'farm_default',
          name: 'Traitement Antiparasitaire Printemps',
          animalIdsJson: '["young_001","young_002","young_003"]',
          status: const Value('open'),
          completed: const Value(false),
          synced: const Value(false),
          createdAt: now.subtract(const Duration(days: 5)),
          updatedAt: now,
        ));

        await db.lotDao.insertLot(LotsTableCompanion.insert(
          id: 'lot_open_sale_001',
          farmId: 'farm_default',
          name: 'Lot de Vente Automne 2024',
          animalIdsJson: '["adult_001","adult_002","adult_003","adult_004"]',
          status: const Value('open'),
          completed: const Value(false),
          synced: const Value(false),
          createdAt: now.subtract(const Duration(days: 2)),
          updatedAt: now,
        ));

        await db.lotDao.insertLot(LotsTableCompanion.insert(
          id: 'lot_open_slaughter_001',
          farmId: 'farm_default',
          name: 'Lot Abattage Décembre',
          animalIdsJson: '["adult_005","adult_006"]',
          status: const Value('open'),
          completed: const Value(false),
          synced: const Value(false),
          createdAt: now.subtract(const Duration(days: 1)),
          updatedAt: now,
        ));

        // 2. CLOSED LOTS (fermés, pour test migration) - 4 lots
        // Ces lots sont fermés MAIS n'ont PAS de Movement records
        // Phase 5 migration utility va les détecter comme "orphelins"
        await db.lotDao.insertLot(LotsTableCompanion.insert(
          id: 'lot_closed_sale_orphan_001',
          farmId: 'farm_default',
          name: 'Vente Juillet 2024 (ORPHELIN)',
          animalIdsJson: '["adult_007","adult_008"]',
          status: const Value('closed'),
          completed: const Value(true),
          completedAt: Value(now.subtract(const Duration(days: 120))),
          // Champs deprecated (Phase 4) - utilisés pour migration
          buyerName: const Value('Coopérative Agricole du Midi'),
          buyerFarmId: const Value.absent(),
          pricePerAnimal: const Value(180.0),
          synced: const Value(false),
          createdAt: now.subtract(const Duration(days: 125)),
          updatedAt: now.subtract(const Duration(days: 120)),
        ));

        await db.lotDao.insertLot(LotsTableCompanion.insert(
          id: 'lot_closed_sale_orphan_002',
          farmId: 'farm_default',
          name: 'Vente Particulier Août (ORPHELIN)',
          animalIdsJson: '["adult_009"]',
          status: const Value('closed'),
          completed: const Value(true),
          completedAt: Value(now.subtract(const Duration(days: 90))),
          // Champs deprecated
          buyerName: const Value('M. Jean Petit'),
          pricePerAnimal: const Value(210.0),
          synced: const Value(false),
          createdAt: now.subtract(const Duration(days: 95)),
          updatedAt: now.subtract(const Duration(days: 90)),
        ));

        await db.lotDao.insertLot(LotsTableCompanion.insert(
          id: 'lot_closed_slaughter_orphan_001',
          farmId: 'farm_default',
          name: 'Abattage Septembre 2024 (ORPHELIN)',
          animalIdsJson: '["adult_010","adult_011"]',
          status: const Value('closed'),
          completed: const Value(true),
          completedAt: Value(now.subtract(const Duration(days: 75))),
          // Champs deprecated
          slaughterhouseName: const Value('Abattoir de Montagne'),
          slaughterhouseId: const Value('farm_slaughterhouse'),
          synced: const Value(false),
          createdAt: now.subtract(const Duration(days: 80)),
          updatedAt: now.subtract(const Duration(days: 75)),
        ));

        await db.lotDao.insertLot(LotsTableCompanion.insert(
          id: 'lot_closed_treatment_001',
          farmId: 'farm_default',
          name: 'Traitement Vaccinal Juin (Fermé)',
          animalIdsJson: '["elderly_001","elderly_002","elderly_003"]',
          status: const Value('closed'),
          completed: const Value(true),
          completedAt: Value(now.subtract(const Duration(days: 150))),
          synced: const Value(false),
          createdAt: now.subtract(const Duration(days: 155)),
          updatedAt: now.subtract(const Duration(days: 150)),
        ));

        // 3. ARCHIVED LOTS (archivés, pour test migration) - 2 lots
        await db.lotDao.insertLot(LotsTableCompanion.insert(
          id: 'lot_archived_sale_orphan_001',
          farmId: 'farm_default',
          name: 'Vente Printemps 2024 (ARCHIVÉ ORPHELIN)',
          animalIdsJson: '["adult_012","adult_013","adult_014"]',
          status: const Value('archived'),
          completed: const Value(true),
          completedAt: Value(now.subtract(const Duration(days: 200))),
          // Champs deprecated
          buyerName: const Value('Ferme Bio Roussillon'),
          buyerFarmId: const Value('farm_003'),
          pricePerAnimal: const Value(195.0),
          synced: const Value(false),
          createdAt: now.subtract(const Duration(days: 210)),
          updatedAt: now.subtract(const Duration(days: 200)),
        ));

        await db.lotDao.insertLot(LotsTableCompanion.insert(
          id: 'lot_archived_slaughter_orphan_001',
          farmId: 'farm_default',
          name: 'Abattage Hiver 2023 (ARCHIVÉ ORPHELIN)',
          animalIdsJson: '["adult_015"]',
          status: const Value('archived'),
          completed: const Value(true),
          completedAt: Value(now.subtract(const Duration(days: 300))),
          // Champs deprecated
          slaughterhouseName: const Value('Abattoir de Montagne'),
          slaughterhouseId: const Value('farm_slaughterhouse'),
          synced: const Value(false),
          createdAt: now.subtract(const Duration(days: 310)),
          updatedAt: now.subtract(const Duration(days: 300)),
        ));

        print('$_tag   ✅ Created ${3 + 4 + 2} varied lots (3 open, 6 orphaned for migration)');
      } catch (e) {
        print('$_tag   ❌ Error creating lots: $e');
      }

      // ════════════════════════════════════════════════════════════
      // TREATMENTS (Active & Expired Withdrawal Periods)
      // ════════════════════════════════════════════════════════════

      print('$_tag   💉 Creating treatments with varied withdrawal periods...');
      try {
        // 1. ACTIVE WITHDRAWAL PERIODS (en cours) - 5 traitements
        for (int i = 1; i <= 5; i++) {
          await db.treatmentDao.insertItem(TreatmentsTableCompanion.insert(
            id: 'treat_active_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            animalId: 'young_${i.toString().padLeft(3, '0')}',
            productId: i % 2 == 0 ? 'prod_001' : 'prod_002',
            productName: i % 2 == 0 ? 'Amoxicilline 500mg' : 'Ivermectine',
            treatmentDate: now.subtract(Duration(days: i)),
            dose: 5.0 + i,
            withdrawalEndDate:
                now.add(Duration(days: (i % 2 == 0 ? 7 : 14) - i)),
            notes: const Value('Traitement antiparasitaire'),
            synced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ));
        }

        // 2. EXPIRED WITHDRAWAL PERIODS (terminés) - 8 traitements
        for (int i = 1; i <= 8; i++) {
          await db.treatmentDao.insertItem(TreatmentsTableCompanion.insert(
            id: 'treat_expired_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            animalId: 'adult_${i.toString().padLeft(3, '0')}',
            productId: ['prod_001', 'prod_002', 'prod_004'][i % 3],
            productName: [
              'Amoxicilline 500mg',
              'Ivermectine',
              'Anti-inflammatoire'
            ][i % 3],
            treatmentDate: now.subtract(Duration(days: 30 + (i * 10))),
            dose: 8.0 + i,
            withdrawalEndDate: now.subtract(Duration(days: 15 + (i * 5))),
            notes: Value(i % 3 == 0 ? 'Infection respiratoire' : null),
            synced: const Value(false),
            createdAt: now.subtract(Duration(days: 30 + (i * 10))),
            updatedAt: now.subtract(Duration(days: 30 + (i * 10))),
          ));
        }

        // 3. RECENT TREATMENTS (aujourd'hui) - 2 traitements
        for (int i = 1; i <= 2; i++) {
          await db.treatmentDao.insertItem(TreatmentsTableCompanion.insert(
            id: 'treat_today_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            animalId: 'elderly_${i.toString().padLeft(3, '0')}',
            productId: 'prod_001',
            productName: 'Amoxicilline 500mg',
            treatmentDate: now,
            dose: 10.0,
            withdrawalEndDate: now.add(const Duration(days: 7)),
            notes: const Value('Infection détectée ce matin'),
            synced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ));
        }

        print('$_tag   ✅ Created ${5 + 8 + 2} treatments (5 active, 8 expired, 2 today)');
      } catch (e) {
        print('$_tag   ❌ Error creating treatments: $e');
      }

      // ════════════════════════════════════════════════════════════
      // VACCINATIONS (Varied Types & Dates)
      // ════════════════════════════════════════════════════════════

      print('$_tag   💉 Creating vaccinations...');
      try {
        // 1. RECENT VACCINATIONS (moins de 30 jours) - 5 vaccinations
        for (int i = 1; i <= 5; i++) {
          await db.vaccinationDao.insertItem(VaccinationsTableCompanion.insert(
            id: 'vacc_recent_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            animalIds: '["young_${i.toString().padLeft(3, '0')}"]',
            vaccineName: i % 2 == 0
                ? 'Vaccin Entérotoxémie'
                : 'Vaccin Pasteurellose',
            type: 'obligatoire',
            disease: i % 2 == 0
                ? 'Entérotoxémie'
                : 'Pasteurellose',
            vaccinationDate: now.subtract(Duration(days: i * 5)),
            dose: '2 ml',
            administrationRoute: 'sous-cutanée',
            withdrawalPeriodDays: 0,
            boosterDate: Value(now.add(Duration(days: 365 - (i * 5)))),
            synced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ));
        }

        // 2. BATCH VACCINATIONS (plusieurs animaux) - 3 vaccinations
        for (int i = 1; i <= 3; i++) {
          await db.vaccinationDao.insertItem(VaccinationsTableCompanion.insert(
            id: 'vacc_batch_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            animalIds:
                '["adult_${(i * 3 - 2).toString().padLeft(3, '0')}","adult_${(i * 3 - 1).toString().padLeft(3, '0')}","adult_${(i * 3).toString().padLeft(3, '0')}"]',
            vaccineName: 'Vaccin Ectima',
            type: 'obligatoire',
            disease: 'Ectima Contagieux',
            vaccinationDate: now.subtract(Duration(days: 60 + (i * 30))),
            dose: '1 ml',
            administrationRoute: 'intramusculaire',
            withdrawalPeriodDays: 0,
            notes: Value('Vaccination de lot - ${i * 3} animaux'),
            synced: const Value(false),
            createdAt: now.subtract(Duration(days: 60 + (i * 30))),
            updatedAt: now.subtract(Duration(days: 60 + (i * 30))),
          ));
        }

        // 3. OLD VACCINATIONS (plus de 6 mois) - 3 vaccinations
        for (int i = 1; i <= 3; i++) {
          await db.vaccinationDao.insertItem(VaccinationsTableCompanion.insert(
            id: 'vacc_old_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            animalIds: '["elderly_${i.toString().padLeft(3, '0')}"]',
            vaccineName: 'Vaccin Brucellose',
            type: 'facultatif',
            disease: 'Brucellose',
            vaccinationDate: now.subtract(Duration(days: 180 + (i * 50))),
            dose: '2 ml',
            administrationRoute: 'sous-cutanée',
            withdrawalPeriodDays: 0,
            boosterDate: Value(now.subtract(Duration(days: i * 10))),
            notes: const Value('Rappel nécessaire'),
            synced: const Value(false),
            createdAt: now.subtract(Duration(days: 180 + (i * 50))),
            updatedAt: now.subtract(Duration(days: 180 + (i * 50))),
          ));
        }

        print('$_tag   ✅ Created ${5 + 3 + 3} vaccinations (5 recent, 3 batch, 3 old)');
      } catch (e) {
        print('$_tag   ❌ Error creating vaccinations: $e');
      }

      // ════════════════════════════════════════════════════════════
      // WEIGHTS (Growth Tracking - Multiple Weights per Animal)
      // ════════════════════════════════════════════════════════════

      print('$_tag   ⚖️  Creating weight tracking data...');
      try {
        // 1. GROWTH CURVE for Young Animals (3-5 pesées par animal)
        for (int animalIdx = 1; animalIdx <= 5; animalIdx++) {
          final birthDate = now.subtract(Duration(days: 30 + (animalIdx * 30)));
          final baseWeight = 4.0 + animalIdx;

          // Pesée à la naissance
          await db.weightDao.insertItem(WeightsTableCompanion.insert(
            id: 'weight_young_${animalIdx}_birth',
            farmId: 'farm_default',
            animalId: 'young_${animalIdx.toString().padLeft(3, '0')}',
            recordedAt: birthDate.add(const Duration(days: 1)),
            weight: baseWeight,
            source: 'scale',
            notes: const Value('Pesée à la naissance'),
            synced: const Value(false),
            createdAt: birthDate.add(const Duration(days: 1)),
            updatedAt: birthDate.add(const Duration(days: 1)),
          ));

          // Pesée à 1 mois
          await db.weightDao.insertItem(WeightsTableCompanion.insert(
            id: 'weight_young_${animalIdx}_1month',
            farmId: 'farm_default',
            animalId: 'young_${animalIdx.toString().padLeft(3, '0')}',
            recordedAt: birthDate.add(const Duration(days: 30)),
            weight: baseWeight + 8.0,
            source: 'scale',
            notes: const Value('Croissance normale'),
            synced: const Value(false),
            createdAt: birthDate.add(const Duration(days: 30)),
            updatedAt: birthDate.add(const Duration(days: 30)),
          ));

          // Pesée à 2 mois
          await db.weightDao.insertItem(WeightsTableCompanion.insert(
            id: 'weight_young_${animalIdx}_2months',
            farmId: 'farm_default',
            animalId: 'young_${animalIdx.toString().padLeft(3, '0')}',
            recordedAt: birthDate.add(const Duration(days: 60)),
            weight: baseWeight + 18.0,
            source: 'scale',
            notes: const Value('Bonne croissance'),
            synced: const Value(false),
            createdAt: birthDate.add(const Duration(days: 60)),
            updatedAt: birthDate.add(const Duration(days: 60)),
          ));

          // Pesée récente (estimation)
          if (animalIdx <= 3) {
            await db.weightDao.insertItem(WeightsTableCompanion.insert(
              id: 'weight_young_${animalIdx}_recent',
              farmId: 'farm_default',
              animalId: 'young_${animalIdx.toString().padLeft(3, '0')}',
              recordedAt: now.subtract(const Duration(days: 3)),
              weight: baseWeight + 25.0,
              source: 'estimation',
              notes: const Value('Estimation visuelle'),
              synced: const Value(false),
              createdAt: now.subtract(const Duration(days: 3)),
              updatedAt: now.subtract(const Duration(days: 3)),
            ));
          }
        }

        // 2. ADULT WEIGHTS (pesées régulières) - 10 pesées
        for (int i = 1; i <= 10; i++) {
          await db.weightDao.insertItem(WeightsTableCompanion.insert(
            id: 'weight_adult_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            animalId: 'adult_${i.toString().padLeft(3, '0')}',
            recordedAt: now.subtract(Duration(days: i * 15)),
            weight: 45.0 + (i * 2.5),
            source: i % 3 == 0 ? 'estimation' : 'scale',
            notes:
                Value(i % 3 == 0 ? 'Estimation' : 'Pesée de contrôle'),
            synced: const Value(false),
            createdAt: now.subtract(Duration(days: i * 15)),
            updatedAt: now.subtract(Duration(days: i * 15)),
          ));
        }

        // 3. ELDERLY WEIGHTS (monitoring santé) - 5 pesées
        for (int i = 1; i <= 5; i++) {
          await db.weightDao.insertItem(WeightsTableCompanion.insert(
            id: 'weight_elderly_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            animalId: 'elderly_${i.toString().padLeft(3, '0')}',
            recordedAt: now.subtract(Duration(days: i * 30)),
            weight: 50.0 - (i * 2.0), // Perte de poids progressive
            source: 'scale',
            notes: Value(i > 3
                ? 'Surveillance perte de poids'
                : 'Poids stable'),
            synced: const Value(false),
            createdAt: now.subtract(Duration(days: i * 30)),
            updatedAt: now.subtract(Duration(days: i * 30)),
          ));
        }

        print(
            '$_tag   ✅ Created ${(5 * 4) + 10 + 5} weight records (growth curves + monitoring)');
      } catch (e) {
        print('$_tag   ❌ Error creating weights: $e');
      }

      // ════════════════════════════════════════════════════════════
      // BATCHES (Varied Purposes)
      // ════════════════════════════════════════════════════════════

      print('$_tag   📋 Creating batches...');
      try {
        await db.batchDao.insertBatch(BatchesTableCompanion.insert(
          id: 'batch_001',
          farmId: 'farm_default',
          purpose: 'treatment',
          name: 'Traitement Antiparasitaire Octobre',
          animalIdsJson:
              '["young_001","young_002","young_003","young_004","young_005"]',
          synced: const Value(false),
          createdAt: now.subtract(const Duration(days: 10)),
          updatedAt: now,
        ));

        await db.batchDao.insertBatch(BatchesTableCompanion.insert(
          id: 'batch_002',
          farmId: 'farm_default',
          purpose: 'vaccination',
          name: 'Vaccination Ectima Printemps',
          animalIdsJson: '["adult_001","adult_002","adult_003"]',
          synced: const Value(false),
          createdAt: now.subtract(const Duration(days: 60)),
          updatedAt: now.subtract(const Duration(days: 60)),
        ));

        await db.batchDao.insertBatch(BatchesTableCompanion.insert(
          id: 'batch_003',
          farmId: 'farm_default',
          purpose: 'weighing',
          name: 'Pesée Mensuelle Novembre',
          animalIdsJson: '["newborn_001","newborn_002","newborn_003"]',
          synced: const Value(false),
          createdAt: now.subtract(const Duration(days: 2)),
          updatedAt: now,
        ));

        print('$_tag   ✅ Created 3 batches');
      } catch (e) {
        print('$_tag   ❌ Error creating batches: $e');
      }

      // ════════════════════════════════════════════════════════════
      // ALERT CONFIGURATIONS (Keep existing)
      // ════════════════════════════════════════════════════════════

      print('$_tag   🔔 Creating alert configurations...');
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

        print('$_tag   ✅ Created 7 alert configurations');
      } catch (e) {
        print('$_tag   ❌ Error creating alert configs: $e');
      }

      print('$_tag ✅ Comprehensive test data seeding complete!');
      print('');
      print('$_tag 📊 SUMMARY:');
      print('$_tag   - 4 Farms (including slaughterhouse)');
      print('$_tag   - 3 Species, 9 Breeds');
      print('$_tag   - 3 Veterinarians');
      print('$_tag   - 5 Medical Products');
      print('$_tag   - 65 Animals (varied ages, statuses, species)');
      print('$_tag   - 31 Movements (all types with enriched data)');
      print('$_tag   - 9 Lots (3 open, 6 orphaned for migration)');
      print('$_tag   - 15 Treatments (active/expired withdrawal)');
      print('$_tag   - 11 Vaccinations (recent/batch/old)');
      print('$_tag   - 35 Weight Records (growth tracking)');
      print('$_tag   - 3 Batches');
      print('$_tag   - 7 Alert Configurations');
      print('');
    } catch (e) {
      print('$_tag ❌ Fatal error during seeding: $e');
    }
  }
}
