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
import 'providers/qr_provider.dart';
import 'providers/rfid_scanner_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/batch_provider.dart';
import 'providers/campaign_provider.dart';
import 'providers/lot_provider.dart';
import 'providers/weight_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/alert_provider.dart';
import 'providers/vaccination_provider.dart';
import 'providers/treatment_provider.dart';
import 'providers/vaccination_reference_provider.dart';
import 'providers/document_provider.dart';
import 'providers/breeding_provider.dart';
import 'providers/breed_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/reminder_provider.dart';
import 'providers/veterinarian_provider.dart';
import 'i18n/app_localizations.dart';
//import 'i18n/app_strings.dart';
import 'utils/constants.dart';
import 'screens/home/home_screen.dart';
//import 'screens/animal/animal_detail_screen.dart';
//import 'screens/animal/animal_list_screen.dart';
//import 'screens/animal/animal_finder_screen.dart';
import 'screens/animal/universal_scanner_screen.dart';
//import 'screens/sync/sync_screen.dart';
import 'drift/database.dart';
import 'repositories/animal_repository.dart';
import 'repositories/weight_repository.dart';
import 'repositories/treatment_repository.dart';
import 'repositories/vaccination_repository.dart';
import 'repositories/veterinarian_repository.dart';
import 'repositories/breed_repository.dart';
import 'repositories/batch_repository.dart';
import 'repositories/lot_repository.dart';
import 'repositories/campaign_repository.dart';
import 'repositories/breeding_repository.dart';
import 'repositories/document_repository.dart';
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
  //final database = await DatabaseInitializer.initialize();
  // Initialiser la DB une seule fois
  debugPrint('✅ the  main() DB initialized: $_dbInitialized');

  if (!_dbInitialized) {
    _appDatabase = await DatabaseInitializer.initialize();
    _dbInitialized = true;
    debugPrint('✅ DB initialisée');
  } else {
    debugPrint('⏭️ DB déjà initialisée, skip');
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
      debugPrint('Notification cliquée: ${response.payload}');
    },
  );

  // Initialize ALL Repositories
  final animalRepository = AnimalRepository(database);
  final weightRepository = WeightRepository(database);
  final vaccinationRepository = VaccinationRepository(database);
  final veterinarianRepository = VeterinarianRepository(database);
  final breedRepository = BreedRepository(database);
  final batchRepository = BatchRepository(database);
  final lotRepository = LotRepository(database);
  final campaignRepository = CampaignRepository(database);
  final breedingRepository = BreedingRepository(database);
  final documentRepository = DocumentRepository(database);
  final treatmentRepository = TreatmentRepository(database);

  runApp(MyApp(
    database: database,
    animalRepository: animalRepository,
    weightRepository: weightRepository,
    vaccinationRepository: vaccinationRepository,
    veterinarianRepository: veterinarianRepository,
    breedRepository: breedRepository,
    batchRepository: batchRepository,
    lotRepository: lotRepository,
    campaignRepository: campaignRepository,
    breedingRepository: breedingRepository,
    documentRepository: documentRepository,
    treatmentRepository: treatmentRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;
  final AnimalRepository animalRepository;
  final WeightRepository weightRepository;
  final VaccinationRepository vaccinationRepository;
  final VeterinarianRepository veterinarianRepository;
  final BreedRepository breedRepository;
  final BatchRepository batchRepository;
  final LotRepository lotRepository;
  final CampaignRepository campaignRepository;
  final BreedingRepository breedingRepository;
  final DocumentRepository documentRepository;
  final TreatmentRepository treatmentRepository;

  const MyApp({
    super.key,
    required this.database,
    required this.animalRepository,
    required this.weightRepository,
    required this.vaccinationRepository,
    required this.veterinarianRepository,
    required this.breedRepository,
    required this.batchRepository,
    required this.lotRepository,
    required this.campaignRepository,
    required this.breedingRepository,
    required this.documentRepository,
    required this.treatmentRepository,
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
        Provider<BatchRepository>.value(value: batchRepository),
        Provider<LotRepository>.value(value: lotRepository),
        Provider<CampaignRepository>.value(value: campaignRepository),
        Provider<BreedingRepository>.value(value: breedingRepository),
        Provider<DocumentRepository>.value(value: documentRepository),
        Provider<TreatmentRepository>.value(value: treatmentRepository),

        // === AuthProvider EN PREMIER ===
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // === Providers sans dépendance ===
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => QRProvider()),
        ChangeNotifierProvider(create: (_) => SyncProvider()),
        ChangeNotifierProvider(create: (_) => RFIDScannerProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final provider = SettingsProvider();
            provider.initializeWithDefaults();
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) => ReminderProvider(flutterLocalNotificationsPlugin),
        ),

        // === BreedProvider (lookup table, lecture seule) ===
        ChangeNotifierProvider(
          create: (_) => BreedProvider(context.read<BreedRepository>()),
        ),

        // === AnimalProvider (charge depuis DB) ===
        ChangeNotifierProxyProvider<AuthProvider, AnimalProvider>(
          create: (context) => AnimalProvider(
              context.read<AuthProvider>(), context.read<AnimalRepository>()),
          update: (context, auth, previous) =>
              previous ??
              AnimalProvider(auth, context.read<AnimalRepository>()),
        ),

        // === BatchProvider (charge depuis DB) ===
        ChangeNotifierProxyProvider<AuthProvider, BatchProvider>(
          create: (context) => BatchProvider(
              context.read<AuthProvider>(), context.read<BatchRepository>()),
          update: (context, auth, previous) =>
              previous ?? BatchProvider(auth, context.read<BatchRepository>()),
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

        // === AlertProvider (dépend de plusieurs providers) ===
        ChangeNotifierProxyProvider4<AnimalProvider, WeightProvider,
            SyncProvider, VaccinationProvider, AlertProvider>(
          create: (context) => AlertProvider(
            animalProvider: context.read<AnimalProvider>(),
            weightProvider: context.read<WeightProvider>(),
            syncProvider: context.read<SyncProvider>(),
            vaccinationProvider: context.read<VaccinationProvider>(),
          ),
          update: (context, animal, weight, sync, vaccination, previous) =>
              previous ??
              AlertProvider(
                animalProvider: animal,
                weightProvider: weight,
                syncProvider: sync,
                vaccinationProvider: vaccination,
              ),
        ),
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
              ),
            ),
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('fr', ''),
              Locale('en', ''),
              Locale('ar', ''),
            ],
            routes: {
              '/scanner': (context) => const UniversalScannerScreen(),
            },
            home: const MainNavigation(),
          );
        },
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomeScreen(),
    );
  }
}
