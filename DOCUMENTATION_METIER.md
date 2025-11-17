# Documentation Métier - Application de Gestion d'Élevage

## Table des matières

1. [Introduction](#1-introduction)
2. [Vue d'ensemble](#2-vue-densemble)
3. [Gestion des animaux individuels](#3-gestion-des-animaux-individuels)
4. [Gestion des lots](#4-gestion-des-lots)
5. [Mouvements d'animaux](#5-mouvements-danimaux)
6. [Événements et suivi](#6-événements-et-suivi)
7. [Gestion vétérinaire](#7-gestion-vétérinaire)
8. [Transactions](#8-transactions)
9. [Configuration de l'application](#9-configuration-de-lapplication)
10. [Synchronisation et mode hors ligne](#10-synchronisation-et-mode-hors-ligne)
11. [Rapports et consultations](#11-rapports-et-consultations)
12. [Workflows typiques](#12-workflows-typiques)

---

## 1. Introduction

### Objectif de l'application

L'application **Ani_Tra** (Animal Tracking) est une solution mobile dédiée à la gestion complète des élevages. Elle permet aux éleveurs, gestionnaires de fermes et intervenants du secteur agricole de suivre, gérer et optimiser toutes les activités liées à leurs animaux.

### À qui s'adresse cette application ?

- **Éleveurs** : suivi quotidien de leur cheptel
- **Gestionnaires de fermes** : pilotage de plusieurs exploitations
- **Vétérinaires** : suivi des interventions et traitements
- **Responsables de production** : analyse des performances et reporting

### Principaux bénéfices

- **Traçabilité complète** : historique détaillé de chaque animal et lot
- **Mobilité** : accès aux données depuis le terrain via smartphone/tablette
- **Simplicité** : interface intuitive adaptée au quotidien de l'éleveur
- **Décisions éclairées** : rapports et statistiques pour optimiser la production

---

## 2. Vue d'ensemble

### Les grands domaines fonctionnels

L'application s'articule autour de **cinq domaines principaux** :

#### 📋 Gestion du cheptel
- Enregistrement et suivi des animaux individuels
- Organisation en lots
- Gestion des informations de base (race, sexe, date de naissance, etc.)

#### 🔄 Mouvements et traçabilité
- Suivi des entrées (naissances, achats)
- Suivi des sorties (ventes, abattages, décès)
- Transferts entre sites ou zones

#### 🏥 Santé et interventions
- Événements de santé (maladies, blessures)
- Interventions vétérinaires
- Traitements et prescriptions
- Reproduction et mise bas

#### 📊 Suivi et mesures
- Pesées régulières
- Mesures diverses
- Historiques et évolutions

#### 💼 Transactions commerciales
- Ventes d'animaux
- Abattages
- Traçabilité des transactions

### Architecture de l'application

L'application fonctionne selon le principe suivant :

```
[Collecte sur le terrain] → [Stockage local] → [Synchronisation] → [Base de données centralisée]
```

**Avantage clé** : vous pouvez travailler même sans connexion internet. Les données sont synchronisées automatiquement dès qu'une connexion est disponible.

---

## 3. Gestion des animaux individuels

### Qu'est-ce qu'un animal dans l'application ?

Chaque animal est enregistré avec son **identité propre** et ses **caractéristiques** :

#### Informations d'identification
- **Numéro d'identification** : numéro unique (boucle auriculaire, puce RFID, etc.)
- **Nom** : optionnel, pour faciliter la reconnaissance
- **Espèce** : bovins, ovins, caprins, etc.
- **Race** : race précise de l'animal
- **Sexe** : mâle ou femelle

#### Informations de naissance
- **Date de naissance**
- **Poids à la naissance**
- **Mère** : lien vers l'animal mère (si connu)
- **Père** : lien vers l'animal père (si connu)

#### État et localisation
- **Statut** : actif, vendu, abattu, décédé
- **Site/ferme** : localisation actuelle
- **Zone/paddock** : emplacement précis dans la ferme

### Ajouter un nouvel animal

L'ajout d'un animal se fait en quelques étapes simples :

1. **Saisir l'identification** : numéro obligatoire, nom optionnel
2. **Sélectionner l'espèce et la race**
3. **Indiquer le sexe et la date de naissance**
4. **Renseigner le poids initial** (optionnel)
5. **Établir la filiation** (mère/père si applicable)
6. **Définir la localisation** (site, zone)

### Consulter et modifier un animal

Pour chaque animal, vous accédez à :

- **Fiche d'identité complète**
- **Historique des événements** : santé, pesées, traitements, mouvements
- **Généalogie** : parents et descendance
- **Courbes de croissance** : évolution du poids
- **Documents associés** : certificats, factures

Les informations peuvent être **modifiées à tout moment** (sauf l'identification une fois créée pour garantir la traçabilité).

### Recherche et filtres

Plusieurs moyens pour retrouver un animal :

- **Recherche par numéro d'identification**
- **Filtre par race, sexe, âge**
- **Filtre par statut** (actif, vendu, etc.)
- **Filtre par localisation** (site, zone)
- **Tri** par date de naissance, poids, dernière modification

---

## 4. Gestion des lots

### Qu'est-ce qu'un lot ?

Un **lot** est un regroupement d'animaux partageant des caractéristiques communes. Les lots permettent de gérer collectivement plusieurs animaux pour gagner du temps et simplifier les opérations.

### Pourquoi utiliser des lots ?

- **Gain de temps** : appliquer une action à plusieurs animaux simultanément
- **Organisation** : structurer le cheptel selon vos critères métier
- **Suivi collectif** : analyser les performances d'un groupe
- **Traçabilité** : historique des opérations groupées

### Types de lots courants

Les lots peuvent être constitués selon différents critères :

#### Par origine
- Lot d'achat (animaux achetés ensemble)
- Lot de naissance (animaux nés la même période)

#### Par destination
- Lot d'engraissement
- Lot destiné à la reproduction
- Lot destiné à la vente

#### Par caractéristiques
- Lot par classe d'âge
- Lot par race
- Lot par sexe

#### Par localisation
- Lot par paddock/zone
- Lot par bâtiment

### Créer un lot

Pour créer un lot :

1. **Donner un nom au lot** : descriptif et facile à retrouver
2. **Définir les critères** : race, âge, sexe, etc. (optionnel)
3. **Sélectionner les animaux** : ajout individuel ou par filtre
4. **Définir la localisation** : où se trouve ce lot
5. **Ajouter des notes** : informations complémentaires

### Opérations sur les lots

#### Opérations collectives
- **Pesée du lot** : enregistrer le poids de tous les animaux
- **Traitement vétérinaire** : appliquer un traitement à tout le lot
- **Déplacement** : transférer tous les animaux vers une autre zone
- **Vente** : vendre tout ou partie du lot
- **Abattage** : enregistrer l'abattage du lot

#### Gestion des membres
- **Ajouter des animaux** : intégrer de nouveaux membres
- **Retirer des animaux** : sortir un animal du lot (sans le supprimer)
- **Diviser un lot** : créer deux lots à partir d'un seul
- **Fusionner des lots** : regrouper plusieurs lots

### Suivi d'un lot

Pour chaque lot, vous disposez de :

- **Effectif actuel** : nombre d'animaux dans le lot
- **Composition** : liste détaillée des animaux
- **Poids total et moyen** : statistiques pondérales
- **Âge moyen** : pyramide des âges
- **Historique des événements** : toutes les opérations effectuées
- **Performance** : gain de poids, taux de croissance
- **Coûts associés** : alimentation, soins, etc.

### Dissolution d'un lot

Quand un lot n'a plus de raison d'être (vente complète, éclatement), vous pouvez :

- **Dissoudre le lot** : les animaux restent dans la base mais le lot est fermé
- **Archiver** : conservation pour l'historique
- **Consulter l'historique** : même dissous, l'historique est conservé

---

## 5. Mouvements d'animaux

### Pourquoi tracer les mouvements ?

La traçabilité des mouvements est essentielle pour :

- **Conformité réglementaire** : obligations légales de suivi
- **Gestion sanitaire** : contrôle des maladies
- **Optimisation** : analyse des flux d'animaux
- **Transparence** : preuve d'origine pour les clients

### Types de mouvements

#### Entrées
Les entrées représentent les arrivées d'animaux dans votre exploitation :

**Naissances**
- Enregistrement automatique lors de la déclaration d'une mise bas
- Lien automatique avec la mère
- Attribution d'un numéro d'identification

**Achats**
- Provenance : élevage d'origine
- Date d'achat et prix
- Documents associés : bon de livraison, certificat sanitaire
- Quarantaine éventuelle

**Transferts entrants**
- Depuis un autre site de votre exploitation
- Depuis une zone vers une autre

#### Sorties
Les sorties marquent le départ définitif d'un animal :

**Ventes**
- Acheteur et destination
- Prix de vente
- Date de départ
- Documents : bon de livraison, certificat

**Abattages**
- Abattoir de destination
- Date d'abattage
- Poids de carcasse
- Résultats de classification

**Décès**
- Date et cause
- Circonstances
- Mesures prises

**Transferts sortants**
- Vers un autre site
- Don ou prêt

#### Mouvements internes

Les mouvements internes ne font pas sortir l'animal de l'exploitation :

**Changement de zone**
- D'un paddock à un autre
- D'un bâtiment à un autre
- Motif du déplacement

**Changement de lot**
- Intégration dans un nouveau lot
- Retrait d'un lot existant

**Changement de statut**
- Passage de l'engraissement à la reproduction
- Réforme

### Enregistrer un mouvement

Pour chaque mouvement, vous indiquez :

1. **Type de mouvement** : entrée, sortie, interne
2. **Animal(x) concerné(s)** : individuel ou lot
3. **Date et heure** : moment du mouvement
4. **Origine et destination** : lieux précis
5. **Motif** : raison du mouvement
6. **Documents** : certificats, bons de livraison
7. **Observations** : informations complémentaires

### Suivi des mouvements

L'application vous permet de :

- **Consulter l'historique** : tous les mouvements d'un animal
- **Filtrer par période** : mouvements du mois, de l'année
- **Filtrer par type** : uniquement les achats, les ventes, etc.
- **Exporter** : génération de registres réglementaires
- **Alertes** : notifications en cas de mouvement inhabituel

### Traçabilité et réglementation

Les informations enregistrées permettent de :

- **Générer le registre d'élevage** : obligation légale
- **Prouver l'origine** : pour les labels et certifications
- **Répondre aux contrôles** : inspections sanitaires
- **Gérer les rappels** : en cas de problème sanitaire

---

## 6. Événements et suivi

### Qu'est-ce qu'un événement ?

Un événement est toute occurrence notable dans la vie d'un animal qui mérite d'être enregistrée pour assurer un suivi complet.

### Types d'événements

#### Événements de santé

**Maladies**
- Symptômes observés
- Date de détection
- Gravité
- Traitement appliqué
- Évolution (guérison, rechute, chronicité)

**Blessures**
- Nature de la blessure
- Circonstances
- Soins apportés
- Durée de convalescence

**Vaccinations**
- Type de vaccin
- Date d'administration
- Rappels programmés
- Lot de vaccin

**Traitements préventifs**
- Vermifuges
- Antiparasitaires
- Compléments alimentaires

#### Événements de reproduction

**Saillies**
- Date de saillie
- Reproducteur (père)
- Type de monte (naturelle ou IA)
- Numéro de paillette (si IA)

**Diagnostics de gestation**
- Date du diagnostic
- Résultat (positive/négative)
- Méthode utilisée
- Date prévue de mise bas

**Mises bas**
- Date et heure
- Déroulement (normal, difficile, assistée)
- Nombre de petits
- Sexe des nouveaux-nés
- Poids à la naissance
- Vitalité

**Avortements**
- Date
- Causes possibles
- Investigations vétérinaires

**Sevrage**
- Date de sevrage
- Poids au sevrage
- Séparation mère-petit

#### Événements de croissance

**Pesées**
- Date de pesée
- Poids mesuré
- Méthode (bascule, estimation)
- Gain de poids depuis la dernière pesée
- GMQ (Gain Moyen Quotidien)

**Mesures morphologiques**
- Hauteur au garrot
- Tour de poitrine
- Longueur
- État corporel (notation)

**Changements alimentaires**
- Passage à un nouveau régime
- Quantités distribuées
- Composition de la ration

### Enregistrer un événement

L'enregistrement d'un événement comprend :

1. **Sélection de l'animal ou du lot**
2. **Type d'événement** : santé, reproduction, pesée, etc.
3. **Date et heure** : moment de l'événement
4. **Détails spécifiques** : selon le type d'événement
5. **Intervenant** : qui a constaté/réalisé l'événement
6. **Photos** : possibilité d'ajouter des photos
7. **Notes** : observations complémentaires

### Consultation de l'historique

Pour chaque animal, vous accédez à :

- **Chronologie complète** : tous les événements dans l'ordre
- **Filtrage par type** : uniquement les pesées, ou les maladies, etc.
- **Recherche par date** : événements d'une période donnée
- **Graphiques d'évolution** : courbes de poids, reproduction
- **Comparaisons** : avec d'autres animaux ou la moyenne du troupeau

### Alertes et rappels

L'application peut vous alerter pour :

- **Rappels de vaccins** : échéances à venir
- **Dates de mise bas prévues** : préparation
- **Pesées à effectuer** : suivi régulier
- **Traitements à renouveler** : vermifuges, etc.
- **Événements inhabituels** : perte de poids, taux de mortalité

### Analyses et statistiques

À partir des événements, l'application calcule :

- **Performances de croissance** : GMQ, poids projetés
- **Taux de reproduction** : fertilité, prolificité
- **Taux de mortalité** : par classe d'âge, par période
- **Incidence des maladies** : fréquence, saisonnalité
- **Comparaisons** : entre lots, entre périodes

---

## 7. Gestion vétérinaire

### Rôle du module vétérinaire

Le module vétérinaire centralise toutes les interventions liées à la santé animale, permettant un suivi rigoureux et une traçabilité complète des actes vétérinaires.

### Interventions vétérinaires

#### Types d'interventions

**Visites de routine**
- Contrôle sanitaire régulier
- Bilan de santé du troupeau
- Conseils du vétérinaire

**Interventions d'urgence**
- Soins d'urgence
- Chirurgie
- Euthanasie

**Diagnostics**
- Examens cliniques
- Prélèvements (sang, urine, etc.)
- Imagerie (radio, écho)

**Prophylaxie**
- Campagnes de vaccination
- Dépistage réglementaire (tuberculose, brucellose, etc.)
- Tests de dépistage

#### Enregistrement d'une intervention

Pour chaque intervention, vous documentez :

1. **Date et heure de l'intervention**
2. **Vétérinaire intervenant** : nom et coordonnées
3. **Animal(x) concerné(s)** : individuel ou collectif
4. **Motif** : raison de l'intervention
5. **Diagnostic** : constat du vétérinaire
6. **Actes réalisés** : examens, soins, chirurgie
7. **Durée de l'intervention**
8. **Coût** : montant facturé

### Traitements et prescriptions

#### Médicaments administrés

Pour chaque traitement, vous enregistrez :

- **Nom du médicament** : commercial et DCI
- **Dosage** : quantité administrée
- **Voie d'administration** : orale, injectable, topique
- **Fréquence** : une fois, plusieurs jours, etc.
- **Durée du traitement**
- **Délai d'attente** : viande, lait (très important)

#### Suivi des prescriptions

- **Renouvellements** : traitements à répéter
- **Observance** : vérification que le traitement est bien suivi
- **Effets** : amélioration, stabilisation, aggravation
- **Effets secondaires** : réactions indésirables

#### Délais d'attente

**Crucial pour la sécurité alimentaire** :

- **Délai viande** : durée avant abattage possible
- **Délai lait** : durée avant commercialisation du lait
- **Alertes automatiques** : notification avant expiration
- **Blocage** : impossibilité de vendre/abattre pendant le délai

### Certificats et documents vétérinaires

#### Types de certificats

**Certificats sanitaires**
- Attestation de bonne santé
- Nécessaires pour les ventes et mouvements
- Validité limitée

**Certificats de vaccination**
- Preuve de vaccination
- Traçabilité des lots de vaccins
- Dates de rappel

**Résultats d'analyses**
- Analyses de sang, lait, etc.
- Dépistages réglementaires
- Tests de gestation

**Ordonnances**
- Prescriptions du vétérinaire
- Traçabilité des médicaments

#### Gestion des documents

- **Numérisation** : scan ou photo des documents papier
- **Stockage centralisé** : tous les documents accessibles
- **Recherche** : par animal, par type, par date
- **Export** : envoi par email, impression
- **Archivage** : conservation réglementaire

### Suivi sanitaire du troupeau

#### Tableau de bord sanitaire

Visualisation rapide de :

- **État sanitaire global** : pourcentage d'animaux sains
- **Maladies en cours** : nombre de cas actifs
- **Traitements en cours** : animaux sous traitement
- **Délais d'attente actifs** : animaux non commercialisables
- **Vaccinations à jour** : taux de couverture

#### Alertes sanitaires

- **Épidémies** : détection de maladies répétées
- **Zoonoses** : maladies transmissibles à l'homme
- **Maladies réglementées** : déclaration obligatoire
- **Vaccinations expirées** : animaux à revacciner

#### Coûts vétérinaires

Suivi des dépenses :

- **Par animal** : coût sanitaire individuel
- **Par lot** : coût pour un groupe
- **Par période** : budget mensuel/annuel
- **Par type** : préventif vs curatif
- **Comparaison** : par rapport aux standards

---

## 8. Transactions

### Types de transactions

L'application gère deux types principaux de transactions : les **ventes** et les **abattages**.

### Ventes d'animaux

#### Informations de vente

Pour chaque vente, vous enregistrez :

**Identification**
- Animal(x) vendu(s) : individuel ou lot complet
- Date de la vente
- Date de livraison effective

**Acheteur**
- Nom de l'acheteur
- Type : particulier, négociant, éleveur
- Coordonnées
- Destination finale des animaux

**Conditions commerciales**
- Prix unitaire ou global
- Mode de calcul : au poids vif, au forfait
- Poids de vente
- Montant total
- Mode de paiement
- Conditions de livraison

**Documents**
- Bon de livraison
- Facture
- Certificats sanitaires obligatoires
- Documents d'identification

#### Processus de vente

1. **Préparation** : sélection des animaux à vendre
2. **Vérification** : contrôle des délais d'attente médicamenteux
3. **Génération des documents** : certificats, facture
4. **Enregistrement de la transaction**
5. **Mise à jour du statut** : animal marqué comme "vendu"
6. **Sortie du cheptel** : mouvement de sortie automatique

#### Vente de lots

Pour les ventes groupées :

- **Vente partielle** : une partie du lot
- **Vente totale** : tout le lot
- **Prix au lot** : négociation globale
- **Homogénéité** : animaux de caractéristiques similaires

### Abattages

#### Informations d'abattage

Pour chaque abattage, vous documentez :

**Identification**
- Animal(x) concerné(s)
- Date d'abattage
- Âge à l'abattage

**Abattoir**
- Nom et localisation
- Numéro d'agrément
- Date de livraison

**Données de carcasse**
- Poids vif à l'abattage
- Poids de carcasse chaude
- Rendement carcasse
- Classification (EUROP)
- État d'engraissement
- Prix au kilo carcasse

**Qualité**
- Conformité sanitaire
- Résultats d'inspection
- Anomalies détectées
- Saisies partielles ou totales

#### Processus d'abattage

1. **Sélection des animaux** : prêts pour l'abattage
2. **Vérifications réglementaires** : délais d'attente
3. **Information de l'abattoir** : réservation
4. **Transport** : organisation de la livraison
5. **Enregistrement** : données d'abattage
6. **Retour d'information** : résultats de classification
7. **Facturation** : paiement par l'abattoir

#### Abattage de lots

Gestion simplifiée pour :

- **Lots homogènes** : abattage groupé
- **Statistiques de lot** : poids moyen, rendement moyen
- **Performance du lot** : comparaison avec les objectifs

### Traçabilité des transactions

#### Historique complet

Pour chaque animal, conservation de :

- **Toutes les transactions** : achats, ventes, abattages
- **Chaîne de propriété** : historique des propriétaires
- **Documents associés** : certificats, factures
- **Parcours de vie** : de la naissance à la sortie

#### Registres réglementaires

Génération automatique de :

- **Registre d'élevage** : entrées et sorties
- **Registre des médicaments** : traitements appliqués
- **Attestations sanitaires** : pour les transactions
- **Bons de livraison** : preuves de transfert

### Analyses financières

#### Suivi des ventes

- **Chiffre d'affaires** : par période, par type d'animal
- **Prix moyens** : évolution dans le temps
- **Marges** : comparaison coûts de production vs prix de vente
- **Clients** : meilleurs acheteurs, fréquence

#### Rentabilité

Calculs automatiques de :

- **Coût de revient** : par animal ou par lot
- **Marge brute** : prix de vente - coûts directs
- **Rentabilité** : par race, par type de production
- **Comparaisons** : performances par rapport aux références

---

## 9. Configuration de l'application

### Paramètres généraux

#### Informations de l'exploitation

**Identification**
- Nom de l'exploitation
- Numéro SIRET/SIREN
- Numéro d'élevage (EDE)
- Adresse complète
- Coordonnées (téléphone, email)

**Responsables**
- Nom du gestionnaire principal
- Contacts secondaires
- Vétérinaire attitré

**Spécificités**
- Types d'élevage pratiqués
- Espèces élevées
- Capacité de l'exploitation

#### Préférences utilisateur

**Affichage**
- Langue de l'interface
- Format de date
- Unités de mesure (kg, lb / °C, °F)
- Devise monétaire

**Notifications**
- Alertes activées/désactivées
- Fréquence des rappels
- Canaux de notification (push, email)

**Raccourcis**
- Actions favorites
- Écrans d'accueil personnalisés

### Gestion des exploitations et sites

#### Structure multi-sites

Pour les exploitations avec plusieurs sites :

**Hiérarchie**
```
Exploitation
  └─ Site A
      ├─ Bâtiment 1
      │   ├─ Zone 1A
      │   └─ Zone 1B
      └─ Bâtiment 2
          ├─ Zone 2A
          └─ Zone 2B
  └─ Site B
      └─ Paddocks
          ├─ Paddock 1
          ├─ Paddock 2
          └─ Paddock 3
```

**Configuration des sites**
- Nom du site
- Adresse géographique
- Superficie
- Capacité d'accueil
- Responsable du site

**Zones et localisations**
- Découpage en zones
- Type de zone (pâture, stabulation, infirmerie)
- Capacité par zone
- Équipements disponibles

#### Transferts entre sites

- **Gestion facilitée** : transferts d'animaux d'un site à l'autre
- **Traçabilité** : historique des mouvements inter-sites
- **Consolidation** : vision globale du cheptel total

### Configuration des races et espèces

#### Espèces gérées

Activation des espèces élevées :

- Bovins
- Ovins
- Caprins
- Équins
- Porcins
- Volailles
- Autres

#### Races disponibles

Pour chaque espèce, configuration de :

- **Liste des races** : utilisées dans votre élevage
- **Caractéristiques** : standards de poids, performances
- **Spécificités** : aptitudes, particularités
- **Codes officiels** : codes races pour les déclarations

### Personnalisation des formulaires

#### Champs personnalisés

Ajout de champs spécifiques à vos besoins :

- **Attributs d'animaux** : caractéristiques particulières
- **Événements spéciaux** : types d'événements propres à votre activité
- **Notes structurées** : champs récurrents

**Exemples** :
- Numéro de box préféré
- Comportement au pâturage
- Aptitude à la monte
- Particularités alimentaires

#### Listes de choix

Configuration des listes déroulantes :

- Types de maladies fréquentes
- Motifs de réforme
- Causes de décès
- Catégories de clients

### Paramètres de synchronisation

#### Fréquence de synchronisation

- **Automatique** : synchronisation dès qu'une connexion est détectée
- **Manuelle** : synchronisation sur demande
- **Planifiée** : synchronisation à heures fixes

#### Données à synchroniser

Choix des données prioritaires :

- Données critiques en priorité
- Photos en Wi-Fi uniquement (économie de données mobiles)
- Synchronisation complète ou partielle

#### Gestion des conflits

En cas de modifications simultanées :

- **Priorité** : locale vs serveur
- **Notification** : alerte en cas de conflit
- **Résolution manuelle** : choix de la version à conserver

### Sauvegardes et sécurité

#### Sauvegardes automatiques

- **Fréquence** : quotidienne, hebdomadaire
- **Stockage** : local + cloud
- **Historique** : conservation des sauvegardes
- **Restauration** : procédure en cas de problème

#### Sécurité des données

- **Protection** : accès sécurisé à l'application
- **Chiffrement** : données sensibles protégées
- **Conformité RGPD** : respect de la réglementation
- **Archivage** : durée de conservation

---

## 10. Synchronisation et mode hors ligne

### Pourquoi le mode hors ligne ?

Dans le contexte agricole, la connexion internet n'est pas toujours disponible :

- **Zones blanches** : absence de couverture réseau dans certains paddocks
- **Bâtiments** : mauvaise réception dans les stabulations
- **Pâtures éloignées** : hors de portée du réseau
- **Pannes** : coupures temporaires

Le **mode hors ligne** garantit que vous pouvez **toujours travailler**, quel que soit l'état de la connexion.

### Fonctionnement du mode hors ligne

#### Stockage local

Toutes les données essentielles sont stockées sur votre appareil :

- **Animaux** : fiches complètes
- **Lots** : composition et historiques
- **Événements récents** : dernières semaines/mois
- **Paramètres** : configuration de l'application
- **Documents** : certificats, photos (selon l'espace disponible)

#### Travail hors ligne

Vous pouvez réaliser **toutes les opérations habituelles** :

**Consultation**
- Visualiser les fiches animaux
- Consulter les historiques
- Voir les statistiques

**Saisie**
- Ajouter de nouveaux animaux
- Enregistrer des événements
- Effectuer des pesées
- Créer des lots
- Saisir des mouvements

**Modification**
- Mettre à jour des informations
- Corriger des erreurs
- Compléter des fiches

#### Indicateur de connexion

L'application affiche clairement :

- **État de connexion** : connecté / hors ligne
- **Données en attente** : nombre d'opérations à synchroniser
- **Dernière synchronisation** : date et heure

### Synchronisation des données

#### Déclenchement automatique

La synchronisation démarre automatiquement quand :

- **Connexion détectée** : Wi-Fi ou données mobiles
- **Qualité suffisante** : signal stable
- **Application ouverte** : ou en arrière-plan selon les paramètres

#### Processus de synchronisation

1. **Envoi des modifications locales** : vos saisies vers le serveur
2. **Réception des mises à jour** : modifications d'autres utilisateurs
3. **Réconciliation** : fusion des données
4. **Vérification** : contrôle de cohérence
5. **Confirmation** : notification de réussite

#### Données prioritaires

L'ordre de synchronisation privilégie :

1. **Événements critiques** : décès, maladies graves
2. **Transactions** : ventes, abattages
3. **Mouvements réglementaires** : entrées, sorties
4. **Données de routine** : pesées, notes
5. **Photos et documents** : en dernier (selon connexion)

### Gestion des conflits

#### Qu'est-ce qu'un conflit ?

Un conflit survient quand :

- **Même donnée modifiée** : sur deux appareils différents
- **Synchronisations différées** : modifications pendant la déconnexion
- **Opérations contradictoires** : vente d'un animal déjà abattu ailleurs

#### Résolution des conflits

L'application propose plusieurs stratégies :

**Résolution automatique**
- **Plus récent gagne** : la dernière modification est conservée
- **Fusion intelligente** : combinaison des modifications si possible
- **Priorité au serveur** : en cas de doute, le serveur fait foi

**Résolution manuelle**
- **Notification** : alerte en cas de conflit non résolvable
- **Comparaison** : affichage des deux versions
- **Choix utilisateur** : sélection de la version correcte
- **Fusion manuelle** : conservation d'éléments des deux versions

### Optimisation du stockage

#### Gestion de l'espace

Sur l'appareil mobile :

- **Données essentielles** : toujours présentes
- **Données récentes** : selon l'espace disponible
- **Historiques complets** : accessibles en ligne uniquement
- **Archivage automatique** : anciennes données déplacées vers le serveur

#### Paramétrage

Vous choisissez :

- **Profondeur d'historique** : combien de mois en local
- **Photos** : résolution et nombre conservés localement
- **Documents** : quels types stocker en local

### Sécurité et fiabilité

#### Protection contre les pertes

- **Sauvegardes automatiques** : avant chaque synchronisation
- **Récupération** : en cas d'échec de synchronisation
- **Traçabilité** : journal des synchronisations
- **Rollback** : retour arrière si nécessaire

#### Intégrité des données

- **Validation** : contrôles de cohérence avant synchronisation
- **Verrouillage** : éviter les modifications simultanées
- **Horodatage** : précision au niveau de la seconde
- **Sommes de contrôle** : vérification de l'intégrité

---

## 11. Rapports et consultations

### Tableaux de bord

#### Tableau de bord principal

Vue d'ensemble de l'activité de l'exploitation :

**Indicateurs clés**
- **Effectif total** : nombre d'animaux présents
- **Répartition par espèce/race** : composition du cheptel
- **Naissances du mois** : dynamique de reproduction
- **Ventes/abattages du mois** : sorties
- **Alertes en cours** : points nécessitant attention

**Graphiques de synthèse**
- Évolution de l'effectif sur 12 mois
- Pyramide des âges
- Répartition par sexe
- État sanitaire global

#### Tableaux de bord spécialisés

**Tableau de bord reproduction**
- Taux de fertilité
- Naissances attendues
- Saillies en cours
- Taux de prolificité

**Tableau de bord sanitaire**
- Animaux sous traitement
- Délais d'attente actifs
- Maladies en cours
- Coûts vétérinaires

**Tableau de bord production**
- Poids moyen par catégorie
- Gains moyens quotidiens
- Rendements de carcasse
- Performance par lot

### Historiques et recherches

#### Historique d'un animal

Consultation chronologique complète :

- **Ligne de vie** : de la naissance à aujourd'hui
- **Filtrage** : par type d'événement
- **Recherche** : par date ou mot-clé
- **Export** : génération de rapport individuel

#### Recherche multi-critères

Recherche avancée permettant de combiner :

- Caractéristiques (race, sexe, âge)
- Localisation (site, zone)
- État (statut, santé)
- Événements (a eu telle maladie, pesé récemment)
- Performance (poids supérieur à X, GMQ > Y)

**Exemples de recherches** :
- "Tous les mâles de race X de plus de 18 mois"
- "Animaux vaccinés contre Y il y a plus de 6 mois"
- "Femelles ayant avorté cette année"

### Rapports prédéfinis

#### Rapports réglementaires

**Registre d'élevage**
- Entrées et sorties
- Mouvements internes
- Conforme aux exigences légales

**Registre sanitaire**
- Interventions vétérinaires
- Médicaments administrés
- Délais d'attente

**Inventaire**
- État du cheptel à une date donnée
- Répartition par catégorie
- Valorisation

#### Rapports de gestion

**Rapport de reproduction**
- Performances de reproduction
- Taux de fertilité et prolificité
- Naissances et mortalité néonatale
- Planning de mise bas

**Rapport de croissance**
- Évolution des poids
- Gains moyens quotidiens
- Comparaisons avec standards
- Identification des animaux à performance

**Rapport financier**
- Chiffre d'affaires (ventes)
- Coûts (vétérinaire, alimentation si saisi)
- Marges par animal ou lot
- Rentabilité

**Rapport sanitaire**
- Incidence des maladies
- Coûts vétérinaires
- Consommation de médicaments
- Taux de mortalité

### Analyses et statistiques

#### Analyses de performance

**Croissance**
- GMQ moyens par race, sexe, lot
- Courbes de croissance
- Comparaison avec références
- Identification des top performers

**Reproduction**
- Intervalle entre mises bas
- Taux de réussite à la saillie
- Prolificité par mère
- Performance des reproducteurs mâles

**Mortalité**
- Taux de mortalité global
- Répartition par âge
- Évolution dans le temps
- Causes principales

#### Analyses économiques

**Coûts**
- Coût de production par animal
- Répartition des coûts (santé, aliment, etc.)
- Coûts par lot ou par race

**Marges**
- Marge brute par animal vendu
- Marge par kilo produit
- Rentabilité par type de production

**Tendances**
- Évolution des prix de vente
- Évolution des coûts
- Prévisions financières

### Exports et partages

#### Formats d'export

Les rapports peuvent être exportés en :

- **PDF** : pour impression ou archivage
- **Excel** : pour analyses complémentaires
- **CSV** : pour import dans d'autres logiciels
- **Email** : envoi direct

#### Partages

Possibilité de partager :

- **Avec le vétérinaire** : données sanitaires
- **Avec le comptable** : données financières
- **Avec les organismes** : déclarations réglementaires
- **Avec les partenaires** : acheteurs, conseillers

#### Planification

- **Rapports automatiques** : génération périodique
- **Envoi programmé** : email mensuel par exemple
- **Alertes** : notification quand un seuil est atteint

### Graphiques et visualisations

#### Types de graphiques

**Évolution temporelle**
- Courbes de poids
- Évolution de l'effectif
- Tendances de reproduction

**Répartitions**
- Camemberts (races, sexes)
- Pyramide des âges
- Répartition géographique

**Comparaisons**
- Barres (lots, périodes)
- Performance individuelle vs moyenne
- Benchmarking

#### Interactivité

- **Zoom** : sur une période
- **Filtrage dynamique** : masquer/afficher des séries
- **Export** : sauvegarde des graphiques
- **Partage** : intégration dans des rapports

---

## 12. Workflows typiques

### Workflow 1 : Enregistrement d'une naissance

**Contexte** : Une vache a mis bas ce matin.

**Étapes** :

1. **Accéder à la fiche de la mère**
   - Rechercher l'animal par son numéro
   - Ouvrir la fiche complète

2. **Enregistrer l'événement de mise bas**
   - Type : Mise bas
   - Date et heure
   - Déroulement (normal, assisté, difficile)
   - Notes éventuelles

3. **Créer le(s) nouveau-né(s)**
   - Clic sur "Ajouter le veau"
   - Attribution d'un numéro d'identification
   - Sexe
   - Poids à la naissance
   - Lien automatique avec la mère
   - Père (si connu)

4. **Définir la localisation**
   - Site et zone (paddock de mise bas)

5. **Vérifier l'alerte de suivi**
   - Premier colostrum (rappel automatique)
   - Première pesée à J+7 (programmée)

**Résultat** : Le veau est enregistré, lié à sa mère, et les premiers suivis sont programmés.

---

### Workflow 2 : Traitement d'un lot malade

**Contexte** : Vous détectez des symptômes de grippe sur plusieurs animaux d'un lot.

**Étapes** :

1. **Identifier le lot concerné**
   - Accès à la liste des lots
   - Sélection du lot

2. **Enregistrer l'événement sanitaire**
   - Type : Maladie
   - Symptômes : toux, écoulement nasal
   - Nombre d'animaux affectés
   - Date de détection

3. **Appel du vétérinaire**
   - Création d'une intervention vétérinaire
   - Date de visite
   - Diagnostic du vétérinaire

4. **Prescription et traitement**
   - Médicament prescrit
   - Dosage par animal
   - Durée du traitement (5 jours)
   - Délai d'attente viande (28 jours)

5. **Administration collective**
   - Application du traitement à tout le lot
   - Enregistrement quotidien si nécessaire

6. **Suivi de l'évolution**
   - Notes d'observation chaque jour
   - Amélioration ou aggravation
   - Fin du traitement à J+5

7. **Gestion du délai d'attente**
   - Alerte automatique à J+28
   - Blocage des ventes avant expiration

**Résultat** : La maladie est documentée, le traitement tracé, et les animaux sont protégés contre une vente prématurée.

---

### Workflow 3 : Vente d'un lot d'engraissement

**Contexte** : Un lot de 20 bovins est prêt pour la vente.

**Étapes** :

1. **Vérifications préalables**
   - Consulter le lot
   - Vérifier l'absence de délai d'attente
   - Vérifier les vaccinations à jour
   - Contrôle des poids (dernière pesée)

2. **Négociation avec l'acheteur**
   - Prix au kilo vif
   - Date de livraison

3. **Génération des documents**
   - Certificats sanitaires
   - Bons de livraison
   - Documents d'identification (si requis)

4. **Pesée finale**
   - Pesée collective ou individuelle
   - Enregistrement des poids

5. **Enregistrement de la vente**
   - Sélection du lot ou des animaux
   - Informations acheteur
   - Prix et conditions
   - Date de transaction

6. **Livraison**
   - Date effective de départ
   - Destination
   - Transport

7. **Mise à jour automatique**
   - Statut des animaux : "Vendu"
   - Mouvement de sortie enregistré
   - Effectif du lot et du cheptel mis à jour
   - Facturation

**Résultat** : La vente est complètement tracée, les documents sont prêts, et le cheptel est à jour.

---

### Workflow 4 : Suivi d'un programme de pesées

**Contexte** : Vous effectuez des pesées mensuelles sur vos lots d'engraissement.

**Étapes** :

1. **Planification**
   - Définir la fréquence (mensuelle)
   - Programmer des rappels

2. **Jour de pesée**
   - Sélection du lot à peser
   - Lancement du mode "pesée collective"

3. **Pesée des animaux**
   - Identification de chaque animal (scan ou saisie)
   - Pesée individuelle
   - Enregistrement automatique
   - Passage à l'animal suivant

4. **Analyse immédiate**
   - Poids moyen du lot
   - GMQ depuis dernière pesée
   - Identification des animaux à problème (perte de poids)
   - Identification des top performers

5. **Actions correctives**
   - Animaux en sous-performance : investigation
   - Ajustement de la ration si nécessaire
   - Séparation des animaux à problème

6. **Suivi dans le temps**
   - Courbes de croissance
   - Comparaison avec les objectifs
   - Prévision de poids à l'abattage
   - Décision de vente pour les animaux prêts

**Résultat** : Le suivi de croissance est rigoureux, permettant des décisions éclairées sur l'alimentation et la commercialisation.

---

### Workflow 5 : Gestion d'une campagne de vaccination

**Contexte** : Vaccination annuelle obligatoire contre la fièvre aphteuse.

**Étapes** :

1. **Préparation**
   - Vérifier les animaux à vacciner (tous sauf < 3 mois)
   - Commander les vaccins
   - Planifier la date avec le vétérinaire

2. **Jour de vaccination**
   - Réception des vaccins
   - Contrôle des lots de vaccins et dates de péremption

3. **Vaccination par lots**
   - Traiter lot par lot
   - Sélection d'un lot
   - Enregistrement de l'intervention vétérinaire collective

4. **Vaccination individuelle**
   - Identification de chaque animal
   - Administration du vaccin
   - Enregistrement automatique :
     - Type de vaccin
     - Lot de vaccin
     - Date d'administration
     - Date de rappel (dans 1 an)

5. **Gestion des exceptions**
   - Animaux manquants : report
   - Animaux malades : contre-indication, report
   - Nouveaux animaux : vaccination à programmer

6. **Documentation**
   - Certificats de vaccination collectifs
   - Attestations individuelles si nécessaire
   - Enregistrement dans le registre sanitaire

7. **Suivi des rappels**
   - Programmation automatique des rappels
   - Alertes 1 mois avant expiration

**Résultat** : Toute l'exploitation est vaccinée, documentée, et les rappels sont programmés pour l'année suivante.

---

### Workflow 6 : Transfert d'animaux entre sites

**Contexte** : Déplacement de génisses du site principal vers un site de pâturage d'été.

**Étapes** :

1. **Sélection des animaux**
   - Critères : génisses de 12-24 mois
   - Recherche multi-critères
   - Constitution d'un lot temporaire

2. **Vérifications sanitaires**
   - Contrôle des vaccinations
   - Absence de maladies en cours
   - Certificats sanitaires si nécessaire (mouvements inter-départementaux)

3. **Préparation du site de destination**
   - Vérifier la capacité d'accueil
   - Préparer les zones (clôtures, abreuvoirs)

4. **Enregistrement du mouvement**
   - Type : Transfert interne
   - Origine : Site principal, Bâtiment A
   - Destination : Site de pâturage, Paddock 3
   - Date et heure de départ
   - Animaux concernés

5. **Transport**
   - Organisation pratique
   - Date effective de déplacement

6. **Arrivée et installation**
   - Confirmation d'arrivée
   - Mise à jour de la localisation
   - Période d'adaptation

7. **Suivi**
   - Visites régulières
   - Pesées intermédiaires
   - État sanitaire

8. **Retour en automne**
   - Même processus en sens inverse
   - Enregistrement du retour

**Résultat** : Le mouvement est complètement tracé, la localisation des animaux est à jour sur les deux sites.

---

### Workflow 7 : Préparation d'un contrôle sanitaire

**Contexte** : Visite de contrôle de la DDPP annoncée pour la semaine prochaine.

**Étapes** :

1. **Audit interne**
   - Vérifier la complétude des registres
   - Contrôler les cohérences (effectif déclaré vs réel)
   - Identifier les manques éventuels

2. **Génération des documents réglementaires**
   - Registre d'élevage (12 derniers mois)
   - Registre sanitaire (traitements et interventions)
   - Inventaire actuel du cheptel
   - Certificats de vaccination

3. **Vérification des identifications**
   - Tous les animaux ont un numéro
   - Boucles auriculaires en bon état
   - Correspondance physique/base de données

4. **Vérification des délais d'attente**
   - Aucun délai actif non documenté
   - Traçabilité des médicaments

5. **Contrôle des mouvements**
   - Toutes les entrées déclarées
   - Toutes les sorties déclarées
   - Documents associés disponibles

6. **Préparation des justificatifs**
   - Factures d'achat d'animaux
   - Bons de livraison de ventes
   - Certificats sanitaires
   - Ordonnances vétérinaires

7. **Export et impression**
   - Impression des registres
   - Sauvegarde PDF
   - Classement chronologique

**Résultat** : L'exploitation est prête pour le contrôle, tous les documents sont à jour et accessibles.

---

## Conclusion

L'application **Ani_Tra** est conçue pour simplifier et professionnaliser la gestion quotidienne de votre élevage. En centralisant toutes les informations et en automatisant les tâches administratives, elle vous permet de :

- **Gagner du temps** sur la paperasse
- **Améliorer la traçabilité** de votre production
- **Prendre de meilleures décisions** grâce aux données
- **Respecter les obligations réglementaires** sans stress
- **Optimiser vos performances** techniques et économiques

L'application évolue régulièrement pour s'adapter à vos besoins et aux évolutions du secteur. N'hésitez pas à faire part de vos suggestions pour améliorer l'outil.

**Bon élevage avec Ani_Tra !**
