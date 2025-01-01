return {
  'alfredosa/devtime.nvim',
  dependencies = {
    { '3rd/sqlite.nvim' },
  },
  config = function()
    require('devtime').setup()
  end,
}
