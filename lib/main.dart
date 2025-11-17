// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
//import 'models/animal.dart';
import 'providers/animal_provider.dart';
import 'providers/sync_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/campaign_provider.dart';
import 'providers/lot_provider.dart';
import 'providers/weight_provider.dart';
import 'providers/alert_provider.dart';
import 'providers/vaccination_provider.dart';
import 'providers/treatment_provider.dart';
import 'providers/medical_product_provider.dart';
import 'providers/vaccination_reference_provider.dart';
import 'providers/document_provider.dart';
import 'providers/breeding_provider.dart';
import 'providers/breed_provider.dart';
import 'providers/species_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/reminder_provider.dart';
import 'providers/veterinarian_provider.dart';
import 'providers/farm_provider.dart';
import 'providers/farm_preferences_provider.dart';
import 'providers/alert_configuration_provider.dart';
import 'providers/rfid_scanner_provider.dart';
import 'providers/movement_provider.dart';
import 'i18n/app_localizations.dart';
//import 'i18n/app_strings.dart';
import 'utils/constants.dart';
import 'screens/home/home_screen.dart';
//import 'screens/animal/animal_detail_screen.dart';
//import 'screens/animal/animal_list_screen.dart';
//import 'screens/animal/animal_finder_screen.dart';
//import 'screens/animal/universal_scanner_screen.dart';
//import 'screens/sync/sync_screen.dart';
import 'drift/database.dart';
import 'repositories/animal_repository.dart';
import 'repositories/weight_repository.dart';
import 'repositories/treatment_repository.dart';
import 'repositories/medical_product_repository.dart';
import 'repositories/vaccination_repository.dart';
import 'repositories/veterinarian_repository.dart';
import 'repositories/breed_repository.dart';
import 'repositories/species_repository.dart';
import 'repositories/lot_repository.dart';
import 'repositories/campaign_repository.dart';
import 'repositories/breeding_repository.dart';
import 'repositories/document_repository.dart';
import 'repositories/alert_configuration_repository.dart';
import 'repositories/farm_repository.dart';
import 'repositories/farm_preferences_repository.dart';
import 'repositories/movement_repository.dart';
import 'database_initializer.dart';

AppDatabase? _appDatabase;
bool _dbInitialized = false;

