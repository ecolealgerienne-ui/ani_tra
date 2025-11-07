// lib/providers/alert_provider.dart

import 'package:flutter/foundation.dart';
import '../models/alert.dart';
import '../models/alert_type.dart';
import '../models/alert_category.dart';
import '../models/animal.dart';

import '../models/weighing_rule.dart';
import '../models/incomplete_event.dart';

import 'animal_provider.dart';
import 'weight_provider.dart';
import 'sync_provider.dart';
import 'vaccination_provider.dart';
import '../data/mock_alerts_generator.dart'; // Ã°Å¸â€ â€¢ MOCK TEMPORAIRE

/// Provider de gestion des alertes mÃƒÂ©tier
///
/// Calcule automatiquement toutes les alertes en ÃƒÂ©coutant :
/// - AnimalProvider (animaux, traitements, mouvements)
/// - WeightProvider (pesÃƒÂ©es)
/// - SyncProvider (synchronisation)
///
/// HiÃƒÂ©rarchise par prioritÃƒÂ© et fournit les alertes au UI.
class AlertProvider extends ChangeNotifier {
  final AnimalProvider _animalProvider;
  final WeightProvider _weightProvider;
  final SyncProvider _syncProvider;
  final VaccinationProvider _vaccinationProvider;

  /// Liste de toutes les alertes calculÃƒÂ©es
  List<Alert> _alerts = [];

  /// Liste des ÃƒÂ©vÃƒÂ©nements incomplets
  List<IncompleteEvent> _incompleteEvents = [];

  /// Configuration : DÃƒÂ©lai max de sync (jours)
  int _maxSyncDelayDays = 7;

  /// Configuration : TolÃƒÂ©rance pesÃƒÂ©e par dÃƒÂ©faut (jours)
  int _weighingToleranceDays = 7;

  AlertProvider({
    required AnimalProvider animalProvider,
    required WeightProvider weightProvider,
    required SyncProvider syncProvider,
    required VaccinationProvider vaccinationProvider,
  })  : _animalProvider = animalProvider,
        _weightProvider = weightProvider,
        _syncProvider = syncProvider,
        _vaccinationProvider = vaccinationProvider {
    // Ãƒâ€°couter les changements des providers
    _animalProvider.addListener(_recalculateAlerts);
    _weightProvider.addListener(_recalculateAlerts);
    _syncProvider.addListener(_recalculateAlerts);
    _vaccinationProvider.addListener(_recalculateAlerts);

    // Calcul initial
    _recalculateAlerts();
  }

  @override
  void dispose() {
    _animalProvider.removeListener(_recalculateAlerts);
    _weightProvider.removeListener(_recalculateAlerts);
    _syncProvider.removeListener(_recalculateAlerts);
    _vaccinationProvider.removeListener(_recalculateAlerts);
    super.dispose();
  }

  // ==================== GETTERS ====================

  /// Toutes les alertes (triÃƒÂ©es par prioritÃƒÂ©)
  List<Alert> get alerts => List.unmodifiable(_alerts);

  /// Alertes URGENTES uniquement (banniÃƒÂ¨re rouge)
  List<Alert> get urgentAlerts =>
      _alerts.where((a) => a.type == AlertType.urgent).toList();

  /// Alertes IMPORTANTES
  List<Alert> get importantAlerts =>
      _alerts.where((a) => a.type == AlertType.important).toList();

  /// TÃƒÂ¢ches ROUTINE
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

  /// Ãƒâ€°vÃƒÂ©nements incomplets
  List<IncompleteEvent> get incompleteEvents =>
      List.unmodifiable(_incompleteEvents);

  // ==================== CONFIGURATION ====================

  /// DÃƒÂ©finir le dÃƒÂ©lai max de sync
  void setMaxSyncDelayDays(int days) {
    if (days < 1) return;
    if (days > 30) return; // Max 30 jours
    _maxSyncDelayDays = days;
    _recalculateAlerts();
  }

  /// DÃƒÂ©finir la tolÃƒÂ©rance pesÃƒÂ©e
  void setWeighingToleranceDays(int days) {
    if (days < 1) return;
    _weighingToleranceDays = days;
    _recalculateAlerts();
  }

  // ==================== CALCUL ALERTES ====================

