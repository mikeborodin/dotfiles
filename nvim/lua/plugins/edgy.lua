return {
  -- edgy
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>ue",
        function()
          require("edgy").toggle()
        end,
        desc = "Edgy Toggle",
      },
      -- stylua: ignore
      { "<leader>uE", function() require("edgy").select() end, desc = "Edgy Select Window" },
    },
    opts = function()
      local opts = {
        animate = {
          enabled = false,
        },
        bottom = {
          {
            ft = "noice",
            size = { height = 0.4 },
            filter = function(buf, win)
              return vim.api.nvim_win_get_config(win).relative == ""
            end,
          },
          {
            ft = "lazyterm",
            title = "LazyTerm",
            size = { height = 0.4 },
            filter = function(buf)
              return not vim.b[buf].lazyterm_cmd
            end,
          },
          { ft = "qf",                title = "QuickFix" },
          {
            ft = "help",
            size = { height = 20 },
            -- don't open help files in edgy that we're editing
            filter = function(buf)
              return vim.bo[buf].buftype == "help"
            end,
          },
          { title = "Spectre",        ft = "spectre_panel",        size = { height = 0.4 } },
          { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 0.4 } },
          {
            ft = "log",
            size = { height = 0.4 },
            filter = function(_, win)
              return vim.api.nvim_win_get_config(win).relative == ""
            end,
          },
        },
        left = {
          "Trouble",
          {
            title = "Neo-Tree",
            ft = "neo-tree",
            filter = function(buf)
              return vim.b[buf].neo_tree_source == "filesystem"
            end,
            pinned = true,
            open = function()
              vim.api.nvim_input("<esc><space>e")
            end,
            size = { height = 0.5, width = 40 },
          },
          { title = "Neotest Summary", ft = "neotest-summary" },
          "neo-tree",
          -- {
          --   title = "Neo-Tree Git",
          --   ft = "neo-tree",
          --   filter = function(buf)
          --     return vim.b[buf].neo_tree_source == "git_status"
          --   end,
          --   pinned = true,
          --   open = "Neotree position=right git_status",
          -- },
        },
        -- right = {
        --   {
        --     ft = "toggleterm",
        --     size = { width = 40 },
        --     filter = function(buf, win)
        --       return vim.api.nvim_win_get_config(win).relative == ""
        --     end,
        --   },
        -- },
        keys = {
          ["<space>wy"] = function(win)
            win:resize("width", 8)
          end,
          ["<space>wl"] = function(win)
            win:resize("width", -8)
          end,
          ["<space>w;"] = function(win)
            win:resize("height", 8)
          end,
          ["<space>wu"] = function(win)
            win:resize("height", -8)
          end,

          ["<space>wh"] = function(win)
            win:hide()
          end,
        },
      }
      return opts
    end,
  },

  -- use edgy's selection window
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = {
      defaults = {
        get_selection_window = function()
          require("edgy").goto_main()
          return 0
        end,
      },
    },
  },

  -- prevent neo-tree from opening files in edgy windows
  {
    "nvim-neo-tree/neo-tree.nvim",
    optional = true,
    opts = function(_, opts)
      opts.open_files_do_not_replace_types = opts.open_files_do_not_replace_types
          or { "terminal", "Trouble", "qf", "Outline" }
      table.insert(opts.open_files_do_not_replace_types, "edgy")
    end,
  },

  -- Fix bufferline offsets when edgy is loaded
  {
    "akinsho/bufferline.nvim",
    optional = true,
    opts = function()
      local Offset = require("bufferline.offset")
      if not Offset.edgy then
        local get = Offset.get
        Offset.get = function()
          if package.loaded.edgy then
            local layout = require("edgy.config").layout
            local ret = { left = "", left_size = 0, right = "", right_size = 0 }
            for _, pos in ipairs({ "left", "right" }) do
              local sb = layout[pos]
              if sb and #sb.wins > 0 then
                local title = " Sidebar" .. string.rep(" ", sb.bounds.width - 8)
                ret[pos] = "%#EdgyTitle#" .. title .. "%*" .. "%#WinSeparator#│%*"
                ret[pos .. "_size"] = sb.bounds.width
              end
            end
            ret.total_size = ret.left_size + ret.right_size
            if ret.total_size > 0 then
              return ret
            end
          end
          return get()
        end
        Offset.edgy = true
      end
    end,
  },
}
