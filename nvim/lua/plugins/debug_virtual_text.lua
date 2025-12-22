return {
  'theHamsta/nvim-dap-virtual-text',

  dependencies = { 'mfussenegger/nvim-dap' },
  enabled = false,
  config = function()
    require('nvim-dap-virtual-text').setup {
      show_stop_reason = false,
    }
  end,
}
