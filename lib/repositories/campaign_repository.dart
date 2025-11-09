// lib/repositories/campaign_repository.dart
import 'dart:convert';
import '../models/campaign.dart';
import '../drift/database.dart';
import '../drift/daos/campaign_dao.dart';
//import '../drift/tables/campaigns_table.dart';
import 'package:drift/drift.dart' as drift;

/// Repository pour gérer la persistance des campagnes
///
/// Fait le pont entre les models Dart et la base de données Drift
class CampaignRepository {
  final CampaignDao _dao;

  CampaignRepository(AppDatabase database) : _dao = database.campaignDao;

  // ==================== CRUD Operations ====================

  /// Récupérer toutes les campagnes d'une ferme
  Future<List<Campaign>> findAllByFarm(String farmId) async {
    final data = await _dao.findAllByFarm(farmId);
    return data.map(_toCampaign).toList();
  }

  /// Récupérer une campagne par son ID
  Future<Campaign?> findById(String id) async {
    final data = await _dao.findById(id);
    return data != null ? _toCampaign(data) : null;
  }

  /// Récupérer les campagnes actives (non complétées) d'une ferme
  Future<List<Campaign>> findActiveByFarm(String farmId) async {
    final data = await _dao.findActiveByFarm(farmId);
    return data.map(_toCampaign).toList();
  }

  /// Récupérer les campagnes complétées d'une ferme
  Future<List<Campaign>> findCompletedByFarm(String farmId) async {
    final data = await _dao.findCompletedByFarm(farmId);
    return data.map(_toCampaign).toList();
  }

  /// Récupérer les campagnes par produit pour une ferme
  Future<List<Campaign>> findByProductId(
      String productId, String farmId) async {
    final data = await _dao.findByProductId(productId, farmId);
    return data.map(_toCampaign).toList();
  }

  /// Récupérer les campagnes par vétérinaire pour une ferme
  Future<List<Campaign>> findByVeterinarianId(
      String veterinarianId, String farmId) async {
    final data = await _dao.findByVeterinarianId(veterinarianId, farmId);
    return data.map(_toCampaign).toList();
  }

  /// Récupérer les campagnes contenant un animal spécifique
  Future<List<Campaign>> findByAnimalId(String animalId, String farmId) async {
    final data = await _dao.findByAnimalId(animalId, farmId);
    return data.map(_toCampaign).toList();
  }

  /// Récupérer les campagnes avec dates de rémanence proches
  Future<List<Campaign>> findWithUpcomingWithdrawal(
      String farmId, DateTime beforeDate) async {
    final data = await _dao.findWithUpcomingWithdrawal(farmId, beforeDate);
    return data.map(_toCampaign).toList();
  }

  /// Récupérer les campagnes dans une plage de dates
  Future<List<Campaign>> findByDateRange(
      String farmId, DateTime startDate, DateTime endDate) async {
    final data = await _dao.findByDateRange(farmId, startDate, endDate);
    return data.map(_toCampaign).toList();
  }

  /// Créer une nouvelle campagne
  Future<Campaign> create(Campaign campaign) async {
    final companion = _toCompanion(campaign, isUpdate: false);
    await _dao.insertCampaign(companion);
    return campaign;
  }

  /// Mettre à jour une campagne
  Future<Campaign> update(Campaign campaign) async {
    final companion = _toCompanion(campaign, isUpdate: true);
    await _dao.updateCampaign(companion);
    return campaign;
  }

  /// Supprimer une campagne
  Future<void> delete(String id) async {
    await _dao.deleteCampaign(id);
  }

  // ==================== Business Logic ====================

  /// Marquer une campagne comme complétée
  Future<void> markAsCompleted(String id) async {
    await _dao.markAsCompleted(id);
  }

  /// Ajouter un animal à la campagne
  Future<void> addAnimalToCampaign(String campaignId, String animalId) async {
    await _dao.addAnimalToCampaign(campaignId, animalId);
  }

  /// Retirer un animal de la campagne
  Future<void> removeAnimalFromCampaign(
      String campaignId, String animalId) async {
    await _dao.removeAnimalFromCampaign(campaignId, animalId);
  }

  /// Compter les campagnes d'une ferme
  Future<int> countByFarm(String farmId) async {
    return await _dao.countByFarm(farmId);
  }

  /// Compter les campagnes actives d'une ferme
  Future<int> countActiveByFarm(String farmId) async {
    return await _dao.countActiveByFarm(farmId);
  }

  /// Compter les campagnes par produit pour une ferme
  Future<int> countByProductId(String productId, String farmId) async {
    return await _dao.countByProductId(productId, farmId);
  }

  /// Récupérer les campagnes non synchronisées d'une ferme
  Future<List<Campaign>> findUnsyncedByFarm(String farmId) async {
    final data = await _dao.findUnsyncedByFarm(farmId);
    return data.map(_toCampaign).toList();
  }

  // ==================== Migration Support ====================

  /// Insérer plusieurs campagnes (pour migration)
  Future<void> insertAll(List<Campaign> campaigns) async {
    for (final campaign in campaigns) {
      await create(campaign);
    }
  }

  /// Supprimer toutes les campagnes d'une ferme
  Future<void> deleteAllByFarm(String farmId) async {
    final campaigns = await findAllByFarm(farmId);
    for (final campaign in campaigns) {
      await delete(campaign.id);
    }
  }

  // ==================== Conversion Methods ====================

  /// Convertir CampaignsTableData en Campaign
  Campaign _toCampaign(CampaignsTableData data) {
    // Décoder le JSON des animal_ids
    List<String> animalIds = [];
    try {
      final decoded = jsonDecode(data.animalIdsJson);
      if (decoded is List) {
        animalIds = decoded.cast<String>();
      }
    } catch (e) {
      animalIds = [];
    }

    return Campaign(
      id: data.id,
      farmId: data.farmId,
      name: data.name,
      productId: data.productId,
      productName: data.productName,
      campaignDate: data.campaignDate,
      withdrawalEndDate: data.withdrawalEndDate,
      veterinarianId: data.veterinarianId,
      veterinarianName: data.veterinarianName,
      animalIds: animalIds,
      completed: data.completed,
      synced: data.synced,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      lastSyncedAt: data.lastSyncedAt,
      serverVersion: data.serverVersion,
    );
  }

  /// Convertir Campaign en CampaignsTableCompanion
  CampaignsTableCompanion _toCompanion(Campaign campaign,
      {required bool isUpdate}) {
    // Encoder animal_ids en JSON
    final animalIdsJson = jsonEncode(campaign.animalIds);

    return CampaignsTableCompanion(
      id: drift.Value(campaign.id),
      farmId: drift.Value(campaign.farmId),
      name: drift.Value(campaign.name),
      productId: drift.Value(campaign.productId),
      productName: drift.Value(campaign.productName),
      campaignDate: drift.Value(campaign.campaignDate),
      withdrawalEndDate: drift.Value(campaign.withdrawalEndDate),
      veterinarianId: drift.Value(campaign.veterinarianId),
      veterinarianName: drift.Value(campaign.veterinarianName),
      animalIdsJson: drift.Value(animalIdsJson),
      completed: drift.Value(campaign.completed),
      synced: drift.Value(campaign.synced),
      createdAt: drift.Value(campaign.createdAt),
      updatedAt: drift.Value(campaign.updatedAt),
      lastSyncedAt: drift.Value(campaign.lastSyncedAt),
      serverVersion: drift.Value(campaign.serverVersion),
    );
  }
}
