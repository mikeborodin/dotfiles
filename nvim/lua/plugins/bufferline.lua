return {
  {
    'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup {
        override = {
          dart = {
            icon = '',
            color = '#1E88E5',
            name = 'Dart',
          },
        },
      }
    end,
  },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    enabled = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('bufferline').setup {
        options = {
          show_buffer_close_icons = false,
          close_command = 'Bdelete! %d',
          move_wraps_at_ends = true,
          max_name_length = 28,
          always_show_bufferline = true,
          indicator = {
            style = 'none',
          },
          offsets = {
            { filetype = 'neo-tree', text = '', padding = 1 },
          },
        },
      }
    end,
  },
}
