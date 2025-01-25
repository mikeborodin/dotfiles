return {
  {

    "folke/tokyonight.nvim",
    lazy = false,
    enabled = true,
    config = function()
      require('tokyonight').setup(
        {
          ---@param colors ColorScheme
          on_colors = function(colors)
            colors.bg = "#222436"
            colors.bg_dark = "#1e2030"
            colors.bg_dark1 = "#191B29"
            colors.bg_highlight = "#2f334d"
            colors.blue = "#82aaff"
            colors.blue0 = "#3e68d7"
            colors.blue1 = "#65bcff"
            colors.blue2 = "#0db9d7"
            colors.blue5 = "#89ddff"
            colors.blue6 = "#b4f9f8"
            colors.blue7 = "#394b70"
            colors.comment = "#636da6"
            colors.cyan = "#86e1fc"
            colors.dark3 = "#545c7e"
            colors.dark5 = "#737aa2"
            colors.fg = "#c8d3f5"
            colors.fg_dark = "#828bb8"
            colors.fg_gutter = "#3b4261"
            colors.green = "#c3e88d"
            colors.green1 = "#4fd6be"
            colors.bg_sidebar = "#1e2030"
            colors.green2 = "#41a6b5"
            colors.magenta = "#c099ff"
            colors.magenta2 = "#ff007c"
            colors.orange = "#ff966c"
            colors.purple = "#fca7ea"
            colors.red = "#ff757f"
            colors.red1 = "#c53b53"
            colors.teal = "#4fd6be"
            colors.terminal_black = "#444a73"
            colors.yellow = "#ffc777"
            colors.git = {
              add = "#b8db87",
              change = "#7ca1f2",
              delete = "#e26a75",
            }
          end,
          on_highlights = function(highlights, colors)
          end
        }
      )
      vim.cmd.colorscheme "tokyonight"
    end,
  },
}
