// lib/models/animal.dart
import 'package:uuid/uuid.dart';
import 'syncable_entity.dart';
import 'eid_change.dart';

/// Sexe de l'animal
enum AnimalSex { male, female }

/// Statut de l'animal
enum AnimalStatus { draft, alive, sold, dead, slaughtered }

/// ModÃ¨le Animal avec traÃ§abilitÃ© EID complÃ¨te et support multi-espÃ¨ces
///
/// GÃ¨re les informations d'un animal d'Ã©levage avec :
/// - TraÃ§abilitÃ© complÃ¨te des changements d'EID (puce RFID)
/// - Support multi-espÃ¨ces et races (multilingue)
/// - Synchronisation avec le serveur
class Animal implements SyncableEntity {
  /// Identifiant PERMANENT de l'animal (UUID)
  /// âš ï¸ NE JAMAIS modifier cet ID - il sert de clÃ© primaire en base de donnÃ©es
  @override
  final String id;

  /// ID de la ferme (multi-tenancy)
  @override
  final String farmId;

  /// EID actuel (Electronic IDentification) - Code RFID de la puce
  /// âœ… MODIFIABLE - Peut Ãªtre changÃ© si la puce est perdue/cassÃ©e
  /// â„¹ï¸ OPTIONNEL - Si null, utiliser visualId ou officialNumber
  String? currentEid;

  /// Historique des changements d'EID
  /// Permet la traÃ§abilitÃ© complÃ¨te des changements de puces
  List<EidChange>? eidHistory;

  /// NumÃ©ro officiel (permanent, attribuÃ© par l'administration)
  final String? officialNumber;

  /// Date de naissance
  final DateTime birthDate;

  /// Sexe de l'animal
  final AnimalSex sex;

  /// ID de la mÃ¨re (optionnel)
  final String? motherId;


  /// Statut actuel
  final AnimalStatus status;

  /// Date de validation (NULL = DRAFT, NOT NULL = timestamp validation)
  final DateTime? validatedAt;

  /// Type d'animal (species) - Ex: 'sheep', 'cattle', 'goat'
  /// UtilisÃ© avec animal_species.dart pour affichage multilingue
  String? speciesId;

  /// Race (breed) - Ex: 'merinos', 'charolaise', 'alpine'
  /// UtilisÃ© avec breed.dart pour affichage multilingue
  String? breedId;

  /// ID visuel personnalisÃ© pour identification de secours
  /// Ex: "Rouge-42", "Tache-Blanche", "Oreille-CoupÃ©e"
  final String? visualId;

  /// Photo optionnelle de l'animal
  final String? photoUrl;

  /// Notes libres sur l'animal (observations, comportement, etc.)
  /// Max 1000 caractères - Modifiable même si l'animal est validé (ALIVE)
  final String? notes;

  /// Champ de compatibilitÃ© pour mock_data.dart
  final int? days;

  // ==================== Champs SyncableEntity ====================

  /// Ã‰tat de synchronisation avec le serveur
  @override
  final bool synced;

  /// Date de crÃ©ation
  @override
  final DateTime createdAt;

  /// Date de derniÃ¨re modification
  @override
  final DateTime updatedAt;

  /// Date de derniÃ¨re synchronisation
  @override
  final DateTime? lastSyncedAt;

  /// Version serveur
  @override
  final String? serverVersion;

  // ==================== Constructeur ====================

