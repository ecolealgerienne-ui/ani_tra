// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/sync_provider.dart';
import '../../providers/veterinarian_provider.dart';
import '../../models/veterinarian.dart';
import '../../widgets/farm_preferences_section.dart';
import '../../widgets//farm_management_section.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Notification settings
  bool _notificationsEnabled = true;
  bool _treatmentReminders = true;
  bool _withdrawalAlerts = true;
  bool _campaignNotifications = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  // Appearance settings
  bool _darkMode = false;
  double _textScale = 1.0;
  String _themeColor = 'blue';

  // Security settings
  bool _biometricEnabled = false;
  bool _autoLock = true;
  int _autoLockMinutes = 5;

  // Storage settings
  int _cacheSize = 0;
  bool _autoBackup = false;

  // Vétérinaire par défaut
  String? _defaultVeterinarianId;
  String? _selectedVetName;
  String? _selectedVetOrg;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _treatmentReminders = prefs.getBool('treatment_reminders') ?? true;
      _withdrawalAlerts = prefs.getBool('withdrawal_alerts') ?? true;
      _campaignNotifications = prefs.getBool('campaign_notifications') ?? true;
      _soundEnabled = prefs.getBool('sound_enabled') ?? true;
      _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
      _darkMode = prefs.getBool('dark_mode') ?? false;
      _textScale = prefs.getDouble('text_scale') ?? 1.0;
      _themeColor = prefs.getString('theme_color') ?? 'blue';
      _biometricEnabled = prefs.getBool('biometric_enabled') ?? false;
      _autoLock = prefs.getBool('auto_lock') ?? true;
      _autoLockMinutes = prefs.getInt('auto_lock_minutes') ?? 5;
      _cacheSize = prefs.getInt('cache_size') ?? 0;
      _autoBackup = prefs.getBool('auto_backup') ?? false;
      _defaultVeterinarianId = prefs.getString('default_veterinarian_id');

      // Charger les infos du vétérinaire si sélectionné
      if (_defaultVeterinarianId != null && mounted) {
        final vetProvider = context.read<VeterinarianProvider>();
        final vet = vetProvider.getVeterinarianById(_defaultVeterinarianId!);
        if (vet != null) {
          _selectedVetName = vet.fullName;
          _selectedVetOrg = vet.clinic;
        }
      }
    });
  }

  Future<void> _savePreference(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeProvider = context.watch<LocaleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate(AppStrings.settings)),
      ),
      body: ListView(
        children: [
          // Account Section
          _SectionHeader(title: l10n.translate(AppStrings.account)),

          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(l10n.translate(AppStrings.userProfile)),
            subtitle: Text(l10n.translate(AppStrings.adminEmail)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showProfileDialog(context),
          ),

          ListTile(
            leading: const Icon(Icons.lock),
            title: Text(l10n.translate(AppStrings.changePassword)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showChangePasswordDialog(context),
          ),

          const Divider(),

          // Farm Preferences Section (ÉTAPE 4)
          const FarmPreferencesSection(),

          const Divider(),

          // Farm Management Section (PHASE 4)
          const FarmManagementSection(),

          const Divider(),

          // Vétérinaire par défaut
          _SectionHeader(
              title: l10n.translate(AppStrings.veterinarianPrescriber)),

          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingMedium,
                vertical: AppConstants.spacingSmall),
            child: Column(
              children: [
                if (_defaultVeterinarianId == null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.spacingLarge,
                        horizontal: AppConstants.spacingMedium),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusMedium),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.person_search,
                          size: AppConstants.iconSizeMediumLarge,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: AppConstants.spacingSmall),
                        Text(
                          l10n.translate(AppStrings.noVeterinarianDefined),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingMedium),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _searchVeterinarian,
                                icon: const Icon(Icons.search),
                                label: Text(l10n.translate(AppStrings.search)),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: AppConstants.spacingSmall),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppConstants.spacingSmall),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _scanVeterinarianQR,
                                icon: const Icon(Icons.qr_code_scanner),
                                label: Text(l10n.translate(AppStrings.scanQr)),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: AppConstants.spacingSmall),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingMedium),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusMedium),
                      border:
                          Border.all(color: Colors.green.shade300, width: AppConstants.spacingMicro),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.green.shade100,
                          radius: AppConstants.avatarRadiusMedium,
                          child: Icon(
                            Icons.verified_user,
                            color: Colors.green.shade700,
                            size: AppConstants.iconSizeMedium,
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedVetName ??
                                    l10n.translate(AppStrings.veterinarian),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppConstants.fontSizeBody,
                                ),
                              ),
                              const SizedBox(height: AppConstants.spacingTiny),
                              Text(
                                _selectedVetOrg ?? '',
                                style: TextStyle(
                                  fontSize: AppConstants.fontSizeSubtitle,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: _removeVeterinarian,
                          icon: const Icon(Icons.close,
                              color: AppConstants.statusDanger),
                          tooltip: l10n.translate(AppStrings.remove),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingSmall),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _searchVeterinarian,
                          icon: const Icon(Icons.search),
                          label: Text(AppLocalizations.of(context)
                              .translate(AppStrings.changeVeterinarian)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: AppConstants.spacingSmall),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const Divider(),

          // Notifications Section
          _SectionHeader(title: l10n.translate(AppStrings.notifications)),

          SwitchListTile(
            title: Text(l10n.translate(AppStrings.notifications)),
            subtitle: Text(l10n.translate(AppStrings.receiveAllNotifications)),
            value: _notificationsEnabled,
            secondary: const Icon(Icons.notifications),
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
              _savePreference('notifications_enabled', value);
            },
          ),

          if (_notificationsEnabled) ...[
            Padding(
              padding: const EdgeInsets.only(left: AppConstants.spacingMedium),
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(l10n.translate(AppStrings.treatmentReminders)),
                    subtitle: Text(
                        l10n.translate(AppStrings.waitingPeriodsDeadlines)),
                    value: _treatmentReminders,
                    onChanged: (value) {
                      setState(() => _treatmentReminders = value);
                      _savePreference('treatment_reminders', value);
                    },
                  ),
                  SwitchListTile(
                    title: Text(l10n.translate(AppStrings.withdrawalAlerts)),
                    subtitle: Text(l10n
                        .translate(AppStrings.animalsWithActiveWaitingPeriod)),
                    value: _withdrawalAlerts,
                    onChanged: (value) {
                      setState(() => _withdrawalAlerts = value);
                      _savePreference('withdrawal_alerts', value);
                    },
                  ),
                  SwitchListTile(
                    title:
                        Text(l10n.translate(AppStrings.campaignNotifications)),
                    subtitle:
                        Text(l10n.translate(AppStrings.newCampaignsReminders)),
                    value: _campaignNotifications,
                    onChanged: (value) {
                      setState(() => _campaignNotifications = value);
                      _savePreference('campaign_notifications', value);
                    },
                  ),
                  SwitchListTile(
                    title: Text(l10n.translate(AppStrings.sound)),
                    value: _soundEnabled,
                    onChanged: (value) {
                      setState(() => _soundEnabled = value);
                      _savePreference('sound_enabled', value);
                    },
                  ),
                  SwitchListTile(
                    title: Text(l10n.translate(AppStrings.vibration)),
                    value: _vibrationEnabled,
                    onChanged: (value) {
                      setState(() => _vibrationEnabled = value);
                      _savePreference('vibration_enabled', value);
                    },
                  ),
                ],
              ),
            ),
          ],

          const Divider(),

          // Appearance Section
          _SectionHeader(title: l10n.translate(AppStrings.appearance)),

          SwitchListTile(
            title: Text(l10n.translate(AppStrings.darkMode)),
            subtitle: Text(l10n.translate(AppStrings.enableDarkTheme)),
            value: _darkMode,
            secondary: Icon(_darkMode ? Icons.dark_mode : Icons.light_mode),
            onChanged: (value) {
              setState(() => _darkMode = value);
              _savePreference('dark_mode', value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text(l10n.translate(AppStrings.restartAppToApplyTheme)),
                  duration: AppConstants.snackBarDurationMedium,
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.format_size),
            title: Text(l10n.translate(AppStrings.textSize)),
            subtitle: Text('${(_textScale * 100).toInt()}%'),
            trailing: SizedBox(
              width: AppConstants.sliderWidth,
              child: Slider(
                value: _textScale,
                min: AppConstants.textScaleMin,
                max: AppConstants.textScaleMax,
                divisions: 7,
                label: '${(_textScale * 100).toInt()}%',
                onChanged: (value) {
                  setState(() => _textScale = value);
                },
                onChangeEnd: (value) {
                  _savePreference('text_scale', value);
                },
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.palette),
            title: Text(l10n.translate(AppStrings.themeColor)),
            subtitle: Text(_getThemeColorName(context, _themeColor)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemeColorDialog(context),
          ),

          const Divider(),

          // Language Section
          _SectionHeader(title: l10n.translate(AppStrings.languageSection)),

          _LanguageTile(
            title: l10n.translate(AppStrings.french),
            locale: const Locale('fr', ''),
            currentLocale: localeProvider.locale,
            onTap: () {
              localeProvider.setLocale(const Locale('fr', ''));
            },
          ),
          _LanguageTile(
            title: l10n.translate(AppStrings.arabic),
            locale: const Locale('ar', ''),
            currentLocale: localeProvider.locale,
            onTap: () {
              localeProvider.setLocale(const Locale('ar', ''));
            },
          ),
          _LanguageTile(
            title: l10n.translate(AppStrings.english),
            locale: const Locale('en', ''),
            currentLocale: localeProvider.locale,
            onTap: () {
              localeProvider.setLocale(const Locale('en', ''));
            },
          ),

          const Divider(),

          // Security Section
          _SectionHeader(title: l10n.translate(AppStrings.security)),

          SwitchListTile(
            title: Text(l10n.translate(AppStrings.biometricAuthentication)),
            subtitle: Text(l10n.translate(AppStrings.useFingerprintFaceId)),
            value: _biometricEnabled,
            secondary: const Icon(Icons.fingerprint),
            onChanged: (value) {
              setState(() => _biometricEnabled = value);
              _savePreference('biometric_enabled', value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(value
                      ? l10n.translate(AppStrings.biometryEnabled)
                      : l10n.translate(AppStrings.biometryDisabled)),
                ),
              );
            },
          ),

          SwitchListTile(
            title: Text(l10n.translate(AppStrings.autoLock)),
            subtitle: Text(_autoLock
                ? l10n
                    .translate(AppStrings.afterMinutesInactivity)
                    .replaceAll('{minutes}', '$_autoLockMinutes')
                : l10n.translate(AppStrings.autoLock)),
            value: _autoLock,
            secondary: const Icon(Icons.lock_clock),
            onChanged: (value) {
              setState(() => _autoLock = value);
              _savePreference('auto_lock', value);
            },
          ),

          if (_autoLock)
            Padding(
              padding: const EdgeInsets.only(left: AppConstants.spacingMedium),
              child: ListTile(
                title: Text(l10n.translate(AppStrings.lockDelay)),
                subtitle: Text(
                    '$_autoLockMinutes ${l10n.translate(AppStrings.minutes)}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showAutoLockDialog(context),
              ),
            ),

          ListTile(
            leading: const Icon(Icons.vpn_key),
            title: Text(l10n.translate(AppStrings.activeSessions)),
            subtitle: Text(l10n.translate(AppStrings.manageConnectedDevices)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showActiveSessionsDialog(context),
          ),

          const Divider(),

          // Sync Section
          _SectionHeader(title: l10n.translate(AppStrings.synchronization)),

          Consumer<SyncProvider>(
            builder: (context, syncProvider, _) {
              return SwitchListTile(
                title: Text(l10n.translate(AppStrings.onlineMode)),
                subtitle: Text(
                  syncProvider.isOnline
                      ? l10n.translate(AppStrings.serverConnectionActive)
                      : l10n.translate(AppStrings.localDataOnly),
                ),
                value: syncProvider.isOnline,
                onChanged: (value) {
                  syncProvider.setOnline(value);
                },
                secondary: Icon(
                  syncProvider.isOnline ? Icons.cloud : Icons.cloud_off,
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.sync),
            title: Text(l10n.translate(AppStrings.autoSync)),
            subtitle: Text(l10n.translate(AppStrings.syncEvery15Minutes)),
            trailing: Switch(
              value: true,
              onChanged: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.translate(AppStrings.featureComingSoon)),
                  ),
                );
              },
            ),
          ),

          ListTile(
            leading: const Icon(Icons.sync_problem),
            title: Text(l10n.translate(AppStrings.viewSyncDetails)),
            subtitle: Text(l10n.translate(AppStrings.historyConflicts)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.translate(AppStrings.openSyncScreen)),
                ),
              );
            },
          ),

          const Divider(),

          // Storage & Data Section
          _SectionHeader(title: l10n.translate(AppStrings.storageData)),

          ListTile(
            leading: const Icon(Icons.storage),
            title: Text(l10n.translate(AppStrings.usedStorage)),
            subtitle: Text(_cacheSize > 0
                ? '${(_cacheSize / 1024 / 1024).toStringAsFixed(2)} MB'
                : l10n.translate(AppStrings.calculating)),
            trailing: TextButton(
              onPressed: () => _calculateCacheSize(),
              child: Text(l10n.translate(AppStrings.deleteCache)),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.cleaning_services),
            title: Text(l10n.translate(AppStrings.clearCache)),
            subtitle: Text(l10n.translate(AppStrings.freeSpace)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showClearCacheDialog(context),
          ),

          SwitchListTile(
            title: Text(l10n.translate(AppStrings.autoBackup)),
            subtitle: Text(l10n.translate(AppStrings.dailyDataBackup)),
            value: _autoBackup,
            secondary: const Icon(Icons.backup),
            onChanged: (value) {
              setState(() => _autoBackup = value);
              _savePreference('auto_backup', value);
            },
          ),

          ListTile(
            leading: const Icon(Icons.download),
            title: Text(l10n.translate(AppStrings.exportData)),
            subtitle: Text(l10n.translate(AppStrings.csvExcelXml)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showExportDialog(context),
          ),

          ListTile(
            leading: const Icon(Icons.upload),
            title: Text(l10n.translate(AppStrings.importData)),
            subtitle: Text(l10n.translate(AppStrings.fromCsvOrExcel)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showImportDialog(context),
          ),

          ListTile(
            leading: const Icon(Icons.delete_sweep,
                color: AppConstants.statusDanger),
            title: Text(l10n.translate(AppStrings.clearLocalData),
                style: const TextStyle(color: AppConstants.statusDanger)),
            subtitle: Text(l10n.translate(AppStrings.deleteAllUnsyncedData)),
            trailing: const Icon(Icons.chevron_right,
                color: AppConstants.statusDanger),
            onTap: () => _showClearDataDialog(context),
          ),

          const Divider(),

          // About Section
          _SectionHeader(title: l10n.translate(AppStrings.about)),

          ListTile(
            leading: const Icon(Icons.info),
            title: Text(l10n.translate(AppStrings.version)),
            trailing: Text(l10n.translate(AppStrings.appVersion)),
          ),

          ListTile(
            leading: const Icon(Icons.description),
            title: Text(l10n.translate(AppStrings.openSourceLicenses)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: l10n.translate(AppStrings.rfidTroupeau),
                applicationVersion: '1.0.0',
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: Text(l10n.translate(AppStrings.privacyPolicy)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPrivacyDialog(context),
          ),

          ListTile(
            leading: const Icon(Icons.gavel),
            title: Text(l10n.translate(AppStrings.termsOfService)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showTermsDialog(context),
          ),

          ListTile(
            leading: const Icon(Icons.help),
            title: Text(l10n.translate(AppStrings.helpSupport)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showHelpDialog(context),
          ),

          const Divider(),

          // Debug Section (MVP only)
          _SectionHeader(
              title:
                  '${l10n.translate(AppStrings.debug)} ${l10n.translate(AppStrings.mvpOnly)}'),

          ListTile(
            leading: const Icon(Icons.bug_report),
            title: Text(l10n.translate(AppStrings.simulateSyncError)),
            onTap: () {
              final syncProvider = context.read<SyncProvider>();
              syncProvider.setOnline(false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text(l10n.translate(AppStrings.offlineModeActivated)),
                  backgroundColor: AppConstants.warningOrange,
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.restore),
            title: Text(l10n.translate(AppStrings.resetPreferences)),
            onTap: () => _showResetPreferencesDialog(context),
          ),

          const SizedBox(height: AppConstants.spacingLarge),

          // Footer
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: AppConstants.logoSize,
                  height: AppConstants.logoSize,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.pets,
                      size: AppConstants.logoSize,
                      color: Colors.grey.shade300,
                    );
                  },
                ),
                const SizedBox(height: AppConstants.spacingSmall),
                Text(
                  l10n.translate(AppStrings.rfidTroupeau),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                ),
                const SizedBox(height: AppConstants.spacingTiny),
                Text(
                  l10n.translate(AppStrings.sheepManagementSystem),
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _getThemeColorName(BuildContext context, String color) {
    final l10n = AppLocalizations.of(context);
    switch (color) {
      case 'blue':
        return l10n.translate(AppStrings.colorBlue);
      case 'green':
        return l10n.translate(AppStrings.colorGreen);
      case 'purple':
        return l10n.translate(AppStrings.colorPurple);
      case 'orange':
        return l10n.translate(AppStrings.colorOrange);
      default:
        return l10n.translate(AppStrings.colorBlue);
    }
  }

  Future<void> _calculateCacheSize() async {
    setState(() {
      _cacheSize = AppConstants.mockCacheSize;
    });
    await _savePreference('cache_size', _cacheSize);
  }

  // Dialog methods
  void _showProfileDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate(AppStrings.userProfile)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: AppConstants.avatarRadiusLarge,
              child: Icon(Icons.person, size: AppConstants.avatarRadiusLarge),
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            TextField(
              decoration: InputDecoration(
                labelText: l10n.translate(AppStrings.fullName),
                border: const OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            TextField(
              decoration: InputDecoration(
                labelText: l10n.translate(AppStrings.email),
                border: const OutlineInputBorder(),
              ),
              enabled: false,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.translate(AppStrings.close)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text(l10n.translate(AppStrings.profileEditComingSoon))),
              );
            },
            child: Text(l10n.translate(AppStrings.modify)),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate(AppStrings.changePassword)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: l10n.translate(AppStrings.currentPassword),
                border: const OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            TextField(
              decoration: InputDecoration(
                labelText: l10n.translate(AppStrings.newPassword),
                border: const OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            TextField(
              decoration: InputDecoration(
                labelText: l10n.translate(AppStrings.confirmPassword),
                border: const OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.translate(AppStrings.cancel)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text(l10n.translate(AppStrings.passwordChangedSuccess)),
                  backgroundColor: AppConstants.successGreen,
                ),
              );
            },
            child: Text(l10n.translate(AppStrings.confirm)),
          ),
        ],
      ),
    );
  }

  void _showThemeColorDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate(AppStrings.chooseColor)),
        content: RadioGroup<String>(
          groupValue: _themeColor,
          onChanged: (newValue) {
            setState(() => _themeColor = newValue!);
            _savePreference('theme_color', newValue!);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.translate(AppStrings.restartAppForColor)),
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _colorOption(context, AppStrings.colorBlue, 'blue', Colors.blue),
              _colorOption(
                  context, AppStrings.colorGreen, 'green', Colors.green),
              _colorOption(
                  context, AppStrings.colorPurple, 'purple', Colors.purple),
              _colorOption(
                  context, AppStrings.colorOrange, 'orange', Colors.orange),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.translate(AppStrings.close)),
          ),
        ],
      ),
    );
  }

  Widget _colorOption(
      BuildContext context, String labelKey, String value, Color color) {
    final l10n = AppLocalizations.of(context);
    return RadioListTile<String>(
      title: Text(l10n.translate(labelKey)),
      value: value,
      secondary: CircleAvatar(
        backgroundColor: color,
        radius: AppConstants.colorCircleRadius,
      ),
    );
  }

  void _showAutoLockDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate(AppStrings.lockDelay)),
        content: RadioGroup<int>(
          groupValue: _autoLockMinutes,
          onChanged: (value) {
            setState(() => _autoLockMinutes = value!);
            _savePreference('auto_lock_minutes', value!);
            Navigator.pop(context);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<int>(
                title: Text(l10n.translate(AppStrings.oneMinute)),
                value: 1,
              ),
              RadioListTile<int>(
                title: Text(l10n.translate(AppStrings.fiveMinutes)),
                value: 5,
              ),
              RadioListTile<int>(
                title: Text(l10n.translate(AppStrings.fifteenMinutes)),
                value: 15,
              ),
              RadioListTile<int>(
                title: Text(l10n.translate(AppStrings.thirtyMinutes)),
                value: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showActiveSessionsDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate(AppStrings.activeSessions)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.phone_android),
              title: Text(l10n.translate(AppStrings.thisDevice)),
              subtitle: Text(l10n.translate(AppStrings.activeNow)),
              trailing: Chip(
                label: Text(l10n.translate(AppStrings.current)),
                backgroundColor: AppConstants.successGreen,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.tablet),
              title: Text(l10n.translate(AppStrings.tabletSamsung)),
              subtitle: Text(l10n.translate(AppStrings.twoHoursAgo)),
              trailing: IconButton(
                icon: const Icon(Icons.exit_to_app,
                    color: AppConstants.statusDanger),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text(l10n.translate(AppStrings.sessionDisconnected)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.translate(AppStrings.close)),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate(AppStrings.clearCache)),
        content: Text(l10n.translate(AppStrings.clearCacheDescription)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.translate(AppStrings.cancel)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _cacheSize = 0);
              _savePreference('cache_size', 0);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.translate(AppStrings.cacheCleared)),
                  backgroundColor: AppConstants.successGreen,
                ),
              );
            },
            child: Text(l10n.translate(AppStrings.clear)),
          ),
        ],
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate(AppStrings.importData)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: Text(l10n.translate(AppStrings.csvFile)),
              subtitle: Text(l10n.translate(AppStrings.importFromCsv)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text(l10n.translate(AppStrings.importCsvComingSoon))),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_present),
              title: Text(l10n.translate(AppStrings.excelFile)),
              subtitle: Text(l10n.translate(AppStrings.importFromExcel)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          l10n.translate(AppStrings.importExcelComingSoon))),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate(AppStrings.exportData)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('CSV'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text(l10n.translate(AppStrings.exportCsvComingSoon))),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('XML'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text(l10n.translate(AppStrings.exportXmlComingSoon))),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_present),
              title: const Text('Excel'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          l10n.translate(AppStrings.exportExcelComingSoon))),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate(AppStrings.clearDataConfirmTitle)),
        content: Text(l10n.translate(AppStrings.clearDataConfirmMessage)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.translate(AppStrings.cancel)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.translate(AppStrings.featureDisabledMvp)),
                  backgroundColor: AppConstants.warningOrange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.statusDanger,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.translate(AppStrings.clear)),
          ),
        ],
      ),
    );
  }

  void _searchVeterinarian() {
    final l10n = AppLocalizations.of(context);
    final vetProvider = context.read<VeterinarianProvider>();
    showDialog(
      context: context,
      builder: (context) => _VeterinarianSearchDialog(
        veterinarians: vetProvider.veterinarians,
        onSelect: (vet) async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('default_veterinarian_id', vet.id);
          setState(() {
            _defaultVeterinarianId = vet.id;
            _selectedVetName = vet.fullName;
            _selectedVetOrg = vet.clinic;
          });
          if (!context.mounted) return;
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n
                  .translate(AppStrings.veterinarianSetDefault)
                  .replaceAll('{name}', vet.fullName)),
              backgroundColor: AppConstants.successGreen,
            ),
          );
        },
      ),
    );
  }

  Future<void> _scanVeterinarianQR() async {
    final l10n = AppLocalizations.of(context);
    final vetProvider = context.read<VeterinarianProvider>();
    final vets = vetProvider.veterinarians;
    if (vets.isEmpty) return;

    final selectedVet = vets.first;

    setState(() {
      _defaultVeterinarianId = selectedVet.id;
      _selectedVetName = selectedVet.fullName;
      _selectedVetOrg = selectedVet.clinic;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('default_veterinarian_id', selectedVet.id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n
            .translate(AppStrings.veterinarianValidated)
            .replaceAll('{name}', selectedVet.fullName)),
        backgroundColor: AppConstants.successGreen,
        duration: AppConstants.snackBarDurationMedium,
      ),
    );
  }

  void _removeVeterinarian() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('default_veterinarian_id');
    setState(() {
      _defaultVeterinarianId = null;
      _selectedVetName = null;
      _selectedVetOrg = null;
    });
  }

  void _showSelectDefaultVeterinarianDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final vetProvider = context.read<VeterinarianProvider>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate(AppStrings.selectDefaultVeterinarian)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: vetProvider.veterinarians.length,
            itemBuilder: (context, index) {
              final vet = vetProvider.veterinarians[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(vet.firstName[0]),
                ),
                title: Text(vet.fullName),
                subtitle:
                    Text(vet.clinic ?? l10n.translate(AppStrings.notSpecified)),
                trailing: vet.isDefault
                    ? const Icon(Icons.check, color: AppConstants.successGreen)
                    : null,
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('default_veterinarian_id', vet.id);
                  setState(() => _defaultVeterinarianId = vet.id);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n
                          .translate(AppStrings.veterinarianSetDefault)
                          .replaceAll('{name}', vet.fullName)),
                      backgroundColor: AppConstants.successGreen,
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.translate(AppStrings.cancel)),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate(AppStrings.privacyPolicy)),
        content: SingleChildScrollView(
          child: Text(l10n.translate(AppStrings.privacyPolicyContent)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.translate(AppStrings.close)),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate(AppStrings.termsOfService)),
        content: SingleChildScrollView(
          child: Text(l10n.translate(AppStrings.termsOfServiceContent)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.translate(AppStrings.close)),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate(AppStrings.helpSupport)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.translate(AppStrings.needHelp),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(l10n.translate(AppStrings.email)),
              subtitle: Text(l10n.translate(AppStrings.supportEmail)),
              dense: true,
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(l10n.translate(AppStrings.phone)),
              subtitle: Text(l10n.translate(AppStrings.supportPhone)),
              dense: true,
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.translate(AppStrings.website)),
              subtitle: Text(l10n.translate(AppStrings.supportWebsite)),
              dense: true,
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            Text(
              l10n.translate(AppStrings.businessHours),
              style: const TextStyle(
                  fontSize: AppConstants.fontSizeSmall, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.translate(AppStrings.close)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.translate(AppStrings.sendEmailComingSoon)),
                ),
              );
            },
            child: Text(l10n.translate(AppStrings.contactUs)),
          ),
        ],
      ),
    );
  }

  void _showResetPreferencesDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate(AppStrings.resetPreferences)),
        content: Text(l10n.translate(AppStrings.resetPreferencesMessage)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.translate(AppStrings.cancel)),
          ),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pop(context);
              setState(() {
                _notificationsEnabled = true;
                _treatmentReminders = true;
                _withdrawalAlerts = true;
                _campaignNotifications = true;
                _soundEnabled = true;
                _vibrationEnabled = true;
                _darkMode = false;
                _textScale = 1.0;
                _themeColor = 'blue';
                _biometricEnabled = false;
                _autoLock = true;
                _autoLockMinutes = 5;
                _cacheSize = 0;
                _autoBackup = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.translate(AppStrings.preferencesReset)),
                  backgroundColor: AppConstants.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.warningOrange,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.translate(AppStrings.reset)),
          ),
        ],
      ),
    );
  }
}

