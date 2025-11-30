# run_once_install_packages.ps1

# --- 1. SCOOP SETUP ---
Write-Host "Checking for Scoop..."
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}

Write-Host "Adding Scoop Buckets..."
scoop bucket add extras
scoop bucket add nerd-fonts

Write-Host "Installing Scoop Packages..."
$scoopApps = @(
    "7zip", "chezmoi", "fd", "ffmpeg", "fzf", "git", "innounp", "jq",
    "mingw", "poppler", "ripgrep", "scoop-search", "tldr", "topgrade", "zoxide",
    "1password-cli", "resvg",
    "komorebi", "yasb", "komokana",
    "fnm", "rustup",
    "starship", "yazi", "PSFzf",
    "firacode-NF", "FiraCode-NF-Propo",
    "JetBrainsMono-NF", "JetBrainsMono-NF-Propo",
    "monaspace-NF", "MPlus-NF-Propo", "font-awesome"
)
scoop install $scoopApps

# --- 2. WINGET SETUP ---
Write-Host "Installing GUI Apps via Winget..."
$wingetApps = @(
    "Vivaldi.Vivaldi",
    "Microsoft.WindowsTerminal", "wez.wezterm", "Warp.Warp", "ZedIndustries.Zed",
    "Obsidian.Obsidian", "Microsoft.WindowsNotepad", "Microsoft.PowerShell",
    "AgileBits.1Password", "ShareX.ShareX", "RamenSoftware.Windhawk",
    "RevoUninstaller.RevoUninstallerPro", "johnsadventures.JohnsBackgroundSwitcher",
    "UniGetUI", "OpenWhisperSystems.Signal", "Vencord.Vesktop",
    "Raycast.Raycast", "AquaVoice.AquaVoice"
)

foreach ($app in $wingetApps) {
    winget install --id $app -e --source winget --accept-package-agreements --accept-source-agreements --force
}

# --- 3. WPM SETUP (Process Manager) ---
# WPM is not on crates.io yet, so we install from the official Git repo
Write-Host "Installing WPM (Window Process Manager)..."
if (Get-Command cargo -ErrorAction SilentlyContinue) {
    cargo install --git https://github.com/LGUG2Z/wpm wpmd
    cargo install --git https://github.com/LGUG2Z/wpm wpmctl
}

Write-Host "Installation Complete!"
