require("../lib/ItemLib")
require("../lib/PrintingLib")

local screen = peripheral.wrap("monitor_0")
local barrel = peripheral.wrap("sophisticatedstorage:barrel_0")
local seedInput = peripheral.wrap("functionalstoreage:oak_1_0")
local network = peripheral.wrap("meBridge_1")

local data = "/data/data.txt"
local items = loadDataFile(data)
local indexed = getIndexedItems(items)
local page = 1
local growList = getGrowList(network, barrel, items)

resetScreen()
printItemSection(items, indexed, growList, page)
print(screen.getSize())