return {
  {
    'nvim-flutter/pubspec-assist.nvim',
    dependencies = { 'plenary.nvim' },
    config = function()
      require('pubspec-assist').setup({})
    end,
  },
}
