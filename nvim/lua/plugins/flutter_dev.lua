return {
  -- my plugins go here
  {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = function()
      local ft = require("flutter-tools");
      ft.setup({
        closing_tags = { enabled = false, },
        decorations = {
          statusline = {
            app_version = false,
            device = false,
            project_config = true,
          },
        },
        dev_log = {
          enabled = true,
          notify_errors = false, -- if there is an error whilst running then notify the user
          open_cmd = "edit",     -- command to use to open the log buffer
        },
        debugger = {
          enabled = true,
          run_via_dap = true,
          exception_breakpoints = { "uncaught", 'raised' },

          register_configurations = function(_)
            require("dap").configurations.dart = {}
            require("dap.ext.vscode").load_launchjs()
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
        lsp = {
          color = {
            enabled = true,
            background = true,
            background_color = nil,
            foreground = false,
            virtual_text = false,
            virtual_text_str = "■",
          },
        },
      })
      require("telescope").load_extension("flutter")
    end,
  },
}
