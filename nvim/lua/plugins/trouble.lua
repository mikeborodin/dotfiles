return {
    "folke/trouble.nvim",
    branch = "main",
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    config = function()
        require("trouble").setup {
        }
    end
}
