return {
	"j-hui/fidget.nvim",
	tag = "v1.4.0",
	opts = {
		-- options
	},
	enabled = true,
	config = function()
		local fidget = require("fidget")
		fidget.setup()
	end
}
