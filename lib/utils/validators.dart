// lib/utils/validators.dart
class AppValidators {
  // EID validation (15 digits)
  static String? validateEID(String? value) {
    if (value == null || value.isEmpty) {
      return 'EID requis';
    }

    final cleanValue = value.replaceAll(' ', '');

    if (cleanValue.length != 15) {
      return 'L\'EID doit contenir 15 chiffres';
    }

    if (RegExp(r'^\d{15}$').hasMatch(cleanValue)) {
      return 'L\'EID ne doit contenir que des chiffres';
    }

    return null;
  }

  // Price validation
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Prix requis';
    }

    final price = double.tryParse(value);

    if (price == null) {
      return 'Prix invalide';
    }

    if (price <= 0) {
      return 'Le prix doit être positif';
    }

    if (price > 100000) {
      return 'Prix trop élevé';
    }

    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nom requis';
    }

    if (value.length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }

    if (value.length > 100) {
      return 'Le nom est trop long';
    }

    return null;
  }

  // Dose validation
  static String? validateDose(String? value) {
    if (value == null || value.isEmpty) {
      return 'Dose requise';
    }

    final dose = double.tryParse(value);

    if (dose == null) {
      return 'Dose invalide';
    }

    if (dose <= 0) {
      return 'La dose doit être positive';
    }

    if (dose > 1000) {
      return 'Dose trop élevée';
    }

    return null;
  }
}
