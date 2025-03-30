return {
  'echasnovski/mini.nvim',
  version = '*',
  enabled = false,
  config = function()
    require('mini.ai').setup {}
    require('mini.surround').setup {}
    require('mini.operators').setup {}
    require('mini.pick').setup {}
    require('mini.files').setup {

      -- Module mappings created only inside explorer.
      -- Use `''` (empty string) to not create one.
      mappings = {
        close = 'q',
        go_in = 'i',
        go_in_plus = 'I',
        go_out = 'n',
        go_out_plus = 'N',
        mark_goto = 'M',
        mark_set = 'm',
        reset = '<BS>',
        reveal_cwd = '@',
        show_help = '?',
        synchronize = '=',
        trim_left = '<',
        trim_right = '>',
      },
    }
  end,
}
