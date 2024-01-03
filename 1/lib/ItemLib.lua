--- gets the length of items table
-- @param items Items table
-- @returns length of table
local function getItemsLength(items)
    count = 0
    for _ in pairs(items) do count = count + 1 end
    return count
end

--- tests if we need to update items table with new barrel configuration
-- @param barrel Barrel paripheral
-- @param items Items map
function isNeedBarrelUpdate(barrel, items)
    return #barrel.list()/2 ~= getItemsLength(items)
end

--- updates data file and items table with barrel items
-- @param barrel Barrel paripheral
-- @param dataFile
-- @returns updated item table
function updateFromBarrel(barrel, dataFile, items)
    local updated = {}
    for i=2,#barrel.list(),2 do
        local currentItem = barrel.list()[i].name
        if items[currentItem] then
        	updated[currentItem] = items[currentItem]
        else
            updated[currentItem] = 1000
        end
    end
    updateDataFile(dataFile, updated)
    return updated
end

--- gets the seed for a specific item
-- @param barrel Barrel paripheral
-- @param name Item name to get the seed for
-- @returns name of seed or nil if cant find the item
function getItemSeed(barrel, name)
    for i=2,#barrel.list(),2 do
        if barrel.list()[i].name == name then
            return barrel.list()[i-1].name
        end
    end
    return nil
end

--- Updates the saved data file with the items table
-- @param dataFile File path to the data
-- @param items Items table to save to the file
function updateDataFile(dataFile, items)
    file = io.open(dataFile, "w")
    io.output(file)
    io.write(textutils.serialise(items))
    io.flush()
end

--- Loads saved data into a table
-- @param dataFile File path to the data
-- @returns item table from saved file
function loadDataFile(dataFile)
    file = io.open(dataFile, "r")
    io.input(dataFile)
    stream = io.read("a")
    if stream then
        return textutils.unserialize(stream)
    end
    return {}
end

--- Gets the item count of an item from a AE system
-- @param network AE Network peripheral
-- @param name Item name to look for
-- @returns item count, or 0 if the item is nil
function getAEItemCount(network, name)
    local item = {name = name}
    local networkItem = network.getItem(item)
    if(networkItem) then
    	return networkItem.amount
    end
    return 0
end

return {
    isNeedBarrelUpdate,
    updateFromBarrel,
    getAEItemCount,
    getItemSeed,
    updateDataFile,
    loadDataFile
}