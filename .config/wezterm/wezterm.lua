local wezterm = require 'wezterm'

return {
  hide_tab_bar_if_only_one_tab = true,

  font = wezterm.font_with_fallback {
    'Fira Code Custom',
    'Iosevka Custom Extended',
  },
  font_size = 14,
  font_rules = {
    {
      italic = true,
      font = wezterm.font('Iosevka Custom Extended', { italic = true }),
    },
    {
      italic = true,
      intensity = 'Bold',
      font = wezterm.font('Iosevka Custom Extended', { italic = true }),
    },
  },

  window_background_opacity = 0.95,

  color_scheme = 'tokyo-night-storm',
  color_schemes = {
    ['tokyo-night-storm'] = {
      foreground = '#c9d3ff',
      background = '#24283b',
      cursor_fg = '#24283b',
      cursor_bg = '#c9d3ff',
      cursor_border = '#c9d3ff',
      selection_bg = '#2d4370',
      ansi = {
        '#32344a',
        '#ea4e6b',
        '#9ece6a',
        '#ff9e64',
        '#7aa2f7',
        '#ad8ee6',
        '#75c1ee',
        '#b6b9cc',
      },
      brights = {
        '#444b6a',
        '#ff4266',
        '#ace173',
        '#e0af68',
        '#9abaff',
        '#bb9af7',
        '#7dcfff',
        '#cbcff5',
      },
    },
  },
}
