[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$layer = (Get-Content "$env:LOCALAPPDATA\Temp\kanata_layer" -ErrorAction SilentlyContinue).Trim()

$icons = @{
    'main' = [char]0xf11c
    'extended' = ([char]0xdb82).ToString() + ([char]0xddfa).ToString()
    'launcher' = [char]0xeb44
    'window_c' = [char]0xebeb
    'window_cs' = [char]0xeae3
}

$icon = $icons[$layer]

if ($icon) {
    Write-Output "$icon $layer"
} else {
    Write-Output $layer
}
