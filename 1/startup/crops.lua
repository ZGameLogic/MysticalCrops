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
local barrel = peripheral.wrap("sophisticatedstorage:barrel_0")
local seedOutput = peripheral.wrap("functionalstoreage:oak_1_0")
local network = peripheral.wrap("meBridge_1")

local data = "/data/data.txt"

-- <item name>={count:4, displayName: iron}
local items = {}
local growList = {}
local manualGrowList = {}
local page = 1
local delta = 100

-- Handle the touch events
function handleTouch(x, y)

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
        local update = false
		if isNeedBarrelUpdate(barrel, items) then
		    print("updating items from barrel")
            items = updateFromBarrel(barrel, data, items)
            update = true
        end
		newGrowList = getGrowList(network, barrel, items)
		if (#barrel.list())%2==0 and #getIndexedItems(newGrowList)~=#getIndexedItems(growList) then
		    growList = newGrowList
		    update = true
		end
		if update then
		    printItemSection(items, getIndexedItems(items), growList, manualGrowList, page)
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