require("utils.find_replace")
require("utils.common_utils")
require("utils.go_to_test")
require("utils.run_script")
require("utils.select_run_config")

local Util = require("lazyvim.util")

function SelectConfigAndRun()
	require('utils.select_run_config').selectRunConfig()
end

-- local is_default_buffer = function()
-- 	return require('utils.buffers').is_not_focused_buffer("NvimTree_1", "mind")
-- end

vim.cmd [[:tnoremap <Esc> <C-\><C-n>]]


local function implementThisTestWithContext()
	local path = GetFilePath()
	vim.notify(path)

	local command = "ai_task_implement_spec3 " .. path .. " | extract | tee $(other " .. path .. ")"
	executeShell(command)
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
		["Infer code under test"] = implementThisTestWithContext,
		["Criticize this file"] = criticizeThisFile,
		["Find logic flaws"] = findLogicFlaws,
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


local keys = {
	--navigation
	{ "<space>0",       Key "%",                                                                         "% Parenthese" },
	{ "<C-cr>",         Key "n",                                                                         "?" },
	{ "<space>n",       function() vim.lsp.buf.definition() end,                                         "Go to definition", },
	{ "<space>ne",      function() vim.lsp.buf.definition() end,                                         "Go to definition", },
	-- jumps
	{ "<space>fu",      function() require("trouble").next({ skip_groups = true, jump = true, }) end,    "Next problem" },
	{ "<space>aa",      Cmd ":Arrow open",                                                               "Arrow open", },
	{ "afn",            function() require("trouble").previous({ skip_groups = true, jump = true }) end, "Previous diagnos", },
	{ "<space>fw",      Cmd ":FzfLua blines",                                                            "Find in buff", },
	{ "<C-f>",          require("fzf-lua").live_grep,                                                    "Live grep" },
	{ "af",             require("fzf-lua").live_grep,                                                    "Live grep" },
	{ "<space>fr",      Key ":lua find_replace_prompt()",                                                "File find/rep", },
	{ "<space>ni",      require("fzf-lua").lsp_implementations,                                          "Impl" },
	{ "<space>no",      require("fzf-lua").lsp_references,                                               "Reference" },
	{ "<space>z",       Cmd ':Zen',                                                                      "Zen" },
	{ "<C-e>",          function() require("fzf-lua").files() end,                                       "Find files", },
	{ "<C-o>",          Cmd ":Other",                                                                    "Open other", },
	-- Code actions
	{ "<space>e",       function() vim.lsp.buf.code_action() end,                                        "Code action (visual)", },
	-- { "<space><space>", Cmd ":silent !dart format %",                                                           "Format", },
	{ "<space><space>", function() vim.lsp.buf.format() end,                                             "Format", },
	{ "<space>h",       function() require("hover").hover() end,                                         "Format", },
	{ "tr",             Cmd ":Other",                                                                    "Open other", },
	{ "<space>O",       Cmd ":Other test",                                                               "Find files", },
	{ "<space>e",       function() vim.lsp.buf.code_action() end,                                        "Code action (visual)", },
	{ "<space>h",       function() require("hover").hover() end,                                         "Format", },
	{ "tr",             function() vim.lsp.buf.rename() end,                                             "Rename", },
	{ "Tr",             Cmd ":FlutterRename",                                                            "Flutter Rename", },
	{ "<space>H",       function() vim.diagnostic.open_float() end,                                      "Floating diagnos", },
	{ '<space>ae',      ':Gen<cr>',                                                                      'AI Actions' },
	{ '<space>nn',      implementThisTestWithContext,                                                    'AI Actions' },
	{ '<space>ai',      selectAiCommand,                                                                 'AI Actions' },
	-- { '<space>ai', function()
	-- 	if is_default_buffer() then
	-- 		local menu = require("utils.ollama_picker")
	-- 		menu.toggle()
	-- 	end
	-- end, 'Gen toggle' },
	--editor windows
	--
	{ "<space>Y",       Cmd ":%bdelete:Neotree focus",                                                   "Close all buffers", },
	{ "<space>Y",       Key ":%bdelete\n:Neotree focus\n",                                               "Close all buffers", },
	{ "ta",             Cmd ":AerialToggle",                                                             "AerialToggle", },
	{ "<C-y>",          Cmd ":Bdelete",                                                                  "Close buffer", },
	{ "<space>y",       Cmd ":Bdelete",                                                                  "Close buffer", },
	--flutter runs
	{ "<space>su",      SelectConfigAndRun,                                                              "SelectRunConfig", },
	{ "<space>nu",      Cmd ":FlutterRun",                                                               "FlutterRun" },
	{ "<space>NU",      Cmd ":FlutterRestart",                                                           "FlutterRestart" },
	{ "<space>ly",      Cmd ":FlutterQuit",                                                              "FlutterQuit" },

	{ "<space>N",       Cmd ":FlutterRun",                                                               "FlutterRun" },
	{ "<space>NY",      Cmd ":FlutterQuit",                                                              "FlutterRestart" },
	{ "<space>K",       Cmd ":FlutterLogClear",                                                          "FlutterLogClear", },
	{ "as",             Cmd ":FlutterVisualDebug",                                                       "Flutter Quit", },
	{ "<space>lv",      Cmd ":FlutterVisualDebug",                                                       "Flutter Visual Debug", },
	{ "ay",             Cmd ":FlutterQuit",                                                              "Flutter Quit", },
	{ "alr",            Cmd ":FlutterReanalyze",                                                         "FlutterReanalyze", },
	{ "als",            Cmd ":FlutterLspRestart",                                                        "FlutterLspRestart", },
	-- searches
	{ "<space>fb",      Cmd ":free",                                                                     desc = "Switch Buffer" },
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
	{ "<space>tv",      Cmd ":CoverageToggle",                                                           "Coverage" },
	{ "<space>kk",      function() print("spc kk") end,                                                  "SaveCommandHistory" },
	{ "<C-w>",          function() print("Cw") end,                                                      "?", },
	{ "tk",             function() print("tk") end,                                                      "?" },
	-- {
	-- 	"<C-h>",
	-- 	function()
	-- 		print("Ch")
	-- 	end,
	-- 	"?",
	-- },
	-- {
	-- 	"<C-i>",
	-- 	function()
	-- 		print("Ci")
	-- 	end,
	-- 	"?",
	-- },
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
