param(
    [string]$TaskName = "InternToolkit-DailyBrowser"
)

Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue
Write-Host "OK: removed $TaskName" -ForegroundColor Green
