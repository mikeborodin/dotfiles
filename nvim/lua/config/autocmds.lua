local function augroup(name)
  return vim.api.nvim_create_augroup('lazyvim_' .. name, { clear = true })
end
-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup 'checktime',
  command = 'checktime',
})

-- Nvim 0.12: floating windows show a statusline by default. Suppress it for all
-- floats so plugins that haven't opted in to style='minimal' don't show a blank bar.
vim.api.nvim_create_autocmd('WinNew', {
  group = augroup 'float_no_statusline',
  callback = function(args)
    local win = vim.api.nvim_get_current_win()
    local cfg = vim.api.nvim_win_get_config(win)
    if cfg.relative ~= '' then
      vim.wo[win].statusline = ' '
    end
  end,
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

-- Native vim.ui replacements (dressing.nvim removed)
-- vim.ui.select -> Telescope; vim.ui.input -> native floating input
vim.ui.select = function(items, opts, on_choice)
  -- Defer so Telescope is loaded (it's lazy-loaded on cmd)
  vim.schedule(function()
    local ok, pickers = pcall(require, 'telescope.pickers')
    if not ok then
      -- Fallback to default if Telescope not available yet
      vim.fn.inputlist(vim.tbl_map(function(i) return tostring(i) end, items))
      return
    end
    local finders = require 'telescope.finders'
    local conf = require('telescope.config').values
    local actions = require 'telescope.actions'
    local action_state = require 'telescope.actions.state'
    local format_item = opts.format_item or tostring
    pickers.new({}, {
      prompt_title = opts.prompt or 'Select',
      finder = finders.new_table {
        results = items,
        entry_maker = function(item)
          return { value = item, display = format_item(item), ordinal = format_item(item) }
        end,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(buf, map)
        actions.select_default:replace(function()
          actions.close(buf)
          local sel = action_state.get_selected_entry()
          on_choice(sel and sel.value or nil, sel and sel.index or nil)
        end)
        map({ 'n', 'i' }, '<esc>', function()
          actions.close(buf)
          on_choice(nil, nil)
        end)
        return true
      end,
    }):find()
  end)
end

vim.ui.input = function(opts, on_confirm)
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.max(40, (opts.prompt and #opts.prompt + 20 or 40))
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'cursor',
    row = 1,
    col = 0,
    width = width,
    height = 1,
    style = 'minimal',
    border = 'rounded',
    title = opts.prompt or 'Input',
    title_pos = 'center',
  })
  vim.bo[buf].buftype = 'prompt'
  vim.fn.prompt_setprompt(buf, '')
  if opts.default then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { opts.default })
    vim.api.nvim_win_set_cursor(win, { 1, #opts.default })
  end
  vim.cmd 'startinsert!'
  local function close_and_confirm(value)
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
    on_confirm(value)
  end
  vim.keymap.set({ 'i', 'n' }, '<CR>', function()
    local line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ''
    close_and_confirm(line ~= '' and line or nil)
  end, { buffer = buf })
  vim.keymap.set({ 'i', 'n' }, '<Esc>', function()
    close_and_confirm(nil)
  end, { buffer = buf })
end

-- Auto-close old buffers when more than max_buffers listed buffers are open
-- (replaces buffers-auto-close.nvim)
local max_buffers = 6
vim.api.nvim_create_autocmd('BufAdd', {
  group = augroup 'auto_close_buffers',
  callback = function()
    local bufs = vim.tbl_filter(function(b)
      return vim.api.nvim_buf_is_loaded(b) and vim.bo[b].buflisted
    end, vim.api.nvim_list_bufs())
    if #bufs <= max_buffers then return end
    -- Sort by last used time (oldest first via bufnr as proxy) and close oldest
    table.sort(bufs)
    local current = vim.api.nvim_get_current_buf()
    for _, b in ipairs(bufs) do
      if b ~= current and #bufs > max_buffers then
        vim.api.nvim_buf_delete(b, { force = false, unload = true })
        -- recount
        bufs = vim.tbl_filter(function(x)
          return vim.api.nvim_buf_is_loaded(x) and vim.bo[x].buflisted
        end, vim.api.nvim_list_bufs())
      end
    end
  end,
})

-- LSP format-on-save (moved from autoformat.lua plugin spec)
-- Use :AutoFormatToggle to disable on the fly
local format_is_enabled = true
vim.api.nvim_create_user_command('AutoFormatToggle', function()
  format_is_enabled = not format_is_enabled
  print('Setting autoformatting to: ' .. tostring(format_is_enabled))
end, {})

local _augroups = {}
local function get_format_augroup(client)
  if not _augroups[client.id] then
    local id = vim.api.nvim_create_augroup('lsp-format-' .. client.name, { clear = true })
    _augroups[client.id] = id
  end
  return _augroups[client.id]
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = augroup 'lsp_format_on_save',
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or not client.server_capabilities.documentFormattingProvider then return end
    if client.name == 'tsserver' then return end
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = get_format_augroup(client),
      buffer = args.buf,
      callback = function()
        if not format_is_enabled then return end
        vim.lsp.buf.format {
          async = false,
          filter = function(c) return c.id == client.id end,
        }
      end,
    })
  end,
})

-- Nvim 0.12: dartls may start async and miss the FileType autocmd attach.
-- Re-attach any running dartls client that isn't yet attached to this buffer.
vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'dartls_attach',
  pattern = 'dart',
  callback = function(args)
    local buf = args.buf
    vim.defer_fn(function()
      if not vim.api.nvim_buf_is_valid(buf) then return end
      for _, client in ipairs(vim.lsp.get_clients({ name = 'dartls' })) do
        if not client.attached_buffers[buf] then
          vim.lsp.buf_attach_client(buf, client.id)
        end
      end
    end, 500)
  end,
})

