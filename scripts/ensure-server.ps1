param(
    [int]$Port = 17890
)

$Root = Split-Path -Parent $PSScriptRoot
$servePs1 = Join-Path $PSScriptRoot "serve.ps1"
$pidFile = Join-Path $Root ".server.pid"

function Test-ServerUp {
    try {
        $null = Invoke-WebRequest -Uri "http://127.0.0.1:$Port/priority.html" -UseBasicParsing -TimeoutSec 2
        return $true
    } catch {
        return $false
    }
}

if (Test-ServerUp) { exit 0 }

if (Test-Path $pidFile) {
    $oldPid = Get-Content $pidFile -ErrorAction SilentlyContinue
    if ($oldPid -and (Get-Process -Id $oldPid -ErrorAction SilentlyContinue)) {
        for ($i = 0; $i -lt 15; $i++) {
            Start-Sleep -Milliseconds 300
            if (Test-ServerUp) { exit 0 }
        }
    }
}

$p = Start-Process powershell.exe -PassThru -WindowStyle Hidden -ArgumentList @(
    "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "`"$servePs1`"", "-Port", $Port
)
Set-Content -Path $pidFile -Value $p.Id -Encoding ASCII

for ($i = 0; $i -lt 25; $i++) {
    Start-Sleep -Milliseconds 300
    if (Test-ServerUp) { exit 0 }
}

Write-Host "ERROR: local server failed to start on port $Port" -ForegroundColor Red
exit 1
