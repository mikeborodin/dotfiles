---@type Wezterm
local wezterm = require("wezterm")
local colors = require("colors")

local config = wezterm.config_builder()

config.window_decorations = "RESIZE|MACOS_FORCE_DISABLE_SHADOW"
config.font_size = 16
config.color_scheme = "Catppuccin Macchiato"
config.leader = { key = "t", mods = "CMD" }
config.disable_default_key_bindings = true
config.show_new_tab_button_in_tab_bar = false
config.window_padding = { top = 0, left = 0, right = 0, bottom = 0 }
config.tab_max_width = 50
config.use_fancy_tab_bar = false
config.show_tabs_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = false
config.command_palette_bg_color = "#383d6d"
config.command_palette_font_size = 22
config.command_palette_rows = 10
config.command_palette_fg_color = "white"
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.default_prog = { "/Users/mike/.local/share/mise/shims/nu" }

config.initial_cols = 120
config.initial_rows = 40
config.adjust_window_size_when_changing_font_size = false

config.animation_fps = 1
config.max_fps = 60
config.front_end = "Software"

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

local function get_process(tab)
  local PROCESS_ICONS = require("process_icons")
  local process_name =
    string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")

  if PROCESS_ICONS[process_name] then
    return " " .. wezterm.format(PROCESS_ICONS[process_name])
  elseif process_name == "" then
    return wezterm.format({
      { Foreground = { Color = colors.red } },
      { Text = "󰌾" },
    })
  else
    return wezterm.format({
      { Foreground = { Color = colors.blue } },
      { Text = string.format("[%s]", process_name) },
    })
  end
end

function get_tab_title_or_pane(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  return tab_info.active_pane.title
end

local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

local Grey = "#0f1419"
local LightGrey = "#191f26"
local TAB_BAR_BG = "181927"
local ACTIVE_TAB_BG = "#383d6d"
local ACTIVE_TAB_FG = "White"
local HOVER_TAB_BG = Grey
local HOVER_TAB_FG = "White"
local NORMAL_TAB_BG = LightGrey
local NORMAL_TAB_FG = "Grey"

wezterm.on(
  "format-tab-title",
  function(tab, tabs, panes, config, hover, max_width)
    panes = panes
    config = config
    max_width = max_width

    local background = NORMAL_TAB_BG
    local foreground = NORMAL_TAB_FG

    local is_first = tab.tab_id == tabs[1].tab_id
    local is_last = tab.tab_id == tabs[#tabs].tab_id

    if tab.is_active then
      background = ACTIVE_TAB_BG
      foreground = ACTIVE_TAB_FG
    elseif hover then
      background = HOVER_TAB_BG
      foreground = HOVER_TAB_FG
    end

    local name = get_current_working_dir(tab)
    local process_name = string.gsub(
      tab.active_pane.foreground_process_name,
      "(.*[/\\])(.*)",
      "%2"
    )

    for _, pane in ipairs(tab.panes) do
      if
        pane.has_unseen_output
        and process_name ~= "nvim"
        and process_name ~= "lazygit"
      then
        name = name .. "*"
      end
    end

    local leading_fg = NORMAL_TAB_FG
    local leading_bg = background

    local trailing_fg = background
    local trailing_bg = NORMAL_TAB_BG

    if is_first then
      leading_fg = TAB_BAR_BG
    else
      leading_fg = NORMAL_TAB_BG
    end

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
      { Text = not is_first and SOLID_RIGHT_ARROW or "" },
      { Background = { Color = background } },
      { Text = get_process(tab) },
      { Text = " " },
      { Foreground = { Color = foreground } },
      { Text = name },
      { Background = { Color = trailing_bg } },
      { Foreground = { Color = trailing_fg } },
      { Text = SOLID_RIGHT_ARROW },
    }
  end
)

function get_tab_title_or_pane(tab_info)
  local title = tab_info.tab_title
  if title and #title > 0 then
    return title
  end
  return tab_info.active_pane.title
end

config.keys = require("keybindings")

flag = true

-- wezterm.on("update-right-status", function(window, pane)
--   local date = wezterm.strftime("  %H:%M")
--   flag = not flag
--   window:set_right_status("> mike: " .. tostring(flag) .. " " .. date)
--

local function read_status_reports()
  local home = os.getenv("HOME") or ""
  local reports_dir = home .. "/status_reports"
  local statuses = {}

  local p = io.popen("ls -1 " .. reports_dir .. "/status_*.txt 2>/dev/null")
  if p then
    for file in p:lines() do
      local f = io.open(file, "r")
      if f then
        local content = f:read("*a") or ""
        f:close()
        content = content:gsub("%s+$", "") -- trim trailing whitespace
        if content ~= "" then
          table.insert(statuses, content)
        end
      end
    end
    p:close()
  end

  return table.concat(statuses, " | ")
end

wezterm.on("update-right-status", function(window, pane)
  local status_str = read_status_reports()
  local date = wezterm.strftime("  %H:%M")
  local display = status_str ~= "" and (status_str .. "  " .. date) or date
  window:set_right_status(display)
end)

return config
