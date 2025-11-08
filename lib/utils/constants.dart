// lib/utils/constants.dart
import 'package:flutter/material.dart';

class AppConstants {
  // API Configuration (for future use)
  static const String apiBaseUrl = 'https://api.rfid-troupeau.com';
  static const String apiVersion = 'v1';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Local Storage Keys
  static const String keyLanguage = 'language_code';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLastSyncDate = 'last_sync_date';
  static const String keyOfflineMode = 'offline_mode';

  // Limits
  static const int maxAnimalsPerFarm = 10000;
  static const int maxCampaignsActive = 10;
  static const int maxPendingSyncItems = 1000;
  static const int maxOfflineDays = 30;

  // Withdrawal periods (days)
  static const int withdrawalAlertThreshold = 7; // Alert if < 7 days
  static const int withdrawalCriticalThreshold = 3; // Critical if < 3 days

  // Colors
  static const Color primaryGreen = Color(0xFF4A7C59);
  static const Color secondaryBrown = Color(0xFF8B7355);
  static const Color tertiaryBlue = Color(0xFF5B9BD5);
  static const Color surfaceBeige = Color(0xFFF5F5F0);

  // Status colors
  static const Color statusAlive = Colors.green;
  static const Color statusSold = Colors.blue;
  static const Color statusDead = Colors.grey;

  // Sync intervals
  static const Duration syncInterval = Duration(minutes: 5);
  static const Duration autoSyncDelay = Duration(seconds: 30);

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Text limits
  static const int maxNotesLength = 500;
  static const int maxNameLength = 100;
  static const int maxCampaignNameLength = 50;

  // ========== IDENTIFIERS (nouvelles constantes) ==========
  static const String tempIdPrefix = 'TEMP_';
  static const String qrPrefixAnimal = 'QR_ANIMAL_';
  static const String qrPrefixVet = 'QR_VET_';
  static const String qrInvalidPrefix = 'QR_INVALID_';

  // ========== ANIMAL CONSTRAINTS (nouvelles constantes) ==========
  static const int minReproductionAgeMonths = 12; // Âge min pour reproduction
  static const int maxIdSubstringLength = 8; // Pour affichage tronqué d'ID

  // ========== NOTIFICATION CHANNELS (nouvelles constantes) ==========
  static const String notificationChannelId = 'medical_reminders';
  static const String notificationChannelName = 'Rappels médicaux';
  static const String notificationChannelDesc =
      'Rappels pour traitements et vaccinations';

  static const String notAvailable = 'N/A';
}
