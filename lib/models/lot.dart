// lib/models/lot.dart
import 'package:uuid/uuid.dart';
import 'syncable_entity.dart';

/// Type de lot
enum LotType {
  /// Traitement sanitaire (ancienne campagne)
  treatment,

  /// Vente d'animaux
  sale,

  /// Abattage
  slaughter,
}

/// Extensions pour LotType
extension LotTypeExt on LotType {
  /// ⚠️ IMPORTANT : Les labels FR sont hardcodés ici car LotType
  /// est un ENUM sans accès au BuildContext.
  ///
  /// La traduction se fera au niveau Provider/UI qui a accès au context.
  /// Label en français
  String get label {
    switch (this) {
      case LotType.treatment:
        return 'Traitement';
      case LotType.sale:
        return 'Vente';
      case LotType.slaughter:
        return 'Abattage';
    }
  }

  /// Icône
  String get icon {
    switch (this) {
      case LotType.treatment:
        return '💊';
      case LotType.sale:
        return '💰';
      case LotType.slaughter:
        return '🏭';
    }
  }
}

/// Statut du lot
enum LotStatus {
  /// Lot ouvert, modifiable
  open,

  /// Lot fermé, non modifiable
  closed,

  /// Lot archivé, vue-seulement
  archived,
}

/// Modèle Lot unifié (Traitement/Vente/Abattage)
///
/// Permet de gérer différents types de lots dans un seul modèle :
/// - Traitement sanitaire (campagne)
/// - Vente d'animaux
/// - Abattage
class Lot implements SyncableEntity {
  /// Identifiant unique du lot
  @override
  final String id;

  /// ID de la ferme (multi-tenancy)
  @override
  final String farmId;

  /// Nom du lot
  final String name;

  /// Type du lot (null = non défini, à définir lors de la finalisation)
  final LotType? type;

  /// Liste des IDs d'animaux dans le lot
  final List<String> animalIds;

  /// Statut du lot (PHASE 1: nullable pour backward-compat)
  final LotStatus? status;

  /// Le lot est-il complété (fermé) ? (PHASE 1: KEEP pour migration)
  final bool completed;

  /// Date de fermeture du lot
  final DateTime? completedAt;

  // ==================== DONNÉES TRAITEMENT ====================

  /// ID du produit (pour traitement)
  final String? productId;

  /// Nom du produit (pour traitement)
  final String? productName;

  /// Date du traitement
  final DateTime? treatmentDate;

  /// Date de fin de rémanence
  final DateTime? withdrawalEndDate;

  /// ID du vétérinaire
  final String? veterinarianId;

  /// Nom du vétérinaire
  final String? veterinarianName;

  // ==================== DONNÉES VENTE ====================

  /// Nom de l'acheteur
  final String? buyerName;

  /// ID de la ferme de l'acheteur
  final String? buyerFarmId;

  /// Prix total de la vente
  final double? totalPrice;

  /// Prix par animal
  final double? pricePerAnimal;

  /// Date de la vente
  final DateTime? saleDate;

  // ==================== DONNÉES ABATTAGE ====================

  /// Nom de l'abattoir
  final String? slaughterhouseName;

  /// ID de l'abattoir
  final String? slaughterhouseId;

  /// Date d'abattage
  final DateTime? slaughterDate;

  // ==================== NOTES ====================

  /// Notes additionnelles
  final String? notes;

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

