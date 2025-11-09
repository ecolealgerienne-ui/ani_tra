// lib/providers/campaign_provider.dart
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/campaign.dart';
import '../models/product.dart';
import '../models/treatment.dart';
import '../repositories/campaign_repository.dart';
import 'auth_provider.dart';

const uuid = Uuid();

/// CampaignProvider - Phase 1C
/// CHANGEMENT: Utilise Repository pour Campaigns (SQLite)
class CampaignProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  final CampaignRepository _repository;
  String _currentFarmId;

  // Données principales (cache local)
  final List<Campaign> _allCampaigns = [];

  // Loading state
  bool _isLoading = false;

  Campaign? _activeCampaign;

  CampaignProvider(this._authProvider, this._repository)
      : _currentFarmId = _authProvider.currentFarmId {
    _authProvider.addListener(_onFarmChanged);
    _loadCampaignsFromRepository();
  }

  void _onFarmChanged() {
    if (_currentFarmId != _authProvider.currentFarmId) {
      _currentFarmId = _authProvider.currentFarmId;
      _activeCampaign = null;
      _loadCampaignsFromRepository();
    }
  }

  // ==================== Getters ====================

  List<Campaign> get campaigns => List.unmodifiable(
      _allCampaigns.where((c) => c.farmId == _authProvider.currentFarmId));

  List<Campaign> get completedCampaigns =>
      campaigns.where((c) => c.completed).toList();

  List<Campaign> get activeCampaigns =>
      campaigns.where((c) => !c.completed).toList();

  Campaign? get activeCampaign => _activeCampaign;
  bool get isLoading => _isLoading;

  int get activeCampaignsCount => activeCampaigns.length;
  int get completedCampaignsCount => completedCampaigns.length;
  int get campaignsCount => campaigns.length;

  // ==================== Repository Loading ====================

  Future<void> _loadCampaignsFromRepository() async {
    if (_currentFarmId.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final farmCampaigns = await _repository.findAllByFarm(_currentFarmId);
      _allCampaigns.removeWhere((c) => c.farmId == _currentFarmId);
      _allCampaigns.addAll(farmCampaigns);
    } catch (e) {
      debugPrint('❌ Error loading campaigns from repository: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void loadMockCampaigns(List<Campaign> mockCampaigns) {
    _migrateCampaignsToRepository(mockCampaigns);
  }

  Future<void> _migrateCampaignsToRepository(List<Campaign> campaigns) async {
    for (final campaign in campaigns) {
      try {
        await _repository.create(campaign, campaign.farmId);
      } catch (e) {
        debugPrint('⚠️ Campaign ${campaign.id} already exists or error: $e');
      }
    }
    await _loadCampaignsFromRepository();
  }

  // ==================== CRUD ====================

  Future<Campaign> createCampaign({
    required String name,
    required Product product,
    required DateTime treatmentDate,
    String? veterinarianId,
    String? veterinarianName,
  }) async {
    final withdrawalEnd =
        treatmentDate.add(Duration(days: product.withdrawalDaysMeat));

    final campaign = Campaign(
      id: uuid.v4(),
      name: name,
      productId: product.id,
      productName: product.name,
      campaignDate: treatmentDate,
      withdrawalEndDate: withdrawalEnd,
      veterinarianId: veterinarianId,
      veterinarianName: veterinarianName,
      animalIds: const [],
      completed: false,
      synced: false,
      createdAt: DateTime.now(),
      farmId: _authProvider.currentFarmId,
    );

    try {
      await _repository.create(campaign, _authProvider.currentFarmId);
      _allCampaigns.add(campaign);
      _activeCampaign = campaign;
      notifyListeners();
      return campaign;
    } catch (e) {
      debugPrint('❌ Error creating campaign: $e');
      rethrow;
    }
  }

  void setActiveCampaign(Campaign campaign) {
    _activeCampaign = campaign;
    notifyListeners();
  }

  Future<bool> addAnimalToActiveCampaign(String animalId) async {
    final current = _activeCampaign;
    if (current == null) return false;
    if (current.animalIds.contains(animalId)) return false;

    final updatedIds = [...current.animalIds, animalId];
    final updatedCampaign = current.copyWith(animalIds: updatedIds);

    try {
      await _repository.update(updatedCampaign, _authProvider.currentFarmId);

      final index = _allCampaigns.indexWhere((c) => c.id == current.id);
      if (index != -1) {
        _allCampaigns[index] = updatedCampaign;
        _activeCampaign = updatedCampaign;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error adding animal to campaign: $e');
      return false;
    }
  }

  void addScannedAnimal(String animalId) {
    addAnimalToActiveCampaign(animalId);
  }

  bool isAnimalScannedInActiveCampaign(String animalId) {
    final current = _activeCampaign;
    if (current == null) return false;
    return current.animalIds.contains(animalId);
  }

  Future<bool> removeAnimalFromActiveCampaign(String animalId) async {
    final current = _activeCampaign;
    if (current == null) return false;
    if (!current.animalIds.contains(animalId)) return false;

    final updatedIds = current.animalIds.where((id) => id != animalId).toList();
    final updatedCampaign = current.copyWith(animalIds: updatedIds);

    try {
      await _repository.update(updatedCampaign, _authProvider.currentFarmId);

      final index = _allCampaigns.indexWhere((c) => c.id == current.id);
      if (index != -1) {
        _allCampaigns[index] = updatedCampaign;
        _activeCampaign = updatedCampaign;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error removing animal from campaign: $e');
      return false;
    }
  }

  Future<void> completeActiveCampaign() async {
    final current = _activeCampaign;
    if (current == null) return;

    final updated = current.copyWith(
      completed: true,
      updatedAt: DateTime.now(),
    );

    try {
      await _repository.update(updated, _authProvider.currentFarmId);

      final index = _allCampaigns.indexWhere((c) => c.id == current.id);
      if (index != -1) {
        _allCampaigns[index] = updated;
      }

      _activeCampaign = null;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error completing campaign: $e');
      rethrow;
    }
  }

  Future<void> completeCampaign(String campaignId) async {
    if (_activeCampaign?.id == campaignId) {
      await completeActiveCampaign();
      return;
    }

    final index = _allCampaigns.indexWhere((c) => c.id == campaignId);
    if (index != -1) {
      final campaign = _allCampaigns[index];
      final updated = campaign.copyWith(
        completed: true,
        updatedAt: DateTime.now(),
      );

      try {
        await _repository.update(updated, _authProvider.currentFarmId);
        _allCampaigns[index] = updated;
        notifyListeners();
      } catch (e) {
        debugPrint('❌ Error completing campaign: $e');
        rethrow;
      }
    }
  }

  Future<void> cancelActiveCampaign() async {
    final current = _activeCampaign;
    if (current == null) return;

    if (current.animalIds.isEmpty) {
      await deleteCampaign(current.id);
    }

    _activeCampaign = null;
    notifyListeners();
  }

  Future<void> deleteCampaign(String campaignId) async {
    try {
      await _repository.delete(campaignId, _authProvider.currentFarmId);

      _allCampaigns.removeWhere((c) => c.id == campaignId);
      if (_activeCampaign?.id == campaignId) {
        _activeCampaign = null;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error deleting campaign: $e');
      rethrow;
    }
  }

  // ==================== Query Methods ====================

  Campaign? getCampaignById(String id) {
    try {
      return campaigns.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> updateCampaign(Campaign updated) async {
    try {
      await _repository.update(updated, _authProvider.currentFarmId);

      final index = _allCampaigns.indexWhere((c) => c.id == updated.id);
      if (index != -1) {
        _allCampaigns[index] = updated;
        if (_activeCampaign?.id == updated.id) {
          _activeCampaign = _allCampaigns[index];
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error updating campaign: $e');
      rethrow;
    }
  }

  void markCampaignAsSynced(String campaignId) {
    if (_allCampaigns.any((c) => c.id == campaignId)) {
      notifyListeners();
    }
  }

  List<Treatment> expandCampaignToTreatments(Campaign campaign) {
    return campaign.animalIds.map((animalId) {
      return Treatment(
        id: uuid.v4(),
        animalId: animalId,
        productId: campaign.productId,
        productName: campaign.productName,
        dose: 0.0,
        treatmentDate: campaign.campaignDate,
        withdrawalEndDate: campaign.withdrawalEndDate,
        notes: null,
        createdAt: DateTime.now(),
        farmId: campaign.farmId,
      );
    }).toList();
  }

  List<Treatment> generateTreatmentsFromCampaign(Campaign campaign) {
    return expandCampaignToTreatments(campaign);
  }

  void clearAllCampaigns() {
    _allCampaigns.clear();
    _activeCampaign = null;
    notifyListeners();
  }

  // ==================== Refresh ====================

  Future<void> refresh() async {
    await _loadCampaignsFromRepository();
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onFarmChanged);
    super.dispose();
  }
}
