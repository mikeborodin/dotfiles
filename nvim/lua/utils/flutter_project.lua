local M = {}

--- Read .vscode/launch.json and return all configurations (strips // comments).
local function load_launch_configs()
  local path = vim.fn.getcwd() .. '/.vscode/launch.json'
  if vim.fn.filereadable(path) == 0 then return {} end
  local lines = {}
  for _, line in ipairs(vim.fn.readfile(path)) do
    if not vim.startswith(vim.trim(line), '//') then
      table.insert(lines, line)
    end
  end
  local ok, data = pcall(vim.json.decode, table.concat(lines, '\n'))
  if not ok or type(data) ~= 'table' then return {} end
  return data.configurations or {}
end

--- Find a launch config by name (case-insensitive).
local function find_launch_config(configs, name)
  local name_lower = name:lower()
  for _, cfg in ipairs(configs) do
    if type(cfg.name) == 'string' and cfg.name:lower() == name_lower then
      return cfg
    end
  end
  return nil
end

--- Map a vscode launch config to a flutter.ProjectConfig table.
local function launch_config_to_project_config(vsc, device)
  local pc = {}

  if device then pc.device = device end
  if vsc.program then pc.target = vsc.program end
  if vsc.flutterMode then pc.flutter_mode = vsc.flutterMode end

  local args = vsc.args or {}
  local i = 1
  local extra_args = {}
  while i <= #args do
    local a = args[i]
    if a == '--flavor' and args[i + 1] then
      pc.flavor = args[i + 1]
      i = i + 2
    elseif a == '--dart-define-from-file' and args[i + 1] then
      if not pc.dart_define_from_file then
        pc.dart_define_from_file = args[i + 1]
      else
        vim.list_extend(extra_args, { '--dart-define-from-file', args[i + 1] })
      end
      i = i + 2
    elseif a == '--dart-define' and args[i + 1] then
      local key, val = args[i + 1]:match '^([^=]+)=(.+)$'
      if key then
        pc.dart_define = pc.dart_define or {}
        pc.dart_define[key] = val
      end
      i = i + 2
    else
      table.insert(extra_args, a)
      i = i + 1
    end
  end
  if #extra_args > 0 then pc.additional_args = extra_args end

  return pc
end

--- Execute .flutter-config.lua from cwd and return {device, run_config} or {}.
--- Uses loadfile (not require) so it re-evaluates every call — no caching.
function M.flutter_config()
  local path = vim.fn.getcwd() .. '/.flutter-config.lua'
  if vim.fn.filereadable(path) == 0 then return {} end
  local fn, err = loadfile(path)
  if not fn then
    vim.notify('flutter-config: ' .. err, vim.log.levels.WARN)
    return {}
  end
  local ok, result = pcall(fn)
  if not ok then
    vim.notify('flutter-config: ' .. result, vim.log.levels.WARN)
    return {}
  end
  return type(result) == 'table' and result or {}
end

--- Build a flutter.ProjectConfig by reading .flutter-config.lua fresh.
--- Called immediately before every :FlutterRun so the config is always current.
function M.project_config()
  local cfg = M.flutter_config()
  local device = cfg.device
  local run_config_name = cfg.run_config

  if not device and not run_config_name then return {} end
  if device and not run_config_name then return { device = device } end

  local configs = load_launch_configs()
  local vsc = find_launch_config(configs, run_config_name)

  if not vsc then
    vim.notify(
      ('flutter: run config %q not found in .vscode/launch.json'):format(run_config_name),
      vim.log.levels.WARN
    )
    return device and { device = device } or {}
  end

  return launch_config_to_project_config(vsc, device)
end

--- Apply current .flutter-config.lua to flutter-tools and then run.
--- Call this instead of :FlutterRun directly.
function M.run()
  local ok, ft = pcall(require, 'flutter-tools')
  if not ok then
    vim.notify('flutter-tools not loaded', vim.log.levels.ERROR)
    return
  end
  ft.setup_project(M.project_config())
  vim.cmd 'FlutterRun'
end

--- Apply config without running (used on DirChanged).
function M.apply()
  local ok, ft = pcall(require, 'flutter-tools')
  if not ok then return end
  ft.setup_project(M.project_config())
end

return M
