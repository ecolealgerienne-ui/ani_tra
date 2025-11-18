// lib/utils/sync_validator.dart

import '../models/animal.dart';
import 'sync_config.dart';

/// Validateur pour la synchronisation (STEP 4)
///
/// Valide les données avant synchronisation:
/// - Validation officialNumber (critique conformité UE)
/// - Validation des identifiants
/// - Validation des statuts
class SyncValidator {
  /// Valider un animal pour synchronisation
  ///
  /// Retourne un [SyncValidationResult] avec:
  /// - isValid: true si l'animal peut être synchronisé
  /// - errors: liste des erreurs de validation
  static SyncValidationResult validateAnimal(Animal animal) {
    final errors = <String>[];

    // 1. CRITIQUE: officialNumber obligatoire (si configuré)
    if ((animal.officialNumber == null || animal.officialNumber!.isEmpty) &&
        SyncConfig.blockSyncIfNoOfficialId) {
      errors.add('officialNumberRequired');
    }

    // 2. Au moins un identifiant requis
    final hasEid = animal.currentEid != null && animal.currentEid!.isNotEmpty;
    final hasOfficial =
        animal.officialNumber != null && animal.officialNumber!.isNotEmpty;
    final hasVisual = animal.visualId != null && animal.visualId!.isNotEmpty;

    if (!hasEid && !hasOfficial && !hasVisual) {
      errors.add('atLeastOneIdentifierRequired');
    }

    // 3. ID animal non vide
    if (animal.id.isEmpty) {
      errors.add('animalIdEmpty');
    }

    // 4. FarmId non vide
    if (animal.farmId.isEmpty) {
      errors.add('farmIdEmpty');
    }

    return SyncValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Vérifier si la sync est globalement autorisée
  static bool canSync() {
    return SyncConfig.isSyncEnabled();
  }
}

/// Résultat de validation sync
class SyncValidationResult {
  /// Validation réussie?
  final bool isValid;

  /// Liste des codes d'erreur (clés I18n)
  final List<String> errors;

  SyncValidationResult({
    required this.isValid,
    required this.errors,
  });

  /// Message d'erreur combiné (pour debug)
  String get errorMessage => errors.join(', ');

  /// Nombre d'erreurs
  int get errorCount => errors.length;

  /// A des erreurs?
  bool get hasErrors => errors.isNotEmpty;
}

/// Exception levée quand sync bloquée
class SyncBlockedException implements Exception {
  final String message;
  final List<String> errorCodes;

  SyncBlockedException(this.message, {this.errorCodes = const []});

  @override
  String toString() => 'SyncBlockedException: $message';
}
