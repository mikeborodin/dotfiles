return {
	"j-hui/fidget.nvim",
	tag = "v1.4.0",
	opts = {
		-- options
	},
	enabled = false,
	config = function()
		local fidget = require("fidget")
		fidget.setup()
		vim.notify = fidget.notify
	end
}
