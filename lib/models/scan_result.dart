// lib/models/scan_result.dart

import 'package:collection/collection.dart';
import 'animal.dart';

/// Types d'identifiants scannables
enum ScanType {
  eid, // EID électronique (FR + 10 chiffres)
  officialNumber, // Numéro officiel seul
  passport, // Code-barres passeport complet
  visualId, // ID visuel personnalisé
  qrCode, // QR code (futur)
  unknown, // Non reconnu
}

/// Résultat d'un scan
class ScanResult {
  final String rawValue;
  final ScanType type;
  final DateTime scannedAt;
  final Map<String, String> parsedData;

  ScanResult({
    required this.rawValue,
    required this.type,
    required this.scannedAt,
    this.parsedData = const {},
  });

  /// Parse le résultat selon le type
  factory ScanResult.parse(String value) {
    final now = DateTime.now();

    // Détection EID : FR + 10 chiffres
    if (RegExp(r'^FR\d{10}$', caseSensitive: false).hasMatch(value)) {
      return ScanResult(
        rawValue: value,
        type: ScanType.eid,
        scannedAt: now,
        parsedData: {'eid': value.toUpperCase()},
      );
    }

    // Détection code-barres passeport
    // Format standard EU : 276FRXXXXXXXXXXYYYY
    if (RegExp(r'^276FR\d{12,16}$').hasMatch(value)) {
      final eid = 'FR${value.substring(5, 15)}';
      final official = value.substring(15);

      return ScanResult(
        rawValue: value,
        type: ScanType.passport,
        scannedAt: now,
        parsedData: {
          'eid': eid,
          'officialNumber': official,
        },
      );
    }

    // Détection numéro officiel seul (8-10 chiffres)
    if (RegExp(r'^\d{8,10}$').hasMatch(value)) {
      return ScanResult(
        rawValue: value,
        type: ScanType.officialNumber,
        scannedAt: now,
        parsedData: {'officialNumber': value},
      );
    }

    // Sinon = ID visuel personnalisé
    return ScanResult(
      rawValue: value,
      type: ScanType.visualId,
      scannedAt: now,
      parsedData: {'visualId': value},
    );
  }

  /// Recherche un animal correspondant
  Animal? findMatchingAnimal(List<Animal> animals) {
    return animals.firstWhereOrNull((animal) {
      switch (type) {
        case ScanType.eid:
          return animal.currentEid == parsedData['eid'];
        case ScanType.officialNumber:
          return animal.officialNumber == parsedData['officialNumber'];
        case ScanType.passport:
          return animal.currentEid == parsedData['eid'] ||
              animal.officialNumber == parsedData['officialNumber'];
        case ScanType.visualId:
          return animal.visualId == parsedData['visualId'];
        default:
          return false;
      }
    });
  }

  @override
  String toString() {
    return 'ScanResult(type: $type, rawValue: $rawValue, parsedData: $parsedData)';
  }
}
