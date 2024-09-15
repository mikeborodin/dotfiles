return {
    'ibhagwan/fzf-lua',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("fzf-lua").setup({
            -- hls = { border = "FloatBorder", },
            winopts = {
                height  = 0.7, -- window height
                width   = 0.6, -- window width
                row     = 0.4, -- window row position (0=top, 1=bottom)
                col     = 0.5, -- window col position (0=left, 1=right)
                border  = 'single',
                preview = {
                    -- default     = 'bat',           -- override the default previewer?
                    -- default uses the 'builtin' previewer
                    border     = 'noborder',
                    -- native fzf previewers (bat/cat/git/etc)
                    wrap       = 'nowrap',   -- wrap|nowrap
                    hidden     = 'nohidden', -- hidden|nohidden
                    vertical   = 'down:45%', -- up|down:size
                    horizontal = 'right:30%',
                    layout     = 'vertical',
                }
            },
            files = {
                prompt       = "",
                input_prompt = "",
                fd_opts      =
                [[--color=never --type f --hidden --follow --exclude .devbox --exclude .git --exclude .fvm --exclude build --exclude .dart_tool]],
            },
            git = {
                files = {
                    prompt = "",
                    input_prompt = "",
                },
            },
            grep = {
                prompt = "",
                input_prompt = "",
            },
            diagnostics = {
                prompt       = "",
                input_prompt = "",
            },
        })
    end,
}
