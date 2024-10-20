vim.g.selectedFlutterDevice = 'none'

return {
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      local function statusMode()
        return vim.g.selectedFlutterDevice
      end
      local function runConfig()
        return vim.g.selected_run_config.name
      end

      require('lualine').setup({
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = '',
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', },
          lualine_c = { runConfig, statusMode },

          lualine_x = {},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {
          lualine_c = {
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
                readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
                unnamed = '[no-name]', -- Text to show for unnamed buffers.
                newfile = '[new]',     -- Text to show for newly created file before first write
              }
            },
          },
          lualine_x = {
            'diagnostics'
          }
        },
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      })
    end

  }
}
