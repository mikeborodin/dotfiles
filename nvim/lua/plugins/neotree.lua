local Util = require 'lazyvim.util'

require 'utils.table_to_string'

vim.g.neotree_autoclose = false

function NeotreeAutocloseToggle()
  vim.g.neotree_autoclose = not vim.g.neotree_autoclose
end

function TableToString(tbl, indent)
  local result = {}
  indent = indent or 0

  for k, v in pairs(tbl) do
    local key = tostring(k)
    local value = type(v) == 'table' and TableToString(v, indent + 1) or tostring(v)

    result[#result + 1] = string.rep('  ', indent) .. key .. ' = ' .. value
  end

  return '{\n' .. table.concat(result, ',\n') .. '\n' .. string.rep('  ', indent - 1) .. '}'
end

return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
      -- "DaikyXendo/nvim-material-icon",
    },
    lazy = false,
    init = function()
      if vim.fn.argc(-1) == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == 'directory' then
          require 'neo-tree'
        end
      end
    end,
    deactivate = function()
      vim.cmd [[Neotree close]]
    end,
    keys = {
      {
        '<space>ge',
        function()
          require('neo-tree.command').execute { source = 'git_status', toggle = true }
        end,
        desc = 'Git explorer',
      },
      {
        'tf',
        '<cmd>Neotree reveal<cr>',
        desc = 'Explorer NeoTree (cwd)',
      },
    },
    opts = {
      event_handlers = {

        {
          event = 'file_open_requested',
          handler = function()
            if vim.g.neotree_autoclose then
              require('neo-tree.command').execute { action = 'close' }
            end
          end,
        },
        {
          event = 'neo_tree_buffer_enter',
          handler = function()
            -- vim.cmd("highlight! Cursor blend=100")
          end,
        },
        {
          event = 'neo_tree_buffer_leave',
          handler = function()
            -- vim.cmd("highlight! Cursor guibg=#5f87af blend=0")
          end,
        },
      },
      sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols' },
      open_files_do_not_replace_types = { 'terminal', 'Trouble', 'qf', 'Outline' },
      filesystem = {
        follow_current_file = { enabled = false },
        use_libuv_file_watcher = true,
        bind_to_cwd = false,
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          never_show = {
            '.DS_Store',
            'thumbs.db',
            'node_modules',
            '.dart_tool',
            '.flutter_plugins',
            '.flutter_plugin_dependencies',
          },
        },
      },
      default_component_configs = {
        diagnostics = {
          symbols = {
            hint = "H",
            info = "I",
            warn = "!",
            error = "X",
          },
          highlights = {
            hint = "DiagnosticSignHint",
            info = "DiagnosticSignInfo",
            warn = "DiagnosticSignWarn",
            error = "DiagnosticSignError",
          },
        },
        file_size = { enabled = false },
        indent = {
          indent_size = 2,
          padding = 1, -- extra padding on left hand side
          -- indent guides
          with_markers = false,
          indent_marker = ' ',
          last_indent_marker = ' ',
          highlight = 'NeoTreeIndentMarker',
          -- expander config, needed for nesting files
          with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
        git_status = {
          symbols = {
            -- Change type
            added = '',    -- or "✚", but this is redundant info if you use git_status_colors on the name
            modified = '', -- or "", but this is redundant info if you use git_status_colors on the name
            deleted = '',  -- this can only be used in the git_status source
            renamed = '',  -- this can only be used in the git_status source
            -- Status type
            untracked = '',
            ignored = '',
            unstaged = '',
            staged = '',
            conflict = '',
          },
        },
      },
      window = {
        position = 'left',
        width = 50,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ['<space>'] = {
            'toggle_node',
            nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
          },
          ['<2-LeftMouse>'] = 'open',
          ['<cr>'] = 'open',
          ['<esc>'] = 'revert_preview',
          ['P'] = { 'toggle_preview', config = { use_float = true } },
          ['l'] = 'focus_preview',
          ['S'] = 'open_split',
          ['s'] = 'open_vsplit',
          -- ["S"] = "split_with_window_picker",
          -- ["s"] = "vsplit_with_window_picker",
          --["t"] = "open_tabnew",
          ['t'] = 'noop',
          -- ["<cr>"] = "open_drop",
          -- ["t"] = "open_tab_drop",
          --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
          ['C'] = 'close_node',
          -- ['C'] = 'close_all_subnodes',
          ['z'] = 'close_all_nodes',
          --["Z"] = "expand_all_nodes",
          ['a'] = {
            'add',
            -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
            -- some commands may take optional config options, see `:h neo-tree-mappings` for details
            config = {
              show_path = 'none', -- "none", "relative", "absolute"
            },
          },
          ['A'] = 'add_directory', -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
          ['d'] = 'delete',
          ['r'] = 'rename',
          ['y'] = 'copy_to_clipboard',
          ['x'] = 'cut_to_clipboard',
          ['p'] = 'paste_from_clipboard',
          ['c'] = 'copy',
          -- takes text input for destination, also accepts the optional config.show_path option like "add":
          -- ["c"] = {
          --  "copy",
          --  config = {
          --    show_path = "none" -- "none", "relative", "absolute"
          --  }
          --}
          ['m'] = 'move',
          ['q'] = 'close_window',
          ['R'] = 'refresh',
          ['?'] = 'show_help',
          ['<'] = 'prev_source',
          ['>'] = 'next_source',
          ['e'] = 'noop',
          ['u'] = 'noop',
          ['i'] = 'open',
          ['n'] = 'close_node',
          ['.'] = 'toggle_hidden',
          ['w'] = 'copy_relative_path',
          ['T'] = 'open_terminal_in_folder',
          ['o'] = 'open_yazi',
        },
      },
      commands = {
        --idea paste image using png paste
        copy_relative_path = function(state)
          local node = state.tree:get_node()
          -- print(node.name)
          local absolutePath = node.path
          local cwd = vim.loop.cwd()
          local relative_path = absolutePath:gsub(cwd .. '/', '')
          vim.fn.setreg('+', relative_path)
          require 'notify' ('copied ' .. relative_path)
        end,
        create_test_file = function(state)
          local node = state.tree:get_node()
          local absolutePath = node.path
          local cwd = vim.loop.cwd()
          local relative_path = absolutePath:gsub(cwd .. '/', '')
          vim.fn.setreg('+', relative_path)

          require 'notify' ('copied ' .. relative_path)
        end,
        open_terminal_in_folder = function(state)
          local node = state.tree:get_node()
          -- print(node.name)
          local absolutePath = node.path
          local cwd = vim.loop.cwd()
          local relative_path = absolutePath:gsub(cwd .. '/', '')
          -- vim.fn.setreg('+', relative_path)
          vim.cmd('ToggleTerm dir=' .. absolutePath)
        end,
        open_yazi = function(state)
          local node = state.tree:get_node()
          local absolutePath = node.path

          require('yazi').yazi({}, absolutePath)
        end,
      },
    },
    config = function(_, opts)
      vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]

      local function on_move(data)
        Util.lsp.on_rename(data.source, data.destination)
      end
      local events = require 'neo-tree.events'
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED,   handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })

      require('neo-tree').setup(opts)
    end,
  },
}
