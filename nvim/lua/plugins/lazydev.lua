return {
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    lazy = false,
    dependencies = {
      {
        'DrKJeff16/wezterm-types',
        lazy = true,
      },
    },
    opts = {
      -- enabled = function(root_dir)
      --   return true
      -- end,
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        -- Load the wezterm types when the `wezterm` module is required
        -- Needs `justinsgithub/wezterm-types` to be installed
        { path = '/Users/mike/.local/share/nvim/lazy/wezterm-types' },
        -- { path = 'wezterm-types', mods = { 'wezterm' } },
        -- Load the xmake types when opening file named `xmake.lua`
        -- Needs `LelouchHe/xmake-luals-addon` to be installed
        { path = 'xmake-luals-addon/library', files = { 'xmake.lua' } },
      },
    },
  },
}
