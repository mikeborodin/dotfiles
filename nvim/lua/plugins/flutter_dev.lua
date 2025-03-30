return {
  {
    'nvim-flutter/flutter-tools.nvim',
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
          open_cmd = 'tabedit', -- command to use to open the log buffer
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
        lsp = {
          -- on_attach = custom_config.on_attach,
          -- capabilities = custom_config.capabilities,
          -- flags = custom_config.flags,
          -- handlers = custom_config.handlers,
          color = {
            enabled = false,
            background = false,
            background_color = nil,
            foreground = false,
            virtual_text = true,
            virtual_text_str = '■',
          },
          settings = {
            lineLength = 100,
            showTodos = false,
            enableSnippets = false,
            updateImportsOnRename = true,
            closingLabels = false,
            analysisExcludedFolders = {
              vim.fn.expand '.fvm',
              vim.fn.expand '$HOME/fvm',
              '.fvm',
              vim.fn.expand '$HOME/.pub-cache',
            },
            outline = {
              enabled = false,
            },
            -- enableSdkFormatter = false,
            includeDependenciesInWorkspaceSymbols = false,
            onlyAnalyzeProjectsWithOpenFiles = true,
            completeFunctionCalls = true,
            checkForSdkUpdates = false,
            suggestFromUnimportedLibraries = true,
            projectSearchDepth = 1,
            documentation = 'full',
            debugSdkLibraries = false,
            debugExternalLibraries = false,
            debugExternalPackageLibraries = false,
          },
        },
      }
    end,
  },
}
