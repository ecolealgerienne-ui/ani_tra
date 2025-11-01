// lib/models/weighing_rule.dart

/// Règle de pesée pour le suivi pondéral des animaux
///
/// Définit quand un animal doit être pesé selon son âge.
/// Configurable par type d'animal (ovin, bovin, caprin...).
class WeighingRule {
  /// Âge en jours où la pesée est recommandée
  /// Null si c'est une règle récurrente
  final int? ageInDays;

  /// Fréquence récurrente en jours (après le dernier âge défini)
  /// Ex: 30 = tous les 30 jours
  final int? recurringDays;

  /// Label de la pesée (ex: "Naissance", "Sevrage", "Mensuelle")
  final String label;

  /// Label en français
  final String? labelFr;

  /// Label en anglais
  final String? labelEn;

  /// Tolérance en jours (combien de jours de retard acceptés avant alerte)
  final int toleranceDays;

  /// Cette pesée est-elle obligatoire ?
  final bool isRequired;

  WeighingRule({
    this.ageInDays,
    this.recurringDays,
    required this.label,
    this.labelFr,
    this.labelEn,
    this.toleranceDays = 3,
    this.isRequired = true,
  }) : assert(
          ageInDays != null || recurringDays != null,
          'WeighingRule doit avoir ageInDays OU recurringDays',
        );

  /// Règle ponctuelle (âge précis)
  factory WeighingRule.atAge({
    required int ageInDays,
    required String label,
    String? labelFr,
    String? labelEn,
    int toleranceDays = 3,
    bool isRequired = true,
  }) {
    return WeighingRule(
      ageInDays: ageInDays,
      label: label,
      labelFr: labelFr,
      labelEn: labelEn,
      toleranceDays: toleranceDays,
      isRequired: isRequired,
    );
  }

  /// Règle récurrente (tous les X jours)
  factory WeighingRule.recurring({
    required int days,
    required String label,
    String? labelFr,
    String? labelEn,
    int toleranceDays = 3,
    bool isRequired = false,
  }) {
    return WeighingRule(
      recurringDays: days,
      label: label,
      labelFr: labelFr,
      labelEn: labelEn,
      toleranceDays: toleranceDays,
      isRequired: isRequired,
    );
  }

  /// Cette règle est récurrente
  bool get isRecurring => recurringDays != null;

  /// Obtenir le label dans la langue donnée
  String getLabel(String locale) {
    switch (locale) {
      case 'fr':
        return labelFr ?? label;
      case 'en':
        return labelEn ?? label;
      default:
        return label;
    }
  }

  /// Conversion en Map
  Map<String, dynamic> toJson() {
    return {
      'ageInDays': ageInDays,
      'recurringDays': recurringDays,
      'label': label,
      'labelFr': labelFr,
      'labelEn': labelEn,
      'toleranceDays': toleranceDays,
      'isRequired': isRequired,
    };
  }

  /// Création depuis Map
  factory WeighingRule.fromJson(Map<String, dynamic> json) {
    return WeighingRule(
      ageInDays: json['ageInDays'],
      recurringDays: json['recurringDays'],
      label: json['label'],
      labelFr: json['labelFr'],
      labelEn: json['labelEn'],
      toleranceDays: json['toleranceDays'] ?? 3,
      isRequired: json['isRequired'] ?? true,
    );
  }

  @override
  String toString() {
    if (isRecurring) {
      return 'WeighingRule(recurring: ${recurringDays}j, $label)';
    }
    return 'WeighingRule(age: ${ageInDays}j, $label)';
  }
}

