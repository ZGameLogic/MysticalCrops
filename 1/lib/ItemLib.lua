--- tests if we need to update items table with new barrel configuration
-- @param barrel Barrel paripheral
-- @param items Items map
function isNeedBarrelUpdate(barrel, items)
    return #barrel.list() ~= #items
end

--- updates data file and items table with barrel items
function updateFromBarrel(barrel, dataFile, items)
    for i=1,#barrel.list(),2 do
    	print("Item: " .. barrel.list()[i+1].name)
    end
    updateDataFile(dataFile, items)
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

function updateDataFile(dataFile, items)

end

function loadDataFile(dataFile, items)

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
    getItemSeed
}