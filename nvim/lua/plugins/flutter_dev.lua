return {
  {
    'akinsho/flutter-tools.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim',
    },
    config = function()
      local isFvmProject = IsFvmProject()

      require("flutter-tools").setup({
        closing_tags = { enabled = false, },
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
          open_cmd = "tabedit",  -- command to use to open the log buffer
        },
        debugger = {
          enabled = true,
          run_via_dap = true,
          exception_breakpoints = { 'raised', },
          register_configurations = function(_)
            if (not require("dap").configurations.dart) then
              require('utils.select_run_config').selectRunConfig()
            end
          end,
        },
        fvm = isFvmProject,
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
            virtual_text_str = "■",
          },
          settings = {
            lineLength = (isFvmProject and 80 or 120),
            showTodos = false,
            enableSnippets = false,
            updateImportsOnRename = true,
            closingLabels = false,
            analysisExcludedFolders = {
              vim.fn.expand(".fvm"),
              vim.fn.expand("$HOME/fvm"),
              ".fvm",
              vim.fn.expand("$HOME/.pub-cache"),
            },
            flutterOutline = false,
            outline = false,
            -- enableSdkFormatter = false,
            includeDependenciesInWorkspaceSymbols = false,
            onlyAnalyzeProjectsWithOpenFiles = true,
            completeFunctionCalls = true,
            checkForSdkUpdates = false,
            suggestFromUnimportedLibraries = true,
            projectSearchDepth = 1,
            documentation = "full",
          },
        }
      })
    end,
  },
}
