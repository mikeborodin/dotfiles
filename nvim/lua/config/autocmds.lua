local function augroup(name)
  return vim.api.nvim_create_augroup('lazyvim_' .. name, { clear = true })
end
-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup 'checktime',
  command = 'checktime',
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter', 'WinEnter', 'TabEnter' }, {
  callback = function()
    require('lualine').refresh()
  end,
})

-- Minimal smart autosave
local function should_save(buf)
  local fn = vim.fn

  -- List of filetypes to ignore
  local ignore_filetypes = {
    'TelescopePrompt',
    'help',
    'qf',
    'dashboard',
    'gitcommit',
    'toggleterm',
    'lazy',
  }
  local modifiable = fn.getbufvar(buf, '&modifiable') == 1
  local buftype = fn.getbufvar(buf, '&buftype') -- "" for normal files
  local filetype = fn.getbufvar(buf, '&filetype')

  -- Save only if modifiable, normal buffer, and filetype not ignored
  if modifiable and buftype == '' then
    for _, ft in ipairs(ignore_filetypes) do
      if filetype == ft then
        return false
      end
    end
    return true
  end
  return false
end

-- Autocmd for autosave
-- vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost' }, {
--   callback = function(args)
--     local buf = args.buf
--     if should_save(buf) and vim.bo[buf].modified then
--       vim.cmd 'write'
--     end
--   end,
-- })

local autosave_delay = 300 -- milliseconds
local autosave_timers = {}

local function schedule_autosave(buf)
  -- overwrite any previous deferred autosave
  autosave_timers[buf] = vim.defer_fn(function()
    -- clear the entry
    autosave_timers[buf] = nil

    -- sanity checks
    if not vim.api.nvim_buf_is_valid(buf) then
      return
    end
    if vim.bo[buf].buftype ~= '' then
      return
    end
    if not vim.bo[buf].modifiable then
      return
    end

    if vim.bo[buf].modified and should_save(buf) then
      vim.api.nvim_buf_call(buf, function()
        vim.cmd 'write'
      end)
    end
  end, autosave_delay)
end

-- autosave on leaving insert mode
vim.api.nvim_create_autocmd('InsertLeave', {
  callback = function(args)
    schedule_autosave(args.buf)
  end,
})

-- autosave on normal mode edits like dd, cc, x
vim.api.nvim_create_autocmd('TextChanged', {
  callback = function(args)
    schedule_autosave(args.buf)
  end,
})

vim.cmd [[ autocmd BufNewFile,BufRead *.metadata set filetype=yaml ]]
vim.cmd [[ autocmd BufNewFile,BufRead *.fvmrc set filetype=json ]]
vim.cmd [[ autocmd BufNewFile,BufRead *.arb set filetype=json ]]
vim.cmd [[ autocmd BufNewFile,BufRead *.code-snippets set filetype=json ]]
vim.cmd [[ autocmd BufNewFile,BufRead devbox.lock set filetype=json ]]
vim.cmd [[ autocmd BufNewFile,BufRead pubspec.lock set filetype=json ]]
vim.cmd [[ autocmd BufNewFile,BufRead package.lock set filetype=json ]]
vim.cmd [[ autocmd BufNewFile,BufRead .tmux.conf set filetype=bash ]]
vim.cmd [[ autocmd FileType dap-repl set filetype=log ]]
vim.cmd [[ autocmd BufNewFile,BufRead *.bru set filetype=bruno ]]

vim.cmd [[autocmd ColorScheme * highlight NvimTreeNormal guibg=#ffff00]]

local function update_columns_env()
  vim.env.COLUMNS = tostring(vim.o.columns)
end

-- Set once on startup
update_columns_env()

-- Update on resize
vim.api.nvim_create_autocmd('VimResized', {
  callback = update_columns_env,
})

vim.api.nvim_create_autocmd({ 'BufWritePost', 'TextChanged', 'TextChangedI' }, {
  pattern = '*.dart',
  callback = function(ev)
    require('fidget').notify('Event: ' .. ev.event .. ' | File: ' .. ev.file)
  end,
})
