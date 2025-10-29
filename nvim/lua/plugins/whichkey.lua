return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    win = {
      -- Show window in the center
      no_overlap = false, -- don’t cover the cursor
      padding = { 0, 10 }, -- top/bottom, left/right padding
      border = 'rounded', -- options: "none", "single", "double", "rounded"
      height = {min = 30,max = 30},
      title = false,
      zindex = 1000,
    },
    preset = 'modern',
    icons = { mappings = false },
  },
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show { global = false }
      end,
      desc = 'Buffer Local Keymaps (which-key)',
    },
  },
}
