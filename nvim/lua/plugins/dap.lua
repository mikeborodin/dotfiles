vim.fn.sign_define('DapBreakpoint',
  { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition',
  { text = 'ﳁ', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected',
  { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
vim.fn.sign_define('DapLogPoint',
  { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapBreakpoint', linehl = 'DiffText', numhl = '' })


return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'nvim-neotest/nvim-nio',
  },

  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#FF5555', bg = '' })


    require('mason-nvim-dap').setup {
      automatic_setup = true,
      ensure_installed = {},
    }

    vim.keymap.set('n', 'sst', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint Condition: ')
    end)
    vim.keymap.set('n', 'se', function()
      require('dap.ui.variables').hover(function() vim.fn.expand('<cexpr>') end)
    end)


    require("dap").adapters.dart = {
      type = "executable",
      command = "dart",
      name = "dart",
      args = { 'debug_adapter' }
    }

    dap.configurations.dart = {
      {
        type = "dart",
        request = "launch main.dart",
        name = "launch main.dart",
        program = "${workspaceFolder}/lib/main.dart",
        cwd = "${workspaceFolder}",
        args = {},
        runInTerminal = true,
      },
    }
    -- require('fidget').notify('sat dart launch main')

    dapui.setup {
      mappings = {
        edit = "E",
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t"
      },
      layouts = {
        {
          elements = {
            -- Provide IDs as strings or tables with "id" and "size" keys
            -- {
            --   id = "scopes",
            --   size = 0.25, -- Can be float or integer > 1
            -- },
            -- { id = "breakpoints", size = 0.25 },
            -- { id = "stacks",      size = 0.25 },
            -- { id = "watches",     size = 0.25 },
            -- "console",
            "repl",
          },
          size = 40,
          position = "bottom", -- Can be "left" or "right"
        },
        -- {
        --   elements = {
        --     "repl",
        --     "console",
        --   },
        --   size = 10,
        --   position = "bottom", -- Can be "bottom" or "top"
        -- },
      },
      icons = {
        expanded = '',
        collapsed = '',
        current_frame = '',
      },
      controls = {
        element = "repl",
        enabled = false,
        icons = {
          disconnect = "",
          pause = "",
          play = "",
          run_last = "",
          step_back = "",
          step_into = "",
          step_out = "",
          step_over = "",
          terminate = ""
        }
      },
    }

    -- dap.listeners.after.event_initialized['dapui_config'] = function()
    --   dapui.open()
    -- end
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
  end,
}
