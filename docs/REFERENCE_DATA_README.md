# Données de Test - Entités de Référence

Ce dossier contient des données de test réalistes pour les 9 entités de référence du système de gestion d'élevage.

## 📁 Fichiers Disponibles

1. **`REFERENCE_DATA_TEST.json`** - Données au format JSON (idéal pour tests API ou import programmatique)
2. **`REFERENCE_DATA_SEED.sql`** - Script SQL pour PostgreSQL/Prisma (injection directe en base)

---

## 📊 Contenu des Données

### 1. **Species** (Espèces) - 3 entrées
- Ovin (Sheep / أغنام)
- Bovin (Cattle / أبقار)
- Caprin (Goat / ماعز)

### 2. **Breeds** (Races) - 15 entrées

**Races ovines algériennes (5):**
- Ouled Djellal - Race rustique adaptée aux zones arides
- Rembi - Race de grande taille
- Hamra - Race à laine rouge
- Barbarine - Race à queue grasse
- Sidaoun - Race de montagne

**Races bovines (5):**
- Brune de l'Atlas - Race locale rustique
- Guelmoise - Race de l'Est algérien
- Cheurfa - Race du Nord-Ouest
- Holstein - Race laitière importée
- Montbéliarde - Race mixte lait-viande

**Races caprines (5):**
- Arabia - Race algérienne
- Makatia - Race des hauts plateaux
- Naine de Kabylie - Petite chèvre de montagne
- Alpine - Race laitière importée
- Saanen - Race blanche haute productivité

### 3. **Medical Products** (Produits médicaux) - 5 entrées

**Antibiotiques:**
- Amoxicilline 15% (Betamox LA) - Délai viande: 28j, lait: 96h
- Oxytétracycline LA (Terramycin LA) - Délai viande: 21j, lait: 72h

**Antiparasitaires:**
- Ivermectine 1% (Ivomec) - Délai viande: 35j
- Closantel 5% (Supaverm) - Contre fasciolose, délai: 28j

**Anti-inflammatoires:**
- Méloxicam 2% (Metacam) - AINS, délai viande: 15j, lait: 120h

### 4. **Vaccine References** (Vaccins) - 7 entrées

**Vaccins obligatoires:**
- Fièvre aphteuse (FMD) - Multi-espèces
- PPR (Peste des Petits Ruminants) - Ovins/Caprins
- Brucellose (B19) - Bovins (génisses 3-8 mois)
- Charbon bactéridien - Multi-espèces

**Vaccins recommandés:**
- Entérotoxémie + Pasteurellose - Ovins
- Rage - Zones à risque
- Agalaxie contagieuse - Élevages laitiers

### 5. **Veterinarians** (Vétérinaires) - 3 entrées

1. **Dr. Karim Bensalem** - Sétif
   - Spécialités: Ovins, Caprins, Médecine préventive
   - Service d'urgence disponible
   - Vétérinaire par défaut
   - Rating: 5/5 (156 interventions)

2. **Dr. Amina Zeddam** - M'Sila
   - Spécialités: Bovins, Reproduction, Échographie
   - Expertise en IA
   - Rating: 4/5 (89 interventions)

3. **Dr. Mohamed Tebboune** - Bordj Bou Arreridj
   - Spécialités: Urgences, Chirurgie
   - Service 24h/24 - 7j/7
   - Rating: 5/5 (234 interventions)

### 6. **Farms** (Fermes) - 2 entrées
- Exploitation Agricole El Baraka - Ain El Kebira, Sétif
- Ferme Laitière El Amel - Sétif (membre coopérative)

### 7. **Farm Preferences** (Préférences) - 1 entrée
- Ferme par défaut avec vétérinaire Dr. Bensalem
- Espèce par défaut: Ovin
- Race par défaut: Ouled Djellal

### 8. **Alert Configurations** (Alertes) - 8 entrées
- **Urgentes (3):** Rémanence, Vaccination, (rouge)
- **Importantes (3):** Pesée, Identification, Renouvellement traitement (orange)
- **Routine (3):** Sync requis, Lots à finaliser, Animaux brouillon (vert/bleu/gris)

### 9. **Campaigns** (Campagnes) - 3 entrées
- Vaccination Fièvre Aphteuse 2024 (complétée)
- Déparasitage Printemps 2024 (complétée)
- Vaccination PPR Automne 2024 (complétée)

---

## 🚀 Utilisation

### Option 1: Import JSON (API ou Prisma Seed)

```typescript
// prisma/seed.ts
import * as fs from 'fs';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  const data = JSON.parse(
    fs.readFileSync('docs/REFERENCE_DATA_TEST.json', 'utf-8')
  );

  // Import species
  for (const species of data.species) {
    await prisma.animalSpecies.upsert({
      where: { id: species.id },
      update: species,
      create: species,
    });
  }

  // Import breeds
  for (const breed of data.breeds) {
    await prisma.breed.upsert({
      where: { id: breed.id },
      update: breed,
      create: breed,
    });
  }

  // ... répéter pour les autres entités

  console.log('✅ Données de référence importées avec succès');
}

main()
  .catch((e) => console.error(e))
  .finally(() => prisma.$disconnect());
```

