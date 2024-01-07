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

local strings = require("cc.strings")

local screen = peripheral.wrap("monitor_0")
local network = peripheral.wrap("meBridge_1")
local barrel = peripheral.wrap("sophisticatedstorage:barrel_0")
local planter = peripheral.wrap("industrialforegoing:plant_sower_0")
local seedStorage = peripheral.wrap("functionalstorage:storage_controller_1")

DELTA_MAX = 10000000000

local data = "/data/data.txt"

-- <item name>={count:4, displayName: iron}
local items = {}
local growList = {}
local manualGrowList = {}
local page = 1
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
        local item = items[getIndexedItems(items)[y-3]]
        if item then
            items[getIndexedItems(items)[y-3]].count = item.count + delta
            updateDataFile(data, items)
            printItemSection(items, getIndexedItems(items), growList, manualGrowList, page)
        end
    elseif x == 36 and y >= 4 and y <= 23 then
    -- sub delta
        local item = items[getIndexedItems(items)[y-3]]
        if item then
            items[getIndexedItems(items)[y-3]].count = item.count - delta
            if items[getIndexedItems(items)[y-3]].count < 0 then
                items[getIndexedItems(items)[y-3]].count = 0
            end
            updateDataFile(data, items)
            printItemSection(items, getIndexedItems(items), growList, manualGrowList, page)
        end
    end
    print(x)
    print(y)
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
		newGrowList = getGrowList(network, barrel, items)
		if (#barrel.list())%2==0 and #getIndexedItems(newGrowList)~=#getIndexedItems(growList) then
		    growList = newGrowList
		    updateGUI = true
		end
		if updateGUI then
		    printItemSection(items, getIndexedItems(items), growList, manualGrowList, page)
		end
		if next(growList) then
            for _,seed in pairs(growList) do
                plantSeed(seedStorage, planter, seed)
            end
		end
        sleep(1)
    end
end

items = loadDataFile(data)
items = updateFromBarrel(barrel, data, items)
resetScreen()

printItemSection(items, getIndexedItems(items), growList, manualGrowList, page)
drawDelta(delta)

parallel.waitForAll(listenTouch, listenTime)