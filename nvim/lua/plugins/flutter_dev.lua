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
          exception_breakpoints = { "uncaught", 'raised', },
          register_configurations = function(_)
            if (not require("dap").configurations.dart) then
              require('utils.select_run_config').selectRunConfig()
            end
          end,
        },
        fvm = isFvmProject,
        lsp = {
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
            updateImportsOnRename = false,
            closingLabels = false,
            analysisExcludedFolders = { vim.fn.expand("$HOME/fvm"), ".fvm", },
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
