vim.g.selected_run_config = 'test'


function SelectRunConfig()
  local telescope = require('telescope')

  -- require('notify')(tableToString(telescope.extensions.dap))
  telescope.load_extension('dap')
  telescope.extensions.dap.configurations({

    attach_mappings = function(prompt_bufnr, map)
      local execute_selected = function()
        local entry = require('telescope.actions.state').get_selected_entry(prompt_bufnr)
        if not entry then
          return
        end
        -- local config = entry

        -- vim.fn.execute("!bash " .. vim.fn.shellescape(file_path))
        require('telescope.actions').close(prompt_bufnr)
        -- require('notify')(config)
        -- print("Executing: " .. tableToString(entry))
        local config = entry.value
        vim.g.selected_run_config = entry.value
        require('notify')('selected '.. config.name)
      end

      -- Map <CR> to execute the selected file in Bash
      map('i', '<CR>', execute_selected)
      map('n', '<CR>', execute_selected)

      return true
    end,
  })
  --   prompt_title = 'Select a file to execute in Bash',
end
