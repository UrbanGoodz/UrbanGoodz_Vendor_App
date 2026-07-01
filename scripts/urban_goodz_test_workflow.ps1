param(
  [switch]$Serve,
  [int]$Port = 8080,
  [switch]$Deploy,
  [switch]$SkipBuild,
  [string]$DeployCommand = $env:UG_TEST_DEPLOY_COMMAND,
  [string]$DeploySshTarget = $env:UG_TEST_SSH_TARGET,
  [string]$DeployRemotePath = $env:UG_TEST_REMOTE_PATH
)

$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$buildDir = Join-Path $repoRoot 'build\web'
$outputsDir = Join-Path $repoRoot 'outputs'
$deployReadyDir = Join-Path $outputsDir 'urban-goodz-tester-web-build'
$zipPath = Join-Path $outputsDir 'urban-goodz-tester-web-build.zip'

function Assert-CommandSucceeded {
  param([string]$StepName)
  if ($LASTEXITCODE -ne 0) {
    throw "$StepName failed with exit code $LASTEXITCODE"
  }
}

function New-ZipFromDirectory {
  param(
    [string]$SourceDir,
    [string]$DestinationZip
  )

  if (Test-Path -LiteralPath $DestinationZip) {
    Remove-Item -LiteralPath $DestinationZip -Force
  }

  Add-Type -AssemblyName System.IO.Compression
  Add-Type -AssemblyName System.IO.Compression.FileSystem

  $archive = [System.IO.Compression.ZipFile]::Open(
    $DestinationZip,
    [System.IO.Compression.ZipArchiveMode]::Create
  )

  try {
    Get-ChildItem -LiteralPath $SourceDir -Recurse -Force -File | ForEach-Object {
      $relativePath = $_.FullName.Substring($SourceDir.Length).TrimStart([char]'\', [char]'/') -replace '\\', '/'
      [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
        $archive,
        $_.FullName,
        $relativePath,
        [System.IO.Compression.CompressionLevel]::Optimal
      ) | Out-Null
    }
  } finally {
    $archive.Dispose()
  }
}

Set-Location $repoRoot

if (-not $SkipBuild) {
  Write-Host 'Building Flutter web release...'
  flutter build web --release --base-href /
  Assert-CommandSucceeded 'Flutter web build'
}

if (-not (Test-Path -LiteralPath $buildDir)) {
  throw "Build output not found: $buildDir"
}

Write-Host 'Restoring tester web extras...'
Copy-Item -LiteralPath (Join-Path $repoRoot '.htaccess.backup') -Destination (Join-Path $buildDir '.htaccess') -Force
Copy-Item -LiteralPath (Join-Path $repoRoot 'tester-guide.html.backup') -Destination (Join-Path $buildDir 'tester-guide.html') -Force

Write-Host 'Refreshing deploy-ready folder...'
if (Test-Path -LiteralPath $deployReadyDir) {
  Remove-Item -LiteralPath $deployReadyDir -Recurse -Force
}
New-Item -ItemType Directory -Path $deployReadyDir | Out-Null
Copy-Item -Path (Join-Path $buildDir '*') -Destination $deployReadyDir -Recurse -Force
Get-ChildItem -LiteralPath $buildDir -Force | Where-Object { $_.Name.StartsWith('.') } | ForEach-Object {
  Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $deployReadyDir $_.Name) -Recurse -Force
}

Write-Host 'Refreshing tester ZIP...'
New-ZipFromDirectory -SourceDir (Resolve-Path $deployReadyDir).Path -DestinationZip $zipPath

if ($Deploy) {
  if ($DeployCommand) {
    Write-Host 'Running configured deploy command...'
    & powershell -NoProfile -ExecutionPolicy Bypass -Command $DeployCommand
    Assert-CommandSucceeded 'Deploy command'
  } elseif ($DeploySshTarget -and $DeployRemotePath) {
    Write-Host "Uploading deploy-ready folder to $DeploySshTarget:$DeployRemotePath ..."
    scp -r (Join-Path $deployReadyDir '*') "$DeploySshTarget`:$DeployRemotePath"
    Assert-CommandSucceeded 'SCP upload'
  } else {
    throw 'Deploy requested, but no deploy configuration was provided. Set UG_TEST_DEPLOY_COMMAND or UG_TEST_SSH_TARGET + UG_TEST_REMOTE_PATH.'
  }
} else {
  Write-Host 'Deploy skipped. Pass -Deploy only after test hosting credentials are approved/configured.'
}

Write-Host "Deploy-ready folder: $deployReadyDir"
Write-Host "Tester ZIP: $zipPath"

if ($Serve) {
  Write-Host "Starting local test server at http://127.0.0.1:$Port"
  Write-Host 'Press Ctrl+C to stop.'
  Set-Location $buildDir
  python -m http.server $Port
}