  Animal({
    String? id,
    this.farmId = 'mock-farm-001', // Valeur par dÃ©faut pour compatibilitÃ© mock
    this.currentEid,
    this.eidHistory,
    this.officialNumber,
    required this.birthDate,
    required this.sex,
    this.motherId,
    this.status = AnimalStatus.alive,
    this.validatedAt,
    this.speciesId,
    this.breedId,
    this.visualId,
    this.photoUrl,
    this.notes,
    this.days,
    this.synced = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastSyncedAt,
    this.serverVersion,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? createdAt ?? DateTime.now();

  // ==================== Getters ====================

  /// Ã‚ge de l'animal en jours
  int get ageInDays => DateTime.now().difference(birthDate).inDays;

  /// Ã‚ge de l'animal en mois
  int get ageInMonths => (ageInDays / 30).floor();

  /// 🔨 DRAFT SYSTEM HELPERS
  
  /// L'animal est-il en brouillon (jamais validé)?
  bool get isDraft => status == AnimalStatus.draft && validatedAt == null;
  
  /// L'animal est-il validé (immuable)?
  bool get isValidated => validatedAt != null;
  
  /// L'animal peut-il être modifié?
  /// ✅ DRAFT: tout modifiable
  /// ✅ ALIVE: nom seulement
  /// ❌ DEAD/SOLD/SLAUGHTERED: rien
  bool get isModifiable => isDraft;
  
  /// L'animal peut-il recevoir des soins?
  /// ✅ ALIVE (vivant)
  /// ❌ DRAFT, DEAD, SOLD, SLAUGHTERED: non
  bool get canReceiveCare => status == AnimalStatus.alive;

  /// Les enregistrements de l'animal peuvent-ils être modifiés?
  /// (notes, EID, poids, etc.)
  /// ✅ ALIVE (vivant): oui
  /// ❌ DRAFT, DEAD, SOLD, SLAUGHTERED: non
  bool get canEditRecords => status == AnimalStatus.alive;

  /// Getter de compatibilitÃ© pour le code existant
  /// @deprecated Utiliser currentEid Ã  la place
  String? get eid => currentEid;

  /// L'animal a-t-il un type (species) dÃ©fini ?
  bool get hasSpecies => speciesId != null && speciesId!.isNotEmpty;

  /// L'animal a-t-il une race (breed) dÃ©finie ?
  bool get hasBreed => breedId != null && breedId!.isNotEmpty;

  /// L'animal a-t-il un historique d'EID ?
  bool get hasEidHistory => eidHistory != null && eidHistory!.isNotEmpty;

  /// Nombre de changements d'EID
  int get eidChangeCount => eidHistory?.length ?? 0;

  /// L'animal a-t-il des notes ?
  bool get hasNotes => notes != null && notes!.isNotEmpty;

  /// ðŸ†• PART3 - VALIDATION MÃˆRE
  /// Peut-elle Ãªtre mÃ¨re ?
  bool get canBeMother {
    return sex == AnimalSex.female &&
        status == AnimalStatus.alive &&
        ageInMonths >= _getReproductionMinAge();
  }

  int _getReproductionMinAge() {
    switch (speciesId?.toLowerCase()) {
      case 'ovine':
      case 'caprine':
        return 7;
      case 'bovine':
        return 15;
      default:
        return 12;
    }
  }

  /// Raison pour laquelle elle ne peut pas Ãªtre mÃ¨re
  String? get cannotBeMotherReason {
    if (sex != AnimalSex.female) {
      return 'L\'animal n\'est pas une femelle';
    }
    if (status != AnimalStatus.alive) {
      return 'L\'animal n\'est plus vivant';
    }
    if (ageInMonths < _getReproductionMinAge()) {
      return 'L\'animal est trop jeune (min. ${_getReproductionMinAge()} mois)';
    }
    return null;
  }

  // ==================== GETTERS SAFE (JAMAIS NULL) ====================

  /// Identifiant principal pour l'affichage (JAMAIS NULL)
  /// PrioritÃ© : visualId > officialNumber > currentEid > "Sans ID"
  String get displayId {
    if (visualId != null && visualId!.isNotEmpty) return visualId!;
    if (officialNumber != null && officialNumber!.isNotEmpty) {
      return officialNumber!;
    }
    if (currentEid != null && currentEid!.isNotEmpty) return currentEid!;
    return 'Sans ID';
  }

  /// Nom complet pour affichage en titre (JAMAIS NULL)
  String get displayName => displayId;

  /// Identifiant complet pour recherche (JAMAIS NULL)
  String get fullIdentification {
    final parts = <String>[];
    if (visualId != null && visualId!.isNotEmpty) parts.add('ID: $visualId');
    if (currentEid != null && currentEid!.isNotEmpty) {
      parts.add('EID: $currentEid');
    }
    if (officialNumber != null && officialNumber!.isNotEmpty) {
      parts.add('NÂ°: $officialNumber');
    }
    return parts.isEmpty ? 'Sans identification' : parts.join(' â€¢ ');
  }

  /// NumÃ©ro officiel safe (JAMAIS NULL)
  String get safeOfficialNumber => officialNumber ?? '-';

  /// EID safe (JAMAIS NULL)
  String get safeEid => currentEid ?? '-';

  /// Visual ID safe (JAMAIS NULL)
  String get safeVisualId => visualId ?? '-';

  // ==================== MÃ©thodes ====================

  /// Changer l'EID de l'animal (en cas de puce perdue/cassÃ©e)
  ///
  /// CrÃ©e automatiquement un enregistrement dans l'historique
  /// et marque l'animal comme non synchronisÃ©.
  Animal changeEid({
    required String newEid,
    required String reason,
    String? notes,
  }) {
    final change = EidChange(
      id: const Uuid().v4(),
      oldEid: currentEid ?? 'N/A',
      newEid: newEid,
      changedAt: DateTime.now(),
      reason: reason,
      notes: notes,
    );

    final updatedHistory = List<EidChange>.from(eidHistory ?? [])..add(change);

    return copyWith(
      currentEid: newEid,
      eidHistory: updatedHistory,
      synced: false,
      updatedAt: DateTime.now(),
    );
  }

  /// Copier avec modifications
  Animal copyWith({
    String? id,
    String? farmId,
    String? currentEid,
    List<EidChange>? eidHistory,
    String? officialNumber,
    DateTime? birthDate,
    AnimalSex? sex,
    String? motherId,
    AnimalStatus? status,
    DateTime? validatedAt,
    String? speciesId,
    String? breedId,
    String? visualId,
    String? photoUrl,
    String? notes,
    int? days,
    bool? synced,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    String? serverVersion,
  }) {
    return Animal(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      currentEid: currentEid ?? this.currentEid,
      eidHistory: eidHistory ?? this.eidHistory,
      officialNumber: officialNumber ?? this.officialNumber,
      birthDate: birthDate ?? this.birthDate,
      sex: sex ?? this.sex,
      motherId: motherId ?? this.motherId,
      status: status ?? this.status,
      validatedAt: validatedAt ?? this.validatedAt,
      speciesId: speciesId ?? this.speciesId,
      breedId: breedId ?? this.breedId,
      visualId: visualId ?? this.visualId,
      photoUrl: photoUrl ?? this.photoUrl,
      notes: notes ?? this.notes,
      days: days ?? this.days,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
    );
  }

  /// Marquer comme synchronisÃ© avec le serveur
  Animal markAsSynced({required String serverVersion}) {
    return copyWith(
      synced: true,
      lastSyncedAt: DateTime.now(),
      serverVersion: serverVersion,
    );
  }

  /// Marquer comme modifiÃ© (Ã  synchroniser)
  Animal markAsModified() {
    return copyWith(
      synced: false,
      updatedAt: DateTime.now(),
    );
  }

  // ==================== SÃ©rialisation ====================

  /// Convertir en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmId': farmId,
      'current_eid': currentEid,
      'eid_history': eidHistory?.map((e) => e.toJson()).toList(),
      'official_number': officialNumber,
      'birth_date': birthDate.toIso8601String(),
      'sex': sex.name,
      'mother_id': motherId,
      'status': status.name,
      'validated_at': validatedAt?.toIso8601String(),
      'species_id': speciesId,
      'breed_id': breedId,
      'visual_id': visualId,
      'photo_url': photoUrl,
      'notes': notes,
      'days': days,
      'synced': synced,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'server_version': serverVersion,
    };
  }

