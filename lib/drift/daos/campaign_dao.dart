// lib/drift/daos/campaign_dao.dart
import 'dart:convert';
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/campaigns_table.dart';

part 'campaign_dao.g.dart';

@DriftAccessor(tables: [CampaignsTable])
class CampaignDao extends DatabaseAccessor<AppDatabase>
    with _$CampaignDaoMixin {
  CampaignDao(super.db);

  // 1. Get all campaigns for a farm
  Future<List<CampaignsTableData>> findAllByFarm(String farmId) {
    return (select(campaignsTable)
          ..where((t) => t.farmId.equals(farmId))
          ..orderBy([(t) => OrderingTerm.desc(t.campaignDate)]))
        .get();
  }

  // 2. Get campaign by ID
  Future<CampaignsTableData?> findById(String id) {
    return (select(campaignsTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // 3. Get active campaigns (not completed) for a farm
  Future<List<CampaignsTableData>> findActiveByFarm(String farmId) {
    return (select(campaignsTable)
          ..where((t) => t.farmId.equals(farmId) & t.completed.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.campaignDate)]))
        .get();
  }

  // 4. Get completed campaigns for a farm
  Future<List<CampaignsTableData>> findCompletedByFarm(String farmId) {
    return (select(campaignsTable)
          ..where((t) => t.farmId.equals(farmId) & t.completed.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.campaignDate)]))
        .get();
  }

  // 5. Get campaigns by product for a farm
  Future<List<CampaignsTableData>> findByProductId(
      String productId, String farmId) {
    return (select(campaignsTable)
          ..where(
              (t) => t.farmId.equals(farmId) & t.productId.equals(productId))
          ..orderBy([(t) => OrderingTerm.desc(t.campaignDate)]))
        .get();
  }

  // 6. Get campaigns by veterinarian for a farm
  Future<List<CampaignsTableData>> findByVeterinarianId(
      String veterinarianId, String farmId) {
    return (select(campaignsTable)
          ..where((t) =>
              t.farmId.equals(farmId) & t.veterinarianId.equals(veterinarianId))
          ..orderBy([(t) => OrderingTerm.desc(t.campaignDate)]))
        .get();
  }

  // 7. Get campaigns containing a specific animal
  Future<List<CampaignsTableData>> findByAnimalId(
      String animalId, String farmId) async {
    final allCampaigns = await findAllByFarm(farmId);

    return allCampaigns.where((campaign) {
      final animalIds = _decodeAnimalIds(campaign.animalIdsJson);
      return animalIds.contains(animalId);
    }).toList();
  }

  // 8. Get campaigns with upcoming withdrawal dates
  Future<List<CampaignsTableData>> findWithUpcomingWithdrawal(
      String farmId, DateTime beforeDate) {
    return (select(campaignsTable)
          ..where((t) =>
              t.farmId.equals(farmId) &
              t.withdrawalEndDate.isSmallerOrEqualValue(beforeDate) &
              t.completed.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.withdrawalEndDate)]))
        .get();
  }

  // 9. Get campaigns within a date range
  Future<List<CampaignsTableData>> findByDateRange(
      String farmId, DateTime startDate, DateTime endDate) {
    return (select(campaignsTable)
          ..where((t) =>
              t.farmId.equals(farmId) &
              t.campaignDate.isBiggerOrEqualValue(startDate) &
              t.campaignDate.isSmallerOrEqualValue(endDate))
          ..orderBy([(t) => OrderingTerm.desc(t.campaignDate)]))
        .get();
  }

  // 10. Insert campaign
  Future<int> insertCampaign(CampaignsTableCompanion campaign) {
    return into(campaignsTable).insert(campaign);
  }

  // 11. Update campaign
  Future<bool> updateCampaign(CampaignsTableCompanion campaign) {
    return update(campaignsTable).replace(campaign);
  }

  // 12. Delete campaign
  Future<int> deleteCampaign(String id) {
    return (delete(campaignsTable)..where((t) => t.id.equals(id))).go();
  }

  // 13. Mark campaign as completed
  Future<int> markAsCompleted(String id) {
    return (update(campaignsTable)..where((t) => t.id.equals(id))).write(
      CampaignsTableCompanion(
        completed: const Value(true),
        synced: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // 14. Add animal to campaign
  Future<void> addAnimalToCampaign(String campaignId, String animalId) async {
    final campaign = await findById(campaignId);
    if (campaign == null) return;

    final animalIds = _decodeAnimalIds(campaign.animalIdsJson);
    if (!animalIds.contains(animalId)) {
      animalIds.add(animalId);

      await (update(campaignsTable)..where((t) => t.id.equals(campaignId)))
          .write(
        CampaignsTableCompanion(
          animalIdsJson: Value(_encodeAnimalIds(animalIds)),
          synced: const Value(false),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  // 15. Remove animal from campaign
  Future<void> removeAnimalFromCampaign(
      String campaignId, String animalId) async {
    final campaign = await findById(campaignId);
    if (campaign == null) return;

    final animalIds = _decodeAnimalIds(campaign.animalIdsJson);
    if (animalIds.contains(animalId)) {
      animalIds.remove(animalId);

      await (update(campaignsTable)..where((t) => t.id.equals(campaignId)))
          .write(
        CampaignsTableCompanion(
          animalIdsJson: Value(_encodeAnimalIds(animalIds)),
          synced: const Value(false),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  // 16. Count campaigns by farm
  Future<int> countByFarm(String farmId) async {
    final query = selectOnly(campaignsTable)
      ..addColumns([campaignsTable.id.count()])
      ..where(campaignsTable.farmId.equals(farmId));

    final result = await query.getSingleOrNull();
    return result?.read(campaignsTable.id.count()) ?? 0;
  }

  // 17. Count active campaigns by farm
  Future<int> countActiveByFarm(String farmId) async {
    final query = selectOnly(campaignsTable)
      ..addColumns([campaignsTable.id.count()])
      ..where(campaignsTable.farmId.equals(farmId) &
          campaignsTable.completed.equals(false));

    final result = await query.getSingleOrNull();
    return result?.read(campaignsTable.id.count()) ?? 0;
  }

  // 18. Count campaigns by product for a farm
  Future<int> countByProductId(String productId, String farmId) async {
    final query = selectOnly(campaignsTable)
      ..addColumns([campaignsTable.id.count()])
      ..where(campaignsTable.farmId.equals(farmId) &
          campaignsTable.productId.equals(productId));

    final result = await query.getSingleOrNull();
    return result?.read(campaignsTable.id.count()) ?? 0;
  }

  // 19. Get unsynced campaigns for a farm
  Future<List<CampaignsTableData>> findUnsyncedByFarm(String farmId) {
    return (select(campaignsTable)
          ..where((t) => t.farmId.equals(farmId) & t.synced.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.updatedAt)]))
        .get();
  }

  // ==================== Helper Methods ====================

  /// Encode List String to JSON string
  String _encodeAnimalIds(List<String> animalIds) {
    return jsonEncode(animalIds);
  }

  /// Decode JSON string to List String
  List<String> _decodeAnimalIds(String jsonString) {
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is List) {
        return decoded.cast<String>();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
