return {
  {
    enabled = false,
    'doums/darcula',
    config = function()
      vim.cmd [[colorscheme darcula]]
    end
  },
  {
    enabled = false,
    'Mofiqul/vscode.nvim',
    config = function()
      vim.o.background = 'dark'
      -- For light theme

      local c = require('vscode.colors').get_colors()
      require('vscode').setup({
        -- Alternatively set style in setup
        style = 'dark',

        -- Enable transparent background
        transparent = false,

        -- Enable italic comment
        italic_comments = true,

        -- Disable nvim-tree background color
        -- disable_nvimtree_bg = true,

        -- Override colors (see ./lua/vscode/colors.lua)
        -- Override highlight groups (see ./lua/vscode/theme.lua)
        group_overrides = {
          -- this supports the same val table as vim.api.nvim_set_hl
          -- use colors from this colorscheme by requiring vscode.colors!
          Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
        }
      })
      require('vscode').load()
    end
  },
  {
    'rose-pine/neovim',
    enabled = false,
    name = 'rose-pine',
    config = function()
      -- vim.cmd [[colorscheme rose-pine]]
    end
  },
  {
    "catppuccin/nvim",
    enabled = false,
    name = "catppuccin",
    config = function()
      -- vim.cmd [[colorscheme catppuccin]]
    end
  },
  {
    -- Theme inspired by Atom
    'Mofiqul/dracula.nvim',
    enabled = true,
    priority = 1000,
    config = function()
      local dracula = require("dracula")
      dracula.setup({
        -- customize dracula color palette
        colors = {
          bg = "#161526",
          -- bg = "#000011",
          fg = "#F8F8F2",
          selection = "#44475A",
          comment = "#6272A4",
          red = "#FF5555",
          orange = "#FFB86C",
          yellow = "#F1FA8C",
          green = "#50fa7b",
          purple = "#BD93F9",
          cyan = "#8BE9FD",
          pink = "#FF79C6",
          bright_red = "#FF6E6E",
          bright_green = "#69FF94",
          bright_yellow = "#FFFFA5",
          bright_blue = "#D6ACFF",
          bright_magenta = "#FF92DF",
          bright_cyan = "#A4FFFF",
          bright_white = "#FFFFFF",
          menu = "#1f1e37",
          visual = "#3E4452",
          gutter_fg = "#4B5263",
          nontext = "#3B4048",
        },
        -- show the '~' characters after the end of buffers
        show_end_of_buffer = true,    -- default false
        -- use transparent background
        transparent_bg = false,       -- default false
        -- set custom lualine background color
        lualine_bg_color = "#44475a", -- default nil
        -- set italic comment
        italic_comment = true,        -- default false
        -- overrides the default highlights see `:h synIDattr`
        overrides = {
          -- Examples
          -- NonText = { fg = dracula.colors().white }, -- set NonText fg to white
          -- NvimTreeIndentMarker = { link = "NonText" }, -- link to NonText highlight
          -- Nothing = {} -- clear highlight of Nothing
        },
      })
      vim.cmd [[colorscheme dracula]]
    end,
  },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'dracula-nvim',
        component_separators = '|',
        section_separators = '',
      },
    },
  },
}
