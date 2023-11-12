local base_branch = "develop"

function selectDevice(device)
	print(device)
	vim.g.selectedFlutterDevice = device
	require("flutter-tools").setup_project({
		device = device,
	})
end

return {
	"axkirillov/easypick.nvim",
	keys = {
		{
			"<space>ld",
			":Easypick flutter_devices<cr>",
			"Test",
		},
	},
	dependencies = { "nvim-telescope/telescope.nvim", "akinsho/flutter-tools.nvim" },
	config = function()
		local easypick = require("easypick")
		easypick.setup({
			pickers = {
				-- add your custom pickers here
				-- below you can find some examples of what those can look like
				-- list files inside current folder with default previewer
				{
					-- name for your custom picker, that can be invoked using :Easypick <name> (supports tab completion)
					name = "ls",
					-- the command to execute, output has to be a list of plain text entries
					command = "ls",
					-- specify your custom previwer, or use one of the easypick.previewers
					previewer = easypick.previewers.default(),
				},

				-- diff current branch with base_branch and show files that changed with respective diffs in preview
				{
					name = "changed_files",
					command = "git diff --name-only $(git merge-base HEAD " .. base_branch .. " )",
					previewer = easypick.previewers.branch_diff({ base_branch = base_branch }),
				},

				-- list files that have conflicts with diffs in preview
				{
					name = "conflicts",
					command = "git diff --name-only --diff-filter=U --relative",
					previewer = easypick.previewers.file_diff(),
				},
				{
					name = "flutter_devices",
					command = "flutter devices --machine | jq -r '.[] | .id'",
					previewer = easypick.previewers.default(),
					action = easypick.actions.nvim_commandf('lua selectDevice("%s")'),
				},
			},
		})
	end,
}