  /// Recalculer toutes les alertes
  void _recalculateAlerts() {
    final newAlerts = <Alert>[];

    // 1. Alertes de rÃƒÂ©manence
    newAlerts.addAll(_calculateRemanenceAlerts());

    // 2. Alertes d'identification
    newAlerts.addAll(_calculateIdentificationAlerts());

    // 3. Alertes de synchronisation
    final syncAlert = _calculateSyncAlert();
    if (syncAlert != null) newAlerts.add(syncAlert);

    // 4. TÃƒÂ¢ches de pesÃƒÂ©e
    newAlerts.addAll(_calculateWeighingTasks());

    // 5. Ãƒâ€°vÃƒÂ©nements incomplets
    _incompleteEvents = _calculateIncompleteEvents();
    newAlerts.addAll(_incompleteEvents
        .where((e) => e.needsAlert)
        .map((e) => Alert.incompleteEvent(
              eventId: e.id,
              eventType: e.type.labelFr,
              description: e.entityName,
              daysOld: e.daysOld,
            )));

    // 6. Traitements ÃƒÂ  renouveler
    newAlerts.addAll(_calculateTreatmentRenewals());
    // 7. Vaccinations (rappels et retards)
    newAlerts.addAll(_calculateVaccinationAlerts());

    // Ã°Å¸â€ â€¢ MOCK TEMPORAIRE : Ajouter des alertes de test
    final animalIds = _animalProvider.animals.map((a) => a.id).toList();
    if (animalIds.length >= 5) {
      MockAlertsGenerator.addMockAlertsToProvider(newAlerts, animalIds);
    }

    // Trier par prioritÃƒÂ© (urgent > important > routine)
    newAlerts.sort((a, b) => a.type.priority.compareTo(b.type.priority));

    _alerts = newAlerts;
    notifyListeners();

    debugPrint('Ã°Å¸â€â€ Alertes recalculÃƒÂ©es : ${_alerts.length} alertes');
    debugPrint('   Ã°Å¸Å¡Â¨ Urgent: $urgentAlertCount');
    debugPrint('   Ã¢Å¡Â Ã¯Â¸Â Important: $importantAlertCount');
    debugPrint('   Ã°Å¸â€œâ€¹ Routine: ${routineAlerts.length}');
  }

  /// Calculer alertes de rÃƒÂ©manence
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

