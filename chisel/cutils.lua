function get_distinct_items(list)
    local hash = {}
    for _, v in ipairs(list) do
        hash[v] = true
    end
    local res = {}
    for k, _ in pairs(hash) do
        res[#res + 1] = k
    end
    return res
end

function write_to_file(filename, data)
    local file, err = io.open(filename, "w")
    if not file then
        return false, "Error opening file: " .. err
    end

    file:write(data)
    file:close()
    return true
end

return {get_distinct_items = get_distinct_items, write_to_file = write_to_file}
