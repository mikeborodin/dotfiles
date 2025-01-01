return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = {
      sections = {
        {
          pane = 1,
          -- {
          --   section = "terminal",
          --   cmd = "chafa ~/Downloads/fantasy-forest-2.jpg --format symbols --symbols vhalf --size 60x17 --stretch; sleep .1",
          --   height = 17,
          --   padding = 1,
          -- },
          { section = "terminal", cmd = "status check", height = 7, gap = 1, padding = 1 },
          { section = "terminal", cmd = "git-cal",      height = 7, gap = 1, padding = 1 },
          -- { section = "keys",     gap = 1,             padding = 1 },
          -- { section = "startup" },
        }
      }
    },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    -- words = { enabled = true },
  },
}
