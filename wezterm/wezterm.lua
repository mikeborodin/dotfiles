---@type Wezterm
local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

config.window_decorations = "RESIZE|MACOS_FORCE_DISABLE_SHADOW"

config.font_size = 16
config.color_scheme = "Catppuccin Macchiato"

config.leader = { key = "t", mods = "CMD" }

config.disable_default_key_bindings = true
config.show_new_tab_button_in_tab_bar = false
config.window_padding = { top = 0, left = 0, right = 0, bottom = 0 }
config.tab_max_width = 50

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

local colors = {
  rosewater = "#f5e0dc",
  flamingo = "#f2cdcd",
  pink = "#f5c2e7",
  mauve = "#cba6f7",
  red = "#f38ba8",
  maroon = "#eba0ac",
  peach = "#fab387",
  yellow = "#f9e2af",
  green = "#a6e3a1",
  teal = "#94e2d5",
  sky = "#89dceb",
  sapphire = "#74c7ec",
  blue = "#89b4fa",
  lavender = "#b4befe",
  text = "#cdd6f4",
  subtext1 = "#bac2de",
  subtext0 = "#a6adc8",
  overlay2 = "#9399b2",
  overlay1 = "#7f849c",
  overlay0 = "#6c7086",
  surface2 = "#585b70",
  surface1 = "#45475a",
  surface0 = "#313244",
  base = "#1e1e2e",
  mantle = "#181825",
  crust = "#11111b",
}

local function get_process(tab)
  local PROCESS_ICONS = {
    ["docker"] = {
      { Foreground = { Color = colors.blue } },
      { Text = "󰡨" },
    },
    ["docker-compose"] = {
      { Foreground = { Color = colors.blue } },
      { Text = "󰡨" },
    },
    ["nvim"] = {
      { Foreground = { Color = colors.green } },
      { Text = "" },
    },
    ["bob"] = {
      { Foreground = { Color = colors.blue } },
      { Text = "" },
    },
    ["vim"] = {
      { Foreground = { Color = colors.green } },
      { Text = "" },
    },
    ["node"] = {
      { Foreground = { Color = colors.green } },
      { Text = "󰋘" },
    },
    ["zsh"] = {
      { Foreground = { Color = colors.peach } },
      { Text = "" },
    },
    ["bash"] = {
      { Foreground = { Color = colors.overlay1 } },
      { Text = "" },
    },
    ["htop"] = {
      { Foreground = { Color = colors.yellow } },
      { Text = "" },
    },
    ["btop"] = {
      { Foreground = { Color = colors.rosewater } },
      { Text = "" },
    },
    ["cargo"] = {
      { Foreground = { Color = colors.peach } },
      { Text = wezterm.nerdfonts.dev_rust },
    },
    ["go"] = {
      { Foreground = { Color = colors.sapphire } },
      { Text = "" },
    },
    ["git"] = {
      { Foreground = { Color = colors.peach } },
      { Text = "󰊢" },
    },
    ["lazygit"] = {
      { Foreground = { Color = colors.mauve } },
      { Text = "󰊢" },
    },
    ["lua"] = {
      { Foreground = { Color = colors.blue } },
      { Text = "" },
    },
    ["wget"] = {
      { Foreground = { Color = colors.yellow } },
      { Text = "󰄠" },
    },
    ["curl"] = {
      { Foreground = { Color = colors.yellow } },
      { Text = "" },
    },
    ["gh"] = {
      { Foreground = { Color = colors.mauve } },
      { Text = "" },
    },
    ["flatpak"] = {
      { Foreground = { Color = colors.blue } },
      { Text = "󰏖" },
    },
    ["dotnet"] = {
      { Foreground = { Color = colors.mauve } },
      { Text = "󰪮" },
    },
    ["paru"] = {
      { Foreground = { Color = colors.mauve } },
      { Text = "󰣇" },
    },
    ["yay"] = {
      { Foreground = { Color = colors.mauve } },
      { Text = "󰣇" },
    },
    ["fish"] = {
      { Foreground = { Color = colors.peach } },
      { Text = "" },
    },
  }

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

    -- local title = " "
    --   .. wezterm.truncate_left(get_tab_title_or_pane(tab), 40)
    --   .. " "

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
local function is_vim(pane)
  local is_vim_env = pane:get_user_vars().IS_NVIM == "true"
  if is_vim_env == true then
    return true
  end
  local process_name =
    string.gsub(pane:get_foreground_process_name(), "(.*[/\\])(.*)", "%2")
  return process_name == "nvim" or process_name == "vim"
