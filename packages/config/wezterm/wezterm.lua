
-- crtl shift R reloads config
-- background color
-- tabs


local wezterm = require 'wezterm';
return {
    enable_tab_bar = false,
    --font = wezterm.font("Ubuntu Mono", {weight="Bold"}),
    font = wezterm.font("JetBrains Mono", {weight="Bold"}),
    font_size= 11,
    -- colors = {background = "#0A0A0A"},
    -- color_scheme = "Solarized Dark Higher Contrast",
    window_close_confirmation = "NeverPrompt",

	keys = { {key="Enter", mods="ALT", action="Nop"} }, -- disable alt-enter fullscreen
	colors = { background = "#14161a" }
}



