// lib/providers/veterinarian_provider.dart
import 'package:flutter/foundation.dart';
import '../models/veterinarian.dart';

class VeterinarianProvider with ChangeNotifier {
  final List<Veterinarian> _veterinarians = [];

  List<Veterinarian> get veterinarians => List.unmodifiable(_veterinarians);

  // Filtres
  List<Veterinarian> get activeVeterinarians =>
      _veterinarians.where((v) => v.isActive).toList();

  List<Veterinarian> get availableVeterinarians =>
      _veterinarians.where((v) => v.isAvailable && v.isActive).toList();

  List<Veterinarian> get preferredVeterinarians =>
      _veterinarians.where((v) => v.isPreferred && v.isActive).toList();

  List<Veterinarian> get emergencyVeterinarians => _veterinarians
      .where((v) => v.emergencyService && v.isAvailable && v.isActive)
      .toList();

  // Statistiques
  Map<String, dynamic> get stats {
    final active = activeVeterinarians;
    return {
      'total': active.length,
      'available': availableVeterinarians.length,
      'preferred': preferredVeterinarians.length,
      'emergency': emergencyVeterinarians.length,
      'totalInterventions':
          active.fold<int>(0, (sum, v) => sum + v.totalInterventions),
    };
  }

  // Spécialités disponibles
  List<String> get allSpecialties {
    final specialties = <String>{};
    for (var vet in activeVeterinarians) {
      specialties.addAll(vet.specialties);
    }
    return specialties.toList()..sort();
  }

  VeterinarianProvider() {
    _loadMockData();
  }

  // Charger des données de démonstration
  void _loadMockData() {
    _veterinarians.addAll([
      Veterinarian(
        id: '1',
        firstName: 'Jean',
        lastName: 'Martin',
        title: 'Dr.',
        licenseNumber: 'VET-75-12345',
        specialties: ['Bovins', 'Ovins', 'Chirurgie'],
        clinic: 'Clinique Vétérinaire Rurale',
        phone: '+33 1 23 45 67 89',
        mobile: '+33 6 12 34 56 78',
        email: 'j.martin@vet-clinique.fr',
        address: '15 Rue de la Ferme',
        city: 'Lyon',
        postalCode: '69000',
        country: 'France',
        isAvailable: true,
        emergencyService: true,
        workingHours: 'Lun-Ven: 8h-18h, Sam: 8h-12h',
        consultationFee: 65.0,
        emergencyFee: 120.0,
        currency: 'EUR',
        notes: 'Disponible pour interventions d\'urgence 24/7',
        isPreferred: true,
        rating: 5,
        totalInterventions: 156,
        lastInterventionDate: DateTime.now().subtract(const Duration(days: 3)),
        createdAt: DateTime(2023, 1, 15),
        updatedAt: DateTime(2024, 10, 20),
      ),
      Veterinarian(
        id: '2',
        firstName: 'Sophie',
        lastName: 'Dubois',
        title: 'Dr.',
        licenseNumber: 'VET-69-67890',
        specialties: ['Ovins', 'Caprins', 'Médecine préventive'],
        clinic: 'Cabinet Vétérinaire des Monts',
        phone: '+33 4 78 90 12 34',
        mobile: '+33 6 98 76 54 32',
        email: 's.dubois@cabinet-vet.fr',
        address: '8 Avenue des Bergeries',
        city: 'Saint-Étienne',
        postalCode: '42000',
        country: 'France',
        isAvailable: true,
        emergencyService: false,
        workingHours: 'Lun-Ven: 9h-17h',
        consultationFee: 55.0,
        emergencyFee: 100.0,
        currency: 'EUR',
        notes: 'Spécialiste reproduction ovine',
        isPreferred: true,
        rating: 5,
        totalInterventions: 98,
        lastInterventionDate: DateTime.now().subtract(const Duration(days: 7)),
        createdAt: DateTime(2023, 3, 10),
      ),
      Veterinarian(
        id: '3',
        firstName: 'Pierre',
        lastName: 'Lefebvre',
        title: 'Dr.',
        licenseNumber: 'VET-38-45678',
        specialties: ['Bovins', 'Parasitologie'],
        clinic: 'Vétérinaire Rural Associé',
        phone: '+33 4 76 54 32 10',
        mobile: '+33 6 45 67 89 01',
        email: 'p.lefebvre@vet-rural.fr',
        address: '22 Chemin des Prés',
        city: 'Grenoble',
        postalCode: '38000',
        country: 'France',
        isAvailable: false, // En congés
        emergencyService: false,
        workingHours: 'Lun-Ven: 8h-16h',
        consultationFee: 60.0,
        currency: 'EUR',
        notes: 'En congés jusqu\'au 15 novembre',
        isPreferred: false,
        rating: 4,
        totalInterventions: 72,
        lastInterventionDate: DateTime.now().subtract(const Duration(days: 45)),
        createdAt: DateTime(2023, 6, 5),
      ),
      Veterinarian(
        id: '4',
        firstName: 'Marie',
        lastName: 'Bernard',
        title: 'Dr.',
        licenseNumber: 'VET-01-23456',
        specialties: ['Ovins', 'Nutrition', 'Pathologie digestive'],
        clinic: 'Cabinet Vétérinaire Bergerie',
        phone: '+33 4 74 12 34 56',
        mobile: '+33 6 23 45 67 89',
        email: 'm.bernard@bergerie-vet.fr',
        address: '5 Place du Marché',
        city: 'Bourg-en-Bresse',
        postalCode: '01000',
        country: 'France',
        isAvailable: true,
        emergencyService: true,
        workingHours: 'Lun-Sam: 8h-19h',
        consultationFee: 70.0,
        emergencyFee: 130.0,
        currency: 'EUR',
        notes:
            'Experte en nutrition ovine, consultations nutritionnelles disponibles',
        isPreferred: true,
        rating: 5,
        totalInterventions: 134,
        lastInterventionDate: DateTime.now().subtract(const Duration(days: 1)),
        createdAt: DateTime(2022, 11, 20),
      ),
      Veterinarian(
        id: '5',
        firstName: 'Thomas',
        lastName: 'Petit',
        title: 'Dr.',
        licenseNumber: 'VET-42-78901',
        specialties: ['Bovins', 'Caprins', 'Échographie'],
        clinic: 'Clinique Vétérinaire de la Vallée',
        phone: '+33 4 77 89 01 23',
        email: 't.petit@vallee-vet.fr',
        address: '30 Route de la Vallée',
        city: 'Roanne',
        postalCode: '42300',
        country: 'France',
        isAvailable: true,
        emergencyService: false,
        workingHours: 'Mar-Sam: 9h-18h',
        consultationFee: 58.0,
        currency: 'EUR',
        notes: 'Équipé pour échographies, suivi de gestation',
        isPreferred: false,
        rating: 4,
        totalInterventions: 45,
        lastInterventionDate: DateTime.now().subtract(const Duration(days: 12)),
        createdAt: DateTime(2024, 2, 1),
      ),
    ]);
    notifyListeners();
  }

