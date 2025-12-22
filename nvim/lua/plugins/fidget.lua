return {
  'j-hui/fidget.nvim',
  event = 'VeryLazy',
  tag = 'v1.4.0',
  opts = {
    -- options
  },
  enabled = true,
  config = function()
    local fidget = require 'fidget'
    fidget.setup()
  end,
}
