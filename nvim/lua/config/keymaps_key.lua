require 'utils.find_replace'
require 'utils.common_utils'
require 'utils.go_to_test'
-- require 'utils.select_run_config'
require 'utils.diagnostics'

local Util = require 'lazyvim.util'

function _G.open_next_terminal()
  local Terminal = require('toggleterm.terminal').Terminal
  local terms = require('toggleterm.terminal').get_all()
  local direction = terms[1].direction
  Terminal:new({
    close_on_exit = true,
    direction = direction,
  }):toggle()
end

function SelectConfigAndRun()
  require('utils.select_run_config').selectRunConfig()
end

-- local is_default_buffer = function()
-- 	return require('utils.buffers').is_not_focused_buffer("NvimTree_1", "mind")
-- end

vim.cmd [[:tnoremap <Esc> <C-\><C-n>]]

-- Function to toggle LSP log output pop-up window
--
local popup_winid = nil

function toggle_flutter_dev_log()
  -- Find the existing buffer by filename
  local bufnr = nil
  for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_option(buffer, 'filetype') == 'log' then
      bufnr = buffer
      break
    end
  end

  -- If the buffer doesn't exist, print an error and return
  if not bufnr then
    print "Buffer with filename '__FLUTTER_DEV_LOG__' not found"
    return
  end

  if popup_winid and vim.api.nvim_win_is_valid(popup_winid) then
    -- Close the popup window if it's already open
    vim.api.nvim_win_close(popup_winid, true)
    popup_winid = nil
  else
    -- Calculate popup dimensions and position
    local width = math.floor(vim.o.columns * 0.9)
    local height = math.floor(vim.o.lines * 0.9)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    -- Create the popup window
    popup_winid = vim.api.nvim_open_win(bufnr, true, {
      relative = 'editor',
      width = width,
      height = height,
      row = row,
      col = col,
      style = 'minimal',
      border = 'single',
    })
  end
end

local function implementSpec4()
  local path = GetFilePath()

  local other = '$(other ' .. path .. ')'
  local createFileCommand = '  mkdir -p $(dirname ' .. other .. ') && touch ' .. other

  local command = 'ai_task_implement_spec4 ' .. path .. ' | extract | tee ' .. other
  executeShell(createFileCommand .. ' && ' .. command)
end

local function selectOllamaModel()
  executeShell 'selectOllamaModel && clear'
end

local function implementDirect()
  local path = GetFilePath()

  local other = '$(other ' .. path .. ')'
  local createFileCommand = '  mkdir -p $(dirname ' .. other .. ') && touch ' .. other

  local command = 'ai_task_implement_direct ' .. path .. ' | extract | tee ' .. other
  executeShell(createFileCommand .. ' && ' .. command)
end
local function updateSpec4()
  local path = GetFilePath()

  local other = '$(other ' .. path .. ')'
  local createFileCommand = '  mkdir -p $(dirname ' .. other .. ') && touch ' .. other

  local command = 'ai_task_update_spec4 ' .. path .. ' | extract | tee ' .. other
  executeShell(createFileCommand .. ' && ' .. command)
end

local function criticizeThisFile()
  local path = GetFilePath()
  vim.notify(path)

  local command = 'ai_task_criticize ' .. path .. ' | glow'
  executeShell(command)
end

function executeShell(command)
  vim.cmd("TermExec cmd='" .. command .. "'")
end

function executeShellAndPrintToSplitPane(command)
  vim.cmd 'vsplit'
  vim.cmd("TermExec cmd='" .. command .. "'")
end

local function findLogicFlaws()
  local path = GetFilePath()
  vim.notify(path)

  local command = 'ai_task_logic_flaws ' .. path .. ' | glow'
  executeShell(command)
end

function getKeys(t)
  local keys = {}
  for key, _ in pairs(t) do
    table.insert(keys, key)
  end
  return keys
end

local function selectAiCommand()
  local tasks = {
    ['Implement under test (spec)'] = implementSpec4,
    ['Update code under test (spec)'] = updateSpec4,
    ['Implenent under test (direct)'] = implementDirect,
    ['Criticize code this file'] = criticizeThisFile,
    ['Find logic flaws in this file'] = findLogicFlaws,
    ['Select Model'] = selectOllamaModel,
  }
  vim.ui.select(getKeys(tasks), { prompt = 'Select task' }, function(choice)
    if choice == nil then
      return
    end

    tasks[choice]()
  end)
end

-- command can be one of:
-- * source.sortMembers
-- * source.organizeImports
-- * source.fixAll
local function executeLsp(command)
  vim.lsp.buf.code_action {
    filter = function(action)
      return action.kind == command
    end,
    apply = true,
  }
end

