# fix_scan_screen_refs.ps1
# Script pour remplacer toutes les references a scan_screen

Write-Host "Recherche de toutes les references a scan_screen..."

# Trouver tous les fichiers qui importent scan_screen
Get-ChildItem -Path lib -Recurse -Filter "*.dart" | ForEach-Object {
    $file = $_.FullName
    $content = Get-Content $file -Raw
    
    if ($content -match "scan_screen|ScanScreen") {
        Write-Host ""
        Write-Host "Fixing $($_.Name)..."
        
        # Determiner le chemin relatif selon l'emplacement du fichier
        $relativePath = $_.DirectoryName
        
        if ($relativePath -match "lib\\screens\\animal") {
            # Dans le meme dossier animal
            $content = $content -replace "import 'scan_screen.dart';", "import 'animal_detail_screen.dart';"
            $content = $content -replace "import '../screens/scan_screen.dart';", "import 'animal_detail_screen.dart';"
        }
        elseif ($relativePath -match "lib\\screens\\") {
            # Dans un autre dossier de screens
            $content = $content -replace "import 'scan_screen.dart';", "import '../animal/animal_detail_screen.dart';"
            $content = $content -replace "import '../scan_screen.dart';", "import '../animal/animal_detail_screen.dart';"
        }
        else {
            # Depuis la racine lib ou autre
            $content = $content -replace "import 'screens/scan_screen.dart';", "import 'screens/animal/animal_detail_screen.dart';"
        }
        
        # Remplacer toutes les occurrences de la classe ScanScreen par AnimalDetailScreen
        $content = $content -replace "\bScanScreen\b", "AnimalDetailScreen"
        $content = $content -replace "_ScanScreenState", "_AnimalDetailScreenState"
        
        # Sauvegarder
        $content | Set-Content $file -NoNewline
        
        Write-Host "  Fixed!"
    }
}

Write-Host ""
Write-Host "Toutes les references a scan_screen ont ete corrigees!"