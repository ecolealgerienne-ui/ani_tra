// lib/providers/reminder_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/medical_reminder.dart';

/// Provider pour la gestion des rappels médicaux
class ReminderProvider extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin _notifications;
  final List<MedicalReminder> _reminders = [];

  ReminderProvider(this._notifications);

  // ==================== Getters ====================

  /// Obtenir tous les rappels
  List<MedicalReminder> get reminders => List.unmodifiable(_reminders);

  /// Obtenir les rappels en attente
  List<MedicalReminder> get pendingReminders {
    return _reminders
        .where((r) => r.status == ReminderStatus.pending)
        .toList()
      ..sort((a, b) => a.reminderDate.compareTo(b.reminderDate));
  }

  /// Obtenir les rappels complétés
  List<MedicalReminder> get completedReminders {
    return _reminders
        .where((r) => r.status == ReminderStatus.completed)
        .toList()
      ..sort((a, b) => b.completedAt!.compareTo(a.completedAt!));
  }

  /// Obtenir les rappels d'aujourd'hui
  List<MedicalReminder> get todayReminders {
    final now = DateTime.now();
    return _reminders
        .where((r) =>
            r.status == ReminderStatus.pending &&
            r.reminderDate.year == now.year &&
            r.reminderDate.month == now.month &&
            r.reminderDate.day == now.day)
        .toList()
      ..sort((a, b) => a.reminderTime.compareTo(b.reminderTime));
  }

  /// Obtenir les rappels pour un animal
  List<MedicalReminder> getRemindersForAnimal(String animalId) {
    return _reminders
        .where((r) => r.animalId == animalId)
        .toList()
      ..sort((a, b) => a.reminderDate.compareTo(b.reminderDate));
  }

  /// Obtenir les rappels pour un acte médical
  List<MedicalReminder> getRemindersForMedicalAct(String actId) {
    return _reminders
        .where((r) => r.medicalActId == actId)
        .toList()
      ..sort((a, b) => a.reminderDate.compareTo(b.reminderDate));
  }

  // ==================== Méthodes de création ====================

  /// Créer des rappels pour un traitement (cure)
  Future<void> createTreatmentReminders({
    required String treatmentId,
    required String animalId,
    required String productName,
    required DateTime startDate,
    required int cureDays,
    required TimeOfDay reminderTime,
  }) async {
    final List<MedicalReminder> newReminders = [];

    // Créer un rappel pour chaque jour (J2 à JN)
    // J1 = premier jour, pas besoin de rappel
    for (int day = 2; day <= cureDays; day++) {
      final reminderDate = startDate.add(Duration(days: day - 1));
      final reminderDateTime = DateTime(
        reminderDate.year,
        reminderDate.month,
        reminderDate.day,
        reminderTime.hour,
        reminderTime.minute,
      );

      final reminder = MedicalReminder(
        id: '${treatmentId}_day_$day',
        medicalActId: treatmentId,
        type: ReminderType.treatment,
        reminderDate: reminderDate,
        reminderTime: reminderDateTime,
        animalId: animalId,
        productName: productName,
        dayNumber: day,
        totalDays: cureDays,
      );

      newReminders.add(reminder);

      // Programmer la notification
      await _scheduleNotification(reminder);
    }

    _reminders.addAll(newReminders);
    notifyListeners();
  }

  /// Créer des rappels pour une vaccination
  Future<void> createVaccinationReminders({
    required String vaccinationId,
    required String animalId,
    required String productName,
    required DateTime administrationDate,
    required List<int> reminderDays,
    required TimeOfDay reminderTime,
  }) async {
    final List<MedicalReminder> newReminders = [];

    for (int i = 0; i < reminderDays.length; i++) {
      final daysToAdd = reminderDays[i];
      final reminderDate = administrationDate.add(Duration(days: daysToAdd));
      final reminderDateTime = DateTime(
        reminderDate.year,
        reminderDate.month,
        reminderDate.day,
        reminderTime.hour,
        reminderTime.minute,
      );

      final reminder = MedicalReminder(
        id: '${vaccinationId}_reminder_$i',
        medicalActId: vaccinationId,
        type: ReminderType.vaccination,
        reminderDate: reminderDate,
        reminderTime: reminderDateTime,
        animalId: animalId,
        productName: productName,
        dayNumber: i + 2, // J2, J3, etc.
        totalDays: reminderDays.length + 1,
      );

      newReminders.add(reminder);
      await _scheduleNotification(reminder);
    }

    _reminders.addAll(newReminders);
    notifyListeners();
  }

  // ==================== Gestion des notifications ====================

  /// Programmer une notification
  Future<void> _scheduleNotification(MedicalReminder reminder) async {
    try {
      final scheduledDate = tz.TZDateTime.from(
        reminder.reminderTime,
        tz.local,
      );

      // Ne programmer que si la date est dans le futur
      if (scheduledDate.isAfter(DateTime.now())) {
        await _notifications.zonedSchedule(
          reminder.id.hashCode,
          _getNotificationTitle(reminder),
          _getNotificationBody(reminder),
          scheduledDate,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'medical_reminders',
              'Rappels médicaux',
              channelDescription: 'Rappels pour traitements et vaccinations',
              importance: Importance.high,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: reminder.id,
        );
      }
    } catch (e) {
      debugPrint('Erreur lors de la programmation de la notification: $e');
    }
  }

  /// Obtenir le titre de la notification
  String _getNotificationTitle(MedicalReminder reminder) {
    if (reminder.type == ReminderType.treatment) {
      return '🔔 Rappel traitement';
    } else {
      return '🔔 Rappel vaccination';
    }
  }

  /// Obtenir le corps de la notification
  String _getNotificationBody(MedicalReminder reminder) {
    return '${reminder.productName} - Animal #${reminder.animalId} - ${reminder.dayLabel}';
  }

  // ==================== Gestion des rappels ====================

  /// Marquer un rappel comme complété
  Future<void> completeReminder(String reminderId) async {
    final index = _reminders.indexWhere((r) => r.id == reminderId);
    if (index != -1) {
      _reminders[index] = _reminders[index].markAsCompleted();

      // Annuler la notification
      await _notifications.cancel(_reminders[index].id.hashCode);
      notifyListeners();
    }
  }

  /// Annuler un rappel
  Future<void> cancelReminder(String reminderId) async {
    final index = _reminders.indexWhere((r) => r.id == reminderId);
    if (index != -1) {
      _reminders[index] = _reminders[index].markAsCancelled();

      // Annuler la notification
      await _notifications.cancel(_reminders[index].id.hashCode);
      notifyListeners();
    }
  }

  /// Annuler tous les rappels d'un acte médical
  Future<void> cancelRemindersForAct(String actId) async {
    final toCancel = _reminders.where((r) => r.medicalActId == actId).toList();

    for (final reminder in toCancel) {
      await _notifications.cancel(reminder.id.hashCode);
      final index = _reminders.indexOf(reminder);
      if (index != -1) {
        _reminders[index] = reminder.markAsCancelled();
      }
    }

    notifyListeners();
  }

  /// Supprimer un rappel
  Future<void> deleteReminder(String reminderId) async {
    final index = _reminders.indexWhere((r) => r.id == reminderId);
    if (index != -1) {
      await _notifications.cancel(_reminders[index].id.hashCode);
      _reminders.removeAt(index);
      notifyListeners();
    }
  }

  /// Supprimer tous les rappels d'un acte
  Future<void> deleteRemindersForAct(String actId) async {
    final toDelete = _reminders.where((r) => r.medicalActId == actId).toList();

    for (final reminder in toDelete) {
      await _notifications.cancel(reminder.id.hashCode);
    }

    _reminders.removeWhere((r) => r.medicalActId == actId);
    notifyListeners();
  }

  // ==================== Utilitaires ====================

  /// Vérifier si des rappels existent pour un acte
  bool hasRemindersForAct(String actId) {
    return _reminders.any((r) => r.medicalActId == actId);
  }

  /// Obtenir le nombre de rappels en attente
  int get pendingReminderCount {
    return _reminders.where((r) => r.status == ReminderStatus.pending).length;
  }

  /// Obtenir le nombre de rappels d'aujourd'hui
  int get todayReminderCount {
    return todayReminders.length;
  }

  /// Nettoyer les rappels anciens (optionnel)
  Future<void> cleanOldReminders({int daysOld = 90}) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
    final toRemove = _reminders
        .where((r) =>
            r.status == ReminderStatus.completed &&
            r.completedAt != null &&
            r.completedAt!.isBefore(cutoffDate))
        .toList();

    for (final reminder in toRemove) {
      await _notifications.cancel(reminder.id.hashCode);
    }

    _reminders.removeWhere((r) => toRemove.contains(r));

    if (toRemove.isNotEmpty) {
      notifyListeners();
    }
  }

  /// Charger les rappels depuis une source de données (à implémenter)
  Future<void> loadReminders() async {
    // TODO: Implémenter le chargement depuis base de données
    notifyListeners();
  }

  /// Sauvegarder les rappels (à implémenter)
  Future<void> saveReminders() async {
    // TODO: Implémenter la sauvegarde en base de données
  }
}
