return {
  -- Treesitter is a new parser generator tool that we can
  -- use in Neovim to power faster and more accurate
  -- syntax highlighting.
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    enabled = true,
    build = ":TSUpdate",
    -- event = { "VeryLazy", },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        { "nushell/tree-sitter-nu", build = ":TSUpdate nu" },
      },
    },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "=",    desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    opts = {
      auto_install = vim.fn.executable "tree-sitter" == 1, -- only enable auto install if `tree-sitter` cli is installed
      highlight = { enable = true },
      incremental_selection = { enable = true },
      indent = { enable = true },
      -- ignore_install = { "dart" },
      textobjects = {
        -- select = {
        --   enable = true,
        --   lookahead = true,
        --   keymaps = {
        --     ["ak"] = { query = "@block.outer", desc = "around block" },
        --     ["ik"] = { query = "@block.inner", desc = "inside block" },
        --     ["ac"] = { query = "@class.outer", desc = "around class" },
        --     ["ic"] = { query = "@class.inner", desc = "inside class" },
        --     ["a?"] = { query = "@conditional.outer", desc = "around conditional" },
        --     ["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
        --     ["af"] = { query = "@function.outer", desc = "around function " },
        --     ["if"] = { query = "@function.inner", desc = "inside function " },
        --     ["ao"] = { query = "@loop.outer", desc = "around loop" },
        --     ["io"] = { query = "@loop.inner", desc = "inside loop" },
        --     ["aa"] = { query = "@parameter.outer", desc = "around argument" },
        --     ["ia"] = { query = "@parameter.inner", desc = "inside argument" },
        --   },
        -- },
        -- move = {
        --   enable = true,
        --   set_jumps = true,
        --   goto_next_start = {
        --     ["]k"] = { query = "@block.outer", desc = "Next block start" },
        --     ["]f"] = { query = "@function.outer", desc = "Next function start" },
        --     ["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
        --   },
        --   goto_next_end = {
        --     ["]K"] = { query = "@block.outer", desc = "Next block end" },
        --     ["]F"] = { query = "@function.outer", desc = "Next function end" },
        --     ["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
        --   },
        --   goto_previous_start = {
        --     ["[k"] = { query = "@block.outer", desc = "Previous block start" },
        --     ["[f"] = { query = "@function.outer", desc = "Previous function start" },
        --     ["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
        --   },
        --   goto_previous_end = {
        --     ["[K"] = { query = "@block.outer", desc = "Previous block end" },
        --     ["[F"] = { query = "@function.outer", desc = "Previous function end" },
        --     ["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
        --   },
        -- },
        -- swap = {
        --   enable = true,
        --   swap_next = {
        --     [">K"] = { query = "@block.outer", desc = "Swap next block" },
        --     [">F"] = { query = "@function.outer", desc = "Swap next function" },
        --     [">A"] = { query = "@parameter.inner", desc = "Swap next argument" },
        --   },
        --   swap_previous = {
        --     ["<K"] = { query = "@block.outer", desc = "Swap previous block" },
        --     ["<F"] = { query = "@function.outer", desc = "Swap previous function" },
        --     ["<A"] = { query = "@parameter.inner", desc = "Swap previous argument" },
        --   },
        -- },
      },
    },
    config = function(_, opts)
      -- if type(opts.ensure_installed) == "table" then
      --   local added = {}
      --   opts.ensure_installed = vim.tbl_filter(function(lang)
      --     if added[lang] then
      --       return false
      --     end
      --     added[lang] = true
      --     return true
      --   end, opts.ensure_installed)
      -- end
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Show context of the current function
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    enabled = true,
    opts = { mode = "cursor" },
    keys = {
      {
        "<space>ut",
        function()
          local Util = require("lazyvim.util")
          local tsc = require("treesitter-context")
          tsc.toggle()
          if Util.inject.get_upvalue(tsc.toggle, "enabled") then
            Util.info("Enabled Treesitter Context", { title = "Option" })
          else
            Util.warn("Disabled Treesitter Context", { title = "Option" })
          end
        end,
        desc = "Toggle Treesitter Context",
      },
    },
  },
}
