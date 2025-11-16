# Spécifications : Enrichissement du Système Movement

**Version:** 2.0
**Date:** 2025-11-16
**Statut:** Approuvé
**Auteur:** Équipe Technique ani_tra

---

## 📋 Table des Matières

1. [Contexte et Objectifs](#1-contexte-et-objectifs)
2. [Principes Directeurs](#2-principes-directeurs)
3. [Architecture Cible](#3-architecture-cible)
4. [Schéma Base de Données](#4-schéma-base-de-données)
5. [Modèles de Données](#5-modèles-de-données)
6. [Types de Mouvements](#6-types-de-mouvements)
7. [Cas d'Usage](#7-cas-dusage)
8. [Migration des Données](#8-migration-des-données)
9. [Plan d'Implémentation](#9-plan-dimplémentation)
10. [Extensions Futures](#10-extensions-futures)

---

## 1. Contexte et Objectifs

### 1.1 Situation Actuelle

Le système de traçabilité actuel utilise deux modèles pour les opérations de vente et d'abattage :

**Problèmes identifiés :**
- ❌ Données acheteur/abattoir non structurées (stockées dans `notes`)
- ❌ Duplication des informations entre `Lot` et `Movement`
- ❌ Requêtes complexes (nécessitent JOIN entre Lot et Movement)
- ❌ Impossibilité de tracer les mouvements temporaires (prêts, transhumance)
- ❌ Pas de distinction entre propriété légale et localisation physique

### 1.2 Objectifs

✅ **Objectif Principal :** Movement devient la source unique de vérité pour la traçabilité

**Objectifs Spécifiques :**
1. Structurer les données de vente (acheteur) et d'abattage (abattoir)
2. Simplifier Lot en conteneur pur (liste d'IDs animaux)
3. Préparer les fondations pour les mouvements temporaires
4. Distinguer propriété vs. localisation physique des animaux
5. Maintenir compatibilité ascendante pendant la transition

---

## 2. Principes Directeurs

### 2.1 Principes Architecturaux

| Principe | Description |
|----------|-------------|
| **Source Unique de Vérité** | Movement = seule source pour traçabilité animale |
| **Lot = Conteneur** | Lot ne stocke que les IDs, pas les métadonnées métier |
| **Extensibilité** | Architecture ouverte pour nouveaux types de mouvements |
| **Pas de Valeurs en Dur** | Toutes les constantes dans fichiers dédiés |
| **I18n Obligatoire** | Toutes les chaînes traduites dans 4 langues (FR, AR, EN, Tamazight) |

### 2.2 Principes de Sécurité

| Principe | Implémentation |
|----------|----------------|
| **Multi-Tenancy** | Toutes les requêtes filtrent par `farmId` |
| **Soft Delete** | Utiliser `deletedAt`, jamais de suppression physique |
| **Sync-Ready** | Colonnes `synced`, `lastSyncedAt`, `serverVersion` |
| **Audit Trail** | `createdAt`, `updatedAt` sur toutes les tables |

---

## 3. Architecture Cible

### 3.1 Vue d'Ensemble

```
┌─────────────────────────────────────────────────────────────┐
│                   SYSTÈME DE TRAÇABILITÉ                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  [Lot]                          [Movement]                  │
│  Conteneur Simple               Source de Vérité            │
│  ═════════════                  ════════════                │
│                                                             │
│  • id                           • id                        │
│  • farmId                       • farmId                    │
│  • name                         • animalId (FK)             │
│  • type                         • type (sale, birth, etc.)  │
│  • animalIds (JSON)             • movementDate              │
│  • status                       • fromFarmId                │
│  • createdAt                    • toFarmId                  │
│                                 • price                     │
│  Métadonnées RETIRÉES :         • notes                     │
│  ❌ buyerName                                               │
│  ❌ slaughterhouseName          NOUVEAUX CHAMPS :           │
│  ❌ totalPrice                  ✅ buyer_name               │
│                                 ✅ buyer_farm_id            │
│                                 ✅ buyer_type               │
│                                 ✅ slaughterhouse_name      │
│                                 ✅ slaughterhouse_id        │
│                                 ✅ is_temporary             │
│                                 ✅ temporary_movement_type  │
│                                 ✅ expected_return_date     │
│                                 ✅ related_movement_id      │
│                                                             │
│  [Animal]                                                   │
│  ════════                                                   │
│                                                             │
│  • farmId (propriétaire légal)                             │
│  ✅ current_location_farm_id (localisation physique)       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 Distinction Propriété vs. Localisation

**Concept Clé :** Un animal peut appartenir à une ferme A mais être physiquement à la ferme B.

| Champ | Signification | Exemple (Prêt de bélier) |
|-------|---------------|--------------------------|
| `Animal.farmId` | Propriétaire légal | Ferme A |
| `Animal.currentLocationFarmId` | Localisation physique | Ferme B |

**Règle :** Si `currentLocationFarmId = null`, alors localisation = farmId

---

## 4. Schéma Base de Données

### 4.1 MovementsTable - Modifications

#### Colonnes Existantes (Conservées)
```dart
TextColumn get id => text()();
TextColumn get farmId => text().named('farm_id')();
TextColumn get animalId => text().named('animal_id')();
TextColumn get type => text()();
DateTimeColumn get movementDate => dateTime().named('movement_date')();
TextColumn get fromFarmId => text().nullable().named('from_farm_id')();
TextColumn get toFarmId => text().nullable().named('to_farm_id')();
RealColumn get price => real().nullable()();
TextColumn get notes => text().nullable()();
BoolColumn get synced => boolean().withDefault(const Constant(false))();
DateTimeColumn get createdAt => dateTime().named('created_at')();
DateTimeColumn get updatedAt => dateTime().named('updated_at')();
DateTimeColumn get deletedAt => dateTime().nullable().named('deleted_at')();
```

#### Nouvelles Colonnes - Vente/Abattage (5)

```dart
/// Nom de l'acheteur (particulier ou ferme)
TextColumn get buyerName =>
  text().nullable().named('buyer_name')();

/// ID de la ferme acheteuse (si applicable)
TextColumn get buyerFarmId =>
  text().nullable().named('buyer_farm_id')();

/// Type d'acheteur : 'individual', 'farm', 'trader', 'cooperative'
TextColumn get buyerType =>
  text().nullable().named('buyer_type')();

/// Nom de l'abattoir
TextColumn get slaughterhouseName =>
  text().nullable().named('slaughterhouse_name')();

/// Identifiant de l'abattoir (numéro agrément, etc.)
TextColumn get slaughterhouseId =>
  text().nullable().named('slaughterhouse_id')();
```

#### Nouvelles Colonnes - Mouvements Temporaires (4)

```dart
/// Indique si le mouvement est temporaire (animal doit revenir)
/// true pour type='temporary_out', false après 'temporary_return'
BoolColumn get isTemporary =>
  boolean().withDefault(const Constant(false))();

/// Sous-type de mouvement temporaire
/// Valeurs possibles : 'loan', 'transhumance', 'boarding', 'quarantine', etc.
/// Obligatoire si type='temporary_out' ou 'temporary_return'
TextColumn get temporaryMovementType =>
  text().nullable().named('temporary_movement_type')();

/// Date de retour prévue (obligatoire pour temporary_out)
DateTimeColumn get expectedReturnDate =>
  dateTime().nullable().named('expected_return_date')();

/// ID du mouvement associé (lien bidirectionnel)
/// Pour temporary_out : rempli quand le retour est créé
/// Pour temporary_return : pointe vers le temporary_out original
TextColumn get relatedMovementId =>
  text().nullable().named('related_movement_id')();
```

#### Index à Créer

```sql
CREATE INDEX idx_movements_buyer_farm_id
  ON movements_table(buyer_farm_id);

CREATE INDEX idx_movements_slaughterhouse_id
  ON movements_table(slaughterhouse_id);

CREATE INDEX idx_movements_temporary_type
  ON movements_table(temporary_movement_type);

CREATE INDEX idx_movements_related_movement_id
  ON movements_table(related_movement_id);
```

**Total Nouvelles Colonnes : 9**

---

### 4.2 AnimalsTable - Modifications

#### Nouvelle Colonne

```dart
/// Localisation physique actuelle de l'animal
/// Peut différer de farmId en cas de mouvement temporaire
/// Si null, la localisation = farmId (animal chez son propriétaire)
TextColumn get currentLocationFarmId =>
  text().nullable().named('current_location_farm_id')();
```

**Total Nouvelles Colonnes : 1**

---

### 4.3 LotsTable - Dépréciation

#### Colonnes à Marquer @deprecated (Phase Transition)

```dart
@deprecated
TextColumn get buyerName => text().nullable().named('buyer_name')();

@deprecated
TextColumn get buyerFarmId => text().nullable().named('buyer_farm_id')();

@deprecated
RealColumn get totalPrice => real().nullable().named('total_price')();

@deprecated
RealColumn get pricePerAnimal => real().nullable().named('price_per_animal')();

@deprecated
DateTimeColumn get saleDate => dateTime().nullable().named('sale_date')();

@deprecated
TextColumn get slaughterhouseName => text().nullable().named('slaughterhouse_name')();

@deprecated
TextColumn get slaughterhouseId => text().nullable().named('slaughterhouse_id')();

@deprecated
DateTimeColumn get slaughterDate => dateTime().nullable().named('slaughter_date')();
```

**Note :** Ces colonnes sont conservées en lecture seule pendant la Phase Transition (v2.x).
Elles seront supprimées en Phase Cleanup (v3.0).

---

## 5. Modèles de Données

### 5.1 Movement Model

```dart
class Movement implements SyncableEntity {
  final String id;
  final String farmId;
  final String animalId;
  final String type;  // Voir MovementType constants
  final DateTime movementDate;
  final String? fromFarmId;
  final String? toFarmId;
  final double? price;
  final String? notes;

  // ========== NOUVEAUX CHAMPS - Vente/Abattage ==========
  final String? buyerName;
  final String? buyerFarmId;
  final String? buyerType;  // Voir BuyerType constants
  final String? slaughterhouseName;
  final String? slaughterhouseId;

  // ========== NOUVEAUX CHAMPS - Mouvements Temporaires ==========
  final bool isTemporary;
  final String? temporaryMovementType;  // Voir TemporaryMovementType constants
  final DateTime? expectedReturnDate;
  final String? relatedMovementId;

  // Champs sync
  final bool synced;
  final DateTime? lastSyncedAt;
  final int? serverVersion;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  // ========== HELPER METHODS ==========

  bool get isSale => type == MovementConstants.sale;
  bool get isSlaughter => type == MovementConstants.slaughter;
  bool get isTemporaryOut => type == MovementConstants.temporaryOut;
  bool get isTemporaryReturn => type == MovementConstants.temporaryReturn;

  /// Vérifie si le mouvement temporaire est en retard
  bool get isOverdue =>
    isTemporary &&
    expectedReturnDate != null &&
    DateTime.now().isAfter(expectedReturnDate!);

  /// Vérifie si le mouvement temporaire a été retourné
  bool get isReturned =>
    isTemporaryOut && relatedMovementId != null;
}
```

### 5.2 Animal Model (Modifications)

```dart
class Animal implements SyncableEntity {
  final String id;
  final String farmId;  // Propriétaire légal
  // ... autres champs existants

  // ========== NOUVEAU CHAMP ==========
  final String? currentLocationFarmId;  // Localisation physique

  // ========== HELPER METHODS ==========

  /// ID du propriétaire légal
  String get ownerId => farmId;

  /// ID de la localisation physique actuelle
  String get physicalLocationId => currentLocationFarmId ?? farmId;

  /// Vérifie si l'animal est chez son propriétaire
  bool get isAtOwnerLocation =>
    currentLocationFarmId == null || currentLocationFarmId == farmId;

  /// Vérifie si l'animal est en mouvement temporaire
  bool get isOnTemporaryMovement => !isAtOwnerLocation;
}
```

---

## 6. Types de Mouvements

### 6.1 MovementType (Types Principaux)

```dart
class MovementConstants {
  // Types existants
  static const String birth = 'birth';
  static const String purchase = 'purchase';
  static const String sale = 'sale';
  static const String death = 'death';
  static const String slaughter = 'slaughter';

  // ========== NOUVEAUX TYPES - Mouvements Temporaires ==========

  /// Départ temporaire (prêt, transhumance, pension, etc.)
  static const String temporaryOut = 'temporary_out';

  /// Retour de mouvement temporaire
  static const String temporaryReturn = 'temporary_return';
}
```

### 6.2 TemporaryMovementType (Sous-Types)

**Architecture Générique Extensible**

```dart
class TemporaryMovementConstants {
  /// Prêt d'animal (ex: bélier pour reproduction)
  static const String loan = 'loan';

  /// Transhumance (déplacement saisonnier vers pâturages)
  static const String transhumance = 'transhumance';

  /// Pension/Garde (animal confié temporairement)
  static const String boarding = 'boarding';

  /// Quarantaine (isolement sanitaire)
  static const String quarantine = 'quarantine';

  /// Exposition/Salon agricole
  static const String exhibition = 'exhibition';

  /// Vente à l'essai (période d'évaluation)
  static const String trialSale = 'trial_sale';

  /// Soins vétérinaires (animal chez le vétérinaire)
  static const String veterinary = 'veterinary';

  // Facilement extensible pour nouveaux types...
}
```

**Avantage :** Ajouter un nouveau type = 1 ligne dans constants, 0 modification DB

### 6.3 BuyerType

```dart
class BuyerTypeConstants {
  /// Particulier/Individu
  static const String individual = 'individual';

  /// Ferme/Exploitation agricole
  static const String farm = 'farm';

  /// Commerçant/Négociant
  static const String trader = 'trader';

  /// Coopérative agricole
  static const String cooperative = 'cooperative';
}
```

### 6.4 AnimalStatus (Nouveaux Statuts)

```dart
class AnimalStatusConstants {
  // Statuts existants
  static const String alive = 'alive';
  static const String sold = 'sold';
  static const String dead = 'dead';
  static const String slaughtered = 'slaughtered';

  // ========== NOUVEAUX STATUTS - Phase 2 ==========

  /// Animal en mouvement temporaire (prêté, transhumance, etc.)
  static const String onTemporaryMovement = 'on_temporary_movement';
}
```

---

## 7. Cas d'Usage

### 7.1 Vente par Lot

**Flux Actuel (conservé) :**

```
┌─────────────────────────────────────────────────────────┐
│ ÉTAPE 1 : Création du Lot                              │
├─────────────────────────────────────────────────────────┤
│ User → Crée Lot (type=sale, status=open)               │
│ User → Ajoute animaux au Lot (animalIds: [...])        │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ ÉTAPE 2 : Finalisation de la Vente                     │
├─────────────────────────────────────────────────────────┤
│ User → Tape "Finaliser" → SaleScreen s'affiche         │
│ User → Saisit :                                         │
│   • buyerName = "Jean Dupont"                          │
│   • buyerFarmId = "F-12345"                            │
│   • buyerType = "farm"                                 │
│   • pricePerAnimal = 500€                              │
│   • saleDate = 2024-11-15                              │
│                                                         │
│ System → expandLotToSaleMovements() :                   │
│   Pour chaque animalId dans lot.animalIds :            │
│     Créer Movement :                                    │
│       • type = 'sale'                                   │
│       • animalId = animalId                            │
│       • buyerName = "Jean Dupont"         ✅ Nouveau   │
│       • buyerFarmId = "F-12345"           ✅ Nouveau   │
│       • buyerType = "farm"                ✅ Nouveau   │
│       • price = 500€                                   │
│       • movementDate = 2024-11-15                      │
│       • notes = null (plus besoin)                     │
│                                                         │
│     Mettre à jour Animal :                             │
│       • status = 'sold'                                │
│       • farmId = "F-12345" (nouveau propriétaire)      │
│                                                         │
│ System → Marque Lot comme fermé (status=closed)        │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ REQUÊTES POSSIBLES                                      │
├─────────────────────────────────────────────────────────┤
│ • Toutes les ventes à Jean Dupont :                    │
│   SELECT * FROM movements                               │
│   WHERE type='sale' AND buyer_name='Jean Dupont'       │
│                                                         │
│ • Toutes les ventes à la ferme F-12345 :               │
│   SELECT * FROM movements                               │
│   WHERE type='sale' AND buyer_farm_id='F-12345'        │
│                                                         │
│ • Revenu total du mois :                               │
│   SELECT SUM(price) FROM movements                      │
│   WHERE type='sale' AND movement_date BETWEEN ? AND ?  │
└─────────────────────────────────────────────────────────┘
```

### 7.2 Vente Individuelle

**Flux Actuel (conservé) :**

```
┌─────────────────────────────────────────────────────────┐
│ VENTE D'UN SEUL ANIMAL (sans Lot)                      │
├─────────────────────────────────────────────────────────┤
│ User → AnimalDetailScreen → Bouton "Vente"             │
│ User → SaleScreen s'affiche avec animal sélectionné    │
│ User → Saisit buyerName, buyerFarmId, buyerType, prix  │
│                                                         │
│ System → Créer Movement :                              │
│   • type = 'sale'                                       │
│   • animalId = animal.id                               │
│   • buyerName = ...              ✅ Nouveau            │
│   • buyerFarmId = ...            ✅ Nouveau            │
│   • buyerType = ...              ✅ Nouveau            │
│   • price = ...                                        │
│   • notes = null                                       │
│                                                         │
│ System → Mettre à jour Animal :                        │
│   • status = 'sold'                                    │
└─────────────────────────────────────────────────────────┘
```

### 7.3 Prêt d'Animal (Phase 2)

**Nouveau Flux :**

```
┌─────────────────────────────────────────────────────────┐
│ ÉTAPE 1 : Prêt Sortant (Ferme A → Ferme B)            │
├─────────────────────────────────────────────────────────┤
│ User → TemporaryMovementScreen                         │
│ User → Sélectionne animal (bélier)                     │
│ User → Sélectionne type = "loan"                       │
│ User → Sélectionne ferme destination (Ferme B)         │
│ User → Saisit date retour prévue = 2024-12-31          │
│                                                         │
│ System → Créer Movement :                              │
│   • id = 'mvt-001'                                     │
│   • type = 'temporary_out'           ✅ Nouveau        │
│   • temporaryMovementType = 'loan'   ✅ Nouveau        │
│   • animalId = 'belier-123'                            │
│   • fromFarmId = 'ferme-A'                             │
│   • toFarmId = 'ferme-B'                               │
│   • isTemporary = true               ✅ Nouveau        │
│   • expectedReturnDate = 2024-12-31  ✅ Nouveau        │
│   • relatedMovementId = null         ✅ Nouveau        │
│   • movementDate = 2024-10-01                          │
│                                                         │
│ System → Mettre à jour Animal :                        │
│   • farmId = 'ferme-A' (propriétaire inchangé)         │
│   • currentLocationFarmId = 'ferme-B' ✅ Nouveau       │
│   • status = 'on_temporary_movement'  ✅ Nouveau       │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ ÉTAPE 2 : Retour du Prêt (Ferme B → Ferme A)          │
├─────────────────────────────────────────────────────────┤
│ User → ReturnTemporaryMovementScreen                   │
│ User → Sélectionne le mouvement temporaire actif       │
│   (affiche : bélier-123, prêté à Ferme B, retour prévu │
│    le 2024-12-31)                                      │
│                                                         │
│ System → Créer Movement :                              │
│   • id = 'mvt-002'                                     │
│   • type = 'temporary_return'        ✅ Nouveau        │
│   • temporaryMovementType = 'loan'   ✅ Nouveau        │
│   • animalId = 'belier-123'                            │
│   • fromFarmId = 'ferme-B'                             │
│   • toFarmId = 'ferme-A'                               │
│   • isTemporary = false                                │
│   • relatedMovementId = 'mvt-001'    ✅ Lien           │
│   • movementDate = 2024-12-20                          │
│                                                         │
│ System → Mettre à jour Movement original :             │
│   • mvt-001.relatedMovementId = 'mvt-002' ✅ Lien      │
│                                                         │
│ System → Mettre à jour Animal :                        │
│   • farmId = 'ferme-A' (inchangé)                      │
│   • currentLocationFarmId = null (retour chez proprio) │
│   • status = 'alive' (retour au statut normal)         │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ REQUÊTES POSSIBLES                                      │
├─────────────────────────────────────────────────────────┤
│ • Tous les prêts actifs (non retournés) :              │
│   SELECT * FROM movements                               │
│   WHERE type='temporary_out'                            │
│     AND temporary_movement_type='loan'                  │
│     AND related_movement_id IS NULL                     │
│                                                         │
│ • Tous les prêts en retard :                           │
│   SELECT * FROM movements                               │
│   WHERE type='temporary_out'                            │
│     AND related_movement_id IS NULL                     │
│     AND expected_return_date < NOW()                    │
│                                                         │
│ • Animaux actuellement prêtés par Ferme A :            │
│   SELECT a.* FROM animals a                             │
│   WHERE a.farm_id='ferme-A'                            │
│     AND a.current_location_farm_id IS NOT NULL          │
│     AND a.status='on_temporary_movement'               │
└─────────────────────────────────────────────────────────┘
```

### 7.4 Transhumance (Phase 2)

**Flux Similaire au Prêt :**

```
Movement temporaryOut :
  • type = 'temporary_out'
  • temporaryMovementType = 'transhumance'  ✅ Différent du prêt
  • fromFarmId = 'ferme-A'
  • toFarmId = null (ou ID du pâturage si enregistré)
  • expectedReturnDate = 2024-09-30

Animal :
  • farmId = 'ferme-A' (propriétaire inchangé)
  • currentLocationFarmId = null (en montagne, pas de farmId)
  • status = 'on_temporary_movement'
```

---

## 8. Migration des Données

### 8.1 Stratégie Globale

**Approche : Migration Progressive en 3 Phases**

| Phase | Version | Durée | Description |
|-------|---------|-------|-------------|
| **Phase Transition** | v2.0 - v2.9 | 3-6 mois | Écriture double, lecture Movement prioritaire |
| **Phase Validation** | v2.9 | 1 mois | Tests, validation intégrité données |
| **Phase Cleanup** | v3.0 | - | Suppression colonnes Lot deprecated |

### 8.2 Migration Lots Fermés → Movements

**Script Migration SQL :**

```sql
-- ========================================
-- Migration des Lots SALE fermés
-- ========================================

-- Pour chaque lot de vente fermé, mettre à jour les movements associés
UPDATE movements_table m
SET
  buyer_name = (
    SELECT l.buyer_name
    FROM lots_table l
    WHERE l.farm_id = m.farm_id
      AND l.type = 'sale'
      AND l.status = 'closed'
      AND m.animal_id IN (
        -- Extraire animalIds du JSON
        SELECT json_each.value
        FROM lots_table, json_each(lots_table.animal_ids_json)
        WHERE lots_table.id = l.id
      )
  ),
  buyer_farm_id = (
    SELECT l.buyer_farm_id
    FROM lots_table l
    WHERE l.farm_id = m.farm_id
      AND l.type = 'sale'
      AND l.status = 'closed'
      AND m.animal_id IN (
        SELECT json_each.value
        FROM lots_table, json_each(lots_table.animal_ids_json)
        WHERE lots_table.id = l.id
      )
  ),
  buyer_type = 'farm',  -- Si via Lot, c'est forcément une ferme
  synced = false,
  updated_at = CURRENT_TIMESTAMP
WHERE m.type = 'sale'
  AND m.buyer_name IS NULL  -- Ne migrer que ceux pas encore migrés
  AND EXISTS (
    SELECT 1 FROM lots_table l
    WHERE l.farm_id = m.farm_id
      AND l.type = 'sale'
      AND l.status = 'closed'
  );

-- ========================================
-- Migration des Lots SLAUGHTER fermés
-- ========================================

UPDATE movements_table m
SET
  slaughterhouse_name = (
    SELECT l.slaughterhouse_name
    FROM lots_table l
    WHERE l.farm_id = m.farm_id
      AND l.type = 'slaughter'
      AND l.status = 'closed'
      AND m.animal_id IN (
        SELECT json_each.value
        FROM lots_table, json_each(lots_table.animal_ids_json)
        WHERE lots_table.id = l.id
      )
  ),
  slaughterhouse_id = (
    SELECT l.slaughterhouse_id
    FROM lots_table l
    WHERE l.farm_id = m.farm_id
      AND l.type = 'slaughter'
      AND l.status = 'closed'
      AND m.animal_id IN (
        SELECT json_each.value
        FROM lots_table, json_each(lots_table.animal_ids_json)
        WHERE lots_table.id = l.id
      )
  ),
  synced = false,
  updated_at = CURRENT_TIMESTAMP
WHERE m.type = 'slaughter'
  AND m.slaughterhouse_name IS NULL
  AND EXISTS (
    SELECT 1 FROM lots_table l
    WHERE l.farm_id = m.farm_id
      AND l.type = 'slaughter'
      AND l.status = 'closed'
  );
```

### 8.3 Migration Movements Individuels (notes → colonnes)

**Extraction des Notes (Regex Pattern Matching) :**

```dart
// movement_migration_service.dart

class MovementMigrationService {
  Future<void> migrateNotesToStructuredFields() async {
    final movements = await movementDao.findAll();

    for (final movement in movements) {
      if (movement.notes == null || movement.notes!.isEmpty) continue;

      Map<String, dynamic> updates = {};

      // ========== EXTRACTION BUYER INFO ==========
      if (movement.type == MovementConstants.sale) {
        // Pattern: "Acheteur: Jean Dupont (N°F-12345)"
        final buyerPattern = RegExp(
          r'Acheteur:\s*(.+?)\s*\(N°(.+?)\)',
          caseSensitive: false,
        );
        final match = buyerPattern.firstMatch(movement.notes!);

        if (match != null) {
          updates['buyer_name'] = match.group(1)?.trim();
          updates['buyer_farm_id'] = match.group(2)?.trim();
          updates['buyer_type'] = BuyerTypeConstants.individual; // Défaut
        }
      }

      // ========== EXTRACTION SLAUGHTERHOUSE INFO ==========
      if (movement.type == MovementConstants.slaughter) {
        // Pattern: "Abattoir: Abattoir Municipal (N°AB-789)"
        final slaughterhousePattern = RegExp(
          r'Abattoir:\s*(.+?)\s*\(N°(.+?)\)',
          caseSensitive: false,
        );
        final match = slaughterhousePattern.firstMatch(movement.notes!);

        if (match != null) {
          updates['slaughterhouse_name'] = match.group(1)?.trim();
          updates['slaughterhouse_id'] = match.group(2)?.trim();
        }
      }

      // Appliquer les mises à jour
      if (updates.isNotEmpty) {
        await movementDao.updatePartial(movement.id, updates);
        print('✅ Migrated movement ${movement.id}');
      }
    }
  }

  /// Validation post-migration
  Future<ValidationResult> validateMigration() async {
    final sales = await movementDao.findByType(farmId, MovementConstants.sale);
    final slaughters = await movementDao.findByType(farmId, MovementConstants.slaughter);

    final salesWithoutBuyer = sales.where((m) =>
      m.buyerName == null && m.buyerFarmId == null
    ).length;

    final slaughtersWithoutFacility = slaughters.where((m) =>
      m.slaughterhouseName == null
    ).length;

    return ValidationResult(
      totalSales: sales.length,
      salesWithoutBuyer: salesWithoutBuyer,
      totalSlaughters: slaughters.length,
      slaughtersWithoutFacility: slaughtersWithoutFacility,
    );
  }
}
```

### 8.4 Validation Post-Migration

**Tests d'Intégrité :**

```dart
// Tests à exécuter après migration

test('All closed sale lots have corresponding movements with buyer info', () async {
  final closedSaleLots = await lotDao.findByTypeAndStatus(
    farmId,
    LotType.sale,
    LotStatus.closed,
  );

  for (final lot in closedSaleLots) {
    for (final animalId in lot.animalIds) {
      final movements = await movementDao.findByAnimalId(farmId, animalId);
      final saleMovement = movements.firstWhere(
        (m) => m.type == MovementConstants.sale,
      );

      expect(saleMovement.buyerName, isNotNull);
      expect(saleMovement.buyerFarmId, isNotNull);
    }
  }
});

test('All movements with buyer info have consistent data', () async {
  final sales = await movementDao.findByType(farmId, MovementConstants.sale);

  for (final sale in sales) {
    if (sale.buyerName != null) {
      // Si buyerName existe, buyerType doit exister
      expect(sale.buyerType, isNotNull);

      // Si buyerType = farm, buyerFarmId doit exister
      if (sale.buyerType == BuyerTypeConstants.farm) {
        expect(sale.buyerFarmId, isNotNull);
      }
    }
  }
});
```

---

## 9. Plan d'Implémentation

### 9.1 Timeline Globale

**Durée Totale Estimée : 5-6 semaines**

```
Semaine 1 : Database Layer        [████████░░] 80%
Semaine 2 : Business Logic         [████████░░] 80%
Semaine 3 : UI & Migration         [████████░░] 80%
Semaine 4-5 : Testing & QA         [██████████] 100%
Semaine 6 : Déploiement            [██████████] 100%
```

### 9.2 Phase 1 : Database & Models (Semaine 1)

**Objectif :** Préparer les fondations sans casser l'existant

| Tâche | Fichiers | Effort | Priorité |
|-------|----------|--------|----------|
| Ajouter 9 colonnes MovementsTable | `lib/drift/tables/movements_table.dart` | 2h | P0 |
| Ajouter 1 colonne AnimalsTable | `lib/drift/tables/animals_table.dart` | 0.5h | P0 |
| Générer migration Drift | `drift build` | 0.5h | P0 |
| Mettre à jour Movement model | `lib/models/movement.dart` | 2h | P0 |
| Mettre à jour Animal model | `lib/models/animal.dart` | 1h | P0 |
| @deprecated sur Lot model | `lib/models/lot.dart` | 1h | P0 |
| Ajouter constantes | `lib/constants/movement_constants.dart` | 1h | P0 |
| Tests unitaires models | `test/models/` | 2h | P1 |

**Total : 10 heures**

### 9.3 Phase 2 : DAOs & Repositories (Semaine 2)

**Objectif :** Business logic pour les nouveaux champs

| Tâche | Fichiers | Effort | Priorité |
|-------|----------|--------|----------|
| Ajouter méthodes DAO (8 nouvelles) | `lib/drift/daos/movement_dao.dart` | 4h | P0 |
| Mettre à jour MovementRepository | `lib/repositories/movement_repository.dart` | 3h | P0 |
| Adapter LotRepository | `lib/repositories/lot_repository.dart` | 2h | P1 |
| Tests unitaires DAOs | `test/daos/` | 3h | P1 |

**Total : 12 heures**

### 9.4 Phase 3 : Providers (Semaine 2)

**Objectif :** Adapter la logique de création de mouvements

| Tâche | Fichiers | Effort | Priorité |
|-------|----------|--------|----------|
| Réécrire expandLotToSaleMovements() | `lib/providers/lot_provider.dart` | 3h | P0 |
| Réécrire expandLotToSlaughterMovements() | `lib/providers/lot_provider.dart` | 3h | P0 |
| Adapter AnimalProvider | `lib/providers/animal_provider.dart` | 2h | P1 |
| Tests unitaires Providers | `test/providers/` | 4h | P1 |

**Total : 12 heures**

### 9.5 Phase 4 : UI (Semaine 3)

**Objectif :** Adapter les écrans pour utiliser les champs structurés

| Tâche | Fichiers | Effort | Priorité |
|-------|----------|--------|----------|
| Adapter SaleScreen | `lib/screens/movement/sale_screen.dart` | 4h | P0 |
| Adapter SlaughterScreen | `lib/screens/movement/slaughter_screen.dart` | 4h | P0 |
| Ajouter clés I18n (4 langues × 8 clés) | `lib/l10n/app_*.arb` | 2h | P0 |
| Tests UI | `test/screens/` | 2h | P1 |

**Total : 12 heures**

### 9.6 Phase 5 : Migration Données (Semaine 3)

**Objectif :** Migrer données existantes vers nouveaux champs

| Tâche | Fichiers | Effort | Priorité |
|-------|----------|--------|----------|
| Créer script migration Lots → Movements | `lib/services/movement_migration_service.dart` | 4h | P0 |
| Créer script migration notes → colonnes | `lib/services/movement_migration_service.dart` | 3h | P0 |
| Tests migration sur DB dev | - | 2h | P0 |
| Validation intégrité données | - | 2h | P0 |

**Total : 11 heures**

### 9.7 Phase 6 : Testing & QA (Semaine 4-5)

**Objectif :** Garantir la qualité et la non-régression

| Tâche | Effort | Priorité |
|-------|--------|----------|
| Tests d'intégration (vente lot) | 4h | P0 |
| Tests d'intégration (vente individuelle) | 3h | P0 |
| Tests d'intégration (abattage) | 3h | P0 |
| Tests E2E (scénarios complets) | 6h | P0 |
| Tests de performance (requêtes) | 2h | P1 |
| UAT (User Acceptance Testing) | 4h | P0 |

**Total : 22 heures**

### 9.8 Phase 7 : Documentation & Déploiement (Semaine 6)

**Objectif :** Documenter et déployer

| Tâche | Effort | Priorité |
|-------|--------|----------|
| Documentation technique | 2h | P0 |
| Guide migration pour équipe | 1h | P0 |
| Release notes v2.0 | 1h | P0 |
| Déploiement staging | 1h | P0 |
| Monitoring post-déploiement | 2h | P0 |

**Total : 7 heures**

---

### 9.9 Résumé Effort Total

| Phase | Heures | Semaines |
|-------|--------|----------|
| Database & Models | 10h | S1 |
| DAOs & Repositories | 12h | S2 |
| Providers | 12h | S2 |
| UI | 12h | S3 |
| Migration Données | 11h | S3 |
| Testing & QA | 22h | S4-5 |
| Documentation & Déploiement | 7h | S6 |

**TOTAL : 86 heures = 5-6 semaines** (avec équipe de 1-2 personnes)

---

## 10. Extensions Futures

### 10.1 Phase 2 - Mouvements Temporaires (UI)

**Ce qui est préparé maintenant :**
- ✅ Colonnes DB : `is_temporary`, `temporary_movement_type`, `expected_return_date`, `related_movement_id`
- ✅ Modèles : `Movement` avec champs temporaires
- ✅ Constantes : `TemporaryMovementType` enum

**Ce qui reste à implémenter (Phase 2) :**
- ❌ UI : TemporaryMovementScreen (créer prêt, transhumance, etc.)
- ❌ UI : ReturnTemporaryMovementScreen (enregistrer retour)
- ❌ UI : TemporaryMovementListScreen (liste des mouvements actifs)
- ❌ Notifications : Alertes pour prêts en retard
- ❌ Rapports : Statistiques mouvements temporaires

**Effort estimé Phase 2 : 30 heures**

### 10.2 Phase 3 - Workflow Approbation

**Colonnes à ajouter dans MovementsTable :**
```dart
TextColumn get status =>
  text().withDefault(const Constant('completed'))();
  // 'pending', 'approved', 'rejected', 'completed'

TextColumn get approverId => text().nullable()();
DateTimeColumn get approvalDate => dateTime().nullable()();
BoolColumn get requiresApproval => boolean().withDefault(const Constant(false))();
```

**Colonnes à ajouter dans FarmsTable :**
```dart
BoolColumn get requireMovementApproval =>
  boolean().withDefault(const Constant(false))();
```

**Effort estimé Phase 3 : 25 heures**

### 10.3 Phase 4 - Documents Attachés

**Nouvelle table à créer :**
```dart
class MovementDocumentsTable extends Table {
  TextColumn get id => text()();
  TextColumn get movementId => text().named('movement_id')();
  TextColumn get farmId => text().named('farm_id')();
  TextColumn get documentType => text().named('document_type')();
  // 'health_certificate', 'invoice', 'receipt', 'customs', 'other'
  TextColumn get filePath => text().named('file_path')();
  DateTimeColumn get expiryDate => dateTime().nullable().named('expiry_date')();
  DateTimeColumn get uploadedAt => dateTime().named('uploaded_at')();

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (movement_id) REFERENCES movements_table(id)',
  ];
}
```

**Effort estimé Phase 4 : 35 heures**

---

## 11. Annexes

### 11.1 Clés I18n à Ajouter

**Fichier : `lib/l10n/app_fr.arb`**
```json
{
  "buyer_name": "Nom de l'acheteur",
  "buyer_farm_id": "ID de la ferme acheteuse",
  "buyer_type": "Type d'acheteur",
  "buyer_type_individual": "Particulier",
  "buyer_type_farm": "Ferme",
  "buyer_type_trader": "Négociant",
  "buyer_type_cooperative": "Coopérative",

  "slaughterhouse_name": "Nom de l'abattoir",
  "slaughterhouse_id": "Numéro d'agrément abattoir",

  "movement_type_temporary_out": "Mouvement temporaire (sortie)",
  "movement_type_temporary_return": "Retour de mouvement temporaire",

  "temporary_type_loan": "Prêt",
  "temporary_type_transhumance": "Transhumance",
  "temporary_type_boarding": "Pension/Garde",
  "temporary_type_quarantine": "Quarantaine",
  "temporary_type_exhibition": "Exposition",
  "temporary_type_trial_sale": "Vente à l'essai",
  "temporary_type_veterinary": "Soins vétérinaires",

  "expected_return_date": "Date de retour prévue",
  "movement_overdue": "Mouvement en retard",

  "current_location": "Localisation actuelle",
  "owner": "Propriétaire",
  "physical_location": "Localisation physique"
}
```

**Total : 20 nouvelles clés × 4 langues = 80 traductions**

### 11.2 Références

**Documents Liés :**
- [ANIMAL_TRANSFER_SYSTEM_SPECS.md](./ANIMAL_TRANSFER_SYSTEM_SPECS.md) - Spécifications initiales (référence historique)

**Standards Appliqués :**
- Multi-tenancy : Toutes requêtes filtrent par `farmId`
- Soft-delete : Utilisation de `deletedAt`
- I18n : Toutes chaînes traduites (FR, AR, EN, Tamazight)
- Constantes : Pas de valeurs en dur dans le code

---

## 12. Validation et Approbation

**Document approuvé le :** 2025-11-16
**Approuvé par :** Équipe Technique ani_tra

**Prochaines étapes :**
1. ✅ Créer branche `feature/enrich-movement-system`
2. ⏳ Implémenter Phase 1 (Database & Models)
3. ⏳ Implémenter Phase 2 (DAOs & Repositories)
4. ⏳ Implémenter Phase 3 (Providers)
5. ⏳ Implémenter Phase 4 (UI)
6. ⏳ Implémenter Phase 5 (Migration Données)
7. ⏳ Implémenter Phase 6 (Testing & QA)
8. ⏳ Déployer v2.0

---

**Fin du document**
