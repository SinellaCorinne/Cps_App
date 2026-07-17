class SurveyModel {
  // Étape 1 : Identité & Situation
  String? id;
  String nom;
  String prenom;
  String genre;
  int? age;
  String? telephone;
  String? commune;
  String? arrondissement;
  String? photoPath;
  
  // Étape 2 : Évaluation Logement & Vulnérabilité
  String? typeLogement;
  int? etatLogement; // Échelle 1-5
  int? acceauEau;
  int? acceauElectricite;
  bool? possedeTelev;
  bool? possedeFrigo;
  bool? possedeVehicule;
  int? nombrePersonnesFoyer;
  double? revenuEstime;
  String? situationEmploi;
  
  // Vulnérabilités
  List<String> vulnerabilites;
  
  // Étape 3 : Synthèse & Recommandations
  String? observationsGenerales;
  String? recommandations;
  String? typeAide;
  
  // Métadonnées
  DateTime dateEnquete;
  String? agentNom;
  String? cpsOrigine;
  bool isSynced;
  String status; // brouillon, validé, transmis
  
  SurveyModel({
    this.id,
    this.nom = '',
    this.prenom = '',
    this.genre = 'Féminin',
    this.age,
    this.telephone,
    this.commune,
    this.arrondissement,
    this.photoPath,
    this.typeLogement,
    this.etatLogement,
    this.acceauEau,
    this.acceauElectricite,
    this.possedeTelev,
    this.possedeFrigo,
    this.possedeVehicule,
    this.nombrePersonnesFoyer,
    this.revenuEstime,
    this.situationEmploi,
    this.vulnerabilites = const [],
    this.observationsGenerales,
    this.recommandations,
    this.typeAide,
    DateTime? dateEnquete,
    this.agentNom,
    this.cpsOrigine,
    this.isSynced = false,
    this.status = 'brouillon',
  }) : dateEnquete = dateEnquete ?? DateTime.now();
  
  // Méthode pour créer une enquête de test
  factory SurveyModel.sample() {
    return SurveyModel(
      id: 'ENQ-${DateTime.now().millisecondsSinceEpoch}',
      nom: 'ADJOVI',
      prenom: 'Marie-Claire',
      genre: 'Féminin',
      age: 42,
      telephone: '+229 97 45 12 34',
      commune: 'Abomey-Calavi',
      arrondissement: 'Godomey',
      typeLogement: 'Maison en terre battue',
      etatLogement: 2,
      acceauEau: 3,
      acceauElectricite: 2,
      possedeTelev: false,
      possedeFrigo: false,
      possedeVehicule: false,
      nombrePersonnesFoyer: 6,
      revenuEstime: 45000,
      situationEmploi: 'Commerçante informelle',
      vulnerabilites: [
        'Famille nombreuse',
        'Logement précaire',
        'Revenus faibles et irréguliers',
        'Enfants non scolarisés'
      ],
      observationsGenerales: 
        'Mme ADJOVI vit seule avec ses 5 enfants dans une maison en terre battue de 2 pièces. '
        'Elle exerce une activité de vente de produits vivriers au marché de Godomey. '
        'Les revenus sont très irréguliers et ne permettent pas de couvrir tous les besoins de base. '
        'Deux enfants ne sont pas scolarisés faute de moyens. '
        'La famille ne dispose ni d\'électricité ni d\'eau courante.',
      recommandations:
        'Orientation vers le programme d\'aide alimentaire d\'urgence. '
        'Inscription des enfants au programme de parrainage scolaire. '
        'Accompagnement pour l\'accès à une activité génératrice de revenus (AGR). '
        'Suivi social rapproché pendant 6 mois.',
      typeAide: 'Aide d\'urgence + Accompagnement social',
      agentNom: 'Agent Jean KOFFI',
      cpsOrigine: 'CPS Abomey-Calavi',
      status: 'brouillon',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'genre': genre,
      'age': age,
      'telephone': telephone,
      'commune': commune,
      'arrondissement': arrondissement,
      'photoPath': photoPath,
      'typeLogement': typeLogement,
      'etatLogement': etatLogement,
      'acceauEau': acceauEau,
      'acceauElectricite': acceauElectricite,
      'possedeTelev': possedeTelev,
      'possedeFrigo': possedeFrigo,
      'possedeVehicule': possedeVehicule,
      'nombrePersonnesFoyer': nombrePersonnesFoyer,
      'revenuEstime': revenuEstime,
      'situationEmploi': situationEmploi,
      'vulnerabilites': vulnerabilites,
      'observationsGenerales': observationsGenerales,
      'recommandations': recommandations,
      'typeAide': typeAide,
      'dateEnquete': dateEnquete.toIso8601String(),
      'agentNom': agentNom,
      'cpsOrigine': cpsOrigine,
      'isSynced': isSynced,
      'status': status,
    };
  }
  
  factory SurveyModel.fromJson(Map<String, dynamic> json) {
    return SurveyModel(
      id: json['id'],
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      genre: json['genre'] ?? 'Féminin',
      age: json['age'],
      telephone: json['telephone'],
      commune: json['commune'],
      arrondissement: json['arrondissement'],
      photoPath: json['photoPath'],
      typeLogement: json['typeLogement'],
      etatLogement: json['etatLogement'],
      acceauEau: json['acceauEau'],
      acceauElectricite: json['acceauElectricite'],
      possedeTelev: json['possedeTelev'],
      possedeFrigo: json['possedeFrigo'],
      possedeVehicule: json['possedeVehicule'],
      nombrePersonnesFoyer: json['nombrePersonnesFoyer'],
      revenuEstime: json['revenuEstime']?.toDouble(),
      situationEmploi: json['situationEmploi'],
      vulnerabilites: List<String>.from(json['vulnerabilites'] ?? []),
      observationsGenerales: json['observationsGenerales'],
      recommandations: json['recommandations'],
      typeAide: json['typeAide'],
      dateEnquete: DateTime.parse(json['dateEnquete']),
      agentNom: json['agentNom'],
      cpsOrigine: json['cpsOrigine'],
      isSynced: json['isSynced'] ?? false,
      status: json['status'] ?? 'brouillon',
    );
  }
}