// Instance globale du plugin de notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser les fuseaux horaires
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation(AppConstants.defaultTimezone));

  // Initialize Database ET récupérer l'instance
  if (!_dbInitialized) {
    _appDatabase = await DatabaseInitializer.initialize();
    _dbInitialized = true;
  }

  final database = _appDatabase!;

  // Initialiser les notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(AppConstants.androidIconPath);

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Notification received
    },
  );

  // Initialize ALL Repositories
  final animalRepository = AnimalRepository(database);
  final weightRepository = WeightRepository(database);
  final vaccinationRepository = VaccinationRepository(database);
  final veterinarianRepository = VeterinarianRepository(database);
  final breedRepository = BreedRepository(database);
  final speciesRepository = SpeciesRepository(database);
  final lotRepository = LotRepository(database);
  final campaignRepository = CampaignRepository(database);
  final breedingRepository = BreedingRepository(database);
  final documentRepository = DocumentRepository(database);
  final treatmentRepository = TreatmentRepository(database);
  final alertConfigurationRepository = AlertConfigurationRepository(database);
  final farmRepository = FarmRepository(database);
  final farmPreferencesRepository = FarmPreferencesRepository(database);
  final movementRepository = MovementRepository(database);
  final medicalProductRepository = MedicalProductRepository(database);

  runApp(MyApp(
    database: database,
    animalRepository: animalRepository,
    weightRepository: weightRepository,
    vaccinationRepository: vaccinationRepository,
    veterinarianRepository: veterinarianRepository,
    breedRepository: breedRepository,
    speciesRepository: speciesRepository,
    lotRepository: lotRepository,
    campaignRepository: campaignRepository,
    breedingRepository: breedingRepository,
    documentRepository: documentRepository,
    treatmentRepository: treatmentRepository,
    medicalProductRepository: medicalProductRepository,
    alertConfigurationRepository: alertConfigurationRepository,
    farmRepository: farmRepository,
    farmPreferencesRepository: farmPreferencesRepository,
    movementRepository: movementRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;
  final AnimalRepository animalRepository;
  final WeightRepository weightRepository;
  final VaccinationRepository vaccinationRepository;
  final VeterinarianRepository veterinarianRepository;
  final BreedRepository breedRepository;
  final SpeciesRepository speciesRepository;
  final LotRepository lotRepository;
  final CampaignRepository campaignRepository;
  final BreedingRepository breedingRepository;
  final DocumentRepository documentRepository;
  final TreatmentRepository treatmentRepository;
  final MedicalProductRepository medicalProductRepository;
  final AlertConfigurationRepository alertConfigurationRepository;
  final FarmRepository farmRepository;
  final FarmPreferencesRepository farmPreferencesRepository;
  final MovementRepository movementRepository;

  const MyApp({
    super.key,
    required this.database,
    required this.animalRepository,
    required this.weightRepository,
    required this.vaccinationRepository,
    required this.veterinarianRepository,
    required this.breedRepository,
    required this.speciesRepository,
    required this.lotRepository,
    required this.campaignRepository,
    required this.breedingRepository,
    required this.documentRepository,
    required this.treatmentRepository,
    required this.medicalProductRepository,
    required this.alertConfigurationRepository,
    required this.farmRepository,
    required this.farmPreferencesRepository,
    required this.movementRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // === Database & Repositories ===
        Provider<AppDatabase>.value(value: database),
        Provider<AnimalRepository>.value(value: animalRepository),
        Provider<WeightRepository>.value(value: weightRepository),
        Provider<VaccinationRepository>.value(value: vaccinationRepository),
        Provider<VeterinarianRepository>.value(value: veterinarianRepository),
        Provider<BreedRepository>.value(value: breedRepository),
        Provider<SpeciesRepository>.value(value: speciesRepository),
        Provider<LotRepository>.value(value: lotRepository),
        Provider<CampaignRepository>.value(value: campaignRepository),
        Provider<BreedingRepository>.value(value: breedingRepository),
        Provider<DocumentRepository>.value(value: documentRepository),
        Provider<TreatmentRepository>.value(value: treatmentRepository),
        Provider<MedicalProductRepository>.value(
            value: medicalProductRepository),
        Provider<AlertConfigurationRepository>.value(
            value: alertConfigurationRepository),
        Provider<FarmRepository>.value(value: farmRepository),
        Provider<FarmPreferencesRepository>.value(
            value: farmPreferencesRepository),
        Provider<MovementRepository>.value(value: movementRepository),

        // === AuthProvider EN PREMIER ===
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // === LocaleProvider (gestion langue) ===
        ChangeNotifierProvider(create: (_) => LocaleProvider()),

        // === SettingsProvider (legacy - farm preferences) ===
        ChangeNotifierProvider(create: (_) => SettingsProvider()),

        // === SyncProvider (standalone) ===
        ChangeNotifierProvider(
          create: (_) => SyncProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ReminderProvider(flutterLocalNotificationsPlugin),
        ),

        // === BreedProvider (lookup table, lecture seule) ===
        // ✅ FIXE: Utiliser ChangeNotifierProxyProvider car BreedProvider extends ChangeNotifier
        ChangeNotifierProxyProvider<BreedRepository, BreedProvider>(
          create: (context) => BreedProvider(context.read<BreedRepository>()),
          update: (context, repo, previous) => previous ?? BreedProvider(repo),
        ),

        // === SpeciesProvider (lookup table, lecture seule) ===
        ChangeNotifierProxyProvider<SpeciesRepository, SpeciesProvider>(
          create: (context) => SpeciesProvider(context.read<SpeciesRepository>()),
          update: (context, repo, previous) => previous ?? SpeciesProvider(repo),
        ),

        // === FarmProvider (Phase 1 - Farm Settings) ===
        ChangeNotifierProxyProvider<AuthProvider, FarmProvider>(
          create: (context) => FarmProvider(
              context.read<AuthProvider>(), context.read<FarmRepository>()),
          update: (context, auth, previous) =>
              previous ?? FarmProvider(auth, context.read<FarmRepository>()),
        ),

        // === FarmPreferencesProvider (Phase 1 - Farm Settings) ===
        ChangeNotifierProxyProvider<AuthProvider, FarmPreferencesProvider>(
          create: (context) => FarmPreferencesProvider(
              context.read<AuthProvider>(),
              context.read<FarmPreferencesRepository>()),
          update: (context, auth, previous) =>
              previous ??
              FarmPreferencesProvider(
                  auth, context.read<FarmPreferencesRepository>()),
        ),

        // === AlertConfigurationProvider (Phase 1 - Farm Settings) ===
        ChangeNotifierProxyProvider<AuthProvider, AlertConfigurationProvider>(
          create: (context) => AlertConfigurationProvider(
              context.read<AuthProvider>(),
              context.read<AlertConfigurationRepository>()),
          update: (context, auth, previous) =>
              previous ??
              AlertConfigurationProvider(
                  auth, context.read<AlertConfigurationRepository>()),
        ),

        // === AnimalProvider (charge depuis DB) ===
        ChangeNotifierProxyProvider<AuthProvider, AnimalProvider>(
          create: (context) => AnimalProvider(
              context.read<AuthProvider>(), context.read<AnimalRepository>()),
          update: (context, auth, previous) =>
              previous ??
              AnimalProvider(auth, context.read<AnimalRepository>()),
        ),

        // === CampaignProvider (charge depuis DB) ===
        ChangeNotifierProxyProvider<AuthProvider, CampaignProvider>(
          create: (context) => CampaignProvider(
              context.read<AuthProvider>(), context.read<CampaignRepository>()),
          update: (context, auth, previous) =>
              previous ??
              CampaignProvider(auth, context.read<CampaignRepository>()),
        ),

        // === LotProvider (charge depuis DB) ===
        ChangeNotifierProxyProvider<AuthProvider, LotProvider>(
          create: (context) => LotProvider(
              context.read<AuthProvider>(), context.read<LotRepository>()),
          update: (context, auth, previous) =>
              previous ?? LotProvider(auth, context.read<LotRepository>()),
        ),

        // === WeightProvider (charge depuis DB) ===
        ChangeNotifierProxyProvider<AuthProvider, WeightProvider>(
          create: (context) => WeightProvider(
              context.read<AuthProvider>(), context.read<WeightRepository>()),
          update: (context, auth, previous) =>
              previous ??
              WeightProvider(auth, context.read<WeightRepository>()),
        ),

        // === MovementProvider (charge depuis DB) ===
        ChangeNotifierProxyProvider<AuthProvider, MovementProvider>(
          create: (context) => MovementProvider(
              context.read<AuthProvider>(), context.read<MovementRepository>()),
          update: (context, auth, previous) =>
              previous ??
              MovementProvider(auth, context.read<MovementRepository>()),
        ),

        // === VaccinationReferenceProvider (charge depuis DB) ===
        ChangeNotifierProxyProvider<AuthProvider, VaccinationReferenceProvider>(
          create: (context) =>
              VaccinationReferenceProvider(context.read<AuthProvider>()),
          update: (context, auth, previous) =>
              previous ?? VaccinationReferenceProvider(auth),
        ),

        // === VaccinationProvider (charge depuis DB) ===
        ChangeNotifierProxyProvider<AuthProvider, VaccinationProvider>(
          create: (context) => VaccinationProvider(context.read<AuthProvider>(),
              context.read<VaccinationRepository>()),
          update: (context, auth, previous) =>
              previous ??
              VaccinationProvider(auth, context.read<VaccinationRepository>()),
        ),

        // === DocumentProvider (charge depuis DB) ===
        ChangeNotifierProxyProvider<AuthProvider, DocumentProvider>(
          create: (context) => DocumentProvider(
              context.read<AuthProvider>(), context.read<DocumentRepository>()),
          update: (context, auth, previous) =>
              previous ??
              DocumentProvider(auth, context.read<DocumentRepository>()),
        ),

        // === BreedingProvider (charge depuis DB) ===
        ChangeNotifierProxyProvider<AuthProvider, BreedingProvider>(
          create: (context) => BreedingProvider(
              context.read<AuthProvider>(), context.read<BreedingRepository>()),
          update: (context, auth, previous) =>
              previous ??
              BreedingProvider(auth, context.read<BreedingRepository>()),
        ),

        // === VeterinarianProvider (charge depuis DB) ===
        ChangeNotifierProxyProvider<AuthProvider, VeterinarianProvider>(
          create: (context) => VeterinarianProvider(
              context.read<AuthProvider>(),
              context.read<VeterinarianRepository>()),
          update: (context, auth, previous) =>
              previous ??
              VeterinarianProvider(
                  auth, context.read<VeterinarianRepository>()),
        ),

        // === TreatmentProvider (charge depuis DB) ===
        ChangeNotifierProxyProvider<AuthProvider, TreatmentProvider>(
          create: (context) => TreatmentProvider(context.read<AuthProvider>(),
              context.read<TreatmentRepository>()),
          update: (context, auth, previous) =>
              previous ??
              TreatmentProvider(auth, context.read<TreatmentRepository>()),
        ),

        // === MedicalProductProvider (charge depuis DB) ===
        ChangeNotifierProxyProvider<AuthProvider, MedicalProductProvider>(
          create: (context) => MedicalProductProvider(
              context.read<AuthProvider>(),
              context.read<MedicalProductRepository>()),
          update: (context, auth, previous) =>
              previous ??
              MedicalProductProvider(
                  auth, context.read<MedicalProductRepository>()),
        ),

        // ═══════════════════════════════════════════════════════════
        // === AlertProvider - ✅ CORRIGÉ: Injection AuthProvider ===
        // ═══════════════════════════════════════════════════════════
        // AVANT: ChangeNotifierProxyProvider5 (❌ MANQUAIT AuthProvider)
        // APRÈS: ChangeNotifierProxyProvider6 (✅ INCLUT AuthProvider)
        ChangeNotifierProxyProvider6<
            AuthProvider,
            AnimalProvider,
            WeightProvider,
            SyncProvider,
            VaccinationProvider,
            AlertConfigurationRepository,
            AlertProvider>(
          create: (context) => AlertProvider(
            authProvider: context.read<AuthProvider>(),
            animalProvider: context.read<AnimalProvider>(),
            weightProvider: context.read<WeightProvider>(),
            syncProvider: context.read<SyncProvider>(),
            vaccinationProvider: context.read<VaccinationProvider>(),
            treatmentProvider: context.read<TreatmentProvider>(),
            alertConfigRepository: context.read<AlertConfigurationRepository>(),
          ),
          update: (context, auth, animal, weight, sync, vaccination,
                  alertConfig, previous) =>
              previous ??
              AlertProvider(
                authProvider: auth,
                animalProvider: animal,
                weightProvider: weight,
                syncProvider: sync,
                vaccinationProvider: vaccination,
                treatmentProvider: context.read<TreatmentProvider>(),
                alertConfigRepository: alertConfig,
              ),
        ),

        // === RFIDScannerProvider (gestion du scan RFID) ===
        ChangeNotifierProvider(create: (_) => RFIDScannerProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: AppConstants.appTitle,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.green,
              scaffoldBackgroundColor: Colors.grey.shade50,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              cardTheme: CardThemeData(
                elevation: AppConstants.mainCardElevation,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.mainCardRadius),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.mainInputRadius),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
              ),
              dialogTheme: const DialogThemeData(
                backgroundColor: Colors.white,
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                contentTextStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
            locale: localeProvider.locale,
            supportedLocales: const [
              Locale('fr', 'FR'),
              Locale('en', 'US'),
              Locale('ar', 'SA'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
