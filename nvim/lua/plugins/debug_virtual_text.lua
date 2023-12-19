return {
  'theHamsta/nvim-dap-virtual-text',
  config = function()
    require("nvim-dap-virtual-text").setup {
      show_stop_reason = false,
    }
  end,
}
