return {
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'moll/vim-bbye',
    },
    config = function()
      require("bufferline").setup({
        options = {
          always_show_bufferline = true,
          close_command = 'Bdelete! %d',
          offsets = {
            { filetype = "neo-tree", text = '', padding = 1, }
          }
        }
      })
    end
  },
}
