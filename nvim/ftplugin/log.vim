
" buffer-local conceal and related settings for log files
" ensure conceal hides escape sequences and not show special characters
if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

" show conceal when not editing text; use conceallevel=2 to hide concealed text
" setlocal conceallevel=2       " 2 hides concealed text entirely
setlocal concealcursor=nc     " conceal in normal + command mode (not in insert)
setlocal wrap                 " wrap long log lines (optional)
setlocal filetype=log
