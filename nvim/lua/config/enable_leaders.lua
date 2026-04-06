require 'utils.common_utils'

local keys = {
  { 'tf', '<Nop>', '?' },
  { 'tn', '<Nop>', '?' },
  { 'a', '<Nop>', '?' },
  { 's', '<Nop>', '?' },
  { 'q', 'a', '<a>' },
  { 'm', 'a', '<a>' },
  { 'tv', '<C-v>', 'Visual block' },
  { '[[', 'gg', 'Command' },
  { ']]', 'G', 'Command' },
  { 'N', ':bprev<cr>', 'Command' },
  { 'U', ':bnext<cr>', 'Command' },
  { 'tn', '<C-w>h', 'Window left' },
  { 'ti', '<C-w>l', 'Window right' },
  { 'te', '<C-w>j', 'Window down' },
  { 'tu', '<C-w>k', 'Window top ' },
  { 'H', '<C-r>', 'Redo' },
}

UseKeymapTable(keys)

-- Comment toggle.
-- `gcc` toggles the current line; `gc` in visual toggles the selection.
-- We do NOT remap to the gc operator because that still waits for a motion.
-- Instead map directly to the linewise comment action in each mode.
vim.keymap.set('n', 'tl', 'gcc', { remap = true, desc = 'Toggle line comment' })
vim.keymap.set('x', 'tl', 'gc',  { remap = true, desc = 'Toggle comment' })
vim.keymap.set('n', 'tj', 'gbc', { remap = true, desc = 'Toggle block comment' })
vim.keymap.set('x', 'tj', 'gb',  { remap = true, desc = 'Toggle block comment' })
