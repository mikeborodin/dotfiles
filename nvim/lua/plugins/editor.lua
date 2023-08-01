return {
  {
    'lukas-reineke/indent-blankline.nvim',
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },
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
  --todo
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  {
    "EthanJWright/vs-tasks.nvim",
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim'
    },
    config = function()
      require("vstask").setup()
    end
  }

}
