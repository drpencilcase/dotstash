-- I am windows.lua and I should live in ~/.config/wezterm/windows.lua

local wezterm = require 'wezterm'
-- FIX: Define 'act' so we can use it inside the callback
local act = wezterm.action

-- This is the module table that we will export
local module = {}

function module.apply_to_config(config)
    config.default_prog = { "pwsh.exe" }

    config.launch_menu = {
        {
            label = "PowerShell 7",
            args = { "pwsh.exe" },
        },
        {
            label = "Git Bash",
            args = { "C:\\Program Files\\Git\\bin\\bash.exe", "-l" },
        },
        {
            label = "Windows PowerShell",
            args = { "powershell.exe" },
        },
        {
            label = "CMD",
            args = { "cmd.exe" },
        },
    }

    -- FIX: Ensure config.keys exists before we try to add to it
    if config.keys == nil then
        config.keys = {}
    end

    local MOD = 'CTRL'

    -- FIX: Use table.insert to append this keybinding instead of overwriting the whole list
    table.insert(config.keys, {
        key = 'c',
        mods = MOD, -- Uses the local variable defined above
        action = wezterm.action_callback(function(window, pane)
            local has_selection = window:get_selection_text_for_pane(pane) ~= ""
            if has_selection then
                window:perform_action(act.CopyTo 'ClipboardAndPrimarySelection', pane)
                window:perform_action(act.ClearSelection, pane)
            else
                -- Send the actual "Ctrl-C" keypress to the shell
                window:perform_action(act.SendKey { key = 'c', mods = 'CTRL' }, pane)
            end
        end),
    })
end

-- return our module table
return module
