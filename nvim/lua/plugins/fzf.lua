return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local actions = require('fzf-lua').actions

    require('fzf-lua').setup {
      winopts = {
        preview = {
          layout = 'vertical',
          title = false,
          border = 'noborder',
          vertical = 'down:70%',
          delay = 0,
        },
      },
      actions = {
        files = {
          ['enter'] = actions.file_edit_or_qf,
          ['ctrl-i'] = actions.file_vsplit,
        },
      },
      files = {
        input_prompt = '',
        cwd_prompt = false,
        fd_opts = [[--color=never --type f --hidden --follow --exclude .devbox --exclude coverage --exclude .git --exclude .fvm --exclude build --exclude .dart_tool]],
      },
      git = {
        files = {
          prompt = '',
          input_prompt = '',
        },
      },
      grep = {
        prompt = '',
        input_prompt = '',
      },
      diagnostics = {
        prompt = '',
        input_prompt = '',
      },
    }
  end,
}
