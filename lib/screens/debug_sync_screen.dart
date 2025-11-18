// lib/screens/debug_sync_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../drift/database.dart';
import '../providers/farm_provider.dart';
import '../repositories/sync_queue_repository.dart';
import '../utils/sync_config.dart';
import '../i18n/app_localizations.dart';

/// Écran de debug pour visualiser et gérer la queue de synchronisation (STEP 4)
class DebugSyncScreen extends StatefulWidget {
  const DebugSyncScreen({super.key});

  @override
  State<DebugSyncScreen> createState() => _DebugSyncScreenState();
}

class _DebugSyncScreenState extends State<DebugSyncScreen> {
  late SyncQueueRepository _syncQueueRepo;
  SyncQueueStats? _stats;
  List<SyncQueueTableData> _pendingItems = [];
  List<SyncQueueTableData> _stalledItems = [];
  bool _isLoading = true;
  String? _farmId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final farmProvider = Provider.of<FarmProvider>(context, listen: false);

    _syncQueueRepo = SyncQueueRepository(db);
    _farmId = farmProvider.currentFarm?.id;

    if (_farmId != null) {
      await _loadData();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadData() async {
    if (_farmId == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final stats = await _syncQueueRepo.getStats(_farmId!);
      final pending = await _syncQueueRepo.getPending(_farmId!);
      final stalled = await _syncQueueRepo.getStalled(_farmId!);

      setState(() {
        _stats = stats;
        _pendingItems = pending;
        _stalledItems = stalled;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _clearQueue() async {
    if (_farmId == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('clearQueue')),
        content: Text(AppLocalizations.of(context).translate('clearQueueConfirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppLocalizations.of(context).translate('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(AppLocalizations.of(context).translate('confirm')),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _syncQueueRepo.deleteAll(_farmId!);
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).translate('queueCleared'))),
        );
      }
    }
  }

  Future<void> _retryAllStalled() async {
    if (_farmId == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('retryAll')),
        content: Text(AppLocalizations.of(context).translate('retryAllConfirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppLocalizations.of(context).translate('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(AppLocalizations.of(context).translate('confirm')),
          ),
        ],
      ),
    );

