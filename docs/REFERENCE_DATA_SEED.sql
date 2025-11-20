-- ============================================================================
-- Script d'injection des données de référence pour le backend
-- Base de données: PostgreSQL avec Prisma
-- Date: 2025-11-20
-- ============================================================================

-- IMPORTANT: Ajuster les noms de tables selon votre schéma Prisma

-- ============================================================================
-- 1. SPECIES (Espèces animales)
-- ============================================================================

INSERT INTO "AnimalSpecies" (id, name_fr, name_en, name_ar, icon, display_order) VALUES
('ovine', 'Ovin', 'Sheep', 'أغنام', '🐑', 1),
('bovine', 'Bovin', 'Cattle', 'أبقار', '🐄', 2),
('caprine', 'Caprin', 'Goat', 'ماعز', '🐐', 3)
ON CONFLICT (id) DO UPDATE SET
  name_fr = EXCLUDED.name_fr,
  name_en = EXCLUDED.name_en,
  name_ar = EXCLUDED.name_ar,
  icon = EXCLUDED.icon,
  display_order = EXCLUDED.display_order;

-- ============================================================================
-- 2. BREEDS (Races)
-- ============================================================================

INSERT INTO "Breed" (id, species_id, name_fr, name_en, name_ar, description, display_order, is_active) VALUES
-- Races ovines
('ouled-djellal', 'ovine', 'Ouled Djellal', 'Ouled Djellal', 'أولاد جلال', 'Race ovine algérienne résistante et adaptée aux zones arides', 1, true),
('rembi', 'ovine', 'Rembi', 'Rembi', 'الرمبي', 'Race ovine algérienne de grande taille', 2, true),
('hamra', 'ovine', 'Hamra', 'Hamra', 'الحمراء', 'Race ovine algérienne à laine rouge', 3, true),
('barbarine', 'ovine', 'Barbarine', 'Barbarine', 'البربرين', 'Race ovine à queue grasse', 4, true),
('sidaoun', 'ovine', 'Sidaoun', 'Sidaoun', 'السيداون', 'Race ovine algérienne adaptée aux montagnes', 5, true),

-- Races bovines
('brune-atlas', 'bovine', 'Brune de l''Atlas', 'Atlas Brown', 'البنية الأطلسية', 'Race bovine locale algérienne rustique', 1, true),
('guelmoise', 'bovine', 'Guelmoise', 'Guelmoise', 'القلموية', 'Race bovine algérienne de l''Est', 2, true),
('cheurfa', 'bovine', 'Cheurfa', 'Cheurfa', 'الشرفة', 'Race bovine algérienne du Nord-Ouest', 3, true),
('holstein', 'bovine', 'Holstein', 'Holstein', 'الهولشتاين', 'Race laitière haute productivité', 4, true),
('montbeliarde', 'bovine', 'Montbéliarde', 'Montbeliarde', 'المونبيليارد', 'Race mixte lait-viande', 5, true),

-- Races caprines
('arbia', 'caprine', 'Arabia', 'Arabia', 'العربية', 'Race caprine algérienne', 1, true),
('makatia', 'caprine', 'Makatia', 'Makatia', 'المكاتية', 'Race caprine des hauts plateaux', 2, true),
('naine-kabyle', 'caprine', 'Naine de Kabylie', 'Kabyle Dwarf', 'القزمة القبائلية', 'Petite chèvre de montagne', 3, true),
('alpine', 'caprine', 'Alpine', 'Alpine', 'الألبية', 'Race caprine laitière importée', 4, true),
('saanen', 'caprine', 'Saanen', 'Saanen', 'السانين', 'Race caprine blanche haute productivité laitière', 5, true)
ON CONFLICT (id) DO UPDATE SET
  species_id = EXCLUDED.species_id,
  name_fr = EXCLUDED.name_fr,
  name_en = EXCLUDED.name_en,
  name_ar = EXCLUDED.name_ar,
  description = EXCLUDED.description,
  display_order = EXCLUDED.display_order,
  is_active = EXCLUDED.is_active;

-- ============================================================================
-- 3. MEDICAL PRODUCTS (Produits médicaux)
-- ============================================================================

