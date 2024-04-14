return {
    '/joshuavial/aider.nvim',
    config = function()
        require('aider').setup({
            auto_manage_context = false,
            default_bindings = false
        })
        -- :lua AiderOpen()
        -- :lua AiderOpen("-3", "hsplit")
        -- :lua AiderOpen("AIDER_NO_AUTO_COMMITS=1 aider -3", "editor")
        -- :lua AiderBackground()
        -- :lua AiderBackground("-3")
        -- :lua AiderBackground("AIDER_NO_AUTO_COMMITS=1 aider -3")
    end
}
