// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'models/animal.dart';
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
import 'providers/vaccination_reference_provider.dart';
import 'providers/document_provider.dart';
import 'providers/breeding_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/reminder_provider.dart';
import 'providers/veterinarian_provider.dart';
import 'i18n/app_localizations.dart';
import 'i18n/app_strings.dart';
import 'utils/constants.dart';
import 'screens/home/home_screen.dart';
import 'screens/animal/animal_detail_screen.dart';
import 'screens/animal/animal_list_screen.dart';
import 'screens/animal/animal_finder_screen.dart';
import 'screens/animal/universal_scanner_screen.dart';
import 'screens/sync/sync_screen.dart';
import 'data/mock_data.dart';
import 'data/mocks/mock_vaccination_references.dart';
import 'data/mocks/mock_veterinarians.dart';
import 'drift/database.dart';
import 'repositories/animal_repository.dart';
import 'repositories/weight_repository.dart';
import 'repositories/vaccination_repository.dart';
import 'repositories/veterinarian_repository.dart';
import 'repositories/breed_repository.dart';
import 'repositories/batch_repository.dart';
import 'repositories/lot_repository.dart';
import 'repositories/campaign_repository.dart';
import 'repositories/breeding_repository.dart';
import 'repositories/document_repository.dart';

// Instance globale du plugin de notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser les fuseaux horaires
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation(AppConstants.defaultTimezone));

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

  // Initialize Database
  final database = AppDatabase();

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

        // === AnimalProvider (avec Repository) ===
        ChangeNotifierProxyProvider<AuthProvider, AnimalProvider>(
          create: (context) {
            final auth = context.read<AuthProvider>();
            final provider =
                AnimalProvider(auth, context.read<AnimalRepository>());
            provider.initializeWithMockData(
              MockData.generateAnimals(),
              MockData.generateProducts(),
              MockData.generateTreatments(),
              MockData.generateMovements(),
            );
            return provider;
          },
          update: (context, auth, previous) =>
              previous ??
              AnimalProvider(auth, context.read<AnimalRepository>()),
        ),

        // === BatchProvider (avec Repository) ===
        ChangeNotifierProxyProvider<AuthProvider, BatchProvider>(
          create: (context) {
            final auth = context.read<AuthProvider>();
            final provider =
                BatchProvider(auth, context.read<BatchRepository>());
            provider.initializeWithMockData(MockData.generateBatches());
            return provider;
          },
          update: (context, auth, previous) =>
              previous ?? BatchProvider(auth, context.read<BatchRepository>()),
        ),

        // === LotProvider (avec Repository) ===
        ChangeNotifierProxyProvider<AuthProvider, LotProvider>(
          create: (context) => LotProvider(
              context.read<AuthProvider>(), context.read<LotRepository>()),
          update: (context, auth, previous) =>
              previous ?? LotProvider(auth, context.read<LotRepository>()),
        ),

        // === CampaignProvider (avec Repository) ===
        ChangeNotifierProxyProvider<AuthProvider, CampaignProvider>(
          create: (context) => CampaignProvider(
              context.read<AuthProvider>(), context.read<CampaignRepository>()),
          update: (context, auth, previous) =>
              previous ??
              CampaignProvider(auth, context.read<CampaignRepository>()),
        ),

        // === WeightProvider (avec Repository) ===
        ChangeNotifierProxyProvider<AuthProvider, WeightProvider>(
          create: (context) {
            final auth = context.read<AuthProvider>();
            final provider =
                WeightProvider(auth, context.read<WeightRepository>());
            provider.setWeights(MockData.generateWeights());
            return provider;
          },
          update: (context, auth, previous) =>
              previous ??
              WeightProvider(auth, context.read<WeightRepository>()),
        ),

        // === VaccinationReferenceProvider ===
        ChangeNotifierProxyProvider<AuthProvider, VaccinationReferenceProvider>(
          create: (context) {
            final auth = context.read<AuthProvider>();
            final provider = VaccinationReferenceProvider(auth);
            provider.setReferences(
              vaccines: MockVaccinationReferences.generateVaccines(),
              diseases: MockVaccinationReferences.generateDiseases(),
              routes: MockVaccinationReferences.generateRoutes(),
            );
            return provider;
          },
          update: (context, auth, previous) =>
              previous ?? VaccinationReferenceProvider(auth),
        ),

        // === VaccinationProvider (avec Repository) ===
        ChangeNotifierProxyProvider<AuthProvider, VaccinationProvider>(
          create: (context) {
            final auth = context.read<AuthProvider>();
            final provider = VaccinationProvider(
                auth, context.read<VaccinationRepository>());
            provider.setVaccinations(MockData.generateVaccinations());
            return provider;
          },
          update: (context, auth, previous) =>
              previous ??
              VaccinationProvider(auth, context.read<VaccinationRepository>()),
        ),

        // === DocumentProvider (avec Repository) ===
        ChangeNotifierProxyProvider<AuthProvider, DocumentProvider>(
          create: (context) => DocumentProvider(
              context.read<AuthProvider>(), context.read<DocumentRepository>()),
          update: (context, auth, previous) =>
              previous ??
              DocumentProvider(auth, context.read<DocumentRepository>()),
        ),

        // === BreedingProvider (avec Repository) ===
        ChangeNotifierProxyProvider<AuthProvider, BreedingProvider>(
          create: (context) => BreedingProvider(
              context.read<AuthProvider>(), context.read<BreedingRepository>()),
          update: (context, auth, previous) =>
              previous ??
              BreedingProvider(auth, context.read<BreedingRepository>()),
        ),

        // === VeterinarianProvider (avec Repository) ===
        ChangeNotifierProxyProvider<AuthProvider, VeterinarianProvider>(
          create: (context) {
            final auth = context.read<AuthProvider>();
            final provider = VeterinarianProvider(
                auth, context.read<VeterinarianRepository>());
            provider.loadMockVets(MockVeterinarians.generateVeterinarians());
            return provider;
          },
          update: (context, auth, previous) =>
              previous ??
              VeterinarianProvider(
                  auth, context.read<VeterinarianRepository>()),
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
  int _selectedIndex = 0;

  List<Widget> _getScreens() {
    return [
      const HomeScreen(),
      _ScanTabScreen(onAnimalSelected: (animal) {
        setState(() {
          _selectedIndex = 0;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnimalDetailScreen(preloadedAnimal: animal),
          ),
        );
      }),
      const AnimalListScreen(),
      const SyncScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = _getScreens();

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context).translate(AppStrings.home),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.qr_code_scanner),
            label: AppLocalizations.of(context).translate(AppStrings.scan),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: AppLocalizations.of(context).translate(AppStrings.animals),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.sync),
            label: AppLocalizations.of(context).translate(AppStrings.sync),
          ),
        ],
      ),
    );
  }
}

/// Widget pour l'onglet Scan qui gère la navigation vers la fiche animal
class _ScanTabScreen extends StatelessWidget {
  final Function(Animal) onAnimalSelected;

  const _ScanTabScreen({required this.onAnimalSelected});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _navigateToScanner(context);
        });

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Future<void> _navigateToScanner(BuildContext context) async {
    final animal = await Navigator.push<Animal>(
      context,
      MaterialPageRoute(
        builder: (context) => AnimalFinderScreen(
          mode: AnimalFinderMode.single,
          title: AppLocalizations.of(context).translate(AppStrings.scanAnimal),
        ),
      ),
    );

    if (animal != null) {
      onAnimalSelected(animal);
    }
  }
}