INSERT INTO "MedicalProduct" (
  id, farm_id, name, commercial_name, category, active_ingredient, manufacturer,
  form, dosage, dosage_unit, withdrawal_period_meat, withdrawal_period_milk,
  current_stock, min_stock, stock_unit, unit_price, currency,
  batch_number, expiry_date, storage_conditions, prescription, notes,
  is_active, type, target_species, standard_cure_days, administration_frequency,
  dosage_formula, default_administration_route, default_injection_site,
  created_at, updated_at
) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'farm-default', 'Amoxicilline 15%', 'Betamox LA', 'Antibiotique', 'Amoxicilline trihydrate', 'Norbrook',
  'Injectable', 150, 'mg/ml', 28, 96, 500, 100, 'ml', 850, 'DZD',
  'AMX2024-001', '2026-12-31', 'Conserver entre 2°C et 8°C', 'Ordonnance vétérinaire obligatoire', 'Agiter avant emploi',
  true, 'treatment', ARRAY['ovin', 'bovin', 'caprin'], 5, '1x/jour',
  '1ml/10kg', 'IM', 'Encolure',
  '2024-01-01', '2024-01-01'),

('550e8400-e29b-41d4-a716-446655440002', 'farm-default', 'Oxytétracycline LA', 'Terramycin LA', 'Antibiotique', 'Oxytétracycline', 'Zoetis',
  'Injectable', 200, 'mg/ml', 21, 72, 300, 80, 'ml', 920, 'DZD',
  'OXY2024-002', '2026-06-30', 'Conserver à l''abri de la lumière', 'Ordonnance vétérinaire obligatoire', 'Action prolongée',
  true, 'treatment', ARRAY['ovin', 'bovin', 'caprin'], 3, '1x tous les 3 jours',
  '1ml/10kg', 'IM', 'Cuisse',
  '2024-01-01', '2024-01-01'),

('550e8400-e29b-41d4-a716-446655440003', 'farm-default', 'Ivermectine 1%', 'Ivomec', 'Antiparasitaire', 'Ivermectine', 'Merial',
  'Injectable', 10, 'mg/ml', 35, 0, 250, 50, 'ml', 1200, 'DZD',
  'IVM2024-003', '2027-03-31', 'Conserver à température ambiante', 'Ordonnance vétérinaire recommandée', 'Traite parasites internes et externes',
  true, 'treatment', ARRAY['ovin', 'bovin', 'caprin'], 1, 'Unique',
  '1ml/50kg', 'SC', 'Derrière l''épaule',
  '2024-01-01', '2024-01-01'),

('550e8400-e29b-41d4-a716-446655440004', 'farm-default', 'Méloxicam 2%', 'Metacam', 'Anti-inflammatoire', 'Méloxicam', 'Boehringer',
  'Injectable', 20, 'mg/ml', 15, 120, 150, 40, 'ml', 1500, 'DZD',
  'MEL2024-004', '2026-09-30', 'Conserver entre 15°C et 25°C', 'Ordonnance vétérinaire obligatoire', 'AINS, analgésique et antipyrétique',
  true, 'treatment', ARRAY['ovin', 'bovin', 'caprin'], 3, '1x/jour',
  '0.5ml/100kg', 'SC', 'Encolure',
  '2024-01-01', '2024-01-01'),

