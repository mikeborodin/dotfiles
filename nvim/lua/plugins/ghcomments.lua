return {
  'dlvhdr/gh-addressed.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'folke/trouble.nvim',
  },
  cmd = 'GhReviewComments',
  keys = {
    { '<space>gc', '<cmd>GhReviewComments<cr>', desc = 'GitHub Review Comments' },
  },
}