// Section Header Widget
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppConstants.spacingMedium,
          AppConstants.spacingMedium,
          AppConstants.spacingMedium,
          AppConstants.spacingSmall),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: AppConstants.letterSpacing,
            ),
      ),
    );
  }
}

// Language Tile Widget
class _LanguageTile extends StatelessWidget {
  final String title;
  final Locale locale;
  final Locale currentLocale;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.title,
    required this.locale,
    required this.currentLocale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentLocale.languageCode == locale.languageCode;

    return ListTile(
      title: Text(title),
      trailing: isSelected
          ? const Icon(Icons.check, color: AppConstants.successGreen)
          : null,
      selected: isSelected,
      onTap: onTap,
    );
  }
}

// Veterinarian Search Dialog Widget
class _VeterinarianSearchDialog extends StatefulWidget {
  final List<Veterinarian> veterinarians;
  final Function(Veterinarian) onSelect;

  const _VeterinarianSearchDialog({
    required this.veterinarians,
    required this.onSelect,
  });

  @override
  State<_VeterinarianSearchDialog> createState() =>
      _VeterinarianSearchDialogState();
}

class _VeterinarianSearchDialogState extends State<_VeterinarianSearchDialog> {
  final _searchController = TextEditingController();
  List<Veterinarian> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = widget.veterinarians;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterVets(String query) {
    setState(() {
      if (query.isEmpty) {
        _filtered = widget.veterinarians;
      } else {
        _filtered = widget.veterinarians
            .where((v) =>
                v.fullName.toLowerCase().contains(query.toLowerCase()) ||
                (v.clinic?.toLowerCase().contains(query.toLowerCase()) ??
                    false))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.translate(AppStrings.searchVeterinarian)),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: l10n.translate(AppStrings.search),
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: _filterVets,
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            Flexible(
              child: _filtered.isEmpty
                  ? Center(
                      child:
                          Text(l10n.translate(AppStrings.noVeterinarianFound)))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final vet = _filtered[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(vet.fullName[0]),
                          ),
                          title: Text(vet.fullName),
                          subtitle: Text(vet.clinic ??
                              l10n.translate(AppStrings.notSpecified)),
                          onTap: () {
                            widget.onSelect(vet);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.translate(AppStrings.cancel)),
        ),
      ],
    );
  }
}
