// lib/screens/settings/app_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/sync_provider.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';

/// App Settings Screen - shown as ModalBottomSheet
///
/// Contains:
/// - 🔔 Notifications
/// - 🎨 Apparence
/// - 🌍 Langue
/// - 🔒 Sécurité
/// - 💾 Stockage & Sync
/// - ℹ️ À propos
class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  /// Show this screen as a modal bottom sheet
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AppSettingsScreen(),
    );
  }

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
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

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppConstants.borderRadiusLarge),
        ),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: AppConstants.spacingSmall),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMedium),
                child: Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: Theme.of(context).primaryColor,
                      size: AppConstants.iconSizeMedium,
                    ),
                    const SizedBox(width: AppConstants.spacingSmall),
                    Text(
                      l10n.translate(AppStrings.settings),
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingMedium,
                  ),
                  children: [
                    const SizedBox(height: AppConstants.spacingSmall),

                    // Notifications Section
                    _buildNotificationsSection(l10n),
                    const Divider(),

                    // Appearance Section
                    _buildAppearanceSection(l10n),
                    const Divider(),

                    // Language Section
                    _buildLanguageSection(l10n, localeProvider),
                    const Divider(),

                    // Security Section
                    _buildSecuritySection(l10n),
                    const Divider(),

                    // Storage & Sync Section
                    _buildStorageSection(l10n),
                    const Divider(),

                    // About Section
                    _buildAboutSection(l10n),

                    const SizedBox(height: AppConstants.spacingLarge),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNotificationsSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.notifications,
          title: l10n.translate(AppStrings.notifications),
        ),
        const SizedBox(height: AppConstants.spacingSmall),
        SwitchListTile(
          title: Text(l10n.translate(AppStrings.enableNotifications)),
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() => _notificationsEnabled = value);
            _savePreference('notifications_enabled', value);
          },
        ),
        SwitchListTile(
          title: Text(l10n.translate(AppStrings.treatmentReminders)),
          value: _treatmentReminders,
          enabled: _notificationsEnabled,
          onChanged: (value) {
            setState(() => _treatmentReminders = value);
            _savePreference('treatment_reminders', value);
          },
        ),
        SwitchListTile(
          title: Text(l10n.translate(AppStrings.withdrawalAlerts)),
          value: _withdrawalAlerts,
          enabled: _notificationsEnabled,
          onChanged: (value) {
            setState(() => _withdrawalAlerts = value);
            _savePreference('withdrawal_alerts', value);
          },
        ),
        SwitchListTile(
          title: Text(l10n.translate(AppStrings.campaignNotifications)),
          value: _campaignNotifications,
          enabled: _notificationsEnabled,
          onChanged: (value) {
            setState(() => _campaignNotifications = value);
            _savePreference('campaign_notifications', value);
          },
        ),
        SwitchListTile(
          title: Text(l10n.translate(AppStrings.sound)),
          value: _soundEnabled,
          enabled: _notificationsEnabled,
          onChanged: (value) {
            setState(() => _soundEnabled = value);
            _savePreference('sound_enabled', value);
          },
        ),
        SwitchListTile(
          title: Text(l10n.translate(AppStrings.vibration)),
          value: _vibrationEnabled,
          enabled: _notificationsEnabled,
          onChanged: (value) {
            setState(() => _vibrationEnabled = value);
            _savePreference('vibration_enabled', value);
          },
        ),
      ],
    );
  }

  Widget _buildAppearanceSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.palette,
          title: l10n.translate(AppStrings.appearance),
        ),
        const SizedBox(height: AppConstants.spacingSmall),
        SwitchListTile(
          title: Text(l10n.translate(AppStrings.darkMode)),
          subtitle: Text(l10n.translate(AppStrings.enableDarkMode)),
          value: _darkMode,
          onChanged: (value) {
            setState(() => _darkMode = value);
            _savePreference('dark_mode', value);
          },
        ),
        ListTile(
          title: Text(l10n.translate(AppStrings.textSize)),
          subtitle: Slider(
            value: _textScale,
            min: 0.8,
            max: 1.5,
            divisions: 7,
            label: _textScale.toStringAsFixed(1),
            onChanged: (value) {
              setState(() => _textScale = value);
              _savePreference('text_scale', value);
            },
          ),
        ),
        ListTile(
          title: Text(l10n.translate(AppStrings.themeColor)),
          subtitle: Text(_getThemeColorName(context, _themeColor)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showThemeColorDialog(context),
        ),
      ],
    );
  }

  Widget _buildLanguageSection(AppLocalizations l10n, LocaleProvider localeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.language,
          title: l10n.translate(AppStrings.languageSection),
        ),
        const SizedBox(height: AppConstants.spacingSmall),
        RadioListTile<String>(
          title: const Text('Français'),
          value: 'fr',
          groupValue: localeProvider.locale.languageCode,
          onChanged: (value) => localeProvider.setLocale(const Locale('fr')),
        ),
        RadioListTile<String>(
          title: const Text('العربية'),
          value: 'ar',
          groupValue: localeProvider.locale.languageCode,
          onChanged: (value) => localeProvider.setLocale(const Locale('ar')),
        ),
      ],
    );
  }

  Widget _buildSecuritySection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.security,
          title: l10n.translate(AppStrings.security),
        ),
        const SizedBox(height: AppConstants.spacingSmall),
        SwitchListTile(
          title: Text(l10n.translate(AppStrings.biometricAuth)),
          subtitle: Text(l10n.translate(AppStrings.useFingerprintFaceId)),
          value: _biometricEnabled,
          onChanged: (value) {
            setState(() => _biometricEnabled = value);
            _savePreference('biometric_enabled', value);
          },
        ),
        SwitchListTile(
          title: Text(l10n.translate(AppStrings.autoLock)),
          subtitle: Text(l10n.translate(AppStrings.lockAppInactivity)),
          value: _autoLock,
          onChanged: (value) {
            setState(() => _autoLock = value);
            _savePreference('auto_lock', value);
          },
        ),
        if (_autoLock)
          ListTile(
            title: Text(l10n.translate(AppStrings.autoLockTime)),
            subtitle: Text(_getAutoLockTimeLabel(l10n, _autoLockMinutes)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showAutoLockDialog(context),
          ),
      ],
    );
  }

  Widget _buildStorageSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.storage,
          title: l10n.translate(AppStrings.storageData),
        ),
        const SizedBox(height: AppConstants.spacingSmall),
        ListTile(
          leading: const Icon(Icons.sync),
          title: Text(l10n.translate(AppStrings.synchronization)),
          subtitle: Consumer<SyncProvider>(
            builder: (context, syncProvider, child) {
              return Text(
                syncProvider.isSyncing
                    ? l10n.translate(AppStrings.syncInProgress)
                    : l10n.translate(AppStrings.syncOnDemand),
              );
            },
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.translate(AppStrings.openSyncScreen)),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.cleaning_services),
          title: Text(l10n.translate(AppStrings.clearCache)),
          subtitle: Text('${(_cacheSize / 1024).toStringAsFixed(1)} MB'),
          trailing: TextButton(
            onPressed: _calculateCacheSize,
            child: Text(l10n.translate(AppStrings.clear)),
          ),
        ),
        SwitchListTile(
          title: Text(l10n.translate(AppStrings.automaticBackup)),
          subtitle: Text(l10n.translate(AppStrings.backupDailyCloud)),
          value: _autoBackup,
          onChanged: (value) {
            setState(() => _autoBackup = value);
            _savePreference('auto_backup', value);
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          icon: Icons.info,
          title: l10n.translate(AppStrings.about),
        ),
        const SizedBox(height: AppConstants.spacingSmall),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(l10n.translate(AppStrings.appVersion)),
          subtitle: const Text('1.0.0 (Build 1)'),
        ),
        ListTile(
          leading: const Icon(Icons.description),
          title: Text(l10n.translate(AppStrings.privacyPolicy)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showPrivacyPolicy(context),
        ),
        ListTile(
          leading: const Icon(Icons.gavel),
          title: Text(l10n.translate(AppStrings.termsOfService)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showTermsOfService(context),
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: Text(l10n.translate(AppStrings.needHelp)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showContactSupport(context),
        ),
      ],
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

  String _getAutoLockTimeLabel(AppLocalizations l10n, int minutes) {
    switch (minutes) {
      case 1:
        return l10n.translate(AppStrings.oneMinute);
      case 5:
        return l10n.translate(AppStrings.fiveMinutes);
      case 15:
        return l10n.translate(AppStrings.fifteenMinutes);
      case 30:
        return l10n.translate(AppStrings.thirtyMinutes);
      default:
        return l10n.translate(AppStrings.fiveMinutes);
    }
  }

  Future<void> _calculateCacheSize() async {
    setState(() {
      _cacheSize = AppConstants.mockCacheSize;
    });
    await _savePreference('cache_size', _cacheSize);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).translate(AppStrings.cacheCleared)),
        backgroundColor: AppConstants.successGreen,
      ),
    );
  }

  void _showThemeColorDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate(AppStrings.chooseColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ColorOption('blue', l10n.translate(AppStrings.colorBlue), Colors.blue),
            _ColorOption('green', l10n.translate(AppStrings.colorGreen), Colors.green),
            _ColorOption('purple', l10n.translate(AppStrings.colorPurple), Colors.purple),
            _ColorOption('orange', l10n.translate(AppStrings.colorOrange), Colors.orange),
          ].map((option) {
            return RadioListTile<String>(
              title: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: option.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingSmall),
                  Text(option.name),
                ],
              ),
              value: option.value,
              groupValue: _themeColor,
              onChanged: (value) {
                setState(() => _themeColor = value!);
                _savePreference('theme_color', value!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAutoLockDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate(AppStrings.autoLockTime)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [1, 5, 15, 30].map((minutes) {
            return RadioListTile<int>(
              title: Text(_getAutoLockTimeLabel(l10n, minutes)),
              value: minutes,
              groupValue: _autoLockMinutes,
              onChanged: (value) {
                setState(() => _autoLockMinutes = value!);
                _savePreference('auto_lock_minutes', value!);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
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

  void _showTermsOfService(BuildContext context) {
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

  void _showContactSupport(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate(AppStrings.contactUs)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(l10n.translate(AppStrings.supportEmail)),
              subtitle: const Text('support@tracabilite.dz'),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(l10n.translate(AppStrings.supportPhone)),
              subtitle: const Text('+213 XX XX XX XX'),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: Text(l10n.translate(AppStrings.businessHours)),
              subtitle: const Text('Lun-Ven: 9h-17h'),
              contentPadding: EdgeInsets.zero,
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
}

// ==========================================
// HELPER WIDGETS
// ==========================================

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingSmall),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: AppConstants.iconSizeRegular,
          ),
          const SizedBox(width: AppConstants.spacingSmall),
          Text(
            title,
            style: TextStyle(
              fontSize: AppConstants.fontSizeSectionTitle,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorOption {
  final String value;
  final String name;
  final Color color;

  _ColorOption(this.value, this.name, this.color);
}
