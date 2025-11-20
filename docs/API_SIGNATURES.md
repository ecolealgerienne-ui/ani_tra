# 📡 Signatures API - App Flutter vers Backend

**Document de référence pour tester les API avant connexion de l'app Flutter**

---

## 📋 Vue d'ensemble

L'application Flutter synchronise **8 types d'entités** via un endpoint unifié `/api/sync`.

### Entités synchronisables
1. **animal** - Animaux d'élevage
2. **treatment** - Traitements médicaux
3. **vaccination** - Vaccinations
4. **movement** - Mouvements d'animaux (achat, vente, mort, etc.)
5. **lot** - Lots d'animaux (campagnes, ventes groupées)
6. **weight** - Enregistrements de pesée
7. **breeding** - Reproductions/saillies
8. **document** - Documents liés aux animaux

### Actions disponibles
- `create` - Création d'une nouvelle entité
- `update` - Mise à jour d'une entité existante
- `delete` - Suppression (soft-delete) d'une entité

---

## 🔐 1. Authentification (Keycloak)

### 1.1 Login - Obtenir un token JWT

**Endpoint:** `{KEYCLOAK_URL}/realms/{REALM}/protocol/openid-connect/token`
**Méthode:** `POST`
**Content-Type:** `application/x-www-form-urlencoded`

**Body (form data):**
```
grant_type=password
client_id={CLIENT_ID}
client_secret={CLIENT_SECRET}    # Optionnel
username={USERNAME}
password={PASSWORD}
```

**Réponse (200 OK):**
```json
{
  "access_token": "eyJhbGc...",
  "refresh_token": "eyJhbGc...",
  "expires_in": 300,
  "refresh_expires_in": 1800,
  "token_type": "Bearer"
}
```

---

### 1.2 Refresh Token

**Endpoint:** `{KEYCLOAK_URL}/realms/{REALM}/protocol/openid-connect/token`
**Méthode:** `POST`
**Content-Type:** `application/x-www-form-urlencoded`

**Body (form data):**
```
grant_type=refresh_token
client_id={CLIENT_ID}
client_secret={CLIENT_SECRET}    # Optionnel
refresh_token={REFRESH_TOKEN}
```

---

### 1.3 Logout

**Endpoint:** `{KEYCLOAK_URL}/realms/{REALM}/protocol/openid-connect/logout`
**Méthode:** `POST`
**Content-Type:** `application/x-www-form-urlencoded`

**Body (form data):**
```
client_id={CLIENT_ID}
client_secret={CLIENT_SECRET}    # Optionnel
refresh_token={REFRESH_TOKEN}
```

---

## 📦 2. Synchronisation - Endpoint principal

### 2.1 Sync Batch (Multiple items)

**Endpoint:** `/api/sync` (ou configuré dans SyncConfig)
**Méthode:** `POST`
**Headers:**
```
Content-Type: application/json
Authorization: Bearer {JWT_TOKEN}
Accept: application/json
```

**Body:**
```json
{
  "items": [
    {
      "farmId": "string (UUID)",
      "entityType": "animal|treatment|vaccination|movement|lot|weight|breeding|document",
      "entityId": "string (UUID)",
      "action": "create|update|delete",
      "payload": { /* Structure selon entityType - voir section 3 */ },
      "clientTimestamp": "2025-01-15T10:30:00.000Z"
    }
  ]
}
```

**Réponse succès (200/201):**
```json
{
  "success": true,
  "results": [
    {
      "entityId": "string (UUID)",
      "success": true,
      "serverVersion": 1
    }
  ]
}
```

**Réponses d'erreur:**
- `400` - Erreur de validation
- `401` - Non authentifié
- `403` - Accès refusé
- `409` - Conflit de version
- `500/502/503` - Erreur serveur

---

### 2.2 Sync Item (Single item)

Même endpoint `/api/sync` mais avec un seul objet au lieu d'un tableau:

**Body:**
```json
{
  "farmId": "string (UUID)",
  "entityType": "animal",
  "entityId": "string (UUID)",
  "action": "create",
  "payload": { /* ... */ },
  "clientTimestamp": "2025-01-15T10:30:00.000Z"
}
```

---

## 🐑 3. Structures de Payload par Entity Type

---

### 3.1 ANIMAL

**entityType:** `"animal"`
**actions:** `create`, `update`, `delete`

#### Champs du payload

