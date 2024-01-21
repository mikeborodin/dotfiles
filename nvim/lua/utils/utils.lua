local lazy = require("flutter-tools.lazy")
local path = lazy.require("flutter-tools.utils.path") ---@module "flutter-tools.utils.path"

function Log(log)
  local current_dir = vim.fn.expand("%:p:h")
  local root_patterns = { "pubspec.yaml", ".git" }
  local root_dir = path.find_root(root_patterns, current_dir) or current_dir
  local log_file = path.join(root_dir, "neovim_plugins.log")
  local file = io.open(log_file, "a")
  if file ~= nil then
    file:write(log)
    file:write("\n")
    file:close()
  end
end

function Has_flutter_dependency_in_pubspec()
  local pubspec = vim.fn.glob("pubspec.yaml")
  if pubspec == "" then return false end
  local pubspec_content = vim.fn.readfile(pubspec)
  local joined_content = table.concat(pubspec_content, "\n")

  local flutter_dependency = string.match(joined_content, "flutter:\n[%s\t]*sdk:[%s\t]*flutter")
  return flutter_dependency ~= nil
end
