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
          {
            icon = " ",
            section = "terminal",
            title = "Top contributors",
            cmd = "git shortlog -s -n",
            height = 5,
            gap = 1,
            padding = 1,
            action = function()
              vim.cmd [[FzfLua git_commits]]
            end,
          },
          -- { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          -- {
          --   icon = " ",
          --   title = "Open PRs",
          --   cmd = "gh pr list -L 3",
          --   key = "p",
          --   action = function()
          --     vim.fn.jobstart("gh pr list --web", { detach = true })
          --   end,
          --   height = 7,
          -- },
          -- {
          --   title = "Notifications",
          --   cmd = "gh notify -s -a -n5",
          --   action = function()
          --     vim.ui.open("https://github.com/notifications")
          --   end,
          --   key = "n",
          --   icon = " ",
          --   height = 5,
          --   enabled = true,
          -- },
        },
      }
    },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    -- words = { enabled = true },
  },
}
