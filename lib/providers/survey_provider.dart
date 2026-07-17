import 'package:flutter/material.dart';
import 'package:app_cps/models/survey_model.dart';

class SurveyProvider extends ChangeNotifier {
  SurveyModel _currentSurvey = SurveyModel();
  int _currentStep = 0;
  bool _isOffline = true; // Mode hors ligne par défaut
  
  SurveyModel get currentSurvey => _currentSurvey;
  int get currentStep => _currentStep;
  bool get isOffline => _isOffline;
  
  void setCurrentStep(int step) {
    _currentStep = step;
    notifyListeners();
  }
  
  void nextStep() {
    if (_currentStep < 2) {
      _currentStep++;
      notifyListeners();
    }
  }
  
  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }
  
  void updateSurvey(SurveyModel survey) {
    _currentSurvey = survey;
    notifyListeners();
  }
  
  void resetSurvey() {
    _currentSurvey = SurveyModel();
    _currentStep = 0;
    notifyListeners();
  }
  
  void loadSampleData() {
    _currentSurvey = SurveyModel.sample();
    notifyListeners();
  }
  
  void toggleOfflineMode() {
    _isOffline = !_isOffline;
    notifyListeners();
  }
  
  // Mise à jour des champs individuels
  void updateIdentity({
    String? nom,
    String? prenom,
    String? genre,
    int? age,
    String? telephone,
    String? commune,
    String? arrondissement,
    String? photoPath,
  }) {
    if (nom != null) _currentSurvey.nom = nom;
    if (prenom != null) _currentSurvey.prenom = prenom;
    if (genre != null) _currentSurvey.genre = genre;
    if (age != null) _currentSurvey.age = age;
    if (telephone != null) _currentSurvey.telephone = telephone;
    if (commune != null) _currentSurvey.commune = commune;
    if (arrondissement != null) _currentSurvey.arrondissement = arrondissement;
    if (photoPath != null) _currentSurvey.photoPath = photoPath;
    notifyListeners();
  }
  
  void updateHousing({
    String? typeLogement,
    int? etatLogement,
    int? acceauEau,
    int? acceauElectricite,
    bool? possedeTelev,
    bool? possedeFrigo,
    bool? possedeVehicule,
    int? nombrePersonnesFoyer,
    double? revenuEstime,
    String? situationEmploi,
  }) {
    if (typeLogement != null) _currentSurvey.typeLogement = typeLogement;
    if (etatLogement != null) _currentSurvey.etatLogement = etatLogement;
    if (acceauEau != null) _currentSurvey.acceauEau = acceauEau;
    if (acceauElectricite != null) _currentSurvey.acceauElectricite = acceauElectricite;
    if (possedeTelev != null) _currentSurvey.possedeTelev = possedeTelev;
    if (possedeFrigo != null) _currentSurvey.possedeFrigo = possedeFrigo;
    if (possedeVehicule != null) _currentSurvey.possedeVehicule = possedeVehicule;
    if (nombrePersonnesFoyer != null) _currentSurvey.nombrePersonnesFoyer = nombrePersonnesFoyer;
    if (revenuEstime != null) _currentSurvey.revenuEstime = revenuEstime;
    if (situationEmploi != null) _currentSurvey.situationEmploi = situationEmploi;
    notifyListeners();
  }
  
  void addVulnerability(String vulnerability) {
    if (!_currentSurvey.vulnerabilites.contains(vulnerability)) {
      _currentSurvey.vulnerabilites = [..._currentSurvey.vulnerabilites, vulnerability];
      notifyListeners();
    }
  }
  
  void removeVulnerability(String vulnerability) {
    _currentSurvey.vulnerabilites = _currentSurvey.vulnerabilites
        .where((v) => v != vulnerability)
        .toList();
    notifyListeners();
  }
  
  void updateSynthesis({
    String? observationsGenerales,
    String? recommandations,
    String? typeAide,
  }) {
    if (observationsGenerales != null) {
      _currentSurvey.observationsGenerales = observationsGenerales;
    }
    if (recommandations != null) {
      _currentSurvey.recommandations = recommandations;
    }
    if (typeAide != null) {
      _currentSurvey.typeAide = typeAide;
    }
    notifyListeners();
  }
  
  Future<void> saveSurveyLocally() async {
    // Simulation de sauvegarde locale (SQLite)
    _currentSurvey.id = 'ENQ-${DateTime.now().millisecondsSinceEpoch}';
    _currentSurvey.status = 'brouillon';
    await Future.delayed(const Duration(milliseconds: 500));
    notifyListeners();
  }
  
  Future<bool> syncSurvey() async {
    // Simulation de synchronisation avec le serveur
    await Future.delayed(const Duration(seconds: 2));
    _currentSurvey.isSynced = true;
    _currentSurvey.status = 'validé';
    notifyListeners();
    return true;
  }
}
