function SelectDevice(device)
	vim.g.selectedFlutterDevice = device
	require("flutter-tools").setup_project({
		device = device,
	})
end

return {
	"axkirillov/easypick.nvim",
	keys = {
		{
			"<space>sd",
			":Easypick flutter_devices<cr>",
			"Test",
		},
	},
	dependencies = { "nvim-telescope/telescope.nvim", "akinsho/flutter-tools.nvim" },
	config = function()
		local easypick = require("easypick")
		easypick.setup({
			pickers = {
				{
					name = "git_conflicts",
					command = "git diff --name-only --diff-filter=U --relative",
					previewer = easypick.previewers.file_diff(),
				},
				{
					name = "flutter_devices",
					command = "cat " .. vim.loop.cwd() .. "/local/flutter_devices",
					previewer = easypick.previewers.default(),
					action = easypick.actions.nvim_commandf('lua SelectDevice("%s")'),
				},
			},
		})
	end,
}
