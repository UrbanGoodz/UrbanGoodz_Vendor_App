# Browser Cache & Temp Cleanup Script for ChatGPT Performance Optimization

Write-Host "Closing active Edge and Chrome processes to free file locks..."
Stop-Process -Name "msedge" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "chrome" -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# 1. Clear Microsoft Edge Cache
$EdgeCache = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache"
if (Test-Path $EdgeCache) {
    Write-Host "Clearing Microsoft Edge Cache..."
    Get-ChildItem $EdgeCache -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
    Write-Host "Edge Cache cleared."
}

$EdgeCodeCache = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Code Cache"
if (Test-Path $EdgeCodeCache) {
    Write-Host "Clearing Microsoft Edge compiled JS Code Cache..."
    Get-ChildItem $EdgeCodeCache -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
}

# 2. Clear Google Chrome Cache
$ChromeCache = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache"
if (Test-Path $ChromeCache) {
    Write-Host "Clearing Google Chrome Cache..."
    Get-ChildItem $ChromeCache -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
    Write-Host "Chrome Cache cleared."
}

$ChromeCodeCache = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Code Cache"
if (Test-Path $ChromeCodeCache) {
    Write-Host "Clearing Google Chrome compiled JS Code Cache..."
    Get-ChildItem $ChromeCodeCache -Recurse -File -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
}

# 3. Clear System DNS Cache again
Clear-DnsClientCache

Write-Host "Cleanup completed successfully! Open your browser and test ChatGPT."