-- For Flutter projects: start dartls immediately on VimEnter so the workspace
-- is already being analyzed before any .dart file is opened (enables :FlutterRun
-- without needing to open a file first).
vim.api.nvim_create_autocmd('VimEnter', {
  group = augroup 'dartls_flutter_eager_start',
  once = true,
  callback = function()
    if not vim.g.x_is_flutter_project then return end

    -- vim.lsp.enable() hooks dartls onto the FileType event, so it won't start
    -- without a dart buffer in a window. We call vim.lsp.start() directly, but
    -- we must resolve the dart binary through flutter-tools so that fvm projects
    -- use the right SDK instead of a bare "dart" that may not be on PATH.
    require('flutter-tools.executable').dart(function(dart_bin)
      local dartls_config = vim.tbl_deep_extend('force',
        vim.lsp.config['dartls'] or {},
        {
          root_dir = vim.fn.getcwd(),
          cmd = { dart_bin, 'language-server', '--protocol=lsp' },
        }
      )
      vim.lsp.start(dartls_config)
    end)
  end,
})

-- Inject project-local devbox bin into PATH when opening a devbox project.
-- This makes tools like firebase, fvm, phrase, etc. available to nvim
-- (terminal, jobstart, LSP) without polluting PATH for non-devbox projects.
-- Runs on VimEnter and DirChanged so it works both at startup and with :cd.
local function inject_devbox_path()
  local devbox_bin = vim.fn.getcwd() .. '/.devbox/nix/profile/default/bin'
  if vim.fn.isdirectory(devbox_bin) == 1 then
    local current_path = vim.env.PATH or ''
    -- Only prepend if not already present
    if not current_path:find(devbox_bin, 1, true) then
      vim.env.PATH = devbox_bin .. ':' .. current_path
    end
  end
end

vim.api.nvim_create_autocmd({ 'VimEnter', 'DirChanged' }, {
  group = augroup 'devbox_path',
  callback = inject_devbox_path,
})

