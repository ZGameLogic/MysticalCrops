require("../lib/ItemLib")

local screen = peripheral.wrap("monitor_0")
local barrel = peripheral.wrap("sophisticatedstorage:barrel_0")
local seedInput = peripheral.wrap("functionalstoreage:oak_1_0")
local network = peripheral.wrap("meBridge_1")

local items = {["minecraft:iron_ingot"]=15}
local data = "/data/data.txt"

items = loadDataFile(data)

for index,item in pairs(items) do
	print(index)
	print(item)
end
print(isNeedBarrelUpdate(barrel, items))
if isNeedBarrelUpdate(barrel, items) then
	updateFromBarrel(barrel, data, items)
end

print(getAEItemCount(network, "minecraft:iron_ingot"))

--for index,item in pairs(barrel.list()) do
--    print(barrel.list()[index])
--	print(string.format("%s: %s", item.name, item.count))
--end

--for i=1,#barrel.list(),2 do
--	print("Seed: " ..  barrel.list()[i].name)
--	print("Item: " .. barrel.list()[i+1].name)
--end
