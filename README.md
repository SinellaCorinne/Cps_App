# Social-Link Bénin 🇧🇯

## Application Mobile de Digitalisation des Enquêtes Sociales

[![Flutter](https://img.shields.io/badge/Flutter-3.6-blue.svg)](https://flutter.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**Social-Link Bénin** est une solution mobile innovante destinée aux agents des Centres de Promotion Sociale (CPS) du Bénin pour digitaliser et moderniser le processus d'enquête sociale sur le terrain.

---

## 🎯 Objectifs du Projet

- **Réduire le temps de saisie** de 60% par rapport au processus papier
- **Garantir l'accès aux données en mode hors-ligne** (Offline-First)
- **Générer automatiquement** des rapports PDF officiels
- **Centraliser les statistiques** pour une meilleure prise de décision
- **Améliorer l'accompagnement** des usagers vulnérables

---

## ✨ Fonctionnalités Principales

### 📱 Pour les Agents Sociaux (Mobile)

#### ✅ Mode Hors-Ligne Complet
- Saisie complète des enquêtes sans connexion Internet
- Stockage local sécurisé des données
- Synchronisation automatique dès retour de connexion

#### 📝 Formulaire d'Enquête en 3 Étapes

**Étape 1 : Identité & Situation**
- Informations personnelles (Nom, Prénom, Genre, Âge)
- Coordonnées et localisation (Commune, Arrondissement)
- Capture de photo de profil
- Géolocalisation GPS automatique

**Étape 2 : Évaluation Logement & Vulnérabilité**
- Type et état du logement (échelle de 1 à 5)
- Accès aux services essentiels (eau, électricité)
- Évaluation des biens possédés
- Nombre de personnes au foyer
- Situation d'emploi et revenus
- Identification des facteurs de vulnérabilité

**Étape 3 : Synthèse & Recommandations**
- Observations générales avec **dictée vocale** 🎙️
- Recommandations et plan d'action
- Type d'aide préconisée

#### 📄 Génération PDF Instantanée
- **LE WAOO EFFECT** : Rapport officiel généré en 1 clic
- Format conforme aux standards du Ministère
- En-tête officiel République du Bénin
- Prévisualisation et partage immédiat
- Impression directe ou export

---

## 🎨 Design & UX

- **Design Mobile-First** épuré et professionnel
- **Palette institutionnelle** : Vert/Bleu du Bénin avec accents chaleureux
- **Typographie claire** adaptée au terrain
- **Gros boutons** pour une utilisation facilitée
- **Navigation intuitive** avec indicateurs de progression
- **Indicateur de statut réseau** visible en permanence

---

## 🛠 Architecture Technique

### Stack Technologique

| Composant | Technologie | Version |
|-----------|-------------|---------|
| Framework | Flutter | 3.6+ |
| Langage | Dart | 3.6+ |
| State Management | Provider | 6.1+ |
| Base de données locale | SQLite | 2.3+ |
| Génération PDF | pdf + printing | 3.11+ / 5.13+ |
| Connectivité | connectivity_plus | 6.0+ |
| Capture photo | image_picker | 1.1+ |

### Architecture Offline-First

```
┌─────────────────────────────────────────┐
│         Interface Mobile Flutter        │
│  (Étapes 1, 2, 3 + Génération PDF)     │
└─────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────┐
│        State Management (Provider)      │
│    (Gestion de l'état de l'enquête)    │
└─────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────┐
│      Stockage Local (SQLite)           │
│  (Sauvegarde automatique des données)   │
└─────────────────────────────────────────┘
                    │
                    ▼ (Quand connexion disponible)
┌─────────────────────────────────────────┐
│        API Backend (À venir)           │
│   (Synchronisation vers le cloud)      │
└─────────────────────────────────────────┘
```

---

## 🚀 Installation et Lancement

### Prérequis

- Flutter SDK 3.6 ou supérieur
- Dart SDK 3.6 ou supérieur
- Android Studio / Xcode (pour compilation mobile)
- Un émulateur ou appareil physique

### Étapes d'Installation

```bash
# 1. Cloner le repository
git clone https://github.com/votre-repo/app_cps.git
cd app_cps

# 2. Installer les dépendances
flutter pub get

# 3. Vérifier l'installation
flutter doctor

# 4. Lancer l'application
flutter run
```

### Démo Rapide avec Données de Test

1. Lancer l'application
2. Sur l'écran d'accueil, cliquer sur **"Démo (Données de test)"**
3. L'application charge automatiquement une enquête complète
4. Naviguer entre les 3 étapes pour voir les données
5. À l'étape 3, cliquer sur **"Générer le Rapport PDF Officiel"**
6. Le PDF s'affiche instantanément avec toutes les données !

---

## 📱 Captures d'Écran

### Écran d'Accueil
```
┌─────────────────────────────┐
│   🇧🇯 RÉPUBLIQUE DU BÉNIN    │
│    Social-Link Bénin        │
│  Centres de Promotion       │
│        Sociale              │
├─────────────────────────────┤
│  [+] Nouvelle Enquête       │
│  [🔬] Démo (Données test)   │
│                             │
│  📁 12   ⚠️ 3    ✅ 9       │
└─────────────────────────────┘
```

### Formulaire d'Enquête
```
┌─────────────────────────────┐
│  🟢 Hors-ligne              │
├─────────────────────────────┤
│  (1) ━━━━━ (2) ━━━━━ (3)   │
│  Identité  Logement  Synthèse│
├─────────────────────────────┤
│  📸 Photo Profil            │
│  📝 Nom: _________          │
│  📝 Prénom: _______         │
│  ⚥ Genre: [F] [M]          │
│  🎂 Âge: ___               │
│  📞 Téléphone: ______       │
│  📍 Commune: _______        │
│                             │
│  [Retour] [Suivant →]      │
└─────────────────────────────┘
```

---

## 📊 Modèle de Données

### Structure de l'Enquête (`SurveyModel`)

```dart
{
  "id": "ENQ-1234567890",
  "nom": "ADJOVI",
  "prenom": "Marie-Claire",
  "genre": "Féminin",
  "age": 42,
  "telephone": "+229 97 45 12 34",
  "commune": "Abomey-Calavi",
  "arrondissement": "Godomey",
  "typeLogement": "Maison en terre battue",
  "etatLogement": 2,
  "acceauEau": 3,
  "acceauElectricite": 2,
  "nombrePersonnesFoyer": 6,
  "revenuEstime": 45000,
  "situationEmploi": "Commerçante informelle",
  "vulnerabilites": [
    "Famille nombreuse",
    "Logement précaire",
    "Revenus faibles et irréguliers"
  ],
  "observationsGenerales": "...",
  "recommandations": "...",
  "typeAide": "Aide d'urgence",
  "dateEnquete": "2026-07-17T10:30:00Z",
  "agentNom": "Agent Jean KOFFI",
  "cpsOrigine": "CPS Abomey-Calavi",
  "status": "brouillon",
  "isSynced": false
}
```

---

## 📄 Format du Rapport PDF

Le rapport généré respecte le format officiel du Ministère :

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  RÉPUBLIQUE DU BÉNIN                 ┃
┃  MINISTÈRE DES AFFAIRES SOCIALES     ┃
┃  Direction des CPS                   ┃
┃           [CPS]                      ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃   RAPPORT D'ENQUÊTE SOCIALE          ┃
┃   Réf: ENQ-XXX - 17/07/2026         ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃ 1. IDENTITÉ ET SITUATION             ┃
┃    Nom: ADJOVI                       ┃
┃    Prénom: Marie-Claire              ┃
┃    ...                               ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃ 2. ÉVALUATION LOGEMENT               ┃
┃    Type: Maison en terre battue      ┃
┃    ...                               ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃ 3. FACTEURS DE VULNÉRABILITÉ         ┃
┃    • Famille nombreuse               ┃
┃    • Logement précaire               ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃ 4. SYNTHÈSE ET RECOMMANDATIONS       ┃
┃    Observations: ...                 ┃
┃    Recommandations: ...              ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃ Agent: Jean KOFFI    Date: 17/07/26 ┃
┃ Signature: ____________              ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

---

## 🔒 Sécurité et Conformité

- **Chiffrement des données** locales (à implémenter en production)
- **Authentification biométrique** (à implémenter)
- **Conformité APDP** (Autorité de Protection des Données Personnelles - Bénin)
- **Stockage sécurisé** des données sensibles
- **Logs d'audit** pour traçabilité

---

## 🗺 Roadmap

### ✅ Phase 1 : MVP (Actuel)
- ✅ Interface mobile Flutter complète
- ✅ Formulaire en 3 étapes
- ✅ Mode offline avec stockage local
- ✅ Génération PDF automatique
- ✅ Données de test pour démonstration

### 🚧 Phase 2 : Backend & Sync (Prochain)
- [ ] API Django REST Framework
- [ ] Base de données PostgreSQL cloud
- [ ] Synchronisation bidirectionnelle
- [ ] Gestion des conflits
- [ ] Dashboard web pour Chef de CPS

### 📅 Phase 3 : Fonctionnalités Avancées
- [ ] Dictée vocale fonctionnelle (Speech-to-Text)
- [ ] Reconnaissance OCR des documents
- [ ] Signature électronique
- [ ] Notifications push
- [ ] Rapports statistiques avancés

### 📅 Phase 4 : Pilote Terrain
- [ ] Tests utilisateurs au CPS Abomey-Calavi
- [ ] Formation des agents
- [ ] Collecte de feedback
- [ ] Optimisations basées sur l'usage réel

---

## 👥 Équipe

**Développeur Lead :** [Votre Nom]  
**Contact :** [votre.email@example.com]

---

## 📞 Support et Contact

Pour toute question ou suggestion :
- 📧 Email : support@social-link-benin.org
- 🌐 Site web : (à venir)
- 📱 WhatsApp : (à définir)

---

## 📜 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

---

## 🙏 Remerciements

- Ministère des Affaires Sociales et de la Microfinance du Bénin
- Direction des Centres de Promotion Sociale
- Tous les agents sociaux sur le terrain

---

**Made with ❤️ for social impact in Benin 🇧🇯**

*"Digitalisons l'accompagnement social pour un Bénin plus inclusif"*

