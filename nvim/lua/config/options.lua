vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.hlsearch = false
vim.o.pumheight = 10
vim.o.pumwidth = 120

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'
vim.o.autowriteall = true

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'
vim.o.hidden = true

vim.o.breakindent = true

vim.o.undofile = true
vim.o.swapfile = false

vim.o.scrolloff = 10

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.exrc = true

vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

vim.o.completeopt = 'menuone,noselect'
vim.cmd('set shortmess+=F')


-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- vim.cmd(':set nonu')
vim.o.number = false
-- vim.o.textwidth = 120
-- vim.cmd(':set colorcolumn=+1')

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3
-- Default splitting will cause your main splits to jump when opening an edgebar.
-- To prevent this, set `splitkeep` to either `screen` or `topline`.
vim.opt.splitkeep = "screen"
