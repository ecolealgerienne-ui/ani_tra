# Data Migrations

Ce dossier contient les utilitaires de migration de données pour ani_tra.

## Lot-to-Movement Migration (Phase 5)

### Contexte

Avant la Phase 3 du projet Movement System Enrichment, les lots de vente et d'abattage finalisés **ne créaient pas de Movement records**.

La Phase 3 a introduit la création automatique de movements lors de la finalisation des lots (voir `lot_finalize_screen.dart`), mais les lots historiques déjà finalisés n'ont pas de movements associés.

### Problème

Les lots "orphelins" (finalisés mais sans Movement records) posent problème car :
- Les données de traçabilité ne sont que dans le Lot, pas dans Movement
- Les nouvelles queries de Movement (Phase 2) ne trouvent pas ces données historiques
- Incohérence entre lots récents et lots historiques

### Solution

L'utilitaire `LotToMovementMigration` crée les Movement records manquants pour les lots orphelins.

## Utilisation

### Option 1 : Migration manuelle dans l'app

```dart
import 'package:provider/provider.dart';
import '../migrations/lot_to_movement_migration.dart';
import '../providers/lot_provider.dart';
import '../providers/movement_provider.dart';

// Dans un bouton admin ou une page de settings
Future<void> runMigration(BuildContext context, String farmId) async {
  final lotProvider = context.read<LotProvider>();
  final movementProvider = context.read<MovementProvider>();

  final migrator = LotToMovementMigration(
    lotProvider: lotProvider,
    movementProvider: movementProvider,
  );

  final result = await migrator.migrateOrphanedLots(farmId);

  print(result.toString());
  // Afficher un dialog avec les résultats
}
```

### Option 2 : Migration automatique au démarrage (one-time)

```dart
// Dans main.dart ou un provider d'initialisation
class AppInitializer {
  static Future<void> runOneTimeMigrations(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final migrationDone = prefs.getBool('lot_movement_migration_v1') ?? false;

    if (!migrationDone) {
      final farmId = context.read<FarmProvider>().currentFarmId;
      await runMigration(context, farmId);
      await prefs.setBool('lot_movement_migration_v1', true);
    }
  }
}
```

### Option 3 : Script de migration (terminal)

Pour une migration en dehors de l'app :

```dart
// scripts/migrate_lots.dart
import 'package:ani_tra/drift/database.dart';
import 'package:ani_tra/migrations/lot_to_movement_migration.dart';
import 'package:ani_tra/providers/lot_provider.dart';
import 'package:ani_tra/providers/movement_provider.dart';

void main() async {
  // Initialiser la database
  final db = AppDatabase();

  // Créer les providers
  final lotProvider = LotProvider(db);
  final movementProvider = MovementProvider(db);

  // Charger les lots
  await lotProvider.loadLots('farm_id_here');

  // Run migration
  final migrator = LotToMovementMigration(
    lotProvider: lotProvider,
    movementProvider: movementProvider,
  );

  final result = await migrator.migrateOrphanedLots('farm_id_here');
  print(result.toString());

  await db.close();
}
```

## Résultat de la migration

La migration retourne un `MigrationResult` contenant :

```
Migration Result:
- Total closed/archived lots: 42
- Lots with existing movements: 35
- Orphaned lots (no movements): 7
- Successfully migrated: 7
- Failed: 0
```

## Détection des lots orphelins

Un lot est considéré orphelin si :
1. Son statut est `closed` ou `archived`
2. Son type est `sale` ou `slaughter` (pas `treatment`)
3. Aucun Movement record n'existe pour les animaux du lot avec :
   - Type correspondant (`sale` → `MovementType.sale`)
   - Date proche de `completedAt` (tolérance ±1 jour)

## Création des Movements

Pour chaque lot orphelin détecté, la migration :

### Lots de vente (LotType.sale)
- Crée un Movement par animal avec :
  - `type: MovementType.sale`
  - `buyerName`: copié de `Lot.buyerName` (deprecated)
  - `buyerFarmId`: copié de `Lot.buyerFarmId` (deprecated)
  - `buyerType`: déterminé automatiquement ('farm' ou 'individual')
  - `price`: copié de `Lot.pricePerAnimal` (deprecated)
  - `movementDate`: `Lot.saleDate` ou `Lot.completedAt`

### Lots d'abattage (LotType.slaughter)
- Crée un Movement par animal avec :
  - `type: MovementType.slaughter`
  - `slaughterhouseName`: copié de `Lot.slaughterhouseName` (deprecated)
  - `slaughterhouseId`: copié de `Lot.slaughterhouseId` (deprecated)
  - `movementDate`: `Lot.slaughterDate` ou `Lot.completedAt`

## Sécurité

- **Non-destructive** : Ne modifie jamais les Lot existants
- **Idempotent** : Peut être exécuté plusieurs fois sans duplication
- **Détection** : Vérifie toujours si des movements existent avant création
- **Logging** : Log tous les événements (success/warning/error)
- **Erreurs** : Continue même si un lot échoue, reporte les erreurs

## Limitations

- Ne migre que les lots `sale` et `slaughter`
- Les lots `treatment` sont ignorés (ils créent des Treatment, pas Movement)
- Nécessite que les champs deprecated du Lot soient remplis
- Tolérance de ±1 jour pour la détection de duplicatas

## Après migration

Une fois la migration terminée :
1. Les nouveaux lots continueront à créer des movements automatiquement
2. Les anciens lots auront leurs movements créés
3. Les queries Movement (Phase 2) fonctionneront sur toutes les données
4. Les champs deprecated de Lot pourront être retirés en v3.0

## Développement futur

En v3.0, après que tous les utilisateurs aient migré :
- Retirer les champs deprecated de Lot
- Retirer les annotations `// ignore: deprecated_member_use`
- Movement devient la seule source de vérité pour vente/abattage
