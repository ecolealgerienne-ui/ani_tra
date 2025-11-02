# fix-all-critical-errors.ps1
$ErrorActionPreference = "Stop"
$baseDir = "C:\Users\amar\Desktop\Tracabilite\src\flutter\animal_trace\lib"

Write-Host "🔧 CORRECTION DES ERREURS CRITIQUES" -ForegroundColor Cyan
Write-Host "===================================`n" -ForegroundColor Cyan

$totalFixed = 0

# === 1. Remplacer .eid par .currentEid (38 fichiers) ===
Write-Host "📝 1. Remplacement .eid → .currentEid..." -ForegroundColor Yellow

$filesToFix = @(
    "providers\alert_provider.dart",
    "providers\animal_provider.dart",
    "screens\animal\add_animal_screen.dart",
    "screens\animal\animal_weight_history_screen.dart",
    "screens\lot\batch_scan_screen.dart",
    "screens\lot\campaign_detail_screen.dart",
    "screens\lot\lot_detail_screen.dart",
    "screens\lot\lot_scan_screen.dart",
    "screens\movement\birth_screen.dart",
    "screens\movement\death_screen.dart",
    "screens\movement\sale_screen.dart",
    "screens\movement\slaughter_screen.dart",
    "screens\weight\weight_record_screen.dart",
    "widgets\animal_card.dart"
)

foreach ($file in $filesToFix) {
    $fullPath = Join-Path $baseDir $file
    if (Test-Path $fullPath) {
        $content = Get-Content $fullPath -Raw
        $newContent = $content -replace '\.eid\b', '.currentEid'
        
        if ($content -ne $newContent) {
            Set-Content $fullPath $newContent -NoNewline -Encoding UTF8
            Write-Host "  ✅ $file" -ForegroundColor Green
            $totalFixed++
        }
    }
}

# === 2. Ajouter farmId dans add_animal_screen.dart ligne 178 ===
Write-Host "`n📝 2. Ajout farmId dans add_animal_screen.dart..." -ForegroundColor Yellow

$addAnimalPath = Join-Path $baseDir "screens\animal\add_animal_screen.dart"
if (Test-Path $addAnimalPath) {
    $content = Get-Content $addAnimalPath -Raw
    
    # Trouver Animal( et ajouter farmId juste après
    $pattern = '(final animal = Animal\(\s*)'
    $replacement = '$1farmId: ''farm_default'',`n        '
    
    $newContent = $content -replace $pattern, $replacement
    
    if ($content -ne $newContent) {
        Set-Content $addAnimalPath $newContent -NoNewline -Encoding UTF8
        Write-Host "  ✅ add_animal_screen.dart" -ForegroundColor Green
        $totalFixed++
    }
}

# === 3. Supprimer EidChange du fichier eid_change.dart (doublon) ===
Write-Host "`n📝 3. Correction conflit EidChange..." -ForegroundColor Yellow

$eidChangePath = Join-Path $baseDir "models\eid_change.dart"
if (Test-Path $eidChangePath) {
    Write-Host "  ⚠️  Suppression du fichier eid_change.dart (doublon avec animal.dart)" -ForegroundColor Yellow
    Remove-Item $eidChangePath -Force
    Write-Host "  ✅ eid_change.dart supprimé" -ForegroundColor Green
    $totalFixed++
}

# === 4. Corriger animal_provider.dart (EidChange et changeEid) ===
Write-Host "`n📝 4. Correction animal_provider.dart..." -ForegroundColor Yellow

$animalProviderPath = Join-Path $baseDir "providers\animal_provider.dart"
if (Test-Path $animalProviderPath) {
    $content = Get-Content $animalProviderPath -Raw
    
    # Supprimer l'import de eid_change.dart
    $newContent = $content -replace "import '../models/eid_change\.dart';\s*\n", ""
    
    # Remplacer oldEid/newEid par eid dans les comparaisons
    $newContent = $newContent -replace '\.oldEid', '.eid'
    $newContent = $newContent -replace '\.newEid', '.eid'
    
    # Remplacer animal.changeEid par animal.copyWith
    $newContent = $newContent -replace '\.changeEid\(', '.copyWith(currentEid: '
    
    if ($content -ne $newContent) {
        Set-Content $animalProviderPath $newContent -NoNewline -Encoding UTF8
        Write-Host "  ✅ animal_provider.dart" -ForegroundColor Green
        $totalFixed++
    }
}

# === 5. Corriger animal_detail_screen.dart (type EidChange) ===
Write-Host "`n📝 5. Correction animal_detail_screen.dart..." -ForegroundColor Yellow

$detailPath = Join-Path $baseDir "screens\animal\animal_detail_screen.dart"
if (Test-Path $detailPath) {
    $content = Get-Content $detailPath -Raw
    
    # Supprimer l'import de eid_change.dart s'il existe
    $newContent = $content -replace "import '../../models/eid_change\.dart';\s*\n", ""
    
    if ($content -ne $newContent) {
        Set-Content $detailPath $newContent -NoNewline -Encoding UTF8
        Write-Host "  ✅ animal_detail_screen.dart" -ForegroundColor Green
        $totalFixed++
    }
}

# === 6. Corriger les imports AnimalListScreen ===
Write-Host "`n📝 6. Correction imports AnimalListScreen..." -ForegroundColor Yellow

$filesWithListScreen = @(
    "main.dart",
    "screens\alert\alerts_screen.dart",
    "screens\home\home_screen.dart"
)

foreach ($file in $filesWithListScreen) {
    $fullPath = Join-Path $baseDir $file
    if (Test-Path $fullPath) {
        $content = Get-Content $fullPath -Raw
        
        # Supprimer les imports unused
        $newContent = $content -replace "import 'screens/animal/animal_list_screen\.dart';\s*\n", ""
        $newContent = $newContent -replace "import '\.\./animal/animal_list_screen\.dart';\s*\n", ""
        
        # Remplacer AnimalListScreen() par un commentaire temporaire
        $newContent = $newContent -replace 'AnimalListScreen\(\)', '/* TODO: AnimalListScreen */'
        $newContent = $newContent -replace 'const AnimalListScreen\(\)', '/* TODO: AnimalListScreen */'
        
        if ($content -ne $newContent) {
            Set-Content $fullPath $newContent -NoNewline -Encoding UTF8
            Write-Host "  ✅ $file" -ForegroundColor Green
            $totalFixed++
        }
    }
}

Write-Host "`n===================================" -ForegroundColor Cyan
Write-Host "✨ TERMINÉ ! $totalFixed corrections" -ForegroundColor Green
Write-Host "`n🔍 Prochaine étape:" -ForegroundColor Yellow
Write-Host "cd C:\Users\amar\Desktop\Tracabilite\src\flutter\animal_trace" -ForegroundColor Gray
Write-Host "flutter analyze" -ForegroundColor Gray