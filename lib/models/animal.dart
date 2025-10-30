// lib/models/animal.dart
import 'package:uuid/uuid.dart';

enum AnimalSex { male, female }

enum AnimalStatus { alive, sold, dead, slaughtered }

class Animal {
  final String id;
  final String eid;
  final String? officialNumber;
  final DateTime birthDate;
  final AnimalSex sex;
  final String? motherId;
  final AnimalStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Ajout chirurgical pour compatibilité mock_data.dart
  final int? days;

  Animal({
    String? id,
    required this.eid,
    this.officialNumber,
    required this.birthDate,
    required this.sex,
    this.motherId,
    this.status = AnimalStatus.alive,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.days, // ← AJOUTÉ
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Animal copyWith({
    String? eid,
    String? officialNumber,
    DateTime? birthDate,
    AnimalSex? sex,
    String? motherId,
    AnimalStatus? status,
    DateTime? updatedAt,
    int? days, // ← AJOUTÉ
  }) {
    return Animal(
      id: id,
      eid: eid ?? this.eid,
      officialNumber: officialNumber ?? this.officialNumber,
      birthDate: birthDate ?? this.birthDate,
      sex: sex ?? this.sex,
      motherId: motherId ?? this.motherId,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      days: days ?? this.days, // ← AJOUTÉ
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eid': eid,
      'official_number': officialNumber,
      'birth_date': birthDate.toIso8601String(),
      'sex': sex.name,
      'mother_id': motherId,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'days': days, // ← AJOUTÉ
    };
  }

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      id: json['id'],
      eid: json['eid'],
      officialNumber: json['official_number'],
      birthDate: DateTime.parse(json['birth_date']),
      sex: AnimalSex.values.firstWhere((e) => e.name == json['sex']),
      motherId: json['mother_id'],
      status: AnimalStatus.values.firstWhere((e) => e.name == json['status']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      days: json['days'] as int?, // ← AJOUTÉ
    );
  }

  int get ageInDays => DateTime.now().difference(birthDate).inDays;
  int get ageInMonths => (ageInDays / 30).floor();
}
