# replace-withopacity.ps1
$baseDir = "C:\Users\amar\Desktop\Tracabilite\src\flutter\animal_trace\lib"

$count = 0
Get-ChildItem -Path $baseDir -Recurse -Filter "*.dart" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    $pattern = '\.withOpacity\((\d+(?:\.\d+)?)\)'
    
    if ($content -match $pattern) {
        $newContent = $content -replace $pattern, '.withValues(alpha: $1)'
        Set-Content $_.FullName $newContent -NoNewline
        Write-Host "✅ $($_.Name)" -ForegroundColor Green
        $count++
    }
}

Write-Host "`n✨ $count fichiers modifiés!" -ForegroundColor Cyan