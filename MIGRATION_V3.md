# Migration v3 - Ajout des champs de retour pour mouvements temporaires

## Problème
L'erreur `no such column: return_date` indique que la base de données n'a pas les nouvelles colonnes.

## Solution

### Étape 1 : Régénérer le code Drift

```bash
dart run build_runner build --delete-conflicting-outputs
```

Cette commande va :
- Lire `lib/drift/tables/movements_table.dart` (qui contient déjà `returnDate` et `returnNotes`)
- Générer `lib/drift/database.g.dart` avec les nouvelles colonnes
- Mettre à jour toutes les classes Drift

### Étape 2 : Appliquer la migration

**Option A - Désinstaller/Réinstaller l'app (plus simple) :**
1. Désinstaller l'application
2. Réinstaller l'application
3. La base de données sera recréée avec toutes les colonnes

**Option B - Suppression manuelle de la base de données :**
```bash
# Android
adb shell run-as com.example.animal_trace rm -rf /data/data/com.example.animal_trace/databases/

# Puis relancer l'app
```

**Option C - Migration automatique (théorique) :**
La migration v2→v3 devrait s'appliquer automatiquement au premier lancement après avoir régénéré le code Drift, car :
- `schemaVersion` a été incrémenté à 3 ✅
- `_migrateToV3AddReturnFields()` existe ✅
- L'appel est dans `onUpgrade` ✅

**CEPENDANT**, si vous avez déjà lancé l'app avec le schemaVersion=3 AVANT de régénérer le code Drift, la migration ne s'appliquera pas car Drift pense qu'elle est déjà faite.

### Étape 3 : Vérifier

Après avoir régénéré et migré, testez :
1. Créer une sortie temporaire
2. Enregistrer un retour avec une date
3. Vérifier que le statut change à "Complété"
4. Vérifier que le bouton "Retour à la ferme" disparaît

## Détails techniques

### Colonnes ajoutées
```sql
ALTER TABLE movements ADD COLUMN return_date INTEGER;
ALTER TABLE movements ADD COLUMN return_notes TEXT;
```

### Code de migration (lib/drift/database.dart:1223-1230)
```dart
Future<void> _migrateToV3AddReturnFields() async {
  await customStatement(
    'ALTER TABLE movements ADD COLUMN return_date INTEGER;',
  );
  await customStatement(
    'ALTER TABLE movements ADD COLUMN return_notes TEXT;',
  );
}
```

## En cas de problème

Si après régénération et migration, l'erreur persiste :

1. Vérifier que `database.g.dart` a été régénéré :
   ```bash
   grep -n "returnDate" lib/drift/database.g.dart
   grep -n "returnNotes" lib/drift/database.g.dart
   ```

2. Si les lignes n'apparaissent pas, le code n'a pas été régénéré correctement

3. Nettoyer et régénérer :
   ```bash
   dart run build_runner clean
   dart run build_runner build --delete-conflicting-outputs
   ```

4. En dernier recours, supprimer complètement la base de données et redémarrer l'app