('550e8400-e29b-41d4-a716-446655440005', 'farm-default', 'Closantel 5%', 'Supaverm', 'Antiparasitaire', 'Closantel sodique', 'Janssen',
  'Injectable', 50, 'mg/ml', 28, 0, 200, 50, 'ml', 980, 'DZD',
  'CLO2024-005', '2026-11-30', 'Protéger de la lumière', 'Ordonnance vétérinaire recommandée', 'Efficace contre fasciolose',
  true, 'treatment', ARRAY['ovin', 'bovin', 'caprin'], 1, 'Unique',
  '1ml/20kg', 'SC', 'Encolure',
  '2024-01-01', '2024-01-01')
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  commercial_name = EXCLUDED.commercial_name,
  category = EXCLUDED.category,
  active_ingredient = EXCLUDED.active_ingredient,
  manufacturer = EXCLUDED.manufacturer,
  form = EXCLUDED.form,
  dosage = EXCLUDED.dosage,
  dosage_unit = EXCLUDED.dosage_unit,
  withdrawal_period_meat = EXCLUDED.withdrawal_period_meat,
  withdrawal_period_milk = EXCLUDED.withdrawal_period_milk,
  current_stock = EXCLUDED.current_stock,
  min_stock = EXCLUDED.min_stock,
  stock_unit = EXCLUDED.stock_unit,
  unit_price = EXCLUDED.unit_price,
  currency = EXCLUDED.currency,
  batch_number = EXCLUDED.batch_number,
  expiry_date = EXCLUDED.expiry_date,
  storage_conditions = EXCLUDED.storage_conditions,
  prescription = EXCLUDED.prescription,
  notes = EXCLUDED.notes,
  is_active = EXCLUDED.is_active,
  type = EXCLUDED.type,
  target_species = EXCLUDED.target_species,
  standard_cure_days = EXCLUDED.standard_cure_days,
  administration_frequency = EXCLUDED.administration_frequency,
  dosage_formula = EXCLUDED.dosage_formula,
  default_administration_route = EXCLUDED.default_administration_route,
  default_injection_site = EXCLUDED.default_injection_site,
  updated_at = EXCLUDED.updated_at;

-- ============================================================================
-- 4. VACCINE REFERENCES (Vaccins de référence)
-- ============================================================================

INSERT INTO "VaccineReference" (
  id, farm_id, name, description, manufacturer, target_species, target_diseases,
  standard_dose, injections_required, injection_interval_days,
  meat_withdrawal_days, milk_withdrawal_days, administration_route, notes,
  is_active, created_at, updated_at
) VALUES
('660e8400-e29b-41d4-a716-446655440001', 'farm-default', 'Entérotoxémie + Pasteurellose',
  'Vaccin combiné contre entérotoxémie et pasteurellose ovine', 'Merial',
  ARRAY['ovine'], ARRAY['Entérotoxémie', 'Pasteurellose'],
  '2ml', 2, 21, 0, 0, 'SC', 'Primo-vaccination obligatoire avant la saison de pâturage',
  true, '2024-01-01', '2024-01-01'),

('660e8400-e29b-41d4-a716-446655440002', 'farm-default', 'Fièvre aphteuse (FMD)',
  'Vaccin contre la fièvre aphteuse', 'Bioveta',
  ARRAY['bovine', 'ovine', 'caprine'], ARRAY['Fièvre aphteuse'],
  '2ml', 1, NULL, 0, 0, 'IM', 'Vaccination obligatoire - Rappel annuel',
  true, '2024-01-01', '2024-01-01'),

('660e8400-e29b-41d4-a716-446655440003', 'farm-default', 'PPR (Peste des Petits Ruminants)',
  'Vaccin contre la peste des petits ruminants', 'OVI Vaccins',
  ARRAY['ovine', 'caprine'], ARRAY['PPR'],
  '1ml', 1, NULL, 0, 0, 'SC', 'Vaccination obligatoire - Immunité 3 ans',
  true, '2024-01-01', '2024-01-01'),

('660e8400-e29b-41d4-a716-446655440004', 'farm-default', 'Brucellose (B19)',
  'Vaccin contre la brucellose bovine', 'CNEVA',
  ARRAY['bovine'], ARRAY['Brucellose'],
  '2ml', 1, NULL, 0, 0, 'SC', 'Génisses de 3-8 mois uniquement - Vaccination obligatoire',
  true, '2024-01-01', '2024-01-01'),

('660e8400-e29b-41d4-a716-446655440005', 'farm-default', 'Charbon bactéridien',
  'Vaccin contre le charbon bactéridien', 'Colorado Serum',
  ARRAY['bovine', 'ovine', 'caprine'], ARRAY['Charbon bactéridien'],
  '1ml', 1, NULL, 0, 0, 'SC', 'Rappel annuel obligatoire',
  true, '2024-01-01', '2024-01-01'),

('660e8400-e29b-41d4-a716-446655440006', 'farm-default', 'Rage',
  'Vaccin antirabique', 'Pasteur',
  ARRAY['bovine', 'ovine', 'caprine'], ARRAY['Rage'],
  '1ml', 1, NULL, 0, 0, 'IM', 'Obligatoire dans les zones à risque - Rappel annuel',
  true, '2024-01-01', '2024-01-01'),

