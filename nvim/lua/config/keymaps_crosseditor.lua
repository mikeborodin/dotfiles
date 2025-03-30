require 'utils.find_replace'
require 'utils.common_utils'
require 'utils.go_to_test'

local keys = {
  { '<space>u', Cmd ':silent write', 'save all buffers' },
  { '<space>U', Cmd ':wa', 'save all buffers' },
  { '<space>q', Cmd ':qa', 'flutter run' },
  { '<C-q>w', Cmd ':qa', 'flutter run' },
  { 'q', Key 'a', '<a>' },
  { 'm', function() end, '<a>' },
  { '[[', Key 'gg', 'top' },
  { ']]', Key 'G', 'bottom' },
  { 'N', Cmd ':bprev\n', 'buffer prev' },
  { 'U', Cmd ':bnext\n', 'buffer next' },
  { 'tv', '<C-v>', 'visual block' },
  { 'tn', '<C-w>h', 'window left' },
  { 'ti', '<C-w>l', 'window right' },
  { 'te', '<C-w>j', 'window up' },
  { 'tu', '<C-w>k', 'window down' },
  { 'H', '<C-r>', 'redo' },
  { '<space>ny', '<C-o>', 'go back' },
  { '<space>nY', '<C-I>', 'go back' },
  { '<space>n;', '<C-i>', 'go next' },
  { '<space>fn', Key 'n', 'find next search result' },
  { '<space>on', '<C-w>v', 'split vertical' },
  { '<space>oe', '<C-w>s', 'split horizontal' },
  { 'tyn', Cmd 'q', 'close window' },
}

UseKeymapTable(keys)
