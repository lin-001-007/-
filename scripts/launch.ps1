param(
    [int]$Port = 17890,
    [int]$DelaySec = 30,
    [switch]$Boot
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$installedFile = Join-Path $Root ".installed.json"
$ensurePs1 = Join-Path $PSScriptRoot "ensure-server.ps1"
$installPs1 = Join-Path $PSScriptRoot "install-daily-browser.ps1"
$shortcutPs1 = Join-Path $PSScriptRoot "create-shortcut.ps1"
$writeInstalledPs1 = Join-Path $PSScriptRoot "write-installed.ps1"
$launcherBat = Join-Path $Root "启动.bat"
$bootBat = Join-Path $PSScriptRoot "boot-open.bat"

function Start-LocalServer {
    & $ensurePs1 -Port $Port
    if ($LASTEXITCODE -ne 0) { throw "server start failed" }
}

function Open-App {
    param([string]$Page = "priority.html")
    Start-LocalServer
    Start-Process "http://127.0.0.1:$Port/$Page"
}

function Sync-Autostart {
    & $installPs1 -BatPath $bootBat -DelaySec $DelaySec | Out-Null
}

function Install-FirstRun {
    if (-not (Test-Path (Join-Path $Root "priority.html"))) {
        throw "missing priority.html"
    }
    Start-LocalServer
    & $shortcutPs1 -TargetBat $launcherBat -ShortcutName "InternToolkit" -Description "InternToolkit"
    Sync-Autostart
    & $writeInstalledPs1 -Root $Root | Out-Null
}

if ($Boot) {
    Open-App -Page "priority.html"
    $cfg = Join-Path $Root "config.ini"
    if (Test-Path $cfg) {
        $line = Get-Content $cfg | Where-Object { $_ -match '^\s*OPEN_GUIDE\s*=\s*1\s*$' }
        if ($line) {
            Start-Sleep -Seconds 2
            Open-App -Page "index.html"
        }
    }
    exit 0
}

if (-not (Test-Path $installedFile)) {
    Write-Host ""
    Write-Host "First run: auto setup..." -ForegroundColor Cyan
    Install-FirstRun
    Write-Host "Done: desktop shortcut + autostart registered." -ForegroundColor Green
    Write-Host ""
} else {
    Sync-Autostart
}

Open-App -Page "priority.html"
