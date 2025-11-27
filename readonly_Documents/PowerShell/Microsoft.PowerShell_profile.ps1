# ---t sheet how Environment Variables ---
$Env:KOMOREBI_CONFIG_HOME = 'C:\Users\barbo\.config\komorebi'
$Env:YAZI_FILE_ONE = 'C:\Users\barbo\scoop\apps\git\current\usr\bin\file.exe'

# --- FZF Configuration (Hidden Files & Speed) ---
# Requires 'fd' installed (scoop install fd)
$env:FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git'
$env:FZF_CTRL_T_COMMAND  = $env:FZF_DEFAULT_COMMAND
$env:FZF_ALT_C_COMMAND   = 'fd --type d --hidden --follow --exclude .git'

# --- Yazi Wrapper Function ---
function y {
    $tmp = (New-TemporaryFile).FullName
    try {
        yazi $args --cwd-file="$tmp"
        $cwd = Get-Content -Path $tmp -Encoding UTF8
        if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
            Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
        }
    }
    finally {
        if (Test-Path $tmp) { Remove-Item -Path $tmp }
    }
}

# --- 1. Starship ---
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (starship init powershell)
}

# --- 2. Modules ---
Import-Module PSReadLine
Import-Module Terminal-Icons
Import-Module PSFzf

# --- 3. PSReadLine (Vi Mode) ---
Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -Colors @{
    InlinePrediction = "$([char]0x1b)[38;5;238m"
}
Set-PSReadLineKeyHandler -Chord 'Ctrl+RightArrow' -Function AcceptNextSuggestionWord

# --- 4. FZF Bindings ---
# We use Set-PsFzfOption to handle the bindings.
# It internally creates the correct ScriptBlocks for us.
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+h'

# Alt+c: Fuzzy Directory Change (cd)
# This uses -ScriptBlock, which is the correct syntax for custom commands
Set-PSReadLineKeyHandler -Key 'Alt+c' -ScriptBlock { Invoke-FzfSetLocation }

# --- 5. Zoxide ---
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (zoxide init powershell | Out-String)
}

# --- 6. Aliases ---
Set-Alias vim nvim
Set-Alias ll ls

# --- 7. Terminal Icons Theme ---
$ThemePath = "$HOME\.config\ps\gruvbox-light.psd1"

if (Test-Path $ThemePath) {
    Add-TerminalIconsColorTheme -Path $ThemePath
    Set-TerminalIconsTheme -ColorTheme GruvboxLight
} else {
    Write-Host "Warning: Icon theme not found at $ThemePath" -ForegroundColor Red
}
fnm env --use-on-cd | Out-String | Invoke-Expression

function tldr {
    & tldr.exe -s @Args
}
