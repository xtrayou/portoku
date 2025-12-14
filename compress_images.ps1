# Image Compression Script for Portfolio
# Compresses JPEG images to reduce file size while maintaining quality

param(
    [string]$FolderPath = "dokumentasimagang",
    [int]$Quality = 75,
    [int]$MaxWidth = 1920
)

Add-Type -AssemblyName System.Drawing

$images = Get-ChildItem -Path $FolderPath -Include *.jpg,*.jpeg,*.png -Recurse
$totalImages = $images.Count
$compressed = 0
$originalSize = 0
$newSize = 0

Write-Host "`nCompressing $totalImages images in $FolderPath..." -ForegroundColor Cyan
Write-Host "Quality: $Quality% | Max Width: $MaxWidth px`n" -ForegroundColor Yellow

foreach ($image in $images) {
    try {
        $originalSize += $image.Length
        
        # Load image
        $img = [System.Drawing.Image]::FromFile($image.FullName)
        
        # Calculate new dimensions if image is too large
        $newWidth = $img.Width
        $newHeight = $img.Height
        
        if ($img.Width -gt $MaxWidth) {
            $newWidth = $MaxWidth
            $newHeight = [int]($img.Height * ($MaxWidth / $img.Width))
        }
        
        # Create new bitmap with calculated dimensions
        $newImg = New-Object System.Drawing.Bitmap($newWidth, $newHeight)
        $graphics = [System.Drawing.Graphics]::FromImage($newImg)
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.DrawImage($img, 0, 0, $newWidth, $newHeight)
        
        # Get encoder for JPEG
        $jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
        $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
        $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, $Quality)
        
        # Save compressed image
        $img.Dispose()
        $tempFile = $image.FullName + ".tmp"
        $newImg.Save($tempFile, $jpegCodec, $encoderParams)
        $newImg.Dispose()
        $graphics.Dispose()
        
        # Replace original with compressed
        Remove-Item $image.FullName -Force
        Move-Item $tempFile $image.FullName -Force
        
        $newFileSize = (Get-Item $image.FullName).Length
        $newSize += $newFileSize
        $compressed++
        
        $reduction = [math]::Round((1 - ($newFileSize / $image.Length)) * 100, 1)
        Write-Host "[$compressed/$totalImages] $($image.Name) - Reduced by $reduction%" -ForegroundColor Green
        
    } catch {
        Write-Host "Error processing $($image.Name): $_" -ForegroundColor Red
    }
}

$totalReduction = [math]::Round((1 - ($newSize / $originalSize)) * 100, 1)
$savedMB = [math]::Round(($originalSize - $newSize) / 1MB, 2)

Write-Host "`n=== Compression Complete ===" -ForegroundColor Cyan
Write-Host "Images processed: $compressed/$totalImages" -ForegroundColor Yellow
Write-Host "Original size: $([math]::Round($originalSize/1MB, 2)) MB" -ForegroundColor Yellow
Write-Host "New size: $([math]::Round($newSize/1MB, 2)) MB" -ForegroundColor Yellow
Write-Host "Total reduction: $totalReduction% ($savedMB MB saved)" -ForegroundColor Green
