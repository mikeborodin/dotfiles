return {
  {
    'm00qek/baleia.nvim',
    config = function()
      vim.g.baleia = require('baleia').setup { log = 'INFO', line_starts_at = 6 }
      vim.api.nvim_create_autocmd('BufWinEnter', {
        pattern = '__FLUTTER_DEV_LOG__',
        callback = function()
          -- vim.o.modifiable = true
          vim.g.baleia.automatically(vim.api.nvim_get_current_buf())
        end,
      })
      vim.api.nvim_create_user_command('BaleiaLogs', vim.g.baleia.logger.show, { bang = true })
    end,
  },
  {
    'nvim-flutter/flutter-tools.nvim',
    lazy = not vim.g.x_is_flutter_project,
    event = { 'VeryLazy' },
    -- enabled      = vim.g.x_is_flutter_project,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim',
    },
    config = function()
      -- local isFvmProject = IsFvmProject()
      require('flutter-tools').setup {
        closing_tags = { enabled = false },
        decorations = {
          statusline = {
            app_version = false,
            device = false,
            project_config = false,
          },
        },
        dev_log = {
          enabled = false,
          notify_errors = false, -- if there is an error whilst running then notify the user
          open_cmd = 'tabedit',  -- command to use to open the log buffer
        },
        debugger = {
          enabled = true,
          run_via_dap = true,
          exception_breakpoints = {},
          evaluate_to_string_in_debug_views = true,
          register_configurations = function(_)
            require('dap').configurations.dart = require('utils.select_run_config').selectRunConfig()
            -- require('dap').configurations.dart = { {
            --   type = "dart",
            --   request = "launch",
            --   name = "launch main.dart",
            --   program = "${workspaceFolder}/lib/main.dart",
            --   toolArgs = {
            --     vim.g.x_is_flutter_project and '--no-start-paused' or nil
            --   },
            --   cwd = "${workspaceFolder}",
            -- } }
          end,
        },
        fvm = true,
        -- LSP settings kept minimal: dartls is started by vim.lsp.enable('dartls')
        -- via lsp/dartls.lua. When flutter-tools calls vim.lsp.start() on FlutterRun,
        -- it will reuse the already-running dartls client (same name + root_dir).
        lsp = {
          color = { enabled = false },
        },
      }
      -- flutter-tools defers command registration (FlutterRun, etc.) until a
      -- *.dart / pubspec.yaml BufEnter. For Flutter projects we want those
      -- commands available immediately, so call setup_project() which triggers
      -- the same internal start() without needing a buffer.
      if vim.g.x_is_flutter_project then
        require('flutter-tools').setup_project({})
      end
    end,
  },
}
