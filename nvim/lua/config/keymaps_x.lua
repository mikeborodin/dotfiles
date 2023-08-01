local function xmap(keys, cmd, desc)
  vim.keymap.set('x', keys, cmd, { noremap = true, desc = desc, silent = true, })
end

local keys = {
  { 'p',        'P',                                      'paste' },
  { '<Space>e', function() vim.lsp.buf.code_action() end, 'Code action (visual)' },
  -- { '<space>U', '<Cmd>call copilot#Complete()<CR>',       'copilot complete' },
}

for _, shortcut in pairs(keys) do
  xmap(shortcut[1], shortcut[2], shortcut[3])
end
