return {
  "LintaoAmons/easy-commands.nvim",
  event = "VeryLazy",
  config = function()
    require("easy-commands").setup({
      disabledCommands = { "CopyFilename" }, -- You can disable the commands you don't want

      aliases = {                            -- You can have a alias to a specific command
        { from = "GitListCommits", to = "GitLog" },
      },

      -- It always welcome to send me back your good commands and usecases
      ---@type EasyCommand.Command[]
      myCommands = {
        -- You can add your own commands
        {
          name = "MyCommand",
          callback = 'lua vim.print("easy command user command")',
          description = "A demo command definition",
        },
        -- You can overwrite the current implementation
        {
          name = "EasyCommand",
          callback = 'lua vim.print("Overwrite easy-command builtin command")',
          description = "The default implementation is overwrited",
        },
        -- You can use the utils provided by the plugin to build your own command
        {
          name = "JqQuery",
          callback = function()
            local sys = require("easy-commands.impl.util.base.sys")
            local editor = require("easy-commands.impl.util.editor")

            vim.ui.input(
              { prompt = 'Query pattern, e.g. `.[] | .["@message"].message`' },
              function(pattern)
                local absPath = editor.buf.read.get_buf_abs_path()
                local stdout, _, stderr = sys.run_sync({ "jq", pattern, absPath }, ".")
                local result = stdout or stderr
                editor.split_and_write(result, { vertical = true })
              end
            )
          end,
          description = "use `jq` to query current json file",
        },
      },
    })
  end,
}
