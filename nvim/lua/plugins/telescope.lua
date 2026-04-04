return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      'nvim-telescope/telescope-dap.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install',
      },
    },
    keys = {
      -- Registered here so lazy.nvim loads telescope on first press (no double-press needed)
      {
        '<D-e>',
        function() require('telescope.builtin').find_files() end,
        desc = 'Find files',
      },
      {
        '<D-f>',
        function() require('telescope.builtin').live_grep() end,
        desc = 'Search in project',
      },
      {
        '<space>fw',
        '<cmd>Telescope current_buffer_fuzzy_find<cr>',
        desc = 'Find in buffer',
      },
      {
        '<space>ab',
        '<cmd>Telescope buffers<cr>',
        desc = 'List buffers',
      },
      {
        'ah',
        '<cmd>Telescope diagnostics<cr>',
        desc = 'Workspace diagnostics',
      },
      {
        '<space>ts',
        '<cmd>Telescope git_status<cr>',
        desc = 'Git status',
      },
      {
        '<space>re',
        '<cmd>Telescope resume<cr>',
        desc = 'Resume search',
      },
      {
        '<space>b',
        '<cmd>Telescope git_branches<cr>',
        desc = 'Git branches',
      },
      {
        '<space>fF',
        function() require('telescope.builtin').find_files { cwd = vim.fn.getcwd() } end,
        desc = 'Find files (cwd)',
      },
      {
        '<space>fR',
        function() require('telescope.builtin').oldfiles { cwd = vim.uv.cwd() } end,
        desc = 'Recent files',
      },
    },
    opts = function()
      local actions = require 'telescope.actions'

      local open_with_trouble = function(...)
        return require('trouble.providers.telescope').open_with_trouble(...)
      end
      local open_selected_with_trouble = function(...)
        return require('trouble.providers.telescope').open_selected_with_trouble(...)
      end
      local find_files_no_ignore = function()
        local action_state = require 'telescope.actions.state'
        local line = action_state.get_current_line()
        require('telescope.builtin').find_files { no_ignore = true, default_text = line }
      end
      local find_files_with_hidden = function()
        local action_state = require 'telescope.actions.state'
        local line = action_state.get_current_line()
        require('telescope.builtin').find_files { hidden = true, default_text = line }
      end
      local telescope = require 'telescope'

      local ignored_folders = {
        '.git',
        'build',
        'node_modules',
        'dist',
        'venv',
        '.fvm',
        '.devbox',
        '.dart-tool',
        'ios/Pods',
        'macos/Pods',
        'macos/build',
        'ios/build',
        '.venv',
        '.idea',
        '.pub-cache',
        'simulator/src',
      }

      local fd_command = {
        'fd',
        '--type', 'f',
        '--hidden',         -- include dotfiles (.env, .fvmrc, etc.)
        '--no-ignore-vcs',  -- ignore .gitignore so gitignored files (e.g. .env) are findable
                            -- but .fdignore / .ignore files per-project still apply
      }

      for _, folder in ipairs(ignored_folders) do
        table.insert(fd_command, '--exclude')
        table.insert(fd_command, folder)
      end

      return {
        pickers = {
          live_grep = {
            additional_args = function(_)
              local args = { '--hidden', '--no-ignore-vcs' }
              for _, folder in ipairs(ignored_folders) do
                table.insert(args, '--glob')
                table.insert(args, '!**/' .. folder .. '/*')
              end
              return args
            end,
          },
          find_files = {
            fd_command = fd_command,
          },
        },
        defaults = {
          -- Nvim 0.12 async treesitter parsing can crash on short-lived preview
          -- buffers (the injections parse is scheduled via vim.schedule, but by
          -- the time it runs the buffer may already be stale/reused). Disabling
          -- treesitter in the previewer avoids this entirely; syntax highlighting
          -- still works via the regex engine fallback.
          preview = {
            treesitter = false,
          },
          sorting_strategy = 'ascending',
          layout_strategy = 'vertical',
          layout_config = {
            vertical = {
              prompt_position = 'top',
              mirror = true,        -- prompt+results on top, preview on bottom
              width = 0.8,
              height = 0.9,
              preview_height = 0.6, -- preview gets 60% of picker height
              preview_cutoff = 0,   -- always show preview regardless of window height
            },
          },
          prompt_prefix = ' ',
          selection_caret = ' ',
          -- open files in the first window that is an actual file.
          -- use the current window if no other window is available.
          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == '' then
                return win
              end
            end
            return 0
          end,
          mappings = {
            i = {
              -- ["<c-t>"] = open_with_trouble,
              -- ["<a-t>"] = open_selected_with_trouble,
              ['<a-i>'] = find_files_no_ignore,
              ['<a-h>'] = find_files_with_hidden,
              -- ["<C-Down>"] = actions.cycle_history_next,
              -- ["<C-Up>"] = actions.cycle_history_prev,
              -- ["<C-f>"] = actions.preview_scrolling_down,
              -- ["<C-b>"] = actions.preview_scrolling_up,
            },
            n = {
              ['q'] = actions.close,
            },
          },
        },
      }
    end,

    config = function(_, opts)
      require('telescope').setup(opts)
      require('telescope').load_extension 'dap'
      require('telescope').load_extension 'fzf'

      -- if vim.g.x_is_flutter_project then
      --   require('telescope').load_extension 'flutter'
      -- end
    end,
  },
}