```json
{
  "id": "string (UUID)",
  "farmId": "string (UUID)",
  "current_location_farm_id": "string (UUID) | null",
  "current_eid": "string | null",
  "eid_history": [
    {
      "id": "string (UUID)",
      "oldEid": "string",
      "newEid": "string",
      "changedAt": "ISO 8601 datetime",
      "reason": "string",
      "notes": "string | null"
    }
  ] | null,
  "official_number": "string | null",
  "birth_date": "ISO 8601 datetime",
  "sex": "male | female",
  "mother_id": "string (UUID) | null",
  "status": "draft | alive | sold | dead | slaughtered | onTemporaryMovement",
  "validated_at": "ISO 8601 datetime | null",
  "species_id": "string | null",
  "breed_id": "string | null",
  "visual_id": "string | null",
  "photo_url": "string | null",
  "notes": "string | null",
  "days": "integer | null",
  "synced": "boolean",
  "created_at": "ISO 8601 datetime",
  "updated_at": "ISO 8601 datetime",
  "last_synced_at": "ISO 8601 datetime | null",
  "server_version": "string | null"
}
```

#### Contraintes de validation
- `current_eid` : Unique par ferme (farmId)
- `official_number` : Unique par ferme
- `sex` : Valeurs autorisées : `male`, `female`
- `status` : Valeurs autorisées : `draft`, `alive`, `sold`, `dead`, `slaughtered`, `onTemporaryMovement`

---

### 3.2 TREATMENT

**entityType:** `"treatment"`
**actions:** `create`, `update`, `delete`

#### Champs du payload

```json
{
  "id": "string (UUID)",
  "farm_id": "string (UUID)",
  "animal_id": "string (UUID)",
  "product_id": "string (UUID)",
  "product_name": "string",
  "dose": "number (double)",
  "treatment_date": "ISO 8601 datetime",
  "withdrawal_end_date": "ISO 8601 datetime",
  "notes": "string | null",
  "veterinarian_id": "string (UUID) | null",
  "veterinarian_name": "string | null",
  "campaign_id": "string (UUID) | null",
  "synced": "boolean",
  "created_at": "ISO 8601 datetime",
  "updated_at": "ISO 8601 datetime",
  "last_synced_at": "ISO 8601 datetime | null",
  "server_version": "string | null"
}
```

#### Relations
- `animal_id` → Animal (doit exister)
- `product_id` → MedicalProduct (doit exister)

---

### 3.3 VACCINATION

**entityType:** `"vaccination"`
**actions:** `create`, `update`, `delete`

#### Champs du payload

```json
{
  "id": "string (UUID)",
  "farm_id": "string (UUID)",
  "animal_id": "string (UUID) | null",
  "animal_ids": ["string (UUID)"] | [],
  "protocol_id": "string (UUID) | null",
  "vaccine_name": "string",
  "type": "obligatoire | recommandee | optionnelle",
  "disease": "string",
  "vaccination_date": "ISO 8601 datetime",
  "batch_number": "string | null",
  "expiry_date": "ISO 8601 datetime | null",
  "dose": "string",
  "administration_route": "string",
  "veterinarian_id": "string (UUID) | null",
  "veterinarian_name": "string | null",
  "next_due_date": "ISO 8601 datetime | null",
  "withdrawal_period_days": "integer",
  "notes": "string | null",
  "synced": "boolean",
  "created_at": "ISO 8601 datetime",
  "updated_at": "ISO 8601 datetime",
  "last_synced_at": "ISO 8601 datetime | null",
  "server_version": "string | null"
}
```

#### Contraintes
- **Soit** `animal_id` **soit** `animal_ids`, jamais les deux
- Si `animal_id` : vaccination individuelle
- Si `animal_ids` : vaccination de groupe

---

### 3.4 MOVEMENT

**entityType:** `"movement"`
**actions:** `create`, `update`, `delete`

#### Champs du payload

