local function registerPostfix()
  local ls = require 'luasnip'
  local f = ls.function_node
  local postfix = require('luasnip.extras.postfix').postfix
end

return {
  'L3MON4D3/LuaSnip',
  version = 'v2.*',
  build = (not jit.os:find 'Windows')
      and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
    or nil,
  dependencies = {
    'rafamadriz/friendly-snippets',
    config = function(_, _)
      require('luasnip.loaders.from_vscode').load_standalone {
        path = '~/.config/nvim/snippets/af.code-snippets',
      }
      require('luasnip.loaders.from_vscode').load_standalone {
        path = '~/.config/nvim/snippets/mike.code-snippets',
      }

      local function scan_directory_for_snippets(dir)
        local files = {}
        for file in io.popen('ls "' .. dir .. '"'):lines() do
          if file:match '%.code%-snippets$' then
            table.insert(files, dir .. '/' .. file)
          end
        end
        return files
      end

      local snippets_dir = vim.fn.expand '.vscode' -- Adjust this path as needed
      local snippets_files = scan_directory_for_snippets(snippets_dir)

      for _, file in ipairs(snippets_files) do
        require('luasnip.loaders.from_vscode').load_standalone {
          path = file,
        }
      end

      registerPostfix()
    end,
  },
  opts = {
    history = true,
    delete_check_events = 'TextChanged',
  },
  keys = {
    {
      '<tab>',
      function()
        return require('luasnip').jumpable(1) and '<Plug>luasnip-jump-next' or '<tab>'
      end,
      expr = true,
      silent = true,
      mode = 'i',
    },
    {
      '<tab>',
      function()
        require('luasnip').jump(1)
      end,
      mode = 's',
    },
    {
      '<s-tab>',
      function()
        require('luasnip').jump(-1)
      end,
      mode = { 'i', 's' },
    },
  },
}
