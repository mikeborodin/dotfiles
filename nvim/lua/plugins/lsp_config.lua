local Util = require 'lazyvim.util'

local function diagnostic_message_only_code(diagnostic)
  return diagnostic.code
end

local function setupDiagnostics(opts)
  for name, icon in pairs(require('lazyvim.config').icons.diagnostics) do
    name = 'DiagnosticSign' .. name
    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = '' })
  end
  if type(opts.diagnostics.virtual_text) == 'table' and opts.diagnostics.virtual_text.prefix == 'icons' then
    opts.diagnostics.virtual_text.prefix = vim.fn.has 'nvim-0.10.0' == 0 and '●'
        or function(diagnostic)
          local icons = require('lazyvim.config').icons.diagnostics
          for d, icon in pairs(icons) do
            if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
              return icon
            end
          end
        end
  end

  vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
end

local function setupServers(opts)
  local servers = opts.servers
  local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  local capabilities = vim.tbl_deep_extend(
    'force',
    {},
    vim.lsp.protocol.make_client_capabilities(),
    has_cmp and cmp_nvim_lsp.default_capabilities() or {},
    opts.capabilities or {}
  )

  require('lspconfig').nushell.setup {}

  local function setupServer(server)
    local server_opts = vim.tbl_deep_extend('force', {
      capabilities = vim.deepcopy(capabilities),
    }, servers[server] or {})

    if opts.setup[server] then
      if opts.setup[server](server, server_opts) then
        return
      end
    elseif opts.setup['*'] then
      if opts.setup['*'](server, server_opts) then
        return
      end
    end
    require('lspconfig')[server].setup(server_opts)
  end

  local have_mason, mlsp = pcall(require, 'mason-lspconfig')
  local all_mslp_servers = {}
  if have_mason then
    all_mslp_servers = vim.tbl_keys(require('mason-lspconfig.mappings.server').lspconfig_to_package)
  end

  local ensure_installed = {}
  for server, server_opts in pairs(servers) do
    if server_opts then
      server_opts = server_opts == true and {} or server_opts
      -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
      if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
        setupServer(server)
      else
        ensure_installed[#ensure_installed + 1] = server
      end
    end
  end

  if have_mason then
    mlsp.setup { ensure_installed = ensure_installed, handlers = { setupServer } }
  end
end

return {
  {
    'neovim/nvim-lspconfig',
    enabled = false,
    dependencies = {
      {
        'folke/neoconf.nvim',
        cmd = 'Neoconf',
        config = false,
        dependencies = { 'nvim-lspconfig' }
      },
      'mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = 'if_many',
          prefix = '',
          -- format = diagnostic_message_only_code,
        },
        severity_sort = true,
      },
      inlay_hints = {
        enabled = true,
      },
      capabilities = {},
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      servers = {
        lua_ls = {
          mason = true,
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = true,
              },
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      },
      setup = {
        rust_analyzer = function()
          return true
        end,
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
    config = function(_, opts)
      if Util.has 'neoconf.nvim' then
        local plugin = require('lazy.core.config').spec.plugins['neoconf.nvim']
        require('neoconf').setup(require('lazy.core.plugin').values(plugin, 'opts', false))
      end

      require('mason').setup(opts)
      require("mason-lspconfig").setup()

      setupDiagnostics(opts)
      setupServers(opts)
    end,
  },
  -- {
  --   'williamboman/mason.nvim',
  --   dependencies = {
  --     "williamboman/mason-lspconfig.nvim",
  --     "neovim/nvim-lspconfig",
  --   },
  --   cmd = 'Mason',
  --   -- build = ':MasonUpdate',
  --   opts = {
  --     ensure_installed = {
  --       'stylua',
  --       'shfmt',
  --       'dart-debug-adapter',
  --       'yaml-language-server',
  --       'json-lsp',
  --     },
  --   },
  --   config = function(_, opts)
  --     require('mason').setup(opts)
  --     require("mason-lspconfig").setup()
  --     -- local mr = require 'mason-registry'
  --     -- mr:on('package:install:success', function()
  --     --   vim.defer_fn(function()
  --     --     require('lazy.core.handler.event').trigger {
  --     --       event = 'FileType',
  --     --       buf = vim.api.nvim_get_current_buf(),
  --     --     }
  --     --   end, 100)
  --     -- end)
  --     -- local function ensure_installed()
  --     --   for _, tool in ipairs(opts.ensure_installed) do
  --     --     local p = mr.get_package(tool)
  --     --     if not p:is_installed() then
  --     --       p:install()
  --     --     end
  --     --   end
  --     -- end
  --     -- if mr.refresh then
  --     --   mr.refresh(ensure_installed)
  --     -- else
  --     --   ensure_installed()
  --     -- end
  --   end,
  -- },
}
