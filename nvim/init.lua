vim.o.guicursor = ""
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  callback = function()
    vim.o.guicursor = "n-v-c:block,i:ver25,r-cr:hor20,o:hor50,a:blinkon0"  -- valid
    vim.cmd("redraw!")
  end,
})

require 'config.options'
require 'config.colemak'
require 'config.enable_leaders'

vim.cmd("source " .. vim.fn.stdpath("config") .. "/colors/rootbeet.vim")

vim.g.loaded_syntastic_dart_dartanalyzer_checker = 0

local function SetIsFlutterProject()
  local pubspec = vim.fn.glob 'pubspec.yaml'

  if pubspec == '' then
    return false
  end
  local pubspec_content = vim.fn.readfile(pubspec)
  local joined_content = table.concat(pubspec_content, '\n')

  local flutter_dependency = string.match(joined_content, 'flutter:\n[%s\t]*sdk:[%s\t]*flutter')
  vim.g.x_is_flutter_project = flutter_dependency ~= nil
end

-- SetIsFlutterProject()

require 'config.setup_lazy'
require 'config.keymaps_clear'
-- require 'config.callbacks'
require 'config.keymaps_x'
require 'config.autocmds'
require 'config.keymaps_crosseditor'
require 'config.keymaps_key'
-- require 'config.repl_highlight'
require 'config.snippets'
-- require 'config.tabline'

vim.filetype.add {
  pattern = {
    ['.*/%.github[%w/]+workflows[%w/]+.*%.ya?ml'] = 'yaml.github',
  },
}

vim.lsp.enable {
  'lua_ls',
  'dartls',
  'jsonls',
  'nushell',
  'gh_actions_ls',
  'yaml_ls',
}

vim.lsp.handlers['window/showMessage'] = function(_, result, ctx)
  if result.message:match 'didChange' then
    return -- ignore these messages
  end
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  local lvl = ({ 'ERROR', 'WARN', 'INFO', 'DEBUG' })[result.type]
  vim.notify(result.message, vim.log.levels[lvl], { title = client and client.name or 'LSP' })
end

vim.diagnostic.config {
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
  },
}
