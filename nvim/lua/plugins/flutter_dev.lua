-- Define a function to check if the CWD contains "project-name"

return {
  {
    'akinsho/flutter-tools.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    event = 'VeryLazy',
    config = function()
      local isSpecial = IsFvmProject()
      local ft = require("flutter-tools");

      ft.setup({
        closing_tags = { enabled = false, },
        decorations = {
          statusline = {
            app_version = false,
            device = true,
            project_config = true,
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
            require("dap").configurations.dart = {
            }

            if (isSpecial) then
              require("dap.ext.vscode").load_launchjs(vim.fn.getcwd() .. '/.vscode/launch.json')
            else
              require("dap.ext.vscode").load_launchjs(vim.fn.getcwd() .. '/.vscode/launch.nvim.json')
            end
          end,
          -- register_configurations = function(paths)
          --   require("dap").configurations.dart = {
          --     {
          --       type = "dart",
          --       request = "launch",
          --       name = "Launch flutter",
          --       dartSdkPath = paths.dart_sdk,
          --       flutterSdkPath = paths.flutter_sdk,
          --       program = "${workspaceFolder}/lib/main.dart",
          --       cwd = "${workspaceFolder}",
          --     },
          --     {
          --       type = "dart",
          --       request = "attach",
          --       name = "Connect flutter",
          --       dartSdkPath = paths.dart_sdk,
          --       flutterSdkPath = paths.flutter_sdk,
          --       program = "${workspaceFolder}/lib/main.dart",
          --       cwd = "${workspaceFolder}",
          --     },
          --   }
          -- end,
        },
        fvm = (isSpecial and true or false),
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
            lineLength = (isSpecial and 80 or 120),
            showTodos = false,
            completeFunctionCalls = true,
            analysisExcludedFolders = {
              "/Users/mike/fvm/versions/stable/packages",
              "/Users/mike/fvm/versions/",
            },
            renameFilesWithClasses = "prompt", -- "always"
            enableSnippets = true,
            updateImportsOnRename = true,
          },
        }
      })
      require("telescope").load_extension("flutter")
    end,
  },
}
