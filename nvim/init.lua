require('config.options')
require('config.colemak')
require('config.enable_leaders')

vim.g.copilot_filetypes = {
  ['xml'] = false,
  ['md'] = false,
}
vim.g.loaded_syntastic_dart_dartanalyzer_checker = 0

local function SetIsFlutterProject()
  local pubspec = vim.fn.glob("pubspec.yaml")

  -- vim.g.x_is_flutter_project = pubspec ~= ""

  if pubspec == "" then return false end
  local pubspec_content = vim.fn.readfile(pubspec)
  local joined_content = table.concat(pubspec_content, "\n")

  local flutter_dependency = string.match(joined_content, "flutter:\n[%s\t]*sdk:[%s\t]*flutter")
  vim.g.x_is_flutter_project = flutter_dependency ~= nil
end


SetIsFlutterProject()

if (vim.g.vscode == nil) then
  require('config.setup_lazy')
  require('config.keymaps_clear')
  require('config.callbacks')

  require('config.keymaps_x')
  require('config.autocmds')
  require('config.keymaps_crosseditor')
  require('config.keymaps_key')
  require('config.repl_highlight')
  require('config.snippets')
else
  require('config.init_plugins_vscode_only')
end
