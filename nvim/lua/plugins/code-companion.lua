return {
    "olimorris/codecompanion.nvim",
    enabled = true,
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
            strategies = {
                chat = {
                    adapter = "llama3",
                },
                inline = {
                    adapter = "llama3",
                },
            },
            adapters = {
                llama3 = function()
                    return require("codecompanion.adapters").extend("ollama", {
                        name = "llama3",
                        schema = {
                            model = {
                                default = "llama3.1:latest",
                            },
                            num_ctx = {
                                default = 16384,
                            },
                            num_predict = {
                                default = -1,
                            },
                        },
                    })
                end,
            },
            chat = {
                icons = {
                    pinned_buffer = " ",
                },
                window = {
                    layout = "float", -- float|vertical|horizontal|buffer
                    position = nil,      -- left|right|top|bottom (nil will default depending on vim.opt.splitright|vim.opt.splitbelow)
                    border = "single",
                    height = 0.8,
                    width = 0.45,
                    relative = "editor",
                    opts = {
                        breakindent = true,
                        cursorcolumn = false,
                        cursorline = false,
                        foldcolumn = "0",
                        linebreak = true,
                        list = false,
                        numberwidth = 1,
                        signcolumn = "no",
                        spell = false,
                        wrap = true,
                    },
                },
                intro_message = "Welcome to CodeCompanion ✨! Press ? for options",

                show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an exteral markdown formatting plugin
                separator = "─", -- The separator between the different messages in the chat buffer

                show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
                show_settings = false, -- Show LLM settings at the top of the chat buffer?
                show_token_count = true, -- Show the token count for each response?
                start_in_insert_mode = false, -- Open the chat buffer in insert mode?

                ---@param tokens number
                ---@param adapter CodeCompanion.Adapter
                token_count = function(tokens, adapter) -- The function to display the token count
                    return " (" .. tokens .. " tokens)"
                end,
            },
            display = {
                diff = {
                    provider = "mini_diff",
                },
            },
            opts = {
                -- log_level = "DEBUG",
            },
        })
    end
}
