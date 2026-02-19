# Download comprehensive Noto fonts for Flutter web
$fonts = @(
    @{url="https://github.com/notofonts/notofonts.github.io/raw/main/fonts/NotoSansSC/hinted/ttf/NotoSansSC-Regular.ttf"; file="NotoSansSC-Regular.ttf"},
    @{url="https://github.com/notofonts/notofonts.github.io/raw/main/fonts/NotoSansJP/hinted/ttf/NotoSansJP-Regular.ttf"; file="NotoSansJP-Regular.ttf"},
    @{url="https://github.com/notofonts/notofonts.github.io/raw/main/fonts/NotoSansKR/hinted/ttf/NotoSansKR-Regular.ttf"; file="NotoSansKR-Regular.ttf"},
    @{url="https://github.com/notofonts/notofonts.github.io/raw/main/fonts/NotoSansArabic/hinted/ttf/NotoSansArabic-Regular.ttf"; file="NotoSansArabic-Regular.ttf"},
    @{url="https://github.com/notofonts/notofonts.github.io/raw/main/fonts/NotoSansThai/hinted/ttf/NotoSansThai-Regular.ttf"; file="NotoSansThai-Regular.ttf"}
)

foreach ($font in $fonts) {
    Write-Host "Downloading $($font.file)..."
    try {
        Invoke-WebRequest -Uri $font.url -OutFile "assets/fonts/$($font.file)" -TimeoutSec 30
        Write-Host "✓ Downloaded $($font.file)" -ForegroundColor Green
    } catch {
        Write-Host "✗ Failed to download $($font.file): $_" -ForegroundColor Red
    }
}

Write-Host "`nDone! Remember to update pubspec.yaml with the new fonts."
