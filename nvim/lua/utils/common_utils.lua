function nmap(keys, cmd, desc)
  vim.keymap.set('n', keys, cmd, { noremap = true, desc = desc, silent = true, })
end

function clear(keys)
  vim.keymap.set({ 'n', 'v' }, keys, '<Nop>', { noremap = true, silent = true })
end

function useKeymapTable(keys)
  for _, shortcut in pairs(keys) do
    nmap(shortcut[1], shortcut[2], shortcut[3])
  end
end

function guard(nvim, vscode)
  if (vim.g.vscode == nil) then
    return nvim
  else
    return vscode
  end
end
