local function augroup(name)
  return vim.api.nvim_create_augroup('lazyvim_' .. name, { clear = true })
end
-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup 'checktime',
  command = 'checktime',
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter', 'WinEnter', 'TabEnter', 'ModeChanged' }, {
  callback = function()
    require('lualine').refresh()
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function()
    local flutter_bin = vim.fn.getcwd() .. '/.fvm/flutter_sdk/bin'

    if vim.fn.isdirectory(flutter_bin) == 1 then
      local path = vim.env.PATH or ''
      if not string.find(path, vim.pesc(flutter_bin)) then
        vim.env.PATH = flutter_bin .. ':' .. path
      end
    end
  end,
})

vim.cmd [[ autocmd BufNewFile,BufRead *.metadata set filetype=yaml ]]
vim.cmd [[ autocmd BufNewFile,BufRead *.fvmrc set filetype=json ]]
vim.cmd [[ autocmd BufNewFile,BufRead *.arb set filetype=json ]]
vim.cmd [[ autocmd BufNewFile,BufRead *.code-snippets set filetype=json ]]
vim.cmd [[ autocmd BufNewFile,BufRead devbox.lock set filetype=json ]]
vim.cmd [[ autocmd BufNewFile,BufRead pubspec.lock set filetype=json ]]
vim.cmd [[ autocmd BufNewFile,BufRead package.lock set filetype=json ]]
vim.cmd [[ autocmd BufNewFile,BufRead .tmux.conf set filetype=bash ]]
vim.cmd [[ autocmd FileType dap-repl set filetype=log ]]
vim.cmd [[ autocmd BufNewFile,BufRead *.bru set filetype=bruno ]]

vim.cmd [[autocmd ColorScheme * highlight NvimTreeNormal guibg=#ffff00]]

vim.cmd [[autocmd bufwritepost kitty.conf :silent !kill -SIGUSR1 $(pgrep kitty)]]
