# Script PowerShell pour régénérer le code Drift
# Exécuter depuis la racine du projet : .\regenerate_drift.ps1

Write-Host "=== Régénération du code Drift ===" -ForegroundColor Cyan
Write-Host ""

# Étape 1 : Nettoyer le cache
Write-Host "Étape 1/4 : Nettoyage du cache build_runner..." -ForegroundColor Yellow
flutter pub run build_runner clean
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERREUR : Échec du nettoyage" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Cache nettoyé" -ForegroundColor Green
Write-Host ""

# Étape 2 : Supprimer manuellement les .g.dart restants
Write-Host "Étape 2/4 : Suppression des fichiers .g.dart..." -ForegroundColor Yellow
$files = Get-ChildItem -Path . -Include *.g.dart -Recurse
if ($files) {
    $files | Remove-Item -Force
    Write-Host "✓ Supprimé $($files.Count) fichier(s) .g.dart" -ForegroundColor Green
} else {
    Write-Host "✓ Aucun fichier .g.dart trouvé" -ForegroundColor Green
}
Write-Host ""

# Étape 3 : Régénérer le code
Write-Host "Étape 3/4 : Régénération du code Drift (peut prendre 1-2 minutes)..." -ForegroundColor Yellow
flutter pub run build_runner build --delete-conflicting-outputs
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERREUR : Échec de la génération" -ForegroundColor Red
    Write-Host "Essayez manuellement : dart run build_runner build --delete-conflicting-outputs" -ForegroundColor Yellow
    exit 1
}
Write-Host "✓ Code généré avec succès" -ForegroundColor Green
Write-Host ""

# Étape 4 : Vérifier la compilation
Write-Host "Étape 4/4 : Vérification de la compilation..." -ForegroundColor Yellow
flutter analyze
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Aucune erreur de compilation !" -ForegroundColor Green
} else {
    Write-Host "⚠ Il reste des erreurs de compilation" -ForegroundColor Yellow
    Write-Host "Exécutez 'flutter analyze' pour plus de détails" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Terminé ===" -ForegroundColor Cyan
