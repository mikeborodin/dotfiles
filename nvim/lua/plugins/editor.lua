-- hover.nvim removed: native vim.lsp.buf.hover() is used via <space>h keymap
-- Comment.nvim removed: gc/gcc are built-in since Neovim 0.10
--   Colemak comment keymaps set in keymaps_key.lua: tl = gc (line), tj = gb (block)
-- nvim-surround, vs-tasks, vim-visual-multi removed (were disabled)

return {
  {
    'HakonHarnes/img-clip.nvim',
    event = 'VeryLazy',
    opts = {
      default = {
        use_absolute_path = false,
        relative_to_current_file = true,
        dir_path = function()
          return vim.fn.expand '%:t:r' .. '-img'
        end,
        prompt_for_file_name = false,
        file_name = '%y%m%d-%H%M%S',
        extension = 'jpg',
        process_cmd = 'convert - -quality 75 jpg:-',
      },
      filetypes = {
        markdown = {
          url_encode_path = true,
          template = '![Image]($FILE_PATH)',
        },
      },
    },
    keys = {
      { '<space>p', '<cmd>PasteImage<cr>', desc = 'Paste image from system clipboard' },
    },
  },
  {
    'iamcco/markdown-preview.nvim',
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },
}
