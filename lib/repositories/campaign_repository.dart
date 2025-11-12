// lib/repositories/campaign_repository.dart
import 'dart:convert';
import '../models/campaign.dart';
import '../drift/database.dart';
import '../drift/daos/campaign_dao.dart';
import 'package:drift/drift.dart' as drift;

/// Repository pour gérer la persistance des campagnes
/// Phase 1C: Avec security checks farmId
class CampaignRepository {
  final CampaignDao _dao;

  CampaignRepository(AppDatabase database) : _dao = database.campaignDao;

  // ==================== CRUD Operations ====================

  /// Récupérer toutes les campagnes d'une ferme
  Future<List<Campaign>> findAllByFarm(String farmId) async {
    final data = await _dao.findAllByFarm(farmId);
    return data.map(_toCampaign).toList();
  }

  /// Récupérer une campagne par son ID (avec vérification farmId)
  Future<Campaign?> findById(String id, String farmId) async {
    final data = await _dao.findById(id, farmId);
    if (data == null) return null;

    return _toCampaign(data);
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

  /// Créer une nouvelle campagne avec validation farmId
  Future<Campaign> create(Campaign campaign, String farmId) async {
    // Security check: vérifier que la campagne appartient à cette ferme
    if (campaign.farmId != farmId) {
      throw Exception('Farm ID mismatch - Security violation');
    }

    final companion = _toCompanion(campaign, isUpdate: false);
    await _dao.insertCampaign(companion);
    return campaign;
  }

  /// Mettre à jour une campagne avec security check
  Future<Campaign> update(Campaign campaign, String farmId) async {
    // Security check: vérifier l'ownership
    final existing = await _dao.findById(campaign.id, farmId);
    if (existing == null) {
      throw Exception(
          'Campaign not found or farm mismatch - Security violation');
    }

    // Double-check: la campagne à updater doit aussi matcher
    if (campaign.farmId != farmId) {
      throw Exception('Farm ID mismatch - Security violation');
    }

    final companion = _toCompanion(campaign, isUpdate: true);
    await _dao.updateCampaign(companion, farmId);
    return campaign;
  }

  /// Supprimer une campagne avec security check
  Future<void> delete(String id, String farmId) async {
    // Security check: vérifier l'ownership
    final existing = await _dao.findById(id, farmId);
    if (existing == null) {
      throw Exception(
          'Campaign not found or farm mismatch - Security violation');
    }

    await _dao.softDelete(id, farmId);
  }

  // ==================== Business Logic ====================

  /// Marquer une campagne comme complétée avec security check
  Future<void> markAsCompleted(String id, String farmId) async {
    // Security check
    final existing = await _dao.findById(id, farmId);
    if (existing == null) {
      throw Exception(
          'Campaign not found or farm mismatch - Security violation');
    }

    await _dao.markAsCompleted(id, farmId);
  }

  /// Ajouter un animal à la campagne avec security check
  Future<void> addAnimalToCampaign(
      String campaignId, String animalId, String farmId) async {
    // Security check
    final existing = await _dao.findById(campaignId, farmId);
    if (existing == null) {
      throw Exception(
          'Campaign not found or farm mismatch - Security violation');
    }

    await _dao.addAnimalToCampaign(campaignId, animalId, farmId);
  }

  /// Retirer un animal de la campagne avec security check
  Future<void> removeAnimalFromCampaign(
      String campaignId, String animalId, String farmId) async {
    // Security check
    final existing = await _dao.findById(campaignId, farmId);
    if (existing == null) {
      throw Exception(
          'Campaign not found or farm mismatch - Security violation');
    }

    await _dao.removeAnimalFromCampaign(campaignId, animalId, farmId);
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

  /// Insérer plusieurs campagnes (pour migration) avec validation farmId
  Future<void> insertAll(List<Campaign> campaigns, String farmId) async {
    for (final campaign in campaigns) {
      // Vérifier que toutes les campagnes appartiennent à cette ferme
      if (campaign.farmId != farmId) {
        throw Exception(
            'Farm ID mismatch in campaign ${campaign.id} - Security violation');
      }
      await create(campaign, farmId);
    }
  }

  /// Supprimer toutes les campagnes d'une ferme
  Future<void> deleteAllByFarm(String farmId) async {
    final campaigns = await findAllByFarm(farmId);
    for (final campaign in campaigns) {
      await delete(campaign.id, farmId);
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
