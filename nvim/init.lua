require('config.options')
require('config.colemak')
require('config.enable_leaders')

vim.g.copilot_filetypes = {
  ['xml'] = false,
  ['md'] = false,
}
vim.g.loaded_syntastic_dart_dartanalyzer_checker = 0

if (vim.g.vscode == nil) then
  require('config.setup_lazy')
  require('config.keymaps_clear')
  require('config.callbacks')

  require('config.keymaps_x')
  require('config.autocmds')
  require('config.keymaps_crosseditor')
  require('config.keymaps_neovim')
  require('config.repl_highlight')
else
  require('config.init_plugins_vscode_only')
end

