return {
  'folke/zen-mode.nvim',
  keys = {
    {
      '<space>z',
      mode = { 'n', 'v' },
      '<cmd>Zen<cr>',
      desc = 'Enter Zen',
    },
  },
  opts = {
    kitty = {
      enabled = true,
      font = '+4',
    },
  },
}
