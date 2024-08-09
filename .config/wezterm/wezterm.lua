local wezterm = require 'wezterm'
local io = require 'io'
local os = require 'os'
local wact = wezterm.action

wezterm.on('augment-command-palette', function(_, _)
  return {
    {
      brief = 'Rename tab',
      icon = 'md_rename_box',
      action = wact.PromptInputLine {
        description = 'Enter new name for active tab',
        action = wezterm.action_callback(function(cwindow, _, line)
          if line then
            cwindow:active_tab():set_title(line)
          end
        end),
      },
    },
    {
      brief = 'Rename workspace',
      icon = 'md_rename_box',
      action = wact.PromptInputLine {
        description = 'Enter new name for active workspace',
        action = wezterm.action_callback(function(_, _, line)
          if line then
            wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
          end
        end),
      },
    },
  }
end)

wezterm.on('update-right-status', function(window, _)
  window:set_right_status(window:active_workspace())
end)

wezterm.on('toggle-ligature', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.harfbuzz_features then
    overrides.harfbuzz_features = { 'aalt=0', 'calt=0', 'clig=0', 'liga=0' }
  else
    overrides.harfbuzz_features = nil
  end
  window:set_config_overrides(overrides)
end)

wezterm.on('edit-scrollback', function(window, pane)
  local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)

  local filename = os.tmpname()
  local f = io.open(filename, 'w+')
  if f == nil then
    wezterm.log_error('Failed to create temp file for scrollback editing')
    return
  end
  f:write(text)
  f:flush()
  f:close()

  window:perform_action(wact.SpawnCommandInNewWindow { args = { 'nvim', filename } }, pane)
  -- Wait "enough" time for nvim to read the file before removing it
  wezterm.sleep_ms(2000)
  os.remove(filename)
end)

