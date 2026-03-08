---@type Wezterm
local wezterm = require("wezterm")
local colors = require("colors")
local PROCESS_ICONS = require("process_icons")

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
config.show_new_tab_button_in_tab_bar = false
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

config.animation_fps = 10
config.max_fps = 60
config.front_end = "WebGpu"
config.status_update_interval = 1000 -- update status bar at most once per second

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

    if cwd == os.getenv("HOME") then
      return "~"
    end

    return string.format("%s", string.match(cwd, "[^/]+$"))
  end
end

-- Pre-format process icons once at config load instead of on every tab redraw
local formatted_process_icons = {}
for name, icon in pairs(PROCESS_ICONS) do
  formatted_process_icons[name] = " " .. wezterm.format(icon)
end

local formatted_empty_process = wezterm.format({
  { Foreground = { Color = colors.red } },
  { Text = "󰌾" },
})

local unknown_process_cache = {}

local function get_process(tab)
  local process_name =
    string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")

  if formatted_process_icons[process_name] then
    return formatted_process_icons[process_name]
  elseif process_name == "" then
    return formatted_empty_process
  else
    if not unknown_process_cache[process_name] then
      unknown_process_cache[process_name] = wezterm.format({
        { Foreground = { Color = colors.blue } },
        { Text = string.format("[%s]", process_name) },
      })
    end
    return unknown_process_cache[process_name]
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

local function update_left_status(window)
  local workspace = window:active_workspace()
  window:set_left_status(wezterm.format({
    { Background = { Color = WORKSPACE_BG } },
    { Foreground = { Color = WORKSPACE_FG } },
    { Attribute = { Intensity = "Bold" } },
    { Text = "  " .. workspace .. " " },
    { Background = { Color = NORMAL_TAB_BG } },
    { Foreground = { Color = WORKSPACE_BG } },
    { Text = SOLID_RIGHT_ARROW },
  }))
end

local status_cache = { text = "", last_read = 0 }
local STATUS_CACHE_TTL = 30 -- seconds between disk reads

local home = os.getenv("HOME") or ""
local reports_dir = home .. "/status_reports"

local function read_status_reports()
  local now = os.time()
  if now - status_cache.last_read < STATUS_CACHE_TTL then
    return status_cache.text
  end

  local statuses = {}

  -- Use wezterm.glob instead of shelling out with io.popen
  local ok, files = pcall(wezterm.glob, reports_dir .. "/status_*.txt")
  if ok and files then
    for _, file in ipairs(files) do
      local f = io.open(file, "r")
      if f then
        local content = f:read("*a") or ""
        f:close()
        content = content:gsub("%s+$", "")
        if content ~= "" then
          table.insert(statuses, content)
        end
      end
    end
  end

  status_cache.text = table.concat(statuses, " | ")
  status_cache.last_read = now
  return status_cache.text
end

wezterm.on("update-status", function(window)
  update_left_status(window)

  local status_str = read_status_reports()
  local date = wezterm.strftime("  %H:%M")
  local display = status_str ~= "" and (status_str .. "  " .. date) or date
  window:set_right_status(display)
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
    local trailing_bg = NORMAL_TAB_BG

    if is_last then
      trailing_bg = TAB_BAR_BG
    else
      trailing_bg = NORMAL_TAB_BG
    end

    return {
      { Attribute = { Italic = false } },
      { Attribute = { Intensity = hover and "Bold" or "Normal" } },
      { Background = { Color = leading_bg } },
      { Foreground = { Color = leading_fg } },
      { Text = SOLID_RIGHT_ARROW },
      { Background = { Color = background } },
      -- { Text = get_process(tab) },
      -- { Text = " " },
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
