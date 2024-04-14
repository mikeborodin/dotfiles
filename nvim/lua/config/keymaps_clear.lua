require("utils.find_replace")
require("utils.common_utils")

Clear('<space>')
Clear('s')
Clear('a')
Clear('<C-n>')
Clear('<C-i>')
Clear('<C-u>')
Clear('<C-e>')
Clear('<C-w>')
Clear('<C-S-n>')
Clear('<C-S-n>')


local keys = {
  { 'st',              '<Nop>', '?' },
  { 'sr',              '<Nop>', '?' },
  { 'ss',              '<Nop>', '?' },
  { 'sn',              '<Nop>', '?' },
  { 'si',              '<Nop>', '?' },
  { 'se',              '<Nop>', '?' },
  { 'so',              '<Nop>', '?' },
  { 's\'',             '<Nop>', '?' },
  { '<space>o',        '<Nop>', '?' },
  { '<space>t',        '<Nop>', '?' },
  { '<space>h',        '<Nop>', '?' },
  { '<space>oi',       '<Nop>', '?' },
  { '<space>oy',       '<Nop>', '?' },
  { '<space>ou',       '<Nop>', '?' },
  { '<C-n>',           '<Nop>', '?' },
  { '<C-i>',           '<Nop>', '?' },
  { '<C-e>',           '<Nop>', '?' },
  { '<C-u>',           '<Nop>', '?' },
  { 't<space><space>', '<Nop>', '?' },
  { 't<space>n',       '<Nop>', '?' },
  { 't<space>u',       '<Nop>', '?' },
  { 't<space>y',       '<Nop>', '?' },
  { 't<space>i',       '<Nop>', '?' },
  { 't<space>e',       '<Nop>', '?' },
  { 't<space>o',       '<Nop>', '?' },
  { 't<space>t',       '<Nop>', '?' },
  { 't<space>h',       '<Nop>', '?' },
  --triads:T-left
  { 't<space>t',       '<Nop>', '?' },
  { 't<space>s',       '<Nop>', '?' },
  { 't<space>f',       '<Nop>', '?' },
  { 't<space>w',       '<Nop>', '?' },
  { 't<space>r',       '<Nop>', '?' },
  { 't<space>a',       '<Nop>', '?' },
  { 't<space><space>', '<Nop>', '?' },
  --triads:S-right
  { 's<space>n',       '<Nop>', '?' },
  { 's<space>u',       '<Nop>', '?' },
  { 's<space>y',       '<Nop>', '?' },
  { 's<space>i',       '<Nop>', '?' },
  { 's<space>e',       '<Nop>', '?' },
  { 's<space>o',       '<Nop>', '?' },
  { 's<space>t',       '<Nop>', '?' },
  { 's<space>h',       '<Nop>', '?' },
  --triads:S-left
  { 's<space>s',       '<Nop>', '?' },
  { 's<space>w',       '<Nop>', '?' },
  { 's<space>r',       '<Nop>', '?' },
  { 's<space>a',       '<Nop>', '?' },
}

UseKeymapTable(keys)
