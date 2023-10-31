return {
  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      "benfowler/telescope-luasnip.nvim",
      'nvim-telescope/telescope-dap.nvim',
    },
  },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  -- {
  --   'nvim-telescope/telescope-fzf-native.nvim',
  --   -- NOTE: If you are having trouble with this installation,
  --   --       refer to the README for telescope-fzf-native for more instructions.
  --   build = 'make',
  --   cond = function()
  --     return vim.fn.executable 'make' == 1
  --   end,
  --   config = function()
  --     -- [[ Configure Telescope ]]
  --     -- See `:help telescope` and `:help telescope.setup()`
  --     require('telescope').load_extension('dap');
  --     require('telescope').setup {
  --       pickers = {
  --         live_grep = {
  --           additional_args = function(opts)
  --             return { "--hidden" }
  --           end
  --         },
  --       },
  --       defaults = {
  --         file_ignore_patterns = { 'node_modules', '.git', },
  --         sorting_strategy = "ascending",
  --         layout_config = {
  --           prompt_position = "top",
  --         },
  --         mappings = {
  --           i = {
  --             ['<C-u>'] = false,
  --             ['<C-d>'] = false,
  --           },
  --         },
  --       },
  --     }
  --     -- Enable telescope fzf native, if installed
  --     pcall(require('telescope').load_extension, 'fzf')
  --     require('telescope').load_extension('luasnip')
  --     -- See `:help telescope.builtin`
  --   end
  -- },
}
