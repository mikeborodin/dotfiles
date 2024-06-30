return {
    'akinsho/toggleterm.nvim',
    config = function()
        require('toggleterm').setup({
            open_mapping = "<C-h>",
            direction = "float",
        })
    end
}
