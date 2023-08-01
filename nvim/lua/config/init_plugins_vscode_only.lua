vim.g.mapleader = 't'
vim.g.maplocalleader = 't'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup({
        toggler = {
          ---Line-comment toggle keymap
          line = '<leader>l',
          ---Block-comment toggle keymap
          block = '<leader>j',
        },
        opleader = {
          ---Line-comment keymap
          line = '<leader>l',
          ---Block-comment keymap
          block = '<leader>j',
        },
      })
    end
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
}, {})