end

local function cmd(key, char)
  return {
    key = key,
    mods = "CMD",
    action = wezterm.action_callback(function(win, pane)
      if char and is_vim(pane) then
        win:perform_action({
          SendKey = { key = utf8.char(char), mods = "CMD" },
        }, pane)
      else
        win:perform_action({
          SendKey = {
            key = key,
            mods = "CMD",
          },
        }, pane)
      end
    end),
  }
end

config.use_fancy_tab_bar = false
config.show_tabs_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = false

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
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

config.keys = {
  -- CTRL+SHIFT+Space, followed by 'r' will put us in resize-pane
  -- mode until we cancel that mode.
  cmd("e", 0xA0),
  cmd("y", 0xA1),
  cmd("o", 0xA2),
  cmd("i", 0xA3),
  cmd("f", 0xA4),
  cmd("h", 0xA5),
  {
    mods = "LEADER",
    key = "h",
    action = wezterm.action.SplitPane({
      direction = "Right",
      command = { args = { "zsh" } },
      size = { Percent = 50 },
    }),
  },
  {
    key = "\u{f746}", -- Match the logged value
    mods = "NONE",
    action = wezterm.action.SendKey({ key = "Insert" }),
  },
  {
    mods = "LEADER",
    key = "H",
    action = wezterm.action.SplitPane({
      direction = "Down",
      command = { args = { "zsh" } },
      size = { Percent = 50 },
    }),
  },
  {
    mods = "LEADER",
    key = "o",
    action = wezterm.action.SpawnCommandInNewTab({ args = { "zsh" } }),
  },
  { key = "L", mods = "LEADER", action = wezterm.action.ShowDebugOverlay },
  {
    key = "y",
    mods = "LEADER",
    action = wezterm.action.CloseCurrentPane({ confirm = false }),
  },
  {
    key = "Y",
    mods = "LEADER",
    action = wezterm.action.CloseCurrentTab({ confirm = true }),
  },
  {
    key = "?",
    mods = "LEADER",
    action = wezterm.action.PaneSelect,
  },
  {
    key = "s",
    mods = "LEADER",
    action = act.SwitchToWorkspace({
      name = "default",
    }),
  },
  {
    key = "r",
    mods = "LEADER",
    action = act.ReloadConfiguration,
  },
  {
    key = "t",
    mods = "LEADER",
    action = act.ResetTerminal,
  },
  {
    key = "q",
    mods = "LEADER",
    action = act.QuitApplication,
  },
  {
    key = "S",
    mods = "LEADER",
    action = act.SwitchToWorkspace({
      name = "monitoring",
      spawn = {
        args = { "zsh" },
      },
    }),
  },
  {
    mods = "CMD",
    key = "w",
    action = act.SwitchWorkspaceRelative(1),
  },
  {
    mods = "CMD",
    key = "u",
    action = act.ActivateTabRelative(1),
  },
  {
    mods = "CMD",
    key = "g",
    action = act.SpawnCommandInNewTab({
      label = "lazygit",
      args = {
        "/Users/mike/.local/share/devbox/global/default/.devbox/nix/profile/default/bin/lazygit",
      },
    }),
  },
  {
    mods = "LEADER",
    key = "?",
    action = act.ActivateCommandPalette,
  },
  {
    mods = "CMD",
    key = "n",
    action = act.ActivateTabRelative(-1),
  },
  {
    mods = "CMD|SHIFT",
    key = "n",
    action = act.ActivatePaneDirection("Left"),
  },
  {
    mods = "CMD|SHIFT",
    key = "i",
    action = act.ActivatePaneDirection("Right"),
  },
  {
    mods = "CMD|SHIFT",
    key = "u",
    action = act.ActivatePaneDirection("Up"),
  },
  {
    mods = "CMD|SHIFT",
    key = "e",
    action = act.ActivatePaneDirection("Down"),
  },
  {
    key = "y",
    mods = "CMD|SHIFT",
    action = wezterm.action.CloseCurrentPane({ confirm = false }),
  },
}

return config
