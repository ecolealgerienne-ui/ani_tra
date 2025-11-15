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

  // SnackBar durations
  static const Duration snackBarDurationShort = Duration(seconds: 1);
  static const Duration snackBarDurationMedium = Duration(seconds: 2);
  static const Duration snackBarDurationLong = Duration(seconds: 3);

  // Text limits
  static const int maxNotesLength = 1000;  // Animal notes max length
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

  // ============ SYNC SCREEN SPECIFIC ============
  /// Hauteur du grand bouton de synchronisation
  static const double syncButtonHeight = 120.0;

  // ============ ICON SIZES ============
  /// Taille des grandes icônes (success, main actions)
  static const double iconSizeLarge = 64.0;

  /// Taille des icônes moyennes-grandes (boutons principaux)
  static const double iconSizeMediumLarge = 48.0;

  /// Taille des icônes moyennes (cards, stats)
  static const double iconSizeMedium = 32.0;

  // ============ FONT SIZES ============
  /// Taille de police pour textes importants/titres secondaires
  static const double fontSizeImportant = 18.0;

  /// Taille de police pour titres de section
  static const double fontSizeSectionTitle = 16.0;

  /// Taille de police pour sous-titres/descriptions
  static const double fontSizeSubtitle = 13.0;

  /// Taille de police pour petits textes/hints
  static const double fontSizeSmall = 12.0;

  // Si pas déjà présentes, ajouter :
  /// Taille de police pour le corps de texte standard
  static const double fontSizeBody = 14.0;

  /// Taille de police très petite pour labels secondaires
  static const double fontSizeTiny = 11.0;

  /// Taille de police micro pour badges/compteurs
  static const double fontSizeMicro = 10.0;

  /// Taille de police grande pour sous-titres importants
  static const double fontSizeLarge = 20.0;

  /// Taille de police extra large pour titres/emojis
  static const double fontSizeExtraLarge = 24.0;

  // ============ OPACITY VALUES ============
  /// Opacité légère pour les badges et backgrounds subtils
  static const double opacityLight = 0.1;

  /// Opacité moyenne pour les backgrounds de cards
  static const double opacityMedium = 0.2;

  /// Opacité subtile pour le texte secondaire
  static const double opacitySubtle = 0.85;

  // ============ ICON SIZES (si absentes) ============
  /// Taille extra petite pour petites icônes inline
  static const double iconSizeXSmall = 16.0;

  /// Taille très petite pour petites icônes inline
  static const double iconSizeTiny = 14.0;

  /// Taille petite pour icônes d'info
  static const double iconSizeSmall = 18.0;

  /// Taille moyenne-petite pour icônes de section
  static const double iconSizeRegular = 20.0;

  // ============ FONT SIZES (si absentes) ============
  /// Taille pour labels et métadonnées
  static const double fontSizeLabel = 15.0;

  /// Taille pour grands titres
  static const double fontSizeLargeTitle = 22.0;

  static const double fontSizeMedium = 16.0;

  // ============ BORDER RADIUS (si absentes) ============
  /// Très petit border radius pour petits éléments
  static const double borderRadiusTiny = 4.0;

  /// Petit border radius pour badges
  static const double borderRadiusSmall = 6.0;

  /// Border radius moyen pour containers
  static const double borderRadiusMedium = 8.0;

  // ============ WEIGHT RECORD SCREEN SPECIFIC ============
  /// Hauteur du bouton de scan d'animal
  static const double scanButtonHeight = 100.0;

  /// Hauteur du bouton de sauvegarde principal
  static const double primaryButtonHeight = 56.0;

  /// Poids maximum autorisé en kg
  static const double maxWeightKg = 300.0;

  // ============ ICON SIZES (si absentes) ============
  /// Taille pour grandes icônes de boutons/actions principales
  static const double iconSizeExtraLarge = 36.0;

  /// Taille pour très grandes icônes (états vides, illustrations)
  static const double iconSizeHuge = 80.0;

  // ============ CONTAINER SIZES ============
  /// Taille standard des containers d'icônes carrés
  static const double iconContainerSize = 48.0;

  // ============ EID HISTORY TIMELINE ============
  /// Taille du cercle de la timeline
  static const double timelineCircleSize = 12.0;

  /// Largeur de la ligne de timeline
  static const double timelineLineWidth = 2.0;

  /// Hauteur de la ligne de timeline entre items
  static const double timelineLineHeight = 50.0;

  // ============ BADGE & PILL ============
  /// Border radius pour badges/pills arrondis
  static const double badgeBorderRadius = 12.0;

  // ============ LOADER SIZE ============
  /// Taille des petits loaders/spinners
  static const double loaderSizeSmall = 20.0;

  // ========== SETTINGS SCREEN ==========
  // ============ SPACING ============
  static const double spacingMicro = 2.0;
  static const double spacingTiny = 4.0;
  static const double spacingExtraSmall = 8.0;
  static const double spacingSmall = 12.0;
  static const double spacingMedium = 16.0;
  static const double spacingMediumLarge = 24.0;
  static const double spacingLarge = 32.0;
  static const double spacingXLarge = 48.0;

  // ============ AVATAR SIZES ============
  static const double avatarRadiusMedium = 24.0;
  static const double avatarRadiusLarge = 40.0;

  // ============ STATUS COLORS ============
  static const Color statusDanger = Colors.red;
  static const Color successGreen = Colors.green;
  static const Color warningOrange = Colors.orange;

  // ============ SLIDER & SCALE ============
  static const double sliderWidth = 150.0;
  static const double textScaleMin = 0.8;
  static const double textScaleMax = 1.5;

  // ============ MISC ============
  static const double colorCircleRadius = 12.0;
  static const int mockCacheSize = 15728640; // 15 MB
  static const double logoSize = 80.0;
  static const double letterSpacing = 1.2;

  // ========== LOT SCREENS ==========
  // ============ COLORS ============
  static const Color primaryBlue = Colors.blue;
  static const Color statusGrey = Colors.grey;

  // ============ SIZES ============
  static const double typeCardIconSize = 60.0;
  static const double typeCardIconFontSize = 32.0;
  static const double headerCircleSize = 80.0;
  static const double headerIconSize = 40.0;
  static const double dialogMaxHeight = 500.0;

  // ============ PADDING ============
  static const double fabPaddingBottom = 80.0;

  // ============ DATE RANGES ============
  static const int maxPastDays = 30;
  static const int maxFutureDays = 60;

  // Scanner overlay
  static const double scannerOverlayBottom = 100.0;
  static const double scannerOverlayPadding = 16.0;
  static const double scannerOverlayMargin = 32.0;
  static const double scannerOverlayRadius = 12.0;
  static const double scannerOverlayAlpha = 0.7;
  static const double scannerIconSize = 48.0;
  static const double scannerTextSize = 16.0;
  static const double scannerButtonBottom = 24.0;
  static const double scannerSpacing = 8.0;

  //BATCH
  // ==================== Batch Create ====================
  // Colors - Status
  static const Color statusSuccess = Colors.green;
  static const Color statusInfo = Colors.blue;
  static const Color statusWarning = Colors.orange;
  // Layout
  static const double batchCreatePadding = 16.0;
  static const double batchCreateSpacingLarge = 32.0;
  static const double batchCreateSpacingMedium = 24.0;
  static const double batchCreateSpacingSmall = 12.0;

  // Icon container
  static const double batchCreateIconSize = 120.0;
  static const double batchCreateIconInnerSize = 60.0;

  // Text sizes
  static const double batchCreateDescriptionSize = 14.0;
  static const double batchCreateTitleSize = 16.0;

  // Validation
  static const int batchNameMinLength = 3;

  // Grid
  static const int batchCreateGridColumns = 2;
  static const double batchCreateGridAspectRatio = 1.8;

  // Purpose cards
  static const double batchCreateCardRadius = 12.0;
  static const double batchCreateCardAlpha = 0.1;
  static const double batchCreateCardBorderSelected = 2.0;
  static const double batchCreateCardBorderNormal = 1.0;
  static const double batchCreateCardShadowAlpha = 0.3;
  static const double batchCreateCardShadowBlur = 8.0;
  static const double batchCreateCardShadowOffset = 2.0;
  static const double batchCreateCardIconSize = 32.0;
  static const double batchCreateCardSpacing = 8.0;
  static const double batchCreateCardTextSize = 14.0;
  static const double batchCreateCardCheckMargin = 4.0;
  static const double batchCreateCardCheckSize = 16.0;

  // Buttons
  static const double batchCreateButtonPadding = 16.0;
  static const double batchCreateButtonHeight = 50.0;

  // ==================== Batch List ====================
  // Layout
  static const double batchListPadding = 16.0;

  // Empty state
  static const double batchListEmptyPadding = 32.0;
  static const double batchListEmptyIconSize = 80.0;
  static const double batchListEmptySpacing = 24.0;
  static const double batchListEmptyTitleSize = 20.0;
  static const double batchListEmptySpacingSmall = 12.0;
  static const double batchListEmptyTextSize = 14.0;

  // Batch card container
  static const double batchCardMargin = 12.0;
  static const double batchCardRadius = 12.0;
  static const double batchCardBorderAlpha = 0.3;
  static const double batchCardShadowAlpha = 0.05;
  static const double batchCardShadowBlur = 4.0;
  static const double batchCardShadowOffset = 2.0;
  static const double batchCardPadding = 16.0;

  // Batch card icon
  static const double batchCardIconSize = 48.0;
  static const double batchCardIconAlpha = 0.1;
  static const double batchCardIconRadius = 8.0;
  static const double batchCardIconInnerSize = 24.0;

  // Batch card content
  static const double batchCardSpacing = 12.0;
  static const double batchCardNameSize = 16.0;
  static const double batchCardSpacingTiny = 4.0;
  static const double batchCardPetIconSize = 14.0;
  static const double batchCardInfoSize = 13.0;
  static const double batchCardSpacingSmall = 12.0;

  // Batch card badge
  static const double batchCardBadgePaddingH = 8.0;
  static const double batchCardBadgePaddingV = 2.0;
  static const double batchCardBadgeAlpha = 0.1;
  static const double batchCardBadgeRadius = 4.0;
  static const double batchCardBadgeSize = 11.0;

  // Batch card menu
  static const double batchCardMenuIconSize = 18.0;
  static const double batchCardMenuSpacing = 8.0;

  // Batch card status
  static const double batchCardStatusPadding = 8.0;
  static const double batchCardStatusIconSize = 16.0;
  static const double batchCardStatusTextSize = 12.0;

  // Batch card action
  static const double batchCardActionPadding = 12.0;

  // ==================== Batch Scan ====================
  // Timing
  static const int batchScanDelay = 300; // milliseconds
  static const int batchScanDuplicateDuration = 2; // seconds
  static const int batchScanSuccessDuration = 1; // seconds

  // Feedback
  static const double batchScanFeedbackSpacing = 12.0;

  // Header
  static const double batchScanHeaderPadding = 24.0;
  static const double batchScanHeaderSpacing = 16.0;
  static const double batchScanHeaderTextSize = 16.0;

  // Counter circle
  static const double batchScanCounterSize = 100.0;
  static const double batchScanCounterIconSize = 32.0;
  static const double batchScanCounterSpacing = 4.0;
  static const double batchScanCounterTextSize = 24.0;

  // Scan zone
  static const double batchScanZoneIconSize = 80.0;
  static const double batchScanZoneSpacing = 24.0;
  static const double batchScanZoneSpacingSmall = 16.0;
  static const double batchScanZoneHintSize = 14.0;

  // Scan button
  static const double batchScanButtonPaddingH = 32.0;
  static const double batchScanButtonPaddingV = 16.0;

  // Animal list
  static const double batchScanListMaxHeight = 200.0;
  static const double batchScanListPadding = 16.0;
  static const double batchScanListTitleSize = 14.0;
  static const double batchScanListIconSize = 18.0;
  static const double batchScanListTextSize = 14.0;

  // Action buttons
  static const double batchScanActionPadding = 16.0;
  static const double batchScanActionShadowAlpha = 0.1;
  static const double batchScanActionShadowBlur = 10.0;
  static const double batchScanActionShadowOffset = -2.0;
  static const double batchScanActionSpacing = 16.0;
  static const int batchScanSaveButtonFlex = 2;

  //section GENERAL ou NAVIGATION)
  // ==================== App Configuration ====================
  static const String appTitle = 'RFID Livestock';
  static const String defaultTimezone = 'Europe/Paris';
  static const String androidIconPath = '@mipmap/ic_launcher';

  // ==================== Main Theme ====================
  static const double mainCardElevation = 2.0;
  static const double mainCardRadius = 12.0;
  static const double mainInputRadius = 8.0;

  /// Délai avant alerte DRAFT (heures)
  static const int draftAlertHours = 0;

  /// Délai avant HARD LIMIT (supprimer ou valider obligatoire)
  static const int draftAlertLimitHours = 168; // 7 jours

  // ALERT CONFIGURATION - Seuils (jours)
  static const int alertRemanenceDaysUrgent = 0; // ≤ 0j = URGENT
  static const int alertRemanenceDaysImportant = 3; // ≤ 3j = IMPORTANT
  static const int alertWeighingToleranceDays = 7; // > 7j sans pesée = ALERT
  static const int alertIdentificationAgeDays = 7; // Âge > 7j = ALERT
  static const int alertIdentificationAgeDaysUrgent = 180; // > 180j = URGENT
  static const int alertVaccinationDaysDue = 7; // ≤ 7j avant due = ALERT
  static const int alertVaccinationDaysOverdue =
      0; // ≤ 0j (passé) = IMPORTANT/URGENT

  // ==================== FARM SETTINGS SCREEN ====================
  /// Espèce par défaut si aucune préférence configurée
  static const String defaultSpeciesId = 'sheep';

  /// Race par défaut pour ovins
  static const String defaultSheepBreedId = 'merinos';

  /// Hauteur de la section de sélection de ferme
  static const double farmSelectionSectionHeight = 80.0;

  /// Padding horizontal de la section Farm Settings
  static const double farmSettingsSectionPaddingH = 16.0;

  /// Spacing entre les sections Farm Settings
  static const double farmSettingsSectionSpacing = 24.0;

  /// Radius des cards Farm Settings
  static const double farmSettingsCardRadius = 12.0;

  /// Padding des cards Farm Settings
  static const double farmSettingsCardPadding = 16.0;

  /// Taille de l'icône dans les sections Farm Settings
  static const double farmSettingsIconSize = 24.0;

  /// Taille du titre de section Farm Settings
  static const double farmSettingsSectionTitleSize = 16.0;

  /// Taille du sous-titre de section Farm Settings
  static const double farmSettingsSectionSubtitleSize = 13.0;
}

// ==================== DATABASE ====================
class DatabaseConstants {
  static const String dbName = 'animal_trace.db';
  static const int schemaVersion = 1;
}

// ==================== SYNC ====================
class SyncConstants {
  static const int maxRetries = 3;
  static const int retryDelaySeconds = 60;
}
