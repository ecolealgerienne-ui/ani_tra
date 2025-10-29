import 'package:flutter/material.dart';
//import 'dart:convert';

class QRProvider extends ChangeNotifier {
  String? _lastScannedQR;
  Map<String, dynamic>? _validatedUser;
  bool _isValidating = false;
  String? _validationError;

  // Getters
  String? get lastScannedQR => _lastScannedQR;
  Map<String, dynamic>? get validatedUser => _validatedUser;
  bool get isValidating => _isValidating;
  String? get validationError => _validationError;

  // Mock QR codes for testing
  static const mockBuyerQR = 'QR_BUYER_12345_VALID';
  static const mockVetQR = 'QR_VET_67890_VALID';

  // Simulate QR scan
  Future<void> scanQRCode(String qrData) async {
    _lastScannedQR = qrData;
    _validationError = null;
    notifyListeners();

    await validateQRCode(qrData);
  }

  // Validate QR code (offline simulation)
  Future<bool> validateQRCode(String qrData) async {
    _isValidating = true;
    _validatedUser = null;
    _validationError = null;
    notifyListeners();

    try {
      // Simulate validation delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock validation logic
      if (qrData.contains('BUYER')) {
        _validatedUser = {
          'id': 'buyer-123',
          'name': 'Mohamed Ben Ali',
          'role': 'buyer',
          'organization': 'Coopérative Ovine du Nord',
          'validated_at': DateTime.now().toIso8601String(),
        };
      } else if (qrData.contains('VET')) {
        _validatedUser = {
          'id': 'vet-456',
          'name': 'Dr. Sarah Dubois',
          'role': 'veterinarian',
          'organization': 'Clinique Vétérinaire Rurale',
          'license': 'VET-FR-2024-789',
          'validated_at': DateTime.now().toIso8601String(),
        };
      } else if (qrData.contains('INVALID')) {
        throw Exception('QR Code invalide ou expiré');
      } else {
        throw Exception('Format de QR Code non reconnu');
      }

      _isValidating = false;
      notifyListeners();
      return true;
    } catch (e) {
      _validationError = e.toString();
      _isValidating = false;
      notifyListeners();
      return false;
    }
  }

  // Generate mock QR for testing
  String generateMockQR(String type) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    switch (type) {
      case 'buyer':
        return 'QR_BUYER_${timestamp}_VALID';
      case 'vet':
        return 'QR_VET_${timestamp}_VALID';
      default:
        return 'QR_INVALID_${timestamp}';
    }
  }

  // Clear validation
  void clearValidation() {
    _lastScannedQR = null;
    _validatedUser = null;
    _validationError = null;
    notifyListeners();
  }
}
