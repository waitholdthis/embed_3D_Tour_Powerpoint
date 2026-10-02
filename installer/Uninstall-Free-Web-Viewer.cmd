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

# Removes the "Free Web Viewer" PowerPoint add-in for the current Windows user.
$ErrorActionPreference = 'Stop'
$AddinId    = '2f8a8adb-3968-4b6d-bf5f-5a883fc37e3e'
$InstallDir = Join-Path $env:LOCALAPPDATA 'FreeWebViewer'
$RegKey     = 'HKCU:\Software\Microsoft\Office\16.0\WEF\Developer'

try {
    if ((Test-Path $RegKey) -and (Get-ItemProperty -Path $RegKey -Name $AddinId -ErrorAction SilentlyContinue)) {
        Remove-ItemProperty -Path $RegKey -Name $AddinId
    }
    if (Test-Path $InstallDir) { Remove-Item -LiteralPath $InstallDir -Recurse -Force }

    Write-Host 'Free Web Viewer has been removed.' -ForegroundColor Green
    Write-Host 'Restart PowerPoint for the change to take effect.'
    exit 0
}
catch {
    Write-Host "Uninstall failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
