// lib/providers/alert_provider.dart

import 'package:flutter/foundation.dart';
import '../models/alert.dart';
import '../models/alert_type.dart';
import '../models/alert_category.dart';
import '../models/animal.dart';
import '../models/treatment.dart';
import '../models/weight_record.dart';
import '../models/weighing_rule.dart';
import '../models/incomplete_event.dart';
import '../models/sync_status.dart';
import 'animal_provider.dart';
import 'weight_provider.dart';
import 'sync_provider.dart';
import '../data/mock_alerts_generator.dart'; // 🆕 MOCK TEMPORAIRE

/// Provider de gestion des alertes métier
///
/// Calcule automatiquement toutes les alertes en écoutant :
/// - AnimalProvider (animaux, traitements, mouvements)
/// - WeightProvider (pesées)
/// - SyncProvider (synchronisation)
///
/// Hiérarchise par priorité et fournit les alertes au UI.
class AlertProvider extends ChangeNotifier {
  final AnimalProvider _animalProvider;
  final WeightProvider _weightProvider;
  final SyncProvider _syncProvider;

  /// Liste de toutes les alertes calculées
  List<Alert> _alerts = [];

  /// Liste des événements incomplets
  List<IncompleteEvent> _incompleteEvents = [];

  /// Configuration : Délai max de sync (jours)
  int _maxSyncDelayDays = 7;

  /// Configuration : Tolérance pesée par défaut (jours)
  int _weighingToleranceDays = 7;

  AlertProvider({
    required AnimalProvider animalProvider,
    required WeightProvider weightProvider,
    required SyncProvider syncProvider,
  })  : _animalProvider = animalProvider,
        _weightProvider = weightProvider,
        _syncProvider = syncProvider {
    // Écouter les changements des providers
    _animalProvider.addListener(_recalculateAlerts);
    _weightProvider.addListener(_recalculateAlerts);
    _syncProvider.addListener(_recalculateAlerts);

    // Calcul initial
    _recalculateAlerts();
  }

  @override
  void dispose() {
    _animalProvider.removeListener(_recalculateAlerts);
    _weightProvider.removeListener(_recalculateAlerts);
    _syncProvider.removeListener(_recalculateAlerts);
    super.dispose();
  }

  // ==================== GETTERS ====================

  /// Toutes les alertes (triées par priorité)
  List<Alert> get alerts => List.unmodifiable(_alerts);

  /// Alertes URGENTES uniquement (bannière rouge)
  List<Alert> get urgentAlerts =>
      _alerts.where((a) => a.type == AlertType.urgent).toList();

  /// Alertes IMPORTANTES
  List<Alert> get importantAlerts =>
      _alerts.where((a) => a.type == AlertType.important).toList();

  /// Tâches ROUTINE
  List<Alert> get routineAlerts =>
      _alerts.where((a) => a.type == AlertType.routine).toList();

  /// Nombre total d'alertes
  int get alertCount => _alerts.length;

  /// Nombre d'alertes urgentes
  int get urgentAlertCount => urgentAlerts.length;

  /// Nombre d'alertes importantes
  int get importantAlertCount => importantAlerts.length;

  /// A des alertes urgentes ?
  bool get hasUrgentAlerts => urgentAlerts.isNotEmpty;

  /// Événements incomplets
  List<IncompleteEvent> get incompleteEvents =>
      List.unmodifiable(_incompleteEvents);

  // ==================== CONFIGURATION ====================

  /// Définir le délai max de sync
  void setMaxSyncDelayDays(int days) {
    if (days < 1) return;
    if (days > 30) return; // Max 30 jours
    _maxSyncDelayDays = days;
    _recalculateAlerts();
  }

  /// Définir la tolérance pesée
  void setWeighingToleranceDays(int days) {
    if (days < 1) return;
    _weighingToleranceDays = days;
    _recalculateAlerts();
  }

  // ==================== CALCUL ALERTES ====================

  /// Recalculer toutes les alertes
  void _recalculateAlerts() {
    final newAlerts = <Alert>[];

    // 1. Alertes de rémanence
    newAlerts.addAll(_calculateRemanenceAlerts());

    // 2. Alertes d'identification
    newAlerts.addAll(_calculateIdentificationAlerts());

    // 3. Alertes de synchronisation
    final syncAlert = _calculateSyncAlert();
    if (syncAlert != null) newAlerts.add(syncAlert);

    // 4. Tâches de pesée
    newAlerts.addAll(_calculateWeighingTasks());

    // 5. Événements incomplets
    _incompleteEvents = _calculateIncompleteEvents();
    newAlerts.addAll(_incompleteEvents
        .where((e) => e.needsAlert)
        .map((e) => Alert.incompleteEvent(
              eventId: e.id,
              eventType: e.type.labelFr,
              description: e.entityName,
              daysOld: e.daysOld,
            )));

    // 6. Traitements à renouveler
    newAlerts.addAll(_calculateTreatmentRenewals());

    // 🆕 MOCK TEMPORAIRE : Ajouter des alertes de test
    final animalIds = _animalProvider.animals.map((a) => a.id).toList();
    if (animalIds.length >= 5) {
      MockAlertsGenerator.addMockAlertsToProvider(newAlerts, animalIds);
    }

    // Trier par priorité (urgent > important > routine)
    newAlerts.sort((a, b) => a.type.priority.compareTo(b.type.priority));

    _alerts = newAlerts;
    notifyListeners();

    debugPrint('🔔 Alertes recalculées : ${_alerts.length} alertes');
    debugPrint('   🚨 Urgent: ${urgentAlertCount}');
    debugPrint('   ⚠️ Important: ${importantAlertCount}');
    debugPrint('   📋 Routine: ${routineAlerts.length}');
  }

