// main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'i18n/app_localizations.dart';

// Providers
import 'providers/animal_provider.dart';
import 'providers/campaign_provider.dart';
import 'providers/sync_provider.dart';
import 'providers/qr_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/batch_provider.dart';
import 'providers/weight_provider.dart';

// Screens
import 'screens/home_screen.dart';
import 'screens/scan_screen.dart';
import 'screens/animal_list_screen.dart';
import 'screens/sync_screen.dart';
import 'screens/settings_screen.dart';

// Mock Data
import 'data/mock_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuration de l'orientation (portrait uniquement)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider de locale (doit être en premier pour i18n)
        ChangeNotifierProvider(
          create: (_) => LocaleProvider(),
        ),

        // Provider de synchronisation
        ChangeNotifierProvider(
          create: (_) => SyncProvider(),
        ),

        // Provider d'animaux (avec mock data)
        ChangeNotifierProvider(
          create: (_) {
            final provider = AnimalProvider();

            // Charger les données de test
            provider.initializeWithMockData(
              MockData.generateAnimals(),
              MockData.generateProducts(),
              MockData.generateTreatments(),
              MockData.generateMovements(),
            );

            return provider;
          },
        ),

        // Provider de campagnes
        ChangeNotifierProvider(
          create: (_) => CampaignProvider(),
        ),

        // Provider QR Code
        ChangeNotifierProvider(
          create: (_) => QRProvider(),
        ),

        // 🆕 Provider de lots (NOUVEAU)
        ChangeNotifierProvider(
          create: (_) {
            final provider = BatchProvider();

            // Charger les lots de test
            provider.initializeWithMockData(
              MockData.generateBatches(),
            );

            return provider;
          },
        ),

        // 🆕 Provider de pesées (NOUVEAU)
        ChangeNotifierProvider(
          create: (_) {
            final provider = WeightProvider();

            // Charger les pesées de test
            provider.setWeights(
              MockData.generateWeightRecords(),
            );

            return provider;
          },
        ),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: 'RFID Troupeau',
            debugShowCheckedModeBanner: false,

            // Internationalisation
            locale: localeProvider.locale,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              AppLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('fr', 'FR'), // Français
              Locale('ar', 'SA'), // Arabe
              Locale('en', 'US'), // Anglais
            ],

            // Theme
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green,
                brightness: Brightness.light,
              ),
              useMaterial3: true,

              // AppBar Theme
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),

              // // Card Theme
              // cardTheme: CardTheme(
              //   elevation: 2,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              // ),

              cardTheme: CardThemeData(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              // Button Theme
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              // Input Theme
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),

            // Dark Theme (optionnel)
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),

            // Theme mode (peut être géré par un provider futur)
            themeMode: ThemeMode.light,

            // Page d'accueil
            home: const MainScreen(),

            // Routes nommées (optionnel, pour navigation avancée)
            routes: {
              '/home': (context) => const MainScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/sync': (context) => const SyncScreen(),
            },
          );
        },
      ),
    );
  }
}

/// Écran principal avec Bottom Navigation Bar
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Liste des écrans
  final List<Widget> _screens = const [
    HomeScreen(), // Index 0
    ScanScreen(), // Index 1
    AnimalListScreen(), // Index 2
    SyncScreen(), // Index 3
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
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

/// Configuration globale de l'application
class AppConfig {
  // Version de l'app
  static const String version = '1.2.0';
  static const String buildNumber = '12';

  // Configuration API (futur)
  static const String apiBaseUrl = 'https://api.rfid-troupeau.com/v1';
  static const String apiTimeout = '30'; // secondes

  // Configuration offline
  static const int maxOfflineDays = 7;
  static const int maxPendingData = 500;

  // Configuration QR Code
  static const int qrCodeGracePeriodHours = 48;
  static const int qrCodeRotationMonths = 6;

  // Configuration sync
  static const int syncIntervalMinutes = 15;
  static const bool autoSyncEnabled = true;

  // Configuration UI
  static const int animalsPerPage = 50;
  static const bool showDebugInfo = true; // false en production
}

/// Extensions utiles
extension StringExtension on String {
  /// Capitaliser la première lettre
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Tronquer avec ellipse
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }
}

extension DateTimeExtension on DateTime {
  /// Formater en DD/MM/YYYY
  String toDateString() {
    return '${day.toString().padLeft(2, '0')}/'
        '${month.toString().padLeft(2, '0')}/'
        '$year';
  }

  /// Formater en DD/MM/YYYY HH:MM
  String toDateTimeString() {
    return '${toDateString()} '
        '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}';
  }

  /// Vérifier si c'est aujourd'hui
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Vérifier si c'est hier
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Obtenir un label relatif (Aujourd'hui, Hier, ou date)
  String toRelativeString() {
    if (isToday) return 'Aujourd\'hui';
    if (isYesterday) return 'Hier';
    return toDateString();
  }
}

/// Constantes de couleurs
class AppColors {
  // Couleurs principales
  static const Color primary = Colors.green;
  static const Color secondary = Color(0xFF4CAF50);

  // Statuts animaux
  static const Color statusAlive = Color(0xFF4CAF50);
  static const Color statusSold = Color(0xFFFF9800);
  static const Color statusDead = Color(0xFFF44336);
  static const Color statusSlaughtered = Color(0xFF9C27B0);

  // Rémanence
  static const Color withdrawalActive = Color(0xFFF44336);
  static const Color withdrawalWarning = Color(0xFFFF9800);
  static const Color withdrawalSoon = Color(0xFF2196F3);
  static const Color withdrawalInactive = Color(0xFF4CAF50);

  // Sexe
  static const Color male = Color(0xFF2196F3);
  static const Color female = Color(0xFFE91E63);

  // États
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Lots
  static const Color batchSale = Color(0xFF4CAF50);
  static const Color batchSlaughter = Color(0xFFF44336);
  static const Color batchTreatment = Color(0xFF2196F3);
  static const Color batchOther = Color(0xFF9E9E9E);
}

/// Constantes de tailles
class AppSizes {
  // Padding
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  // Border radius
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;

  // Icon sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;

  // Font sizes
  static const double fontSmall = 12.0;
  static const double fontMedium = 14.0;
  static const double fontLarge = 16.0;
  static const double fontXLarge = 20.0;
  static const double fontXXLarge = 24.0;
}
