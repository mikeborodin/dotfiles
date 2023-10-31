require("utils.find_replace")
require("utils.common_utils")
require("utils.go_to_test")
require("utils.run_script")
local Util = require("lazyvim.util")

local keys = {
	--navigation
	{ "<space>0", "%", "% Parenthese" },
	-- jumps
	{
		"afu",
		function()
			require("trouble").next({ skip_groups = true, jump = true })
		end,
		"Next problem",
	},
	{
		"afd",
		":Trouble<cr>",
		"Next problem",
	},
	{
		"afn",
		function()
			require("trouble").previous({ skip_groups = true, jump = true })
		end,
		"Previous diagnos",
	},
	{
		"<space>ff",
		require("telescope.builtin").current_buffer_fuzzy_find,
		"Find in buff",
	},
	{ "<space>fw", require("telescope.builtin").live_grep, "Live grep" }, --deprecated
	{ "<C-f>", require("telescope.builtin").live_grep, "Live grep" }, --deprecated
	{ "af", require("telescope.builtin").live_grep, "Live grep" },
	{
		"<space>fr",
		":lua find_replace_prompt()<cr>",
		"File find/rep",
	},
	{ "<space>ni", require("telescope.builtin").lsp_implementations, "Impl" },
	{ "<space>no", require("telescope.builtin").lsp_references, "Reference" },
	{
		"<C-e>",
		function()
			require("telescope.builtin").find_files({ hidden = true })
		end,
		"Find files",
	},
	{
		"<C-o>",
		":Other<cr>",
		"Open other",
	},
	{
		"<space>nO",
		":Other<cr>",
		"Open other",
	},
	{
		"<space>O",
		":Other test<cr>",
		"Find files",
	},
	-- Code actions
	{
		"<space>e",
		function()
			vim.lsp.buf.code_action()
		end,
		"Code action (visual)",
	},
	{
		"<space><space>",
		function()
			vim.lsp.buf.format()
		end,
		"Format",
	},
	{
		"<space>h",
		function()
			require("hover").hover()
		end,
		"Format",
	},
	{
		"tr",
		function()
			vim.lsp.buf.rename()
		end,
		"Rename",
	},
	{
		"Tr",
		":FlutterRename<cr>",
		"Flutter Rename",
	},
	{
		"<space>H",
		function()
			vim.diagnostic.open_float()
		end,
		"Floating diagnos",
	},
	--
	--editor windows
	{
		"<space>ya",
		'<cmd>%bdelete<cr><cmd>Neotree focus<cr>',
		"Close all buffers",
	},
	{
		"<C-y>",
		":Bdelete<cr>",
		"Close buffer",
	},
	{
		"<space>y",
		":Bdelete<cr>",
		"Close buffer",
	},
	--flutter runs
	{ "at", ":FlutterRun<cr>", "FlutterRun" },
	{ "<space>NE", ":FlutterRun<cr>", "FlutterRun" },
	{ "<space>NI", ":FlutterRestart<cr>", "FlutterRestart" },
	{ "<space>NY", ":FlutterQuit<cr>", "FlutterRestart" },
	{
		"ar",
		"<cmd>FlutterRestart<cr>",
		"Flutter Restart",
	},
	{
		"as",
		"<cmd>Telescope flutter commands<cr>",
		"Find fluttercmd",
	},
	{
		"ak",
		"<cmd>FlutterLogClear<cr>",
		"FlutterLogClear",
	},
	{
		"<space>NK",
		"<cmd>FlutterLogClear<cr>",
		"FlutterLogClear",
	},
	{
		"as",
		"<cmd>FlutterVisualDebug<cr>",
		"Flutter Quit",
	},
	{
		"ay",
		"<cmd>FlutterQuit<cr>",
		"Flutter Quit",
	},
	{
		"alr",
		"<cmd>FlutterReanalyze<cr>",
		"FlutterReanalyze",
	},
	{
		"als",
		"<cmd>FlutterLspRestart<cr>",
		"FlutterLspRestart",
	},
	{
		"adn",
		function()
			-- it wokrs for selecting devices
			require("flutter-tools").setup_project({
				{
					-- name = "Dev-debug",
					-- flavor = "dev",
					-- target = "lib/main_dev.dart",
					-- device = "A6AAC97D-0372-4A11-ACCF-2F784A02D70C",
					device = "3D2FCA91-D8F9-44C2-AEB2-C1712B59E9F2",
					-- dart_define = {
					-- 	API_URL = "https://dev.example.com/api",
					-- 	IS_DEV = true,
					-- },
					-- dart_define_from_file = "config.json", -- the path to a JSON configuration file
				},
			})
		end,
		"Select Flutter Devices",
	},
	-- searches
	{ "<space>fb", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
	{ "<space>fF", Util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
	{ "<space>fR", Util.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent (cwd)" },
	{ "<space>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
	{ "<space>RR", "<cmd>Telescope resume<cr>", desc = "Resume" },
	{
		"<space>ab",
		require("telescope.builtin").buffers,
		"Buffers",
	},
	{
		"ah",
		require("telescope.builtin").diagnostics,
		"Find diagnost",
	},

	--debugging starts with S
	{
		"su",
		"<cmd>DapContinue<cr>",
		"DapContinue",
	},
	{
		"st",
		"<cmd>DapToggleBreakpoint<cr>",
		"Toggle breakpnt",
	},
	{
		"sh",
		function()
			require("dapui").toggle()
		end,
		"Toggle DapUI",
	},
	--testing
	-- :Coverage && CoverageToggle
	-- new
	{ "<space>l", "space l", "?" },
	{ "<space>tv", ":CoverageToggle<cr>", "Coverage" },
	{
		"<C-w>",
		function()
			print("Cw")
		end,
		"?",
	},
	{
		"<C-h>",
		function()
			print("Ch")
		end,
		"?",
	},
	{
		"<C-i>",
		function()
			print("Ci")
		end,
		"?",
	},
	{ "tk", function() end, "?" },
}

useKeymapTable(keys)
