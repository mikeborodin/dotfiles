return {
  {
    'lewis6991/hover.nvim',
    config = function()
      require("hover").setup {
        init = function()
          -- Require providers
          require("hover.providers.lsp")
          -- require('hover.providers.gh')
          -- require('hover.providers.gh_user')
          -- require('hover.providers.jira')
          -- require('hover.providers.man')
          -- require('hover.providers.dictionary')
        end,
        preview_opts = {
          border = 'rounded'
        },
        -- Whether the contents of a currently open hover window should be moved
        -- to a :h preview-window when pressing the hover keymap.
        preview_window = false,
        title = true
      }
      -- vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
    end
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
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  {
    'mg979/vim-visual-multi',
    config = function()

    end
  }

}
