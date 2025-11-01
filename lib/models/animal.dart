// lib/models/animal.dart
import 'package:uuid/uuid.dart';
import 'eid_change.dart';

enum AnimalSex { male, female }

enum AnimalStatus { alive, sold, dead, slaughtered }

class Animal {
  /// Identifiant PERMANENT de l'animal (UUID)
  /// ⚠️ NE JAMAIS modifier cet ID - il sert de clé primaire en base de données
  final String id;

  /// EID actuel (Electronic IDentification) - Code RFID de la puce
  /// ✅ MODIFIABLE - Peut être changé si la puce est perdue/cassée
  String currentEid;

  /// Historique des changements d'EID
  /// Permet la traçabilité complète des changements de puces
  List<EidChange>? eidHistory;

  /// Numéro officiel (permanent, attribué par l'administration)
  final String? officialNumber;

  /// Date de naissance
  final DateTime birthDate;

  /// Sexe de l'animal
  final AnimalSex sex;

  /// ID de la mère (optionnel)
  final String? motherId;

  /// Statut actuel
  final AnimalStatus status;

  /// Type d'animal (species) - ÉTAPE 1
  /// Ex: 'sheep', 'cattle', 'goat'
  String? speciesId;

  /// Race (breed) - ÉTAPE 1
  /// Ex: 'merinos', 'charolaise', 'alpine'
  String? breedId;

  /// Dates de tracking
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Champ de compatibilité pour mock_data.dart
  final int? days;

  Animal({
    String? id,
    required this.currentEid,
    this.eidHistory,
    this.officialNumber,
    required this.birthDate,
    required this.sex,
    this.motherId,
    this.status = AnimalStatus.alive,
    this.speciesId,
    this.breedId,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.days,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Changer l'EID de l'animal (en cas de puce perdue/cassée)
  ///
  /// Crée automatiquement un enregistrement dans l'historique
  Animal changeEid({
    required String newEid,
    required String reason,
    String? notes,
  }) {
    final change = EidChange(
      id: const Uuid().v4(),
      oldEid: currentEid,
      newEid: newEid,
      changedAt: DateTime.now(),
      reason: reason,
      notes: notes,
    );

    final updatedHistory = List<EidChange>.from(eidHistory ?? [])..add(change);

    return copyWith(
      currentEid: newEid,
      eidHistory: updatedHistory,
      updatedAt: DateTime.now(),
    );
  }

  Animal copyWith({
    String? currentEid,
    List<EidChange>? eidHistory,
    String? officialNumber,
    DateTime? birthDate,
    AnimalSex? sex,
    String? motherId,
    AnimalStatus? status,
    String? speciesId,
    String? breedId,
    DateTime? updatedAt,
    int? days,
  }) {
    return Animal(
      id: id,
      currentEid: currentEid ?? this.currentEid,
      eidHistory: eidHistory ?? this.eidHistory,
      officialNumber: officialNumber ?? this.officialNumber,
      birthDate: birthDate ?? this.birthDate,
      sex: sex ?? this.sex,
      motherId: motherId ?? this.motherId,
      status: status ?? this.status,
      speciesId: speciesId ?? this.speciesId,
      breedId: breedId ?? this.breedId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      days: days ?? this.days,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'current_eid': currentEid,
      'eid_history': eidHistory?.map((e) => e.toJson()).toList(),
      'official_number': officialNumber,
      'birth_date': birthDate.toIso8601String(),
      'sex': sex.name,
      'mother_id': motherId,
      'status': status.name,
      'species_id': speciesId,
      'breed_id': breedId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'days': days,
    };
  }

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      id: json['id'],
      currentEid: json['current_eid'] ?? json['eid'], // Rétrocompatibilité
      eidHistory: json['eid_history'] != null
          ? (json['eid_history'] as List)
              .map((e) => EidChange.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      officialNumber: json['official_number'],
      birthDate: DateTime.parse(json['birth_date']),
      sex: AnimalSex.values.firstWhere((e) => e.name == json['sex']),
      motherId: json['mother_id'],
      status: AnimalStatus.values.firstWhere((e) => e.name == json['status']),
      speciesId: json['species_id'],
      breedId: json['breed_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      days: json['days'] as int?,
    );
  }

  int get ageInDays => DateTime.now().difference(birthDate).inDays;
  int get ageInMonths => (ageInDays / 30).floor();

  /// Getter de compatibilité pour le code existant
  /// @deprecated Utiliser currentEid à la place
  String get eid => currentEid;

  @override
  String toString() {
    return 'Animal(id: $id, currentEid: $currentEid, officialNumber: $officialNumber)';
  }
}
