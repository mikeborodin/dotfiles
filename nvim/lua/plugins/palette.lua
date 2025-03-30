return {
  'roobert/palette.nvim',
  lazy = false,
  enabled = false,
  priority = 1000,
  config = function()
    require('palette').setup {
      palettes = {
        main = 'custom_main_palette',
        accent = 'custom_accent_palette',
        state = 'custom_state_palette',
      },

      custom_palettes = {
        main = {
          custom_main_palette = {
            color0 = '#191d33',
            color1 = '#1A1E39',
            color2 = '#383f5e',
            color3 = '#4e5470',
            color4 = '#7b7f94',
            color5 = '#a7a9b7',
            color6 = '#bdbfc9',
            color7 = '#d3d4db',
            color8 = '#e9e9ed',
          },
        },
        accent = {
          custom_accent_palette = {
            accent0 = '#D97C8F',
            accent1 = '#D9AE7E',
            accent2 = '#D9D87E',
            accent3 = '#A5D9A7',
            accent4 = '#8BB9C8',
            accent5 = '#C9A1D3',
            accent6 = '#B8A1D9',
          },
        },
        state = {
          custom_state_palette = {
            error = '#D97C8F',
            warning = '#D9AE7E',
            hint = '#D9D87E',
            ok = '#A5D9A7',
            info = '#8BB9C8',
          },
        },
      },
    }

    vim.cmd [[colorscheme palette]]
  end,
}
