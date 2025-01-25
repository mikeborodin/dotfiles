return {
    'vim-test/vim-test',
    config = function()
        vim.cmd [[
         let g:test#strategy = "toggleterm"

        "  function! FvmTransform(cmd) abort
        "     return 'fvm '.a:cmd
        "  endfunction
        " let g:test#custom_transformations = {'fvm': function('FvmTransform')}
        " let g:test#transformation = 'fvm'
        ]]
    end
}
