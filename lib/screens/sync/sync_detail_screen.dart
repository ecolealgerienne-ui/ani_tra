// lib/screens/sync_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/sync_provider.dart';
import '../../providers/animal_provider.dart';
import '../../providers/campaign_provider.dart';
import '../../i18n/app_localizations.dart';

class SyncDetailScreen extends StatefulWidget {
  const SyncDetailScreen({super.key});

  @override
  State<SyncDetailScreen> createState() => _SyncDetailScreenState();
}

class _SyncDetailScreenState extends State<SyncDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final syncProvider = context.watch<SyncProvider>();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('sync_details')),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.pending), text: 'En attente'),
            Tab(icon: Icon(Icons.history), text: 'Historique'),
            Tab(icon: Icon(Icons.warning), text: 'Conflits'),
            Tab(icon: Icon(Icons.settings), text: 'Configuration'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: syncProvider.isOnline && !syncProvider.isSyncing
                ? () async {
                    await syncProvider.synchronize();
                  }
                : null,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PendingDataTab(),
          _SyncHistoryTab(),
          _ConflictsTab(),
          _SyncConfigTab(),
        ],
      ),
    );
  }
}

// ============================================================================
// TAB 1: PENDING DATA
// ============================================================================
class _PendingDataTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final syncProvider = context.watch<SyncProvider>();
    final animalProvider = context.watch<AnimalProvider>();

    // Simuler les données en attente (à adapter selon votre structure)
    final pendingAnimals = _getPendingAnimals(animalProvider);
    final pendingTreatments = _getPendingTreatments(animalProvider);
    final pendingEvents = _getPendingEvents();

    if (syncProvider.pendingDataCount == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.green.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune donnée en attente',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toutes vos données sont synchronisées',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary Card
        Card(
          color: Colors.orange.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.pending_actions,
                        color: Colors.orange.shade700, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${syncProvider.pendingDataCount} éléments en attente',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Seront synchronisés lors de la prochaine connexion',
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
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Animals pending
        if (pendingAnimals.isNotEmpty) ...[
          _SectionHeader(
            icon: Icons.pets,
            title: 'Animaux (${pendingAnimals.length})',
            color: Colors.blue,
          ),
          ...pendingAnimals.map((animal) => _PendingDataCard(
                icon: Icons.pets,
                title: animal['name'] as String,
                subtitle: animal['action'] as String,
                timestamp: animal['timestamp'] as DateTime,
                type: 'animal',
              )),
          const SizedBox(height: 16),
        ],

        // Treatments pending
        if (pendingTreatments.isNotEmpty) ...[
          _SectionHeader(
            icon: Icons.medical_services,
            title: 'Traitements (${pendingTreatments.length})',
            color: Colors.green,
          ),
          ...pendingTreatments.map((treatment) => _PendingDataCard(
                icon: Icons.medical_services,
                title: treatment['name'] as String,
                subtitle: treatment['action'] as String,
                timestamp: treatment['timestamp'] as DateTime,
                type: 'treatment',
              )),
          const SizedBox(height: 16),
        ],

        // Events pending
        if (pendingEvents.isNotEmpty) ...[
          _SectionHeader(
            icon: Icons.event,
            title: 'Événements (${pendingEvents.length})',
            color: Colors.purple,
          ),
          ...pendingEvents.map((event) => _PendingDataCard(
                icon: Icons.event,
                title: event['name'] as String,
                subtitle: event['action'] as String,
                timestamp: event['timestamp'] as DateTime,
                type: 'event',
              )),
        ],
      ],
    );
  }

  List<Map<String, dynamic>> _getPendingAnimals(AnimalProvider provider) {
    // Simuler les animaux en attente
    // Dans une vraie app, vous auriez un flag 'needsSync' ou 'pendingSync'
    return [
      {
        'name': 'Vache #1234',
        'action': 'Création en attente',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      },
      {
        'name': 'Vache #5678',
        'action': 'Modification en attente',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      },
    ];
  }

  List<Map<String, dynamic>> _getPendingTreatments(AnimalProvider provider) {
    return [
      {
        'name': 'Traitement antibiotique',
        'action': 'Ajout en attente',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      },
    ];
  }

  List<Map<String, dynamic>> _getPendingEvents() {
    return [
      {
        'name': 'Événement sanitaire',
        'action': 'Création en attente',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
      },
    ];
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingDataCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final String type;

  const _PendingDataCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getTypeColor().withOpacity(0.1),
          child: Icon(icon, color: _getTypeColor(), size: 20),
        ),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(timestamp),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            _showOptionsMenu(context);
          },
        ),
      ),
    );
  }

  Color _getTypeColor() {
    switch (type) {
      case 'animal':
        return Colors.blue;
      case 'treatment':
        return Colors.green;
      case 'event':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) {
      return 'À l\'instant';
    } else if (diff.inHours < 1) {
      return 'Il y a ${diff.inMinutes}min';
    } else if (diff.inDays < 1) {
      return 'Il y a ${diff.inHours}h';
    } else {
      return DateFormat('dd/MM à HH:mm').format(dt);
    }
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Voir les détails'),
              onTap: () {
                Navigator.pop(context);
                // Implémenter la vue détails
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Annuler la synchronisation',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                // Implémenter l'annulation
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// TAB 2: SYNC HISTORY
// ============================================================================
class _SyncHistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final syncProvider = context.watch<SyncProvider>();

    // Simuler un historique de synchronisations
    final history = _getSyncHistory();

    if (history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun historique',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Les synchronisations apparaîtront ici',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return _SyncHistoryCard(
          timestamp: item['timestamp'] as DateTime,
          success: item['success'] as bool,
          itemsSynced: item['itemsSynced'] as int,
          duration: item['duration'] as Duration,
          error: item['error'] as String?,
        );
      },
    );
  }

  List<Map<String, dynamic>> _getSyncHistory() {
    // Simuler un historique
    return [
      {
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'success': true,
        'itemsSynced': 15,
        'duration': const Duration(seconds: 3),
        'error': null,
      },
      {
        'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
        'success': true,
        'itemsSynced': 8,
        'duration': const Duration(seconds: 2),
        'error': null,
      },
      {
        'timestamp': DateTime.now().subtract(const Duration(hours: 24)),
        'success': false,
        'itemsSynced': 0,
        'duration': const Duration(seconds: 1),
        'error': 'Erreur de connexion au serveur',
      },
      {
        'timestamp': DateTime.now().subtract(const Duration(days: 2)),
        'success': true,
        'itemsSynced': 23,
        'duration': const Duration(seconds: 5),
        'error': null,
      },
    ];
  }
}

