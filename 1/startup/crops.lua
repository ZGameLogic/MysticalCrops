-- ***************************************************
-- * 					Crops						 *
-- * 												 *
-- * This program takes a barrel input of seed item  *
-- * pairs and automatically grows the item if the   *
-- * count of the item is less than the set value.   *
-- * 												 *
-- * 				By Ben Shabowski				 *
-- ***************************************************

require("../lib/PrintingLib")
require("../lib/ItemLib")

local network = peripheral.wrap("meBridge_1")
local barrel = peripheral.wrap("sophisticatedstorage:barrel_0")
local planter = peripheral.wrap("industrialforegoing:plant_sower_0")
local seedStorage = peripheral.wrap("functionalstorage:storage_controller_1")

DELTA_MAX = 10000000000
PAGE_ITEM_COUNT = 20

local data = "/data/data.txt"

-- {itemName: minecraft:iron_ingot, count:4, displayName: Iron Ingot}
local items = {}
local growList = {}
local manualGrowList = {}
local page = 1
local growItemIndex = 1
local delta = 100

-- Handle the touch events
function handleTouch(x, y)
    if x >= 42 and x <= 47 and y == 6 then
        -- delta divide
        if delta >= 10 then
            delta = delta / 10
            drawDelta(delta)
        end
    elseif x >= 49 and x <= 55 and y == 6 then
        -- delta multiply
        if delta < DELTA_MAX then
            delta = delta * 10
            drawDelta(delta)
        end
    elseif x == 35 and y >= 4 and y <= 23 then
        -- add delta
        local item = items[y-3+((page-1)*PAGE_ITEM_COUNT)]
        if item then
            items[y-3+((page-1)*PAGE_ITEM_COUNT)].count = item.count + delta
            updateDataFile(data, items)
            printItemSection(items, growList, manualGrowList, page)
        end
    elseif x == 36 and y >= 4 and y <= 23 then
        -- sub delta
        local item = items[y-3+((page-1)*PAGE_ITEM_COUNT)]
        if item then
            items[y-3+((page-1)*PAGE_ITEM_COUNT)].count = item.count - delta
            if items[y-3+((page-1)*PAGE_ITEM_COUNT)].count < 0 then
                items[y-3+((page-1)*PAGE_ITEM_COUNT)].count = 0
            end
            updateDataFile(data, items)
            printItemSection(items, growList, manualGrowList, page)
        end
    elseif x >= 2 and x <= 25 and y >= 4 and y <= 23 then
        -- select or deselect from grow list
        local item = items[y-3+((page-1)*PAGE_ITEM_COUNT)]
        if item then
            local seed = getItemSeed(barrel, item.name)
            if seed then
                if growListContainsItem(manualGrowList, item.name) then
                    manualGrowList = removeFromTable(manualGrowList, item.name)
                else
                    manualGrowList = addToTable(manualGrowList, item.name, seed)
                end
                printItemSection(items, growList, manualGrowList, page)
            end
        end
    elseif x >= 17 and x <= 25 and y == 25 then
        -- page up
        local maxPage = math.ceil(#items/PAGE_ITEM_COUNT)
        if page + 1 <= maxPage then
            page = page + 1
            printItemSection(items, growList, manualGrowList, page)
        end
    elseif x >= 2 and x <= 8 and y == 25 then
        -- page down
        if page > 1 then
            page = page - 1
            printItemSection(items, growList, manualGrowList, page)
        end
    elseif x >= 42 and x <= 50 and y == 15 then
        -- grow list down
        local combined = combinedGrowList(growList, manualGrowList)
        if(growItemIndex > 1) then
            growItemIndex = growItemIndex -1
            drawGrowItem(combined, growItemIndex)
        else
            growItemIndex = #combined
            drawGrowItem(combined, growItemIndex)
        end
    elseif x >= 51 and x <= 60 and y == 15 then
        -- grow list up
        local combined = combinedGrowList(growList, manualGrowList)
        if growItemIndex < #combined then
            growItemIndex = growItemIndex + 1
            drawGrowItem(combined, growItemIndex)
        else
            growItemIndex = 1
            drawGrowItem(combined, growItemIndex)
        end
    end
end

-- Listens for touch event
function listenTouch()
    while true do
        event, size, xPos, yPos = os.pullEvent("monitor_touch")
        handleTouch(xPos, yPos)
    end
end

-- Do something every second
function listenTime()
    while true do
        local updateGUI = false
		if isNeedBarrelUpdate(barrel, items) then
            items = updateFromBarrel(barrel, data, items)
            updateGUI = true
        end
		local newGrowList = getGrowList(network, barrel, items)
		if (#barrel.list())%2==0 and #newGrowList~=#growList then
		    updateGUI = true
		end
        growList = newGrowList
        local combined = combinedGrowList(growList, manualGrowList)
        if growItemIndex > #combined then
            growItemIndex = 1
        end
		if updateGUI then
		    printItemSection(items, growList, manualGrowList, page)
            if #combined > 1 then
                drawGrowItem(combined, growItemIndex)
            else
                drawEmptyGrowItem()
            end
		end
		if next(manualGrowList) then
		    for _,entry in pairs(manualGrowList) do
                plantSeed(seedStorage, planter, entry.seed)
            end
            updateGrowItemCount(combined, growItemIndex)
		end
		if next(growList) then
            for _,entry in pairs(growList) do
                plantSeed(seedStorage, planter, entry.seed)
            end
            updateGrowItemCount(combined, growItemIndex)
		end
        sleep(1)
    end
end

items = loadDataFile(data)
items = updateFromBarrel(barrel, data, items)
resetScreen()

printItemSection(items, growList, manualGrowList, page)
drawDelta(delta)

parallel.waitForAll(listenTouch, listenTime)