---@diagnostic disable: undefined-global

-- ~/.config/yazi/init.lua
th.git = th.git or {}
th.git.modified = ui.Style():fg("blue")
th.git.deleted = ui.Style():fg("red"):bold()

-- require("git"):setup()

-- You can configure your bookmarks by lua language
local bookmarks = {}

local path_sep = package.config:sub(1, 1)
local home_path = os.getenv("HOME")

table.insert(bookmarks, {
  tag = "Desktop",
  path = home_path .. path_sep .. "Desktop" .. path_sep,
  key = "d",
})

require("git"):setup()

-- require("yamb"):setup({
--   bookmarks = bookmarks,
--   jump_notify = true,
--   cli = "fzf",
--   keys = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
--   path = os.getenv("HOME") .. "/.config/yazi/bookmark",
-- })
