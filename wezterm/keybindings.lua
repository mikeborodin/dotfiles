---@type Wezterm
local wezterm = require("wezterm")
local act = wezterm.action

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

return {
  cmd("e", 0xA0),
  cmd("y", 0xA1),
  cmd("o", 0xA2),
  cmd("i", 0xA3),
  cmd("f", 0xA4),
  cmd("h", 0xA5),
  --- spawning
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
    key = "f",
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
    key = "n",
    action = act.ActivateTabRelative(-1),
  },
  {
    mods = "CMD|SHIFT",
    key = "y",
    action = wezterm.action.CloseCurrentPane({ confirm = false }),
  },
  --copypaste
  {
    mods = "CMD",
    key = "c",
    action = wezterm.action.CopyTo("Clipboard"),
  },
  {
    mods = "CMD",
    key = "c",
    action = wezterm.action.CopyTo("Clipboard"),
  },
  {
    mods = "CMD",
    key = "v",
    action = wezterm.action.PasteFrom("Clipboard"),
  },
  --- panes nav
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
  --- fonts
  {
    mods = "CMD",
    key = "+",
    action = act.IncreaseFontSize,
  },
  {
    mods = "CMD",
    key = "-",
    action = act.DecreaseFontSize,
  },
  {
    mods = "LEADER",
    key = "=",
    action = act.ResetFontSize,
  },
  {
    mods = "LEADER",
    key = "?",
    action = act.ActivateCommandPalette,
  },
}
