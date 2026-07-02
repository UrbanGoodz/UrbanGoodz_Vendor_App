param(
    [switch]$SkipBuild
)

$ErrorActionPreference = "Stop"

Write-Host "Urban Goodz customer tester release check" -ForegroundColor Cyan

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Host "BLOCKED: flutter is not available on PATH." -ForegroundColor Red
    exit 1
}

Write-Host "Flutter version:" -ForegroundColor Yellow
flutter --version

Write-Host "Running flutter analyze..." -ForegroundColor Yellow
flutter analyze

if (-not $SkipBuild) {
    Write-Host "Running flutter web release build..." -ForegroundColor Yellow
    flutter build web --release --base-href / --no-wasm-dry-run

    if (-not (Test-Path "build\web")) {
        Write-Host "BLOCKED: build\web was not created." -ForegroundColor Red
        exit 1
    }

    New-Item -ItemType Directory -Force outputs | Out-Null
    $zipPath = "outputs\urban-goodz-tester-web-build.zip"
    if (Test-Path $zipPath) {
        Remove-Item $zipPath -Force
    }
    Compress-Archive -Path "build\web\*" -DestinationPath $zipPath -Force
    Write-Host "Created $zipPath" -ForegroundColor Green
}

Write-Host "Release check complete." -ForegroundColor Green
