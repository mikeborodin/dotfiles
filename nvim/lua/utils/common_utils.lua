function Nmap(keys, cmd, desc)
  local function runAndLog()
    if type(cmd) == 'function' then
      cmd()
    end
    --
    local file = io.open(os.getenv 'HOME' .. '/neovim_keys.log', 'a')
    if file == nil then
      return
    end
    file:write(keys .. '\n')
    file:close()
  end

  if type(cmd) == 'string' then
    vim.keymap.set('n', keys, cmd, { noremap = true, desc = desc, silent = true })
  else
    vim.keymap.set('n', keys, runAndLog, { noremap = true, desc = desc, silent = true })
  end
end

function Clear(keys)
  vim.keymap.set({ 'n', 'v' }, keys, '<Nop>', { noremap = true, silent = true })
end

function UseKeymapTable(keys)
  for _, shortcut in pairs(keys) do
    Nmap(shortcut[1], shortcut[2], shortcut[3])
  end
end

function VsQuard(nvim, vscode)
  if vim.g.vscode == nil then
    return nvim
  else
    return vscode
  end
end

function Cmd(cmd)
  return function()
    vim.cmd(cmd)
  end
end

function FlutterCmdOrDefault(cmd, fallback)
  if vim.g.x_is_flutter_project then
    return function()
      vim.cmd(cmd)
    end
  else
    return function()
      vim.cmd(fallback)
    end
  end
end

function Key(cmd)
  return function()
    vim.api.nvim_feedkeys(cmd, 'n', true)
  end
end
