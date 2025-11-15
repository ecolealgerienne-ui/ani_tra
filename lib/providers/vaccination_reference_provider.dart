// lib/providers/vaccination_reference_provider.dart

import 'package:flutter/foundation.dart';
import '../models/vaccine_reference.dart';
import '../models/disease_reference.dart';
import '../models/administration_route.dart';
import 'auth_provider.dart';

class VaccinationReferenceProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  String _currentFarmId;

  List<VaccineReference> _allVaccines = [];
  List<DiseaseReference> _allDiseases = [];
  List<AdministrationRoute> _allRoutes = [];

  VaccinationReferenceProvider(this._authProvider)
      : _currentFarmId = _authProvider.currentFarmId {
    _authProvider.addListener(_onFarmChanged);
  }

  void _onFarmChanged() {
    if (_currentFarmId != _authProvider.currentFarmId) {
      _currentFarmId = _authProvider.currentFarmId;
      notifyListeners();
    }
  }

  List<VaccineReference> get vaccines => _allVaccines
      .where((v) => v.farmId == _authProvider.currentFarmId && v.isActive)
      .toList();

  List<DiseaseReference> get diseases => _allDiseases
      .where((d) => d.farmId == _authProvider.currentFarmId && d.isActive)
      .toList();

  List<AdministrationRoute> get routes => _allRoutes
      .where((r) => r.farmId == _authProvider.currentFarmId && r.isActive)
      .toList();

  void setReferences({
    required List<VaccineReference> vaccines,
    required List<DiseaseReference> diseases,
    required List<AdministrationRoute> routes,
  }) {
    _allVaccines = vaccines;
    _allDiseases = diseases;
    _allRoutes = routes;
    notifyListeners();
  }

  VaccineReference? getVaccineByName(String name) {
    try {
      return vaccines.firstWhere((v) => v.name == name);
    } catch (e) {
      return null;
    }
  }

  DiseaseReference? getDiseaseByName(String name) {
    try {
      return diseases.firstWhere((d) => d.name == name);
    } catch (e) {
      return null;
    }
  }

  AdministrationRoute? getRouteByCode(String code) {
    try {
      return routes.firstWhere((r) => r.code == code);
    } catch (e) {
      return null;
    }
  }

  Future<void> addVaccine(VaccineReference vaccine) async {
    _allVaccines.add(vaccine);
    notifyListeners();
  }

  Future<void> addDisease(DiseaseReference disease) async {
    _allDiseases.add(disease);
    notifyListeners();
  }

  Future<void> addRoute(AdministrationRoute route) async {
    _allRoutes.add(route);
    notifyListeners();
  }

  Future<void> syncToServer() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onFarmChanged);
    super.dispose();
  }
}