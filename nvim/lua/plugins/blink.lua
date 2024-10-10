return {
  "saghen/blink.cmp",
  lazy = false,
  enabled = false,
  dependencies = "rafamadriz/friendly-snippets",
  version = "v0.*",
  opts = {
    keymap = {
      show = '<C-space>',
      hide = '<C-e>',
      accept = '<cr>',
      select_prev = { '<Up>', '<C-p>' },
      select_next = { '<Down>', '<C-n>' },

      show_documentation = {},
      hide_documentation = {},
      scroll_documentation_up = '<C-b>',
      scroll_documentation_down = '<C-f>',

      snippet_forward = '<Tab>',
      snippet_backward = '<S-Tab>',
    },
    windows = {
      autocomplete = {
        min_width = 30,
        max_width = 60,
        max_height = 10,
        border = "none",
        winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
        -- keep the cursor X lines away from the top/bottom of the window
        scrolloff = 2,
        -- which directions to show the window,
        -- falling back to the next direction when there's not enough space
        direction_priority = { "s", "n" },
        -- whether to preselect the first item in the completion list
        preselect = true,
        -- Controls how the completion items are rendered on the popup window
        -- 'simple' will render the item's kind icon the left alongside the label
        -- 'reversed' will render the label on the left and the kind icon + name on the right
        -- 'function(blink.cmp.CompletionRenderContext): blink.cmp.Component[]' for custom rendering
        draw = "simple",
        -- Controls the cycling behavior when reaching the beginning or end of the completion list.
        cycle = {
          -- When `true`, calling `select_next` at the *bottom* of the completion list will select the *first* completion item.
          from_bottom = true,
          -- When `true`, calling `select_prev` at the *top* of the completion list will select the *last* completion item.
          from_top = true,
        },
      },
    },
    sources = {
      -- similar to nvim-cmp's sources, but we point directly to the source's lua module
      -- multiple groups can be provided, where it'll fallback to the next group if the previous
      -- returns no completion items
      -- WARN: This API will have breaking changes during the beta
      -- FOR REF: full example

      providers = {
        {
          -- all of these properties work on every source
          {
            "blink.cmp.sources.lsp",
            keyword_length = 0,
            score_offset = 0,
            trigger_characters = { "f", "o", "o" },
            opts = {},
          },
          -- the follow two sources have additional options
          {
            "blink.cmp.sources.path",
            opts = {
              trailing_slash = false,
              label_trailing_slash = true,
              get_cwd = function(context)
                return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
              end,
              show_hidden_files_by_default = true,
            },
          },
          {
            "blink.cmp.sources.snippets",
            score_offset = 999,
            -- similar to https://github.com/garymjr/nvim-snippets
            opts = {
              friendly_snippets = false,
              search_paths = { "~/.config/nvim/snippets" },
              global_snippets = { "all" },
              extended_filetypes = {},
              ignored_filetypes = {},
            },
          },
        },
        { { "blink.cmp.sources.buffer" } },
      },
    },
    highlight = {
      use_nvim_cmp_as_default = false,
    },
    -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- adjusts spacing to ensure icons are aligned
    nerd_font_variant = "normal",

    -- experimental auto-brackets support
    accept = {
      create_undo_point = true,
      auto_brackets = {
        enabled = true,
        default_brackets = { '(', ')' },
        override_brackets_for_filetypes = {},
        -- Overrides the default blocked filetypes
        force_allow_filetypes = {},
        blocked_filetypes = {},
        -- Synchronously use the kind of the item to determine if brackets should be added
        kind_resolution = {
          enabled = true,
          blocked_filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'vue' },
        },
        -- Asynchronously use semantic token to determine if brackets should be added
        semantic_token_resolution = {
          enabled = true,
          blocked_filetypes = {},
        },
      },
    },

    -- experimental signature help support
    trigger = { signature_help = { enabled = true } },
  },
}
