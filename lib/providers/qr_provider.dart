// lib/providers/qr_provider.dart
import 'package:flutter/material.dart';

/// Provider responsable de la validation et de la gestion des QR codes.
/// Compatible multi-langue : les erreurs utilisent des clés de traduction.
class QRProvider extends ChangeNotifier {
  // ===== Constantes (préfixes techniques et clés i18n) =====
  static const String kPrefixAnimal = 'QR_ANIMAL_';
  static const String kPrefixVet = 'QR_VET_';

  static const String kErrAnimalIdMissing = 'qr.error.animal_id_missing';
  static const String kErrVetIdMissing = 'qr.error.vet_id_missing';
  static const String kErrUnrecognized = 'qr.error.unrecognized';
  static const String kErrUnknown = 'qr.error.unknown';

  String? _lastScannedQR;
  Map<String, dynamic>? _validatedUser;
  bool _isValidating = false;
  String? _validationErrorKey; // clé de traduction (pas de texte brut)

  // Getters
  String? get lastScannedQR => _lastScannedQR;
  Map<String, dynamic>? get validatedUser => _validatedUser;
  bool get isValidating => _isValidating;
  String? get validationErrorKey => _validationErrorKey;

  /// Définir explicitement le dernier QR scanné
  void setLastScannedQR(String data) {
    _lastScannedQR = data;
    notifyListeners();
  }

  /// Valide et parse un QR. Gère trois formats connus :
  /// - `QR_ANIMAL_<ID>`
  /// - `QR_VET_<ID>`
  /// - autres (non reconnu)
  ///
  /// Les erreurs renvoient des **clés de traduction** :
  /// - "qr.error.animal_id_missing"
  /// - "qr.error.vet_id_missing"
  /// - "qr.error.unrecognized"
  Future<void> validateAndParseQR(String qr) async {
    _isValidating = true;
    _validationErrorKey = null;
    _validatedUser = null;
    _lastScannedQR = qr;
    notifyListeners();

    try {
      await Future<void>.delayed(const Duration(milliseconds: 120));

      if (qr.startsWith(kPrefixAnimal)) {
        final idPart = qr.substring(kPrefixAnimal.length).trim();
        if (idPart.isEmpty) {
          throw const FormatException(kErrAnimalIdMissing);
        }
        // Map mutable (pas de const ici puisqu'on ajoute un champ variable)
        _validatedUser = <String, dynamic>{
          'type': 'ANIMAL',
          'id': idPart,
        };
      } else if (qr.startsWith(kPrefixVet)) {
        final idPart = qr.substring(kPrefixVet.length).trim();
        if (idPart.isEmpty) {
          throw const FormatException(kErrVetIdMissing);
        }
        _validatedUser = <String, dynamic>{
          'type': 'VET',
          'id': idPart,
        };
      } else {
        throw const FormatException(kErrUnrecognized);
      }
    } catch (e) {
      // Si FormatException → message = clé i18n portée par l’exception
      if (e is FormatException) {
        _validationErrorKey = e.message;
      } else {
        _validationErrorKey = kErrUnknown;
      }
    } finally {
      _isValidating = false;
      notifyListeners();
    }
  }

  /// Génère un QR factice selon un type demandé (utile pour tests/démo).
  /// Types acceptés : 'ANIMAL', 'VET', 'OTHER'
  String generateDummyQR(String type) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    switch (type.toUpperCase()) {
      case 'ANIMAL':
        return '$kPrefixAnimal$timestamp';
      case 'VET':
        return '${kPrefixVet}${timestamp}_VALID';
      default:
        return 'QR_INVALID_$timestamp';
    }
  }

  /// Réinitialise l’état complet du provider
  void clearValidation() {
    _lastScannedQR = null;
    _validatedUser = null;
    _validationErrorKey = null;
    notifyListeners();
  }
}
