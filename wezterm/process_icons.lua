local wezterm = require("wezterm")
local colors = require("colors")

return {
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
