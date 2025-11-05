// lib/widgets/sync_indicator.dart
import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// Indicateur de synchronisation dans le header
///
/// Affiche l'état de synchronisation avec le serveur :
/// - ☁️ Synchronisé (vert)
/// - 🔄 Synchronisation en cours (animation)
/// - ⚠️ Données en attente (orange avec badge)
/// - ❌ Hors ligne (gris)
///
/// Cliquable pour ouvrir les détails de synchronisation
class SyncIndicator extends StatelessWidget {
  final bool isOnline;
  final bool isSyncing;
  final int pendingCount;
  final DateTime? lastSyncDate;
  final VoidCallback? onTap;

  const SyncIndicator({
    super.key,
    required this.isOnline,
    required this.isSyncing,
    required this.pendingCount,
    this.lastSyncDate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône avec état
            _buildIcon(),
            const SizedBox(width: 6),

            // Badge avec nombre de données en attente (si applicable)
            if (pendingCount > 0 && !isSyncing) _buildBadge(),
          ],
        ),
      ),
    );
  }

  /// Construit l'icône selon l'état
  Widget _buildIcon() {
    if (isSyncing) {
      return _SyncingIcon();
    }

    if (!isOnline) {
      return Icon(
        Icons.cloud_off_rounded,
        color: Colors.grey.shade600,
        size: 24,
      );
    }

    if (pendingCount > 0) {
      return Icon(
        Icons.cloud_upload_rounded,
        color: Colors.orange.shade700,
        size: 24,
      );
    }

    return const Icon(
      Icons.cloud_done_rounded,
      color: AppConstants.primaryGreen,
      size: 24,
    );
  }

  /// Construit le badge avec le nombre de données en attente
  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.orange.shade700,
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(minWidth: 20),
      child: Text(
        pendingCount > 99 ? '99+' : '$pendingCount',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Icône de synchronisation avec animation de rotation
class _SyncingIcon extends StatefulWidget {
  @override
  State<_SyncingIcon> createState() => _SyncingIconState();
}

class _SyncingIconState extends State<_SyncingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Icon(
        Icons.sync_rounded,
        color: AppConstants.tertiaryBlue,
        size: 24,
      ),
    );
  }
}

/// Dialogue de détails de synchronisation
///
/// Affiche :
/// - État de connexion
/// - Date de dernière synchronisation
/// - Nombre de données en attente
/// - Bouton pour forcer la synchronisation
class SyncDetailsDialog extends StatelessWidget {
  final bool isOnline;
  final bool isSyncing;
  final int pendingCount;
  final DateTime? lastSyncDate;
  final VoidCallback? onSync;

  const SyncDetailsDialog({
    super.key,
    required this.isOnline,
    required this.isSyncing,
    required this.pendingCount,
    this.lastSyncDate,
    this.onSync,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.cloud_rounded, color: AppConstants.primaryGreen),
          SizedBox(width: 8),
          Text('Synchronisation'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // État de connexion
          _InfoRow(
            icon: isOnline ? Icons.wifi_rounded : Icons.wifi_off_rounded,
            iconColor: isOnline ? Colors.green : Colors.red,
            label: 'Connexion',
            value: isOnline ? 'En ligne' : 'Hors ligne',
          ),
          const SizedBox(height: 12),

          // Dernière synchronisation
          if (lastSyncDate != null) ...[
            _InfoRow(
              icon: Icons.access_time_rounded,
              iconColor: AppConstants.tertiaryBlue,
              label: 'Dernière sync',
              value: _formatLastSync(lastSyncDate!),
            ),
            const SizedBox(height: 12),
          ],

          // Données en attente
          _InfoRow(
            icon: Icons.pending_actions_rounded,
            iconColor: pendingCount > 0 ? Colors.orange : Colors.green,
            label: 'En attente',
            value: pendingCount == 0
                ? 'Aucune donnée'
                : pendingCount == 1
                    ? '1 donnée'
                    : '$pendingCount données',
          ),

          // Message si synchronisation en cours
          if (isSyncing) ...[
            const SizedBox(height: 16),
            const Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('Synchronisation en cours...'),
              ],
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fermer'),
        ),
        if (pendingCount > 0 && !isSyncing && onSync != null)
          FilledButton.icon(
            onPressed: () {
              onSync!();
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.sync_rounded, size: 18),
            label: const Text('Synchroniser'),
          ),
      ],
    );
  }

  /// Formate la date de dernière synchronisation
  String _formatLastSync(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) {
      return 'À l\'instant';
    } else if (diff.inMinutes < 60) {
      return 'Il y a ${diff.inMinutes} min';
    } else if (diff.inHours < 24) {
      return 'Il y a ${diff.inHours}h';
    } else {
      return 'Il y a ${diff.inDays}j';
    }
  }
}

/// Ligne d'information dans le dialogue
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
