vim.api.nvim_exec(
  [[
  highlight FlutterHighlight guifg=yellow ctermfg=yellow
]],
  false
)

vim.cmd [[
  augroup DAPREPLHighlight
    autocmd!
    autocmd BufEnter,BufWinEnter,TabEnter * lua HighlightFlutter()
  augroup END
]]

function HighlightFlutter()
  if vim.bo.buftype == 'dap-repl' then
    vim.cmd 'syntax match FlutterHighlight /^flutter.*/'
  end
end