  /// CrÃ©er depuis JSON
  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      id: json['id'],
      farmId: json['farmId'] as String? ??
          json['farm_id'] as String? ??
          'mock-farm-001',
      currentEid: json['current_eid'] ??
          json['currentEid'] ??
          json['eid'], // RÃ©trocompatibilitÃ©
      eidHistory: json['eid_history'] != null || json['eidHistory'] != null
          ? ((json['eid_history'] ?? json['eidHistory']) as List)
              .map((e) => EidChange.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      officialNumber: json['official_number'] ?? json['officialNumber'],
      birthDate: DateTime.parse(json['birth_date'] ?? json['birthDate']),
      sex: AnimalSex.values.firstWhere((e) => e.name == json['sex']),
      motherId: json['mother_id'] ?? json['motherId'],
      status: AnimalStatus.values.firstWhere((e) => e.name == json['status']),
      speciesId: json['species_id'] ?? json['speciesId'],
      breedId: json['breed_id'] ?? json['breedId'],
      visualId: json['visual_id'] ?? json['visualId'],
      photoUrl: json['photo_url'] ?? json['photoUrl'],
      notes: json['notes'] as String?,
      days: json['days'] as int?,
      synced: json['synced'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] ?? json['createdAt']),
      updatedAt: json['updated_at'] != null || json['updatedAt'] != null
          ? DateTime.parse(json['updated_at'] ?? json['updatedAt'])
          : DateTime.now(),
      lastSyncedAt:
          json['last_synced_at'] != null || json['lastSyncedAt'] != null
              ? DateTime.parse(json['last_synced_at'] ?? json['lastSyncedAt'])
              : null,
      validatedAt: json['validated_at'] != null ? DateTime.parse(json['validated_at']) : null,
      serverVersion: json['server_version'] ?? json['serverVersion'],
    );
  }

  @override
  String toString() {
    return 'Animal(id: $id, currentEid: $currentEid, officialNumber: $officialNumber, '
        'species: $speciesId, breed: $breedId, status: ${status.name}, synced: $synced)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Animal && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
