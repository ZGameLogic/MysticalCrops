--[[
    Screen size is 61 x 26
]]--
require("../lib/ItemLib")

local strings = require("cc.strings")
local screen = peripheral.wrap("monitor_0")

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

--- Writes a line to the screen, and then puts the cursor on the first index of the next line
--- @param line string Line to write to screen
local function writeLine(line)
    screen.write(line)
    x,y = screen.getCursorPos()
    screen.setCursorPos(1,y+1)
end

--- Writes an item line to the screen
--- @param item string item display name
--- @param color Color color to make item text
local function writeItemLine(item, color)
    if item then
        screen.setTextColor(0x1)
        screen.write("| ")
        screen.setTextColor(color)
        screen.write(strings.ensure_width(item.displayName,22))
        screen.setTextColor(0x1)
        screen.write(" | ")
        screen.setTextColor(color)
        screen.write(strings.ensure_width(formatNumber(item.count), 7))
        screen.setTextColor(0x1)
        screen.write("+- |")
    else
        screen.setTextColor(0x1)
        screen.write("|")
        screen.write(strings.ensure_width("",24))
        screen.write("|")
        screen.write(strings.ensure_width("",11))
        screen.write("|")
    end
    x,y = screen.getCursorPos()
    screen.setCursorPos(1,y+1)
    end

--- Completely clears the screen
function resetScreen()
    screen.setTextScale(1)
    screen.setTextColor(0x1)
    screen.setBackgroundColor(0x8000)
    for i=1,26 do
        screen.setCursorPos(1, i)
        screen.write(strings.ensure_width("", 61))
    end
    screen.setCursorPos(1,1)
end

--- Prints the item section of the screen
--- @param items table Items table
--- @param growList table grow list of seeds for coloring
--- @param manualGrowList table manual grow list of seeds for coloring
--- @param page number Current page we are on
function printItemSection(items, growList, manualGrowList, page)
    screen.setCursorPos(1,1)
    writeLine("|====================================|")
    writeLine("| "..strings.ensure_width("Resource page:".. page,22).." |Threshold  |")
    writeLine("|------------------------|-----------|")
    for i=(page-1)*PAGE_ITEM_COUNT+1,PAGE_ITEM_COUNT*page do
    	item = items[i]
    	if item then
            color = 0x1
            if growListContainsItem(manualGrowList, item.name) then
                color = 0x2
            elseif growListContainsItem(growList, item.name) then
                color = 0x2000
            elseif((i-1)%2==0) then
                color = 0x1
            else
                color = 0x100
            end
            writeItemLine(item, color)
        else
            writeItemLine(nil, 0x1)
    	end
    end
    writeLine("|====================================|")
    if #items > PAGE_ITEM_COUNT then
        writeLine("       < Page "..page.." >")
    end
end

--- Draws the delta section to the screen
--- @param delta number Current delta
function drawDelta(delta)
    local x = 41
    local y = 1
    -- Clear current Delta
    for i=y,y+6 do
        screen.setCursorPos(x, i)
        screen.write("                ")
    end
    -- Draw new delta
    screen.setTextColor(0x1)
    screen.setCursorPos(x, y)
    screen.write("________________")
    screen.setCursorPos(x, y+1)
    screen.write("|    Delta     |")
    screen.setCursorPos(x, y+2)
    screen.write("|==============|")
    screen.setCursorPos(x, y+3)
    screen.write("| "..strings.ensure_width(delta.."",13).."|")
    screen.setCursorPos(x, y+4)
    screen.write("|==============|")
    screen.setCursorPos(x, y+5)
    screen.write("| ")
    if delta == 1 then
        screen.setTextColor(0x100)
    end
    screen.write("/10")
    screen.setTextColor(0x1)
    screen.write("  |  ")
    if delta >= DELTA_MAX then
        screen.setTextColor(0x100)
    end
    screen.write("*10")
    screen.setTextColor(0x1)
    screen.write("  |")
    screen.setCursorPos(x, y+6)
    screen.write("|==============|")
end

return {
    resetScreen,
    printItemSection,
    drawDelta
}