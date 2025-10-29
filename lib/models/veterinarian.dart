// lib/models/veterinarian.dart
class Veterinarian {
  final String id;
  final String firstName;
  final String lastName;
  final String? title; // Dr., Pr., etc.

  // Informations professionnelles
  final String licenseNumber; // Numéro d'ordre
  final List<String> specialties; // Spécialités
  final String? clinic; // Nom de la clinique/cabinet

  // Coordonnées
  final String phone;
  final String? mobile;
  final String? email;
  final String? address;
  final String? city;
  final String? postalCode;
  final String? country;

  // Disponibilité
  final bool isAvailable;
  final bool emergencyService; // Service d'urgence
  final String? workingHours; // Horaires de travail

  // Tarifs
  final double? consultationFee;
  final double? emergencyFee;
  final String? currency;

  // Notes et préférences
  final String? notes;
  final bool isPreferred; // Vétérinaire préféré
  final int rating; // Note de 1 à 5

  // Statistiques
  final int totalInterventions;
  final DateTime? lastInterventionDate;

  // Métadonnées
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  Veterinarian({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.title,
    required this.licenseNumber,
    this.specialties = const [],
    this.clinic,
    required this.phone,
    this.mobile,
    this.email,
    this.address,
    this.city,
    this.postalCode,
    this.country,
    this.isAvailable = true,
    this.emergencyService = false,
    this.workingHours,
    this.consultationFee,
    this.emergencyFee,
    this.currency,
    this.notes,
    this.isPreferred = false,
    this.rating = 5,
    this.totalInterventions = 0,
    this.lastInterventionDate,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  // Nom complet
  String get fullName {
    final titlePart = title != null ? '$title ' : '';
    return '$titlePart$firstName $lastName';
  }

  // Nom court
  String get shortName => '$firstName ${lastName[0]}.';

  // Adresse complète
  String? get fullAddress {
    if (address == null) return null;
    final parts = [
      address,
      if (postalCode != null) postalCode,
      if (city != null) city,
    ];
    return parts.join(', ');
  }

  // Spécialités formatées
  String get specialtiesFormatted {
    if (specialties.isEmpty) return 'Généraliste';
    return specialties.join(', ');
  }

  // Copie avec modification
  Veterinarian copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? title,
    String? licenseNumber,
    List<String>? specialties,
    String? clinic,
    String? phone,
    String? mobile,
    String? email,
    String? address,
    String? city,
    String? postalCode,
    String? country,
    bool? isAvailable,
    bool? emergencyService,
    String? workingHours,
    double? consultationFee,
    double? emergencyFee,
    String? currency,
    String? notes,
    bool? isPreferred,
    int? rating,
    int? totalInterventions,
    DateTime? lastInterventionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return Veterinarian(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      title: title ?? this.title,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      specialties: specialties ?? this.specialties,
      clinic: clinic ?? this.clinic,
      phone: phone ?? this.phone,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      address: address ?? this.address,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      isAvailable: isAvailable ?? this.isAvailable,
      emergencyService: emergencyService ?? this.emergencyService,
      workingHours: workingHours ?? this.workingHours,
      consultationFee: consultationFee ?? this.consultationFee,
      emergencyFee: emergencyFee ?? this.emergencyFee,
      currency: currency ?? this.currency,
      notes: notes ?? this.notes,
      isPreferred: isPreferred ?? this.isPreferred,
      rating: rating ?? this.rating,
      totalInterventions: totalInterventions ?? this.totalInterventions,
      lastInterventionDate: lastInterventionDate ?? this.lastInterventionDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  // Conversion JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'title': title,
      'licenseNumber': licenseNumber,
      'specialties': specialties,
      'clinic': clinic,
      'phone': phone,
      'mobile': mobile,
      'email': email,
      'address': address,
      'city': city,
      'postalCode': postalCode,
      'country': country,
      'isAvailable': isAvailable,
      'emergencyService': emergencyService,
      'workingHours': workingHours,
      'consultationFee': consultationFee,
      'emergencyFee': emergencyFee,
      'currency': currency,
      'notes': notes,
      'isPreferred': isPreferred,
      'rating': rating,
      'totalInterventions': totalInterventions,
      'lastInterventionDate': lastInterventionDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory Veterinarian.fromJson(Map<String, dynamic> json) {
    return Veterinarian(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      title: json['title'] as String?,
      licenseNumber: json['licenseNumber'] as String,
      specialties: (json['specialties'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      clinic: json['clinic'] as String?,
      phone: json['phone'] as String,
      mobile: json['mobile'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      postalCode: json['postalCode'] as String?,
      country: json['country'] as String?,
      isAvailable: json['isAvailable'] as bool? ?? true,
      emergencyService: json['emergencyService'] as bool? ?? false,
      workingHours: json['workingHours'] as String?,
      consultationFee: json['consultationFee'] as double?,
      emergencyFee: json['emergencyFee'] as double?,
      currency: json['currency'] as String?,
      notes: json['notes'] as String?,
      isPreferred: json['isPreferred'] as bool? ?? false,
      rating: json['rating'] as int? ?? 5,
      totalInterventions: json['totalInterventions'] as int? ?? 0,
      lastInterventionDate: json['lastInterventionDate'] != null
          ? DateTime.parse(json['lastInterventionDate'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  // Vérifications
  bool get hasEmail => email != null && email!.isNotEmpty;
  bool get hasMobile => mobile != null && mobile!.isNotEmpty;
  bool get hasEmergencyService => emergencyService;
  bool get hasRecentActivity {
    if (lastInterventionDate == null) return false;
    final daysSinceLastIntervention =
        DateTime.now().difference(lastInterventionDate!).inDays;
    return daysSinceLastIntervention <= 30;
  }
}
