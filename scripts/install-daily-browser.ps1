param(
    [Parameter(Mandatory = $true)][string]$BatPath,
    [string]$TaskName = "InternToolkit-DailyBrowser",
    [int]$DelaySec = 30
)

if (-not (Test-Path $BatPath)) {
    Write-Host "ERROR: script not found: $BatPath" -ForegroundColor Red
    exit 1
}

Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue

$action = New-ScheduledTaskAction -Execute $BatPath
$trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
$trigger.Delay = "PT${DelaySec}S"
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -ExecutionTimeLimit (New-TimeSpan -Hours 1)

Register-ScheduledTask `
    -TaskName $TaskName `
    -Action $action `
    -Trigger $trigger `
    -Settings $settings `
    -Description "InternToolkit: open priority tool after logon" | Out-Null

$task = Get-ScheduledTask -TaskName $TaskName
Write-Host "OK: $($task.TaskName) [$($task.State)]" -ForegroundColor Green
