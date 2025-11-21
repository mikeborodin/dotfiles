" detect .log filetype
augroup filetypedetect_log
  autocmd!
  autocmd BufRead,BufNewFile *.log setfiletype log
augroup END
