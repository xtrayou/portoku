# Script to check if all referenced images in HTML exist
$htmlPath = "c:\laragon\www\portoku\index.html"
$basePath = "c:\laragon\www\portoku"

Write-Host "Checking images referenced in HTML..." -ForegroundColor Cyan
Write-Host ""

# Read HTML content
$htmlContent = Get-Content $htmlPath -Raw

# Find all data-bg attributes
$pattern = 'data-bg="([^"]+)"'
$matches = [regex]::Matches($htmlContent, $pattern)

$missingImages = @()
$foundImages = @()

foreach ($match in $matches) {
    $imagePath = $match.Groups[1].Value
    $fullPath = Join-Path $basePath $imagePath
    
    if (Test-Path $fullPath) {
        $foundImages += $imagePath
        Write-Host "[OK] $imagePath" -ForegroundColor Green
    }
    else {
        $missingImages += $imagePath
        Write-Host "[MISSING] $imagePath" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Summary:" -ForegroundColor Yellow
Write-Host "Total images referenced: $($matches.Count)" -ForegroundColor White
Write-Host "Found: $($foundImages.Count)" -ForegroundColor Green
Write-Host "Missing: $($missingImages.Count)" -ForegroundColor Red

if ($missingImages.Count -gt 0) {
    Write-Host ""
    Write-Host "Missing images:" -ForegroundColor Red
    $missingImages | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
}
