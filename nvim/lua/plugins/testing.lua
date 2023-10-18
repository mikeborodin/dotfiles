return {
  -- {
  --   'nvim-neotest/neotest',
  --   dependencies = {
  --     {
  --       'nvim-treesitter/nvim-treesitter',
  --       'sidlatau/neotest-dart',
  --       "nvim-lua/plenary.nvim",
  --       "antoinemadec/FixCursorHold.nvim"
  --     }
  --   },
  --   enabled = true,
  --   config = function()
  --     require 'nvim-treesitter.configs'.setup {
  --       ensure_installed = { "lua", "vim", "vimdoc", "query", "dart", "yaml" },
  --       sync_install = false,
  --       auto_install = true,
  --       ignore_install = { "javascript" },
  --       highlight = {
  --         enable = true,
  --         disable = { "c", "rust" },
  --         disable = function(lang, buf)
  --           local max_filesize = 100 * 1024 -- 100 KB
  --           local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  --           if ok and stats and stats.size > max_filesize then
  --             return true
  --           end
  --         end,
  --         additional_vim_regex_highlighting = false,
  --       },
  --     }
  --     require('neotest').setup({
  --       status = { virtual_text = true },
  --       output = { open_on_run = true },
  --       adapters = {
  --         require('neotest-dart') {
  --           command = 'flutter',
  --           use_lsp = true
  --         },
  --       }
  --     })
  --   end
  -- },
  {
    "nvim-neotest/neotest",
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter',
        'sidlatau/neotest-dart',
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim"
      }
    },
    opts = function(opts) 
      return {
      -- Can be a list of adapters like what neotest expects,
      -- or a list of adapter names,
      -- or a table of adapter names, mapped to adapter configs.
      -- The adapter will then be automatically loaded with the config.
      adapters = {
          require('neotest-dart') {
            command = 'flutter',
            use_lsp = true
          },
      },
      -- Example for loading neotest-go with a custom config
      -- adapters = {
      --   ["neotest-go"] = {
      --     args = { "-tags=integration" },
      --   },
      -- },
      status = { virtual_text = true },
      output = { open_on_run = true },
      quickfix = {
        open = function()
          if require("lazyvim.util").has("trouble.nvim") then
            vim.cmd("Trouble quickfix")
          else
            vim.cmd("copen")
          end
        end,
      },
    } 
  end,
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            -- Replace newline and tab characters with space for more compact diagnostics
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)

      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == "number" then
            if type(config) == "string" then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == "table" and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif meta and meta.__call then
                adapter(config)
              else
                error("Adapter " .. name .. " does not support setup")
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end

      require("neotest").setup(opts)
    end,
    -- stylua: ignore
    keys = {
      { "<space>tw", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
      { "<space>tF", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run All Test Files" },
      { "<space>tf", function() require("neotest").run.run() end, desc = "Run Nearest" },
      { "<space>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
      { "<space>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
      { "<space>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
      { "<space>tS", function() require("neotest").run.stop() end, desc = "Stop" },
    },
  },
  {
    'andythigpen/nvim-coverage',
    keys = {
      -- '<space>tT', ':CoverageToggle<cr>', 'CoverageToggle',
    },
    config = function()
      require("coverage").setup()
    end
  },
}
