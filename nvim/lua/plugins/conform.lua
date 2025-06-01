return {
  'stevearc/conform.nvim',
  enabled = true,
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      rust = { 'rustfmt', lsp_format = 'fallback' },
      json = { 'jq', lsp_format = 'fallback' },
      bash = { 'shfmt', lsp_format = 'fallback' },
      -- Conform will run multiple formatters sequentially
      -- python = { "isort", "black" },
      -- You can customize some of the format options for the filetype (:help conform.format)
      -- Conform will run the first available formatter
      yaml = { 'yamlfmt', lsp_format = 'fallback' },
    },
    default_format_opts = {
      lsp_format = 'fallback',
    },
    --   format_on_save = {
    --     -- These options will be passed to conform.format()
    --     timeout_ms = 500,
    --     lsp_format = 'fallback',
    --   },
  },
}
