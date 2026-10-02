<# : batch launcher - the PowerShell part below does the work
@echo off
setlocal
set "SELF=%~f0"
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex (Get-Content -LiteralPath $env:SELF -Raw)"
set "CODE=%ERRORLEVEL%"
echo.
pause
exit /b %CODE%
#>

# Installs the "Free Web Viewer" PowerPoint add-in for the current Windows user.
$ErrorActionPreference = 'Stop'
$AddinId     = '2f8a8adb-3968-4b6d-bf5f-5a883fc37e3e'
$ManifestUrl = 'https://waitholdthis.github.io/embed_3D_Tour_Powerpoint/addin/manifest.xml'
$InstallDir  = Join-Path $env:LOCALAPPDATA 'FreeWebViewer'
$Manifest    = Join-Path $InstallDir 'manifest.xml'
$RegKey      = 'HKCU:\Software\Microsoft\Office\16.0\WEF\Developer'

try {
    Write-Host 'Installing Free Web Viewer for PowerPoint...'

    if (-not (Test-Path $InstallDir)) { New-Item -ItemType Directory -Path $InstallDir | Out-Null }

    Write-Host '  Downloading add-in manifest...'
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -UseBasicParsing -Uri $ManifestUrl -OutFile $Manifest

    $xml = [xml](Get-Content -LiteralPath $Manifest -Raw)
    if ($xml.OfficeApp.Id -ne $AddinId) { throw 'Downloaded manifest does not match this add-in.' }

    Write-Host '  Registering with PowerPoint...'
    if (-not (Test-Path $RegKey)) { New-Item -Path $RegKey -Force | Out-Null }
    Set-ItemProperty -Path $RegKey -Name $AddinId -Value $Manifest

    Write-Host ''
    Write-Host 'Done!' -ForegroundColor Green
    if (Get-Process -Name POWERPNT -ErrorAction SilentlyContinue) {
        Write-Host 'PowerPoint is open - close it completely and reopen it first.' -ForegroundColor Yellow
    }
    Write-Host 'In PowerPoint: Home > Add-ins > More Add-ins > My Add-ins > Developer Add-ins > Free Web Viewer'
    exit 0
}
catch {
    Write-Host ''
    Write-Host "Install failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host 'Check the internet connection and try again.'
    exit 1
}
