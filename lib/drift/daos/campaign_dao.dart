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
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.campaignDate)]))
        .get();
  }

  // 2. Get campaign by ID (avec security check farmId)
  Future<CampaignsTableData?> findById(String id, String farmId) {
    return (select(campaignsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId))
          ..where((t) => t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  // 3. Get active campaigns (not completed) for a farm
  Future<List<CampaignsTableData>> findActiveByFarm(String farmId) {
    return (select(campaignsTable)
          ..where((t) => t.farmId.equals(farmId) & t.completed.equals(false))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.campaignDate)]))
        .get();
  }

  // 4. Get completed campaigns for a farm
  Future<List<CampaignsTableData>> findCompletedByFarm(String farmId) {
    return (select(campaignsTable)
          ..where((t) => t.farmId.equals(farmId) & t.completed.equals(true))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.campaignDate)]))
        .get();
  }

  // 5. Get campaigns by product for a farm
  Future<List<CampaignsTableData>> findByProductId(
      String productId, String farmId) {
    return (select(campaignsTable)
          ..where(
              (t) => t.farmId.equals(farmId) & t.productId.equals(productId))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.campaignDate)]))
        .get();
  }

  // 6. Get campaigns by veterinarian for a farm
  Future<List<CampaignsTableData>> findByVeterinarianId(
      String veterinarianId, String farmId) {
    return (select(campaignsTable)
          ..where((t) =>
              t.farmId.equals(farmId) & t.veterinarianId.equals(veterinarianId))
          ..where((t) => t.deletedAt.isNull())
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
          ..where((t) => t.deletedAt.isNull())
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
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.campaignDate)]))
        .get();
  }

  // 10. Insert campaign
  Future<int> insertCampaign(CampaignsTableCompanion campaign) {
    return into(campaignsTable).insert(campaign);
  }

  // 11. Update campaign (avec farmId security check)
  Future<int> updateCampaign(CampaignsTableCompanion campaign, String farmId) {
    return (update(campaignsTable)..where((t) => t.farmId.equals(farmId)))
        .write(campaign);
  }

  // 12. Soft-delete campaign (audit trail)
  Future<int> softDelete(String id, String farmId) {
    return (update(campaignsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(CampaignsTableCompanion(
      deletedAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // 13. Mark campaign as completed (avec security check farmId)
  Future<int> markAsCompleted(String id, String farmId) {
    return (update(campaignsTable)
          ..where((t) => t.id.equals(id))
          ..where((t) => t.farmId.equals(farmId)))
        .write(
      CampaignsTableCompanion(
        completed: const Value(true),
        synced: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // 14. Add animal to campaign (avec security check farmId)
  Future<void> addAnimalToCampaign(
      String campaignId, String animalId, String farmId) async {
    final campaign = await findById(campaignId, farmId);
    if (campaign == null) return;

    final animalIds = _decodeAnimalIds(campaign.animalIdsJson);
    if (!animalIds.contains(animalId)) {
      animalIds.add(animalId);

      await (update(campaignsTable)
            ..where((t) => t.id.equals(campaignId))
            ..where((t) => t.farmId.equals(farmId)))
          .write(
        CampaignsTableCompanion(
          animalIdsJson: Value(_encodeAnimalIds(animalIds)),
          synced: const Value(false),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  // 15. Remove animal from campaign (avec security check farmId)
  Future<void> removeAnimalFromCampaign(
      String campaignId, String animalId, String farmId) async {
    final campaign = await findById(campaignId, farmId);
    if (campaign == null) return;

    final animalIds = _decodeAnimalIds(campaign.animalIdsJson);
    if (animalIds.contains(animalId)) {
      animalIds.remove(animalId);

      await (update(campaignsTable)
            ..where((t) => t.id.equals(campaignId))
            ..where((t) => t.farmId.equals(farmId)))
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
      ..where(campaignsTable.farmId.equals(farmId))
      ..where(campaignsTable.deletedAt.isNull());

    final result = await query.getSingleOrNull();
    return result?.read(campaignsTable.id.count()) ?? 0;
  }

  // 17. Count active campaigns by farm
  Future<int> countActiveByFarm(String farmId) async {
    final query = selectOnly(campaignsTable)
      ..addColumns([campaignsTable.id.count()])
      ..where(campaignsTable.farmId.equals(farmId) &
          campaignsTable.completed.equals(false))
      ..where(campaignsTable.deletedAt.isNull());

    final result = await query.getSingleOrNull();
    return result?.read(campaignsTable.id.count()) ?? 0;
  }

  // 18. Count campaigns by product for a farm
  Future<int> countByProductId(String productId, String farmId) async {
    final query = selectOnly(campaignsTable)
      ..addColumns([campaignsTable.id.count()])
      ..where(campaignsTable.farmId.equals(farmId) &
          campaignsTable.productId.equals(productId))
      ..where(campaignsTable.deletedAt.isNull());

    final result = await query.getSingleOrNull();
    return result?.read(campaignsTable.id.count()) ?? 0;
  }

  // 19. Get unsynced campaigns for a farm
  Future<List<CampaignsTableData>> findUnsyncedByFarm(String farmId) {
    return (select(campaignsTable)
          ..where((t) => t.farmId.equals(farmId) & t.synced.equals(false))
          ..where((t) => t.deletedAt.isNull())
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
