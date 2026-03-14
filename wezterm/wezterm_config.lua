---@type Wezterm
local wezterm = require("wezterm")
local colors = require("colors")

local config = wezterm.config_builder()

config.window_decorations = "RESIZE|MACOS_FORCE_DISABLE_SHADOW"
config.font_size = 19
config.color_scheme = "Catppuccin Macchiato"
config.leader = { key = "t", mods = "CMD" }
config.disable_default_key_bindings = true
config.show_new_tab_button_in_tab_bar = false
config.window_padding = { top = 0, left = 0, right = 0, bottom = 0 }
config.tab_max_width = 50
config.use_fancy_tab_bar = false
config.enable_tab_bar = true
config.show_tabs_in_tab_bar = true
config.show_tab_index_in_tab_bar = false
config.command_palette_bg_color = "#383d6d"
config.command_palette_font_size = 22
config.command_palette_rows = 10
config.scrollback_lines = 2000
config.command_palette_fg_color = "white"
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.default_prog = { "/Users/mike/.local/share/mise/shims/nu" }

config.initial_cols = 120
config.initial_rows = 40
config.adjust_window_size_when_changing_font_size = false

-- Performance settings
config.animation_fps = 10
config.max_fps = 60
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.status_update_interval = 1000
config.default_cursor_style = "SteadyBlock" -- avoid repaint from blinking
config.cursor_blink_rate = 0 -- disable cursor blink entirely
config.check_for_updates = false -- skip network I/O on startup

-- Cache HOME once at config load, not on every tab render
local HOME = os.getenv("HOME")

local function get_current_working_dir(tab)
  local cwd_uri = tab.active_pane.current_working_dir

  if cwd_uri then
    local cwd = ""
    if type(cwd_uri) == "userdata" then
      cwd = cwd_uri.file_path
    else
      cwd_uri = cwd_uri:sub(8)
      local slash = cwd_uri:find("/")
      if slash then
        cwd = cwd_uri:sub(slash):gsub("%%(%x%x)", function(hex)
          return string.char(tonumber(hex, 16))
        end)
      end
    end

    if cwd == HOME then
      return "~"
    end

    return string.match(cwd, "[^/]+$")
  end
end

local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

local Grey = "#0f1419"
local LightGrey = "#191f26"
local TAB_BAR_BG = "#181927"
local ACTIVE_TAB_BG = "#383d6d"
local ACTIVE_TAB_FG = "White"
local HOVER_TAB_BG = Grey
local HOVER_TAB_FG = "White"
local NORMAL_TAB_BG = LightGrey
local NORMAL_TAB_FG = "Grey"

local TAB_TITLE_MAX_LEN = 25

local WORKSPACE_BG = colors.mauve
local WORKSPACE_FG = colors.crust

-- Cache the last formatted workspace status to avoid re-formatting when unchanged
local last_workspace = nil
local last_workspace_status = nil

local function update_left_status(window)
  local workspace = window:active_workspace()
  if workspace ~= last_workspace then
    last_workspace = workspace
    last_workspace_status = wezterm.format({
      { Background = { Color = WORKSPACE_BG } },
      { Foreground = { Color = WORKSPACE_FG } },
      { Attribute = { Intensity = "Bold" } },
      { Text = "  " .. workspace .. " " },
      { Background = { Color = NORMAL_TAB_BG } },
      { Foreground = { Color = WORKSPACE_BG } },
      { Text = SOLID_RIGHT_ARROW },
    })
  end
  window:set_left_status(last_workspace_status)
end


wezterm.on("update-status", function(window)
  update_left_status(window)

  local date = wezterm.strftime("  %H:%M")
  window:set_right_status(date)
end)

wezterm.on(
  "format-tab-title",
  function(tab, tabs, _panes, _config, hover, _max_width)
    local background = NORMAL_TAB_BG
    local foreground = NORMAL_TAB_FG

    local is_last = tab.tab_id == tabs[#tabs].tab_id

    if tab.is_active then
      background = ACTIVE_TAB_BG
      foreground = ACTIVE_TAB_FG
    elseif hover then
      background = HOVER_TAB_BG
      foreground = HOVER_TAB_FG
    end

    local tab_title = tab.tab_title
    local name = (tab_title and #tab_title > 0) and tab_title
      or get_current_working_dir(tab)
      or ""

    if #name > TAB_TITLE_MAX_LEN then
      name = name:sub(1, TAB_TITLE_MAX_LEN) .. "…"
    end

    local leading_fg = NORMAL_TAB_BG
    local leading_bg = background

    local trailing_fg = background
    local trailing_bg = is_last and TAB_BAR_BG or NORMAL_TAB_BG

    return {
      { Attribute = { Italic = false } },
      { Attribute = { Intensity = hover and "Bold" or "Normal" } },
      { Background = { Color = leading_bg } },
      { Foreground = { Color = leading_fg } },
      { Text = SOLID_RIGHT_ARROW },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = name },
      { Background = { Color = trailing_bg } },
      { Foreground = { Color = trailing_fg } },
      { Text = SOLID_RIGHT_ARROW },
    }
  end
)

config.keys = require("keybindings")

return config