    if (confirm == true) {
      for (final item in _stalledItems) {
        await _syncQueueRepo.resetRetry(item.id, _farmId!);
      }
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).translate('retriesReset'))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('syncQueueDebug')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: l10n.translate('refreshStats'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _farmId == null
              ? Center(child: Text(l10n.translate('noFarmAvailable')))
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sync status card
                        _buildSyncStatusCard(l10n),
                        const SizedBox(height: 16),

                        // Stats card
                        _buildStatsCard(l10n),
                        const SizedBox(height: 16),

                        // Actions
                        _buildActionsCard(l10n),
                        const SizedBox(height: 16),

                        // Pending items
                        _buildItemsSection(
                          l10n,
                          l10n.translate('pendingItems'),
                          _pendingItems,
                          Colors.orange,
                        ),
                        const SizedBox(height: 16),

                        // Stalled items
                        _buildItemsSection(
                          l10n,
                          l10n.translate('stalledItems'),
                          _stalledItems,
                          Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildSyncStatusCard(AppLocalizations l10n) {
    final isEnabled = SyncConfig.isSyncEnabled();

    return Card(
      child: ListTile(
        leading: Icon(
          isEnabled ? Icons.cloud_done : Icons.cloud_off,
          color: isEnabled ? Colors.green : Colors.grey,
          size: 32,
        ),
        title: Text(
          isEnabled
              ? l10n.translate('syncEnabled')
              : l10n.translate('syncDisabled'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isEnabled ? Colors.green : Colors.grey,
          ),
        ),
        subtitle: Text(l10n.translate('toggleSync')),
        trailing: Switch(
          value: isEnabled,
          onChanged: (value) {
            SyncConfig.setSyncEnabled(value);
            setState(() {});
          },
        ),
      ),
    );
  }

  Widget _buildStatsCard(AppLocalizations l10n) {
    if (_stats == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(l10n.translate('queueEmpty')),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.translate('syncStats'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  l10n.translate('pendingItems'),
                  _stats!.pendingCount.toString(),
                  Colors.orange,
                ),
                _buildStatItem(
                  l10n.translate('stalledItems'),
                  _stats!.stalledCount.toString(),
                  Colors.red,
                ),
                _buildStatItem(
                  l10n.translate('totalItems'),
                  _stats!.totalCount.toString(),
                  Colors.blue,
                ),
              ],
            ),
            if (_stats!.byEntityType.isNotEmpty) ...[
              const Divider(height: 24),
              Text(
                l10n.translate('byEntity'),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _stats!.byEntityType.entries.map((entry) {
                  return Chip(
                    label: Text('${entry.key}: ${entry.value}'),
                    backgroundColor: Colors.grey[200],
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildActionsCard(AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: _pendingItems.isEmpty && _stalledItems.isEmpty
                  ? null
                  : _clearQueue,
              icon: const Icon(Icons.delete_sweep),
              label: Text(l10n.translate('clearQueue')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
            ElevatedButton.icon(
              onPressed: _stalledItems.isEmpty ? null : _retryAllStalled,
              icon: const Icon(Icons.replay),
              label: Text(l10n.translate('retryAll')),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsSection(
    AppLocalizations l10n,
    String title,
    List<SyncQueueTableData> items,
    Color color,
  ) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.list, color: color),
                const SizedBox(width: 8),
                Text(
                  '$title (${items.length})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.translate('noItemsInQueue'),
                style: TextStyle(color: Colors.grey[600]),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return _buildQueueItem(l10n, items[index], color);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildQueueItem(
    AppLocalizations l10n,
    SyncQueueTableData item,
    Color color,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Text(
          item.entityType.substring(0, 1).toUpperCase(),
          style: TextStyle(color: color),
        ),
      ),
      title: Text(
        '${item.entityType} - ${item.action}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ID: ${item.entityId}'),
          if (item.retryCount > 0)
            Text(
              '${l10n.translate('retryCount')}: ${item.retryCount}',
              style: const TextStyle(color: Colors.orange),
            ),
          if (item.errorMessage != null)
            Text(
              '${l10n.translate('lastError')}: ${item.errorMessage}',
              style: const TextStyle(color: Colors.red, fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) => _handleItemAction(value, item),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'view',
            child: Row(
              children: [
                const Icon(Icons.visibility),
                const SizedBox(width: 8),
                Text(l10n.translate('viewPayload')),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'retry',
            child: Row(
              children: [
                const Icon(Icons.replay),
                const SizedBox(width: 8),
                Text(l10n.translate('retryItem')),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                const Icon(Icons.delete, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  l10n.translate('deleteItem'),
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleItemAction(String action, SyncQueueTableData item) async {
    if (_farmId == null) return;
    final l10n = AppLocalizations.of(context);

    switch (action) {
      case 'view':
        _showPayloadDialog(item);
        break;
      case 'retry':
        await _syncQueueRepo.resetRetry(item.id, _farmId!);
        await _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.translate('itemRetryReset'))),
          );
        }
        break;
      case 'delete':
        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l10n.translate('deleteItem')),
            content: Text(l10n.translate('deleteItemConfirm')),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l10n.translate('cancel')),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l10n.translate('confirm')),
              ),
            ],
          ),
        );
        if (confirm == true) {
          final db = Provider.of<AppDatabase>(context, listen: false);
          await db.syncQueueDao.deleteItem(item.id, _farmId!);
          await _loadData();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.translate('itemDeleted'))),
            );
          }
        }
        break;
    }
  }

  void _showPayloadDialog(SyncQueueTableData item) {
    final l10n = AppLocalizations.of(context);
    String payloadJson = '';

    try {
      final decoded = utf8.decode(item.payload);
      final parsed = jsonDecode(decoded);
      payloadJson = const JsonEncoder.withIndent('  ').convert(parsed);
    } catch (e) {
      payloadJson = 'Error decoding payload: $e';
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.translate('payloadDetails')),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${l10n.translate('entityType')}: ${item.entityType}'),
              Text('${l10n.translate('action')}: ${item.action}'),
              Text('ID: ${item.entityId}'),
              const Divider(),
              Text(
                l10n.translate('payload'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SelectableText(
                  payloadJson,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: payloadJson));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.translate('payloadCopied'))),
              );
            },
            child: Text(l10n.translate('copyPayload')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.translate('close')),
          ),
        ],
      ),
    );
  }
}
