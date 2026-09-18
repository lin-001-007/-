param(
    [Parameter(Mandatory = $true)][string]$TargetBat,
    [Parameter(Mandatory = $true)][string]$ShortcutName,
    [string]$Description = "InternToolkit"
)

$desktop = [Environment]::GetFolderPath("Desktop")
$lnk = Join-Path $desktop ($ShortcutName + ".lnk")
$dir = Split-Path -Parent $TargetBat

$shell = New-Object -ComObject WScript.Shell
$sc = $shell.CreateShortcut($lnk)
$sc.TargetPath = $TargetBat
$sc.WorkingDirectory = $dir
$sc.Description = $Description
$sc.Save()

Write-Host "OK: shortcut -> $lnk" -ForegroundColor Green