  Lot({
    String? id,
    this.farmId = 'mock-farm-001', // Valeur par défaut pour compatibilité mock
    required this.name,
    this.type,
    this.animalIds = const [],
    this.status,
    this.completed = false,
    this.completedAt,
    // Traitement
    this.productId,
    this.productName,
    this.treatmentDate,
    this.withdrawalEndDate,
    this.veterinarianId,
    this.veterinarianName,
    // Vente
    this.buyerName,
    this.buyerFarmId,
    this.totalPrice,
    this.pricePerAnimal,
    this.saleDate,
    // Abattage
    this.slaughterhouseName,
    this.slaughterhouseId,
    this.slaughterDate,
    // Notes
    this.notes,
    // Sync
    this.synced = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastSyncedAt,
    this.serverVersion,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? createdAt ?? DateTime.now();

  // ==================== Getters ====================

  /// Nombre d'animaux dans le lot
  int get animalCount => animalIds.length;

  /// Le lot est-il ouvert (modifiable) ?
  bool get isOpen => status == LotStatus.open || (!completed && status == null);

  /// Le lot est-il fermé (non modifiable) ?
  bool get isClosed => status == LotStatus.closed || (completed && status == null);

  /// Le lot est-il archivé ?
  bool get isArchived => status == LotStatus.archived;

  /// Le lot est-il vide ?
  bool get isEmpty => animalIds.isEmpty;

  /// Le lot contient-il des animaux ?
  bool get isNotEmpty => animalIds.isNotEmpty;

  // ==================== Méthodes ====================

  /// Copier avec modifications
  Lot copyWith({
    String? id,
    String? farmId,
    String? name,
    LotType? type,
    bool clearType = false,
    List<String>? animalIds,
    LotStatus? status,
    bool? completed,
    DateTime? completedAt,
    bool clearCompletedAt = false,
    // Traitement
    String? productId,
    String? productName,
    DateTime? treatmentDate,
    DateTime? withdrawalEndDate,
    String? veterinarianId,
    String? veterinarianName,
    // Vente
    String? buyerName,
    String? buyerFarmId,
    double? totalPrice,
    double? pricePerAnimal,
    DateTime? saleDate,
    // Abattage
    String? slaughterhouseName,
    String? slaughterhouseId,
    DateTime? slaughterDate,
    // Notes
    String? notes,
    // Sync
    bool? synced,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    String? serverVersion,
  }) {
    return Lot(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      name: name ?? this.name,
      type: clearType ? null : (type ?? this.type),
      animalIds: animalIds ?? this.animalIds,
      status: status ?? this.status,
      completed: completed ?? this.completed,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
      // Traitement
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      treatmentDate: treatmentDate ?? this.treatmentDate,
      withdrawalEndDate: withdrawalEndDate ?? this.withdrawalEndDate,
      veterinarianId: veterinarianId ?? this.veterinarianId,
      veterinarianName: veterinarianName ?? this.veterinarianName,
      // Vente
      buyerName: buyerName ?? this.buyerName,
      buyerFarmId: buyerFarmId ?? this.buyerFarmId,
      totalPrice: totalPrice ?? this.totalPrice,
      pricePerAnimal: pricePerAnimal ?? this.pricePerAnimal,
      saleDate: saleDate ?? this.saleDate,
      // Abattage
      slaughterhouseName: slaughterhouseName ?? this.slaughterhouseName,
      slaughterhouseId: slaughterhouseId ?? this.slaughterhouseId,
      slaughterDate: slaughterDate ?? this.slaughterDate,
      // Notes
      notes: notes ?? this.notes,
      // Sync
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
    );
  }

  /// Marquer comme synchronisé avec le serveur
  Lot markAsSynced({required String serverVersion}) {
    return copyWith(
      synced: true,
      lastSyncedAt: DateTime.now(),
      serverVersion: serverVersion,
    );
  }

  /// Marquer comme modifié (à synchroniser)
  Lot markAsModified() {
    return copyWith(
      synced: false,
      updatedAt: DateTime.now(),
    );
  }

  /// Marquer comme complété
  Lot markAsCompleted() {
    return copyWith(
      status: LotStatus.closed,
      completed: true,
      completedAt: DateTime.now(),
      synced: false,
      updatedAt: DateTime.now(),
    );
  }

  /// Ajouter un animal au lot
  Lot addAnimal(String animalId) {
    if (animalIds.contains(animalId)) return this;
    return copyWith(
      animalIds: [...animalIds, animalId],
      synced: false,
      updatedAt: DateTime.now(),
    );
  }

  /// Retirer un animal du lot
  Lot removeAnimal(String animalId) {
    if (!animalIds.contains(animalId)) return this;
    return copyWith(
      animalIds: animalIds.where((id) => id != animalId).toList(),
      synced: false,
      updatedAt: DateTime.now(),
    );
  }

  // ==================== Sérialisation ====================

  /// Convertir en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmId': farmId,
      'name': name,
      'type': type?.name,
      'animalIds': animalIds,
      'status': status?.name,
      'completed': completed,
      'completedAt': completedAt?.toIso8601String(),
      // Traitement
      'productId': productId,
      'productName': productName,
      'treatmentDate': treatmentDate?.toIso8601String(),
      'withdrawalEndDate': withdrawalEndDate?.toIso8601String(),
      'veterinarianId': veterinarianId,
      'veterinarianName': veterinarianName,
      // Vente
      'buyerName': buyerName,
      'buyerFarmId': buyerFarmId,
      'totalPrice': totalPrice,
      'pricePerAnimal': pricePerAnimal,
      'saleDate': saleDate?.toIso8601String(),
      // Abattage
      'slaughterhouseName': slaughterhouseName,
      'slaughterhouseId': slaughterhouseId,
      'slaughterDate': slaughterDate?.toIso8601String(),
      // Notes
      'notes': notes,
      // Sync
      'synced': synced,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastSyncedAt': lastSyncedAt?.toIso8601String(),
      'serverVersion': serverVersion,
    };
  }

