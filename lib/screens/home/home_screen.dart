// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/animal_provider.dart';
import '../../providers/batch_provider.dart';
import '../../../providers/sync_provider.dart';
import '../../providers/alert_provider.dart';
import '../../models/animal.dart';
//import '../../models/alert.dart';
import '../../models/alert_type.dart';

import '../animal/animal_list_screen.dart';
import '../animal/animal_detail_screen.dart';
import '../animal/animal_finder_screen.dart';
import '../lot/lot_list_screen.dart';
import '../settings/settings_screen.dart';
import '../alert/alerts_screen.dart';
import '../services/export_registry_screen.dart'; // 🆕 PART3

/// Écran d'accueil simplifié
///
/// Affiche :
/// - 🆕 Bannière d'alerte rouge (si urgence)
/// - Barre de recherche rapide
/// - Statistiques clés (3 cartes compactes)
/// - 3 Actions Rapides principales (Animaux + Lots + Vaccinations)
/// - 🆕 Export PDF (PART3)
/// - FAB Scanner
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Rechercher un animal par EID ou N° officiel
  void _searchAnimal(BuildContext context, String query) {
    if (query.trim().isEmpty) return;

    final animalProvider = context.read<AnimalProvider>();
    final animal = animalProvider.findByEIDOrNumber(query.trim());

    if (animal != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnimalDetailScreen(preloadedAnimal: animal),
        ),
      );
      _searchController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Animal "$query" non trouvé'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de Bord'),
        actions: [
          // 🆕 Bouton Alertes avec badge
          Consumer<AlertProvider>(
            builder: (context, alertProvider, child) {
              final alertCount = alertProvider.alertCount;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    tooltip: 'Alertes',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AlertsScreen(),
                        ),
                      );
                    },
                  ),
                  if (alertCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          alertCount > 9 ? '9+' : '$alertCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Paramètres',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 🆕 Bannière d'alerte urgente (si présente)
          _buildUrgentAlertBanner(context),

          // Contenu principal
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1));
                if (!mounted) return;
                // Forcer le recalcul des alertes
                context.read<AlertProvider>().refresh();
                setState(() {});
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Barre de recherche
                    _buildSearchBar(context),

                    const SizedBox(height: 24),

                    // Statistiques (3 cartes compactes)
                    _buildStatsCards(context),

                    const SizedBox(height: 32),

                    // Titre section
                    const Text(
                      'Actions Rapides',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 🆕 CARTE 1 : ANIMAUX (grosse carte)
                    _buildMainActionCard(
                      context: context,
                      icon: Icons.pets,
                      iconColor: Colors.blue,
                      title: 'Animaux',
                      subtitle: 'Gérer mon troupeau',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AnimalListScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // 🆕 CARTE 2 : LOTS (grosse carte)
                    _buildMainActionCard(
                      context: context,
                      icon: Icons.inventory_2,
                      iconColor: Colors.orange,
                      title: 'Mes Lots',
                      subtitle: 'Campagnes & groupes',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LotListScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // 🆕 PART3 : CARTE 3 : EXPORT PDF
                    _buildMainActionCard(
                      context: context,
                      icon: Icons.picture_as_pdf,
                      iconColor: Colors.purple,
                      title: 'Export Registre',
                      subtitle: 'PDF pour contrôle',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ExportRegistryScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // FAB Scanner
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final animal = await Navigator.push<Animal>(
            context,
            MaterialPageRoute(
              builder: (context) => const AnimalFinderScreen(
                mode: AnimalFinderMode.single,
                title: 'Identifier un animal',
              ),
            ),
          );

          if (!mounted) return;
          if (animal != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AnimalDetailScreen(
                  preloadedAnimal: animal,
                ),
              ),
            );
          }
        },
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Scanner'),
      ),
    );
  }

  /// Widget : Bannière d'alerte urgente (rouge, en haut)
  /// 🆕 Affiche la première alerte urgente s'il y en a
  Widget _buildUrgentAlertBanner(BuildContext context) {
    return Consumer<AlertProvider>(
      builder: (context, alertProvider, child) {
        final urgentAlerts = alertProvider.alerts
            .where((a) => a.type == AlertType.urgent)
            .toList();

        if (urgentAlerts.isEmpty) {
          return const SizedBox.shrink();
        }

        final firstAlert = urgentAlerts.first;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            border: Border(
              bottom: BorderSide(
                color: Colors.red.shade200,
                width: 1,
              ),
            ),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AlertsScreen(),
                ),
              );
            },
            child: Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red.shade700,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstAlert.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        firstAlert.message,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.shade700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (urgentAlerts.length > 1)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '+${urgentAlerts.length - 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.red.shade700,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Widget : Barre de recherche
  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Rechercher EID ou N°...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        onSubmitted: (value) => _searchAnimal(context, value),
        onChanged: (value) {
          setState(() {}); // Pour afficher/masquer le bouton clear
        },
      ),
    );
  }

  /// Widget : Cartes de statistiques (3 cartes compactes)
  /// 🆕 Utilise maintenant AlertProvider pour les alertes
  Widget _buildStatsCards(BuildContext context) {
    return Consumer4<AnimalProvider, SyncProvider, BatchProvider,
        AlertProvider>(
      builder: (context, animalProvider, syncProvider, batchProvider,
          alertProvider, child) {
        final aliveAnimals = animalProvider.animals
            .where((a) => a.status == AnimalStatus.alive)
            .length;

        // Compter les lots actifs
        final activeLots = batchProvider.batches.length;

        // 🆕 Utiliser AlertProvider pour les alertes urgentes
        final urgentAlerts = alertProvider.urgentAlertCount;

        return Row(
          children: [
            // Stat 1 : Total animaux
            Expanded(
              child: _StatCard(
                icon: Icons.pets,
                label: 'Animaux',
                value: '$aliveAnimals',
                subtitle: 'vivants',
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),

            // Stat 2 : Lots actifs
            Expanded(
              child: _StatCard(
                icon: Icons.inventory_2,
                label: 'Lots',
                value: '$activeLots',
                subtitle: 'actifs',
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),

            // Stat 3 : Alertes urgentes (depuis AlertProvider)
            Expanded(
              child: _StatCard(
                icon: Icons.warning,
                label: 'Alertes',
                value: '$urgentAlerts',
                subtitle: 'urgentes',
                color: urgentAlerts > 0 ? Colors.red : Colors.green,
              ),
            ),
          ],
        );
      },
    );
  }

  /// Widget : Grande carte d'action principale
  Widget _buildMainActionCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icône
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: iconColor,
              ),
            ),

            const SizedBox(width: 20),

            // Textes
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Flèche
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget : Carte de statistique compacte
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          if (subtitle != null) ...[
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[500],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
