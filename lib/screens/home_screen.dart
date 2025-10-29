// screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/animal_provider.dart';
import '../providers/campaign_provider.dart';
import '../providers/sync_provider.dart';
import '../providers/batch_provider.dart';

import 'scan_screen.dart';
import 'campaign_list_screen.dart';
import 'animal_list_screen.dart';
import 'add_animal_screen.dart';
import 'batch_create_screen.dart';
import 'settings_screen.dart';

/// Écran d'accueil (Dashboard)
///
/// Affiche :
/// - Recherche rapide (EID ou N° officiel)
/// - Statistiques clés (effectif, alertes, sync)
/// - Actions rapides (Scanner, Campagne, Animaux, Ajouter, Lots)
/// - Campagnes actives
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
    if (query.trim().isEmpty) {
      return;
    }

    final animalProvider = context.read<AnimalProvider>();
    final animal = animalProvider.findByEIDOrNumber(query.trim());

    if (animal != null) {
      // Animal trouvé → Naviguer vers le détail
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanScreen(
            preloadedAnimal: animal,
          ),
        ),
      );

      // Vider le champ de recherche
      _searchController.clear();
    } else {
      // Animal non trouvé
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
          // 🆕 Bouton Paramètres
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Paramètres',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Simuler un refresh
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🆕 Bannière Mode Hors Ligne (si applicable)
              Consumer<SyncProvider>(
                builder: (context, syncProvider, child) {
                  // TODO: Implémenter la détection offline réelle
                  final isOffline = false; // Placeholder

                  if (!isOffline) return const SizedBox.shrink();

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.cloud_off, color: Colors.orange.shade800),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Mode Hors Ligne',
                            style: TextStyle(
                              color: Colors.orange.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // 🆕 Barre de Recherche Rapide
              _buildSearchBar(context),

              const SizedBox(height: 24),

              // Statistiques
              _buildStatsCards(context),

              const SizedBox(height: 24),

              // Actions Rapides
              _buildQuickActions(context),

              const SizedBox(height: 24),

              // Campagnes Actives
              _buildActiveCampaigns(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget : Barre de recherche rapide
  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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

  /// Widget : Cartes de statistiques
  Widget _buildStatsCards(BuildContext context) {
    return Consumer3<AnimalProvider, SyncProvider, BatchProvider>(
      builder: (context, animalProvider, syncProvider, batchProvider, child) {
        final totalAnimals = animalProvider.animals.length;
        final aliveAnimals = animalProvider.animals
            .where((a) => a.status == AnimalStatus.alive)
            .length;
        final pendingSync = syncProvider.pendingDataCount;

        // Compter les alertes de rémanence
        int withdrawalAlerts = 0;
        for (final animal in animalProvider.animals) {
          if (animal.status != AnimalStatus.alive) continue;

          final treatments = animalProvider.getAnimalTreatments(animal.id);
          for (final treatment in treatments) {
            if (treatment.isWithdrawalActive &&
                treatment.daysUntilWithdrawalEnd < 7) {
              withdrawalAlerts++;
              break; // Un seul comptage par animal
            }
          }
        }

        return Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.pets,
                label: 'Total',
                value: totalAnimals.toString(),
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.check_circle,
                label: 'Vivants',
                value: aliveAnimals.toString(),
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.sync,
                label: 'En attente',
                value: pendingSync.toString(),
                color: pendingSync > 0 ? Colors.orange : Colors.grey,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.warning,
                label: 'Alertes',
                value: withdrawalAlerts.toString(),
                color: withdrawalAlerts > 0 ? Colors.red : Colors.grey,
              ),
            ),
          ],
        );
      },
    );
  }

  /// Widget : Actions rapides
  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions Rapides',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),

        // Grille 2x3
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            // Scanner un Animal
            _QuickActionCard(
              icon: Icons.qr_code_scanner,
              label: 'Scanner un Animal',
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScanScreen(),
                  ),
                );
              },
            ),

            // Nouvelle Campagne
            _QuickActionCard(
              icon: Icons.medical_services,
              label: 'Nouvelle Campagne',
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CampaignListScreen(),
                  ),
                );
              },
            ),

            // Animaux (liste)
            _QuickActionCard(
              icon: Icons.list,
              label: 'Animaux',
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AnimalListScreen(),
                  ),
                );
              },
            ),

            // 🆕 Ajouter Animal
            _QuickActionCard(
              icon: Icons.add,
              label: 'Ajouter Animal',
              color: Colors.teal,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddAnimalScreen(),
                  ),
                );
              },
            ),

            // 🆕 Préparer un Lot
            _QuickActionCard(
              icon: Icons.inventory,
              label: 'Préparer un Lot',
              color: Colors.deepPurple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BatchCreateScreen(),
                  ),
                );
              },
            ),

            // Placeholder pour future action
            _QuickActionCard(
              icon: Icons.more_horiz,
              label: 'Plus',
              color: Colors.grey,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fonctionnalité à venir'),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Widget : Campagnes actives
  Widget _buildActiveCampaigns(BuildContext context) {
    return Consumer<CampaignProvider>(
      builder: (context, campaignProvider, child) {
        final activeCampaigns = campaignProvider.activeCampaigns;

        if (activeCampaigns.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Campagnes Actives',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Liste des campagnes
            ...activeCampaigns.map((campaign) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(
                      Icons.medical_services,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  title: Text(
                    campaign.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${campaign.animalCount} animaux',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                  ),
                  onTap: () {
                    // TODO: Naviguer vers détail campagne
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Campagne: ${campaign.productName}'),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }
}

/// Widget : Carte de statistique
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Widget : Carte d'action rapide
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
