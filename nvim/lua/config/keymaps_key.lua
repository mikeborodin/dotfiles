require("utils.find_replace")
require("utils.common_utils")
require("utils.go_to_test")
require("utils.run_script")
require("utils.select_run_config")
require("utils.diagnostics")

local Util = require("lazyvim.util")

function _G.open_next_terminal()
  local Terminal  = require('toggleterm.terminal').Terminal
  local terms     = require('toggleterm.terminal').get_all()
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
    print("Buffer with filename '__FLUTTER_DEV_LOG__' not found")
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
      border = 'single'
    })
  end
end

local function implementSpec4()
  local path = GetFilePath()

  local other = '$(other ' .. path .. ')'
  local createFileCommand = '  mkdir -p $(dirname ' .. other .. ') && touch ' .. other

  local command = "ai_task_implement_spec4 " .. path .. " | extract | tee " .. other
  executeShell(createFileCommand .. ' && ' .. command)
end

local function selectOllamaModel()
  executeShell('selectOllamaModel && clear')
end

local function implementDirect()
  local path = GetFilePath()

  local other = '$(other ' .. path .. ')'
  local createFileCommand = '  mkdir -p $(dirname ' .. other .. ') && touch ' .. other

  local command = "ai_task_implement_direct " .. path .. " | extract | tee " .. other
  executeShell(createFileCommand .. ' && ' .. command)
end
local function updateSpec4()
  local path = GetFilePath()

  local other = '$(other ' .. path .. ')'
  local createFileCommand = '  mkdir -p $(dirname ' .. other .. ') && touch ' .. other

  local command = "ai_task_update_spec4 " .. path .. " | extract | tee " .. other
  executeShell(createFileCommand .. ' && ' .. command)
end

local function criticizeThisFile()
  local path = GetFilePath()
  vim.notify(path)

  local command = "ai_task_criticize " .. path .. " | glow"
  executeShell(command)
end

function executeShell(command)
  vim.cmd("TermExec cmd='" .. command .. "'")
end

function executeShellAndPrintToSplitPane(command)
  vim.cmd('vsplit')
  vim.cmd("TermExec cmd='" .. command .. "'")
end

local function findLogicFlaws()
  local path = GetFilePath()
  vim.notify(path)

  local command = "ai_task_logic_flaws " .. path .. " | glow"
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
    ["Implement under test (spec)"] = implementSpec4,
    ["Update code under test (spec)"] = updateSpec4,
    ["Implenent under test (direct)"] = implementDirect,
    ["Criticize code this file"] = criticizeThisFile,
    ["Find logic flaws in this file"] = findLogicFlaws,
    ["Select Model"] = selectOllamaModel,
  }
  vim.ui.select(
    getKeys(tasks),
    { prompt = "Select task" },
    function(choice)
      if (choice == nil) then return end

      tasks[choice]()
    end
  )
end

-- command can be one of:
-- * source.sortMembers
-- * source.organizeImports
-- * source.fixAll
local function executeLsp(command)
  vim.lsp.buf.code_action({
    filter = function(action)
      return action.kind == command
    end,
    apply = true,
  })
end


local function autoFix()
  if vim.bo.filetype == 'dart' then
    executeLsp('source.fixAll')
  else
    vim.lsp.buf.format()
  end
end

