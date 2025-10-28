return {
  {
    'folke/noice.nvim',
    enabled = true,
    dependencies = {
      'MunifTanjim/nui.nvim',
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