class _SyncHistoryCard extends StatelessWidget {
  final DateTime timestamp;
  final bool success;
  final int itemsSynced;
  final Duration duration;
  final String? error;

  const _SyncHistoryCard({
    required this.timestamp,
    required this.success,
    required this.itemsSynced,
    required this.duration,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  success ? Icons.check_circle : Icons.error,
                  color: success ? Colors.green : Colors.red,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        success
                            ? 'Synchronisation réussie'
                            : 'Échec de synchronisation',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy à HH:mm').format(timestamp),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (success) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.upload,
                    label: '$itemsSynced éléments',
                  ),
                  const SizedBox(width: 8),
                  _InfoChip(
                    icon: Icons.timer,
                    label: '${duration.inSeconds}s',
                  ),
                ],
              ),
            ],
            if (error != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline,
                        color: Colors.red.shade700, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        error!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.blue.shade700),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TAB 3: CONFLICTS
// ============================================================================
class _ConflictsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Simuler des conflits de synchronisation
    final conflicts = _getConflicts();

    if (conflicts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.green.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun conflit',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Toutes les données sont cohérentes',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: Colors.orange.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.orange.shade700, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${conflicts.length} conflit(s) détecté(s)',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Nécessite une résolution manuelle',
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
        ...conflicts.map((conflict) => _ConflictCard(
              entityType: conflict['entityType'] as String,
              entityName: conflict['entityName'] as String,
              localValue: conflict['localValue'] as String,
              serverValue: conflict['serverValue'] as String,
              timestamp: conflict['timestamp'] as DateTime,
            )),
      ],
    );
  }

  List<Map<String, dynamic>> _getConflicts() {
    // Simuler des conflits
    return [
      {
        'entityType': 'Animal',
        'entityName': 'Vache #1234',
        'localValue': 'Poids: 450kg',
        'serverValue': 'Poids: 455kg',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
      },
      {
        'entityType': 'Traitement',
        'entityName': 'Antibiotique XYZ',
        'localValue': 'Date fin: 15/10/2025',
        'serverValue': 'Date fin: 16/10/2025',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      },
    ];
  }
}

