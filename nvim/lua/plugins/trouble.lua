return {
  'folke/trouble.nvim',
  branch = 'main',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    update_diagnostics_loclist = function()
      require 'notify' 'diagnostics updated'
    end

    vim.api.nvim_command [[autocmd! User LspDiagnosticsChanged lua update_diagnostics_loclist()]]
    require('trouble').setup {}
  end,
}
