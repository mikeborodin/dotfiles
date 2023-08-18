local function create_file_if_not_exists(path)
  local success, error_msg = vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
  if success == 1 then
    print("Directory created:", vim.fn.fnamemodify(path, ":h"))
    local file = io.open(path, "a") -- Open in "append" mode to create if not exists
    if file then
      file:close()
      print("File created:", path)
    else
      print("File creation failed:", path)
    end
  else
    print("Directory creation failed:", error_msg)
  end
end

local function swapTestLib(filepath)
  if string.sub(filepath, 1, 4) == "test" then
    local implementationPath = "lib" .. string.sub(filepath, 5)
    local replacedImplementationPath = string.gsub(implementationPath, "%_test.dart$", ".dart")
    return replacedImplementationPath
  elseif string.sub(filepath, 1, 3) == "lib" then
    local testPath = "test" .. string.sub(filepath, 4)
    local replacedTestPath = string.gsub(testPath, "%.dart$", "_test.dart")
    return replacedTestPath
  else
    error('could not detect')
  end
end

function jumpToTest()
  local absolutePath = vim.fn.expand('%:p')
  local cwd = vim.fn.getcwd()
  local filePath = vim.fn.substitute(absolutePath, "^" .. vim.fn.escape(cwd, '/'), '', '')
  if vim.startswith(filePath, '/') then
    filePath = vim.fn.substitute(filePath, '^/', '', '')
  end
  print(filePath)
  local counterpartFile = swapTestLib(filePath)
  print(counterpartFile)
  create_file_if_not_exists(counterpartFile)
  vim.cmd('edit ' .. counterpartFile)
end
