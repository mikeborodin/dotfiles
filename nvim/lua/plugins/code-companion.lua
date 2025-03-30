return {
  'olimorris/codecompanion.nvim',
  enabled = true,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'hrsh7th/nvim-cmp',
    'nvim-telescope/telescope.nvim',
    { 'stevearc/dressing.nvim', opts = {} },
  },
  config = function()
    require('codecompanion').setup {
      strategies = {
        chat = {
          adapter = 'llama3',
        },
        inline = {
          adapter = 'llama3',
        },
      },
      adapters = {
        openai = function()
          return require('codecompanion.adapters').extend('openai', {
            env = {
              api_key = 'cmd:op read op://personal/OpenAI/credential --no-newline',
            },
          })
        end,
        llama3 = function()
          return require('codecompanion.adapters').extend('ollama', {
            name = 'llama3',
            schema = {
              model = {
                default = 'llama3.1:latest',
              },
              num_ctx = {
                default = 16384,
              },
              num_predict = {
                default = -1,
              },
            },
          })
        end,
      },
      display = {
        chat = {
          -- Change the default icons
          icons = {
            pinned_buffer = ' ',
            watched_buffer = '👀 ',
          },

          -- Alter the sizing of the debug window
          debug_window = {
            ---@return number|fun(): number
            width = vim.o.columns - 5,
            ---@return number|fun(): number
            height = vim.o.lines - 2,
          },

          -- Options to customize the UI of the chat buffer
          window = {
            layout = 'float', -- float|vertical|horizontal|buffer
            position = nil, -- left|right|top|bottom (nil will default depending on vim.opt.plitright|vim.opt.splitbelow)
            border = 'single',
            height = 0.8,
            width = 0.8,
            relative = 'editor',
            full_height = true, -- when set to false, vsplit will be used to open the chat buffer vs. botright/topleft vsplit
            opts = {
              breakindent = true,
              cursorcolumn = false,
              cursorline = false,
              foldcolumn = '0',
              linebreak = true,
              list = false,
              numberwidth = 1,
              signcolumn = 'no',
              spell = false,
              wrap = true,
              number = false,
              relativenumber = false,
            },
          },
          token_count = function(tokens, adapter)
            return ' (' .. tokens .. ' tokens)'
          end,
        },
      },
      opts = {
        -- log_level = "DEBUG",
      },
    }
  end,
}
