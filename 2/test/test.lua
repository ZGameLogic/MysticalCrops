local t = {
    [1] = {
        ["displayName"] = "Iron Ingot"
    },
    [2] = {
        ["displayName"] = "Gold Ingot"
    },
    [3] = {
        ["displayName"] = "Apple"
    }
}

local function sort(inputItems)
    -- copy over everything to a new table
    local items = {}
    for i,value in pairs(inputItems) do items[i] = value end
    for i=1,#items-1 do
        -- find smallest item
        local smallest = i
        for j=i+1,#items do
            if items[j].displayName < items[smallest].displayName then
                smallest = j
            end
        end
        print("Smallest: "..items[smallest].displayName)
        -- swap smallest with index
        local indexItem = items[i]
        items[i] = items[smallest]
        items[smallest] = indexItem
    end
    for _,value in pairs(items) do
        print("Before:"..value.displayName)
    end
    return items
end

local sorted = sort(t)

for _,value in pairs(sorted) do
    print(value.displayName)
end