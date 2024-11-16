return {
    "olimorris/codecompanion.nvim",
    enabled=false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "hrsh7th/nvim-cmp",
        "nvim-telescope/telescope.nvim",
        { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } }, -- Optional: For prettier markdown rendering
        { "stevearc/dressing.nvim",                    opts = {} },
    },
    config = function()
        require("codecompanion").setup({
            display = {
                diff = {
                    provider = "mini_diff",
                },
            },
            opts = {
                log_level = "DEBUG",
            },
        })
    end
}
