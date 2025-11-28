# Start WPM services after wpmd is ready
# This script waits for wpmd to be ready, then starts your services

$MaxRetries = 30
$RetryDelay = 2

Write-Host "Waiting for wpmd to be ready..." -ForegroundColor Cyan

# Wait for wpmd to be responsive
for ($i = 1; $i -le $MaxRetries; $i++) {
    try {
        $state = wpmctl state 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "wpmd is ready!" -ForegroundColor Green
            break
        }
    } catch {
        # wpmctl not ready yet
    }

    if ($i -eq $MaxRetries) {
        Write-Host "ERROR: wpmd did not become ready in time" -ForegroundColor Red
        exit 1
    }

    Write-Host "Attempt $i/$MaxRetries - waiting ${RetryDelay}s..." -ForegroundColor Yellow
    Start-Sleep -Seconds $RetryDelay
}

# Start your services
Write-Host "`nStarting services..." -ForegroundColor Cyan

# Option 1: Start all services via desktop unit
wpmctl start desktop

# Option 2: Start komokana (which will start its dependencies)
# wpmctl start komokana

if ($LASTEXITCODE -eq 0) {
    Write-Host "Services started successfully!" -ForegroundColor Green

    # Show the current state
    Write-Host "`nCurrent state:" -ForegroundColor Cyan
    wpmctl state
} else {
    Write-Host "ERROR: Failed to start services" -ForegroundColor Red
    exit 1
}
