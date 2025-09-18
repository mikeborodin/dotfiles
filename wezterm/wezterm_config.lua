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
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

-- local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
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
      { Text = get_current_working_dir(tab) },
      { Background = { Color = trailing_bg } },
      { Foreground = { Color = trailing_fg } },
      { Text = SOLID_RIGHT_ARROW },
    }
  end
)

function get_tab_title_or_pane(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

config.keys = require("keybindings")

return config