local function autoFix()
  if vim.bo.filetype == 'dart' then
    executeLsp 'source.fixAll'
  elseif vim.bo.filetype == 'json' then
    vim.cmd '%!fixjson'
  else
    vim.lsp.buf.format()
  end
end

local M = {}

M.keys = {
  -- Navigation
  { '<space>0', Key '%', desc = 'Jump to match' },
  { '<D-cr>', Key 'n', desc = 'Next match' },
  {
    '<space>ne',
    function()
      vim.lsp.buf.definition()
    end,
    desc = 'Go to definition',
  },
  {
    '<space>ni',
    function()
      require('fzf-lua').lsp_implementations()
    end,
    desc = 'List implementations',
  },
  {
    '<space>no',
    function()
      require('fzf-lua').lsp_references()
    end,
    desc = 'List references',
  },
  {
    '<space>i',
    function()
      vim.lsp.buf.definition()
    end,
    desc = 'Go to definition',
  },

  -- Diagnostics navigation
  {
    '<space>nu',
    function()
      require('trouble').next { skip_groups = true, jump = true }
    end,
    desc = 'Next diagnostic',
  },
  {
    'afn',
    function()
      require('trouble').previous { skip_groups = true, jump = true }
    end,
    desc = 'Prev diagnostic',
  },

  -- File & search
  { '<space>fw', Cmd ':FzfLua blines', desc = 'Find in buffer' },
  {
    '<Char-0xA4>',
    function()
      require('fzf-lua').live_grep()
    end,
    desc = 'Search in project',
  },
  {
    'af',
    function()
      require('fzf-lua').live_grep()
    end,
    desc = 'Search in project',
  },
  { '<space>fr', Key ':lua find_replace_prompt()', desc = 'Find and replace' },
  {
    '<Char-0xA0>',
    function()
      require('fzf-lua').files()
    end,
    desc = 'Find files',
  },
  { '<Char-0xA2>', Cmd ':Other', desc = 'Open alternate file' },

  -- Code actions
  {
    '<space>e',
    function()
      vim.lsp.buf.code_action()
    end,
    desc = 'Code actions',
  },
  {
    '<space><space>',
    function()
      require('conform').format()
    end,
    desc = 'Format code',
  },
  { '<BS><BS>', autoFix, desc = 'Auto-fix & organize imports' },
  { '<space>df', Cmd ':silent !dart format %', desc = 'Format (Dart)' },
  {
    '<space>h',
    function()
      require('hover').hover()
    end,
    desc = 'Show hover info',
  },
  {
    'tr',
    function()
      vim.lsp.buf.rename()
    end,
    desc = 'Rename symbol',
  },
  { 'Tr', Cmd ':FlutterRename', desc = 'Rename (Flutter)' },
  {
    '<space>H',
    function()
      vim.diagnostic.open_float()
    end,
    desc = 'Show diagnostics',
  },
  { '<space>nn', Cmd ':AvanteToggle', desc = 'Toggle AI actions' },
  { '<space>ae', ':Gen<cr>', desc = 'AI generate' },

  -- Buffers / windows
  { '<space>Y', Key ':%bdelete\n:Neotree focus\n', desc = 'Close all buffers' },
  { 'ta', '', desc = 'Toggle Aerial outline' },
  {
    '<Char-0xA1>',
    function()
      require('bufdelete').bufdelete()
    end,
    desc = 'Close buffer',
  },

  -- Flutter
  { '<space>su', SelectConfigAndRun, desc = 'Select run config' },
  { '<space>n', Cmd ':FlutterRun', desc = 'Run app' },
  { '<space>u', Cmd ':FlutterRestart', desc = 'Hot restart' },
  { '<space>y', Cmd ':FlutterQuit', desc = 'Quit app' },
  { '<space>N', Cmd ':FlutterRun', desc = 'Run Flutter' },
  { '<space>NY', Cmd ':FlutterQuit', desc = 'Quit Flutter' },
  { '<space>K', Cmd ':FlutterLogClear', desc = 'Clear logs' },
  { 'as', Cmd ':FlutterVisualDebug', desc = 'Toggle visual debug' },
  { '<space>lv', Cmd ':FlutterVisualDebug', desc = 'Visual debug' },
  { 'alr', Cmd ':FlutterReanalyze', desc = 'Reanalyze project' },
  { '<space>rr', Cmd ':FlutterLspRestart', desc = 'Restart LSP' },
  { '<space>rl', Cmd ':!~/scripts/brl $(dirname %)', desc = 'Create barrel file' },

  -- Search & files (continued)
  { '<space>fb', Cmd ':free', desc = 'Switch buffer' },
  { '<space>ff', Cmd ':Telescope commander', desc = 'Command palette' },
  {
    '<space>fF',
    function()
      Util.telescope('files', { cwd = false })
    end,
    desc = 'Find files (cwd)',
  },
  {
    '<space>fR',
    function()
      Util.telescope('oldfiles', { cwd = vim.loop.cwd() })
    end,
    desc = 'Recent files',
  },
  { '<space>ts', Cmd ':FzfLua git_status', desc = 'Git status' },
  { '<space>re', Cmd ':FzfLua resume', desc = 'Resume search' },
  {
    '<space>ab',
    function()
      require('fzf-lua').buffers()
    end,
    desc = 'List buffers',
  },
  {
    'ah',
    function()
      require('fzf-lua').diagnostics_workspace()
    end,
    desc = 'Workspace diagnostics',
  },

  -- Debugging
  { 'su', Cmd ':DapContinue', desc = 'Continue debug' },
  { 'st', Cmd ':DapToggleBreakpoint', desc = 'Toggle breakpoint' },
  {
    'sh',
    function()
      require('dapui').toggle()
    end,
    desc = 'Toggle DAP UI',
  },
  {
    'sv',
    function()
      require('dapui').toggle()
    end,
    desc = 'Toggle DAP UI',
  },
  {
    'se',
    function()
      require('dapui').eval(nil, { enter = true })
    end,
    desc = 'Eval expression',
  },
  {
    'sa',
    function()
      require('dapui').float_element 'stack'
    end,
    desc = 'View call stack',
  },
  {
    'sc',
    function()
      require('dapui').float_element 'scopes'
    end,
    desc = 'View scopes',
  },

  -- Testing
  { '<space>tf', Cmd ':TestNearest', desc = 'Run nearest test' },
  { '<space>tw', Cmd ':TestFile', desc = 'Run test file' },
  { '<space>tv', Cmd ':CoverageToggle', desc = 'Toggle coverage' },

  -- Tasks / commands
  { '<space>sa', Cmd ':TermExec cmd=analyze', desc = 'Run analyzer' },
  { '<space>sf', Cmd ':TermExec cmd=dart_format', desc = 'Run formatter' },
  -- { '<space>su', Cmd ':TermExec cmd=submit', desc = 'Submit code' },
  { '<space>gm', Cmd ':silent !git switch main', desc = 'Git: switch to main' },
  {
    '<space>sp',
    function()
      vim.ui.input({ prompt = 'Describe changes:', default = 'feat: ' }, function(input)
        if input then
          vim.cmd(':TermExec cmd=\'push "' .. input .. '"\'')
          vim.notify(input)
        end
      end)
    end,
    desc = 'Git: push with message',
  },
  -- nu -c \"source devenv.nu; dart_format\"
  {
    '<space>su',
    function()
      local fidget_notify = require('fidget').notify
      vim.fn.jobstart('devbox run script submit', {
        stdout_buffered = true,
        stderr_buffered = true,
        on_exit = function(_, exit_code, stdout, stderr)
          if exit_code == 0 then
            fidget_notify 'Finished'
          else
            fidget_notify('Error: \n stdout:' .. (stdout or '') .. '\n stderr:' .. (stderr or ''))
          end
        end,
      })
      fidget_notify 'Submitting...'
    end,
    desc = 'Git: submit',
  },
  {
    '<space>sb',
    function()
      vim.ui.input({ prompt = 'Branch name:', default = 'feat/CONN-' }, function(input)
        if input then
          vim.fn.jobstart('git switch --create ' .. input, {
            stdout_buffered = true,
            stderr_buffered = true,
            on_exit = function(_, exit_code, stdout, stderr)
              local fidget_notify = require('fidget').notify
              if exit_code == 0 then
                fidget_notify 'On new branch'
              else
                fidget_notify('Error creating: \n stdout:' .. (stdout or '') .. '\n stderr:' .. (stderr or ''))
              end
            end,
          })
        end
      end)
    end,
    desc = 'Git: create branch',
  },

  -- Misc
  {
    'tk',
    function()
      print 'tk'
    end,
    desc = 'Test key',
  },
  {
    'tuy',
    function()
      require 'neoclip.fzf'()
    end,
    desc = 'Clipboard history',
  },
  {
    '<Char-0xA3>',
    function()
      require('arrow.ui').openMenu()
    end,
    desc = 'Open Arrow menu',
  },
}

-- {
-- 	"adn",
-- 	function()
-- 		--TODO: make it work
-- 		-- it wokrs for selecting devices
-- 		require("flutter-tools").setup_project({
-- 			{
-- 				device = "3D2FCA91-D8F9-44C2-AEB2-C1712B59E9F2",
-- 			},
-- 		})
-- 	end,
-- 	"Select Flutter Devices",
-- },

-- UseKeymapTable(keys)
--
return M