('660e8400-e29b-41d4-a716-446655440007', 'farm-default', 'Agalaxie contagieuse',
  'Vaccin contre l''agalaxie contagieuse', 'SAIDAL Vétérinaire',
  ARRAY['ovine', 'caprine'], ARRAY['Agalaxie contagieuse'],
  '1ml', 2, 28, 0, 0, 'SC', 'Vaccination recommandée dans les élevages laitiers',
  true, '2024-01-01', '2024-01-01')
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  manufacturer = EXCLUDED.manufacturer,
  target_species = EXCLUDED.target_species,
  target_diseases = EXCLUDED.target_diseases,
  standard_dose = EXCLUDED.standard_dose,
  injections_required = EXCLUDED.injections_required,
  injection_interval_days = EXCLUDED.injection_interval_days,
  meat_withdrawal_days = EXCLUDED.meat_withdrawal_days,
  milk_withdrawal_days = EXCLUDED.milk_withdrawal_days,
  administration_route = EXCLUDED.administration_route,
  notes = EXCLUDED.notes,
  is_active = EXCLUDED.is_active,
  updated_at = EXCLUDED.updated_at;

-- ============================================================================
-- 5. VETERINARIANS (Vétérinaires)
-- ============================================================================

INSERT INTO "Veterinarian" (
  id, farm_id, first_name, last_name, title, license_number, specialties,
  clinic, phone, mobile, email, address, city, postal_code, country,
  is_available, emergency_service, working_hours, consultation_fee, emergency_fee, currency,
  notes, is_preferred, is_default, rating, total_interventions, last_intervention_date,
  is_active, created_at, updated_at
) VALUES
('770e8400-e29b-41d4-a716-446655440001', 'farm-default', 'Karim', 'Bensalem', 'Dr.', 'VET-DZ-2018-001234',
  ARRAY['Ovins', 'Caprins', 'Médecine préventive'],
  'Cabinet Vétérinaire Bensalem', '+213 25 12 34 56', '+213 661 23 45 67', 'k.bensalem@vetalger.dz',
  '15 Rue des Frères Bouadou', 'Sétif', '19000', 'Algérie',
  true, true, 'Lun-Sam: 08:00-18:00', 3000, 5000, 'DZD',
  'Spécialisé en élevage ovin de steppe', true, true, 5, 156, '2024-11-15',
  true, '2023-01-15', '2024-11-15'),

('770e8400-e29b-41d4-a716-446655440002', 'farm-default', 'Amina', 'Zeddam', 'Dr.', 'VET-DZ-2020-005678',
  ARRAY['Bovins', 'Reproduction', 'Échographie'],
  'Clinique Vétérinaire des Hauts Plateaux', '+213 36 78 90 12', '+213 772 34 56 78', 'a.zeddam@vetclinic.dz',
  'Boulevard de l''Indépendance', 'M''Sila', '28000', 'Algérie',
  true, false, 'Lun-Jeu: 09:00-17:00', 3500, NULL, 'DZD',
  'Expertise en reproduction bovine et IA', false, false, 4, 89, '2024-10-28',
  true, '2023-03-20', '2024-10-28'),

('770e8400-e29b-41d4-a716-446655440003', 'farm-default', 'Mohamed', 'Tebboune', 'Dr.', 'VET-DZ-2015-003456',
  ARRAY['Urgences', 'Chirurgie', 'Petits ruminants'],
  'Polyclinique Vétérinaire Tebboune', '+213 29 45 67 89', '+213 550 12 34 56', 'm.tebboune@polyclivet.dz',
  'Zone Industrielle, Lot 45', 'Bordj Bou Arreridj', '34000', 'Algérie',
  true, true, '24h/24 - 7j/7', 2800, 4500, 'DZD',
  'Service d''urgence disponible nuit et week-end', false, false, 5, 234, '2024-11-18',
  true, '2022-06-10', '2024-11-18')
