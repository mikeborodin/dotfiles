require("utils.find_replace")
require("utils.common_utils")
require("utils.go_to_test")

local keys = {
  --this are my mappings! mine
  --selected
  { '<space>u',  '<cmd>silent write<cr>',                                                         'Save all buffers' },
  { '<space>U',  '<cmd>wa<cr>',                                                                   'Save all buffers' },
  { '<space>q',  '<cmd>qa<cr>',                                                                   'Flutter Run' },
  { '<space>q',  '<cmd>qa<cr>',                                                                   'Flutter Run' },
  { '<C-q>w',    '<cmd>qa<cr>',                                                                   'Flutter Run' },
  { 'q',         'a',                                                                             '<a>' },
  { 'm',         'a',                                                                             '<a>' },
  { 'tv',        '<C-v>',                                                                         'Visual block' },
  { '[[',        'gg',                                                                            'Command' },
  { ']]',        'G',                                                                             'Command' },
  { 'N',         ':bprev<cr>',                                                                    'Command' },
  { 'U',         ':bnext<cr>',                                                                    'Command' },
  { 'tn',        '<C-w>h',                                                                        'Window left' },
  { 'ti',        '<C-w>l',                                                                        'Window right' },
  { 'te',        '<C-w>j',                                                                        'Window down' },
  { 'tu',        '<C-w>k',                                                                        'Window top ' },
  { 'H',         '<C-r>',                                                                         'Redo' },
  { '<space>ny', '<C-o>',                                                                         'Go back' },
  { '<space>nY', '<C-I>',                                                                         'Go back' },
  { '<space>n;', '<C-i>',                                                                         'Go next' },
  { '<space>fn', 'n',                                                                             'Find next search result' },
  { '<space>on', '<C-w>v',                                                                        'Split vertical' },
  { '<space>oe', '<C-w>s',                                                                        'Split horizontal' },
  { 'tyn',       ':q<cr>',                                                                        'Close window' },
  { '<space>ne', guard(function() vim.lsp.buf.definition() end, 'editor.action.goToDeclaration'), 'Go to definition' },
}

useKeymapTable(keys)
