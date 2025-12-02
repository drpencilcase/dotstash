-- /Users/barbo/.config/wezterm/keybindings.lua
local wezterm = require 'wezterm'
local act = wezterm.action

local THUMB = is_darwin() and 'CMD' or 'CTRL'
local PINKY = is_darwin() and 'CTRL' or 'SUPER'

local leader = { key = 'Space', mods = PINKY, timeout_milliseconds = 1000 }

local keys = {
    -- ============================================================================
    -- COMMAND PALETTE & DEBUG
    -- ============================================================================
    { key = 'k', mods = THUMB,    action = act.ActivateCommandPalette },
    { key = 'd', mods = 'LEADER', action = act.ShowDebugOverlay },
    { key = 'r', mods = 'LEADER', action = act.ReloadConfiguration },

    -- ============================================================================
    -- TABS: Management
    -- ============================================================================
    { key = 't', mods = THUMB,    action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 'w', mods = THUMB,    action = act.CloseCurrentTab { confirm = true } },
    {
        key = ',',
        mods = 'LEADER',
        action = act.PromptInputLine {
            description = 'Enter new name for tab',
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        }
    },

    -- TABS: Navigation
    { key = '[',          mods = THUMB,             action = act.ActivateTabRelative(-1) },
    { key = ']',          mods = THUMB,             action = act.ActivateTabRelative(1) },
    { key = '1',          mods = THUMB,             action = act.ActivateTab(0) },
    { key = '2',          mods = THUMB,             action = act.ActivateTab(1) },
    { key = '3',          mods = THUMB,             action = act.ActivateTab(2) },
    { key = '4',          mods = THUMB,             action = act.ActivateTab(3) },
    { key = '5',          mods = THUMB,             action = act.ActivateTab(4) },
    { key = '6',          mods = THUMB,             action = act.ActivateTab(5) },
    { key = '7',          mods = THUMB,             action = act.ActivateTab(6) },
    { key = '8',          mods = THUMB,             action = act.ActivateTab(7) },
    { key = '9',          mods = THUMB,             action = act.ActivateTab(-1) }, -- Last tab

    -- TABS: Move (reorder)
    { key = '{',          mods = THUMB .. '|SHIFT', action = act.MoveTabRelative(-1) },
    { key = '}',          mods = THUMB .. '|SHIFT', action = act.MoveTabRelative(1) },

    -- ============================================================================
    -- PANES: Split
    -- ============================================================================
    { key = '-',          mods = 'LEADER',          action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = '\\',         mods = 'LEADER',          action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },

    -- PANES: Navigation (Vim style)
    { key = 'h',          mods = 'LEADER',          action = act.ActivatePaneDirection 'Left' },
    { key = 'j',          mods = 'LEADER',          action = act.ActivatePaneDirection 'Down' },
    { key = 'k',          mods = 'LEADER',          action = act.ActivatePaneDirection 'Up' },
    { key = 'l',          mods = 'LEADER',          action = act.ActivatePaneDirection 'Right' },

    -- PANES: Navigation (Arrow keys)
    { key = 'LeftArrow',  mods = THUMB,             action = act.ActivatePaneDirection 'Left' },
    { key = 'RightArrow', mods = THUMB,             action = act.ActivatePaneDirection 'Right' },
    { key = 'UpArrow',    mods = THUMB,             action = act.ActivatePaneDirection 'Up' },
    { key = 'DownArrow',  mods = THUMB,             action = act.ActivatePaneDirection 'Down' },


    -- PANES: Resize (Arrow keys)
    { key = 'LeftArrow',  mods = 'LEADER',          action = act.AdjustPaneSize { 'Left', 5 } },
    { key = 'RightArrow', mods = 'LEADER',          action = act.AdjustPaneSize { 'Right', 5 } },
    { key = 'UpArrow',    mods = 'LEADER',          action = act.AdjustPaneSize { 'Up', 5 } },
    { key = 'DownArrow',  mods = 'LEADER',          action = act.AdjustPaneSize { 'Down', 5 } },

    -- PANES: Close & Zoom
    { key = 'x',          mods = 'LEADER',          action = act.CloseCurrentPane { confirm = true } },
    { key = 'z',          mods = 'LEADER',          action = act.TogglePaneZoomState },

    -- PANES: Rotate & Swap
    { key = 'o',          mods = 'LEADER',          action = act.RotatePanes 'Clockwise' },
    { key = 's',          mods = 'LEADER',          action = act.PaneSelect { mode = 'SwapWithActive' } },

    -- ============================================================================
    -- COPY MODE & SCROLLBACK
    -- ============================================================================
    { key = 'c',          mods = 'LEADER',          action = act.ActivateCopyMode },
    { key = 'Enter',      mods = 'LEADER',          action = act.ActivateCopyMode },
    { key = 'PageUp',     mods = 'SHIFT',           action = act.ScrollByPage(-1) },
    { key = 'PageDown',   mods = 'SHIFT',           action = act.ScrollByPage(1) },
    { key = 'u',          mods = PINKY,             action = act.ScrollByPage(-0.5) },
    { key = 'd',          mods = PINKY,             action = act.ScrollByPage(0.5) },

    -- ============================================================================
    -- SEARCH
    -- ============================================================================
    { key = 'f',          mods = THUMB,             action = act.Search { CaseSensitiveString = '' } },
    { key = 'f',          mods = 'LEADER',          action = act.Search { CaseSensitiveString = '' } },

    -- ============================================================================
    -- FONT SIZE
    -- ============================================================================
    { key = '=',          mods = THUMB,             action = act.IncreaseFontSize },
    { key = '-',          mods = THUMB,             action = act.DecreaseFontSize },
    { key = '0',          mods = THUMB,             action = act.ResetFontSize },

    -- ============================================================================
    -- QUICK SELECT (URLs, file paths, hashes, etc)
    -- ============================================================================
    {
        key = 'Space',
        mods = 'LEADER',
        action = act.QuickSelect
    },

    -- ============================================================================
    -- WORKSPACES
    -- ============================================================================
    { key = 'w',     mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },
    {
        key = 'S',
        mods = 'LEADER|SHIFT',
        action = act.PromptInputLine {
            description = 'Enter name for new workspace',
            action = wezterm.action_callback(function(window, pane, line)
                if line then
                    window:perform_action(
                        act.SwitchToWorkspace {
                            name = line,
                        },
                        pane
                    )
                end
            end),
        }
    },

    -- ============================================================================
    -- LAUNCHER & MENU
    -- ============================================================================
    { key = 'l',     mods = THUMB,    action = act.ShowLauncher },

    -- ============================================================================
    -- CLIPBOARD
    -- ============================================================================
    { key = 'c',     mods = THUMB,    action = act.CopyTo 'Clipboard' },
    { key = 'v',     mods = THUMB,    action = act.PasteFrom 'Clipboard' },
    { key = 'Copy',  mods = 'NONE',   action = act.CopyTo 'Clipboard' },
    { key = 'Paste', mods = 'NONE',   action = act.PasteFrom 'Clipboard' },

    -- ============================================================================
    -- MISC
    -- ============================================================================
    { key = 'Enter', mods = THUMB,    action = act.ToggleFullScreen },
    { key = 'q',     mods = THUMB,    action = act.QuitApplication },
}

return {
    leader = leader,
    keys = keys,
}
