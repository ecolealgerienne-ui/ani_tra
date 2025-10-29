// lib/utils/navigation_helper.dart
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/scan_screen.dart';
import '../screens/animal_list_screen.dart';
import '../screens/campaign_list_screen.dart';
import '../screens/movements_screen.dart';
import '../screens/sync_screen.dart';
import '../screens/settings_screen.dart';

class NavigationHelper {
  // Navigate to screen
  static void navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  // Navigate and replace
  static void navigateAndReplace(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  // Navigate to named screens
  static void navigateToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  static void navigateToScan(BuildContext context) {
    navigateTo(context, const ScanScreen());
  }

  static void navigateToAnimals(BuildContext context) {
    navigateTo(context, const AnimalListScreen());
  }

  static void navigateToCampaigns(BuildContext context) {
    navigateTo(context, const CampaignListScreen());
  }

  static void navigateToMovements(BuildContext context) {
    navigateTo(context, const MovementsScreen());
  }

  static void navigateToSync(BuildContext context) {
    navigateTo(context, const SyncScreen());
  }

  static void navigateToSettings(BuildContext context) {
    navigateTo(context, const SettingsScreen());
  }

  // Show confirmation dialog
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirmer',
    String cancelText = 'Annuler',
    bool isDangerous = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDangerous ? Colors.red : null,
              foregroundColor: isDangerous ? Colors.white : null,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // Show snackbar
  static void showSnackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.green);
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.red);
  }

  static void showWarningSnackBar(BuildContext context, String message) {
    showSnackBar(context, message, backgroundColor: Colors.orange);
  }
}