ON CONFLICT (id) DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  title = EXCLUDED.title,
  license_number = EXCLUDED.license_number,
  specialties = EXCLUDED.specialties,
  clinic = EXCLUDED.clinic,
  phone = EXCLUDED.phone,
  mobile = EXCLUDED.mobile,
  email = EXCLUDED.email,
  address = EXCLUDED.address,
  city = EXCLUDED.city,
  postal_code = EXCLUDED.postal_code,
  country = EXCLUDED.country,
  is_available = EXCLUDED.is_available,
  emergency_service = EXCLUDED.emergency_service,
  working_hours = EXCLUDED.working_hours,
  consultation_fee = EXCLUDED.consultation_fee,
  emergency_fee = EXCLUDED.emergency_fee,
  currency = EXCLUDED.currency,
  notes = EXCLUDED.notes,
  is_preferred = EXCLUDED.is_preferred,
  is_default = EXCLUDED.is_default,
  rating = EXCLUDED.rating,
  total_interventions = EXCLUDED.total_interventions,
  last_intervention_date = EXCLUDED.last_intervention_date,
  is_active = EXCLUDED.is_active,
  updated_at = EXCLUDED.updated_at;

-- ============================================================================
-- 6. FARMS (Fermes)
-- ============================================================================

INSERT INTO "Farm" (id, name, location, owner_id, cheptel_number, group_id, group_name, created_at, updated_at) VALUES
('farm-default', 'Exploitation Agricole El Baraka', 'Commune de Ain El Kebira, Wilaya de Sétif',
  'owner-001', 'SET-2024-00145', NULL, NULL, '2023-01-01', '2024-11-20'),

('farm-002', 'Ferme Laitière El Amel', 'Route de Constantine Km 12, Sétif',
  'owner-001', 'SET-2024-00246', 'group-001', 'Coopérative Laitière des Hauts Plateaux', '2023-06-15', '2024-11-20')
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  location = EXCLUDED.location,
  owner_id = EXCLUDED.owner_id,
  cheptel_number = EXCLUDED.cheptel_number,
  group_id = EXCLUDED.group_id,
  group_name = EXCLUDED.group_name,
  updated_at = EXCLUDED.updated_at;

-- ============================================================================
-- 7. FARM PREFERENCES (Préférences de ferme)
-- ============================================================================

INSERT INTO "FarmPreference" (id, farm_id, default_veterinarian_id, default_species_id, default_breed_id, created_at, updated_at) VALUES
('pref-default', 'farm-default', '770e8400-e29b-41d4-a716-446655440001', 'ovine', 'ouled-djellal', '2023-01-01', '2024-11-20')
ON CONFLICT (id) DO UPDATE SET
  default_veterinarian_id = EXCLUDED.default_veterinarian_id,
  default_species_id = EXCLUDED.default_species_id,
  default_breed_id = EXCLUDED.default_breed_id,
  updated_at = EXCLUDED.updated_at;

