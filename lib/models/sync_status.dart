// lib/models/sync_status.dart

/// Santé de la synchronisation
enum SyncHealth {
  /// ✅ Sync OK (< 3 jours)
  ok,

  /// ⚠️ Sync recommandée (3-7 jours)
  warning,

  /// 🚨 Sync critique (> 7 jours)
  critical,
}

/// Extension pour les propriétés visuelles
extension SyncHealthExtension on SyncHealth {
  /// Icône selon la santé
  String get icon {
    switch (this) {
      case SyncHealth.ok:
        return '☁️';
      case SyncHealth.warning:
        return '⚠️';
      case SyncHealth.critical:
        return '🚨';
    }
  }

  /// Couleur (hex string)
  String get colorHex {
    switch (this) {
      case SyncHealth.ok:
        return '#4CAF50'; // Vert
      case SyncHealth.warning:
        return '#FF9800'; // Orange
      case SyncHealth.critical:
        return '#F44336'; // Rouge
    }
  }

  /// Label en français
  String get labelFr {
    switch (this) {
      case SyncHealth.ok:
        return 'À jour';
      case SyncHealth.warning:
        return 'Sync recommandée';
      case SyncHealth.critical:
        return 'Sync critique';
    }
  }
}

/// Statut de synchronisation de l'application
///
/// Gère :
/// - Dernière sync
/// - Éléments en attente
/// - Calcul de la santé (OK/WARNING/CRITICAL)
/// - Alertes selon le délai
class SyncStatus {
  /// Date de la dernière synchronisation réussie
  final DateTime? lastSyncAt;

  /// Nombre d'éléments en attente de sync
  final int pendingItems;

  /// Sync en cours actuellement
  final bool isSyncing;

  /// Dernière erreur de sync (si échec)
  final String? lastError;

  /// Délai maximum autorisé (en jours) - Configurable
  /// Par défaut : 7 jours (limite max)
  final int maxDelayDays;

  SyncStatus({
    this.lastSyncAt,
    this.pendingItems = 0,
    this.isSyncing = false,
    this.lastError,
    this.maxDelayDays = 7,
  });

  /// Nombre de jours depuis la dernière sync
  int get daysSinceLastSync {
    if (lastSyncAt == null) return 999; // Jamais synchronisé
    final diff = DateTime.now().difference(lastSyncAt!);
    return diff.inDays;
  }

  /// Heures depuis la dernière sync (pour affichage)
  int get hoursSinceLastSync {
    if (lastSyncAt == null) return 999;
    final diff = DateTime.now().difference(lastSyncAt!);
    return diff.inHours;
  }

  /// Santé de la sync
  SyncHealth get health {
    if (daysSinceLastSync <= 3) {
      return SyncHealth.ok;
    } else if (daysSinceLastSync <= maxDelayDays) {
      return SyncHealth.warning;
    } else {
      return SyncHealth.critical;
    }
  }

  /// Sync est nécessaire
  bool get needsSync {
    return daysSinceLastSync >= maxDelayDays || pendingItems > 0;
  }

  /// Sync est URGENTE (dépassement du délai max)
  bool get isUrgent {
    return daysSinceLastSync > maxDelayDays;
  }

  /// Sync est CRITIQUE (dépassement + 7 jours de grâce)
  bool get isCritical {
    return daysSinceLastSync > (maxDelayDays + 7);
  }

  /// Message d'état pour l'utilisateur
  String get statusMessage {
    if (isSyncing) {
      return 'Synchronisation en cours...';
    }

    if (lastSyncAt == null) {
      return 'Jamais synchronisé';
    }

    if (daysSinceLastSync == 0) {
      if (hoursSinceLastSync == 0) {
        return 'Synchronisé à l\'instant';
      }
      return 'Synchronisé il y a ${hoursSinceLastSync}h';
    }

    if (daysSinceLastSync == 1) {
      return 'Synchronisé hier';
    }

    return 'Synchronisé il y a ${daysSinceLastSync}j';
  }

  /// Message court pour le header (ex: "J-2")
  String get shortMessage {
    if (isSyncing) return 'Sync...';
    if (lastSyncAt == null) return 'Jamais';

    if (daysSinceLastSync == 0) {
      return 'Maintenant';
    }

    return 'J-$daysSinceLastSync';
  }

  /// Message de conseil pour l'utilisateur
  String? get adviceMessage {
    if (isCritical) {
      return '🚨 Synchronisation critique ! Risque de perte de données. Connectez-vous immédiatement.';
    }

    if (isUrgent) {
      return '⚠️ Synchronisation requise. Connectez-vous dès que possible (délai max dépassé).';
    }

    if (health == SyncHealth.warning) {
      return '⚠️ Synchronisation recommandée pour sécuriser vos données.';
    }

    if (pendingItems > 10) {
      return '📊 $pendingItems modifications en attente de sauvegarde.';
    }

    return null;
  }

  /// Copie avec modifications
  SyncStatus copyWith({
    DateTime? lastSyncAt,
    int? pendingItems,
    bool? isSyncing,
    String? lastError,
    int? maxDelayDays,
  }) {
    return SyncStatus(
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      pendingItems: pendingItems ?? this.pendingItems,
      isSyncing: isSyncing ?? this.isSyncing,
      lastError: lastError ?? this.lastError,
      maxDelayDays: maxDelayDays ?? this.maxDelayDays,
    );
  }

  /// Statut par défaut (jamais synchronisé)
  factory SyncStatus.initial() {
    return SyncStatus(
      lastSyncAt: null,
      pendingItems: 0,
      isSyncing: false,
      maxDelayDays: 7,
    );
  }

  /// Statut après sync réussie
  SyncStatus afterSuccessfulSync() {
    return copyWith(
      lastSyncAt: DateTime.now(),
      pendingItems: 0,
      isSyncing: false,
      lastError: null,
    );
  }

  /// Statut après échec de sync
  SyncStatus afterFailedSync(String error) {
    return copyWith(
      isSyncing: false,
      lastError: error,
    );
  }

  /// Incrémenter les éléments en attente
  SyncStatus incrementPending() {
    return copyWith(pendingItems: pendingItems + 1);
  }

  /// Conversion en Map (pour persistance)
  Map<String, dynamic> toJson() {
    return {
      'lastSyncAt': lastSyncAt?.toIso8601String(),
      'pendingItems': pendingItems,
      'isSyncing': isSyncing,
      'lastError': lastError,
      'maxDelayDays': maxDelayDays,
    };
  }

  /// Création depuis Map
  factory SyncStatus.fromJson(Map<String, dynamic> json) {
    return SyncStatus(
      lastSyncAt: json['lastSyncAt'] != null
          ? DateTime.parse(json['lastSyncAt'])
          : null,
      pendingItems: json['pendingItems'] ?? 0,
      isSyncing: json['isSyncing'] ?? false,
      lastError: json['lastError'],
      maxDelayDays: json['maxDelayDays'] ?? 7,
    );
  }

  @override
  String toString() {
    return 'SyncStatus(lastSync: ${lastSyncAt?.toIso8601String() ?? 'never'}, pending: $pendingItems, health: ${health.name})';
  }
}
