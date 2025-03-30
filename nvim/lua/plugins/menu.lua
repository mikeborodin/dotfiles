return {
  'nvchad/menu',
  dependencies = { 'nvchad/volt', lazy = true },
  lazy = true,
  config = function()
    -- mouse users + nvimtree users!
    vim.keymap.set('n', '<RightMouse>', function()
      vim.cmd.exec '"normal! \\<RightMouse>"'

      local options = vim.bo.ft == 'NvimTree' and 'nvimtree' or 'default'
      require('menu').open(options, { mouse = true })
    end, {})
    require('menu').setup()
  end,
}
