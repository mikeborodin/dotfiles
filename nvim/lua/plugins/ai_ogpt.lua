return {
    "huynle/ogpt.nvim",
    enabled = true,
    dir     = "/Users/mike/personal_projects/ogpt.nvim",
    event   = "VeryLazy",
    config  = function()
        local opts = {
            ollama = {
                enabled = true,
                models = {
                    {
                        name = "mistral",
                    },
                },
                model = {
                    name = "mistral",
                },
                api_params = {
                    model = "mistral",
                    temperature = 0.5,
                    top_p = 0.99,
                },
                api_chat_params = {
                    -- use default ollama model
                    model = "mistral",
                    temperature = 0.8,
                    top_p = 0.99,
                },
            }
        }
        require('ogpt').setup(opts)
    end
}
