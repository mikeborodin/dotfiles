return {
  'sindrets/diffview.nvim',
  event = 'VeryLazy',
  config = function()
    -- Lua
    require('diffview').setup()
  end,
}
