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

local windows = require("windows")


-- Create the main config table and merge settings from modules
local config = {}

-- Merge appearance settings
for k, v in pairs(appearance) do
    config[k] = v
end

-- Set leader and keys from keybindings module
config.leader = keybindings.leader
config.keys = keybindings.keys

-- Load windows only configs --
if is_windows() then
    windows.apply_to_config(config)
end

-- Sets up wuake mode
local mux = wezterm.mux
local act = wezterm.action

local scratch = "_scratch" -- Keep this consistent with Hammerspoon
wezterm.on("gui-attached", function(domain)
  local workspace = mux.get_active_workspace()
  if workspace ~= scratch then return end

  -- Compute width: 66% of screen width, up to 1000 px
  local width_ratio = 0.66
  local width_max = 1000
  local aspect_ratio = 16 / 9
  local screen = wezterm.gui.screens().active
  local width = math.min(screen.width * width_ratio, width_max)
  local height = width / aspect_ratio

  for _, window in ipairs(mux.all_windows()) do
    local gwin = window:gui_window()
    if gwin ~= nil then
      gwin:perform_action(act.SetWindowLevel "AlwaysOnTop", gwin:active_pane())
      gwin:set_inner_size(width, height)
    end
  end
end)
wezterm.on('format-window-title', function()
  local workspace = wezterm.mux.get_active_workspace()
  if workspace ~= scratch then return end
  return scratch
end)
return config
