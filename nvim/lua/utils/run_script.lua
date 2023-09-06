function RunProjectScript()
  local telescope = require('telescope.builtin')

  require('telescope.builtin').find_files({
    prompt_title = 'Select a file to execute in Bash',
    attach_mappings = function(prompt_bufnr, map)
      local execute_selected = function()
        local entry = require('telescope.actions.state').get_selected_entry(prompt_bufnr)
        if not entry then
          return
        end
        local file_path = entry.path
        -- vim.fn.execute("!bash " .. vim.fn.shellescape(file_path))
        require('telescope.actions').close(prompt_bufnr)
        require('notify')(file_path)
      end

      -- Map <CR> to execute the selected file in Bash
      map('i', '<CR>', execute_selected)
      map('n', '<CR>', execute_selected)

      return true
    end,
  })
end
