return {
  {
    'folke/noice.nvim',
    -- enabled = false,
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('noice').setup {
        notify = { enabled = false },
        messages = { enabled = false },
        popupmenu = { enabled = false },
      }
    end,
  },
  {
    'grapp-dev/nui-components.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
  },
  {
    'mrcjkb/rustaceanvim',
    enabled = false,
    version = '^5', -- Recommended
    -- lazy = false, -- This plugin is already lazy
  },
  {
    'akinsho/toggleterm.nvim',
    -- enabled = true,
    config = function()
      require('toggleterm').setup {
        open_mapping = '<Char-0xA5>',
        direction = 'float',
        shell = function()
          if vim.env.DEVBOX_PROJECT_ROOT == vim.loop.cwd() then
            return 'devbox run shell'
          else
            return 'nu'
          end
        end,
      }
    end,
  },
  -- Treesitter is a new parser generator tool that we can
  -- use in Neovim to power faster and more accurate
  -- syntax highlighting.
  {
    'nvim-treesitter/nvim-treesitter',
    version = false, -- last release is way too old and doesn't work on Windows
    -- enabled = true,
    -- enabled = false,
    build = ':TSUpdate',
    event = { 'VeryLazy' },
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        -- { 'nushell/tree-sitter-nu', build = ':TSUpdate nu' },
        -- {
        --   'LhKipp/nvim-nu',
        --   build = ':TSInstall nu',
        --   opts = {},
        -- },
      },
    },
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    keys = {
      { '=', desc = 'Increment selection' },
      { '<bs>', desc = 'Decrement selection', mode = 'x' },
    },
    opts = {
      ensure_installed = { 'dart', 'bruno', 'nu' },
      auto_install = vim.fn.executable 'tree-sitter' == 1, -- only enable auto install if `tree-sitter` cli is installed
      highlight = { enable = true },
      incremental_selection = { enable = true },
      -- parser_install_dir = vim.fn.stdpath('data') .. '/parsers', -- Optional custom parser location
      indent = { enable = true },
      -- ignore_install = { "dart" },
      textobjects = {
        disable = { 'dart' },
        -- select = {
        --   enable = true,
        --   lookahead = true,
        --   keymaps = {
        --     ["ak"] = { query = "@block.outer", desc = "around block" },
        --     ["ik"] = { query = "@block.inner", desc = "inside block" },
        --     ["ac"] = { query = "@class.outer", desc = "around class" },
        --     ["ic"] = { query = "@class.inner", desc = "inside class" },
        --     ["a?"] = { query = "@conditional.outer", desc = "around conditional" },
        --     ["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
        --     ["af"] = { query = "@function.outer", desc = "around function " },
        --     ["if"] = { query = "@function.inner", desc = "inside function " },
        --     ["ao"] = { query = "@loop.outer", desc = "around loop" },
        --     ["io"] = { query = "@loop.inner", desc = "inside loop" },
        --     ["aa"] = { query = "@parameter.outer", desc = "around argument" },
        --     ["ia"] = { query = "@parameter.inner", desc = "inside argument" },
        --   },
        -- },
        -- move = {
        --   enable = true,
        --   set_jumps = true,
        --   goto_next_start = {
        --     ["]k"] = { query = "@block.outer", desc = "Next block start" },
        --     ["]f"] = { query = "@function.outer", desc = "Next function start" },
        --     ["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
        --   },
        --   goto_next_end = {
        --     ["]K"] = { query = "@block.outer", desc = "Next block end" },
        --     ["]F"] = { query = "@function.outer", desc = "Next function end" },
        --     ["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
        --   },
        --   goto_previous_start = {
        --     ["[k"] = { query = "@block.outer", desc = "Previous block start" },
        --     ["[f"] = { query = "@function.outer", desc = "Previous function start" },
        --     ["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
        --   },
        --   goto_previous_end = {
        --     ["[K"] = { query = "@block.outer", desc = "Previous block end" },
        --     ["[F"] = { query = "@function.outer", desc = "Previous function end" },
        --     ["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
        --   },
        -- },
        -- swap = {
        --   enable = true,
        --   swap_next = {
        --     [">K"] = { query = "@block.outer", desc = "Swap next block" },
        --     [">F"] = { query = "@function.outer", desc = "Swap next function" },
        --     [">A"] = { query = "@parameter.inner", desc = "Swap next argument" },
        --   },
        --   swap_previous = {
        --     ["<K"] = { query = "@block.outer", desc = "Swap previous block" },
        --     ["<F"] = { query = "@function.outer", desc = "Swap previous function" },
        --     ["<A"] = { query = "@parameter.inner", desc = "Swap previous argument" },
        --   },
        -- },
      },
    },
    config = function(_, opts)
      -- if type(opts.ensure_installed) == "table" then
      --   local added = {}
      --   opts.ensure_installed = vim.tbl_filter(function(lang)
      --     if added[lang] then
      --       return false
      --     end
      --     added[lang] = true
      --     return true
      --   end, opts.ensure_installed)
      -- end

      local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
      parser_config.bruno = {
        install_info = {
          url = 'https://github.com/Scalamando/tree-sitter-bruno', -- local path or git repo
          files = { 'src/parser.c', 'src/scanner.c' }, -- note that some parsers also require src/scanner.c or src/scanner.cc
          branch = 'main', -- default branch in case of git repo if different from master
          generate_requires_npm = false, -- if stand-alone parser without npm dependencies
          requires_generate_from_grammar = true, -- if folder contains pre-generated src/parser.c
        },
        -- filetype = "bruno",                                        -- if filetype does not match the parser name
      }
      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  -- Show context of the current function
  {
    'nvim-treesitter/nvim-treesitter-context',
    -- event = 'VeryLazy',
    -- enabled = true,
    -- enabled = false,
    opts = { mode = 'cursor' },
    keys = {
      {
        '<space>ut',
        function()
          local Util = require 'lazyvim.util'
          local tsc = require 'treesitter-context'
          tsc.toggle()
          if Util.inject.get_upvalue(tsc.toggle, 'enabled') then
            Util.info('Enabled Treesitter Context', { title = 'Option' })
          else
            Util.warn('Disabled Treesitter Context', { title = 'Option' })
          end
        end,
        desc = 'Toggle Treesitter Context',
      },
    },
  },
  {
    'nvim-treesitter/playground',
  },
  {
    'vim-test/vim-test',
    config = function()
      vim.cmd [[
         let g:test#strategy = "toggleterm"

         function! FvmTransform(cmd) abort
            return ''.a:cmd
         endfunction
        let g:test#custom_transformations = {'fvm': function('FvmTransform')}
        let g:test#transformation = 'fvm'
        ]]
    end,
  },
  {
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
  },
}
