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
        if #args == 0 then return end
        local command = table.concat(args, " ")

        -- Prepend the created variables to the command so that they are available
        local full_cmd = [[
    alias ! = ya emit
    def dbg [msg] { print -e $msg ; exit 1 }

    let $all = $env.yazi_all | split row ';'
    let $select = $env.yazi_select | split row ';'
    let $hover = $env.yazi_hover
]] .. command

        if args.hide then
            ya.hide()
        end

        -- ya.notify { title = "YAZI_ID", content = ya.id("app").value, timeout = 5.0 }
        -- ya.notify { title = "cmd", content = full_cmd, timeout = 5.0 }
        local output, err = Command("nu")
            -- Call command with --login so that custom config is loaded
            :args({ "-l", "-c", full_cmd })
            -- Pass files as env variables
            :env("yazi_all", table.concat(get_paths(), ";"):gsub("\\", "/"))
            :env("yazi_hover", get_hover():gsub("\\", "/"))
            :env("yazi_select", table.concat(get_select(), ";"):gsub("\\", "/"))
            -- :env("YAZI_ID", ya.id("app").value)
            :stdout(Command.PIPED)
            :stderr(Command.PIPED)
            :output()

        -- ya.notify { title = "out", content = output.stdout, timeout = 3.0 }
        if not output.status.success and output.stderr ~= "" then
            ya.notify { title = "err", content = output.stderr, timeout = 5.0 }
            ya.dbg(output.stderr)
        end
    end,
}
