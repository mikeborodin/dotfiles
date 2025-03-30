local function input(prompt)
  return vim.fn.input(prompt)
end

function Find_replace_prompt()
  local search_str = input 'Replace: '
  local replace_str = input 'With: '
  search_str = vim.fn.escape(search_str, '/')
  replace_str = vim.fn.escape(replace_str, '/')
  vim.cmd('%s/' .. search_str .. '/' .. replace_str .. '/g')
end
