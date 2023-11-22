return {
  'NeogitOrg/neogit',
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "nvim-telescope/telescope.nvim", -- optional
    "sindrets/diffview.nvim",        -- optional
    "ibhagwan/fzf-lua",
  },
  keys = {
    { "<space>vs", function()
      local neogit = require('neogit')
      -- open using defaults
      neogit.open()
      -- open commit popup
      -- neogit.open({ "commit" })
      -- open with split kind
      -- neogit.open({ kind = "split" })
      -- open home directory
      -- neogit.open({ cwd = "~" })
    end,
      "Open neogit",
    },
  },
  config = function()
    require('neogit').setup({
      signs = {
        hunk = { "", "" },
        -- right arrow nerdfont
        item = { '', '' },
        section = { '', '' },
      },
    })
  end

}
