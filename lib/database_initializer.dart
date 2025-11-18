// lib/database_initializer.dart
import 'dart:math';
import 'package:drift/drift.dart';
import 'package:animal_trace/drift/database.dart';
import 'package:animal_trace/models/animal.dart';
import 'package:animal_trace/utils/constants.dart';

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
      // MEDICAL PRODUCTS (Varied - Treatments + Vaccines)
      // ════════════════════════════════════════════════════════════

      print('$_tag   💊 Creating medical products...');
      try {
        // TRAITEMENTS (type = 'treatment')
        final treatments = [
          {
            'id': 'prod_treat_001',
            'name': 'Amoxicilline 500mg',
            'commercialName': 'Duphamox LA',
            'category': 'Antibiotique',
            'type': 'treatment',
            'targetSpecies': 'ovin,bovin,caprin',
            'withdrawalMeat': 7,
            'withdrawalMilk': 3,
            'currentStock': 100.0,
            'minStock': 10.0,
            'stockUnit': 'ml',
            'standardCureDays': 5,
            'administrationFrequency': '1x/jour',
            'dosageFormula': '0.5ml/10kg',
            'defaultRoute': 'IM',
            'defaultSite': 'Encolure',
          },
          {
            'id': 'prod_treat_002',
            'name': 'Ivermectine 1%',
            'commercialName': 'Ivomec',
            'category': 'Antiparasitaire',
            'type': 'treatment',
            'targetSpecies': 'ovin,bovin,caprin',
            'withdrawalMeat': 14,
            'withdrawalMilk': 7,
            'currentStock': 50.0,
            'minStock': 5.0,
            'stockUnit': 'ml',
            'standardCureDays': 1,
            'administrationFrequency': 'Dose unique',
            'dosageFormula': '0.2ml/10kg',
            'defaultRoute': 'SC',
            'defaultSite': 'Encolure',
          },
          {
            'id': 'prod_treat_003',
            'name': 'Anti-inflammatoire',
            'commercialName': 'Metacam',
            'category': 'Anti-inflammatoire',
            'type': 'treatment',
            'targetSpecies': 'ovin,bovin,caprin',
            'withdrawalMeat': 21,
            'withdrawalMilk': 14,
            'currentStock': 25.0,
            'minStock': 5.0,
            'stockUnit': 'ml',
            'standardCureDays': 3,
            'administrationFrequency': '1x/jour',
            'dosageFormula': '0.4ml/10kg',
            'defaultRoute': 'SC',
            'defaultSite': 'Encolure',
          },
          {
            'id': 'prod_treat_004',
            'name': 'Oxytétracycline LA',
            'commercialName': 'Terramycin',
            'category': 'Antibiotique',
            'type': 'treatment',
            'targetSpecies': 'ovin,bovin,caprin',
            'withdrawalMeat': 28,
            'withdrawalMilk': 7,
            'currentStock': 80.0,
            'minStock': 15.0,
            'stockUnit': 'ml',
            'standardCureDays': 3,
            'administrationFrequency': 'Tous les 3 jours',
            'dosageFormula': '1ml/10kg',
            'defaultRoute': 'IM',
            'defaultSite': 'Cuisse',
          },
          {
            'id': 'prod_treat_005',
            'name': 'Complément Vitaminé',
            'commercialName': 'VitaBoost',
            'category': 'Supplément',
            'type': 'treatment',
            'targetSpecies': 'ovin,bovin,caprin',
            'withdrawalMeat': 0,
            'withdrawalMilk': 0,
            'currentStock': 200.0,
            'minStock': 20.0,
            'stockUnit': 'ml',
            'standardCureDays': 1,
            'administrationFrequency': 'Dose unique',
            'dosageFormula': '5ml/animal',
            'defaultRoute': 'IM',
            'defaultSite': 'Encolure',
          },
        ];

        for (var t in treatments) {
          await db.medicalProductDao
              .insertProduct(MedicalProductsTableCompanion.insert(
            id: t['id'] as String,
            farmId: 'farm_default',
            name: t['name'] as String,
            commercialName: Value(t['commercialName'] as String?),
            category: t['category'] as String,
            type: Value(t['type'] as String),
            targetSpecies: Value(t['targetSpecies'] as String),
            withdrawalPeriodMeat: t['withdrawalMeat'] as int,
            withdrawalPeriodMilk: t['withdrawalMilk'] as int,
            currentStock: t['currentStock'] as double,
            minStock: t['minStock'] as double,
            stockUnit: t['stockUnit'] as String,
            standardCureDays: Value(t['standardCureDays'] as int?),
            administrationFrequency: Value(t['administrationFrequency'] as String?),
            dosageFormula: Value(t['dosageFormula'] as String?),
            defaultAdministrationRoute: Value(t['defaultRoute'] as String?),
            defaultInjectionSite: Value(t['defaultSite'] as String?),
            synced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ));
        }

        // VACCINS (type = 'vaccine')
        final vaccines = [
          {
            'id': 'prod_vacc_001',
            'name': 'Vaccin Entérotoxémie',
            'commercialName': 'Covexin 10',
            'category': 'Entérotoxémie',
            'type': 'vaccine',
            'targetSpecies': 'ovin,caprin',
            'withdrawalMeat': 0,
            'withdrawalMilk': 0,
            'currentStock': 30.0,
            'minStock': 5.0,
            'stockUnit': 'doses',
            'vaccinationProtocol': 'Primo: 2 injections à 4 semaines d\'intervalle. Rappel annuel.',
            'reminderDays': '28,365',
            'dosageFormula': '2ml/animal',
            'defaultRoute': 'SC',
            'defaultSite': 'Encolure',
          },
          {
            'id': 'prod_vacc_002',
            'name': 'Vaccin Pasteurellose',
            'commercialName': 'Pasteurella',
            'category': 'Pasteurellose',
            'type': 'vaccine',
            'targetSpecies': 'ovin,bovin,caprin',
            'withdrawalMeat': 0,
            'withdrawalMilk': 0,
            'currentStock': 25.0,
            'minStock': 5.0,
            'stockUnit': 'doses',
            'vaccinationProtocol': 'Primo: 2 injections à 3 semaines. Rappel: 1 an.',
            'reminderDays': '21,365',
            'dosageFormula': '2ml/animal',
            'defaultRoute': 'SC',
            'defaultSite': 'Encolure',
          },
          {
            'id': 'prod_vacc_003',
            'name': 'Vaccin Ectima Contagieux',
            'commercialName': 'EctiVax',
            'category': 'Ectima',
            'type': 'vaccine',
            'targetSpecies': 'ovin,caprin',
            'withdrawalMeat': 0,
            'withdrawalMilk': 0,
            'currentStock': 20.0,
            'minStock': 5.0,
            'stockUnit': 'doses',
            'vaccinationProtocol': 'Scarification unique. Protection 1 an.',
            'reminderDays': '365',
            'dosageFormula': '1 scarification/animal',
            'defaultRoute': 'ID',
            'defaultSite': 'Face interne cuisse',
          },
          {
            'id': 'prod_vacc_004',
            'name': 'Vaccin Fièvre Aphteuse',
            'commercialName': 'Aftopor',
            'category': 'Fièvre Aphteuse',
            'type': 'vaccine',
            'targetSpecies': 'ovin,bovin,caprin',
            'withdrawalMeat': 0,
            'withdrawalMilk': 0,
            'currentStock': 15.0,
            'minStock': 5.0,
            'stockUnit': 'doses',
            'vaccinationProtocol': 'Primo: 2 doses à 1 mois. Rappel tous les 6 mois.',
            'reminderDays': '30,180,365',
            'dosageFormula': '2ml/animal',
            'defaultRoute': 'IM',
            'defaultSite': 'Encolure',
          },
          {
            'id': 'prod_vacc_005',
            'name': 'Vaccin Brucellose',
            'commercialName': 'Brucelvax',
            'category': 'Brucellose',
            'type': 'vaccine',
            'targetSpecies': 'bovin,caprin',
            'withdrawalMeat': 0,
            'withdrawalMilk': 0,
            'currentStock': 12.0,
            'minStock': 3.0,
            'stockUnit': 'doses',
            'vaccinationProtocol': 'Vaccin obligatoire. Dose unique. Rappel tous les 2 ans.',
            'reminderDays': '730',
            'dosageFormula': '2ml/animal',
            'defaultRoute': 'SC',
            'defaultSite': 'Encolure',
          },
        ];

        for (var v in vaccines) {
          await db.medicalProductDao
              .insertProduct(MedicalProductsTableCompanion.insert(
            id: v['id'] as String,
            farmId: 'farm_default',
            name: v['name'] as String,
            commercialName: Value(v['commercialName'] as String?),
            category: v['category'] as String,
            type: Value(v['type'] as String),
            targetSpecies: Value(v['targetSpecies'] as String),
            withdrawalPeriodMeat: v['withdrawalMeat'] as int,
            withdrawalPeriodMilk: v['withdrawalMilk'] as int,
            currentStock: v['currentStock'] as double,
            minStock: v['minStock'] as double,
            stockUnit: v['stockUnit'] as String,
            vaccinationProtocol: Value(v['vaccinationProtocol'] as String?),
            reminderDays: Value(v['reminderDays'] as String?),
            dosageFormula: Value(v['dosageFormula'] as String?),
            defaultAdministrationRoute: Value(v['defaultRoute'] as String?),
            defaultInjectionSite: Value(v['defaultSite'] as String?),
            synced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ));
        }

        print('$_tag   ✅ Created ${treatments.length + vaccines.length} medical products (${treatments.length} treatments + ${vaccines.length} vaccines)');
      } catch (e) {
        print('$_tag   ❌ Error creating medical products: $e');
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
        // NOTE: Birth movements are NOT created as they are not business movements
        // Births are tracked as animal records, not movement transactions

        // 1. PURCHASE MOVEMENTS (achats) - 5 mouvements
        for (int i = 1; i <= 5; i++) {
          await db.movementDao.insertItem(MovementsTableCompanion.insert(
            id: 'mov_purchase_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            animalId: 'adult_${i.toString().padLeft(3, '0')}',
            movementDate: now.subtract(Duration(days: 365 + (i * 50))),
            type: 'purchase',
            status: 'ongoing', // Purchases start as ongoing, need validation
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
            status: 'ongoing', // Sales start as ongoing, need validation
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
            status: 'closed', // Slaughter events are immediately closed
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
            status: 'ongoing', // Temporary out movements start as ongoing
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

        // 6. DEATH MOVEMENTS (morts naturelles) - 2 mouvements
        for (int i = 1; i <= 2; i++) {
          await db.movementDao.insertItem(MovementsTableCompanion.insert(
            id: 'mov_death_${i.toString().padLeft(3, '0')}',
            farmId: 'farm_default',
            animalId: 'dead_${i.toString().padLeft(3, '0')}',
            movementDate: now.subtract(const Duration(days: 90)),
            type: 'death',
            status: 'closed', // Death events are immediately closed
            notes: Value(i == 1 ? 'Mort naturelle - vieillesse' : 'Accident'),
            synced: const Value(false),
            createdAt: now,
            updatedAt: now,
          ));
        }

        print('$_tag   ✅ Created ${5 + 5 + 3 + 4 + 2} comprehensive movements (births excluded)');
      } catch (e) {
        print('$_tag   ❌ Error creating movements: $e');
      }

      // ════════════════════════════════════════════════════════════
      // LOTS (Open)
      // ════════════════════════════════════════════════════════════

      print('$_tag   📦 Creating lots...');
      try {
        // OPEN LOTS (actifs) - 3 lots
        await db.lotDao.insertLot(LotsTableCompanion.insert(
          id: 'lot_open_treatment_001',
          farmId: 'farm_default',
          name: 'Traitement Antiparasitaire Printemps',
          status: const Value('open'),
          completed: const Value(false),
          synced: const Value(false),
          createdAt: now.subtract(const Duration(days: 5)),
          updatedAt: now,
        ));
        // Ajouter les animaux via lot_animals
        await db.lotAnimalDao.addAnimalsToLot(
          'lot_open_treatment_001',
          ['young_001', 'young_002', 'young_003'],
        );

        await db.lotDao.insertLot(LotsTableCompanion.insert(
          id: 'lot_open_sale_001',
          farmId: 'farm_default',
          name: 'Lot de Vente Automne 2024',
          status: const Value('open'),
          completed: const Value(false),
          synced: const Value(false),
          createdAt: now.subtract(const Duration(days: 2)),
          updatedAt: now,
        ));
        // Ajouter les animaux via lot_animals
        await db.lotAnimalDao.addAnimalsToLot(
          'lot_open_sale_001',
          ['adult_001', 'adult_002', 'adult_003', 'adult_004'],
        );

        await db.lotDao.insertLot(LotsTableCompanion.insert(
          id: 'lot_open_slaughter_001',
          farmId: 'farm_default',
          name: 'Lot Abattage Décembre',
          status: const Value('open'),
          completed: const Value(false),
          synced: const Value(false),
          createdAt: now.subtract(const Duration(days: 1)),
          updatedAt: now,
        ));
        // Ajouter les animaux via lot_animals
        await db.lotAnimalDao.addAnimalsToLot(
          'lot_open_slaughter_001',
          ['adult_005', 'adult_006'],
        );

        // CLOSED LOTS (finalisés avec mouvements) - 2 lots
        await db.lotDao.insertLot(LotsTableCompanion.insert(
          id: 'lot_closed_sale_001',
          farmId: 'farm_default',
          name: 'Vente Lot Été 2024',
          type: const Value('sale'),
          status: const Value('closed'),
          completed: const Value(true),
          completedAt: Value(now.subtract(const Duration(days: 15))),
          priceTotal: const Value(1500.0),
          buyerName: const Value('Coopérative Agricole du Sud'),
          synced: const Value(false),
          createdAt: now.subtract(const Duration(days: 20)),
          updatedAt: now.subtract(const Duration(days: 15)),
        ));
        await db.lotAnimalDao.addAnimalsToLot(
          'lot_closed_sale_001',
          ['young_006', 'young_007', 'young_008'],
        );
        // Créer les mouvements de vente pour chaque animal du lot
        for (final animalId in ['young_006', 'young_007', 'young_008']) {
          await db.movementDao.insertItem(MovementsTableCompanion.insert(
            id: 'mov_lot_sale_$animalId',
            farmId: 'farm_default',
            animalId: animalId,
            lotId: const Value('lot_closed_sale_001'),
            type: 'sale',
            status: 'ongoing',
            movementDate: now.subtract(const Duration(days: 15)),
            buyerName: const Value('Coopérative Agricole du Sud'),
            buyerType: const Value('cooperative'),
            synced: const Value(false),
            createdAt: now.subtract(const Duration(days: 15)),
            updatedAt: now.subtract(const Duration(days: 15)),
          ));
          print('🔍 [DB Init] Created sale movement mov_lot_sale_$animalId with lotId=lot_closed_sale_001');
        }

        await db.lotDao.insertLot(LotsTableCompanion.insert(
          id: 'lot_closed_slaughter_001',
          farmId: 'farm_default',
          name: 'Abattage Lot Printemps',
          type: const Value('slaughter'),
          status: const Value('closed'),
          completed: const Value(true),
          completedAt: Value(now.subtract(const Duration(days: 30))),
          synced: const Value(false),
          createdAt: now.subtract(const Duration(days: 35)),
          updatedAt: now.subtract(const Duration(days: 30)),
        ));
        await db.lotAnimalDao.addAnimalsToLot(
          'lot_closed_slaughter_001',
          ['young_009', 'young_010'],
        );
        // Créer les mouvements d'abattage pour chaque animal du lot
        for (final animalId in ['young_009', 'young_010']) {
          await db.movementDao.insertItem(MovementsTableCompanion.insert(
            id: 'mov_lot_slaughter_$animalId',
            farmId: 'farm_default',
            animalId: animalId,
            lotId: const Value('lot_closed_slaughter_001'),
            type: 'slaughter',
            status: 'closed',
            movementDate: now.subtract(const Duration(days: 30)),
            slaughterhouseName: const Value('Abattoir Régional'),
            slaughterhouseId: const Value('ABT-001'),
            synced: const Value(false),
            createdAt: now.subtract(const Duration(days: 30)),
            updatedAt: now.subtract(const Duration(days: 30)),
          ));
          print('🔍 [DB Init] Created slaughter movement mov_lot_slaughter_$animalId with lotId=lot_closed_slaughter_001');
        }

        print('$_tag   ✅ Created 5 lots (3 open, 2 closed with movements)');
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

        // Note: Configuration alerte "Batch to Finalize" supprimée (batches supprimés)

        print('$_tag   ✅ Created 6 alert configurations');
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
      print('$_tag   - 34 Movements (29 individual + 5 in lots)');
      print('$_tag   - 5 Lots (3 open, 2 closed with movements)');
      print('$_tag   - 15 Treatments (active/expired withdrawal)');
      print('$_tag   - 11 Vaccinations (recent/batch/old)');
      print('$_tag   - 35 Weight Records (growth tracking)');
      print('$_tag   - 6 Alert Configurations');
      print('');
    } catch (e) {
      print('$_tag ❌ Fatal error during seeding: $e');
    }
  }

  /// Génère des données de benchmark pour tester les performances
  ///
  /// Utilise les constantes de AppConstants pour déterminer les quantités:
  /// - Light mode: 1000 animaux
  /// - Full mode: 5000 animaux
  static Future<Map<String, int>> seedBenchmarkData(AppDatabase db, String farmId) async {
    final random = Random();
    final now = DateTime.now();
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

    print('$_tag ═══════════════════════════════════════');
    print('$_tag BENCHMARK DATA GENERATION - ${isLightMode ? "LIGHT" : "FULL"} MODE');
    print('$_tag ═══════════════════════════════════════');

    final animalIds = <String>[];
    final species = ['sheep', 'cattle', 'goat'];
    final breeds = {
      'sheep': ['merinos', 'suffolk', 'lacaune'],
      'cattle': ['holstein', 'charolais', 'limousin'],
      'goat': ['alpine', 'saanen', 'angora'],
    };

    // 1. Générer les animaux
    print('$_tag Generating $animalCount animals...');
    for (int i = 0; i < animalCount; i++) {
      final id = 'bench_animal_${i.toString().padLeft(6, '0')}';
      final speciesId = species[random.nextInt(species.length)];
      final breedList = breeds[speciesId]!;
      final breedId = breedList[random.nextInt(breedList.length)];

      await db.animalDao.insertItem(AnimalsTableCompanion.insert(
        id: id,
        farmId: farmId,
        currentEid: Value('BENCH_${i.toString().padLeft(6, '0')}'),
        officialNumber: Value('FR${random.nextInt(999999999).toString().padLeft(9, '0')}'),
        birthDate: now.subtract(Duration(days: random.nextInt(1825) + 30)),
        sex: random.nextBool() ? AnimalSex.male.name : AnimalSex.female.name,
        status: AnimalStatus.alive.name,
        speciesId: Value(speciesId),
        breedId: Value(breedId),
        visualId: Value('V${i.toString().padLeft(4, '0')}'),
        synced: const Value(false),
        createdAt: now,
        updatedAt: now,
      ));
      animalIds.add(id);

      if ((i + 1) % 100 == 0) {
        print('$_tag   Animals: ${i + 1}/$animalCount');
      }
    }
    print('$_tag ✓ Animals generated: ${animalIds.length}');

    // 2. Générer les lots
    print('$_tag Generating $lotCount lots...');
    for (int i = 0; i < lotCount; i++) {
      final id = 'bench_lot_${i.toString().padLeft(4, '0')}';

      await db.lotDao.insertLot(LotsTableCompanion.insert(
        id: id,
        farmId: farmId,
        name: 'Benchmark Lot #${i + 1}',
        status: Value(random.nextInt(10) < 8 ? 'open' : 'closed'),
        completed: const Value(false),
        synced: const Value(false),
        createdAt: now.subtract(Duration(days: random.nextInt(365))),
        updatedAt: now,
      ));

      // Assigner 5-20 animaux par lot
      final lotAnimalCount = random.nextInt(16) + 5;
      final lotAnimalIds = <String>[];
      for (int j = 0; j < lotAnimalCount && j < animalIds.length; j++) {
        final randomIndex = random.nextInt(animalIds.length);
        if (!lotAnimalIds.contains(animalIds[randomIndex])) {
          lotAnimalIds.add(animalIds[randomIndex]);
        }
      }
      if (lotAnimalIds.isNotEmpty) {
        await db.lotAnimalDao.addAnimalsToLot(id, lotAnimalIds);
      }

      if ((i + 1) % 50 == 0) {
        print('$_tag   Lots: ${i + 1}/$lotCount');
      }
    }
    print('$_tag ✓ Lots generated: $lotCount');

    // 3. Générer les mouvements
    print('$_tag Generating $movementCount movements...');
    final movementTypes = ['birth', 'purchase', 'sale', 'death'];
    for (int i = 0; i < movementCount; i++) {
      final id = 'bench_mov_${i.toString().padLeft(6, '0')}';
      final animalId = animalIds[random.nextInt(animalIds.length)];
      final type = movementTypes[random.nextInt(movementTypes.length)];

      await db.movementDao.insertItem(MovementsTableCompanion.insert(
        id: id,
        farmId: farmId,
        animalId: animalId,
        type: type,
        movementDate: now.subtract(Duration(days: random.nextInt(365))),
        status: type == 'death' || type == 'birth' ? 'closed' : 'ongoing',
        price: Value(type == 'sale' || type == 'purchase'
            ? (random.nextDouble() * 500 + 100)
            : null),
        notes: Value('Benchmark movement #${i + 1}'),
        synced: const Value(false),
        createdAt: now,
        updatedAt: now,
      ));

      if ((i + 1) % 500 == 0) {
        print('$_tag   Movements: ${i + 1}/$movementCount');
      }
    }
    print('$_tag ✓ Movements generated: $movementCount');

    // 4. Générer les traitements
    print('$_tag Generating $treatmentCount treatments...');
    final products = [
      ('prod_treat_001', 'Amoxicilline 500mg'),
      ('prod_treat_002', 'Ivermectine 1%'),
      ('prod_treat_003', 'Anti-inflammatoire'),
    ];
    for (int i = 0; i < treatmentCount; i++) {
      final id = 'bench_treat_${i.toString().padLeft(5, '0')}';
      final animalId = animalIds[random.nextInt(animalIds.length)];
      final product = products[random.nextInt(products.length)];
      final treatmentDate = now.subtract(Duration(days: random.nextInt(90)));
      final withdrawalDays = random.nextInt(21) + 7;

      await db.treatmentDao.insertItem(TreatmentsTableCompanion.insert(
        id: id,
        farmId: farmId,
        animalId: animalId,
        productId: product.$1,
        productName: product.$2,
        treatmentDate: treatmentDate,
        dose: (random.nextInt(10) + 1).toDouble(),
        withdrawalEndDate: treatmentDate.add(Duration(days: withdrawalDays)),
        notes: Value('Benchmark treatment #${i + 1}'),
        synced: const Value(false),
        createdAt: now,
        updatedAt: now,
      ));

      if ((i + 1) % 200 == 0) {
        print('$_tag   Treatments: ${i + 1}/$treatmentCount');
      }
    }
    print('$_tag ✓ Treatments generated: $treatmentCount');

    // 5. Générer les vaccinations
    print('$_tag Generating $vaccinationCount vaccinations...');
    final vaccines = [
      ('Vaccin Entérotoxémie', 'Entérotoxémie'),
      ('Vaccin Pasteurellose', 'Pasteurellose'),
      ('Vaccin Ectima', 'Ectima Contagieux'),
    ];
    final routes = ['sous-cutanée', 'intramusculaire', 'intradermique'];
    final types = ['obligatoire', 'recommandee', 'optionnelle'];
    for (int i = 0; i < vaccinationCount; i++) {
      final id = 'bench_vacc_${i.toString().padLeft(5, '0')}';
      final animalId = animalIds[random.nextInt(animalIds.length)];
      final vaccine = vaccines[random.nextInt(vaccines.length)];
      final vaccinationDate = now.subtract(Duration(days: random.nextInt(180)));

      await db.vaccinationDao.insertItem(VaccinationsTableCompanion.insert(
        id: id,
        farmId: farmId,
        animalIds: '["$animalId"]',
        vaccineName: vaccine.$1,
        type: types[random.nextInt(types.length)],
        disease: vaccine.$2,
        vaccinationDate: vaccinationDate,
        dose: '${random.nextInt(5) + 1} ml',
        administrationRoute: routes[random.nextInt(routes.length)],
        withdrawalPeriodDays: 0,
        notes: Value('Benchmark vaccination #${i + 1}'),
        synced: const Value(false),
        createdAt: now,
        updatedAt: now,
      ));

      if ((i + 1) % 200 == 0) {
        print('$_tag   Vaccinations: ${i + 1}/$vaccinationCount');
      }
    }
    print('$_tag ✓ Vaccinations generated: $vaccinationCount');

    // 6. Générer les pesées
    print('$_tag Generating $weightCount weights...');
    final weightSources = ['scale', 'manual', 'estimation'];
    for (int i = 0; i < weightCount; i++) {
      final id = 'bench_weight_${i.toString().padLeft(6, '0')}';
      final animalId = animalIds[random.nextInt(animalIds.length)];

      await db.weightDao.insertItem(WeightsTableCompanion.insert(
        id: id,
        farmId: farmId,
        animalId: animalId,
        recordedAt: now.subtract(Duration(days: random.nextInt(365))),
        weight: random.nextDouble() * 150 + 20,
        source: weightSources[random.nextInt(weightSources.length)],
        notes: Value('Benchmark weight #${i + 1}'),
        synced: const Value(false),
        createdAt: now,
        updatedAt: now,
      ));

      if ((i + 1) % 1000 == 0) {
        print('$_tag   Weights: ${i + 1}/$weightCount');
      }
    }
    print('$_tag ✓ Weights generated: $weightCount');

    print('$_tag ═══════════════════════════════════════');
    print('$_tag BENCHMARK DATA COMPLETE');
    print('$_tag ═══════════════════════════════════════');

    return {
      'animals': animalIds.length,
      'lots': lotCount,
      'movements': movementCount,
      'treatments': treatmentCount,
      'vaccinations': vaccinationCount,
      'weights': weightCount,
    };
  }
}
