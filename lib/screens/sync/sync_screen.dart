// lib/screens/sync_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/sync_provider.dart';
import '../../providers/animal_provider.dart';
import '../../providers/campaign_provider.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';

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
                        ? l10n.translate(AppStrings.onlineModeActivated)
                        : l10n.translate(AppStrings.offlineMode),
                  ),
                  duration: AppConstants.snackBarDurationShort,
                ),
              );
            },
            tooltip: l10n.translate(AppStrings.toggleOnlineOffline),
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
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          children: [
            Card(
              color: syncProvider.isOnline
                  ? Colors.green.shade50
                  : Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMedium),
                child: Row(
                  children: [
                    Icon(
                      syncProvider.isOnline
                          ? Icons.cloud_done
                          : Icons.cloud_off,
                      color: syncProvider.isOnline
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                      size: AppConstants.iconSizeMediumLarge,
                    ),
                    const SizedBox(width: AppConstants.spacingMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            syncProvider.isOnline
                                ? l10n.translate(AppStrings.connectedToServer)
                                : l10n.translate(AppStrings.offlineMode),
                            style: const TextStyle(
                              fontSize: AppConstants.fontSizeImportant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingTiny),
                          Text(
                            syncProvider.isOnline
                                ? l10n.translate(AppStrings.syncAvailable)
                                : l10n.translate(AppStrings.dataWillSyncLater),
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeSubtitle,
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
            const SizedBox(height: AppConstants.spacingMedium),
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
                const SizedBox(width: AppConstants.spacingSmall),
                Expanded(
                  child: _StatCard(
                    context: context,
                    icon: Icons.update,
                    label: l10n.translate(AppStrings.lastSync),
                    value: syncProvider.lastSyncDate != null
                        ? _formatLastSync(context, syncProvider.lastSyncDate!)
                        : l10n.translate(AppStrings.never),
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingMediumLarge),
            if (syncProvider.pendingDataCount > 0)
              SizedBox(
                width: double.infinity,
                height: AppConstants.syncButtonHeight,
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
                                      : l10n.translate(AppStrings.syncFailed),
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
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                                color: Colors.white),
                            const SizedBox(height: AppConstants.spacingSmall),
                            Text(l10n.translate(AppStrings.syncInProgress)),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.sync,
                                size: AppConstants.iconSizeMediumLarge),
                            const SizedBox(height: AppConstants.spacingExtraSmall),
                            Text(
                              l10n.translate(AppStrings.syncNow),
                              style: const TextStyle(
                                  fontSize: AppConstants.fontSizeImportant),
                            ),
                            if (!syncProvider.isOnline)
                              Text(
                                l10n.translate(AppStrings.requiresConnection),
                                style: const TextStyle(
                                    fontSize: AppConstants.fontSizeSmall),
                              ),
                          ],
                        ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingMediumLarge),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green.shade700,
                      size: AppConstants.iconSizeLarge,
                    ),
                    const SizedBox(height: AppConstants.spacingSmall),
                    Text(
                      l10n.translate(AppStrings.allDataSynchronized),
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeSectionTitle,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            if (syncProvider.syncError != null) ...[
              const SizedBox(height: AppConstants.spacingMedium),
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingMedium),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(AppConstants.badgeBorderRadius),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red.shade700),
                    const SizedBox(width: AppConstants.spacingSmall),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.translate(AppStrings.syncError),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: AppConstants.spacingTiny),
                          Text(
                            syncProvider.syncError!,
                            style: const TextStyle(
                                fontSize: AppConstants.fontSizeSmall),
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
            const SizedBox(height: AppConstants.spacingMediumLarge),
            Text(
              l10n.translate(AppStrings.localDataSummary),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            _SummaryCard(
              icon: Icons.pets,
              label: l10n.translate(AppStrings.animals),
              value: animalProvider.stats['total'].toString(),
            ),
            _SummaryCard(
              icon: Icons.medical_services,
              label: l10n.translate(AppStrings.treatments),
              value: animalProvider
                  .getActiveWithdrawalTreatments()
                  .length
                  .toString(),
            ),
            _SummaryCard(
              icon: Icons.campaign,
              label: l10n.translate(AppStrings.campaigns),
              value: campaignProvider.campaigns.length.toString(),
            ),
          ],
        ),
      ),
    );
  }

  String _formatLastSync(BuildContext context, DateTime dateTime) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return l10n.translate(AppStrings.justNow);
    } else if (difference.inHours < 1) {
      return l10n
          .translate(AppStrings.minutesAgo)
          .replaceAll('{minutes}', difference.inMinutes.toString());
    } else if (difference.inDays < 1) {
      return l10n
          .translate(AppStrings.hoursAgo)
          .replaceAll('{hours}', difference.inHours.toString());
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
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        child: Column(
          children: [
            Icon(icon, color: color, size: AppConstants.iconSizeMedium),
            const SizedBox(height: AppConstants.spacingExtraSmall),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: AppConstants.spacingTiny),
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
            fontSize: AppConstants.fontSizeImportant,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
