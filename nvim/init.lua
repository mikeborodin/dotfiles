require('config.options')
require('config.colemak')
require('config.enable_leaders')

vim.g.copilot_filetypes = {
  ['xml'] = false,
}

if (vim.g.vscode == nil) then
  require('config.setup_lazy')
  require('config.keymaps_clear')
  require('config.callbacks')

  require('config.completion')
  require('config.snippets')

  require('config.keymaps_x')
  require('config.keymaps_crosseditor')
  require('config.keymaps_neovim')
else
  require('config.init_plugins_vscode_only')
end