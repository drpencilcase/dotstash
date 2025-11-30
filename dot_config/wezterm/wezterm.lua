local wezterm = require("wezterm")

-- Globally defined OS detection functions to be used across config files.
is_linux = function()
    return wezterm.target_triple:find("linux") ~= nil
end

is_darwin = function()
    return wezterm.target_triple:find("darwin") ~= nil
end

is_windows = function()
    return wezterm.target_triple:find("windows") ~= nil
end

-- Load modularized configuration
local keybindings = require("keybindings")
local appearance = require("appearance")

-- Create the main config table and merge settings from modules
local config = {
}
for k, v in pairs(appearance) do
    config[k] = v
end
config.keys = keybindings.keys

return config
