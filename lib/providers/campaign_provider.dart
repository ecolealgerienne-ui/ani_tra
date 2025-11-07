// lib/providers/campaign_provider.dart
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/campaign.dart';
import 'auth_provider.dart';
import '../models/product.dart';
import '../models/treatment.dart';

const uuid = Uuid();

/// Provider de gestion des campagnes.
/// Aucune chaîne destinée à l'utilisateur n'est émise ici (multi-langue côté UI).
class CampaignProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  String _currentFarmId;

  CampaignProvider(this._authProvider)
      : _currentFarmId = _authProvider.currentFarmId {
    _authProvider.addListener(_onFarmChanged);
  }

  void _onFarmChanged() {
    if (_currentFarmId != _authProvider.currentFarmId) {
      _currentFarmId = _authProvider.currentFarmId;
      _activeCampaign = null;
      notifyListeners();
    }
  }

  List<Campaign> _allCampaigns = [];
  Campaign? _activeCampaign;

  // ==================== Getters ====================

  List<Campaign> get campaigns => List.unmodifiable(
    _allCampaigns.where((item) => item.farmId == _authProvider.currentFarmId)
  );

  List<Campaign> get completedCampaigns =>
      _allCampaigns.where((c) => c.completed).toList();

  List<Campaign> get activeCampaigns =>
      _allCampaigns.where((c) => !c.completed).toList();

  Campaign? get activeCampaign => _activeCampaign;

  /// Nombre de campagnes actives
  int get activeCampaignsCount => activeCampaigns.length;

  /// Nombre de campagnes terminées
  int get completedCampaignsCount => completedCampaigns.length;

  /// Nombre total de campagnes
  int get campaignsCount => _allCampaigns.length;

  // ==================== Campaign Management ====================

  /// Crée une nouvelle campagne
  Campaign createCampaign({
    required String name,
    required Product product,
    required DateTime treatmentDate,
    String? veterinarianId,
    String? veterinarianName,
  }) {
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
    );

    final campaignWithFarm = campaign.copyWith(farmId: _authProvider.currentFarmId);
    _allCampaigns.add(campaignWithFarm);
    _activeCampaign = campaign;
    notifyListeners();

    return campaign;
  }

  /// Définit la campagne active
  void setActiveCampaign(Campaign campaign) {
    _activeCampaign = campaign;
    notifyListeners();
  }

  /// Ajoute un animal à la campagne active
  bool addAnimalToActiveCampaign(String animalId) {
    final current = _activeCampaign;
    if (current == null) return false;

    if (current.animalIds.contains(animalId)) {
      return false; // déjà présent
    }

    final updatedIds = [...current.animalIds, animalId];
    final updatedCampaign = current.copyWith(animalIds: updatedIds);

    final index = _allCampaigns.indexWhere((c) => c.id == current.id);
    if (index != -1) {
      _allCampaigns[index] = updatedCampaign;
      _activeCampaign = updatedCampaign;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Alias pour addAnimalToActiveCampaign (compatibilité)
  void addScannedAnimal(String animalId) {
    addAnimalToActiveCampaign(animalId);
  }

  /// Vérifie si un animal est déjà dans la campagne active
  bool isAnimalScannedInActiveCampaign(String animalId) {
    final current = _activeCampaign;
    if (current == null) return false;
    return current.animalIds.contains(animalId);
  }

  /// Retire un animal de la campagne active
  bool removeAnimalFromActiveCampaign(String animalId) {
    final current = _activeCampaign;
    if (current == null) return false;

    if (!current.animalIds.contains(animalId)) {
      return false; // pas présent
    }

    final updatedIds = current.animalIds.where((id) => id != animalId).toList();
    final updatedCampaign = current.copyWith(animalIds: updatedIds);

    final index = _allCampaigns.indexWhere((c) => c.id == current.id);
    if (index != -1) {
      _allCampaigns[index] = updatedCampaign;
      _activeCampaign = updatedCampaign;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Marque la campagne active comme complétée
  void completeActiveCampaign() {
    final current = _activeCampaign;
    if (current == null) return;

    final updated = current.copyWith(
      completed: true,
      updatedAt: DateTime.now(),
    );

    final index = _allCampaigns.indexWhere((c) => c.id == current.id);
    if (index != -1) {
      _allCampaigns[index] = updated;
    }

    _activeCampaign = null;
    notifyListeners();
  }

  /// Alias pour completeActiveCampaign avec ID (compatibilité)
  void completeCampaign(String campaignId) {
    // Si c'est la campagne active, utiliser completeActiveCampaign
    if (_activeCampaign?.id == campaignId) {
      completeActiveCampaign();
      return;
    }

    // Sinon, compléter la campagne par ID
    final index = _allCampaigns.indexWhere((c) => c.id == campaignId);
    if (index != -1) {
      final campaign = _allCampaigns[index];
      final updated = campaign.copyWith(
        completed: true,
        updatedAt: DateTime.now(),
      );
      _allCampaigns[index] = updated;
      notifyListeners();
    }
  }

  /// Annule la campagne active
  void cancelActiveCampaign() {
    final current = _activeCampaign;
    if (current == null) return;

    // Si aucun animal scanné, supprimer la campagne
    if (current.animalIds.isEmpty) {
      _allCampaigns.removeWhere((c) => c.id == current.id);
    }

    _activeCampaign = null;
    notifyListeners();
  }

  /// Supprime une campagne par ID
  void deleteCampaign(String campaignId) {
    _allCampaigns.removeWhere((c) => c.id == campaignId);
    if (_activeCampaign?.id == campaignId) {
      _activeCampaign = null;
    }
    notifyListeners();
  }

  /// Récupère une campagne par ID
  Campaign? getCampaignById(String id) {
    try {
      return _allCampaigns.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Met à jour une campagne existante
  void updateCampaign(Campaign updated) {
    final index = _allCampaigns.indexWhere((c) => c.id == updated.id);
    if (index != -1) {
      _allCampaigns[index] = updated;
      if (_activeCampaign?.id == updated.id) {
        _activeCampaign = _allCampaigns[index];
      }
      notifyListeners();
    }
  }

  /// API conservée pour compatibilité (pas de champ `synced` dans le model)
  void markCampaignAsSynced(String campaignId) {
    if (_allCampaigns.any((c) => c.id == campaignId)) {
      notifyListeners(); // no-op pour ne pas casser les appels existants
    }
  }

  /// Convertit une campagne en traitements individuels
  List<Treatment> expandCampaignToTreatments(Campaign campaign) {
    return campaign.animalIds.map((animalId) {
      return Treatment(
        id: uuid.v4(),
        animalId: animalId,
        productId: campaign.productId,
        productName: campaign.productName,
        dose: 0.0, // valeur par défaut — ajuste si besoin
        treatmentDate: campaign.campaignDate,
        withdrawalEndDate: campaign.withdrawalEndDate,
        notes: null,
        createdAt: DateTime.now(), // ← requis par le modèle Treatment
      );
    }).toList();
  }

  /// Alias pour expandCampaignToTreatments (compatibilité)
  List<Treatment> generateTreatmentsFromCampaign(Campaign campaign) {
    return expandCampaignToTreatments(campaign);
  }

  // ==================== Mock / Reset ====================

  void loadMockCampaigns(List<Campaign> mockCampaigns) {
    _allCampaigns = mockCampaigns;
    notifyListeners();
  }

  void clearAllCampaigns() {
    _allCampaigns.clear();
    _activeCampaign = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onFarmChanged);
    super.dispose();
  }
}
