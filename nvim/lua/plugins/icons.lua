return {
  {
    'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup {
        override_by_filename = {
          ['.gitignore'] = {
            icon = '',
            color = '#f1502f',
            name = 'Gitignore',
          },
          ['CODEOWNERS'] = {
            icon = '',
          },
          ['slang.yaml'] = {
            icon = '󰗊'
          },
          ['.phrase.yml'] = {
            icon = '󰗊'
          },
          ['.metadata'] = {
            icon = '󰙅'
          },
          ['devbox.lock'] = {
            icon = ''
          },
        },
        override = {
          yaml = {
            icon = '󰙅',
            color = '#bb781b',
            name = 'Yaml',
          },
          nu = {
            icon = '',
            color = '#009051',
            name = 'Nushell',
          },
          dart = {
            icon = '',
            color = '#1E88E5',
            name = 'Dart',
          },
        },
      }
    end,
  },
}