vim.cmd [[ autocmd BufNewFile,BufRead *.metadata set filetype=yaml ]]
vim.cmd [[ autocmd BufNewFile,BufRead *.fvmrc set filetype=json ]]
vim.cmd [[ autocmd BufNewFile,BufRead *.arb set filetype=json ]]
vim.cmd [[ autocmd BufNewFile,BufRead *.xctestplan set filetype=json ]]
vim.cmd [[ autocmd BufNewFile,BufRead *.code-snippets set filetype=json ]]
vim.cmd [[ autocmd BufNewFile,BufRead devbox.lock set filetype=json ]]
vim.cmd [[ autocmd BufNewFile,BufRead pubspec.lock set filetype=json ]]
vim.cmd [[ autocmd BufNewFile,BufRead package.lock set filetype=json ]]
vim.cmd [[ autocmd BufNewFile,BufRead .tmux.conf set filetype=bash ]]
vim.cmd [[ autocmd BufNewFile,BufRead .kitty-session set filetype=bash ]]
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

-- vim.api.nvim_create_autocmd({ 'BufWritePost', 'TextChanged', 'TextChangedI' }, {
--   pattern = '*.dart',
--   callback = function(ev)
--     require('fidget').notify('Event: ' .. ev.event .. ' | File: ' .. ev.file)
--   end,
-- })

-- ─── Quality-of-life: plugin-less utilities ───────────────────────────────────

-- :CdHere — cd to the directory of the current file
vim.api.nvim_create_user_command('CdHere', function()
  local dir = vim.fn.expand '%:p:h'
  vim.fn.chdir(dir)
  vim.notify('cwd: ' .. dir, vim.log.levels.INFO)
end, { desc = 'cd to current file directory' })

-- dart fix --apply on save for .dart files (catches issues LSP format misses)
-- Uses `fvm dart fix` if the project root contains a .fvmrc file.
vim.api.nvim_create_autocmd('BufWritePost', {
  group = augroup 'dart_fix',
  pattern = '*.dart',
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)
    local root = vim.fs.root(args.buf, { 'pubspec.yaml', '.fvmrc', '.git' }) or vim.fn.getcwd()
    local is_fvm = vim.fn.filereadable(root .. '/.fvmrc') == 1
    local cmd = is_fvm
        and { 'fvm', 'dart', 'fix', '--apply', file }
        or { 'dart', 'fix', '--apply', file }
    vim.fn.jobstart(cmd, {
      cwd = root,
      stdout_buffered = true,
      stderr_buffered = true,
      on_exit = function(_, code)
        if code == 0 then
          -- Reload buffer silently to pick up any changes dart fix made
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(args.buf) then
              vim.api.nvim_buf_call(args.buf, function() vim.cmd 'silent! checktime' end)
            end
          end)
        end
      end,
    })
  end,
})

-- pubspec.yaml watcher: run flutter pub get automatically on save
vim.api.nvim_create_autocmd('BufWritePost', {
  group = augroup 'pubspec_pub_get',
  pattern = '*/pubspec.yaml',
  callback = function()
    vim.fn.jobstart({ 'flutter', 'pub', 'get' }, {
      cwd = vim.fn.expand '%:p:h',
      stdout_buffered = true,
      on_exit = function(_, code)
        vim.schedule(function()
          if code == 0 then
            vim.notify('flutter pub get: OK', vim.log.levels.INFO)
          else
            vim.notify('flutter pub get: failed (exit ' .. code .. ')', vim.log.levels.WARN)
          end
        end)
      end,
    })
  end,
})

-- Send visual selection to the last active toggleterm (REPL-send pattern)
-- Usage: select text in visual mode, press <leader>rs
vim.keymap.set('v', '<leader>rs', function()
  -- Yank selection into register s
  vim.cmd 'noau normal! "sy'
  local text = vim.fn.getreg 's'
  -- Send to first available toggleterm
  local ok, terminal = pcall(require, 'toggleterm.terminal')
  if not ok then
    vim.notify('toggleterm not loaded', vim.log.levels.WARN)
    return
  end
  local terms = terminal.get_all()
  if #terms == 0 then
    vim.notify('No active terminal — open one with <D-h> first', vim.log.levels.WARN)
    return
  end
  terms[1]:send(text, true)
end, { desc = 'Send selection to terminal' })
