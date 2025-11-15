// lib/models/vaccination_protocol.dart

import 'vaccination.dart';

class VaccinationProtocol {
  final String id;
  final String name;
  final String description;
  final String speciesId;
  final VaccinationType type;
  final String disease;
  final String recommendedVaccine;
  final String standardDose;
  final String administrationRoute;
  final int withdrawalPeriodDays;
  final int? minAgeMonths;
  final int? maxAgeMonths;
  final int reminderIntervalDays;
  final String? recommendedPeriod;
  final String? notes;
  final bool isActive;

  const VaccinationProtocol({
    required this.id,
    required this.name,
    required this.description,
    required this.speciesId,
    required this.type,
    required this.disease,
    required this.recommendedVaccine,
    required this.standardDose,
    required this.administrationRoute,
    this.withdrawalPeriodDays = 0,
    this.minAgeMonths,
    this.maxAgeMonths,
    required this.reminderIntervalDays,
    this.recommendedPeriod,
    this.notes,
    this.isActive = true,
  });

  DateTime calculateNextDueDate(DateTime vaccinationDate) {
    return vaccinationDate.add(Duration(days: reminderIntervalDays));
  }

  bool isAnimalEligible(int ageInMonths) {
    if (minAgeMonths != null && ageInMonths < minAgeMonths!) {
      return false;
    }
    if (maxAgeMonths != null && ageInMonths > maxAgeMonths!) {
      return false;
    }
    return true;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'speciesId': speciesId,
      'type': type.name,
      'disease': disease,
      'recommendedVaccine': recommendedVaccine,
      'standardDose': standardDose,
      'administrationRoute': administrationRoute,
      'withdrawalPeriodDays': withdrawalPeriodDays,
      'minAgeMonths': minAgeMonths,
      'maxAgeMonths': maxAgeMonths,
      'reminderIntervalDays': reminderIntervalDays,
      'recommendedPeriod': recommendedPeriod,
      'notes': notes,
      'isActive': isActive,
    };
  }

  factory VaccinationProtocol.fromJson(Map<String, dynamic> json) {
    return VaccinationProtocol(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      speciesId: json['speciesId'] as String,
      type: VaccinationType.values.byName(json['type'] as String),
      disease: json['disease'] as String,
      recommendedVaccine: json['recommendedVaccine'] as String,
      standardDose: json['standardDose'] as String,
      administrationRoute: json['administrationRoute'] as String,
      withdrawalPeriodDays: json['withdrawalPeriodDays'] as int? ?? 0,
      minAgeMonths: json['minAgeMonths'] as int?,
      maxAgeMonths: json['maxAgeMonths'] as int?,
      reminderIntervalDays: json['reminderIntervalDays'] as int,
      recommendedPeriod: json['recommendedPeriod'] as String?,
      notes: json['notes'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}

class VaccinationProtocols {
  static final List<VaccinationProtocol> ovineProtocols = [
    const VaccinationProtocol(
      id: 'ovine_enterotoxemie',
      name: 'Entérotoxémie',
      description: 'Vaccination contre Clostridium perfringens',
      speciesId: 'ovine',
      type: VaccinationType.recommandee,
      disease: 'Entérotoxémie',
      recommendedVaccine: 'Covexin 10',
      standardDose: '2 ml',
      administrationRoute: 'IM',
      withdrawalPeriodDays: 0,
      minAgeMonths: 2,
      reminderIntervalDays: 365,
      recommendedPeriod: 'Mars-Avril',
      notes: 'Rappel annuel. Vacciner 4-6 semaines avant mise à l\'herbe.',
    ),
    const VaccinationProtocol(
      id: 'ovine_pasteurellose',
      name: 'Pasteurellose',
      description: 'Vaccination contre Pasteurella',
      speciesId: 'ovine',
      type: VaccinationType.recommandee,
      disease: 'Pasteurellose',
      recommendedVaccine: 'Ovipast Plus',
      standardDose: '2 ml',
      administrationRoute: 'SC',
      withdrawalPeriodDays: 0,
      minAgeMonths: 3,
      reminderIntervalDays: 365,
      recommendedPeriod: 'Septembre-Octobre',
      notes: 'Vaccination avant rentrée en bergerie.',
    ),
    const VaccinationProtocol(
      id: 'ovine_fievre_q',
      name: 'Fièvre Q',
      description: 'Vaccination contre Coxiella burnetii',
      speciesId: 'ovine',
      type: VaccinationType.optionnelle,
      disease: 'Fièvre Q',
      recommendedVaccine: 'Coxevac',
      standardDose: '1 ml',
      administrationRoute: 'SC',
      withdrawalPeriodDays: 0,
      minAgeMonths: 3,
      reminderIntervalDays: 365,
      notes: 'Vaccination recommandée en zones endémiques.',
    ),
  ];

  static final List<VaccinationProtocol> bovineProtocols = [
    const VaccinationProtocol(
      id: 'bovine_bvd',
      name: 'BVD',
      description: 'Vaccination contre la Diarrhée Virale Bovine',
      speciesId: 'bovine',
      type: VaccinationType.recommandee,
      disease: 'BVD',
      recommendedVaccine: 'Bovilis BVD',
      standardDose: '2 ml',
      administrationRoute: 'IM',
      withdrawalPeriodDays: 0,
      minAgeMonths: 6,
      reminderIntervalDays: 365,
      notes: 'Vacciner génisses avant première saillie.',
    ),
    const VaccinationProtocol(
      id: 'bovine_ibr',
      name: 'IBR',
      description: 'Vaccination contre la Rhinotrachéite Infectieuse Bovine',
      speciesId: 'bovine',
      type: VaccinationType.recommandee,
      disease: 'IBR',
      recommendedVaccine: 'Bovilis IBR',
      standardDose: '2 ml',
      administrationRoute: 'IM',
      withdrawalPeriodDays: 0,
      minAgeMonths: 3,
      reminderIntervalDays: 180,
      notes: 'Rappel tous les 6 mois pour reproductrices.',
    ),
    const VaccinationProtocol(
      id: 'bovine_fievre_aphteuse',
      name: 'Fièvre Aphteuse',
      description: 'Vaccination contre le virus aphteux',
      speciesId: 'bovine',
      type: VaccinationType.obligatoire,
      disease: 'Fièvre Aphteuse',
      recommendedVaccine: 'Aftovaxpur',
      standardDose: '2 ml',
      administrationRoute: 'IM',
      withdrawalPeriodDays: 0,
      minAgeMonths: 4,
      reminderIntervalDays: 180,
      notes: 'Vaccination obligatoire selon réglementation.',
    ),
  ];

  static final List<VaccinationProtocol> caprineProtocols = [
    const VaccinationProtocol(
      id: 'caprine_enterotoxemie',
      name: 'Entérotoxémie',
      description: 'Vaccination contre Clostridium perfringens',
      speciesId: 'caprine',
      type: VaccinationType.recommandee,
      disease: 'Entérotoxémie',
      recommendedVaccine: 'Covexin 10',
      standardDose: '2 ml',
      administrationRoute: 'IM',
      withdrawalPeriodDays: 0,
      minAgeMonths: 2,
      reminderIntervalDays: 365,
      recommendedPeriod: 'Mars-Avril',
      notes: 'Rappel annuel. Vacciner avant mise à l\'herbe.',
    ),
    const VaccinationProtocol(
      id: 'caprine_caev',
      name: 'CAEV',
      description: 'Dépistage Arthrite Encéphalite Caprine',
      speciesId: 'caprine',
      type: VaccinationType.recommandee,
      disease: 'CAEV',
      recommendedVaccine: 'Pas de vaccin - Dépistage',
      standardDose: 'N/A',
      administrationRoute: 'N/A',
      withdrawalPeriodDays: 0,
      minAgeMonths: 6,
      reminderIntervalDays: 365,
      notes: 'Dépistage annuel recommandé.',
    ),
  ];

  static List<VaccinationProtocol> getProtocolsForSpecies(String speciesId) {
    switch (speciesId.toLowerCase()) {
      case 'ovine':
        return ovineProtocols;
      case 'bovine':
        return bovineProtocols;
      case 'caprine':
        return caprineProtocols;
      default:
        return [];
    }
  }

  static VaccinationProtocol? getProtocolById(String id) {
    final allProtocols = [
      ...ovineProtocols,
      ...bovineProtocols,
      ...caprineProtocols,
    ];
    try {
      return allProtocols.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<VaccinationProtocol> getAllProtocols() {
    return [
      ...ovineProtocols,
      ...bovineProtocols,
      ...caprineProtocols,
    ];
  }
}
