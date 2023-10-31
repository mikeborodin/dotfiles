local Util = require("lazyvim.util")
return {
	-- Fuzzy finder.
	-- The default key bindings to find files will use Telescope's
	-- `find_files` or `git_files` depending on whether the
	-- directory is a git repo.
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		version = false, -- telescope did only one release, so use HEAD for now
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				enabled = vim.fn.executable("make") == 1,
				config = function()
					Util.on_load("telescope.nvim", function()
						require("telescope").load_extension("fzf")
					end)
				end,
			},
		},
		keys = {
			-- { "<space>/", Util.telescope("live_grep"), desc = "Grep (root dir)" },
			-- { "<space>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
			-- find
			-- { "<space>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			-- { "<space>fc", Util.telescope.config_files(), desc = "Find Config File" },
			-- { "<space>ff", Util.telescope("files"), desc = "Find Files (root dir)" },
			-- { "<space>fR", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },

			-- -- git
			-- { "<space>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
			-- -- search
			-- { '<space>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
			-- { "<space>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
			-- { "<space>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
			-- { "<space>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
			-- { "<space>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
			-- { "<space>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
			-- { "<space>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
			-- { "<space>sg", Util.telescope("live_grep"), desc = "Grep (root dir)" },
			-- { "<space>sG", Util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
			-- { "<space>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
			-- { "<space>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
			-- { "<space>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
			-- { "<space>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
			-- { "<space>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
			-- { "<space>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
			-- { "<space>sw", Util.telescope("grep_string", { word_match = "-w" }), desc = "Word (root dir)" },
			-- { "<space>sW", Util.telescope("grep_string", { cwd = false, word_match = "-w" }), desc = "Word (cwd)" },
			-- { "<space>sw", Util.telescope("grep_string"), mode = "v", desc = "Selection (root dir)" },
			-- { "<space>sW", Util.telescope("grep_string", { cwd = false }), mode = "v", desc = "Selection (cwd)" },
			-- { "<space>uC", Util.telescope("colorscheme", { enable_preview = true }), desc = "Colorscheme with preview" },
			-- {
			--   "<space>ss",
			--   function()
			--     require("telescope.builtin").lsp_document_symbols({
			--       symbols = require("lazyvim.config").get_kind_filter(),
			--     })
			--   end,
			--   desc = "Goto Symbol",
			-- },
			-- {
			--   "<space>sS",
			--   function()
			--     require("telescope.builtin").lsp_dynamic_workspace_symbols({
			--       symbols = require("lazyvim.config").get_kind_filter(),
			--     })
			--   end,
			--   desc = "Goto Symbol (Workspace)",
			-- },
		},
		opts = function()
			local actions = require("telescope.actions")

			local open_with_trouble = function(...)
				return require("trouble.providers.telescope").open_with_trouble(...)
			end
			local open_selected_with_trouble = function(...)
				return require("trouble.providers.telescope").open_selected_with_trouble(...)
			end
			local find_files_no_ignore = function()
				local action_state = require("telescope.actions.state")
				local line = action_state.get_current_line()
				Util.telescope("find_files", { no_ignore = true, default_text = line })()
			end
			local find_files_with_hidden = function()
				local action_state = require("telescope.actions.state")
				local line = action_state.get_current_line()
				Util.telescope("find_files", { hidden = true, default_text = line })()
			end

			return {
				defaults = {
					sorting_strategy = "ascending",
					pickers = {
						live_grep = {
							additional_args = function(opts)
								return { "--hidden" }
							end,
						},
					},
					layout_config = {
						prompt_position = "top",
						height = 0.7,
						preview_cutoff = 40,
						width = 0.8,
					},
					prompt_prefix = " ",
					selection_caret = " ",
					-- open files in the first window that is an actual file.
					-- use the current window if no other window is available.
					get_selection_window = function()
						local wins = vim.api.nvim_list_wins()
						table.insert(wins, 1, vim.api.nvim_get_current_win())
						for _, win in ipairs(wins) do
							local buf = vim.api.nvim_win_get_buf(win)
							if vim.bo[buf].buftype == "" then
								return win
							end
						end
						return 0
					end,
					mappings = {
						i = {
							["<c-t>"] = open_with_trouble,
							["<a-t>"] = open_selected_with_trouble,
							["<a-i>"] = find_files_no_ignore,
							["<a-h>"] = find_files_with_hidden,
							["<C-Down>"] = actions.cycle_history_next,
							["<C-Up>"] = actions.cycle_history_prev,
							["<C-f>"] = actions.preview_scrolling_down,
							["<C-b>"] = actions.preview_scrolling_up,
						},
						n = {
							["q"] = actions.close,
						},
					},
				},
			}
		end,
	},
}
