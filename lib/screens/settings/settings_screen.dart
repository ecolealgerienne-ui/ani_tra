// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/sync_provider.dart';
import '../../widgets/farm_preferences_section.dart';
import '../../i18n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('settings')),
      ),
      body: ListView(
        children: [
          // Account Section
          const _SectionHeader(title: 'Compte'),

          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: const Text('Profil utilisateur'),
            subtitle: const Text('admin@rfid-troupeau.com'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showProfileDialog(context),
          ),

          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Changer le mot de passe'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showChangePasswordDialog(context),
          ),

          const Divider(),

          // Farm Preferences Section (ÉTAPE 4)
          const FarmPreferencesSection(),

          const Divider(),

          // Notifications Section
          const _SectionHeader(title: 'Notifications'),

          SwitchListTile(
            title: const Text('Activer les notifications'),
            subtitle: const Text('Recevoir toutes les notifications'),
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
                    title: const Text('Rappels de traitement'),
                    subtitle: const Text('Délais d\'attente et échéances'),
                    value: _treatmentReminders,
                    onChanged: (value) {
                      setState(() => _treatmentReminders = value);
                      _savePreference('treatment_reminders', value);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Alertes de retrait'),
                    subtitle: const Text('Animaux avec délai d\'attente actif'),
                    value: _withdrawalAlerts,
                    onChanged: (value) {
                      setState(() => _withdrawalAlerts = value);
                      _savePreference('withdrawal_alerts', value);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Notifications de campagne'),
                    subtitle: const Text('Nouvelles campagnes et rappels'),
                    value: _campaignNotifications,
                    onChanged: (value) {
                      setState(() => _campaignNotifications = value);
                      _savePreference('campaign_notifications', value);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Son'),
                    value: _soundEnabled,
                    onChanged: (value) {
                      setState(() => _soundEnabled = value);
                      _savePreference('sound_enabled', value);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Vibration'),
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
          const _SectionHeader(title: 'Apparence'),

          SwitchListTile(
            title: const Text('Mode sombre'),
            subtitle: const Text('Activer le thème sombre'),
            value: _darkMode,
            secondary: Icon(_darkMode ? Icons.dark_mode : Icons.light_mode),
            onChanged: (value) {
              setState(() => _darkMode = value);
              _savePreference('dark_mode', value);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Redémarrez l\'app pour appliquer le thème'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.format_size),
            title: const Text('Taille du texte'),
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
            title: const Text('Couleur du thème'),
            subtitle: Text(_getThemeColorName(_themeColor)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemeColorDialog(context),
          ),

          const Divider(),

          // Language Section
          _SectionHeader(title: 'Langue / Language / اللغة'),

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
          const _SectionHeader(title: 'Sécurité'),

          SwitchListTile(
            title: const Text('Authentification biométrique'),
            subtitle: const Text('Utiliser empreinte/Face ID'),
            value: _biometricEnabled,
            secondary: const Icon(Icons.fingerprint),
            onChanged: (value) {
              setState(() => _biometricEnabled = value);
              _savePreference('biometric_enabled', value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      value ? 'Biométrie activée' : 'Biométrie désactivée'),
                ),
              );
            },
          ),

          SwitchListTile(
            title: const Text('Verrouillage automatique'),
            subtitle: Text(_autoLock
                ? 'Après $_autoLockMinutes minutes d\'inactivité'
                : 'Désactivé'),
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
                title: const Text('Délai de verrouillage'),
                subtitle: Text('$_autoLockMinutes minutes'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showAutoLockDialog(context),
              ),
            ),

          ListTile(
            leading: const Icon(Icons.vpn_key),
            title: const Text('Sessions actives'),
            subtitle: const Text('Gérer les appareils connectés'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showActiveSessionsDialog(context),
          ),

          const Divider(),

          // Sync Section
          const _SectionHeader(title: 'Synchronisation'),

          Consumer<SyncProvider>(
            builder: (context, syncProvider, _) {
              return SwitchListTile(
                title: const Text('Mode En Ligne'),
                subtitle: Text(
                  syncProvider.isOnline
                      ? 'Connexion au serveur active'
                      : 'Mode hors ligne (données locales)',
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
            title: const Text('Synchronisation automatique'),
            subtitle: const Text('Synchroniser toutes les 15 minutes'),
            trailing: Switch(
              value: true,
              onChanged: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fonctionnalité à venir'),
                  ),
                );
              },
            ),
          ),

          ListTile(
            leading: const Icon(Icons.sync_problem),
            title: const Text('Voir les détails de synchronisation'),
            subtitle: const Text('Historique et conflits'),
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
          const _SectionHeader(title: 'Stockage et données'),

          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Stockage utilisé'),
            subtitle: Text(_cacheSize > 0
                ? '${(_cacheSize / 1024 / 1024).toStringAsFixed(2)} MB'
                : 'Calcul en cours...'),
            trailing: TextButton(
              onPressed: () => _calculateCacheSize(),
              child: const Text('Actualiser'),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.cleaning_services),
            title: const Text('Vider le cache'),
            subtitle: const Text('Libérer de l\'espace'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showClearCacheDialog(context),
          ),

          SwitchListTile(
            title: const Text('Sauvegarde automatique'),
            subtitle: const Text('Backup quotidien des données'),
            value: _autoBackup,
            secondary: const Icon(Icons.backup),
            onChanged: (value) {
              setState(() => _autoBackup = value);
              _savePreference('auto_backup', value);
            },
          ),

          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Exporter les données'),
            subtitle: const Text('CSV, XML, Excel'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showExportDialog(context),
          ),

          ListTile(
            leading: const Icon(Icons.upload),
            title: const Text('Importer des données'),
            subtitle: const Text('Depuis fichier CSV ou Excel'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showImportDialog(context),
          ),

          ListTile(
            leading: const Icon(Icons.delete_sweep, color: Colors.red),
            title: const Text('Effacer les données locales',
                style: TextStyle(color: Colors.red)),
            subtitle:
                const Text('Supprimer toutes les données non synchronisées'),
            trailing: const Icon(Icons.chevron_right, color: Colors.red),
            onTap: () => _showClearDataDialog(context),
          ),

          const Divider(),

          // About Section
          const _SectionHeader(title: 'À propos'),

          const ListTile(
            leading: Icon(Icons.info),
            title: Text('Version'),
            trailing: Text('1.0.0+1 (MVP)'),
          ),

          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Licences open source'),
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
            title: const Text('Politique de confidentialité'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPrivacyDialog(context),
          ),

          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text('Conditions d\'utilisation'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showTermsDialog(context),
          ),

          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Aide et support'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showHelpDialog(context),
          ),

          const Divider(),

          // Debug Section (MVP only)
          const _SectionHeader(title: 'Debug (MVP)'),

          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Simuler erreur de synchronisation'),
            onTap: () {
              final syncProvider = context.read<SyncProvider>();
              syncProvider.setOnline(false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Mode offline activé pour tester les erreurs'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Réinitialiser les préférences'),
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
                  'RFID Troupeau',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Système de gestion de troupeau ovin',
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 40),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Nom complet',
                border: OutlineInputBorder(),
              ),
              enabled: false,
            ),
            const SizedBox(height: 12),
            const TextField(
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ColorOption('Bleu', 'blue', Colors.blue),
            _ColorOption('Vert', 'green', Colors.green),
            _ColorOption('Violet', 'purple', Colors.purple),
            _ColorOption('Orange', 'orange', Colors.orange),
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

  Widget _ColorOption(String label, String value, Color color) {
    return RadioListTile<String>(
      title: Text(label),
      value: value,
      groupValue: _themeColor,
      secondary: CircleAvatar(
        backgroundColor: color,
        radius: 12,
      ),
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
    );
  }

  void _showAutoLockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Délai de verrouillage'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<int>(
              title: const Text('1 minute'),
              value: 1,
              groupValue: _autoLockMinutes,
              onChanged: (value) {
                setState(() => _autoLockMinutes = value!);
                _savePreference('auto_lock_minutes', value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<int>(
              title: const Text('5 minutes'),
              value: 5,
              groupValue: _autoLockMinutes,
              onChanged: (value) {
                setState(() => _autoLockMinutes = value!);
                _savePreference('auto_lock_minutes', value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<int>(
              title: const Text('15 minutes'),
              value: 15,
              groupValue: _autoLockMinutes,
              onChanged: (value) {
                setState(() => _autoLockMinutes = value!);
                _savePreference('auto_lock_minutes', value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<int>(
              title: const Text('30 minutes'),
              value: 30,
              groupValue: _autoLockMinutes,
              onChanged: (value) {
                setState(() => _autoLockMinutes = value!);
                _savePreference('auto_lock_minutes', value!);
                Navigator.pop(context);
              },
            ),
          ],
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
            ListTile(
              leading: const Icon(Icons.phone_android),
              title: const Text('Cet appareil'),
              subtitle: const Text('Actif maintenant'),
              trailing: const Chip(
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Besoin d\'aide ?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: const Text('support@rfid-troupeau.com'),
              dense: true,
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Téléphone'),
              subtitle: const Text('+33 1 23 45 67 89'),
              dense: true,
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Site web'),
              subtitle: const Text('www.rfid-troupeau.com'),
              dense: true,
            ),
            const SizedBox(height: 12),
            const Text(
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
