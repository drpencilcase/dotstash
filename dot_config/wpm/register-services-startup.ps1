# Register WPM services to start automatically after wpmd is ready
# Run this script once to set up automatic service startup

$TaskName = "WPM-Start-Services"
$WpmctlPath = (Get-Command wpmctl.exe -ErrorAction SilentlyContinue).Source
$StartServicesScript = Join-Path $env:USERPROFILE ".config\wpm\start-services.ps1"

if (-not $WpmctlPath) {
    Write-Host "ERROR: wpmctl.exe not found in PATH" -ForegroundColor Red
    Write-Host "Please ensure wpm is installed and in your PATH" -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Path $StartServicesScript)) {
    Write-Host "ERROR: start-services.ps1 not found at $StartServicesScript" -ForegroundColor Red
    exit 1
}

Write-Host "Found wpmctl at: $WpmctlPath" -ForegroundColor Green
Write-Host "Found start-services script at: $StartServicesScript" -ForegroundColor Green

# Remove existing task if it exists
$existingTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
if ($existingTask) {
    Write-Host "Removing existing task..." -ForegroundColor Yellow
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
}

# Create the action to run start-services.ps1
$Action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File `"$StartServicesScript`""

# Create the trigger to run at logon (with a 10 second delay to let wpmd start)
$Trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
$Trigger.Delay = "PT10S"  # 10 second delay

# Create settings for the task
$Settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 5)

# Register the task
Register-ScheduledTask `
    -TaskName $TaskName `
    -Action $Action `
    -Trigger $Trigger `
    -Settings $Settings `
    -Description "Starts WPM services (kanata, komorebi, komokana) after wpmd is ready" `
    -User $env:USERNAME `
    -RunLevel Limited

Write-Host "`nTask registered successfully!" -ForegroundColor Green
Write-Host "`nYour services will now start automatically 10 seconds after you log in." -ForegroundColor Cyan
Write-Host "`nSetup complete! Your login startup sequence will be:" -ForegroundColor Yellow
Write-Host "  1. wpmd starts (WPM daemon)" -ForegroundColor White
Write-Host "  2. [10 second delay]" -ForegroundColor Gray
Write-Host "  3. Services start: kanata → komorebi → komokana" -ForegroundColor White
Write-Host "`nTo test now, run: Start-ScheduledTask -TaskName '$TaskName'" -ForegroundColor Cyan
Write-Host "To disable: Disable-ScheduledTask -TaskName '$TaskName'" -ForegroundColor Gray
Write-Host "To remove: Unregister-ScheduledTask -TaskName '$TaskName' -Confirm:`$false" -ForegroundColor Gray
