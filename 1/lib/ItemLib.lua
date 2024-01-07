--- gets the length of items table
--- @param items table Items table
--- @return number length of table
local function getItemsLength(items)
    local count = 0
    for _ in pairs(items) do count = count + 1 end
    return count
end

--- gets the item slot of an item in storage
--- @param storage peripheral Inventory
--- @param name string name of item
--- @return number slot the item is in, or nil
local function getItemSlot(storage, name)
    for index,item in pairs(storage.list()) do
        if(name == item.name) then
            return index
        end
    end
    return nil
end

--- Gets the item count of an item from a AE system
--- @param network peripheral AE Network peripheral
--- @param name string Item name to look for
--- @return number item count, or 0 if the item is nil
local function getAEItemCount(network, name)
    local item = {name = name}
    local networkItem = network.getItem(item)
    if(networkItem) then
    	return networkItem.amount
    end
    return 0
end

--- tests if we need to update items table with new barrel configuration
--- @param barrel peripheral Barrel peripheral
--- @param items table Items map
function isNeedBarrelUpdate(barrel, items)
    return (#barrel.list())%2==0 and #barrel.list()/2 ~= getItemsLength(items)
end

--- updates data file and items table with barrel items
--- @param barrel peripheral Barrel peripheral
--- @param dataFile string path to datafile
--- @param items table Items table
--- @return table updated item table
function updateFromBarrel(barrel, dataFile, items)
    local updated = {}
    for i=1,#barrel.list(),2 do
        local currentItem = barrel.getItemDetail(i)
        if items[currentItem.name] then
        	updated[currentItem.name] = items[currentItem.name]
        else
            updated[currentItem.name] = {count=1000, displayName=currentItem.displayName}
        end
    end
    updateDataFile(dataFile, updated)
    return updated
end

--- gets the seed for a specific item
--- @param barrel peripheral Barrel peripheral
--- @param name string Item name to get the seed for
--- @return string name of seed or nil if cant find the item
function getItemSeed(barrel, name)
    for i=1,#barrel.list(),2 do
        if barrel.list()[i].name == name then
            return barrel.list()[i+1].name
        end
    end
    return nil
end

--- Updates the saved data file with the items table
--- @param dataFile string path to the data
--- @param items table of items to save to the file
function updateDataFile(dataFile, items)
    local file = io.open(dataFile, "w")
    io.output(file)
    io.write(textutils.serialise(items))
    io.flush()
end

--- Loads saved data into a table
--- @param dataFile string path to the data
--- @return table item table from saved file
function loadDataFile(dataFile)
    local file = io.open(dataFile, "r")
    io.input(dataFile)
    local stream = io.read("a")
    if stream then
        return textutils.unserialize(stream)
    end
    return {}
end

--- Creates a table of items
--- @param items table of items
function getIndexedItems(items)
    local indexed = {}
    local index = 1
    for itemName,_ in pairs(items) do
    	indexed[index] = itemName
    	index = index + 1
    end
    return indexed
end

--- Gets a list of items that need to be grown
--- @param network peripheral AE Network peripheral
--- @param barrel peripheral Barrel peripheral
--- @param items table of items
--- @return table Table of item names as keys and seed type as values
function getGrowList(network, barrel, items)
    local growList = {}
    for index,value in pairs(items) do
        aeCount = getAEItemCount(network, index)
        if aeCount < value.count then
        	growList[index] = getItemSeed(barrel, index)
        end
    end
    return growList
end

--- Moves plant seeds from storage to the planter
--- @param seedStorage peripheral storage controller for the seeds
--- @param planter peripheral planter that plants the seeds
--- @param seedName string name of seed to plant
function plantSeed(seedStorage, planter, seedName)
    local slot = getItemSlot(seedStorage, seedName)
    if slot then
        planter.pullItems(peripheral.getName(seedStorage), slot, 576)
        --seedStorage.pushItems(peripheral.getName(planter), slot, 576)
    end
end

--- Adds a value to an index to a table
--- @param table table to add to
--- @param index string index of the item
--- @param value string value of the item
--- @return table with the updated information
function addToTable(table, index, value)
    local t = {}
    for i,v in pairs(table) do t[i] = v end
    t[index] = value
    return t
end

--- Removes a value to an index to a table
--- @param table table to add to
--- @param index string index of the item
--- @return table with the updated information
function removeFromTable(table, index)
    local t = {}
    for i,v in pairs(table) do
        if i~=index then
            t[i] = v
        end
    end
    return t
end

return {
    isNeedBarrelUpdate,
    updateFromBarrel,
    getItemSeed,
    updateDataFile,
    loadDataFile,
    getGrowList,
    getIndexedItems,
    plantSeed,
    addToTable,
    removeFromTable
}