        // CrÃƒÂ©er alerte si < 7 jours
        if (daysRemaining < 7) {
          alerts.add(Alert.remanence(
            animalId: animal.id,
            animalName: animal.officialNumber ??
                animal.displayName ??
                animal.visualId ??
                'Animal ${animal.id.substring(0, 8)}',
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
      // VÃƒÂ©rifier si EID manquant ou invalide
      if (animal.displayName.isEmpty ||
          animal.displayName.length < 10 ||
          animal.displayName.startsWith('TEMP_')) {
        alerts.add(Alert.missingIdentification(
          animalId: animal.id,
          animalName: animal.officialNumber ??
              animal.visualId ??
              'Animal ${animal.id.substring(0, 8)}',
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

    // Calculer jours depuis derniÃƒÂ¨re sync
    final daysSinceLastSync = _syncProvider.lastSyncDate != null
        ? DateTime.now().difference(_syncProvider.lastSyncDate!).inDays
        : 999;

    // Nombre d'ÃƒÂ©lÃƒÂ©ments en attente
    final pendingItems = _syncProvider.pendingDataCount;

    // Si sync nÃƒÂ©cessaire ou critique
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

  /// Calculer tÃƒÂ¢ches de pesÃƒÂ©e
  List<Alert> _calculateWeighingTasks() {
    final alerts = <Alert>[];
    final animals = _animalProvider.animals
        .where((a) => a.status == AnimalStatus.alive)
        .toList();

    // Grouper par raison de pesÃƒÂ©e
    final animalsByReason = <String, List<String>>{};

    for (final animal in animals) {
      // RÃƒÂ©cupÃƒÂ©rer les rÃƒÂ¨gles pour cette espÃƒÂ¨ce
      final rules = WeighingRulesConfig.getRulesForSpecies(
        animal.speciesId ?? 'ovine',
      );

      // Obtenir la derniÃƒÂ¨re pesÃƒÂ©e
      final weights = _weightProvider.weights
          .where((w) => w.animalId == animal.id)
          .toList();
      weights.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
      final lastWeight = weights.isNotEmpty ? weights.first : null;

      // Calculer la prochaine pesÃƒÂ©e attendue
      for (final rule in rules) {
        if (rule.ageInDays != null) {
          // RÃƒÂ¨gle ÃƒÂ  ÃƒÂ¢ge prÃƒÂ©cis
          final targetAge = rule.ageInDays!;
          final currentAge = animal.ageInDays;

          // Animal a-t-il atteint cet ÃƒÂ¢ge ?
          if (currentAge >= targetAge) {
            // A-t-il ÃƒÂ©tÃƒÂ© pesÃƒÂ© ÃƒÂ  cet ÃƒÂ¢ge ?
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
          // RÃƒÂ¨gle rÃƒÂ©currente
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

    // CrÃƒÂ©er une alerte par groupe
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

  /// Calculer ÃƒÂ©vÃƒÂ©nements incomplets
  List<IncompleteEvent> _calculateIncompleteEvents() {
    final events = <IncompleteEvent>[];

    // VÃƒÂ©rifier les animaux incomplets
    for (final animal in _animalProvider.animals) {
      final missingFields = <String>[];
      var completionRate = 1.0;

      if (animal.speciesId == null || animal.speciesId!.isEmpty) {
        missingFields.add('Type');
        completionRate -= 0.3;
      }

      if (animal.displayName.isEmpty ||
          animal.displayName.length < 10) {
        missingFields.add('EID valide');
        completionRate -= 0.4;
      }

      // Si des champs manquent, crÃƒÂ©er un ÃƒÂ©vÃƒÂ©nement incomplet
      if (missingFields.isNotEmpty && completionRate < 0.9) {
        events.add(IncompleteEvent.animal(
          animalId: animal.id,
          animalName: animal.officialNumber ??
              animal.displayName ??
              animal.visualId ??
              'Animal ${animal.id.substring(0, 8)}' ??
              animal.visualId ??
              'Animal ${animal.id.substring(0, 8)}',
          missingFields: missingFields,
          completionRate: completionRate,
          createdAt: animal.createdAt,
        ));
      }
    }

    return events;
  }

  /// Calculer traitements ÃƒÂ  renouveler
  List<Alert> _calculateTreatmentRenewals() {
    final alerts = <Alert>[];
    // TODO: ImplÃƒÂ©menter la logique de renouvellement
    // Pour l'instant, retour vide
    return alerts;
  }

  // ==================== FILTRES ====================

  /// Filtrer alertes par catÃƒÂ©gorie
  List<Alert> getAlertsByCategory(AlertCategory category) {
    return _alerts.where((a) => a.category == category).toList();
  }

  /// Filtrer alertes par type
  List<Alert> getAlertsByType(AlertType type) {
    return _alerts.where((a) => a.type == type).toList();
  }

  /// Obtenir alertes pour un animal spÃƒÂ©cifique
  List<Alert> getAlertsForAnimal(String animalId) {
    return _alerts.where((a) => a.entityId == animalId).toList();
  }

  // ==================== STATS ====================

  /// Statistiques par catÃƒÂ©gorie
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
    // TODO: ImplÃƒÂ©menter persistance
    notifyListeners();
  }

  /// Effacer une alerte (temporaire, sera recalculÃƒÂ©e)
  void dismissAlert(String alertId) {
    _alerts.removeWhere((a) => a.id == alertId);
    notifyListeners();
  }

  /// Forcer le recalcul
  void refresh() {
    _recalculateAlerts();
  }

  // ==================== HELPERS ====================
  /// Calculer alertes de vaccinations
  List<Alert> _calculateVaccinationAlerts() {
    final alerts = <Alert>[];
    final vaccinations = _vaccinationProvider.getVaccinationsWithRemindersDue();

    for (final vaccination in vaccinations) {
      if (vaccination.nextDueDate != null) {
        final daysUntil = vaccination.daysUntilReminder!;

        // Déterminer la priorité selon le délai
        final type = daysUntil < 0
            ? AlertType.urgent
            : daysUntil < 7
                ? AlertType.important
                : AlertType.routine;

        // Nom de l'animal ou groupe
        String entityName;
        if (vaccination.isGroupVaccination) {
          entityName = '${vaccination.animalCount} animaux';
        } else {
          entityName = vaccination.animalId ?? 'Animal';
        }

        alerts.add(Alert(
          id: 'vaccination_reminder_${vaccination.id}',
          type: type,
          category: AlertCategory.treatment,
          title: 'Rappel vaccination ${vaccination.disease}',
          message: daysUntil < 0
              ? 'Rappel en retard de ${-daysUntil} jours - $entityName'
              : 'Rappel dans $daysUntil jours - $entityName',
          entityId: vaccination.animalId,
          animalIds:
              vaccination.isGroupVaccination ? vaccination.animalIds : null,
          actionLabel: 'Vacciner',
          dueDate: vaccination.nextDueDate,
        ));
      }
    }

    return alerts;
  }

  /// Message de rÃƒÂ©sumÃƒÂ© pour l'utilisateur
  String getSummary() {
    if (_alerts.isEmpty) {
      return 'Aucune alerte Ã°Å¸Å½â€°';
    }

    final urgent = urgentAlertCount;
    final important = importantAlertCount;
    final routine = routineAlerts.length;

    final parts = <String>[];
    if (urgent > 0) parts.add('$urgent urgente${urgent > 1 ? 's' : ''}');
    if (important > 0) {
      parts.add('$important importante${important > 1 ? 's' : ''}');
    }
    if (routine > 0) parts.add('$routine tÃƒÂ¢che${routine > 1 ? 's' : ''}');

    return parts.join(', ');
  }

  /// Message pour la banniÃƒÂ¨re rouge
  String? getUrgentBannerMessage() {
    if (!hasUrgentAlerts) return null;

    final count = urgentAlertCount;
    if (count == 1) {
      return 'Ã°Å¸Å¡Â¨ ${urgentAlerts.first.title}';
    }
    return 'Ã°Å¸Å¡Â¨ $count ALERTES URGENTES';
  }
}
