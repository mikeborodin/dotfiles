return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  event ='InsertEnter',
  dependencies = {
    { 'L3MON4D3/LuaSnip', version = 'v2.*' },

    -- {
    --   'rafamadriz/friendly-snippets',
    -- },
  },

  -- use a release tag to download pre-built binaries
  version = '*',
  -- branch = 'main',
  -- commit = '3ab6832',
  -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config

  config = function()
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

    -- local snippets_dir = vim.fn.expand '.vscode' -- Adjust this path as needed
    -- local snippets_files = scan_directory_for_snippets(snippets_dir)
    --
    -- for _, file in ipairs(snippets_files) do
    --   require('luasnip.loaders.from_vscode').load_standalone {
    --     path = file,
    --   }
    -- end
    require('blink.cmp').setup {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- see the "default configuration" section below for full documentation on how to define
      -- your own keymap.
      keymap = { preset = 'enter' },
      -- completion = {
      --   menu = { auto_show = function(ctx) return ctx.mode ~= 'cmdline' end }
      -- },
      enabled = function()
        return not vim.list_contains({
          'DressingInput',
          'dap-repl',
          'markdown',
        }, vim.bo.filetype) and vim.bo.buftype ~= 'prompt' and vim.b.completion ~= false
      end,
      completion = {
        menu = {
          draw = {
            treesitter = { 'lsp' },
            columns = {
              { 'label', 'label_description', gap = 1 },
              { 'kind_icon', 'kind' },
            },
          },
        },
        documentation = { auto_show = true, auto_show_delay_ms = 1000 },
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
      },
      appearance = {
        use_nvim_cmp_as_default = false,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'normal',
      },

      snippets = {
        expand = function(snippet)
          require('luasnip').lsp_expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require('luasnip').jumpable(filter.direction)
          end
          return require('luasnip').in_snippet()
        end,
        jump = function(direction)
          require('luasnip').jump(direction)
        end,
      },
      sources = {
        default = { 'lsp', 'path', 'snippets' },
        per_filetype = {
          -- optionally inherit from the `default` sources
          lua = { inherit_defaults = true, 'lazydev' },
        },
        -- providers = {
        --   snippets = {
        --     opts = {
        --       search_paths = {
        --         vim.fn.stdpath('config') .. '/snippets',
        --       },
        --     }
        --   }
        -- }
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100, -- show at a higher priority than lsp
          },
        },
      },

      -- experimental signature help support
      signature = { enabled = false },
    }
  end,
  -- allows extending the providers array elsewhere in your config
  -- without having to redefine it
  -- opts_extend = { "sources.default" }
}
