return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        enabled = false,
        branch = "canary",
        dependencies = {
            { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
            { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
        },
        keys = {
            { "<space>cc", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChatToggle" },
        },
        opts = {
            debug = true, -- Enable debugging
            -- See Configuration section for rest
        },
        -- See Commands section for default commands if you want to lazy load on them
    },
}
