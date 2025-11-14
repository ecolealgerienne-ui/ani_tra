// lib/providers/alert_provider.dart

import 'package:flutter/material.dart';
import '../models/alert.dart';
import '../models/alert_type.dart';
import '../models/alert_category.dart';
import '../models/alert_configuration.dart';
import '../models/animal.dart';

import '../models/incomplete_event.dart';

import 'animal_provider.dart';
import 'auth_provider.dart';
import 'weight_provider.dart';
import 'sync_provider.dart';
import 'vaccination_provider.dart';
import 'treatment_provider.dart';
import '../i18n/app_localizations.dart';
import '../i18n/app_strings.dart';
import '../utils/constants.dart';
import '../repositories/alert_configuration_repository.dart';

/// Provider de gestion des alertes métier
///
/// Phase 2: Config-driven via AlertConfigurationRepository
/// Calcule automatiquement toutes les alertes en écoutant :
/// - AuthProvider (changements de ferme)
/// - AnimalProvider (animaux, traitements, mouvements)
/// - WeightProvider (pesées)
/// - SyncProvider (synchronisation)
/// - VaccinationProvider (vaccinations)
/// - AlertConfigurationRepository (configurations BD)
///
/// Hiérarchise par priorité et fournit les alertes au UI.
///
/// ✅ PHASE 4 FIX: Filtrage DRAFT
/// - Les animaux DRAFT ne reçoivent QUE des alertes de brouillon
/// - Alertes métier (traitement, vaccination, etc.) exclues pour les DRAFT
class AlertProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  final AnimalProvider _animalProvider;
  final WeightProvider _weightProvider;
  final SyncProvider _syncProvider;
  final VaccinationProvider _vaccinationProvider;
  final TreatmentProvider _treatmentProvider;
  final AlertConfigurationRepository _alertConfigRepository;

  /// Liste de toutes les alertes calculées
  List<Alert> _alerts = [];

  /// Liste des événements incomplets
  List<IncompleteEvent> _incompleteEvents = [];

  /// Configuration : Délai max de sync (jours)
  int _maxSyncDelayDays = 7;

  /// Configuration : Tolérance pesée par défaut (jours)
  int _weighingToleranceDays = 7;

  /// FarmId courant (peut changer au runtime)
  String _currentFarmId;

  AlertProvider({
    required AuthProvider authProvider,
    required AnimalProvider animalProvider,
    required WeightProvider weightProvider,
    required SyncProvider syncProvider,
    required VaccinationProvider vaccinationProvider,
    required TreatmentProvider treatmentProvider,
    required AlertConfigurationRepository alertConfigRepository,
  })  : _authProvider = authProvider,
        _animalProvider = animalProvider,
        _weightProvider = weightProvider,
        _syncProvider = syncProvider,
        _vaccinationProvider = vaccinationProvider,
        _treatmentProvider = treatmentProvider,
        _alertConfigRepository = alertConfigRepository,
        _currentFarmId = authProvider.currentFarmId {
    // ✅ ÉCOUTER CHANGEMENTS FERME
    _authProvider.addListener(_onFarmChanged);

    // Écouter les changements des providers
    _animalProvider.addListener(_recalculateAlerts);
    _weightProvider.addListener(_recalculateAlerts);
    _syncProvider.addListener(_recalculateAlerts);
    _vaccinationProvider.addListener(_recalculateAlerts);
    _treatmentProvider.addListener(_recalculateAlerts);

    // Calcul initial
    _recalculateAlerts();
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onFarmChanged);
    _animalProvider.removeListener(_recalculateAlerts);
    _weightProvider.removeListener(_recalculateAlerts);
    _syncProvider.removeListener(_recalculateAlerts);
    _vaccinationProvider.removeListener(_recalculateAlerts);
    _treatmentProvider.removeListener(_recalculateAlerts);
    super.dispose();
  }

  // ==================== FARM CHANGE DETECTION ====================

  /// ✅ NOUVELLE MÉTHODE: Détecter changement de ferme depuis AuthProvider
  /// Pattern copié de AnimalProvider
  void _onFarmChanged() {
    if (_currentFarmId != _authProvider.currentFarmId) {
      debugPrint(
          '🔄 [ALERT] Farm changée: $_currentFarmId → ${_authProvider.currentFarmId}');
      _currentFarmId = _authProvider.currentFarmId;
      _alerts = [];
      _incompleteEvents = [];
      _recalculateAlerts();
    }
  }

  // ==================== SETTERS ====================

  /// Définir la ferme courante (à appeler au login/switch farm)
  /// ⚠️ NOTE: Normalement appelé automatiquement via _onFarmChanged()
  /// Garder pour backward compatibility et appels explicites
  Future<void> setCurrentFarm(String farmId) async {
    if (_currentFarmId == farmId) return;
    debugPrint('🔄 [ALERT] setCurrentFarm: $farmId');
    _currentFarmId = farmId;
    await _recalculateAlerts();
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

  // ==================== CALCUL ALERTES - PHASE 2 ====================

  /// Recalculer toutes les alertes
  /// Phase 2: Charge configurations depuis BD via AlertConfigurationRepository
  Future<void> _recalculateAlerts() async {
    if (_currentFarmId.isEmpty) {
      debugPrint('⚠️ [ALERT] _recalculateAlerts: farmId VIDE, skip');
      _alerts = [];
      notifyListeners();
      return;
    }

    try {
      await generateAlerts(_currentFarmId);
    } catch (e) {
      debugPrint('❌ Erreur calcul alertes: $e');
      _alerts = [];
      notifyListeners();
    }
  }

  /// Générer toutes les alertes pour une ferme (Phase 2 - Config-driven + DEBUG)
  Future<void> generateAlerts(String farmId) async {
    debugPrint('🔍 [ALERT DEBUG] generateAlerts START - farmId: $farmId');
    final newAlerts = <Alert>[];

    try {
      // Vérification 0: farmId vide?
      if (farmId.isEmpty) {
        debugPrint('⚠️ [ALERT] farmId est VIDE! Arrêt.');
        _alerts = [];
        notifyListeners();
        return;
      }

      // 1. Charger configurations activées depuis BD
      debugPrint('📦 [ALERT] Chargement configurations...');
      final configs = await _alertConfigRepository.getEnabled(farmId);
      debugPrint('✅ [ALERT] Configs trouvées: ${configs.length}');
      for (final c in configs) {
        debugPrint(
            '   - ${c.evaluationType}: ${c.titleKey} (enabled: ${c.enabled})');
      }

      if (configs.isEmpty) {
        debugPrint(
            '⚠️ [ALERT] AUCUNE configuration trouvée pour farmId: $farmId');
        debugPrint(
            '   → Vérifier si AlertConfigurationSeeds.seedDatabase() a été appelé');
      }

      // 2. Pour chaque configuration, évaluer le type
      for (final config in configs) {
        try {
          debugPrint('🔄 [ALERT] Évaluation: ${config.evaluationType}');

          switch (config.evaluationType) {
            case AlertEvaluationType.remanence:
              final remanenceAlerts = await _checkAndBuildRemanence(config);
              debugPrint('   ↳ Remanence: ${remanenceAlerts.length} alertes');
              newAlerts.addAll(remanenceAlerts);
              break;
            case AlertEvaluationType.weighing:
              final weighingAlerts = await _checkAndBuildWeighing(config);
              debugPrint('   ↳ Weighing: ${weighingAlerts.length} alertes');
              newAlerts.addAll(weighingAlerts);
              break;
            case AlertEvaluationType.vaccination:
              final vacAlerts = await _checkAndBuildVaccination(config);
              debugPrint('   ↳ Vaccination: ${vacAlerts.length} alertes');
              newAlerts.addAll(vacAlerts);
              break;
            case AlertEvaluationType.identification:
              final idAlerts = await _checkAndBuildIdentification(config);
              debugPrint('   ↳ Identification: ${idAlerts.length} alertes');
              newAlerts.addAll(idAlerts);
              break;
            case AlertEvaluationType.syncRequired:
              final syncAlert = await _checkAndBuildSyncRequired(config);
              if (syncAlert != null) {
                debugPrint('   ↳ Sync: 1 alerte');
                newAlerts.add(syncAlert);
              } else {
                debugPrint('   ↳ Sync: 0 alertes');
              }
              break;
            case AlertEvaluationType.treatmentRenewal:
              final treatAlerts = await _checkAndBuildTreatmentRenewal(config);
              debugPrint(
                  '   ↳ Treatment: ${treatAlerts.length} alertes (TODO)');
              newAlerts.addAll(treatAlerts);
              break;
            case AlertEvaluationType.batchToFinalize:
              final batchAlerts = await _checkAndBuildBatchToFinalize(config);
              debugPrint('   ↳ Batch: ${batchAlerts.length} alertes (TODO)');
              newAlerts.addAll(batchAlerts);
              break;
          }
        } catch (e) {
          debugPrint(
              '❌ [ALERT] Erreur évaluation ${config.evaluationType}: $e');
        }
      }

      // 3. ✅ PHASE 4 FIX: Alertes DRAFT (brouillons depuis > 48h)
      debugPrint('🔄 [ALERT] Calcul alertes brouillons (DRAFT)...');
      final draftAlerts = await _checkAndBuildDraftAlerts(null);
      debugPrint('   ↳ Brouillons: ${draftAlerts.length} alertes');
      newAlerts.addAll(draftAlerts);

      // 4. Événements incomplets (legacy support - brouillons)
      debugPrint('🔄 [ALERT] Calcul événements incomplets...');
      _incompleteEvents = _calculateIncompleteEvents();
      debugPrint('   ↳ Brouillons: ${_incompleteEvents.length}');
      newAlerts.addAll(_incompleteEvents
          .where((e) => e.needsAlert)
          .map((e) => Alert.incompleteEvent(
                eventId: e.id,
                eventType: e.type.labelFr,
                description: e.entityName,
                daysOld: e.daysOld,
              )));

      // 5. Trier par priorité
      newAlerts.sort((a, b) => a.type.priority.compareTo(b.type.priority));

      debugPrint('✅ [ALERT] TOTAL alertes générées: ${newAlerts.length}');
      for (final alert in newAlerts) {
        debugPrint(
            '   - ${alert.type.labelFr}: ${alert.title} (${alert.category.labelFr})');
      }

      _alerts = newAlerts;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ [ALERT] ERREUR CRITIQUE generateAlerts: $e');
      debugPrint('   Stack: ${StackTrace.current}');
      rethrow;
    }
  }

  // ==================== ÉVALUATIONS PAR TYPE (Phase 2) ====================

  /// ✅ PHASE 4 FIX - Évaluation DRAFT (Brouillons en alerte)
  /// Crée des alertes pour les animaux en brouillon depuis > 48h
  Future<List<Alert>> _checkAndBuildDraftAlerts(
    AlertConfiguration? config,
  ) async {
    final alerts = <Alert>[];
    final drafts = _animalProvider.animals
        .where((a) => a.status == AnimalStatus.draft)
        .toList();

    debugPrint('🔍 [DRAFT] Analyse ${drafts.length} brouillons');

    for (final animal in drafts) {
      final hoursSinceCreation =
          DateTime.now().difference(animal.createdAt).inHours;

      debugPrint(
          '   - ${animal.displayName}: $hoursSinceCreation heures en brouillon');

      // ✅ URGENT si > 7 jours (HARD LIMIT)
      if (hoursSinceCreation >= AppConstants.draftAlertLimitHours) {
        debugPrint(
            '     ⚠️ URGENT: Dépasse ${AppConstants.draftAlertLimitHours}h!');

        final daysOld = hoursSinceCreation ~/ 24;
        final alert = Alert(
          id: 'draft_critical_${animal.id}',
          type: AlertType.urgent,
          category: AlertCategory.registre,
          title: '🚨 URGENT: Brouillon depuis ${daysOld}j',
          message: '${_getAnimalDisplayName(animal)}: À valider ou supprimer!',
          entityId: animal.id,
          entityType: 'animal',
          entityName: _getAnimalDisplayName(animal),
          dueDate: animal.createdAt
              .add(const Duration(hours: AppConstants.draftAlertLimitHours)),
          actionLabel: 'Valider',
          animalIds: [animal.id],
          titleKey: config?.titleKey,
          messageKey: config?.messageKey,
          messageParams: {
            'animalName': _getAnimalDisplayName(animal),
            'days': daysOld.toString(),
            'hours': hoursSinceCreation.toString(),
          },
        );
        alerts.add(alert);
      }
      // ✅ IMPORTANT si > 48h
      else if (hoursSinceCreation >= AppConstants.draftAlertHours) {
        debugPrint(
            '     ⚠️ IMPORTANT: Dépasse ${AppConstants.draftAlertHours}h');

        final alert = Alert(
          id: 'draft_warning_${animal.id}',
          type: AlertType.important,
          category: AlertCategory.registre,
          title: '⚠️ Brouillon depuis ${hoursSinceCreation}h',
          message: '${_getAnimalDisplayName(animal)}: À valider ou supprimer',
          entityId: animal.id,
          entityType: 'animal',
          entityName: _getAnimalDisplayName(animal),
          dueDate: animal.createdAt
              .add(const Duration(hours: AppConstants.draftAlertHours)),
          actionLabel: 'Valider',
          animalIds: [animal.id],
          titleKey: config?.titleKey,
          messageKey: config?.messageKey,
          messageParams: {
            'animalName': _getAnimalDisplayName(animal),
            'hours': hoursSinceCreation.toString(),
          },
        );
        alerts.add(alert);
      }
    }

    return alerts;
  }

  /// Évaluation REMANENCE (Délai abattage)
  /// Cherche les animaux avec traitement actif et délai court
  /// ✅ PHASE 4 FIX: EXCLUDE DRAFT animals
  Future<List<Alert>> _checkAndBuildRemanence(
    AlertConfiguration config,
  ) async {
    final alerts = <Alert>[];

    // ✅ PHASE 2: Utiliser TreatmentProvider + constantes
    final treatmentsInWithdrawal =
        _treatmentProvider.getTreatmentsInWithdrawalPeriod();

    for (final treatment in treatmentsInWithdrawal) {
      final daysRemaining = treatment.daysUntilWithdrawalEnd;

      // ✅ PHASE 4 FIX: Récupérer l'animal et vérifier son statut
      final animal = _animalProvider.animals.firstWhere(
        (a) => a.id == treatment.animalId,
        orElse: () => Animal(
          id: 'unknown',
          farmId: _currentFarmId,
          currentEid: 'Unknown',
          visualId: 'Unknown',
          officialNumber: '',
          speciesId: '',
          birthDate: DateTime.now(),
          sex: AnimalSex.male,
          status: AnimalStatus.alive,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      // ✅ PHASE 4 FIX: SKIP si DRAFT
      if (animal.status == AnimalStatus.draft) {
        debugPrint(
            '   ↳ SKIP remanence alerte for DRAFT animal: ${animal.displayName}');
        continue;
      }

      // Créer alerte si < 7 jours (constante)
      if (daysRemaining < 7) {
        final alertType = daysRemaining <= AppConstants.alertRemanenceDaysUrgent
            ? AlertType.urgent
            : daysRemaining <= AppConstants.alertRemanenceDaysImportant
                ? AlertType.important
                : AlertType.routine;

        final alert = Alert(
          id: 'remanence_${animal.id}',
          type: alertType,
          category: AlertCategory.remanence,
          title: '',
          message: '',
          entityId: animal.id,
          entityType: 'animal',
          entityName: _getAnimalDisplayName(animal),
          dueDate: DateTime.now().add(Duration(days: daysRemaining)),
          actionLabel: 'Voir l\'animal',
          animalIds: [animal.id],
          titleKey: config.titleKey,
          messageKey: config.messageKey,
          messageParams: {
            'animalName': _getAnimalDisplayName(animal),
            'daysRemaining': daysRemaining.toString(),
            'treatmentName': treatment.productName,
          },
        );
        alerts.add(alert);
      }
    }

    return alerts;
  }

  /// Évaluation WEIGHING (Pesée manquante)
  Future<List<Alert>> _checkAndBuildWeighing(
    AlertConfiguration config,
  ) async {
    final alerts = <Alert>[];
    final animals = _animalProvider.animals
        .where((a) => a.status == AnimalStatus.alive)
        .toList();

    for (final animal in animals) {
      // ✅ PHASE 2: Chercher la dernière pesée pour cet animal
      final lastWeight = _weightProvider.weights
          .where((w) => w.animalId == animal.id)
          .fold<DateTime?>(
            null,
            (latest, w) => latest == null || w.recordedAt.isAfter(latest)
                ? w.recordedAt
                : latest,
          );

      if (lastWeight == null) {
        // Aucune pesée du tout - IMPORTANT si animal adulte
        final alertType =
            animal.ageInDays > 30 ? AlertType.important : AlertType.routine;

        final alert = Alert(
          id: 'weighing_${animal.id}',
          type: alertType,
          category: AlertCategory.weighing,
          title: '',
          message: '',
          entityId: animal.id,
          entityType: 'animal',
          entityName: _getAnimalDisplayName(animal),
          actionLabel: 'Peser',
          animalIds: [animal.id],
          titleKey: config.titleKey,
          messageKey: config.messageKey,
          messageParams: {
            'animalName': _getAnimalDisplayName(animal),
            'daysSinceWeight': '∞',
          },
        );
        alerts.add(alert);
        continue;
      }

      final daysSinceWeight = DateTime.now().difference(lastWeight).inDays;

      // ✅ PHASE 2: Alerte si > tolérance (constante)
      if (daysSinceWeight > AppConstants.alertWeighingToleranceDays) {
        final alert = Alert(
          id: 'weighing_${animal.id}',
          type: AlertType.routine,
          category: AlertCategory.weighing,
          title: '',
          message: '',
          entityId: animal.id,
          entityType: 'animal',
          entityName: _getAnimalDisplayName(animal),
          actionLabel: 'Peser',
          animalIds: [animal.id],
          titleKey: config.titleKey,
          messageKey: config.messageKey,
          messageParams: {
            'animalName': _getAnimalDisplayName(animal),
            'daysSinceWeight': daysSinceWeight.toString(),
          },
        );
        alerts.add(alert);
      }
    }

    return alerts;
  }

  /// Évaluation VACCINATION (Vaccination due)
  /// ✅ PHASE 4 FIX: EXCLUDE DRAFT animals
  Future<List<Alert>> _checkAndBuildVaccination(
    AlertConfiguration config,
  ) async {
    final alerts = <Alert>[];
    final vaccinations = _vaccinationProvider.getVaccinationsWithRemindersDue();

    for (final vaccination in vaccinations) {
      if (vaccination.nextDueDate == null) continue;

      // ✅ PHASE 4 FIX: Vérifier le statut de l'animal
      if (!vaccination.isGroupVaccination && vaccination.animalId != null) {
        try {
          final animal = _animalProvider.animals.firstWhere(
            (a) => a.id == vaccination.animalId,
          );

          // SKIP si animal DRAFT
          if (animal.status == AnimalStatus.draft) {
            debugPrint(
                '   ↳ SKIP vaccination alerte for DRAFT animal: ${animal.displayName}');
            continue;
          }
        } catch (e) {
          // Animal non trouvé, on continue
          debugPrint(
              '   ↳ Animal not found for vaccination: ${vaccination.animalId}');
          continue;
        }
      }

      final daysUntil =
          vaccination.nextDueDate!.difference(DateTime.now()).inDays;

      // ✅ PHASE 2: Alerte si rappel due ou passé (utilise constantes)
      if (daysUntil <= AppConstants.alertVaccinationDaysDue) {
        final alertType = daysUntil <= AppConstants.alertVaccinationDaysOverdue
            ? AlertType.urgent
            : daysUntil <= 3
                ? AlertType.important
                : AlertType.routine;

        final entityName = vaccination.isGroupVaccination
            ? '${vaccination.animalCount} animaux'
            : _animalProvider.animals
                .firstWhere(
                  (a) => a.id == vaccination.animalId,
                  orElse: () => Animal(
                    id: 'unknown',
                    farmId: _currentFarmId,
                    currentEid: 'Unknown',
                    visualId: 'Unknown',
                    officialNumber: '',
                    speciesId: '',
                    birthDate: DateTime.now(),
                    sex: AnimalSex.male,
                    status: AnimalStatus.alive,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  ),
                )
                .displayName;

        final daysOverdue = daysUntil < 0 ? -daysUntil : 0;

        final alert = Alert(
          id: 'vaccination_${vaccination.id}',
          type: alertType,
          category: AlertCategory.treatment,
          title: '',
          message: '',
          entityId: vaccination.animalId,
          entityType: 'vaccination',
          entityName: entityName,
          dueDate: vaccination.nextDueDate,
          actionLabel: 'Vacciner',
          animalIds: vaccination.animalIds,
          titleKey: config.titleKey,
          messageKey: config.messageKey,
          messageParams: {
            'animalName': entityName,
            'daysOverdue': daysOverdue.toString(),
          },
        );
        alerts.add(alert);
      }
    }

    return alerts;
  }

  /// Évaluation IDENTIFICATION (ID officiel manquant) ✅ PHASE 2
  Future<List<Alert>> _checkAndBuildIdentification(
    AlertConfiguration config,
  ) async {
    final alerts = <Alert>[];
    final animals = _animalProvider.animals
        .where((a) => a.status == AnimalStatus.alive)
        .toList();

    for (final animal in animals) {
      // ✅ PHASE 2: Vérifier si l'animal a un official number/ID valide
      final hasOfficialId =
          animal.officialNumber != null && animal.officialNumber!.isNotEmpty;

      if (!hasOfficialId) {
        // ✅ PHASE 2: Utiliser constantes d'âge pour sévérité
        final alertType =
            animal.ageInDays > AppConstants.alertIdentificationAgeDaysUrgent
                ? AlertType.urgent
                : animal.ageInDays > AppConstants.alertIdentificationAgeDays
                    ? AlertType.important
                    : AlertType.routine;

        final alert = Alert(
          id: 'identification_${animal.id}',
          type: alertType,
          category: AlertCategory.identification,
          title: '',
          message: '',
          entityId: animal.id,
          entityType: 'animal',
          entityName: _getAnimalDisplayName(animal),
          actionLabel: 'Ajouter ID officiel',
          animalIds: [animal.id],
          titleKey: config.titleKey,
          messageKey: config.messageKey,
          messageParams: {
            'animalName': _getAnimalDisplayName(animal),
            'ageInDays': animal.ageInDays.toString(),
          },
        );
        alerts.add(alert);
      }
    }

    return alerts;
  }

  /// Évaluation SYNC REQUIRED (Sync en retard)
  Future<Alert?> _checkAndBuildSyncRequired(
    AlertConfiguration config,
  ) async {
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
      final type = daysSinceLastSync > 14
          ? AlertType.urgent
          : daysSinceLastSync > 7
              ? AlertType.important
              : AlertType.routine;

      final alert = Alert(
        id: 'sync_required',
        type: type,
        category: AlertCategory.sync,
        title: '',
        message: '',
        actionLabel: 'Synchroniser',
        count: pendingItems,
        titleKey: config.titleKey,
        messageKey: config.messageKey,
        messageParams: {
          'daysSince': daysSinceLastSync.toString(),
          'pending': pendingItems.toString(),
        },
      );
      return alert;
    }

    return null;
  }

  /// Évaluation TREATMENT RENEWAL (Traitement à renouveler)
  Future<List<Alert>> _checkAndBuildTreatmentRenewal(
    AlertConfiguration config,
  ) async {
    final alerts = <Alert>[];
    // TODO: Implémenter la logique quand treatments ont renewal date
    return alerts;
  }

  /// Évaluation BATCH TO FINALIZE (Lot à finaliser)
  Future<List<Alert>> _checkAndBuildBatchToFinalize(
    AlertConfiguration config,
  ) async {
    final alerts = <Alert>[];
    // TODO: Implémenter quand Batch model est prêt
    return alerts;
  }

  // ==================== LEGACY HELPERS ====================

  /// Calculer alertes incomplets (legacy - garde pour backward compat)
  List<IncompleteEvent> _calculateIncompleteEvents() {
    final events = <IncompleteEvent>[];

    for (final animal in _animalProvider.animals) {
      if (animal.status != AnimalStatus.draft) continue;

      final missingFields = <String>[];
      var completionRate = 1.0;

      if (animal.displayName.isEmpty || animal.displayName.length < 10) {
        missingFields.add('EID valide');
        completionRate -= 0.4;
      }

      // Si des champs manquent, créer un événement incomplet
      if (missingFields.isNotEmpty && completionRate < 0.9) {
        events.add(IncompleteEvent.animal(
          animalId: animal.id,
          animalName: _getAnimalDisplayName(animal),
          missingFields: missingFields,
          completionRate: completionRate,
          createdAt: animal.createdAt,
        ));
      }
    }

    return events;
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
  /// Cherche dans entityId (alerte spécifique) ET animalIds (alertes de groupe)
  List<Alert> getAlertsForAnimal(String animalId) {
    return _alerts
        .where((a) =>
                a.entityId == animalId || // Alerte spécifique à cet animal
                (a.animalIds?.contains(animalId) ??
                    false) // Alerte de groupe (brouillons, pesées, etc)
            )
        .toList();
  }

  /// Obtenir SEULEMENT les alertes spécifiques à un animal
  /// Inclut:
  /// - Alertes spécifiques (entityId == animalId)
  /// - Alertes DRAFT (animalIds contient animalId)
  /// Exclut les alertes de groupe (pesées collectives, vaccinations groupe, etc)
  /// Utilisé dans l'écran de détail animal pour afficher uniquement
  /// les problèmes relatifs à CET animal, pas des autres
  List<Alert> getSpecificAlertsForAnimal(String animalId) {
    return _alerts
        .where((a) =>
                a.entityId == animalId || // Alerte spécifique à cet animal
                (a.animalIds?.contains(animalId) ??
                    false) // Alerte de groupe (DRAFT, pesées, etc)
            )
        .toList();
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

  // ==================== DEBUG HELPERS ====================

  /// DEBUG: Afficher l'état des animaux
  void debugAnimalsState() {
    debugPrint('🐑 [DEBUG ANIMALS] ===== ÉTAT ANIMAUX =====');
    final animals = _animalProvider.animals;
    debugPrint('Total animaux: ${animals.length}');

    for (final animal in animals.take(5)) {
      // Afficher les 5 premiers
      debugPrint('  - ${animal.displayName}');
      debugPrint('    Status: ${animal.status}');
      debugPrint('    Age: ${animal.ageInDays} jours');
      debugPrint(
          '    Traitements: ${_animalProvider.getAnimalTreatments(animal.id).length}');
    }
    if (animals.length > 5) {
      debugPrint('  ... et ${animals.length - 5} autres');
    }
  }

  /// DEBUG: Appeler depuis HomeScreen ou AlertScreen pour tester
  void debugAlert() {
    debugPrint('\n\n🔍 ===== DEBUG ALERTE COMPLET =====');
    debugPrint('FarmId courant: $_currentFarmId');
    debugPrint('AuthProvider.currentFarmId: ${_authProvider.currentFarmId}');
    debugAnimalsState();
    debugPrint('Alertes actuelles: ${_alerts.length}');
    debugPrint('Urgentes: ${urgentAlerts.length}');
    debugPrint('Importantes: ${importantAlerts.length}');
    debugPrint('Routine: ${routineAlerts.length}');
    debugPrint('===== FIN DEBUG =====\n\n');
  }

  // ==================== HELPERS I18N ====================

  /// Obtenir le nom d'affichage d'un animal avec fallback
  String _getAnimalDisplayName(Animal animal) {
    return animal.displayName;
  }

  /// Message de résumé pour l'utilisateur (avec i18n)
  ///
  /// ⚠️ Cette méthode nécessite un BuildContext pour la traduction
  String getSummary(BuildContext context) {
    if (_alerts.isEmpty) {
      return AppLocalizations.of(context).translate(AppStrings.noAlert);
    }

    final urgent = urgentAlertCount;
    final important = importantAlertCount;
    final routine = routineAlerts.length;

    final parts = <String>[];
    if (urgent > 0) {
      parts.add('$urgent ${_getPluralLabel(context, urgent, 'urgent')}');
    }
    if (important > 0) {
      parts.add(
          '$important ${_getPluralLabel(context, important, 'important')}');
    }
    if (routine > 0) {
      parts.add('$routine ${_getPluralLabel(context, routine, 'task')}');
    }

    return parts.join(', ');
  }

  /// Message pour la bannière rouge (avec i18n)
  ///
  /// ⚠️ Cette méthode nécessite un BuildContext pour la traduction
  String? getUrgentBannerMessage(BuildContext context) {
    if (!hasUrgentAlerts) return null;

    final count = urgentAlertCount;
    if (count == 1) {
      return '🚨 ${urgentAlerts.first.title}';
    }
    return '🚨 $count ${AppLocalizations.of(context).translate(AppStrings.urgentAlerts).toUpperCase()}';
  }

  /// Helper : Label pluriel selon le type et le count
  String _getPluralLabel(BuildContext context, int count, String type) {
    final l10n = AppLocalizations.of(context);

    switch (type) {
      case 'urgent':
        return count > 1
            ? '${l10n.translate(AppStrings.urgentLabel).toLowerCase()}s'
            : l10n.translate(AppStrings.urgentLabel).toLowerCase();
      case 'important':
        return count > 1
            ? '${l10n.translate(AppStrings.importantLabel).toLowerCase()}es'
            : l10n.translate(AppStrings.importantLabel).toLowerCase();
      case 'task':
        return count > 1
            ? '${l10n.translate(AppStrings.routineLabel).toLowerCase()}s'
            : l10n.translate(AppStrings.routineLabel).toLowerCase();
      default:
        return '';
    }
  }
}
