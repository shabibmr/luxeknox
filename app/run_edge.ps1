# Run Flutter on Microsoft Edge and write logs to a temporary file
$ErrorActionPreference = "Stop"

# Determine target Flutter project directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $scriptDir) { $scriptDir = (Get-Location).Path }

if (Test-Path (Join-Path $scriptDir "pubspec.yaml")) {
    $appDir = $scriptDir
} elseif (Test-Path (Join-Path $scriptDir "..\app\pubspec.yaml")) {
    $appDir = (Resolve-Path (Join-Path $scriptDir "..\app")).Path
} elseif (Test-Path (Join-Path $scriptDir "app\pubspec.yaml")) {
    $appDir = (Resolve-Path (Join-Path $scriptDir "app")).Path
} else {
    $appDir = (Get-Location).Path
}

# Create temporary log file in the system temp directory
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$tempLog = Join-Path ([System.IO.Path]::GetTempPath()) "flutter_edge_$timestamp.log"
New-Item -ItemType File -Path $tempLog -Force | Out-Null

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host " Starting Flutter app on device: Edge" -ForegroundColor Cyan
Write-Host " Working Directory: $appDir" -ForegroundColor Cyan
Write-Host " Temp Log File:     $tempLog" -ForegroundColor Yellow
Write-Host "==================================================" -ForegroundColor Cyan

Set-Location $appDir
try {
    # Run flutter run -d Edge, streaming output to both terminal and temp log file
    flutter run -d Edge $args 2>&1 | Tee-Object -FilePath $tempLog
} finally {
    Write-Host "`nLogs saved to: $tempLog" -ForegroundColor Green
}
