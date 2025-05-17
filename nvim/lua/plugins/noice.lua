return {
  {
    'rcarriga/nvim-notify',
    config = function()
      require('notify').setup {
        background_colour = '#000000',
        render = 'minimal',
        top_down = false,
        animate = false,
        timeout = 500,
      }
    end,
  },
  {
    'folke/noice.nvim',
    enabled = false,
    dependencies = {
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
    },
    config = function()
      require('noice').setup {
        notify = { enabled = false },
        messages = { enabled = false },
        popupmenu = { enabled = false },
      }
    end,
  },
}