**Exécution:**
```bash
npx prisma db seed
```

---

### Option 2: Import SQL Direct

**Méthode 1: Via psql**
```bash
psql -U postgres -d votre_base -f docs/REFERENCE_DATA_SEED.sql
```

**Méthode 2: Via pgAdmin**
1. Ouvrir pgAdmin
2. Se connecter à votre base de données
3. Ouvrir l'outil Query Tool
4. Charger le fichier `REFERENCE_DATA_SEED.sql`
5. Exécuter le script

**Méthode 3: Via Docker (si base en container)**
```bash
docker exec -i postgres_container psql -U postgres -d votre_base < docs/REFERENCE_DATA_SEED.sql
```

---

### Option 3: Import via API (Postman/Insomnia)

1. Démarrer votre backend NestJS
2. Utiliser les endpoints GET de référence avec les données JSON
3. Créer une collection Postman avec les données

---

## ⚠️ Important

### Avant l'Import

1. **Vérifier les noms de tables** dans le script SQL - ils doivent correspondre à votre schéma Prisma
2. **Adapter les IDs** si nécessaire (notamment `farm-default` et `owner-001`)
3. **Backup de la base** si vous importez en production

### Noms de Tables à Vérifier

Le script SQL utilise ces noms de tables (à adapter selon votre schéma):
- `AnimalSpecies`
- `Breed`
- `MedicalProduct`
- `VaccineReference`
- `Veterinarian`
- `Farm`
- `FarmPreference`
- `AlertConfiguration`
- `Campaign`

### Conversion snake_case → camelCase

Si votre schéma Prisma utilise camelCase pour les colonnes, ajustez le script SQL:

**Exemple:**
```sql
-- Avant (snake_case)
name_fr, name_en, name_ar

-- Après (camelCase)
nameFr, nameEn, nameAr
```

---

## 🧪 Tests Recommandés

Après l'import, vérifier:

1. **Endpoints GET fonctionnels:**
```bash
GET /api/reference/species
GET /api/reference/breeds?species_id=ovine
GET /api/reference/medical-products?type=treatment
GET /api/reference/vaccines
GET /api/reference/veterinarians?farm_id=farm-default
GET /api/reference/farms
GET /api/reference/farm-preferences?farm_id=farm-default
GET /api/reference/alert-configurations?farm_id=farm-default
GET /api/reference/campaigns?farm_id=farm-default
```

2. **Relations correctes:**
   - Breeds → Species (species_id)
   - Veterinarians → Farm (farm_id)
   - Campaigns → MedicalProduct (product_id)
   - Farm Preferences → Veterinarian (default_veterinarian_id)

3. **Données multilingues:** Vérifier affichage FR/EN/AR

---

## 📝 Personnalisation

### Ajouter Plus de Données

**Races supplémentaires:**
```json
{
  "id": "nouvelle-race",
  "species_id": "ovine",
  "name_fr": "Nouvelle Race",
  "name_en": "New Breed",
  "name_ar": "سلالة جديدة",
  "description": "Description de la race",
  "display_order": 6,
  "is_active": true
}
```

**Produits médicaux:**
```json
{
  "id": "uuid",
  "farmId": "farm-default",
  "name": "Nom du produit",
  "type": "treatment",
  "targetSpecies": ["ovin", "bovin"],
  "withdrawalPeriodMeat": 14,
  "withdrawalPeriodMilk": 48,
  "currentStock": 100,
  "minStock": 20,
  "stockUnit": "ml"
}
```

### Changer les Fermes

Remplacer `farm-default` par votre ID de ferme réel dans:
- medical_products
- vaccines
- veterinarians
- farm_preferences
- alert_configurations
- campaigns

---

## 🔄 Mise à Jour des Données

Le script SQL utilise `ON CONFLICT DO UPDATE` pour permettre les mises à jour:

```sql
-- Ré-exécuter le script mettra à jour les données existantes
psql -U postgres -d votre_base -f docs/REFERENCE_DATA_SEED.sql
```

---

## 📞 Support

Pour questions ou problèmes:
1. Vérifier les logs de votre backend
2. Vérifier la structure de votre schéma Prisma
3. Adapter les noms de colonnes si nécessaire

---

## ✅ Checklist Post-Import

- [ ] Toutes les espèces affichées dans l'app
- [ ] Races filtrées par espèce
- [ ] Produits médicaux disponibles
- [ ] Vaccins listés avec maladies cibles
- [ ] Vétérinaires avec coordonnées complètes
- [ ] Fermes accessibles
- [ ] Préférences chargées correctement
- [ ] Alertes configurées et actives
- [ ] Campagnes historiques visibles

---

**Dernière mise à jour:** 2025-11-20
**Version:** 1.0
