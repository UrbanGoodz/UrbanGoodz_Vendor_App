$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$buildWeb = Join-Path $repoRoot 'build\web'
$port = 8080

function Assert-LastCommand {
  param([string]$StepName)

  if ($LASTEXITCODE -ne 0) {
    throw "$StepName failed with exit code $LASTEXITCODE"
  }
}

function Invoke-WebBuild {
  flutter pub get
  Assert-LastCommand 'flutter pub get'

  flutter build web --release --base-href /
  Assert-LastCommand 'flutter build web'
}

Set-Location $repoRoot

try {
  Invoke-WebBuild
} catch {
  Write-Host 'Build failed. Running flutter clean once, then retrying...'
  flutter clean
  Assert-LastCommand 'flutter clean'

  Invoke-WebBuild
}

if (-not (Test-Path -LiteralPath $buildWeb)) {
  throw "Build output not found: $buildWeb"
}

Write-Host ''
Write-Host 'Local Urban Goodz preview:'
Write-Host "http://localhost:$port"
Write-Host ''
Write-Host 'Press Ctrl+C to stop the server.'
Write-Host ''

Set-Location $buildWeb
python -m http.server $port
