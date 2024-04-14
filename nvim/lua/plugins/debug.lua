return {
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    'rcarriga/nvim-dap-ui',
    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'nvim-neotest/nvim-nio',
  },

  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    vim.fn.sign_define('DapBreakpoint', { text = '🔥', texthl = '', linehl = '', numhl = '', })
    vim.fn.sign_define('DapStopped', { text = '👉', texthl = '', linehl = 'DiffText', numhl = '', })
    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,
      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
      },
    }

    -- You can provide additional configuration to the handlers,
    -- see mason-nvim-dap README for more information
    -- require('mason-nvim-dap').setup_handlers()

    -- Basic debugging keymaps, feel free to change to your liking!
    -- todo
    -- vim.keymap.set('n', 'tb', dap.toggle_breakpoint)
    -- vim.keymap.set('n', 'sin', dap.continue)
    vim.keymap.set('n', '<F1>', dap.step_into)
    vim.keymap.set('n', '<F2>', dap.step_over)
    vim.keymap.set('n', '<F3>', dap.step_out)
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end)
    vim.keymap.set('n', 'se', function()
      require('dap.ui.variables').hover(function() vim.fn.expand('<cexpr>') end)
    end)

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
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
          -- You can change the order of elements in the sidebar
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

    dap.listeners.after.event_initialized['dapui_config'] = function()
      -- require('notify')('dap inited')
      -- dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    -- require('dap-go').setup()
  end,
}