-- ============================================================================
-- 8. ALERT CONFIGURATIONS (Configurations d'alertes)
-- ============================================================================

INSERT INTO "AlertConfiguration" (
  id, farm_id, evaluation_type, type, category, title_key, message_key,
  severity, icon_name, color_hex, enabled, created_at, updated_at
) VALUES
('alert-001', 'farm-default', 'remanence', 'urgent', 'Santé', 'alert.remanence.title', 'alert.remanence.message',
  3, 'warning', '#FF5252', true, '2023-01-01', '2024-01-01'),

('alert-002', 'farm-default', 'weighing', 'important', 'Performance', 'alert.weighing.title', 'alert.weighing.message',
  2, 'scale', '#FF9800', true, '2023-01-01', '2024-01-01'),

('alert-003', 'farm-default', 'vaccination', 'urgent', 'Santé', 'alert.vaccination.title', 'alert.vaccination.message',
  3, 'syringe', '#FF5252', true, '2023-01-01', '2024-01-01'),

('alert-004', 'farm-default', 'identification', 'important', 'Administration', 'alert.identification.title', 'alert.identification.message',
  2, 'id-card', '#FF9800', true, '2023-01-01', '2024-01-01'),

('alert-005', 'farm-default', 'syncRequired', 'routine', 'Système', 'alert.sync.title', 'alert.sync.message',
  1, 'sync', '#2196F3', true, '2023-01-01', '2024-01-01'),

('alert-006', 'farm-default', 'treatmentRenewal', 'important', 'Santé', 'alert.treatment.title', 'alert.treatment.message',
  2, 'medication', '#FF9800', true, '2023-01-01', '2024-01-01'),

('alert-007', 'farm-default', 'batchToFinalize', 'routine', 'Gestion', 'alert.batch.title', 'alert.batch.message',
  1, 'list', '#4CAF50', true, '2023-01-01', '2024-01-01'),

('alert-008', 'farm-default', 'draftAnimals', 'routine', 'Gestion', 'alert.draft.title', 'alert.draft.message',
  1, 'draft', '#9E9E9E', true, '2023-01-01', '2024-01-01')
ON CONFLICT (id) DO UPDATE SET
  evaluation_type = EXCLUDED.evaluation_type,
  type = EXCLUDED.type,
  category = EXCLUDED.category,
  title_key = EXCLUDED.title_key,
  message_key = EXCLUDED.message_key,
  severity = EXCLUDED.severity,
  icon_name = EXCLUDED.icon_name,
  color_hex = EXCLUDED.color_hex,
  enabled = EXCLUDED.enabled,
  updated_at = EXCLUDED.updated_at;

-- ============================================================================
-- 9. CAMPAIGNS (Campagnes)
-- ============================================================================

INSERT INTO "Campaign" (
  id, farm_id, name, product_id, product_name, campaign_date, withdrawal_end_date,
  veterinarian_id, veterinarian_name, completed, created_at, updated_at
) VALUES
('campaign-001', 'farm-default', 'Vaccination Fièvre Aphteuse 2024',
  '660e8400-e29b-41d4-a716-446655440002', 'Fièvre aphteuse (FMD)',
  '2024-03-15 09:00:00', '2024-03-15 09:00:00',
  '770e8400-e29b-41d4-a716-446655440001', 'Dr. Karim Bensalem',
  true, '2024-02-01', '2024-03-15 15:00:00'),

('campaign-002', 'farm-default', 'Déparasitage Printemps 2024',
  '550e8400-e29b-41d4-a716-446655440003', 'Ivermectine 1%',
  '2024-04-10 10:00:00', '2024-05-15 00:00:00',
  NULL, NULL,
  true, '2024-03-20', '2024-04-10 16:00:00'),

('campaign-003', 'farm-default', 'Vaccination PPR Automne 2024',
  '660e8400-e29b-41d4-a716-446655440003', 'PPR (Peste des Petits Ruminants)',
  '2024-10-01 08:00:00', '2024-10-01 08:00:00',
  '770e8400-e29b-41d4-a716-446655440001', 'Dr. Karim Bensalem',
  true, '2024-09-01', '2024-10-01 14:00:00')
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  product_id = EXCLUDED.product_id,
  product_name = EXCLUDED.product_name,
  campaign_date = EXCLUDED.campaign_date,
  withdrawal_end_date = EXCLUDED.withdrawal_end_date,
  veterinarian_id = EXCLUDED.veterinarian_id,
  veterinarian_name = EXCLUDED.veterinarian_name,
  completed = EXCLUDED.completed,
  updated_at = EXCLUDED.updated_at;

-- ============================================================================
-- FIN DU SCRIPT
-- ============================================================================

-- Afficher les statistiques d'insertion
SELECT 'Species' as table_name, COUNT(*) as count FROM "AnimalSpecies"
UNION ALL
SELECT 'Breeds', COUNT(*) FROM "Breed"
UNION ALL
SELECT 'Medical Products', COUNT(*) FROM "MedicalProduct"
UNION ALL
SELECT 'Vaccines', COUNT(*) FROM "VaccineReference"
UNION ALL
SELECT 'Veterinarians', COUNT(*) FROM "Veterinarian"
UNION ALL
SELECT 'Farms', COUNT(*) FROM "Farm"
UNION ALL
SELECT 'Farm Preferences', COUNT(*) FROM "FarmPreference"
UNION ALL
SELECT 'Alert Configurations', COUNT(*) FROM "AlertConfiguration"
UNION ALL
SELECT 'Campaigns', COUNT(*) FROM "Campaign";