```json
{
  "id": "string (UUID)",
  "farm_id": "string (UUID)",
  "animal_id": "string (UUID)",
  "lot_id": "string (UUID) | null",
  "type": "birth | purchase | sale | death | slaughter | temporaryOut | temporaryReturn",
  "movement_date": "ISO 8601 datetime",
  "from_farm_id": "string (UUID) | null",
  "to_farm_id": "string (UUID) | null",
  "price": "number (double) | null",
  "notes": "string | null",
  "buyer_qr_signature": "string | null",
  "buyer_name": "string | null",
  "buyer_farm_id": "string (UUID) | null",
  "buyer_type": "individual | farm | trader | cooperative | null",
  "slaughterhouse_name": "string | null",
  "slaughterhouse_id": "string (UUID) | null",
  "is_temporary": "boolean",
  "temporary_movement_type": "loan | transhumance | boarding | null",
  "expected_return_date": "ISO 8601 datetime | null",
  "return_date": "ISO 8601 datetime | null",
  "return_notes": "string | null",
  "related_movement_id": "string (UUID) | null",
  "status": "ongoing | closed | archived",
  "synced": "boolean",
  "created_at": "ISO 8601 datetime",
  "updated_at": "ISO 8601 datetime",
  "last_synced_at": "ISO 8601 datetime | null",
  "server_version": "string | null"
}
```

#### Valeurs enum
- `type` : `birth`, `purchase`, `sale`, `death`, `slaughter`, `temporaryOut`, `temporaryReturn`
- `buyer_type` : `individual`, `farm`, `trader`, `cooperative`
- `temporary_movement_type` : `loan`, `transhumance`, `boarding`
- `status` : `ongoing`, `closed`, `archived`

---

### 3.5 LOT

**entityType:** `"lot"`
**actions:** `create`, `update`, `delete`

#### Champs du payload

```json
{
  "id": "string (UUID)",
  "farmId": "string (UUID)",
  "name": "string",
  "type": "treatment | purchase | sale | slaughter | null",
  "status": "open | closed | archived | null",
  "completed": "boolean",
  "completedAt": "ISO 8601 datetime | null",
  "animalIds": ["string (UUID)"],
  "productId": "string (UUID) | null",
  "productName": "string | null",
  "treatmentDate": "ISO 8601 datetime | null",
  "withdrawalEndDate": "ISO 8601 datetime | null",
  "veterinarianId": "string (UUID) | null",
  "veterinarianName": "string | null",
  "priceTotal": "number (double) | null",
  "buyerName": "string | null",
  "sellerName": "string | null",
  "notes": "string | null",
  "synced": "boolean",
  "createdAt": "ISO 8601 datetime",
  "updatedAt": "ISO 8601 datetime",
  "lastSyncedAt": "ISO 8601 datetime | null",
  "serverVersion": "string | null"
}
```

#### Valeurs enum
- `type` : `treatment`, `purchase`, `sale`, `slaughter`
- `status` : `open`, `closed`, `archived`

---

### 3.6 WEIGHT

**entityType:** `"weight"`
**actions:** `create`, `update`, `delete`

#### Champs du payload

```json
{
  "id": "string (UUID)",
  "farm_id": "string (UUID)",
  "animal_id": "string (UUID)",
  "weight": "number (double)",
  "recorded_at": "ISO 8601 datetime",
  "source": "scale | manual | estimated | veterinary",
  "notes": "string | null",
  "synced": "boolean",
  "created_at": "ISO 8601 datetime",
  "updated_at": "ISO 8601 datetime",
  "last_synced_at": "ISO 8601 datetime | null",
  "server_version": "string | null"
}
```

#### Valeurs enum
- `source` : `scale`, `manual`, `estimated`, `veterinary`

---

### 3.7 BREEDING

**entityType:** `"breeding"`
**actions:** `create`, `update`, `delete`

#### Champs du payload

```json
{
  "id": "string (UUID)",
  "farmId": "string (UUID)",
  "motherId": "string (UUID)",
  "fatherId": "string (UUID) | null",
  "fatherName": "string | null",
  "method": "natural | artificialInsemination",
  "breedingDate": "ISO 8601 datetime",
  "expectedBirthDate": "ISO 8601 datetime",
  "actualBirthDate": "ISO 8601 datetime | null",
  "expectedOffspringCount": "integer | null",
  "offspringIds": ["string (UUID)"],
  "veterinarianId": "string (UUID) | null",
  "veterinarianName": "string | null",
  "notes": "string | null",
  "status": "pending | completed | failed | aborted",
  "synced": "boolean",
  "createdAt": "ISO 8601 datetime",
  "updatedAt": "ISO 8601 datetime",
  "lastSyncedAt": "ISO 8601 datetime | null",
  "serverVersion": "string | null"
}
```

