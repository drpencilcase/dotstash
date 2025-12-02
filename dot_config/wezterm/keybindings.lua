-- /Users/barbo/.config/wezterm/keybindings.lua
local wezterm = require 'wezterm'
local act = wezterm.action

-- 1. Define Modifiers based on OS
-- On Mac, Thumb is CMD. On Windows, your Kanata setup makes Thumb send CTRL.
local THUMB = is_darwin() and 'CMD' or 'CTRL'

local leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
local keys = {
    -- COMMAND PALETTE (Keep your existing binding)
    { key = 'k',  mods = THUMB,    action = act.ActivateCommandPalette },

    -- DEBUG OVERLAY
    { key = 'd',  mods = 'LEADER', action = act.ShowDebugOverlay },

    -- RELOAD CONFIG
    { key = 'r',  mods = 'LEADER', action = act.ReloadConfiguration },

    { key = '-',  mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = '\\', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },

    -- PANES: Navigation (Vim style)
    { key = 'h',  mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
    { key = 'j',  mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
    { key = 'k',  mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
    { key = 'l',  mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },

    -- PANES: Close
    { key = 'w',  mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },

    -- PANES: Zoom (Toggle Maximize)
    { key = 'z',  mods = 'LEADER', action = act.TogglePaneZoomState },
}

return {
    leader = leader,
    keys = keys,
}
