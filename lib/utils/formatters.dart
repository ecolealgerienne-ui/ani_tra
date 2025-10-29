// lib/utils/formatters.dart
import 'package:intl/intl.dart';

class AppFormatters {
  // Date formatters
  static final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat timeFormat = DateFormat('HH:mm');

  static String formatDate(DateTime date) {
    return dateFormat.format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return dateTimeFormat.format(dateTime);
  }

  static String formatTime(DateTime time) {
    return timeFormat.format(time);
  }

  // Relative time
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes}min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays}j';
    } else {
      return formatDate(dateTime);
    }
  }

  // Currency
  static String formatCurrency(double amount, {String symbol = '€'}) {
    return '${amount.toStringAsFixed(2)} $symbol';
  }

  // EID formatting
  static String formatEID(String eid) {
    if (eid.length <= 12) return eid;
    return '${eid.substring(0, 3)} ${eid.substring(3, 7)} ${eid.substring(7, 11)} ${eid.substring(11)}';
  }

  // Truncate EID for display
  static String truncateEID(String eid, {int maxLength = 15}) {
    if (eid.length <= maxLength) return eid;
    return '${eid.substring(0, maxLength)}...';
  }

  // Age formatting
  static String formatAge(int ageInDays) {
    if (ageInDays < 30) {
      return '$ageInDays jours';
    } else if (ageInDays < 365) {
      final months = (ageInDays / 30).floor();
      return '$months mois';
    } else {
      final years = (ageInDays / 365).floor();
      final months = ((ageInDays % 365) / 30).floor();
      if (months == 0) {
        return '$years an${years > 1 ? 's' : ''}';
      }
      return '$years an${years > 1 ? 's' : ''} $months mois';
    }
  }
}
