
function tableToString(tbl, indent)
    local result = {}
    indent = indent or 0

    for k, v in pairs(tbl) do
        local key = tostring(k)
        local value = type(v) == "table" and tableToString(v, indent + 1) or tostring(v)

        result[#result + 1] = string.rep("  ", indent) .. key .. " = " .. value
    end

    return "{\n" .. table.concat(result, ",\n") .. "\n" .. string.rep("  ", indent - 1) .. "}"
end
