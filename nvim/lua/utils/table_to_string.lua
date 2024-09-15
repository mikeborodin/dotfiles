function TableToString(tbl, indent)
    local result = {}
    indent = indent or 0

    for k, v in pairs(tbl) do
        local key = tostring(k)
        local value = type(v) == "table" and TableToString(v, indent + 1) or tostring(v)

        result[#result + 1] = string.rep("  ", indent) .. key .. " = " .. value
    end

    return "{\n" .. table.concat(result, ",\n") .. "\n" .. string.rep("  ", indent - 1) .. "}"
end

function IsFvmProject()
    -- check if .fvmrc exists
    return vim.fn.filereadable(".fvmrc") == 1
end

function MoveToNextSearchResult()
    vim.api.nvim_command("normal! n")
end
