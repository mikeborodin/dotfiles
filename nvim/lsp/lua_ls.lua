---@type vim.lsp.Config
return {
  cmd = { 'lua-language-server' },
  name = 'lua_ls',
  root_markers = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
  },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local markers = {
      '.luarc.json', '.luarc.jsonc', '.luacheckrc',
      '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml',
    }
    local root = vim.fs.root(fname, markers)
    -- Refuse to start if no lua-specific root found, or if it would
    -- resolve to the home directory (too broad, lua_ls refuses it anyway).
    if not root or root == vim.env.HOME then return end
    on_dir(root)
  end,
  filetypes = { 'lua' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        disable = { 'lowercase-global' },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          '${3rd}/love2d/library',
        },
      },
    },
  },
}
