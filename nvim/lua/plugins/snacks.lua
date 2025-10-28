return {
  'folke/snacks.nvim',
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
          { section = 'header', ttl = 0 },
          { icon = ' ', title = 'Recent Files', cwd = true, section = 'recent_files', indent = 2, padding = 1 },
          {
            action = ':FzfLua files',
            key = 'f',
            desc = 'Find File',
            icon = ' ',
          },
        },
      },
    },
    -- notifier = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    -- words = { enabled = true },
  },
}
