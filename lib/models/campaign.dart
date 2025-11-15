// lib/models/campaign.dart
import 'package:uuid/uuid.dart';
import 'syncable_entity.dart';

/// Campagne de traitement collectif
///
/// Permet d'organiser des traitements sur plusieurs animaux
/// (vaccinations, vermifuges, etc.)
class Campaign implements SyncableEntity {
  /// Identifiant unique de la campagne
  @override
  final String id;

  /// ID de la ferme (multi-tenancy)
  @override
  final String farmId;

  /// Nom de la campagne
  final String name;

  /// ID du produit utilisé
  final String productId;

  /// Nom du produit utilisé
  final String productName;

  /// Date de la campagne
  final DateTime campaignDate;

  /// Date de fin de rémanence (délai d'attente)
  final DateTime withdrawalEndDate;

  /// ID du vétérinaire (optionnel)
  final String? veterinarianId;

  /// Nom du vétérinaire (optionnel)
  final String? veterinarianName;

  /// Liste des IDs d'animaux traités
  final List<String> animalIds;

  /// La campagne est-elle complétée ?
  final bool completed;

  // ==================== Champs SyncableEntity ====================

  /// État de synchronisation
  @override
  final bool synced;

  /// Date de création
  @override
  final DateTime createdAt;

  /// Date de dernière modification
  @override
  final DateTime updatedAt;

  /// Date de dernière synchronisation
  @override
  final DateTime? lastSyncedAt;

  /// Version serveur
  @override
  final String? serverVersion;

  // ==================== Constructeur ====================

  Campaign({
    String? id,
    this.farmId = 'mock-farm-001', // Valeur par défaut pour compatibilité mock
    required this.name,
    required this.productId,
    required this.productName,
    required this.campaignDate,
    required this.withdrawalEndDate,
    this.veterinarianId,
    this.veterinarianName,
    this.animalIds = const [],
    this.completed = false,
    this.synced = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastSyncedAt,
    this.serverVersion,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? createdAt ?? DateTime.now();

  // ==================== Getters ====================

  /// Nombre d'animaux dans la campagne
  int get animalCount => animalIds.length;

  /// La campagne est-elle vide ?
  bool get isEmpty => animalIds.isEmpty;

  /// La campagne contient-elle des animaux ?
  bool get isNotEmpty => animalIds.isNotEmpty;

  /// La campagne est-elle active (non complétée) ?
  bool get isActive => !completed;

  /// Nombre de jours avant la fin de rémanence
  int get daysUntilWithdrawalEnd {
    final now = DateTime.now();
    if (withdrawalEndDate.isBefore(now)) return 0;
    return withdrawalEndDate.difference(now).inDays;
  }

  /// La rémanence est-elle terminée ?
  bool get withdrawalPeriodEnded => DateTime.now().isAfter(withdrawalEndDate);

  /// La campagne a-t-elle un vétérinaire assigné ?
  bool get hasVeterinarian => veterinarianId != null;

  // ==================== Méthodes ====================

  /// Copier avec modifications
  Campaign copyWith({
    String? id,
    String? farmId,
    String? name,
    String? productId,
    String? productName,
    DateTime? campaignDate,
    DateTime? withdrawalEndDate,
    String? veterinarianId,
    String? veterinarianName,
    List<String>? animalIds,
    bool? completed,
    bool? synced,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    String? serverVersion,
  }) {
    return Campaign(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      name: name ?? this.name,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      campaignDate: campaignDate ?? this.campaignDate,
      withdrawalEndDate: withdrawalEndDate ?? this.withdrawalEndDate,
      veterinarianId: veterinarianId ?? this.veterinarianId,
      veterinarianName: veterinarianName ?? this.veterinarianName,
      animalIds: animalIds ?? this.animalIds,
      completed: completed ?? this.completed,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
    );
  }

  /// Marquer comme synchronisé avec le serveur
  Campaign markAsSynced({required String serverVersion}) {
    return copyWith(
      synced: true,
      lastSyncedAt: DateTime.now(),
      serverVersion: serverVersion,
    );
  }

  /// Marquer comme modifié (à synchroniser)
  Campaign markAsModified() {
    return copyWith(
      synced: false,
      updatedAt: DateTime.now(),
    );
  }

  /// Marquer comme complétée
  Campaign markAsCompleted() {
    return copyWith(
      completed: true,
      synced: false,
      updatedAt: DateTime.now(),
    );
  }

  /// Ajouter un animal à la campagne
  Campaign addAnimal(String animalId) {
    if (animalIds.contains(animalId)) return this;
    return copyWith(
      animalIds: [...animalIds, animalId],
      synced: false,
      updatedAt: DateTime.now(),
    );
  }

  /// Retirer un animal de la campagne
  Campaign removeAnimal(String animalId) {
    if (!animalIds.contains(animalId)) return this;
    return copyWith(
      animalIds: animalIds.where((id) => id != animalId).toList(),
      synced: false,
      updatedAt: DateTime.now(),
    );
  }

  // ==================== Sérialisation ====================

  /// Conversion vers JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmId': farmId,
      'name': name,
      'productId': productId,
      'productName': productName,
      'campaignDate': campaignDate.toIso8601String(),
      'withdrawalEndDate': withdrawalEndDate.toIso8601String(),
      'veterinarianId': veterinarianId,
      'veterinarianName': veterinarianName,
      'animalIds': animalIds,
      'completed': completed,
      'synced': synced,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastSyncedAt': lastSyncedAt?.toIso8601String(),
      'serverVersion': serverVersion,
    };
  }

  /// Création depuis JSON
  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'],
      farmId: json['farmId'] as String? ??
          json['farm_id'] as String? ??
          'mock-farm-001',
      name: json['name'],
      productId: json['productId'] ?? json['product_id'],
      productName: json['productName'] ?? json['product_name'],
      campaignDate:
          DateTime.parse(json['campaignDate'] ?? json['campaign_date']),
      withdrawalEndDate: DateTime.parse(
          json['withdrawalEndDate'] ?? json['withdrawal_end_date']),
      veterinarianId: json['veterinarianId'] ?? json['veterinarian_id'],
      veterinarianName: json['veterinarianName'] ?? json['veterinarian_name'],
      animalIds:
          List<String>.from(json['animalIds'] ?? json['animal_ids'] ?? []),
      completed: json['completed'] ?? false,
      synced: json['synced'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? json['created_at']),
      updatedAt: json['updatedAt'] != null || json['updated_at'] != null
          ? DateTime.parse(json['updatedAt'] ?? json['updated_at'])
          : DateTime.now(),
      lastSyncedAt:
          json['lastSyncedAt'] != null || json['last_synced_at'] != null
              ? DateTime.parse(json['lastSyncedAt'] ?? json['last_synced_at'])
              : null,
      serverVersion: json['serverVersion'] ?? json['server_version'],
    );
  }

  @override
  String toString() {
    return 'Campaign(id: $id, name: $name, productName: $productName, '
        'animalCount: $animalCount, veterinarianName: $veterinarianName, '
        'completed: $completed, synced: $synced)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Campaign && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
