# remove-unused-imports.ps1
$baseDir = "C:\Users\amar\Desktop\Tracabilite\src\flutter\animal_trace\lib"

$importsToRemove = @{
    "data\mock_alerts_generator.dart" = @("import '../models/alert_category.dart';")
    "providers\alert_provider.dart" = @(
        "import '../models/treatment.dart';",
        "import '../models/weight_record.dart';",
        "import '../models/sync_status.dart';"
    )
    "providers\lot_provider.dart" = @("import '../models/product.dart';")
    "screens\alert\alerts_screen.dart" = @("import '../../models/alert_type.dart';")
    "screens\animal\add_animal_screen.dart" = @(
        "import '../../models/animal_species.dart';",
        "import '../../models/breed.dart';"
    )
    "screens\animal\animal_detail_screen.dart" = @("import '../../models/eid_change.dart';")
    "screens\animal\animal_list_screen.dart" = @(
        "import 'dart:math';",
        "import '../../i18n/app_localizations.dart';",
        "import '../../widgets/animal_card.dart';",
        "import 'package:flutter/services.dart';"
    )
    "screens\lot\campaign_list_screen.dart" = @("import '../lot/campaign_scan_screen.dart';")
    "screens\movement\slaughter_screen.dart" = @("import '../../models/treatment.dart';")
    "screens\sync\sync_detail_screen.dart" = @("import '../../providers/campaign_provider.dart';")
    "screens\treatment\treatment_screen.dart" = @("import '../../models/animal.dart';")
    "widgets\farm_preferences_section.dart" = @(
        "import '../models/animal_species.dart';",
        "import '../models/breed.dart';"
    )
}

foreach ($file in $importsToRemove.Keys) {
    $filePath = Join-Path $baseDir $file
    if (Test-Path $filePath) {
        $content = Get-Content $filePath -Raw
        foreach ($import in $importsToRemove[$file]) {
            $content = $content -replace [regex]::Escape($import), ""
        }
        $content = $content -replace "(\r?\n){3,}", "`n`n"
        Set-Content $filePath $content -NoNewline
        Write-Host "✅ $file" -ForegroundColor Green
    }
}

Write-Host "`n✨ Terminé!" -ForegroundColor Cyan