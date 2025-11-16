// lib/utils/sync_validator.dart
import '../models/animal.dart';
import 'sync_config.dart';

/// Validateur pour la synchronisation (STEP 4)
///
/// Cette classe valide les données avant synchronisation:
/// - Validation officialNumber (critique pour conformité UE)
/// - Validation des identifiants (au moins un requis)
/// - Validation des statuts
/// - Vérification si la queue peut être synchronisée
class SyncValidator {
  /// Valider un animal pour synchronisation
  ///
  /// Vérifie:
  /// 1. 🔴 CRITIQUE: officialNumber présent (si blockSyncIfNoOfficialId = true)
  /// 2. Au moins un identifiant présent (EID, officialNumber ou visualId)
  /// 3. ID animal non vide
  /// 4. Status valide
  /// 5. Date de naissance présente
  ///
  /// Retourne SyncValidationResult avec:
  /// - isValid: true si toutes validations passent
  /// - errors: liste des erreurs trouvées
  /// - canForceSync: true en dev mode (permet bypass)
  static SyncValidationResult validateAnimal(Animal animal) {
    final errors = <String>[];

    // ❌ BLOCAGE CRITIQUE: officialNumber vide
    // Traçabilité réglementaire UE = officialNumber OBLIGATOIRE
    if (animal.officialNumber == null || animal.officialNumber!.isEmpty) {
      if (SyncConfig.blockSyncIfNoOfficialId) {
        errors.add(
            'BLOCAGE: officialNumber obligatoire pour synchroniser (conformité réglementaire UE)');
      } else if (SyncConfig.isDevelopmentMode && SyncConfig.debugLogging) {
        print('⚠️  [DEV MODE] officialNumber vide mais sync autorisée');
      }
    }

    // ⚠️ WARNING: Au moins un identifiant requis
    final hasEid = animal.currentEid != null && animal.currentEid!.isNotEmpty;
    final hasOfficialNumber =
        animal.officialNumber != null && animal.officialNumber!.isNotEmpty;
    final hasVisualId =
        animal.visualId != null && animal.visualId!.isNotEmpty;

    if (!hasEid && !hasOfficialNumber && !hasVisualId) {
      errors.add(
          'Au moins un identifiant requis (EID, numéro officiel ou ID visuel)');
    }

    // ❌ ERREUR: ID vide
    if (animal.id.isEmpty) {
      errors.add('Animal ID ne peut pas être vide');
    }

    // ❌ ERREUR: Status invalide (vérifier avec enum)
    // Le status est déjà un enum AnimalStatus, donc toujours valide
    // Mais on peut vérifier qu'il n'est pas draft pour la sync
    if (animal.status == AnimalStatus.draft) {
      errors.add(
          'Animal en brouillon (draft) ne peut pas être synchronisé - valider d\'abord');
    }

    // ❌ ERREUR: Birth date manquant
    if (animal.birthDate == null) {
      errors.add('Date de naissance obligatoire');
    }

    // ⚠️ WARNING: FarmId vide
    if (animal.farmId.isEmpty) {
      errors.add('FarmId ne peut pas être vide (multi-tenancy requis)');
    }

    return SyncValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      canForceSync: SyncConfig.isDevelopmentMode,
    );
  }

  /// Vérifier si la queue peut être synchronisée
  ///
  /// Contrôle global de la synchronisation selon les flags de configuration:
  /// - testMode: pas de sync réelle
  /// - mockServerMode: sync simulée
  /// - syncEnabled: sync activée/désactivée
  ///
  /// Paramètres:
  /// - pendingCount: nombre d'items en attente
  /// - totalRetries: nombre total de retries
  ///
  /// Retourne true si sync autorisée, false sinon
  static bool canSyncQueue({
    required int pendingCount,
    required int totalRetries,
  }) {
    // Mode test: pas de sync réelle
    if (SyncConfig.testMode) {
      if (SyncConfig.debugLogging) {
        print('🧪 [TEST MODE] Pas de sync réelle - items restent en queue');
      }
      return false;
    }

    // Mode mock serveur: sync simulée (autorisée)
    if (SyncConfig.mockServerMode) {
      if (SyncConfig.debugLogging) {
        print('🤖 [MOCK SERVER] Sync simulée (pas d\'appel HTTP)');
      }
      return true;
    }

    // Sync globalement désactivée
    if (!SyncConfig.syncEnabled) {
      if (SyncConfig.debugLogging) {
        print('🔴 [SYNC DÉSACTIVÉE] Via Settings');
      }
      return false;
    }

    // ⚠️ WARNING: Queue trop grosse
    if (pendingCount > SyncConfig.maxQueueSize) {
      print('⚠️  [WARNING] Queue size = $pendingCount > ${SyncConfig.maxQueueSize}');
      print('   Risque de performance - cleanup recommandé');
      // Continuer quand même (pas bloquant)
    }

    return true;
  }

  /// Valider une entité générique avant sync
  ///
  /// Validations de base applicables à toutes les entités:
  /// - ID non vide
  /// - FarmId non vide
  ///
  /// Pour validations spécifiques, utiliser les méthodes dédiées
  /// (ex: validateAnimal pour Animal)
  static SyncValidationResult validateEntity({
    required String id,
    required String farmId,
    required String entityType,
  }) {
    final errors = <String>[];

    if (id.isEmpty) {
      errors.add('$entityType: ID ne peut pas être vide');
    }

    if (farmId.isEmpty) {
      errors.add('$entityType: FarmId ne peut pas être vide');
    }

    return SyncValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      canForceSync: SyncConfig.isDevelopmentMode,
    );
  }
}

/// Résultat de validation pour synchronisation
///
/// Contient:
/// - isValid: true si validation réussie
/// - errors: liste des erreurs trouvées
/// - canForceSync: true si bypass possible (dev mode)
class SyncValidationResult {
  final bool isValid;
  final List<String> errors;
  final bool canForceSync;

  SyncValidationResult({
    required this.isValid,
    required this.errors,
    required this.canForceSync,
  });

  /// Message d'erreur formaté (toutes erreurs séparées par ; )
  String get errorMessage => errors.join('; ');

  /// Peut-on procéder à la sync?
  ///
  /// TRUE si:
  /// - isValid = true (validation OK)
  /// - OU canForceSync = true (dev mode bypass)
  bool get canProceed => isValid || canForceSync;

  /// Affichage debug
  @override
  String toString() {
    if (isValid) {
      return '✅ Validation OK';
    } else {
      return '❌ Validation échouée: $errorMessage '
          '${canForceSync ? "(bypass possible en dev)" : ""}';
    }
  }
}

/// Exception levée quand synchronisation bloquée
///
/// Utilisée pour:
/// - Blocage officialNumber vide en production
/// - Blocage validation critique (ID vide, etc.)
/// - Blocage status draft
class SyncBlockedException implements Exception {
  final String message;

  SyncBlockedException(this.message);

  @override
  String toString() => '🔴 SYNC BLOQUÉE: $message';
}
