return {
  'stevearc/aerial.nvim',
  enabled = false,
  config = function()
    require('aerial').setup {
      default_direction = 'prefer_left',
      on_attach = function(bufnr)
        vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
        vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
      end,
    }
  end,
}