  // CRUD Operations
  Veterinarian? getVeterinarianById(String id) {
    try {
      return _veterinarians.firstWhere((v) => v.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Veterinarian> getVeterinariansBySpecialty(String specialty) {
    return _veterinarians
        .where((v) => v.specialties.contains(specialty) && v.isActive)
        .toList();
  }

  List<Veterinarian> searchVeterinarians(String query) {
    final lowerQuery = query.toLowerCase();
    return _veterinarians.where((v) {
      return v.isActive &&
          (v.firstName.toLowerCase().contains(lowerQuery) ||
              v.lastName.toLowerCase().contains(lowerQuery) ||
              v.fullName.toLowerCase().contains(lowerQuery) ||
              (v.clinic?.toLowerCase().contains(lowerQuery) ?? false) ||
              (v.city?.toLowerCase().contains(lowerQuery) ?? false) ||
              v.specialties.any((s) => s.toLowerCase().contains(lowerQuery)));
    }).toList();
  }

  void addVeterinarian(Veterinarian veterinarian) {
    _veterinarians.add(veterinarian);
    notifyListeners();
  }

  void updateVeterinarian(Veterinarian veterinarian) {
    final index = _veterinarians.indexWhere((v) => v.id == veterinarian.id);
    if (index != -1) {
      _veterinarians[index] = veterinarian.copyWith(updatedAt: DateTime.now());
      notifyListeners();
    }
  }

  void deleteVeterinarian(String id) {
    final index = _veterinarians.indexWhere((v) => v.id == id);
    if (index != -1) {
      _veterinarians[index] = _veterinarians[index].copyWith(
        isActive: false,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  // Gestion des préférés
  void togglePreferred(String id) {
    final index = _veterinarians.indexWhere((v) => v.id == id);
    if (index != -1) {
      _veterinarians[index] = _veterinarians[index].copyWith(
        isPreferred: !_veterinarians[index].isPreferred,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  // Gestion de la disponibilité
  void toggleAvailability(String id) {
    final index = _veterinarians.indexWhere((v) => v.id == id);
    if (index != -1) {
      _veterinarians[index] = _veterinarians[index].copyWith(
        isAvailable: !_veterinarians[index].isAvailable,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  // Mise à jour du rating
  void updateRating(String id, int rating) {
    final index = _veterinarians.indexWhere((v) => v.id == id);
    if (index != -1) {
      _veterinarians[index] = _veterinarians[index].copyWith(
        rating: rating,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  // Incrémenter les interventions
  void incrementInterventions(String id) {
    final index = _veterinarians.indexWhere((v) => v.id == id);
    if (index != -1) {
      _veterinarians[index] = _veterinarians[index].copyWith(
        totalInterventions: _veterinarians[index].totalInterventions + 1,
        lastInterventionDate: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  // Obtenir le vétérinaire le plus actif
  Veterinarian? getMostActiveVeterinarian() {
    if (activeVeterinarians.isEmpty) return null;
    return activeVeterinarians
        .reduce((a, b) => a.totalInterventions > b.totalInterventions ? a : b);
  }

  // Obtenir les vétérinaires par note
  List<Veterinarian> getVeterinariansByRating(int minRating) {
    return activeVeterinarians.where((v) => v.rating >= minRating).toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
  }
}
