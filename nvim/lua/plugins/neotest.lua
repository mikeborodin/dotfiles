return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        {
          "sidlatau/neotest-dart",
          lazy = false,
          -- dir = "~/personal_projects/neotest-dart",
        },
      },
    },
    opts = function(_)
      return {
        adapters = {
          require("neotest-dart")({
            command = (IsFvmProject() and "fvm flutter" or "flutter"),
            use_lsp = true,
          }),
        },
        status = { virtual_text = false },
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
        icons = {
          expanded = "",
          child_prefix = "",
          child_indent = "",
          final_child_prefix = "",
          non_collapsible = "",
          collapsed = "",

          passed = "",
          running = "",
          failed = "",
          unknown = ""
        },
      }
    end,
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            -- Replace newline and tab characters with space for more compact diagnostics
            local message =
                diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " ")
                :gsub("^%s+", "")
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
    -- keys = {
    --   {
    --     "<space>tw",
    --     function() require("neotest").run.run(vim.fn.expand("%")) end,
    --     desc = "Run File"
    --   },
    --   {
    --     "<space>tF",
    --     function() require("neotest").run.run(vim.loop.cwd()) end,
    --     desc = "Run All Test Files"
    --   },
    --   {
    --     "<space>tf",
    --     function() require("neotest").run.run() end,
    --     desc = "Run Nearest"
    --   },
    --   {
    --     "<space>tm",
    --     function() require("neotest").summary.toggle() end,
    --     desc = "Toggle Summary"
    --   },
    --   {
    --     "<space>to",
    --     function()
    --       require("neotest").output.open({
    --         enter = true,
    --         auto_close = true
    --       })
    --     end,
    --     desc = "Show Output"
    --   },
    --   {
    --     "<space>tO",
    --     function() require("neotest").output_panel.toggle() end,
    --     desc = "Toggle Output Panel"
    --   },
    --   {
    --     "<space>tS",
    --     function() require("neotest").run.stop() end,
    --     desc = "Stop"
    --   },
    -- },
  },
}
