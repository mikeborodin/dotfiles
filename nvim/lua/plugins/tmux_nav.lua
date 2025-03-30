return {
  {
    'alexghergh/nvim-tmux-navigation',
    config = function()
      require('nvim-tmux-navigation').setup {
        keybindings = {
          left = '<C-t>n',
          down = '<C-t>e',
          up = '<C-t>u',
          right = '<C-t>i',
          last_active = '<C-\\>',
          next = '<C-\\>',
        },
      }
    end,
  },
}
