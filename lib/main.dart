// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/animal_provider.dart';
import 'providers/sync_provider.dart';
import 'providers/qr_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/batch_provider.dart';
import 'providers/campaign_provider.dart';
import 'providers/lot_provider.dart';
import 'providers/weight_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/alert_provider.dart';
import 'i18n/app_localizations.dart';
import 'screens/home_screen.dart';
import 'screens/scan_screen.dart';
import 'screens/animal_list_screen.dart';
import 'screens/sync_screen.dart';
import 'data/mock_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Providers de base (pas de dépendances)
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => QRProvider()),
        ChangeNotifierProvider(create: (_) => SyncProvider()),

        // Provider de paramètres (ÉTAPE 4)
        ChangeNotifierProvider(
          create: (_) {
            final provider = SettingsProvider();
            provider.initializeWithDefaults();
            return provider;
          },
        ),

        // Provider avec données mock
        ChangeNotifierProvider(
          create: (_) {
            final provider = AnimalProvider();
            // Charger les données mock
            provider.initializeWithMockData(
              MockData.generateAnimals(),
              MockData.generateProducts(),
              MockData.generateTreatments(),
              MockData.generateMovements(),
            );
            return provider;
          },
        ),

        // Provider de lots/batches
        ChangeNotifierProvider(
          create: (_) {
            final provider = BatchProvider();
            // Charger les lots mock
            provider.initializeWithMockData(MockData.generateBatches());
            return provider;
          },
        ),

        // Provider de lots (nouveau système unifié)
        ChangeNotifierProvider(
          create: (_) => LotProvider(),
        ),

        // Provider de campagnes
        ChangeNotifierProvider(
          create: (_) => CampaignProvider(),
        ),

        // Provider de pesées
        ChangeNotifierProvider(
          create: (_) {
            final provider = WeightProvider();
            // Charger les pesées mock
            provider.setWeights(MockData.generateWeights());
            return provider;
          },
        ),

        // 🆕 Provider d'alertes (dépend de Animal, Weight, Sync)
        ChangeNotifierProxyProvider3<AnimalProvider, WeightProvider,
            SyncProvider, AlertProvider>(
          create: (context) => AlertProvider(
            animalProvider: context.read<AnimalProvider>(),
            weightProvider: context.read<WeightProvider>(),
            syncProvider: context.read<SyncProvider>(),
          ),
          update: (context, animal, weight, sync, previous) =>
              previous ??
              AlertProvider(
                animalProvider: animal,
                weightProvider: weight,
                syncProvider: sync,
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
            // ✅ AJOUT CRITIQUE : Delegates de localisation
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

  static const List<Widget> _screens = [
    HomeScreen(),
    ScanScreen(),
    AnimalListScreen(),
    SyncScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
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
