require("utils.common_utils")

local keys = {
  { 'tf',              '<Nop>', '?' },
  { 'tn',              '<Nop>', '?' },
  { 'a',              '<Nop>', '?' },
  { 's',              '<Nop>', '?' },
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
}

useKeymapTable(keys)
