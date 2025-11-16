# Script PowerShell pour regenerer le code Drift
# Executer depuis la racine du projet

Write-Host "=== Regeneration du code Drift ===" -ForegroundColor Cyan
Write-Host ""

# Etape 1 : Nettoyer le cache
Write-Host "Etape 1/4 : Nettoyage du cache build_runner..." -ForegroundColor Yellow
flutter pub run build_runner clean
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERREUR : Echec du nettoyage" -ForegroundColor Red
    exit 1
}
Write-Host "Cache nettoye" -ForegroundColor Green
Write-Host ""

# Etape 2 : Supprimer manuellement les .g.dart restants
Write-Host "Etape 2/4 : Suppression des fichiers .g.dart..." -ForegroundColor Yellow
$files = Get-ChildItem -Path . -Include *.g.dart -Recurse
if ($files) {
    $files | Remove-Item -Force
    Write-Host "Supprime $($files.Count) fichier(s) .g.dart" -ForegroundColor Green
}
else {
    Write-Host "Aucun fichier .g.dart trouve" -ForegroundColor Green
}
Write-Host ""

# Etape 3 : Regenerer le code
Write-Host "Etape 3/4 : Regeneration du code Drift (1-2 minutes)..." -ForegroundColor Yellow
flutter pub run build_runner build --delete-conflicting-outputs
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERREUR : Echec de la generation" -ForegroundColor Red
    Write-Host "Essayez : dart run build_runner build --delete-conflicting-outputs" -ForegroundColor Yellow
    exit 1
}
Write-Host "Code genere avec succes" -ForegroundColor Green
Write-Host ""

# Etape 4 : Verifier la compilation
Write-Host "Etape 4/4 : Verification de la compilation..." -ForegroundColor Yellow
flutter analyze
if ($LASTEXITCODE -eq 0) {
    Write-Host "Aucune erreur de compilation !" -ForegroundColor Green
}
else {
    Write-Host "Il reste des erreurs de compilation" -ForegroundColor Yellow
    Write-Host "Executez 'flutter analyze' pour plus de details" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Termine ===" -ForegroundColor Cyan
