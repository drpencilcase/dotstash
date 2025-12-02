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
        return 'Everforest Dark (Gogh)'
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
    warn_about_missing_glyphs = true,
    font_size = 14.0,
    line_height = 1.3,
    harfbuzz_features = { "calt", "liga", "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08" },
    font = wezterm.font_with_fallback {
        { -- Normal text - first option
            family = 'Monaspace Neon NF',
            harfbuzz_features = { 'calt', 'liga', 'dlig', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08' },
            stretch = 'UltraCondensed', -- This doesn't seem to do anything
        },
        {                               -- Normal text - fallback option
            family = 'MonaspiceNe NF',
            harfbuzz_features = { 'calt', 'liga', 'dlig', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08' },
            stretch = 'UltraCondensed', -- This doesn't seem to do anything
        },
    },

    font_rules = {
        { -- Italic
            intensity = 'Normal',
            italic = true,
            font = wezterm.font_with_fallback {
                {
                    family = 'Monaspace Xenon NF', -- courier-like
                    style = 'Italic',
                    harfbuzz_features = { 'calt', 'liga', 'dlig', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08' },
                },
                {
                    family = 'MonaspiceXe NF',
                    style = 'Italic',
                    harfbuzz_features = { 'calt', 'liga', 'dlig', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08' },
                },
            }
        },

        { -- Bold
            intensity = 'Bold',
            italic = false,
            font = wezterm.font_with_fallback {
                {
                    family = 'Monaspace Krypton NF',
                    weight = 'Bold',
                    harfbuzz_features = { 'calt', 'liga', 'dlig', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08' },
                },
                {
                    family = 'MonaspiceKr NF',
                    weight = 'Bold',
                    harfbuzz_features = { 'calt', 'liga', 'dlig', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08' },
                },
            }
        },

        { -- Bold Italic
            intensity = 'Bold',
            italic = true,
            font = wezterm.font_with_fallback {
                {
                    family = 'Monaspace Xenon NF',
                    style = 'Italic',
                    weight = 'Bold',
                    harfbuzz_features = { 'calt', 'liga', 'dlig', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08' },
                },
                {
                    family = 'MonaspiceXe NF',
                    style = 'Italic',
                    weight = 'Bold',
                    harfbuzz_features = { 'calt', 'liga', 'dlig', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08' },
                },
            }
        },
    },

}

if is_windows() then
    appearance_config.window_background_opacity = 0
    appearance_config.win32_system_backdrop = 'Mica'
end

return appearance_config
