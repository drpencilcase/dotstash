-- I am helpers.lua and I should live in ~/.config/wezterm/helpers.lua

local wezterm = require 'wezterm'

-- This is the module table that we will export
local module = {}

-- This function is private to this module and is not visible
-- outside.
-- local function private_helper()
-- wezterm.log_error 'hello!'
-- end

-- define a function in the module table.
-- Only functions defined in `module` will be exported to
-- code that imports this module.
-- The suggested convention for making modules that update
-- the config is for them to export an `apply_to_config`
-- function that accepts the config object, like this:
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
    config.keys = {
        key = 'c',
        mods = MOD, -- Thumb + C
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
    }
end

-- return our module table
return module
