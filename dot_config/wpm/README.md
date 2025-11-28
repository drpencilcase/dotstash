# WPM (Windows Process Manager) Setup Guide

## Table of Contents
- [What is WPM?](#what-is-wpm)
- [Current Configuration](#current-configuration)
- [Dependency Chain](#dependency-chain)
- [Installation & Testing](#installation--testing)
- [Auto-Start on Login](#auto-start-on-login)
- [Common Commands](#common-commands)
- [Troubleshooting](#troubleshooting)

---

## What is WPM?

**WPM** is a systemd-inspired process manager for Windows 11+ created by LGUG2Z. It manages user-level background processes through JSON unit files, allowing you to:

- Define service dependencies
- Configure healthchecks
- Set up lifecycle hooks
- Manage restart policies
- Control process startup order

### Components

- **`wpmd`** - The daemon that manages processes
- **`wpmctl`** - The control tool to interact with the daemon

---

## Current Configuration

Your setup includes 4 unit files in `~/.config/wpm/`:

### 1. `kanata.json` - Keyboard Remapper
- **Type**: Simple
- **Dependencies**: None (base service)
- **Port**: 4567
- **Healthcheck**: Process-based (checks after 1s)
- **Restart Policy**: Never
- **Config**: `~/.config/kanata/windows.kbd`

### 2. `komorebi.json` - Tiling Window Manager
- **Type**: Simple
- **Dependencies**: kanata
- **Healthcheck**: Command-based (`komorebic state` after 1s)
- **Restart Policy**: Never
- **Config**: `~/.config/komorebi/komorebi.json`
- **Lifecycle Hooks**:
  - `ExecStartPre`: `komorebic fetch-asc`
  - `ExecStop`: `komorebic stop`
  - `ExecStopPost`: `komorebic restore-windows`

### 3. `komokana.json` - Application-Aware Layer Switcher
- **Type**: Simple
- **Dependencies**: komorebi AND kanata
- **Healthcheck**: Process-based (after 1s)
- **Restart Policy**: OnFailure (every 2 seconds)
- **Config**: `~/.config/komokana/config.yaml`

### 4. `desktop.json` - Meta Unit
- **Type**: Oneshot (runs once and completes)
- **Dependencies**: komorebi
- **Purpose**: Ensures komorebi stack is running, then displays completion message

---

## Dependency Chain

```
┌─────────┐
│ kanata  │ ← Starts first (no dependencies)
└────┬────┘
     │
     │ requires
     ↓
┌─────────┐
│komorebi │ ← Starts second (needs kanata)
└────┬────┘
     │
     │ requires (both)
     ↓
┌──────────┐
│ komokana │ ← Starts third (needs both)
└──────────┘
```

---

## Installation & Testing

### Prerequisites

Ensure you have `wpmd` and `wpmctl` installed:

```powershell
# Check if installed
wpmd --version
wpmctl --version
```

### Testing the Setup

#### Step 1: Start the Daemon

Open a terminal and run:

```powershell
wpmd
```

Leave this terminal open - it will show daemon logs.

#### Step 2: Check Loaded Units

In a **new terminal**, verify all units are loaded:

```powershell
wpmctl state
```

Expected output shows all units with their current state.

#### Step 3: Start Services

```powershell
# Option 1: Start komokana (auto-starts dependencies)
wpmctl start komokana

# Option 2: Start via desktop meta-unit
wpmctl start desktop
```

#### Step 4: Verify Everything is Running

```powershell
# View all services status
wpmctl state

# Check detailed status of specific service
wpmctl status kanata
wpmctl status komorebi
wpmctl status komokana

# View logs
wpmctl log kanata
wpmctl log komorebi
wpmctl log komokana
```

Expected output: All services showing **"Running"** state with PIDs.

#### Step 5: Test Stopping

```powershell
# Stop a service
wpmctl stop komokana

# Verify it stopped
wpmctl state
```

---

## Auto-Start on Login

To make WPM start automatically when you log into Windows, use the provided PowerShell scripts.

### Setup Instructions

#### Step 1: Register wpmd to Start at Login

```powershell
cd $HOME\.config\wpm
.\register-startup.ps1
```

This creates a scheduled task that:
- ✅ Runs `wpmd` when you log in **hidden in the background** (no terminal window)
- ✅ Auto-restarts if it crashes (up to 3 times)
- ✅ Works on battery power (laptops)
- ✅ Won't terminate when you close terminal windows

#### Step 2: Register Services to Auto-Start

```powershell
cd $HOME\.config\wpm
.\register-services-startup.ps1
```

This creates a second scheduled task that:
- ✅ Waits 10 seconds for `wpmd` to be ready
- ✅ Starts your services automatically
- ✅ Times out after 5 minutes if something goes wrong

### What Happens at Login

1. **You log in** → Windows Task Scheduler starts
2. **Immediately** → `wpmd` starts **hidden in background** (WPM daemon loads all unit files)
3. **10 seconds later** → Script checks if `wpmd` is ready
4. **Once ready** → Runs `wpmctl start komokana`
5. **Dependencies cascade** → kanata → komorebi → komokana all start in order

**Note**: Everything runs headless (no visible windows), but you can still control services with `wpmctl` commands.

### Testing Auto-Start (Without Logging Out)

```powershell
# Test wpmd startup
Start-ScheduledTask -TaskName "WPM-Startup"
Start-Sleep -Seconds 5

# Test services startup
Start-ScheduledTask -TaskName "WPM-Start-Services"

# Check status
wpmctl state
```

### Managing Auto-Start Tasks

#### Disable (Keep Tasks, Don't Run)

```powershell
Disable-ScheduledTask -TaskName "WPM-Startup"
Disable-ScheduledTask -TaskName "WPM-Start-Services"
```

#### Re-Enable

```powershell
Enable-ScheduledTask -TaskName "WPM-Startup"
Enable-ScheduledTask -TaskName "WPM-Start-Services"
```

#### Remove Completely

```powershell
Unregister-ScheduledTask -TaskName "WPM-Startup" -Confirm:$false
Unregister-ScheduledTask -TaskName "WPM-Start-Services" -Confirm:$false
```

---

## Common Commands

### Daemon Management

```powershell
# Start daemon manually (headless/hidden)
Start-ScheduledTask -TaskName "WPM-Startup"

# Or start with visible window (for debugging)
wpmd

# Check if daemon is running
wpmctl state

# Stop daemon
Stop-Process -Name wpmd -Force

# Or stop via task scheduler
Stop-ScheduledTask -TaskName "WPM-Startup"
```

**Note**: When using the auto-start setup, `wpmd` runs hidden in the background. You don't need to keep a terminal window open.

### Service Control

```powershell
# Start a service (auto-starts dependencies)
wpmctl start <service-name>
wpmctl start komokana

# Start via meta-unit
wpmctl start desktop

# Stop a service
wpmctl stop <service-name>
wpmctl stop komokana

# Restart a service
wpmctl stop <service-name>
wpmctl start <service-name>
```

### Monitoring

```powershell
# View all units and their states
wpmctl state

# View detailed status of a specific unit
wpmctl status <service-name>
wpmctl status kanata

# View real-time logs
wpmctl log <service-name>
wpmctl log komorebi

# View all logs
wpmctl log kanata
wpmctl log komorebi
wpmctl log komokana
```

### Configuration Management

```powershell
# Reload all unit files (after editing .json files)
wpmctl reload

# Rebuild (reinstall manifests if using package versions)
wpmctl rebuild
```

---

## Troubleshooting

### Service Won't Start

1. **Check if wpmd is running:**
   ```powershell
   wpmctl state
   ```
   If you get an error, start `wpmd`:
   ```powershell
   Start-ScheduledTask -TaskName "WPM-Startup"
   # Or for debugging with visible output:
   wpmd
   ```

2. **Check the logs:**
   ```powershell
   wpmctl log <service-name>
   ```
   Look for error messages.

3. **Verify executables are in PATH:**
   ```powershell
   Get-Command kanata.exe
   Get-Command komorebi.exe
   Get-Command komokana.exe
   ```

4. **Check configuration files exist:**
   ```powershell
   Test-Path ~/.config/kanata/windows.kbd
   Test-Path ~/.config/komorebi/komorebi.json
   Test-Path ~/.config/komokana/config.yaml
   ```

### Dependencies Not Starting

- Services with dependencies will automatically start their required services
- Check `wpmctl state` to see which services are running
- If a dependency fails, the dependent service won't start

### Auto-Start Not Working

1. **Verify tasks are registered:**
   ```powershell
   Get-ScheduledTask -TaskName "WPM-Startup"
   Get-ScheduledTask -TaskName "WPM-Start-Services"
   ```

2. **Check task history:**
   - Open Task Scheduler (`Win + R`, type `taskschd.msc`)
   - Navigate to Task Scheduler Library
   - Find "WPM-Startup" and "WPM-Start-Services"
   - Check the History tab

3. **Manually run tasks to test:**
   ```powershell
   Start-ScheduledTask -TaskName "WPM-Startup"
   Start-Sleep -Seconds 5
   Start-ScheduledTask -TaskName "WPM-Start-Services"
   ```

### After Editing Unit Files

Always reload after making changes:

```powershell
wpmctl reload
```

Then restart affected services:

```powershell
wpmctl stop <service-name>
wpmctl start <service-name>
```

---

## File Locations

- **Unit Files**: `~/.config/wpm/*.json`
- **Logs**: `~/.config/wpm/logs/*.log`
- **Startup Scripts**: `~/.config/wpm/*.ps1`
- **Service Configs**:
  - Kanata: `~/.config/kanata/windows.kbd`
  - Komorebi: `~/.config/komorebi/komorebi.json`
  - Komokana: `~/.config/komokana/config.yaml`

---

## Quick Reference

```powershell
# Essential Commands
Start-ScheduledTask -TaskName "WPM-Startup"  # Start daemon (headless)
wpmd                          # Start daemon (visible, for debugging)
wpmctl state                  # View all services
wpmctl start komokana         # Start services
wpmctl stop komokana          # Stop services
wpmctl status <service>       # Detailed status
wpmctl log <service>          # View logs
wpmctl reload                 # Reload config files
Stop-Process -Name wpmd -Force  # Stop daemon

# Setup Auto-Start
.\register-startup.ps1        # Register wpmd startup (headless)
.\register-services-startup.ps1   # Register services startup

# Test Auto-Start
Start-ScheduledTask -TaskName "WPM-Startup"
Start-ScheduledTask -TaskName "WPM-Start-Services"
```

---

## Adding New Services (e.g., YASB)

To add YASB or any other service later:

1. Create a new unit file: `~/.config/wpm/yasb.json`
2. Define the service structure (see existing files as examples)
3. Add dependencies if needed (e.g., `"Requires": ["komorebi"]`)
4. Reload: `wpmctl reload`
5. Start: `wpmctl start yasb`
6. Update `start-services.ps1` to include the new service if needed

---

## Resources

- **WPM Documentation**: https://lgug2z.github.io/wpm/
- **WPM GitHub**: https://github.com/LGUG2Z/wpm
- **Discord Community**: https://discord.gg/mGkn66PHkx
- **Schema Reference**: https://raw.githubusercontent.com/LGUG2Z/wpm/refs/heads/master/schema.unit.json

---

**Last Updated**: 2024
**Configuration Version**: Using locally installed executables (no package management)