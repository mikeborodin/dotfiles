
(
  echo "=== SYSTEM ==="
  sw_vers
  echo
  uname -a
  echo
  system_profiler SPDisplaysDataType | sed -n '1,120p'
  echo

  echo "=== NVIM ==="
  nvim --version | sed -n '1,20p'
  echo

  echo "=== TERM ==="
  echo "TERM=$TERM"
  echo "COLORTERM=$COLORTERM"
  echo

  echo "=== WEZTERM ENV ==="
  env | grep -E 'WEZTERM|TERM|COLORTERM|WAYLAND|DISPLAY|GPU' | sort
  echo

  echo "=== NVIM UI OPTIONS ==="
  nvim --headless +'lua print(vim.inspect({
    guicursor = vim.o.guicursor,
    cmdheight = vim.o.cmdheight,
    laststatus = vim.o.laststatus,
    winbar = vim.o.winbar,
    statusline = vim.o.statusline,
    termguicolors = vim.o.termguicolors,
  }))' +q 2>/dev/null
  echo

  echo "=== LOADED PLUGINS (lazy.nvim) ==="
  nvim --headless +'lua if pcall(require,"lazy") then
    local p = require("lazy").plugins()
    for _, v in ipairs(p) do
      print(v.name, v.enabled ~= false and "ENABLED" or "DISABLED")
    end
  else
    print("lazy.nvim not found")
  end' +q 2>/dev/null

) 
