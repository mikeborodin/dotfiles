local function create_file_if_not_exists(path)
  if vim.fn.filereadable(path) == 0 then
    os.execute("mkdir -p $(dirname " .. path .. ")")
    local file = io.open(path, "w")
    io.close(file)
    print("File created")
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
    return filepath
  end
end

function jumpToTest()
  local absolutePath = vim.fn.expand('%:p')
  local cwd = vim.fn.getcwd()
  local filePath = absolutePath:gsub(cwd .. '/', '')
  local counterpartFile = swapTestLib(filePath)
  create_file_if_not_exists(counterpartFile)
  print(counterpartFile)
  vim.cmd('edit ' .. counterpartFile)
end
