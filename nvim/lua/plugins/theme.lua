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
          Cursor = {
            fg = c.vscDarkBlue,
            bg = c.vscLightGreen,
            bold = true,
          },
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
    'lunacookies/vim-colors-xcode',
    enabled = false,
    config = function()
      vim.cmd [[colorscheme xcodedark]]
    end
  },
  {'rose-pine/neovim',
  enabled = false, 
  config = function()
    require('rose-pine').setup({
	--- @usage 'auto'|'main'|'moon'|'dawn'
	variant = 'auto',
	--- @usage 'main'|'moon'|'dawn'
	dark_variant = 'main',
	bold_vert_split = false,
	dim_nc_background = false,
	disable_background = false,
	disable_float_background = false,
	disable_italics = false,

	--- @usage string hex value or named color from rosepinetheme.com/palette
	groups = {
		background = 'base',
		background_nc = '_experimental_nc',
		panel = 'surface',
		panel_nc = 'base',
		border = 'highlight_med',
		comment = 'muted',
		link = 'iris',
		punctuation = 'subtle',

		error = 'love',
		hint = 'iris',
		info = 'foam',
		warn = 'gold',

		headings = {
			h1 = 'iris',
			h2 = 'foam',
			h3 = 'rose',
			h4 = 'gold',
			h5 = 'pine',
			h6 = 'foam',
		}
		-- or set all headings at once
		-- headings = 'subtle'
	},

	-- Change specific vim highlight groups
	-- https://github.com/rose-pine/neovim/wiki/Recipes
	highlight_groups = {
		ColorColumn = { bg = 'rose' },

		-- Blend colours against the "base" background
		CursorLine = { bg = 'foam', blend = 10 },
		StatusLine = { fg = 'love', bg = 'love', blend = 10 },

		-- By default each group adds to the existing config.
		-- If you only want to set what is written in this config exactly,
		-- you can set the inherit option:
		Search = { bg = 'gold', inherit = false },
	}
})
-- Set colorscheme after options
vim.cmd('colorscheme rose-pine')
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
  -- catppuccin
  {

    "folke/tokyonight.nvim",
    lazy = false,
    enabled = false,
    opts = { style = "moon" },
    config = function()
      vim.cmd [[colorscheme tokyonight]]
    end,
  },

}