  /// Calculer alertes de rémanence
  List<Alert> _calculateRemanenceAlerts() {
    final alerts = <Alert>[];
    final animals = _animalProvider.animals
        .where((a) => a.status == AnimalStatus.alive)
        .toList();

    for (final animal in animals) {
      final treatments = _animalProvider.getAnimalTreatments(animal.id);

      for (final treatment in treatments) {
        if (!treatment.isWithdrawalActive) continue;

        final daysRemaining = treatment.daysUntilWithdrawalEnd;

        // Créer alerte si < 7 jours
        if (daysRemaining < 7) {
          alerts.add(Alert.remanence(
            animalId: animal.id,
            animalName: animal.officialNumber ?? animal.eid,
            daysRemaining: daysRemaining,
            treatmentName: treatment.productName ?? 'Traitement',
          ));
        }
      }
    }

    return alerts;
  }

  /// Calculer alertes d'identification manquante
  List<Alert> _calculateIdentificationAlerts() {
    final alerts = <Alert>[];
    final animals = _animalProvider.animals
        .where((a) => a.status == AnimalStatus.alive)
        .toList();

    for (final animal in animals) {
      // Vérifier si EID manquant ou invalide
      if (animal.eid.isEmpty ||
          animal.eid.length < 10 ||
          animal.eid.startsWith('TEMP_')) {
        alerts.add(Alert.missingIdentification(
          animalId: animal.id,
          animalName:
              animal.officialNumber ?? 'Animal ${animal.id.substring(0, 8)}',
          ageInDays: animal.ageInDays,
        ));
      }
    }

    return alerts;
  }

  /// Calculer alerte de synchronisation
  /// Calculer alerte de synchronisation
  Alert? _calculateSyncAlert() {
    // Si sync en cours, pas d'alerte
    if (_syncProvider.isSyncing) return null;

    // Calculer jours depuis dernière sync
    final daysSinceLastSync = _syncProvider.lastSyncDate != null
        ? DateTime.now().difference(_syncProvider.lastSyncDate!).inDays
        : 999;

    // Nombre d'éléments en attente
    final pendingItems = _syncProvider.pendingDataCount;

    // Si sync nécessaire ou critique
    final needsSync =
        daysSinceLastSync > _maxSyncDelayDays || pendingItems > 10;

    if (needsSync) {
      return Alert.syncRequired(
        daysSinceLastSync: daysSinceLastSync,
        pendingItems: pendingItems,
      );
    }

    return null;
  }

  /// Calculer tâches de pesée
  List<Alert> _calculateWeighingTasks() {
    final alerts = <Alert>[];
    final animals = _animalProvider.animals
        .where((a) => a.status == AnimalStatus.alive)
        .toList();

    // Grouper par raison de pesée
    final animalsByReason = <String, List<String>>{};

    for (final animal in animals) {
      // Récupérer les règles pour cette espèce
      final rules = WeighingRulesConfig.getRulesForSpecies(
        animal.speciesId ?? 'ovine',
      );

      // Obtenir la dernière pesée
      final weights = _weightProvider.weights
          .where((w) => w.animalId == animal.id)
          .toList();
      weights.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
      final lastWeight = weights.isNotEmpty ? weights.first : null;

      // Calculer la prochaine pesée attendue
      for (final rule in rules) {
        if (rule.ageInDays != null) {
          // Règle à âge précis
          final targetAge = rule.ageInDays!;
          final currentAge = animal.ageInDays;

          // Animal a-t-il atteint cet âge ?
          if (currentAge >= targetAge) {
            // A-t-il été pesé à cet âge ?
            final hasWeightAtAge = weights.any((w) {
              final weightAge =
                  animal.birthDate.difference(w.recordedAt).inDays.abs();
              return (weightAge - targetAge).abs() <= rule.toleranceDays;
            });

            if (!hasWeightAtAge) {
              final delay = currentAge - targetAge;
              if (delay <= _weighingToleranceDays) {
                final reason = rule.label;
                animalsByReason.putIfAbsent(reason, () => []);
                animalsByReason[reason]!.add(animal.id);
              }
            }
          }
        } else if (rule.recurringDays != null && lastWeight != null) {
          // Règle récurrente
          final daysSinceLastWeight =
              DateTime.now().difference(lastWeight.recordedAt).inDays;

          if (daysSinceLastWeight >= rule.recurringDays!) {
            final reason = rule.label;
            animalsByReason.putIfAbsent(reason, () => []);
            animalsByReason[reason]!.add(animal.id);
          }
        }
      }
    }

    // Créer une alerte par groupe
    animalsByReason.forEach((reason, animalIds) {
      if (animalIds.isNotEmpty) {
        alerts.add(Alert.weighingRequired(
          animalIds: animalIds,
          reason: reason,
        ));
      }
    });

    return alerts;
  }

