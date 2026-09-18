param(
    [Parameter(Mandatory = $true)][string]$Root
)

$info = @{
    installedAt = (Get-Date).ToString("o")
    root = $Root
    port = 17890
    version = "1.0.0"
} | ConvertTo-Json

Set-Content -Path (Join-Path $Root ".installed.json") -Value $info -Encoding UTF8
Write-Host "OK: wrote .installed.json"