local config = {
  scrollback_lines = 10000,

  audible_bell = "Disabled",

  use_ime = false,

  quick_select_patterns = {
    -- Git-status file paths
    '(?<=\\s{8}|\\s{8}modified:\\s{3})/*[0-9A-Za-z.+_/-]+',
    -- Git branch names in ()
    '\\(([0-9A-Za-z_+-]+)\\)',
  },

  font = wezterm.font_with_fallback {
    'Fira Code Custom',
    'Iosevka Custom Extended',
    'Rec Mono Custom',
    'Font Awesome 6 Free',
  },
  font_size = 12,
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

  window_background_opacity = 0.9,

  color_scheme = 'tokyo-night-storm',
  color_schemes = {
    ['tokyo-night-storm'] = {
      foreground = '#d3d7eb',
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

  -- Default: saturation = 0.9, brightness = 0.8
  inactive_pane_hsb = { saturation = 0.9, brightness = 0.6 },

  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,

  unix_domains = { { name = 'unix' } },
  default_gui_startup_args = { 'connect', 'unix' },

  -- Override default table to always confirm
  skip_close_confirmation_for_processes_named = {},

  leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 },
  keys = {
    { key = 'e',     mods = 'CTRL|SHIFT',        action = wact.EmitEvent 'toggle-ligature' },
    { key = 'y',     mods = 'CTRL|SHIFT',        action = wact.EmitEvent 'edit-scrollback' },

    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    { key = 'a',     mods = 'LEADER|CTRL', action = wact.SendKey { key = 'a', mods = 'CTRL' } },
    -- Spawn new terminal with the same working directory
    { key = 'Enter', mods = 'SHIFT|CTRL',  action = wact.SpawnWindow, },

    -- Split panes
    { key = 'v',     mods = 'LEADER',      action = wact.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 'b',     mods = 'LEADER',      action = wact.SplitHorizontal { domain = 'CurrentPaneDomain' } },

    { key = 'z',     mods = 'LEADER',      action = wact.TogglePaneZoomState },
    { key = 'o',     mods = 'LEADER|CTRL', action = wact.RotatePanes('Clockwise') },
    { key = 'x',     mods = 'LEADER',      action = wact.CloseCurrentPane { confirm = true } },

    -- Tab actions
    { key = 'c',     mods = 'LEADER',      action = wact.SpawnTab('CurrentPaneDomain') },
    { key = 'h',     mods = 'LEADER|CTRL', action = wact.ActivateTabRelative(-1) },
    { key = 'l',     mods = 'LEADER|CTRL', action = wact.ActivateTabRelative(1) },

    {
      key = '[',
      mods = 'LEADER',
      action = wact.Multiple { wact.ActivateCopyMode, wact.CopyMode('ClearSelectionMode') }
    },
    { key = ']',     mods = 'LEADER',      action = wact.PasteFrom('PrimarySelection') },

    -- Workspaces
    { key = 's',     mods = 'LEADER',  action = wact.ShowLauncherArgs { flags = 'WORKSPACES' } },
  },

  key_tables = {
    copy_mode = {
      { key = 'q',      mods = 'NONE',       action = wact.CopyMode('Close') },
      { key = 'Escape', mods = 'NONE',       action = wact.CopyMode('ClearSelectionMode') },

      -- Movement
      { key = 'w', mods = 'NONE',       action = wact.CopyMode('MoveForwardWord') },
      { key = 'b', mods = 'NONE',       action = wact.CopyMode('MoveBackwardWord') },
      { key = 'e', mods = 'NONE',       action = wact.CopyMode('MoveForwardWordEnd') },
      { key = '0', mods = 'NONE',       action = wact.CopyMode('MoveToStartOfLine') },
      { key = '^', mods = 'NONE',       action = wact.CopyMode('MoveToStartOfLineContent') },
      { key = '$', mods = 'NONE',       action = wact.CopyMode('MoveToEndOfLineContent') },
      { key = 'g', mods = 'NONE',       action = wact.CopyMode('MoveToScrollbackTop') },
      { key = 'g', mods = 'SHIFT',      action = wact.CopyMode('MoveToScrollbackBottom') },
      { key = 'h', mods = 'SHIFT',      action = wact.CopyMode('MoveToViewportTop') },
      { key = 'l', mods = 'SHIFT',      action = wact.CopyMode('MoveToViewportBottom') },

      -- Page movement
      { key = 'b', mods = 'CTRL',       action = wact.CopyMode('PageUp') },
      { key = 'f', mods = 'CTRL',       action = wact.CopyMode('PageDown') },

      -- Selection
      { key = 'v', mods = 'NONE',       action = wact.CopyMode { SetSelectionMode = 'Cell' } },
      { key = 'v', mods = 'SHIFT',      action = wact.CopyMode { SetSelectionMode = 'Line' } },
      { key = 'v', mods = 'CTRL',       action = wact.CopyMode { SetSelectionMode = 'Block' } },
      { key = 'o', mods = 'NONE',       action = wact.CopyMode('MoveToSelectionOtherEnd') },
      { key = 'o', mods = 'SHIFT',      action = wact.CopyMode('MoveToSelectionOtherEndHoriz') },

      -- Copy selection
      { key = 'y', mods = 'NONE',       action = wact.CopyTo('Clipboard') },
      { key = 'y', mods = 'SHIFT',      action = wact.CopyTo('PrimarySelection') },

      -- Search
      { key = '/', mods = 'NONE',       action = wact.Search { CaseInSensitiveString = '' } },
      { key = '/', mods = 'SHIFT',      action = wact.Search('CurrentSelectionOrEmptyString') },
      { key = 'f', mods = 'CTRL|SHIFT', action = wact.Search { Regex = '' } },

      -- Naviagte search matches
      {
        key = 'n',
        mods = 'NONE',
        action = wact.Multiple { wact.CopyMode('NextMatch'), wact.CopyMode('ClearSelectionMode') }
      },
      {
        key = 'n',
        mods = 'SHIFT',
        action = wact.Multiple { wact.CopyMode('PriorMatch'), wact.CopyMode('ClearSelectionMode') }
      },
      { key = 'l', mods = 'CTRL', action = wact.CopyMode('ClearPattern') },
    },
    search_mode = {
      { key = 'Escape', mods = 'NONE', action = wact.ActivateCopyMode },
      {
        key = 'Enter',
        mods = 'NONE',
        action = wact.Multiple {
          wact.CopyMode('AcceptPattern'),
          wact.ActivateCopyMode, wact.CopyMode('ClearSelectionMode')
        }
      },
      { key = 'r', mods = 'CTRL', action = wact.CopyMode('CycleMatchType') },
    },
  },

  mouse_bindings = {
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'NONE',
      action = wact.CompleteSelectionOrOpenLinkAtMouseCursor("PrimarySelection"),
    },
  },
}

-- Bindings for vim directions
local dirKeys = { 'h', 'j', 'k', 'l' }
local dirNames = { 'Left', 'Down', 'Up', 'Right' }
local dirArrows = { 'LeftArrow', 'DownArrow', 'UpArrow', 'RightArrow' }
for i = 1, #dirKeys do
  -- Move focus
  table.insert(config.keys, { key = dirKeys[i], mods = 'LEADER', action = wact.ActivatePaneDirection(dirNames[i]) })
  table.insert(config.keys, { key = dirKeys[i], mods = 'ALT', action = wact.ActivatePaneDirection(dirNames[i]) })
  -- Resize pane
  table.insert(config.keys,
    { key = dirArrows[i], mods = 'LEADER|CTRL', action = wact.AdjustPaneSize { dirNames[i], 5 } })

  -- Copy mode directions
  table.insert(config.key_tables.copy_mode,
    { key = dirKeys[i], mods = 'NONE', action = wact.CopyMode('Move' .. dirNames[i]) })
  table.insert(config.key_tables.copy_mode,
    { key = dirArrows[i], mods = 'NONE', action = wact.CopyMode('Move' .. dirNames[i]) })
end

-- Bindings to activate tabs 1--9
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = 'LEADER',
    action = wact.ActivateTab(i - 1),
  })
end

return config
