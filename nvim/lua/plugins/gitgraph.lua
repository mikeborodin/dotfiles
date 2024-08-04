return {
    'isakbm/gitgraph.nvim',
    dependencies = { 'sindrets/diffview.nvim' },
    opts = {
        symbols = {
            merge_commit = 'M',
            commit = '*',
        },
        format = {
            timestamp = '%H:%M:%S %d-%m-%Y',
            fields = { 'hash', 'timestamp', 'author', 'branch_name', 'tag' },
        },
    },
    init = function()
        vim.keymap.set('n', '<space>gl', function()
            require('gitgraph').draw({}, {})
        end, { desc = 'new git graph' })
    end,
}
