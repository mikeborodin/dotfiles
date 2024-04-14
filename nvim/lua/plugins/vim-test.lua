return {
    'vim-test/vim-test',
    config = function()
        vim.cmd [[
         let g:test#strategy = "toggleterm"
        ]]
    end
}