local keys = {
  --navigation
  { "<space>0",       Key "%",                                                                         "% Parenthese" },
  { "<C-cr>",         Key "n",                                                                         "?" },
  { "<space>ne",      function() vim.lsp.buf.definition() end,                                         "Go to definition", },
  { "<space>ni",      require("fzf-lua").lsp_implementations,                                          "Impl" },
  { "<space>no",      require("fzf-lua").lsp_references,                                               "Reference" },
  { "<space>i",       function() vim.lsp.buf.definition() end,                                         "Go to definition", },
  -- jumps
  { "<space>nu",      function() require("trouble").next({ skip_groups = true, jump = true, }) end,    "Next problem" },
  -- { "<space>aa",      Cmd ":Arrow open",                                                               "Arrow open", },
  { "afn",            function() require("trouble").previous({ skip_groups = true, jump = true }) end, "Previous diagnos", },
  { "<space>fw",      Cmd ":FzfLua blines",                                                            "Find in buff", },
  { "<C-f>",          require("fzf-lua").live_grep,                                                    "Live grep" },
  { "af",             require("fzf-lua").live_grep,                                                    "Live grep" },
  { "<space>fr",      Key ":lua find_replace_prompt()",                                                "File find/rep", },
  { "<space>z",       Cmd ':Zen',                                                                      "Zen" },
  { "<C-e>",          function() require("fzf-lua").files() end,                                       "Find files", },
  { "<C-o>",          Cmd ":Other",                                                                    "Open other", },
  -- Code actions
  { "<space>e",       function() vim.lsp.buf.code_action() end,                                        "Code action (visual)", },
  -- { "<space><space>", Cmd ":silent !dart format %",                                                           "Format", },
  { "<space><space>", function() vim.lsp.buf.format() end,                                             "Format", },
  { "<BS><BS>",       autoFix,                                                                         "Fix All & organizeImports" },
  { "<space>df",      Cmd ':silent !dart format %',                                                    "Format", },
  { "<space>h",       function() require("hover").hover() end,                                         "Format", },
  { "tr",             Cmd ":Other",                                                                    "Open other", },
  { "<space>O",       Cmd ":Other test",                                                               "Find files", },
  { "<space>e",       function() vim.lsp.buf.code_action() end,                                        "Code action (visual)", },
  { "<space>h",       function() require("hover").hover() end,                                         "Format", },
  { "tr",             function() vim.lsp.buf.rename() end,                                             "Rename", },
  { "Tr",             Cmd ":FlutterRename",                                                            "Flutter Rename", },
  { "<space>H",       function() vim.diagnostic.open_float() end,                                      "Floating diagnos", },
  { '<space>nn',      Cmd ':AvanteToggle',                                                             'AI Actions' },
  { '<space>ae',      ':Gen<cr>',                                                                      'AI Actions' },
  -- { '<space>ai', function()
  -- 	if is_default_buffer() then
  -- 		local menu = require("utils.ollama_picker")
  -- 		menu.toggle()
  -- 	end
  -- end, 'Gen toggle' },
  --editor windows
  --
  { "<space>Y",       Key ":%bdelete\n:Neotree focus\n",                                               "Close all buffers", },
  { "ta",             Cmd ":AerialToggle",                                                             "AerialToggle", },
  { "<C-y>",          function() require('bufdelete').bufdelete() end,                                 "Close buffer", },
  --flutter runs
  { "<space>su",      SelectConfigAndRun,                                                              "SelectRunConfig", },
  -- { "<space>n",       FlutterCmdOrDefault(":FlutterRun", ":DapContinue"),                              "Run" },
  { "<space>n",       Cmd(":FlutterRun"),                                                              "Run" },
  { "<space>u",       Cmd ":FlutterRestart",                                                           "FlutterRestart" },
  { "<space>y",       Cmd ":FlutterQuit",                                                              "FlutterQuit" },
  { "ao",             function() require('yazi').yazi({}, vim.fn.expand("%:p")) end,                   "Yazi" },
  -- { "sd",             PopulateLoclistWithDiagnostics,                                                  "Populate diagns" },

  { "<space>N",       Cmd ":FlutterRun",                                                               "FlutterRun" },
  { "<space>NY",      Cmd ":FlutterQuit",                                                              "FlutterRestart" },
  { "<space>K",       Cmd ":FlutterLogClear",                                                          "FlutterLogClear", },
  { "as",             Cmd ":FlutterVisualDebug",                                                       "Flutter Quit", },
  { "<space>lv",      Cmd ":FlutterVisualDebug",                                                       "Flutter Visual Debug", },
  { "alr",            Cmd ":FlutterReanalyze",                                                         "FlutterReanalyze", },
  { "<space>rr",      Cmd ":FlutterLspRestart",                                                        "FlutterLspRestart", },
  -- searches
  { "<space>fb",      Cmd ":free",                                                                     desc = "Switch Buffer" },
  { "<space>ff",      Cmd ":Telescope commander",                                                      desc = "Switch Buffer" },
  { "<space>fF",      Util.telescope("files", { cwd = false }),                                        desc = "Find Files (cwd)" },
  { "<space>fR",      Util.telescope("oldfiles", { cwd = vim.loop.cwd() }),                            desc = "Recent (cwd)" },
  { "<space>ts",      Cmd ":FzfLua git_status",                                                        desc = "status" },
  { "<space>re",      Cmd ":FzfLua resume",                                                            desc = "Resume" },
  { "<space>ab",      require("fzf-lua").buffers,                                                      "Buffers", },
  { "ah",             require('fzf-lua').diagnostics_workspace,                                        "Diagnosis", },
  --debugging starts with S
  { "su",             Cmd ":DapContinue",                                                              "DapContinue", },
  { "st",             Cmd ":DapToggleBreakpoint",                                                      "Toggle breakpnt", },
  { "sh",             function() require("dapui").toggle() end,                                        "Open DapUI Repl", },
  { "sv",             function() require("dapui").toggle() end,                                        "Open DapUI Repl", },
  { "se",             function() require('dapui').eval(nil, { enter = true }) end,                     "Evaluate this", },
  { "sa",             function() require("dapui").float_element('stack') end,                          "Open DapUI stacks", },
  { "sc",             function() require("dapui").float_element('scopes') end,                         "Open DapUI stacks", },
  --testing
  { "<space>tf",      Cmd ':TestNearest',                                                              "Test Nearest" },
  { "<space>tw",      Cmd ':TestFile',                                                                 "Test File" },
  { "<space>l",       function() print("spc l") end,                                                   "?" },
  -- { "<C-l>",          toggle_flutter_dev_log,                                                          "Toggle Lsp Log", },

  { "<space>tv",      Cmd ":CoverageToggle",                                                           "Coverage" },
  { "<space>fm", function()
    local path = GetFilePath()
    vim.notify('opening' .. path)
    Snacks.terminal.open('yazi ' .. path)
  end, "Yazi" },
  { "<space>kk", function() print("spc kk") end,          "SaveCommandHistory" },
  { "<C-w>",     function() print("Cw") end,              "?", },
  { "tk",        function() print("tk") end,              "?" },
  { "tuy",       function() require('neoclip.fzf')() end, "Clip History" },
  -- {
  -- 	"<C-h>",
  -- 	function()
  -- 		print("Ch")
  -- 	end,
  -- 	"?",
  -- },
  {
    "<C-i>",
    function()
      require('arrow.ui').openMenu()
    end,
    "?",
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

UseKeymapTable(keys)
