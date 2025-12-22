return {
  {
    'andythigpen/nvim-coverage',
    enabled = false,
    config = function()
      require('coverage').setup {
        coverage_file = 'coverage/lcov.info',
        summary = {
          width_percentage = 0.9,
        },
      }
    end,
  },
}
