return {
  {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    enabled = true,
    init = false,
    opts = function()
      local dashboard = require 'alpha.themes.dashboard'

      local logo = [[Let's rock!
             ]]

      dashboard.section.header.val = vim.split(logo, '\n')

            -- stylua: ignore
            dashboard.section.buttons.val = {
                dashboard.button("r", " Recent", "<cmd> Telescope oldfiles <cr>"),
                dashboard.button("s", " Restore", [[<cmd> lua require("persistence").load() <cr>]]),
                dashboard.button("q", " Quit", "<cmd> qa <cr>")
            }

      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = 'Comment'
        button.opts.hl_shortcut = ''
        button.opts.position = 'center'
        button.opts.width = 25
      end
      dashboard.section.header.opts.hl = ''
      dashboard.section.footer.opts.hl = 'Keyword'
      dashboard.opts.layout[1].val = 8
      return dashboard
    end,

    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == 'lazy' then
        vim.cmd.close()
        vim.api.nvim_create_autocmd('User', {
          once = true,
          pattern = 'AlphaReady',
          callback = function()
            require('lazy').show()
          end,
        })
      end

      require('alpha').setup(dashboard.opts)

      vim.api.nvim_create_autocmd('User', {
        once = true,
        pattern = 'LazyVimStarted',
        callback = function()
          -- Get the current date and time

          -- Get the current hour
          local current_hour = tonumber(os.date '%H')

          -- Define the greeting variable
          local greeting

          if current_hour < 5 then
            greeting = '    Good night!'
          elseif current_hour < 12 then
            greeting = '  󰼰 Good morning!'
          elseif current_hour < 17 then
            greeting = '    Good afternoon!'
          elseif current_hour < 20 then
            greeting = '  󰖝  Good evening!'
          else
            greeting = '  󰖔  Good night!'
          end

          dashboard.section.footer.val = greeting

          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
}
