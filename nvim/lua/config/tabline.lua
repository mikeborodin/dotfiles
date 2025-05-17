local M = {}

local tabline_str = ''
local augroup = vim.api.nvim_create_augroup('MyTablineUpdate', { clear = true })

-- Get project root
local function get_project_root()
  local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if vim.v.shell_error == 0 and root ~= '' then return root end
  return vim.fn.getcwd()
end

-- Recompute tabline
function M.update_tabline()
  local filepath = vim.fn.expand('%:p')
  local root = get_project_root()
  local rel_path = filepath:find(root, 1, true) == 1 and filepath:sub(#root + 2) or filepath

  local branch = vim.fn.systemlist("git branch --show-current")[1]
  if vim.v.shell_error ~= 0 then branch = '' end

  local count = #vim.fn.getbufinfo({ buflisted = 1 })

  tabline_str = table.concat({
    branch ~= '' and ('' .. branch .. '  ') or '',
    '  ',
    rel_path ~= '' and rel_path or '[No File]',
    ' %= ',
    '   Buffers: ' .. count,
  }, ' ')
end

-- Return cached string
function _G.my_tabline()
  return tabline_str
end

-- Set tabline
-- vim.o.tabline = '%!v:lua.my_tabline()'
-- vim.o.showtabline = 2
-- vim.o.laststatus = 0

-- Update on relevant events
vim.api.nvim_create_autocmd({
  'BufEnter',
  'BufWritePost',
  'BufAdd',
  'BufUnload',
  'BufDelete',
  'BufLeave',
  'TabEnter',
  'DirChanged',
  'VimEnter',
}, {
  group = augroup,
  callback = function()
    -- M.update_tabline()
  end,
})

-- Initial fill
-- M.update_tabline()
