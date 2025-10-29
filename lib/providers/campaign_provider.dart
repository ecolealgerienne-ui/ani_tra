// lib/providers/campaign_provider.dart
// Artefact 15 : CampaignProvider étendu avec vétérinaire
// Version : 1.2

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/campaign.dart';
import '../models/product.dart';
import '../models/treatment.dart';

const uuid = Uuid();

class CampaignProvider with ChangeNotifier {
  List<Campaign> _campaigns = [];
  Campaign? _activeCampaign;

  // ==================== Getters ====================

  List<Campaign> get campaigns => _campaigns;

  List<Campaign> get activeCampaigns =>
      _campaigns.where((c) => !c.completed).toList();

  Campaign? get activeCampaign => _activeCampaign;

  // ==================== Campaign Management ====================

  /// Créer une nouvelle campagne
  /// MODIFIÉ v1.2 : Ajout veterinarianId et veterinarianName
  Campaign createCampaign({
    required String name,
    required Product product,
    required DateTime treatmentDate,
    String? veterinarianId, // ← NOUVEAU
    String? veterinarianName, // ← NOUVEAU
  }) {
    final withdrawalEnd = treatmentDate.add(
      Duration(days: product.withdrawalDaysMeat),
    );

    final campaign = Campaign(
      id: uuid.v4(),
      name: name,
      productId: product.id,
      productName: product.name,
      campaignDate: treatmentDate,
      withdrawalEndDate: withdrawalEnd,
      veterinarianId: veterinarianId, // ← NOUVEAU
      veterinarianName: veterinarianName, // ← NOUVEAU
      animalIds: [],
      completed: false,
      synced: false,
      createdAt: DateTime.now(),
    );

    _campaigns.add(campaign);
    notifyListeners();

    return campaign;
  }

  /// Définir la campagne active
  void setActiveCampaign(Campaign campaign) {
    _activeCampaign = campaign;
    notifyListeners();
  }

  /// Ajouter un animal à la campagne active
  bool addAnimalToActiveCampaign(String animalId) {
    if (_activeCampaign == null) return false;

    // Vérifier doublon
    if (_activeCampaign!.animalIds.contains(animalId)) {
      return false; // Animal déjà dans la campagne
    }

    // Ajouter l'animal
    final updatedIds = [..._activeCampaign!.animalIds, animalId];
    final updatedCampaign = _activeCampaign!.copyWith(
      animalIds: updatedIds,
      synced: false,
    );

    // Mettre à jour dans la liste
    final index = _campaigns.indexWhere((c) => c.id == _activeCampaign!.id);
    if (index != -1) {
      _campaigns[index] = updatedCampaign;
      _activeCampaign = updatedCampaign;
      notifyListeners();
      return true;
    }

    return false;
  }

  /// Vérifier si un animal est dans la campagne active
  bool isAnimalInActiveCampaign(String animalId) {
    if (_activeCampaign == null) return false;
    return _activeCampaign!.animalIds.contains(animalId);
  }

  /// Compléter la campagne active
  void completeActiveCampaign() {
    if (_activeCampaign == null) return;

    final updatedCampaign = _activeCampaign!.copyWith(
      completed: true,
      synced: false,
    );

    final index = _campaigns.indexWhere((c) => c.id == _activeCampaign!.id);
    if (index != -1) {
      _campaigns[index] = updatedCampaign;
    }

    _activeCampaign = null;
    notifyListeners();
  }

  /// Annuler la campagne active
  void cancelActiveCampaign() {
    if (_activeCampaign == null) return;

    // Supprimer la campagne si aucun animal scanné
    if (_activeCampaign!.animalIds.isEmpty) {
      _campaigns.removeWhere((c) => c.id == _activeCampaign!.id);
    }

    _activeCampaign = null;
    notifyListeners();
  }

  /// Supprimer une campagne
  void deleteCampaign(String campaignId) {
    _campaigns.removeWhere((c) => c.id == campaignId);

    if (_activeCampaign?.id == campaignId) {
      _activeCampaign = null;
    }

    notifyListeners();
  }

  /// Récupérer une campagne par ID
  Campaign? getCampaignById(String id) {
    try {
      return _campaigns.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  // ==================== Treatments Generation ====================

  /// Générer les traitements pour tous les animaux d'une campagne
  /// MODIFIÉ v1.2 : Inclure veterinarianId et veterinarianName
  List<Treatment> generateTreatmentsFromCampaign(Campaign campaign) {
    return campaign.animalIds.map((animalId) {
      return Treatment(
        id: uuid.v4(),
        animalId: animalId,
        productName: campaign.productName,
        productId: campaign.productId,
        dose: 0.0, // À définir selon le produit et poids animal
        treatmentDate: campaign.campaignDate,
        withdrawalEndDate: campaign.withdrawalEndDate,
        veterinarianId: campaign.veterinarianId, // ← NOUVEAU
        veterinarianName: campaign.veterinarianName, // ← NOUVEAU
        campaignId: campaign.id,
        synced: false,
        createdAt: DateTime.now(),
      );
    }).toList();
  }

  // ==================== Statistics ====================

  /// Nombre total de campagnes
  int get totalCampaigns => _campaigns.length;

  /// Nombre de campagnes actives (non complétées)
  int get activeCampaignCount => activeCampaigns.length;

  /// Nombre total d'animaux traités dans toutes les campagnes
  int get totalAnimalsInCampaigns {
    return _campaigns.fold(0, (sum, campaign) => sum + campaign.animalCount);
  }

  // ==================== Mock Data ====================

  /// Initialiser avec des données de test
  void loadMockCampaigns(List<Campaign> mockCampaigns) {
    _campaigns = mockCampaigns;
    notifyListeners();
  }

  /// Réinitialiser toutes les campagnes
  void clearAllCampaigns() {
    _campaigns.clear();
    _activeCampaign = null;
    notifyListeners();
  }
}
