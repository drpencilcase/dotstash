-- /Users/barbo/.config/wezterm/appearance.lua
local wezterm = require 'wezterm'

-- 1. Detect OS
local is_windows = wezterm.target_triple:find("windows") ~= nil
local is_darwin = wezterm.target_triple:find("darwin") ~= nil

-- 2. Define Font Names based on OS
-- Default to macOS names (Monaspace ...)
local fonts = {
    main        = 'Monaspace Neon NF',
    italic      = 'Monaspace Xenon NF',
    bold        = 'Monaspace Krypton NF',
    bold_italic = 'Monaspace Xenon NF',
}

-- Override with Windows names if on Windows (Monaspice ...)
if is_windows then
    fonts.main        = 'MonaspiceNe Nerd Font'
    fonts.italic      = 'MonaspiceXe Nerd Font'
    fonts.bold        = 'MonaspiceKr Nerd Font'
    fonts.bold_italic = 'MonaspiceXe Nerd Font'
end

-- 3. Define common settings
local common_features = { 'calt', 'liga', 'dlig', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08' }

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

-- 4. Build the Configuration
local appearance_config = {
    color_scheme = scheme_for_appearance(get_appearance()),
    use_fancy_tab_bar = false,
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

    -- Main Font (Neon / MonaspiceNe)
    font = wezterm.font {
        family = fonts.main,
        harfbuzz_features = common_features,
    },

    font_rules = {
        { -- Italic (Xenon / MonaspiceXe)
            intensity = 'Normal',
            italic = true,
            font = wezterm.font {
                family = fonts.italic,
                style = 'Italic',
                harfbuzz_features = common_features,
            }
        },

        { -- Bold (Krypton / MonaspiceKr)
            intensity = 'Bold',
            italic = false,
            font = wezterm.font {
                family = fonts.bold,
                weight = 'Bold',
                harfbuzz_features = common_features,
            }
        },

        { -- Bold Italic (Xenon / MonaspiceXe)
            intensity = 'Bold',
            italic = true,
            font = wezterm.font {
                family = fonts.bold_italic,
                style = 'Italic',
                weight = 'Bold',
                harfbuzz_features = common_features,
            }
        },
    },
}



return appearance_config
