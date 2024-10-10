vim.g.selected_run_config = { name = 'no config' }

local dap = require('dap')
local notify = require('dap.utils').notify
local M = {}

M.json_decode = vim.json.decode
M.type_to_filetypes = {}

local function create_input(type_, input)
  if type_ == "promptString" then
    return function()
      local description = input.description or 'Input'
      if not vim.endswith(description, ': ') then
        description = description .. ': '
      end
      if vim.ui.input then
        local co = coroutine.running()
        local opts = {
          prompt = description,
          default = input.default or '',
        }
        vim.ui.input(opts, function(result)
          vim.schedule(function()
            coroutine.resume(co, result)
          end)
        end)
        return coroutine.yield()
      else
        return vim.fn.input(description, input.default or '')
      end
    end
  elseif type_ == "pickString" then
    return function()
      local options = assert(input.options, "input of type pickString must have an `options` property")
      local opts = {
        prompt = input.description,
        format_item = function(x)
          return x.label and x.label or x
        end,
      }
      local co = coroutine.running()
      vim.ui.select(options, opts, function(option)
        vim.schedule(function()
          local value = option and option.value or option
          coroutine.resume(co, value or (input.default or ''))
        end)
      end)
      return coroutine.yield()
    end
  else
    local msg = "Unsupported input type in vscode launch.json: " .. type_
    notify(msg, vim.log.levels.WARN)
  end
end


local function create_inputs(inputs)
  local result = {}
  for _, input in ipairs(inputs) do
    local id = assert(input.id, "input must have a `id`")
    local key = "${input:" .. id .. "}"
    local type_ = assert(input.type, "input must have a `type`")
    local fn = create_input(type_, input)
    if fn then
      result[key] = fn
    end
  end
  return result
end

local function chain(default, fns)
  return function()
    local result = default
    for _, fn in ipairs(fns) do
      result = fn(result)
    end
    return result
  end
end


local function apply_input(inputs, value)
  if type(value) == "table" then
    local new_value = {}
    for k, v in pairs(value) do
      new_value[k] = apply_input(inputs, v)
    end
    value = new_value
  end
  if type(value) ~= "string" then
    return value
  end
  local matches = string.gmatch(value, "${input:([%w_]+)}")
  local input_functions = {}
  for input_id in matches do
    local input_key = "${input:" .. input_id .. "}"
    local input = inputs[input_key]
    if not input then
      local msg = "No input with id `" .. input_id .. "` found in inputs"
      notify(msg, vim.log.levels.WARN)
    end
    table.insert(input_functions, function(val)
      assert(coroutine.running(), "Must run in coroutine")
      local input_value = input()
      return val:gsub(input_key, input_value)
    end)
  end
  if next(input_functions) then
    return chain(value, input_functions)
  else
    return value
  end
end


local function apply_inputs(config, inputs)
  local result = {}
  for key, value in pairs(config) do
    result[key] = apply_input(inputs, value)
  end
  return result
end


--- Lift properties of a child table to top-level
local function lift(tbl, key)
  local child = tbl[key]
  if child then
    tbl[key] = nil
    return vim.tbl_extend('force', tbl, child)
  end
  return tbl
end


function M._load_json(jsonstr)
  local data = assert(M.json_decode(jsonstr), "launch.json must contain a JSON object")
  local inputs = create_inputs(data.inputs or {})
  local has_inputs = next(inputs) ~= nil

  local sysname
  if vim.fn.has('linux') == 1 then
    sysname = 'linux'
  elseif vim.fn.has('mac') == 1 then
    sysname = 'osx'
  elseif vim.fn.has('win32') == 1 then
    sysname = 'windows'
  end

  local configs = {}
  for _, config in ipairs(data.configurations or {}) do
    config = lift(config, sysname)
    table.insert(configs, has_inputs and apply_inputs(config, inputs) or config)
  end
  return configs
end

function M.load_run_configurations_from_vscode(path, type_to_filetypes)
  type_to_filetypes = vim.tbl_extend('keep', type_to_filetypes or {}, M.type_to_filetypes)
  local resolved_path = path
  if not vim.loop.fs_stat(resolved_path) then
    local configs = {
      {
        type = "dart",
        request = "launch",
        name = "launch main.dart",
        program = "${workspaceFolder}/lib/main.dart",
        cwd = "${workspaceFolder}",
      },
    }
    return configs
  end

  local lines = {}
  for line in io.lines(resolved_path) do
    if not vim.startswith(vim.trim(line), '//') then
      table.insert(lines, line)
    end
  end
  local contents = table.concat(lines, '\n')
  local configurations = M._load_json(contents)

  return configurations
end

function M.selectRunConfig()
  local path = vim.fn.getcwd() .. '/.vscode/launch.json'

  local configurations = M.load_run_configurations_from_vscode(path)

  require("dap.ui").pick_if_many(
    configurations,
    "Select launch configuration",
    function(config)
      return config.name
    end,
    function(launch_config)
      if not launch_config then return end
      launch_config = vim.deepcopy(launch_config)
      vim.g.selected_run_config = launch_config
      dap.configurations['dart'] = { launch_config }
    end
  )
end

return M
