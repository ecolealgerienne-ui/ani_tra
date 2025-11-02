// lib/models/sync/syncable_entity.dart

/// Interface pour toutes les entités synchronisables (offline-first)
///
/// Cette interface définit les champs minimaux nécessaires pour
/// gérer la synchronisation bidirectionnelle avec un serveur.
abstract class SyncableEntity {
  /// ID unique de l'entité
  String get id;

  /// Date de création de l'entité
  DateTime get createdAt;

  /// Date de dernière modification locale
  DateTime get updatedAt;

  /// L'entité est-elle synchronisée avec le serveur ?
  bool get synced;

  /// Date de la dernière synchronisation réussie
  /// null = jamais synchronisé
  DateTime? get lastSyncedAt;

  /// Version du serveur (pour résolution de conflits)
  /// Format recommandé: timestamp ou hash
  /// null = créé localement, pas encore sur serveur
  String? get serverVersion;

  /// ID de la ferme (pour filtrage multi-ferme)
  String get farmId;
}

/// Extension avec méthodes utilitaires
extension SyncableEntityExtension on SyncableEntity {
  /// L'entité a été modifiée depuis la dernière sync ?
  bool get isDirty {
    if (lastSyncedAt == null) return true;
    return updatedAt.isAfter(lastSyncedAt!);
  }

  /// Nombre de jours depuis la dernière sync
  int? get daysSinceLastSync {
    if (lastSyncedAt == null) return null;
    return DateTime.now().difference(lastSyncedAt!).inDays;
  }

  /// Jamais synchronisé avec le serveur ?
  bool get neverSynced => lastSyncedAt == null;

  /// En attente de synchronisation ?
  bool get pendingSync => !synced || isDirty;

  /// Peut être synchronisé maintenant ?
  bool get canSync => pendingSync && serverVersion != null;
}
