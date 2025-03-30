return {
  'akinsho/toggleterm.nvim',
  config = function()
    require('toggleterm').setup {
      open_mapping = '<C-h>',
      direction = 'float',
      shell = function()
        if vim.env.DEVBOX_PROJECT_ROOT == vim.loop.cwd() then
          return 'devbox run shell'
        else
          return 'zsh'
        end
      end,
    }
  end,
}
