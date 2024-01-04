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

-- Handle the touch events
function handleTouch(x, y)

end

-- Handle updating the list of data from the barrel
function updateBarrelItems()
    if isNeedBarrelUpdate(barrel, items) then
    	items = updateFromBarrel(barrel, data, items)
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
		updateBarrelItems()
        sleep(1)
    end
end

items = loadDataFile(data)
parallel.waitForAll(listenTouch, listenTime)