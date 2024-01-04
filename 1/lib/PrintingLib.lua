--[[
    Screen size is 61 x 26
]]--

local strings = require("cc.strings")
local screen = peripheral.wrap("monitor_0")

local PAGE_ITEM_COUNT = 30

-- Shrinks large numbers
local function shrinkNumber(number)
    if number > 1000000 then
        return string.format("%.3fM", number/1000000)
    end
    return number
end

local function writeLine(line)
    screen.write(line)
    x,y = screen.getCursorPos()
    screen.setCursorPos(1,y+1)
end

local function writeItemLine(item)
    writeLine("| "..strings.ensure_width(item.."",22).." |")
end

--- Completly clears the screen
-- @param screen Screen peripheral
function resetScreen()
    screen.setTextScale(1)
    screen.setTextColor(0x1)
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
    		writeItemLine(items[item].displayName)
        else
            writeItemLine("")
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