return {
  {
    'grapp-dev/nui-components.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
  },
  {
    'akinsho/toggleterm.nvim',
    -- enabled = true,
    config = function()
      require('toggleterm').setup {
        -- open_mapping handled manually below for instant show/hide
        direction = 'float',
        shell = function()
          if vim.env.DEVBOX_PROJECT_ROOT == vim.loop.cwd() then
            return 'devbox run shell'
          else
            return 'nu'
          end
        end,
      }

      -- Instead of toggling (destroy/recreate float), keep the window alive
      -- and just hide/show it. First open still spawns the shell; subsequent
      -- toggles are instant because the window is never destroyed.
      local term_win = nil
      local function smart_toggle()
        local Terminal = require('toggleterm.terminal').Terminal
        local terms = require('toggleterm.terminal').get_all(true)
        local t = terms[1]
        if not t then
          -- First open: create and open normally
          t = Terminal:new({ hidden = false })
          t:open()
          term_win = t.window
          return
        end
        if term_win and vim.api.nvim_win_is_valid(term_win) then
          -- Window is visible: hide it without closing
          vim.api.nvim_win_hide(term_win)
          term_win = nil
        else
          -- Window was hidden: re-open (reuses existing buffer/process)
          t:open()
          term_win = t.window
        end
      end

      vim.keymap.set({ 'n', 'v', 'i', 't' }, '<D-h>', smart_toggle, { desc = 'Toggle terminal' })
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
    event = { 'BufReadPost', 'BufNewFile' },
    ft = { 'dart', 'lua', 'nu', 'json', 'yaml', 'markdown', 'bash', 'toml', 'bruno' },
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
      { '=',    desc = 'Increment selection' },
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
      local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
      parser_config.bruno = {
        install_info = {
          url = 'https://github.com/Scalamando/tree-sitter-bruno', -- local path or git repo
          files = { 'src/parser.c', 'src/scanner.c' },             -- note that some parsers also require src/scanner.c or src/scanner.cc
          branch = 'main',                                         -- default branch in case of git repo if different from master
          generate_requires_npm = false,                           -- if stand-alone parser without npm dependencies
          requires_generate_from_grammar = true,                   -- if folder contains pre-generated src/parser.c
        },
        -- filetype = "bruno",                                        -- if filetype does not match the parser name
      }
      require('nvim-treesitter.configs').setup(opts)

      -- nvim-treesitter/master's query_predicates.lua was written for the old
      -- iter_matches API where match[id] was a single TSNode. In nvim 0.12 the
      -- "all" behaviour became permanent: match[id] is now always TSNode[].
      -- Passing an array to get_node_text → get_range → node:range() crashes.
      -- Override the affected directives with 0.12-compatible versions.
      local ts_query = vim.treesitter.query
      local force_opts = { force = true, all = false }

      local html_script_type_languages = {
        importmap = 'json',
        module = 'javascript',
        ['application/ecmascript'] = 'javascript',
        ['text/ecmascript'] = 'javascript',
      }
      local non_filetype_aliases = {
        ex = 'elixir', pl = 'perl', sh = 'bash', uxn = 'uxntal', ts = 'typescript',
      }
      local function lang_from_info_string(alias)
        return vim.filetype.match { filename = 'a.' .. alias }
            or non_filetype_aliases[alias]
            or alias
      end

      ts_query.add_directive('set-lang-from-mimetype!', function(match, _, bufnr, pred, metadata)
        local nodes = match[pred[2]]
        local node = nodes and nodes[1]
        if not node then return end
        local val = vim.treesitter.get_node_text(node, bufnr)
        metadata['injection.language'] = html_script_type_languages[val]
            or vim.split(val, '/')[2]
            or val
      end, force_opts)

      ts_query.add_directive('set-lang-from-info-string!', function(match, _, bufnr, pred, metadata)
        local nodes = match[pred[2]]
        local node = nodes and nodes[1]
        if not node then return end
        local alias = vim.treesitter.get_node_text(node, bufnr):lower()
        metadata['injection.language'] = lang_from_info_string(alias)
      end, force_opts)

      ts_query.add_directive('downcase!', function(match, _, bufnr, pred, metadata)
        local id = pred[2]
        local nodes = match[id]
        local node = nodes and nodes[1]
        if not node then return end
        if not metadata[id] then metadata[id] = {} end
        local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ''
        metadata[id].text = text:lower()
      end, force_opts)

      -- Predicates also use match[id] as a single node; patch for safety.
      ts_query.add_predicate('nth?', function(match, _, _, pred)
        local nodes = match[pred[2]]
        local node = nodes and nodes[1]
        local n = tonumber(pred[3])
        if node and node:parent() and node:parent():named_child_count() > n then
          return node:parent():named_child(n) == node
        end
        return false
      end, { force = true })

      ts_query.add_predicate('kind-eq?', function(match, _, _, pred)
        local nodes = match[pred[2]]
        local node = nodes and nodes[1]
        if not node then return true end
        local types = { unpack(pred, 3) }
        return vim.tbl_contains(types, node:type())
      end, { force = true })
    end,
  },

  -- Show context of the current function
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = { mode = 'cursor' },
    keys = {
      {
        '<space>ut',
        function()
          require('treesitter-context').toggle()
        end,
        desc = 'Toggle Treesitter Context',
      },
    },
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
    -- Seamless navigation between neovim splits and kitty panes
    -- build hook installs the kitty kittens (navigate_kitty.py, relative_resize.py)
    'mrjones2014/smart-splits.nvim',
    lazy = false,
    build = './kitty/install-kittens.bash',
    opts = {
      multiplexer_integration = 'kitty',
      at_edge = 'stop',
    },
    config = function(_, opts)
      require('smart-splits').setup(opts)
      -- cmd+shift+n/i/e/u passed through by kitty when IS_NVIM is set
      -- neovim receives them as <D-n>/<D-i>/<D-e>/<D-u> (Colemak: n=left, i=right, e=down, u=up)
      vim.keymap.set('n', '<D-N>', require('smart-splits').move_cursor_left, { desc = 'Move to left split/pane' })
      vim.keymap.set('n', '<D-E>', require('smart-splits').move_cursor_down, { desc = 'Move to lower split/pane' })
      vim.keymap.set('n', '<D-U>', require('smart-splits').move_cursor_up, { desc = 'Move to upper split/pane' })
      vim.keymap.set('n', '<D-I>', require('smart-splits').move_cursor_right, { desc = 'Move to right split/pane' })
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
