// lib/screens/settings/account_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../i18n/app_localizations.dart';
import '../../i18n/app_strings.dart';
import '../../utils/constants.dart';

/// Screen for Account Settings
///
/// Contains two main sections:
/// - 👤 PROFIL (full name, email, modify button)
/// - 🔐 MOT DE PASSE (current, new, confirm password fields)
class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate(AppStrings.myAccount)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        children: [
          // ==========================================
          // SECTION 1: PROFIL
          // ==========================================
          _SectionHeader(
            icon: Icons.person,
            title: l10n.translate(AppStrings.profile),
          ),
          const SizedBox(height: AppConstants.spacingSmall),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingMedium),
              child: Column(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: AppConstants.avatarRadiusLarge,
                    backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.person,
                      size: AppConstants.avatarRadiusLarge,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingMedium),

                  // Full Name
                  _ProfileField(
                    icon: Icons.person_outline,
                    label: l10n.translate(AppStrings.fullName),
                    value: authProvider.currentUserName ?? l10n.translate(AppStrings.notDefined),
                  ),
                  const SizedBox(height: AppConstants.spacingSmall),

                  // Email
                  _ProfileField(
                    icon: Icons.email_outlined,
                    label: l10n.translate(AppStrings.email),
                    value: authProvider.currentUserEmail ?? l10n.translate(AppStrings.adminEmail),
                  ),
                  const SizedBox(height: AppConstants.spacingMedium),

                  // Modify Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _showEditProfileDialog,
                      icon: const Icon(Icons.edit),
                      label: Text(l10n.translate(AppStrings.modify)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.spacingSmall,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppConstants.spacingLarge),

          // ==========================================
          // SECTION 2: MOT DE PASSE
          // ==========================================
          _SectionHeader(
            icon: Icons.lock,
            title: l10n.translate(AppStrings.password),
          ),
          const SizedBox(height: AppConstants.spacingSmall),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current Password
                  TextField(
                    controller: _currentPasswordController,
                    obscureText: _obscureCurrentPassword,
                    decoration: InputDecoration(
                      labelText: l10n.translate(AppStrings.currentPassword),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureCurrentPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureCurrentPassword = !_obscureCurrentPassword;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingSmall),

                  // New Password
                  TextField(
                    controller: _newPasswordController,
                    obscureText: _obscureNewPassword,
                    decoration: InputDecoration(
                      labelText: l10n.translate(AppStrings.newPassword),
                      prefixIcon: const Icon(Icons.lock_reset),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingSmall),

                  // Confirm Password
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      labelText: l10n.translate(AppStrings.confirmPassword),
                      prefixIcon: const Icon(Icons.lock_clock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingMedium),

                  // Change Password Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _changePassword,
                      icon: const Icon(Icons.check_circle),
                      label: Text(l10n.translate(AppStrings.changePassword)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.spacingSmall,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppConstants.spacingSmall),

                  // Info Box
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingSmall),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue.shade700,
                          size: AppConstants.iconSizeRegular,
                        ),
                        const SizedBox(width: AppConstants.spacingSmall),
                        Expanded(
                          child: Text(
                            l10n.translate(AppStrings.passwordRequirements),
                            style: const TextStyle(fontSize: AppConstants.fontSizeSmall),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.translate(AppStrings.editProfile)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: l10n.translate(AppStrings.fullName),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: AppConstants.spacingSmall),
            TextField(
              decoration: InputDecoration(
                labelText: l10n.translate(AppStrings.email),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
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
                  content: Text(l10n.translate(AppStrings.profileEditComingSoon)),
                  backgroundColor: AppConstants.successGreen,
                ),
              );
            },
            child: Text(l10n.translate(AppStrings.save)),
          ),
        ],
      ),
    );
  }

  void _changePassword() {
    final l10n = AppLocalizations.of(context);

    // Validation
    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.translate(AppStrings.fillAllFields)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.translate(AppStrings.passwordsDoNotMatch)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: Implement actual password change logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.translate(AppStrings.passwordChangedSuccess)),
        backgroundColor: AppConstants.successGreen,
      ),
    );

    // Clear fields
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }
}

// ==========================================
// REUSABLE WIDGETS
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
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: AppConstants.iconSizeMedium,
        ),
        const SizedBox(width: AppConstants.spacingSmall),
        Text(
          title,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeImportant,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _ProfileField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileField({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingSmall),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: AppConstants.iconSizeRegular,
          ),
          const SizedBox(width: AppConstants.spacingSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingTiny),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeBody,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
