// lib/screens/sync_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/sync_provider.dart';
import '../../providers/animal_provider.dart';
import '../../providers/campaign_provider.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';

class SyncScreen extends StatelessWidget {
  const SyncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final syncProvider = context.watch<SyncProvider>();
    final animalProvider = context.watch<AnimalProvider>();
    final campaignProvider = context.watch<CampaignProvider>();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate(AppStrings.sync)),
        actions: [
          IconButton(
            icon: Icon(
              syncProvider.isOnline ? Icons.cloud : Icons.cloud_off,
            ),
            onPressed: () {
              syncProvider.toggleOnlineStatus();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    syncProvider.isOnline
                        ? 'Mode En Ligne activé'
                        : l10n.translate(AppStrings.offlineMode),
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'Basculer Online/Offline',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (syncProvider.isOnline) {
            await syncProvider.synchronize();
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              color: syncProvider.isOnline
                  ? Colors.green.shade50
                  : Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      syncProvider.isOnline
                          ? Icons.cloud_done
                          : Icons.cloud_off,
                      color: syncProvider.isOnline
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                      size: 48,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            syncProvider.isOnline
                                ? 'Connecté au serveur'
                                : l10n.translate(AppStrings.offlineMode),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            syncProvider.isOnline
                                ? 'Synchronisation disponible'
                                : 'Les données seront synchronisées plus tard',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    context: context,
                    icon: Icons.pending_actions,
                    label: l10n.translate(AppStrings.pendingData),
                    value: syncProvider.pendingDataCount.toString(),
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    context: context,
                    icon: Icons.update,
                    label: 'Dernière synchro',
                    value: syncProvider.lastSyncDate != null
                        ? _formatLastSync(syncProvider.lastSyncDate!)
                        : 'Jamais',
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (syncProvider.pendingDataCount > 0)
              SizedBox(
                width: double.infinity,
                height: 120,
                child: ElevatedButton(
                  onPressed: syncProvider.isSyncing || !syncProvider.isOnline
                      ? null
                      : () async {
                          final success = await syncProvider.synchronize();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success
                                      ? l10n.translate(AppStrings.syncSuccess)
                                      : 'Échec de la synchronisation',
                                ),
                                backgroundColor:
                                    success ? Colors.green : Colors.red,
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                  child: syncProvider.isSyncing
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Colors.white),
                            SizedBox(height: 12),
                            Text('Synchronisation en cours...'),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.sync, size: 48),
                            const SizedBox(height: 8),
                            Text(
                              l10n.translate(AppStrings.syncNow),
                              style: const TextStyle(fontSize: 18),
                            ),
                            if (!syncProvider.isOnline)
                              const Text(
                                '(Nécessite connexion)',
                                style: TextStyle(fontSize: 12),
                              ),
                          ],
                        ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green.shade700,
                      size: 64,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Toutes les données sont synchronisées',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            if (syncProvider.syncError != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Erreur de synchronisation',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            syncProvider.syncError!,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        syncProvider.clearError();
                      },
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            Text(
              'Résumé des données locales',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _SummaryCard(
              icon: Icons.pets,
              label: 'Animaux',
              value: animalProvider.stats['total'].toString(),
            ),
            _SummaryCard(
              icon: Icons.medical_services,
              label: 'Traitements',
              value: animalProvider
                  .getActiveWithdrawalTreatments()
                  .length
                  .toString(),
            ),
            _SummaryCard(
              icon: Icons.campaign,
              label: 'Campagnes',
              value: campaignProvider.campaigns.length.toString(),
            ),
          ],
        ),
      ),
    );
  }

  String _formatLastSync(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inHours < 1) {
      return 'Il y a ${difference.inMinutes}min';
    } else if (difference.inDays < 1) {
      return 'Il y a ${difference.inHours}h';
    } else {
      return DateFormat('dd/MM à HH:mm').format(dateTime);
    }
  }
}

class _StatCard extends StatelessWidget {
  final BuildContext context;
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.context,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(label),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
