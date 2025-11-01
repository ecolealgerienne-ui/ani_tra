// lib/models/alert_category.dart

/// Catégorie d'alerte selon le domaine métier
///
/// Permet de classifier les alertes par type d'action requise
enum AlertCategory {
  /// 📊 Rémanence / Délai d'attente
  ///
  /// Alertes liées aux traitements vétérinaires :
  /// - Délai avant abattage
  /// - Délai avant vente lait
  /// - Conformité réglementaire FDA/ANMV
  remanence,

  /// 🏷️ Identification
  ///
  /// Alertes liées à l'identification des animaux :
  /// - Animal sans EID
  /// - EID non conforme
  /// - Passeport manquant
  identification,

  /// 📝 Registre
  ///
  /// Alertes liées au registre d'élevage :
  /// - Événements incomplets
  /// - Données à finaliser
  /// - Validation requise
  registre,

  /// ☁️ Synchronisation
  ///
  /// Alertes liées à la sync des données :
  /// - Sync en retard
  /// - Backup requis
  /// - Conformité cloud
  sync,

  /// ⚖️ Pesée
  ///
  /// Alertes liées au suivi pondéral :
  /// - Pesée en retard
  /// - Suivi croissance
  /// - Décision de vente
  weighing,

  /// 💉 Traitement
  ///
  /// Alertes liées aux soins :
  /// - Traitement à renouveler
  /// - Vaccination due
  /// - Prophylaxie obligatoire
  treatment,

  /// 📦 Lot
  ///
  /// Alertes liées aux lots/campagnes :
  /// - Lot à finaliser
  /// - Départ imminent
  /// - Documentation manquante
  batch,

  /// 👶 Naissance
  ///
  /// Alertes liées aux naissances :
  /// - Déclaration à faire
  /// - Premier soin requis
  /// - Identification à poser
  birth,

  /// 💀 Mortalité
  ///
  /// Alertes liées aux décès :
  /// - Équarrissage < 48h
  /// - Déclaration obligatoire
  /// - Analyse cause
  death,

  /// 📋 Autre
  ///
  /// Alertes génériques ou non classifiées
  other,
}

/// Extension pour obtenir les propriétés visuelles
extension AlertCategoryExtension on AlertCategory {
  /// Icône selon la catégorie
  String get icon {
    switch (this) {
      case AlertCategory.remanence:
        return '📊';
      case AlertCategory.identification:
        return '🏷️';
      case AlertCategory.registre:
        return '📝';
      case AlertCategory.sync:
        return '☁️';
      case AlertCategory.weighing:
        return '⚖️';
      case AlertCategory.treatment:
        return '💉';
      case AlertCategory.batch:
        return '📦';
      case AlertCategory.birth:
        return '👶';
      case AlertCategory.death:
        return '💀';
      case AlertCategory.other:
        return '📋';
    }
  }

  /// Label en français
  String get labelFr {
    switch (this) {
      case AlertCategory.remanence:
        return 'Rémanence';
      case AlertCategory.identification:
        return 'Identification';
      case AlertCategory.registre:
        return 'Registre';
      case AlertCategory.sync:
        return 'Synchronisation';
      case AlertCategory.weighing:
        return 'Pesée';
      case AlertCategory.treatment:
        return 'Traitement';
      case AlertCategory.batch:
        return 'Lot';
      case AlertCategory.birth:
        return 'Naissance';
      case AlertCategory.death:
        return 'Mortalité';
      case AlertCategory.other:
        return 'Autre';
    }
  }

  /// Label en anglais
  String get labelEn {
    switch (this) {
      case AlertCategory.remanence:
        return 'Withdrawal';
      case AlertCategory.identification:
        return 'Identification';
      case AlertCategory.registre:
        return 'Registry';
      case AlertCategory.sync:
        return 'Sync';
      case AlertCategory.weighing:
        return 'Weighing';
      case AlertCategory.treatment:
        return 'Treatment';
      case AlertCategory.batch:
        return 'Batch';
      case AlertCategory.birth:
        return 'Birth';
      case AlertCategory.death:
        return 'Death';
      case AlertCategory.other:
        return 'Other';
    }
  }

  /// Description courte en français
  String get descriptionFr {
    switch (this) {
      case AlertCategory.remanence:
        return 'Délai avant abattage/vente';
      case AlertCategory.identification:
        return 'EID et traçabilité';
      case AlertCategory.registre:
        return 'Mise à jour registre';
      case AlertCategory.sync:
        return 'Sauvegarde des données';
      case AlertCategory.weighing:
        return 'Suivi pondéral';
      case AlertCategory.treatment:
        return 'Soins vétérinaires';
      case AlertCategory.batch:
        return 'Gestion de lots';
      case AlertCategory.birth:
        return 'Déclaration naissance';
      case AlertCategory.death:
        return 'Gestion mortalité';
      case AlertCategory.other:
        return 'Autres alertes';
    }
  }
}
