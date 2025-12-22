vim.g.selectedFlutterDevice = ''

return {
  {
    'nvim-lualine/lualine.nvim',
    enabled = false,
    -- lazy = false,
    config = function()
      local function statusMode()
        return vim.g.selectedFlutterDevice
      end
      local function runConfig()
        return vim.g.selected_run_config.name
      end

      local colorscheme = require 'lualine.themes.auto'

      colorscheme.normal.c.bg = 'Normal'
      colorscheme.insert.c.bg = 'Normal'
      colorscheme.replace.c.bg = 'Normal'
      colorscheme.command.c.bg = 'Normal'
      colorscheme.visual.c.bg = 'Normal'
      require('lualine').setup {
        options = {
          icons_enabled = false,
          theme = colorscheme,
          component_separators = ' ',
          section_separators = { left = '', right = '' },
          ignore_focus = {},
          disabled_filetypes = {
            statusline = { 'toggleterm' },
            winbar = { 'toggleterm' },
            tabline = { 'toggleterm', 'log' },
          },
          always_divide_middle = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {},
        tabline = {
          lualine_b = {
            {
              'branch',
              color = 'User4',
            },
            {
              'filename',
              style = 'default',
              file_status = true,
              newfile_status = false,
              path = 1,
              -- 1: Relative path
              -- 2: Absolute path
              -- 3: Absolute path, with tilde as the home directory
              -- 4: Filename and parent dir, with tilde as the home directory
              shorting_target = 40, -- Shortens path to leave 40 spaces in the window
              symbols = {
                modified = '●',
                readonly = '(readonly)', -- Text to show when the file is non-modifiable or readonly.
                unnamed = '[no-name]', -- Text to show for unnamed buffers.
                newfile = '[new]', -- Text to show for newly created file before first write
              },
            },
          },
          lualine_y = {
            {
              'diagnostics',
              color = 'TabLine',
            },
            'filetype',
            {
              'lsp_status',
              icon = '', -- f013
              symbols = {
                -- Standard unicode symbols to cycle through for LSP progress:
                spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
                -- Standard unicode symbol for when LSP is done:
                done = '✓',
                -- Delimiter inserted between LSP names:
                separator = ' ',
              },
              -- List of LSP names to ignore (e.g., `null-ls`):
              ignore_lsp = {},
            },
            {
              'diff',
              colored = true, -- Displays a colored diff status if set to true
              diff_color = {
                -- Same color values as the general color option can be used here.
                added = 'Added', -- Changes the diff's added color
                modified = 'Changed', -- Changes the diff's modified color
                removed = 'Removed', -- Changes the diff's removed color you
              },
              symbols = { added = '+', modified = '~', removed = '-' }, -- Changes the symbols used by the diff.
              source = nil, -- A function that works as a data source for diff.
              -- It must return a table as such:
              --   { added = add_count, modified = modified_count, removed = removed_count }
              -- or nil on failure. count <= 0 won't be displayed.
            },
          },
        },
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      }

      vim.o.laststatus = 0
    end,
  },
}
