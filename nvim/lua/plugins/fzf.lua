return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  enabled = true,
  event = 'VeryLazy',
  config = function()
    local actions = require('fzf-lua').actions

    require('fzf-lua').setup {
      previewers = {
        builtin = {
          extensions = {
            -- neovim terminal only supports `viu` block output
            ['png'] = { 'head' },
            -- by default the filename is added as last argument
            -- if required, use `{file}` for argument positioning
            ['svg'] = { 'head' },
            ['jpg'] = { 'head' },
          },
        },
      },
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
          ['tab'] = actions.file_vsplit,
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
