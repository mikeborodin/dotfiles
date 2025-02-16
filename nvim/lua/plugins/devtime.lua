return {
  'alfredosa/devtime.nvim',
  enabled = false,
  dependencies = {
    { '3rd/sqlite.nvim' },
  },
  config = function()
    require('devtime').setup()
  end,
}
