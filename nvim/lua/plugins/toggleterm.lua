return {
    'akinsho/toggleterm.nvim',
    config = function()
        require('toggleterm').setup({
            open_mapping = "<C-h>",
            direction = "horizontal",
            float_opts = {
                width = 60,
                height = 40,
                row = 2,
                col = 80,
                title_pos = 'left'
            },
        })
    end
}
