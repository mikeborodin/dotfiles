-- Get the selected files if any or the hovered in a list
local get_paths = ya.sync(function()
  local paths = {}
  -- get selected files
  for _, u in pairs(cx.active.selected) do
    paths[#paths + 1] = tostring(u)
  end
  -- if no files are selected, get hovered file
  if #paths == 0 then
    if cx.active.current.hovered then
      paths[1] = tostring(cx.active.current.hovered.url)
    end
  end

  return paths
end)

-- Get selected files if any or empty list
local get_select = ya.sync(function()
  local paths = {}
  -- get selected files
  for _, u in pairs(cx.active.selected) do
    paths[#paths + 1] = tostring(u)
  end

  return paths
end)

-- Get the hovered file only
local get_hover = ya.sync(function()
  if cx.active.current.hovered then
    return tostring(cx.active.current.hovered.url)
  else
    return ""
  end
end)

return {
  entry = function(self, job)
    local args = job.args
    -- First and only arg is the command to run
    if #args == 0 then
      ya.notify({
        title = "Actions",
        content = "please configure the hotkey to send parameters",
        timeout = 5.0,
      })
      ya.hide()

      return
    end
    local command = table.concat(args, " ")

    -- Prepend the created variables to the command so that they are available
    local full_cmd = [[
    alias ! = ya emit
    def dbg [msg] { print -e $msg ; exit 1 }

    let $all = $env.yazi_all | split row ';'
    let $select = $env.yazi_select | split row ';'
    let $hover = $env.yazi_hover
]] .. command

    local hover = get_hover()

    local output, err = Command("nu")
      :args({
        "--login",
        "~/personal_projects/dotfiles/scripts/ai/" .. args[1] .. ".nu",
        hover,
      })
      :env("yazi_hover", hover)
      :env("yazi_select", table.concat(get_select(), ";"):gsub("\\", "/"))
      :env("YAZI_ID", ya.id("app").value)
      :stdout(Command.PIPED)
      :stderr(Command.PIPED)
      :output()

    ya.notify({
      title = "Task finished",
      content = "For " .. hover .. ".\nOutput:\n" .. output.stdout,
      timeout = 3.0,
    })
    if not output.status.success and output.stderr ~= "" then
      ya.notify({ title = "err", content = output.stderr, timeout = 5.0 })
      ya.dbg(output.stderr)
    end
  end,
}
