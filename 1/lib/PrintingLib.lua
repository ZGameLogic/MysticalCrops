--[[
    Screen size is 61 x 26
]]--
local strings = require("cc.strings")
local screen = peripheral.wrap("monitor_0")

local PAGE_ITEM_COUNT = 20

--- Shrinks and formats large numbers
-- @param number
-- @returns Formatted number
local function formatNumber(number)
    if(number > 1000000000000) then
        return string.format("%.2fT", number/1000000000000)
    elseif(number > 1000000000) then
        return string.format("%.2fB", number/1000000000)
    elseif(number > 1000000) then
        return string.format("%.2fM", number/1000000)
    else
        return string.format("%d", number)
    end
end

local function writeLine(line)
    screen.write(line)
    x,y = screen.getCursorPos()
    screen.setCursorPos(1,y+1)
end

local function writeItemLine(item, color)
    screen.setTextColor(0x1)
    screen.write("| ")
    screen.setTextColor(color)
    screen.write(strings.ensure_width(item.displayName,22))
    writeLine("| "..strings.ensure_width(item.displayName,22))
    screen.setTextColor(0x1)
    screen.write(" | ")
    screen.setTextColor(color)
    screen.write(strings.ensure_width(formatNumber(item.count), 6))
    screen.setTextColor(0x1)
    screen.write(" |")
end

--- Completely clears the screen
-- @param screen Screen peripheral
function resetScreen()
    screen.setTextScale(1)
    screen.setTextColor(0x1)
    screen.setBackgroundColor(0x8000)
    for i=1,76 do
        screen.setCursorPos(1, i)
        screen.write("                                                                                                                     ")
    end
    screen.setCursorPos(1,1)
end

function printItemSection(items, indexedItems, growList, page)
    writeLine("| "..strings.ensure_width("Resource page:".. page,30).." |Threshold|")
    for i=(page-1)*PAGE_ITEM_COUNT+1,PAGE_ITEM_COUNT*page do
    	item = indexedItems[i]
    	if item then
            color = 0x1
            if growList[item] then
                color = 0x2000
            elseif(i%2==0) then
                color = 0x1
            else
                color = 0x100
            end
            writeItemLine(items[item], color)
        else
            writeItemLine("", 0x1)
    	end
    end
    writeLine("|================================|")
    writeLine("")
    writeLine("     < Page >      ")
end

return {
    resetScreen,
    printItemSection
}