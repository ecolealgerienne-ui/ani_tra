// lib/utils/extensions.dart
import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  // Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  // Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  // Check if date is in current week
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek) && isBefore(endOfWeek);
  }

  // Format as relative string
  String toRelativeString() {
    if (isToday) return 'Aujourd\'hui';
    if (isYesterday) return 'Hier';

    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    }

    return DateFormat('dd/MM/yyyy').format(this);
  }

  // Start of day
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  // End of day
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59);
  }
}

extension StringExtensions on String {
  // Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  // Truncate with ellipsis
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  // Remove all whitespace
  String get removeWhitespace {
    return replaceAll(RegExp(r'\s+'), '');
  }

  // Validate EID format
  bool get isValidEID {
    final clean = removeWhitespace;
    return clean.length == 15 && RegExp(r'^\d{15}$').hasMatch(clean);
  }
}

extension ListExtensions<T> on List<T> {
  // Safely get element or null
  T? getOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  // Chunk list into smaller lists
  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }
}
