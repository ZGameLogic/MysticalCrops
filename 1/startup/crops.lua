-- ***************************************************
-- * 					Crops						 *
-- * 												 *
-- * This program takes a chest input of seed item   *
-- * pairs and automatically grows the item if the   *
-- * count of the item is less than the set value.   *
-- * 												 *
-- * 				By Ben Shabowski				 *
-- ***************************************************


require("../lib/PrintingLib")
local strings = require("cc.strings")

local screen = peripheral.wrap("monitor_0")
local barrel = peripheral.wrap("sophisticatedstorage:barrel_0")
local seedInput = peripheral.wrap("functionalstoreage:oak_1_0")
local network = peripheral.wrap("meBridge_1")

local data = "../data/data.txt"

--[[
    <item name>=<count to stop planting>
]]--
local items = {}

-- Handle the touch events
function handleTouch(x, y)

end

-- Handle updating the list of data from the barrel
function updateBarrelItems()


end

-- Gets an item from the ME system
function getItem(itemName)
    for index,item in pairs(network.listItems()) do
        if item.name == itemName then
            return item
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
		updateBarrelItems()
        sleep(1)
    end
end

parallel.waitForAll(listenTouch, listenTime)