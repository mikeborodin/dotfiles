return {
    dir = '/Users/mike/personal_projects/fzf-lua',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("fzf-lua").setup({
            hls = { border = "FloatBorder" },
            winopts = {
                height  = 0.5, -- window height
                width   = 0.8, -- window width
                row     = 0.5, -- window row position (0=top, 1=bottom)
                col     = 0.2, -- window col position (0=left, 1=right)
                preview = {
                    -- default     = 'bat',           -- override the default previewer?
                    -- default uses the 'builtin' previewer
                    border     = 'noborder', -- border|noborder, applies only to
                    -- native fzf previewers (bat/cat/git/etc)
                    wrap       = 'nowrap',   -- wrap|nowrap
                    hidden     = 'nohidden', -- hidden|nohidden
                    vertical   = 'down:45%', -- up|down:size
                    horizontal = 'right:30%',
                }
            },
        })
    end,
}
