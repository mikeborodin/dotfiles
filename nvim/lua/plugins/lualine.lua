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
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', },
          lualine_c = { runConfig, statusMode },

          lualine_x = { 'diagnostics' },
          lualine_y = {},
          lualine_z = {}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      })
    end
  }
}
