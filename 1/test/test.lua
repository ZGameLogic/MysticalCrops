local t = {
    [1] = {
        ["displayName"] = "Iron Ingot"
    },
    [2] = {
        ["displayName"] = "Gold Ingot"
    },
    [3] = {
        ["displayName"] = "Apple"
    },
}

local function sort(items)
    return items
end

t = sort(t)

print(next(t[1]))