  /// Calculer événements incomplets
  List<IncompleteEvent> _calculateIncompleteEvents() {
    final events = <IncompleteEvent>[];

    // Vérifier les animaux incomplets
    for (final animal in _animalProvider.animals) {
      final missingFields = <String>[];
      var completionRate = 1.0;

      // Champs critiques manquants
      if (animal.birthDate == null) {
        missingFields.add('Date de naissance');
        completionRate -= 0.2;
      }

      if (animal.sex == null) {
        missingFields.add('Sexe');
        completionRate -= 0.1;
      }

      if (animal.speciesId == null || animal.speciesId!.isEmpty) {
        missingFields.add('Type');
        completionRate -= 0.3;
      }

      if (animal.eid.isEmpty || animal.eid.length < 10) {
        missingFields.add('EID valide');
        completionRate -= 0.4;
      }

      // Si des champs manquent, créer un événement incomplet
      if (missingFields.isNotEmpty && completionRate < 0.9) {
        events.add(IncompleteEvent.animal(
          animalId: animal.id,
          animalName: animal.officialNumber ?? animal.eid,
          missingFields: missingFields,
          completionRate: completionRate,
          createdAt: animal.createdAt,
        ));
      }
    }

    return events;
  }

  /// Calculer traitements à renouveler
  List<Alert> _calculateTreatmentRenewals() {
    final alerts = <Alert>[];
    // TODO: Implémenter la logique de renouvellement
    // Pour l'instant, retour vide
    return alerts;
  }

  // ==================== FILTRES ====================

  /// Filtrer alertes par catégorie
  List<Alert> getAlertsByCategory(AlertCategory category) {
    return _alerts.where((a) => a.category == category).toList();
  }

  /// Filtrer alertes par type
  List<Alert> getAlertsByType(AlertType type) {
    return _alerts.where((a) => a.type == type).toList();
  }

  /// Obtenir alertes pour un animal spécifique
  List<Alert> getAlertsForAnimal(String animalId) {
    return _alerts.where((a) => a.entityId == animalId).toList();
  }

  // ==================== STATS ====================

  /// Statistiques par catégorie
  Map<AlertCategory, int> getAlertCountsByCategory() {
    final counts = <AlertCategory, int>{};
    for (final alert in _alerts) {
      counts[alert.category] = (counts[alert.category] ?? 0) + 1;
    }
    return counts;
  }

  /// Statistiques par type
  Map<AlertType, int> getAlertCountsByType() {
    return {
      AlertType.urgent: urgentAlertCount,
      AlertType.important: importantAlertCount,
      AlertType.routine: routineAlerts.length,
    };
  }

  // ==================== ACTIONS ====================

  /// Marquer une alerte comme lue (future feature)
  void markAlertAsRead(String alertId) {
    // TODO: Implémenter persistance
    notifyListeners();
  }

  /// Effacer une alerte (temporaire, sera recalculée)
  void dismissAlert(String alertId) {
    _alerts.removeWhere((a) => a.id == alertId);
    notifyListeners();
  }

  /// Forcer le recalcul
  void refresh() {
    _recalculateAlerts();
  }

  // ==================== HELPERS ====================

  /// Message de résumé pour l'utilisateur
  String getSummary() {
    if (_alerts.isEmpty) {
      return 'Aucune alerte 🎉';
    }

    final urgent = urgentAlertCount;
    final important = importantAlertCount;
    final routine = routineAlerts.length;

    final parts = <String>[];
    if (urgent > 0) parts.add('$urgent urgente${urgent > 1 ? 's' : ''}');
    if (important > 0) {
      parts.add('$important importante${important > 1 ? 's' : ''}');
    }
    if (routine > 0) parts.add('$routine tâche${routine > 1 ? 's' : ''}');

    return parts.join(', ');
  }

  /// Message pour la bannière rouge
  String? getUrgentBannerMessage() {
    if (!hasUrgentAlerts) return null;

    final count = urgentAlertCount;
    if (count == 1) {
      return '🚨 ${urgentAlerts.first.title}';
    }
    return '🚨 $count ALERTES URGENTES';
  }
}
