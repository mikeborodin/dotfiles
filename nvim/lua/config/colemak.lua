local function map(mode, lhs, rhs)
  vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true })
end

-- Normal mode mappings
map("n", "u", "k")
map("n", "e", "j")
map("n", "n", "h")
map("n", "i", "l")
map("n", "h", "u")
map("n", "j", "n")
map("n", "k", "i")
map("n", "l", "e")

-- Visual mode mappings
map("x", "u", "k")
map("x", "e", "j")
map("x", "n", "h")
map("x", "i", "l")
map("x", "h", "u")
map("x", "j", "n")
map("x", "k", "i")
map("x", "l", "e")

-- Operator-pending mode mappings
map("o", "u", "k")
map("o", "e", "j")
map("o", "n", "h")
map("o", "i", "l")
map("o", "h", "u")
map("o", "j", "n")
map("o", "k", "i")
map("o", "l", "e")