  /// Créer depuis JSON
  factory Lot.fromJson(Map<String, dynamic> json) {
    return Lot(
      id: json['id'],
      farmId: json['farmId'] as String? ??
          json['farm_id'] as String? ??
          'mock-farm-001',
      name: json['name'],
      type: json['type'] != null
          ? LotType.values.firstWhere((e) => e.name == json['type'])
          : null,
      animalIds:
          List<String>.from(json['animalIds'] ?? json['animal_ids'] ?? []),
      status: json['status'] != null
          ? LotStatus.values.firstWhere((e) => e.name == json['status'],
              orElse: () => (json['completed'] ?? false)
                  ? LotStatus.closed
                  : LotStatus.open)
          : null,
      completed: json['completed'] ?? false,
      completedAt: json['completedAt'] != null || json['completed_at'] != null
          ? DateTime.parse(json['completedAt'] ?? json['completed_at'])
          : null,
      // Traitement
      productId: json['productId'] ?? json['product_id'],
      productName: json['productName'] ?? json['product_name'],
      treatmentDate:
          json['treatmentDate'] != null || json['treatment_date'] != null
              ? DateTime.parse(json['treatmentDate'] ?? json['treatment_date'])
              : null,
      withdrawalEndDate: json['withdrawalEndDate'] != null ||
              json['withdrawal_end_date'] != null
          ? DateTime.parse(
              json['withdrawalEndDate'] ?? json['withdrawal_end_date'])
          : null,
      veterinarianId: json['veterinarianId'] ?? json['veterinarian_id'],
      veterinarianName: json['veterinarianName'] ?? json['veterinarian_name'],
      // Vente
      buyerName: json['buyerName'] ?? json['buyer_name'],
      buyerFarmId: json['buyerFarmId'] ?? json['buyer_farm_id'],
      totalPrice:
          (json['totalPrice'] ?? json['total_price'] as num?)?.toDouble(),
      pricePerAnimal:
          (json['pricePerAnimal'] ?? json['price_per_animal'] as num?)
              ?.toDouble(),
      saleDate: json['saleDate'] != null || json['sale_date'] != null
          ? DateTime.parse(json['saleDate'] ?? json['sale_date'])
          : null,
      // Abattage
      slaughterhouseName:
          json['slaughterhouseName'] ?? json['slaughterhouse_name'],
      slaughterhouseId: json['slaughterhouseId'] ?? json['slaughterhouse_id'],
      slaughterDate:
          json['slaughterDate'] != null || json['slaughter_date'] != null
              ? DateTime.parse(json['slaughterDate'] ?? json['slaughter_date'])
              : null,
      // Notes
      notes: json['notes'],
      // Sync
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
    return 'Lot(id: $id, name: $name, type: ${type?.label ?? "Non défini"}, '
        'status: ${status?.name ?? "N/A"}, animalCount: $animalCount, synced: $synced)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Lot && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
