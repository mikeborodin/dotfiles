return {
  {
    "rcarriga/nvim-notify",
    config = function()
      require('notify').setup {
        background_colour = '#000000',
        render = 'minimal',
        top_down = false,
        animate = false,
        timeout = 500,
      }
    end
  },
  {
    'folke/noice.nvim',
    enabled = false,
    dependencies = {
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
    },
    config = function()
      require("noice").setup({
        notify = { enabled = false, },
        messages = { enabled = false, },
        popupmenu = { enabled = false, },
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },
      })
      require('notify').setup {
        background_colour = '#000000',
        render = 'minimal',
        top_down = false,
        animate = false,
        timeout = 500,
      }
    end
  },
}
