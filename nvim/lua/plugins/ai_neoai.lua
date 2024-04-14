-- weird
return {
    "Bryley/neoai.nvim",
    enabled = false,
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    cmd = {
        "NeoAI",
        "NeoAIOpen",
        "NeoAIClose",
        "NeoAIToggle",
        "NeoAIContext",
        "NeoAIContextOpen",
        "NeoAIContextClose",
        "NeoAIInject",
        "NeoAIInjectCode",
        "NeoAIInjectContext",
        "NeoAIInjectContextCode",
    },
    keys = {
        { "<space>as", desc = "summarize text" },
        { "<space>ag", desc = "generate git message" },
    },
    config = function()
        require("neoai").setup({
            -- Options go here
            models = {
                {
                    name = "mistral",
                    model = "mistral",
                    params = nil,
                },
            },

        })
    end,
    dir = "/Users/mike/personal_projects/neoai.nvim",
}
