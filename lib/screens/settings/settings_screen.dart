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
            subtitle: const Text('admin@rfid-troupeau.com'),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                if (_defaultVeterinarianId == null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 32, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.person_search,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.translate(AppStrings.noVeterinarianDefined),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _searchVeterinarian,
                                icon: const Icon(Icons.search),
                                label: Text(l10n.translate(AppStrings.search)),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _scanVeterinarianQR,
                                icon: const Icon(Icons.qr_code_scanner),
                                label: Text(l10n.translate(AppStrings.scanQr)),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
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
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: Colors.green.shade300, width: 2),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.green.shade100,
                          radius: 24,
                          child: Icon(
                            Icons.verified_user,
                            color: Colors.green.shade700,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedVetName ??
                                    l10n.translate(AppStrings.veterinarian),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _selectedVetOrg ?? '',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: _removeVeterinarian,
                          icon: const Icon(Icons.close, color: Colors.red),
                          tooltip: l10n.translate(AppStrings.remove),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _searchVeterinarian,
                          icon: const Icon(Icons.search),
                          label: Text(AppLocalizations.of(context)
                              .translate(AppStrings.changeVeterinarian)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
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
              padding: const EdgeInsets.only(left: 16),
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
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.format_size),
            title: Text(l10n.translate(AppStrings.textSize)),
            subtitle: Text('${(_textScale * 100).toInt()}%'),
            trailing: SizedBox(
              width: 150,
              child: Slider(
                value: _textScale,
                min: 0.8,
                max: 1.5,
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
            subtitle: Text(_getThemeColorName(_themeColor)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemeColorDialog(context),
          ),

          const Divider(),

          // Language Section
          const _SectionHeader(title: 'Langue / Language / اللغة'),

          _LanguageTile(
            title: 'Français',
            locale: const Locale('fr', ''),
            currentLocale: localeProvider.locale,
            onTap: () {
              localeProvider.setLocale(const Locale('fr', ''));
            },
          ),
          _LanguageTile(
            title: 'العربية',
            locale: const Locale('ar', ''),
            currentLocale: localeProvider.locale,
            onTap: () {
              localeProvider.setLocale(const Locale('ar', ''));
            },
          ),
          _LanguageTile(
            title: 'English',
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
              padding: const EdgeInsets.only(left: 16),
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
              // Navigate to sync_detail_screen.dart
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ouvrir sync_detail_screen.dart'),
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
            leading: const Icon(Icons.delete_sweep, color: Colors.red),
            title: Text(l10n.translate(AppStrings.clearLocalData),
                style: const TextStyle(color: Colors.red)),
            subtitle: Text(l10n.translate(AppStrings.deleteAllUnsyncedData)),
            trailing: const Icon(Icons.chevron_right, color: Colors.red),
            onTap: () => _showClearDataDialog(context),
          ),

          const Divider(),

          // About Section
          _SectionHeader(title: l10n.translate(AppStrings.about)),

          ListTile(
            leading: const Icon(Icons.info),
            title: Text(l10n.translate(AppStrings.version)),
            trailing: const Text('1.0.0+1 (MVP)'),
          ),

          ListTile(
            leading: const Icon(Icons.description),
            title: Text(l10n.translate(AppStrings.openSourceLicenses)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: 'RFID Troupeau',
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
          _SectionHeader(title: '${l10n.translate(AppStrings.debug)} (MVP)'),

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
                  backgroundColor: Colors.orange,
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.restore),
            title: Text(l10n.translate(AppStrings.resetPreferences)),
            onTap: () => _showResetPreferencesDialog(context),
          ),

          const SizedBox(height: 24),

          // Footer
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 80,
                  height: 80,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.pets,
                      size: 80,
                      color: Colors.grey.shade300,
                    );
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.translate(AppStrings.rfidTroupeau),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.translate(AppStrings.sheepManagementSystem),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _getThemeColorName(String color) {
    switch (color) {
      case 'blue':
        return 'Bleu';
      case 'green':
        return 'Vert';
      case 'purple':
        return 'Violet';
      case 'orange':
        return 'Orange';
      default:
        return 'Bleu';
    }
  }

  Future<void> _calculateCacheSize() async {
    // Simulate cache calculation
    setState(() {
      _cacheSize = 15728640; // 15 MB
    });
    await _savePreference('cache_size', _cacheSize);
  }

  // Dialog methods
  void _showProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profil utilisateur'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 40),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nom complet',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Modification du profil - À venir')),
              );
            },
            child: const Text('Modifier'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Changer le mot de passe'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Mot de passe actuel',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Nouveau mot de passe',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Confirmer le mot de passe',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Mot de passe modifié avec succès'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  void _showThemeColorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisir une couleur'),
        content: RadioGroup<String>(
          groupValue: _themeColor,
          onChanged: (newValue) {
            setState(() => _themeColor = newValue!);
            _savePreference('theme_color', newValue!);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Redémarrez l\'app pour appliquer la couleur'),
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _colorOption('Bleu', 'blue', Colors.blue),
              _colorOption('Vert', 'green', Colors.green),
              _colorOption('Violet', 'purple', Colors.purple),
              _colorOption('Orange', 'orange', Colors.orange),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _colorOption(String label, String value, Color color) {
    return RadioListTile<String>(
      title: Text(label),
      value: value,
      // groupValue et onChanged retirés (gérés par RadioGroup parent)
      secondary: CircleAvatar(
        backgroundColor: color,
        radius: 12,
      ),
    );
  }

  void _showAutoLockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Délai de verrouillage'),
        content: RadioGroup<int>(
          groupValue: _autoLockMinutes,
          onChanged: (value) {
            setState(() => _autoLockMinutes = value!);
            _savePreference('auto_lock_minutes', value!);
            Navigator.pop(context);
          },
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<int>(
                title: Text('1 minute'),
                value: 1,
              ),
              RadioListTile<int>(
                title: Text('5 minutes'),
                value: 5,
              ),
              RadioListTile<int>(
                title: Text('15 minutes'),
                value: 15,
              ),
              RadioListTile<int>(
                title: Text('30 minutes'),
                value: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showActiveSessionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sessions actives'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              leading: Icon(Icons.phone_android),
              title: Text('Cet appareil'),
              subtitle: Text('Actif maintenant'),
              trailing: Chip(
                label: Text('Actuel'),
                backgroundColor: Colors.green,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.tablet),
              title: const Text('Tablette Samsung'),
              subtitle: const Text('Il y a 2 heures'),
              trailing: IconButton(
                icon: const Icon(Icons.exit_to_app, color: Colors.red),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Session déconnectée'),
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
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vider le cache'),
        content: const Text(
          'Cela supprimera les fichiers temporaires et libérera de l\'espace. '
          'Vos données seront préservées.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _cacheSize = 0);
              _savePreference('cache_size', 0);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache vidé avec succès'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Vider'),
          ),
        ],
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Importer des données'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Fichier CSV'),
              subtitle: const Text('Importer depuis CSV'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Import CSV - À venir')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_present),
              title: const Text('Fichier Excel'),
              subtitle: const Text('Importer depuis Excel'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Import Excel - À venir')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exporter les données'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('CSV'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Export CSV - À venir')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('XML'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Export XML - À venir')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_present),
              title: const Text('Excel'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Export Excel - À venir')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Effacer les données ?'),
        content: const Text(
          'Cette action supprimera toutes les données locales non synchronisées. '
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fonctionnalité désactivée en MVP'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Effacer'),
          ),
        ],
      ),
    );
  }

  void _searchVeterinarian() {
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
              content: Text('${vet.fullName} défini par défaut'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  Future<void> _scanVeterinarianQR() async {
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
        content: Text('✅ ${selectedVet.fullName} validé'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
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
    final vetProvider = context.read<VeterinarianProvider>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sélectionner vétérinaire par défaut'),
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
                subtitle: Text(vet.clinic ?? 'Non spécifié'),
                trailing: vet.isDefault
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('default_veterinarian_id', vet.id);
                  setState(() => _defaultVeterinarianId = vet.id);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${vet.fullName} défini par défaut'),
                      backgroundColor: Colors.green,
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
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Politique de confidentialité'),
        content: const SingleChildScrollView(
          child: Text(
            'RFID Troupeau respecte votre vie privée.\n\n'
            '• Toutes les données sont stockées localement sur votre appareil\n'
            '• La synchronisation est sécurisée via HTTPS/TLS\n'
            '• Aucune donnée n\'est partagée avec des tiers\n'
            '• Vous contrôlez entièrement vos données\n'
            '• Nous ne collectons aucune donnée personnelle sans votre consentement\n\n'
            'Pour plus d\'informations, contactez: support@rfid-troupeau.com',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Conditions d\'utilisation'),
        content: const SingleChildScrollView(
          child: Text(
            'CONDITIONS D\'UTILISATION\n\n'
            '1. Acceptation des conditions\n'
            'En utilisant RFID Troupeau, vous acceptez ces conditions.\n\n'
            '2. Utilisation du service\n'
            'Le service est fourni "tel quel" pour la gestion de troupeaux.\n\n'
            '3. Responsabilités\n'
            'Vous êtes responsable de la précision des données saisies.\n\n'
            '4. Propriété intellectuelle\n'
            'Tous les droits sont réservés.\n\n'
            '5. Limitation de responsabilité\n'
            'Nous ne sommes pas responsables des pertes de données.\n\n'
            'Version: 1.0.0\n'
            'Dernière mise à jour: Octobre 2025',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aide et support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Besoin d\'aide ?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text('support@rfid-troupeau.com'),
              dense: true,
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Téléphone'),
              subtitle: Text('+33 1 23 45 67 89'),
              dense: true,
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Site web'),
              subtitle: Text('www.rfid-troupeau.com'),
              dense: true,
            ),
            SizedBox(height: 12),
            Text(
              'Horaires: Lun-Ven 9h-18h',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Envoi d\'email - À venir')),
              );
            },
            child: const Text('Nous contacter'),
          ),
        ],
      ),
    );
  }

  void _showResetPreferencesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Réinitialiser les préférences'),
        content: const Text(
          'Cela réinitialisera tous les paramètres aux valeurs par défaut. '
          'Vos données ne seront pas affectées.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
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
                const SnackBar(
                  content: Text('Préférences réinitialisées'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Réinitialiser'),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 1.2,
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
      trailing:
          isSelected ? const Icon(Icons.check, color: Colors.green) : null,
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
    return AlertDialog(
      title: const Text('Rechercher un vétérinaire'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Rechercher',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterVets,
            ),
            const SizedBox(height: 16),
            Flexible(
              child: _filtered.isEmpty
                  ? const Center(child: Text('Aucun vétérinaire trouvé'))
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
                          subtitle: Text(vet.clinic ?? 'Non spécifié'),
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
          child: const Text('Annuler'),
        ),
      ],
    );
  }
}