class _ConflictCard extends StatelessWidget {
  final String entityType;
  final String entityName;
  final String localValue;
  final String serverValue;
  final DateTime timestamp;

  const _ConflictCard({
    required this.entityType,
    required this.entityName,
    required this.localValue,
    required this.serverValue,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entityName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        entityType,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.phone_android,
                          size: 16, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        'Version locale',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(localValue),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.cloud, size: 16, color: Colors.green.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        'Version serveur',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(serverValue),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _resolveConflict(context, 'local');
                    },
                    icon: const Icon(Icons.phone_android),
                    label: const Text('Garder local'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _resolveConflict(context, 'server');
                    },
                    icon: const Icon(Icons.cloud),
                    label: const Text('Garder serveur'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _resolveConflict(BuildContext context, String choice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la résolution'),
        content: Text(
          choice == 'local'
              ? 'Voulez-vous garder la version locale et écraser la version serveur ?'
              : 'Voulez-vous garder la version serveur et écraser la version locale ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Conflit résolu : version ${choice == 'local' ? 'locale' : 'serveur'} conservée',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// TAB 4: CONFIGURATION
// ============================================================================
class _SyncConfigTab extends StatefulWidget {
  @override
  State<_SyncConfigTab> createState() => _SyncConfigTabState();
}

class _SyncConfigTabState extends State<_SyncConfigTab> {
  bool _autoSync = true;
  bool _syncOnWifiOnly = false;
  bool _syncPhotos = true;
  bool _syncDocuments = true;
  int _syncInterval = 15; // minutes

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Synchronisation automatique'),
                subtitle: const Text(
                    'Synchroniser automatiquement les données en arrière-plan'),
                value: _autoSync,
                onChanged: (value) {
                  setState(() {
                    _autoSync = value;
                  });
                },
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('WiFi uniquement'),
                subtitle: const Text(
                    'Synchroniser uniquement en WiFi pour économiser les données'),
                value: _syncOnWifiOnly,
                onChanged: (value) {
                  setState(() {
                    _syncOnWifiOnly = value;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Fréquence de synchronisation',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              RadioListTile<int>(
                title: const Text('Toutes les 5 minutes'),
                value: 5,
                groupValue: _syncInterval,
                onChanged: (value) {
                  setState(() {
                    _syncInterval = value!;
                  });
                },
              ),
              RadioListTile<int>(
                title: const Text('Toutes les 15 minutes'),
                value: 15,
                groupValue: _syncInterval,
                onChanged: (value) {
                  setState(() {
                    _syncInterval = value!;
                  });
                },
              ),
              RadioListTile<int>(
                title: const Text('Toutes les 30 minutes'),
                value: 30,
                groupValue: _syncInterval,
                onChanged: (value) {
                  setState(() {
                    _syncInterval = value!;
                  });
                },
              ),
              RadioListTile<int>(
                title: const Text('Toutes les heures'),
                value: 60,
                groupValue: _syncInterval,
                onChanged: (value) {
                  setState(() {
                    _syncInterval = value!;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Types de données à synchroniser',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              CheckboxListTile(
                title: const Text('Photos'),
                subtitle: const Text('Synchroniser les photos des animaux'),
                value: _syncPhotos,
                onChanged: (value) {
                  setState(() {
                    _syncPhotos = value!;
                  });
                },
              ),
              const Divider(height: 1),
              CheckboxListTile(
                title: const Text('Documents'),
                subtitle:
                    const Text('Synchroniser les certificats et documents'),
                value: _syncDocuments,
                onChanged: (value) {
                  setState(() {
                    _syncDocuments = value!;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Configuration enregistrée'),
                backgroundColor: Colors.green,
              ),
            );
          },
          icon: const Icon(Icons.save),
          label: const Text('Enregistrer la configuration'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {
            _showClearDataDialog(context);
          },
          icon: const Icon(Icons.delete_sweep, color: Colors.red),
          label: const Text(
            'Effacer les données locales',
            style: TextStyle(color: Colors.red),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Effacer les données'),
        content: const Text(
          'Êtes-vous sûr de vouloir effacer toutes les données locales ? '
          'Cette action est irréversible. Assurez-vous d\'avoir synchronisé vos données avant.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Données locales effacées'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Effacer'),
          ),
        ],
      ),
    );
  }
}
