local planter = peripheral.wrap("industrialforegoing:plant_sower_0")
local storage = peripheral.wrap("functionalstorage:storage_controller_1")

local t = {
    ["a"] = "c",
    ["b"] = "a",
    ["c"] = "b",
    ["d"] = "d",
    ["e"] = "e",
}

table.sort(t, function (a, b) return a[2] > b[2] end)

print(next(t))