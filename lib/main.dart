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
import 'screens/home/home_screen.dart'; // ✅ Mis à jour
import 'screens/animal/animal_detail_screen.dart'; // ✅ Mis à jour
import 'screens/animal/animal_list_screen.dart'; // ✅ Mis à jour
import 'screens/animal/animal_finder_screen.dart'; // ✅ Scanner universel
import 'screens/animal/universal_scanner_screen.dart'; // ✅ Scanner Phase 1
import 'screens/sync/sync_screen.dart'; // ✅ Mis à jour
import 'data/mock_data.dart';
import 'data/mocks/mock_vaccination_references.dart';
import 'data/mocks/mock_veterinarians.dart';

// Instance globale du plugin de notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser les fuseaux horaires
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Paris'));

  // Initialiser les notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

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
      // → Ouvrir écran pré-rempli pour enregistrer le soin
      debugPrint('Notification cliquée: ${response.payload}');
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 1. AuthProvider EN PREMIER
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // 2. Providers sans dépendance
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

        // AnimalProvider - ligne ~24
        ChangeNotifierProxyProvider<AuthProvider, AnimalProvider>(
          create: (context) {
            final auth = context.read<AuthProvider>();
            final provider = AnimalProvider(auth);
            provider.initializeWithMockData(
              MockData.generateAnimals(),
              MockData.generateProducts(),
              MockData.generateTreatments(),
              MockData.generateMovements(),
            );
            return provider;
          },
          update: (context, auth, previous) => previous ?? AnimalProvider(auth),
        ),

        // BatchProvider - ligne ~30
        ChangeNotifierProxyProvider<AuthProvider, BatchProvider>(
          create: (context) {
            final auth = context.read<AuthProvider>();
            final provider = BatchProvider(auth);
            provider.initializeWithMockData(MockData.generateBatches());
            return provider;
          },
          update: (context, auth, previous) => previous ?? BatchProvider(auth),
        ),

        ChangeNotifierProxyProvider<AuthProvider, LotProvider>(
          create: (context) => LotProvider(context.read<AuthProvider>()),
          update: (context, auth, previous) => previous ?? LotProvider(auth),
        ),

        ChangeNotifierProxyProvider<AuthProvider, CampaignProvider>(
          create: (context) => CampaignProvider(context.read<AuthProvider>()),
          update: (context, auth, previous) =>
              previous ?? CampaignProvider(auth),
        ),

        ChangeNotifierProxyProvider<AuthProvider, WeightProvider>(
          create: (context) {
            final auth = context.read<AuthProvider>();
            final provider = WeightProvider(auth);
            provider.setWeights(MockData.generateWeights());
            return provider;
          },
          update: (context, auth, previous) => previous ?? WeightProvider(auth),
        ),

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

        ChangeNotifierProxyProvider<AuthProvider, VaccinationProvider>(
          create: (context) {
            final auth = context.read<AuthProvider>();
            final provider = VaccinationProvider(auth);
            provider.setVaccinations(MockData.generateVaccinations());
            return provider;
          },
          update: (context, auth, previous) =>
              previous ?? VaccinationProvider(auth),
        ),

        ChangeNotifierProxyProvider<AuthProvider, DocumentProvider>(
          create: (context) => DocumentProvider(context.read<AuthProvider>()),
          update: (context, auth, previous) =>
              previous ?? DocumentProvider(auth),
        ),

        ChangeNotifierProxyProvider<AuthProvider, BreedingProvider>(
          create: (context) => BreedingProvider(context.read<AuthProvider>()),
          update: (context, auth, previous) =>
              previous ?? BreedingProvider(auth),
        ),

        ChangeNotifierProxyProvider<AuthProvider, VeterinarianProvider>(
          create: (context) {
            final auth = context.read<AuthProvider>();
            final provider = VeterinarianProvider(auth);
            provider.loadMockVets(MockVeterinarians.generateVeterinarians());
            return provider;
          },
          update: (context, auth, previous) =>
              previous ?? VeterinarianProvider(auth),
        ),

        // 4. AlertProvider (dépend de plusieurs providers)
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
            title: 'RFID Livestock',
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
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
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
          _selectedIndex = 0; // Retour à l'accueil
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Animaux',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sync),
            label: 'Sync',
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
    // Utiliser un Builder pour avoir accès au bon context
    return Builder(
      builder: (context) {
        // Auto-navigation vers AnimalFinderScreen
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _navigateToScanner(context);
        });

        // Afficher un écran vide pendant la navigation
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
        builder: (context) => const AnimalFinderScreen(
          mode: AnimalFinderMode.single,
          title: 'Scanner un animal',
        ),
      ),
    );

    if (animal != null) {
      onAnimalSelected(animal);
    }
  }
}