/// Configuration des règles de pesée par espèce
///
/// Définit les règles métier pour chaque type d'animal.
class WeighingRulesConfig {
  /// Règles pour les ovins (moutons)
  static List<WeighingRule> get ovine => [
        WeighingRule.atAge(
          ageInDays: 0,
          label: 'Naissance',
          labelFr: 'Naissance',
          labelEn: 'Birth',
          toleranceDays: 1,
          isRequired: true,
        ),
        WeighingRule.atAge(
          ageInDays: 10,
          label: '10 jours',
          labelFr: '10 jours',
          labelEn: '10 days',
          toleranceDays: 3,
          isRequired: true,
        ),
        WeighingRule.atAge(
          ageInDays: 30,
          label: '30 jours',
          labelFr: '30 jours',
          labelEn: '30 days',
          toleranceDays: 5,
          isRequired: true,
        ),
        WeighingRule.atAge(
          ageInDays: 70,
          label: 'Sevrage',
          labelFr: 'Sevrage (70j)',
          labelEn: 'Weaning (70d)',
          toleranceDays: 7,
          isRequired: true,
        ),
        WeighingRule.recurring(
          days: 30,
          label: 'Mensuelle',
          labelFr: 'Pesée mensuelle',
          labelEn: 'Monthly weighing',
          toleranceDays: 7,
          isRequired: false,
        ),
      ];

  /// Règles pour les bovins (vaches, veaux)
  static List<WeighingRule> get bovine => [
        WeighingRule.atAge(
          ageInDays: 0,
          label: 'Naissance',
          labelFr: 'Naissance',
          labelEn: 'Birth',
          toleranceDays: 1,
          isRequired: true,
        ),
        WeighingRule.atAge(
          ageInDays: 30,
          label: '1 mois',
          labelFr: '1 mois',
          labelEn: '1 month',
          toleranceDays: 5,
          isRequired: true,
        ),
        WeighingRule.atAge(
          ageInDays: 90,
          label: '3 mois',
          labelFr: '3 mois',
          labelEn: '3 months',
          toleranceDays: 7,
          isRequired: true,
        ),
        WeighingRule.atAge(
          ageInDays: 210,
          label: 'Sevrage',
          labelFr: 'Sevrage (7 mois)',
          labelEn: 'Weaning (7 months)',
          toleranceDays: 14,
          isRequired: true,
        ),
        WeighingRule.recurring(
          days: 60,
          label: 'Bimestrielle',
          labelFr: 'Pesée bimestrielle',
          labelEn: 'Bimonthly weighing',
          toleranceDays: 10,
          isRequired: false,
        ),
      ];

  /// Règles pour les caprins (chèvres)
  static List<WeighingRule> get caprine => [
        WeighingRule.atAge(
          ageInDays: 0,
          label: 'Naissance',
          labelFr: 'Naissance',
          labelEn: 'Birth',
          toleranceDays: 1,
          isRequired: true,
        ),
        WeighingRule.atAge(
          ageInDays: 10,
          label: '10 jours',
          labelFr: '10 jours',
          labelEn: '10 days',
          toleranceDays: 3,
          isRequired: true,
        ),
        WeighingRule.atAge(
          ageInDays: 30,
          label: '30 jours',
          labelFr: '30 jours',
          labelEn: '30 days',
          toleranceDays: 5,
          isRequired: true,
        ),
        WeighingRule.atAge(
          ageInDays: 60,
          label: 'Sevrage',
          labelFr: 'Sevrage (60j)',
          labelEn: 'Weaning (60d)',
          toleranceDays: 7,
          isRequired: true,
        ),
        WeighingRule.recurring(
          days: 30,
          label: 'Mensuelle',
          labelFr: 'Pesée mensuelle',
          labelEn: 'Monthly weighing',
          toleranceDays: 7,
          isRequired: false,
        ),
      ];

  /// Obtenir les règles pour une espèce donnée
  static List<WeighingRule> getRulesForSpecies(String speciesId) {
    switch (speciesId.toLowerCase()) {
      case 'ovine':
      case 'sheep':
      case 'ovin':
        return ovine;
      case 'bovine':
      case 'cattle':
      case 'bovin':
        return bovine;
      case 'caprine':
      case 'goat':
      case 'caprin':
        return caprine;
      default:
        // Par défaut : règles ovines (les plus courantes)
        return ovine;
    }
  }
}