#### Valeurs enum
- `method` : `natural`, `artificialInsemination`
- `status` : `pending`, `completed`, `failed`, `aborted`

---

### 3.8 DOCUMENT

**entityType:** `"document"`
**actions:** `create`, `update`, `delete`

#### Champs du payload

```json
{
  "id": "string (UUID)",
  "farmId": "string (UUID)",
  "animalId": "string (UUID) | null",
  "type": "passport | certificate | invoice | transportCert | breedingCert | vetReport | other",
  "fileName": "string",
  "fileUrl": "string (URL)",
  "fileSizeBytes": "integer | null",
  "mimeType": "string | null",
  "uploadDate": "ISO 8601 datetime",
  "expiryDate": "ISO 8601 datetime | null",
  "notes": "string | null",
  "uploadedBy": "string (UUID) | null",
  "synced": "boolean",
  "createdAt": "ISO 8601 datetime",
  "updatedAt": "ISO 8601 datetime",
  "lastSyncedAt": "ISO 8601 datetime | null",
  "serverVersion": "string | null"
}
```

#### Valeurs enum
- `type` : `passport`, `certificate`, `invoice`, `transportCert`, `breedingCert`, `vetReport`, `other`

---

## 🧪 4. Exemples de requêtes complètes

### Exemple 1 : Créer un animal

```bash
POST /api/sync
Authorization: Bearer eyJhbGc...
Content-Type: application/json

{
  "farmId": "farm-123",
  "entityType": "animal",
  "entityId": "animal-456",
  "action": "create",
  "payload": {
    "id": "animal-456",
    "farmId": "farm-123",
    "current_location_farm_id": null,
    "current_eid": "250269801234567",
    "eid_history": null,
    "official_number": "FR1234567890",
    "birth_date": "2024-01-15T00:00:00.000Z",
    "sex": "female",
    "mother_id": null,
    "status": "alive",
    "validated_at": "2024-01-15T10:00:00.000Z",
    "species_id": "ovine",
    "breed_id": "merinos",
    "visual_id": "Rouge-42",
    "photo_url": null,
    "notes": null,
    "days": null,
    "synced": false,
    "created_at": "2024-01-15T10:00:00.000Z",
    "updated_at": "2024-01-15T10:00:00.000Z",
    "last_synced_at": null,
    "server_version": null
  },
  "clientTimestamp": "2024-01-15T10:00:00.000Z"
}
```

---

### Exemple 2 : Batch sync (multiple items)

```bash
POST /api/sync
Authorization: Bearer eyJhbGc...
Content-Type: application/json

{
  "items": [
    {
      "farmId": "farm-123",
      "entityType": "animal",
      "entityId": "animal-001",
      "action": "create",
      "payload": { /* ... */ },
      "clientTimestamp": "2024-01-15T10:00:00.000Z"
    },
    {
      "farmId": "farm-123",
      "entityType": "treatment",
      "entityId": "treatment-001",
      "action": "create",
      "payload": { /* ... */ },
      "clientTimestamp": "2024-01-15T10:05:00.000Z"
    }
  ]
}
```

---

## ❤️ 5. Health Check

**Endpoint:** `/health`
**Méthode:** `GET`
**Headers:** Aucun

**Réponse (200 OK):**
```json
{
  "status": "ok"
}
```

---

## 📝 6. Notes importantes

### Format des dates
- **Toutes les dates** sont en **ISO 8601** format : `2024-01-15T10:30:00.000Z`
- Timezone : UTC recommandé

### UUIDs
- Tous les IDs sont des UUIDs v4
- Format : `"123e4567-e89b-12d3-a456-426614174000"`

### Champs snake_case vs camelCase
- ⚠️ **Attention** : Certains modèles utilisent `snake_case` (animal, treatment, vaccination, movement, weight)
- D'autres utilisent `camelCase` (lot, breeding, document)
- **Respecter exactement** la casse indiquée dans ce document

### Gestion des erreurs
```json
{
  "success": false,
  "error": "Message d'erreur",
  "message": "Description détaillée"
}
```

---

## 🔗 7. Ressources

- Code source Flutter : `/lib/models/` (méthodes `toJson()`)
- Service de sync : `/lib/services/sync/sync_api_client.dart`
- Configuration : `/lib/utils/sync_config.dart`

---

**Document généré automatiquement à partir du code source Flutter**
**Dernière mise à jour : 2025-01-15**
