-- /Users/barbo/.config/wezterm/appearance.lua
-- Appearance settings for wezterm
local wezterm = require 'wezterm'

local function get_appearance()
    if wezterm.gui then
        return wezterm.gui.get_appearance()
    end
    return 'Dark'
end

local function scheme_for_appearance(appearance)
    if appearance:find 'Dark' then
        return 'Everforest Dark (Gogh)'
    else
        return 'EverforestLight (Gogh)'
    end
end

local appearance_config = {
    color_scheme = scheme_for_appearance(get_appearance()),
    use_fancy_tab_bar = true,
    hide_tab_bar_if_only_one_tab = true,
    window_decorations = 'RESIZE',
    window_frame = {
        font = wezterm.font { family = 'Roboto', weight = 'Bold' },
        font_size = 12.0,
        active_titlebar_bg = '#2A353C',
        inactive_titlebar_bg = '#2A353C',
    },
    window_background_opacity = 0.90,
    macos_window_background_blur = 5,
    font = wezterm.font("Monaspace Neon NF"),
    font_size = 14.0,
    line_height = 1.3,
    harfbuzz_features = { "calt", "liga", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08" },
    font_rules = {
        {
            intensity = "Normal",
            italic = true,
            font = wezterm.font("Monaspace Radon NF", { weight = "Regular" }),
        },
        {
            intensity = "Bold",
            italic = false,
            font = wezterm.font("Monaspace Neon NF", { weight = "ExtraBold" }),
        },
        {
            intensity = "Bold",
            italic = true,
            font = wezterm.font("Monaspace Radon NF", { weight = "ExtraBold" }),
        },
    },
}

if is_windows() then
    appearance_config.window_background_opacity = 0
    appearance_config.win32_system_backdrop = 'Mica'
end

return appearance_config
