// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/animal_provider.dart';
import '../../providers/batch_provider.dart';
import '../../../providers/sync_provider.dart';
import '../../providers/alert_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/farm_provider.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';
import '../../models/animal.dart';
//import '../../models/alert.dart';
import '../../models/alert_type.dart';

import '../animal/animal_list_screen.dart';
import '../animal/animal_detail_screen.dart';
//import '../animal/animal_finder_screen.dart';
import '../lot/lot_list_screen.dart';
import '../settings/account_settings_screen.dart';
import '../settings/farm_settings_screen.dart';
import '../settings/app_settings_screen.dart';
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
          content: Text(
            AppLocalizations.of(context)
                .translate(AppStrings.animalNotFoundSearch)
                .replaceAll('{query}', query),
          ),
          backgroundColor: Colors.red,
          duration: AppConstants.snackBarDurationMedium,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Consumer2<AuthProvider, FarmProvider>(
          builder: (context, auth, farmProvider, child) {
            return PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'account') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountSettingsScreen(),
                    ),
                  );
                } else if (value == 'farm') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FarmSettingsScreen(),
                    ),
                  );
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        auth.currentUserName ?? 'Utilisateur',
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeBody,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingMicro),
                      Text(
                        farmProvider.currentFarm?.name ?? '',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: AppConstants.opacitySubtle),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: AppConstants.spacingTiny),
                  const Icon(Icons.arrow_drop_down, size: AppConstants.iconSizeRegular),
                ],
              ),
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  value: 'account',
                  child: Row(
                    children: [
                      const Icon(Icons.person),
                      const SizedBox(width: AppConstants.spacingSmall),
                      Text(l10n.translate(AppStrings.myAccount)),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'farm',
                  child: Row(
                    children: [
                      const Icon(Icons.agriculture),
                      const SizedBox(width: AppConstants.spacingSmall),
                      Text(l10n.translate(AppStrings.farmSettings)),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: l10n.translate(AppStrings.settings),
            onPressed: () {
              AppSettingsScreen.show(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header "Tableau de Bord" centré
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppConstants.spacingSmall,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Center(
              child: Text(
                l10n.translate(AppStrings.dashboard),
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeImportant,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // 🆕 Bannière d'alerte urgente (si présente)
          _buildUrgentAlertBanner(context),

          // Contenu principal
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(AppConstants.snackBarDurationShort);
                if (!mounted) return;
                // Forcer le recalcul des alertes
                context.read<AlertProvider>().refresh();
                setState(() {});
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppConstants.spacingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Barre de recherche
                    _buildSearchBar(context),

                    const SizedBox(height: AppConstants.spacingMediumLarge),

                    // Statistiques (3 cartes compactes)
                    _buildStatsCards(context),

                    const SizedBox(height: AppConstants.spacingLarge),

                    // Titre section
                    Text(
                      AppLocalizations.of(context)
                          .translate(AppStrings.quickActions),
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: AppConstants.spacingMedium),

                    // 🆕 CARTE 1 : ANIMAUX (grosse carte)
                    _buildMainActionCard(
                      context: context,
                      icon: Icons.pets,
                      iconColor: Colors.blue,
                      title: AppLocalizations.of(context)
                          .translate(AppStrings.animals),
                      subtitle: AppLocalizations.of(context)
                          .translate(AppStrings.manageHerd),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AnimalListScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: AppConstants.spacingMedium),

                    // 🆕 CARTE 2 : LOTS (grosse carte)
                    _buildMainActionCard(
                      context: context,
                      icon: Icons.inventory_2,
                      iconColor: Colors.orange,
                      title: AppLocalizations.of(context)
                          .translate(AppStrings.myLots),
                      subtitle: AppLocalizations.of(context)
                          .translate(AppStrings.campaignsGroups),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LotListScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: AppConstants.spacingMedium),

                    // 🆕 PART3 : CARTE 3 : EXPORT PDF
                    _buildMainActionCard(
                      context: context,
                      icon: Icons.picture_as_pdf,
                      iconColor: Colors.purple,
                      title: AppLocalizations.of(context)
                          .translate(AppStrings.exportRegistry),
                      subtitle: AppLocalizations.of(context)
                          .translate(AppStrings.pdfControl),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ExportRegistryScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: AppConstants.spacingMediumLarge),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // FAB Scanner
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () async {
      //     final animal = await Navigator.push<Animal>(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => AnimalFinderScreen(
      //           mode: AnimalFinderMode.single,
      //           title: AppLocalizations.of(context)
      //               .translate(AppStrings.identifyAnimal),
      //         ),
      //       ),
      //     );

      //     if (!mounted) return;
      //     if (animal != null) {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => AnimalDetailScreen(
      //             preloadedAnimal: animal,
      //           ),
      //         ),
      //       );
      //     }
      //   },
      //   icon: const Icon(Icons.qr_code_scanner),
      //   label: Text(AppLocalizations.of(context).translate(AppStrings.scanner)),
      // ),
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
                  size: AppConstants.iconSizeMedium,
                ),
                const SizedBox(width: AppConstants.spacingSmall),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstAlert.getTitle(context),
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeBody,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade900,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingMicro),
                      Text(
                        firstAlert.getMessage(context),
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          color: Colors.red.shade700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppConstants.spacingExtraSmall),
                if (urgentAlerts.length > 1)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
                    ),
                    child: Text(
                      '+${urgentAlerts.length - 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: AppConstants.fontSizeSmall,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: AppConstants.iconSizeXSmall,
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
        borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
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
          hintText:
              AppLocalizations.of(context).translate(AppStrings.searchHint),
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
            borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
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
                label:
                    AppLocalizations.of(context).translate(AppStrings.animals),
                value: '$aliveAnimals',
                subtitle: AppLocalizations.of(context)
                    .translate(AppStrings.aliveStatus),
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: AppConstants.spacingSmall),

            // Stat 2 : Lots actifs
            Expanded(
              child: _StatCard(
                icon: Icons.inventory_2,
                label: AppLocalizations.of(context).translate(AppStrings.lots),
                value: '$activeLots',
                subtitle: AppLocalizations.of(context)
                    .translate(AppStrings.activeStatus),
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: AppConstants.spacingSmall),

            // Stat 3 : Alertes urgentes (depuis AlertProvider)
            Expanded(
              child: _StatCard(
                icon: Icons.warning,
                label:
                    AppLocalizations.of(context).translate(AppStrings.alerts),
                value: '$urgentAlerts',
                subtitle: AppLocalizations.of(context)
                    .translate(AppStrings.urgentStatus),
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
                borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
              ),
              child: Icon(
                icon,
                size: AppConstants.iconSizeMedium,
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
                      fontSize: AppConstants.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingTiny),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeBody,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Flèche
            Icon(
              Icons.arrow_forward_ios,
              size: AppConstants.iconSizeRegular,
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
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
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
          Icon(icon, color: color, size: AppConstants.iconSizeMedium),
          const SizedBox(height: AppConstants.spacingExtraSmall),
          Text(
            value,
            style: TextStyle(
              fontSize: AppConstants.fontSizeExtraLarge,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: AppConstants.spacingTiny),
          Text(
            label,
            style: TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          if (subtitle != null) ...[
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: AppConstants.fontSizeMicro,
                color: Colors.grey[500],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
