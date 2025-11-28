# Register WPM to start at login using Windows Task Scheduler
# Run this script once to set up automatic startup

$TaskName = "WPM-Startup"
$WpmdPath = (Get-Command wpmd.exe -ErrorAction SilentlyContinue).Source
$WpmctlPath = (Get-Command wpmctl.exe -ErrorAction SilentlyContinue).Source

if (-not $WpmdPath) {
    Write-Host "ERROR: wpmd.exe not found in PATH" -ForegroundColor Red
    Write-Host "Please ensure wpm is installed and in your PATH" -ForegroundColor Yellow
    exit 1
}

Write-Host "Found wpmd at: $WpmdPath" -ForegroundColor Green
Write-Host "Found wpmctl at: $WpmctlPath" -ForegroundColor Green

# Remove existing task if it exists
$existingTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
if ($existingTask) {
    Write-Host "Removing existing task..." -ForegroundColor Yellow
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
}

# Create the action to run wpmd hidden (no console window)
$Action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command `"Start-Process -FilePath '$WpmdPath' -WindowStyle Hidden`""

# Create the trigger to run at logon
$Trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME

# Create settings for the task
$Settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RestartCount 3 `
    -RestartInterval (New-TimeSpan -Minutes 1)

# Register the task
Register-ScheduledTask `
    -TaskName $TaskName `
    -Action $Action `
    -Trigger $Trigger `
    -Settings $Settings `
    -Description "Starts WPM daemon (wpmd) at login to manage background processes" `
    -User $env:USERNAME `
    -RunLevel Limited

Write-Host "`nTask registered successfully!" -ForegroundColor Green
Write-Host "`nThe wpmd daemon will now start automatically when you log in." -ForegroundColor Cyan
Write-Host "`nTo start your services automatically after wpmd starts, you have two options:" -ForegroundColor Yellow
Write-Host "  1. Create another task that runs 'wpmctl start komokana' (or 'desktop') a few seconds after login" -ForegroundColor White
Write-Host "  2. Manually run 'wpmctl start komokana' after logging in" -ForegroundColor White
Write-Host "`nTo test now, run: Start-ScheduledTask -TaskName '$TaskName'" -ForegroundColor Cyan
Write-Host "To disable: Disable-ScheduledTask -TaskName '$TaskName'" -ForegroundColor Gray
Write-Host "To remove: Unregister-ScheduledTask -TaskName '$TaskName' -Confirm:`$false" -ForegroundColor Gray
