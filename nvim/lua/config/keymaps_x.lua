local function xmap(keys, cmd, desc)
  vim.keymap.set('x', keys, cmd, { noremap = true, desc = desc, silent = true })
end

local keys = {
  { 'p', 'P', 'paste' },
  { '<space>0', '%', '% Parenthese' },
  {
    '<space>e',
    function()
      vim.lsp.buf.code_action()
    end,
    'Code action',
  },
  { '<space>ae', ':Gen<cr>', 'AI Actions' },
  -- { '<space>U', '<Cmd>call copilot#Complete()<CR>',       'copilot complete' },
}

for _, shortcut in pairs(keys) do
  xmap(shortcut[1], shortcut[2], shortcut[3])
end
